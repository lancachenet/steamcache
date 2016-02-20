import argparse
import HTMLParser
import logging
import os
import os.path
import re
import sqlite3
import sys
import time

try:
    import requests
except ImportError:
    requests = None
    print 'Please install requests (pip install requests[security])!'
    sys.exit(1)

PATTERN_LOG_LINE = re.compile(r'.*/depot/(\d+)/.* (LOCAL|REMOTE|OTHER)')
COLOURS = {
    'LOCAL': '\033[32m',
    'REMOTE': '\033[31m',
    'OTHER': '\033[33m',
    'off': '\033[39m',
}
STEAMDB_INFO = 'https://steamdb.info/depot/{depot}/'
PATTERN_DEPOT_NAME = re.compile(r'<h1[^>]*header-title">(.+)</h1>')


class SteamCacheLogWatcher(object):
    def __init__(self, path_logs, path_name_cache):
        self.log = logging.getLogger(self.__class__.__name__)

        self.path_logs = path_logs
        self.path_name_cache = (
            path_name_cache or
            os.path.expanduser('~/.cache/steamcache/')
        )
        self._names = {}
        self._htmlparser = HTMLParser.HTMLParser()

        self.access_log_path = os.path.join(self.path_logs, 'access.log')
        self.cache_db_path = os.path.join(self.path_name_cache, 'cache.db')

        try:
            os.makedirs(self.path_name_cache)
        except OSError:
            pass

        try:
            self.con = sqlite3.connect(self.cache_db_path)
            self.load_name_cache()
        except:
            self.con = None
            self.log.exception(
                'Failed to open cache database at %s',
                self.cache_db_path
            )

    def _create_name_cache(self):
        try:
            cur = self.con.cursor()
            cur.execute('''
                CREATE TABLE depots (id int PRIMARY KEY, depot_name VARCHAR);
            ''')
            self.con.commit()
        except sqlite3.OperationalError:
            pass

    def load_name_cache(self):
        self.log.debug('Loading depot names from cache')

        if not self.con:
            return

        self._create_name_cache()

        cur = self.con.cursor()
        cur.execute('SELECT id, depot_name FROM depots ORDER BY depot_name')
        for depot, name in cur.fetchall():
            self.log.debug('%d - %s', depot, name)
            self._names[depot] = name

    def save_name_to_cache(self, depot, name):
        if not self.con:
            return

        try:
            self.log.debug('Saving depot %d - %s to cache', depot, name)

            cur = self.con.cursor()
            cur.execute(
                'INSERT INTO depots (id, depot_name) VALUES (?, ?)',
                (depot, name)
            )
            self.con.commit()
        except sqlite3.Error:
            self.log.exception('Failed to save %d: %r to cache', depot, name)

    def get_name(self, depot):
        name = self._names.get(depot, None)
        if name:
            return name

        try:
            r = requests.get(STEAMDB_INFO.format(depot=depot), timeout=5)
            m = PATTERN_DEPOT_NAME.findall(r.text)[0]
            m = self._htmlparser.unescape(m)
            self._names[depot] = m
            self.save_name_to_cache(depot, m)
            return m
        except:
            self.log.exception('Failed to get name for depot %d', depot)

    def run(self):
        log = open(self.access_log_path, 'r')
        log.seek(0, 2)

        while True:
            b = log.read()

            if not b:
                time.sleep(0.008)
                continue

            while b.endswith('\n'):
                l, b = b.split('\n', 1)

                l = l.strip()

                depot = ''
                name = ''
                source = 'OTHER'

                # Faster check for whether we need to care about this line
                if '/depot/' in l:
                    m = PATTERN_LOG_LINE.match(l)
                    if not m:
                        continue

                    depot, source = m.groups()
                    depot = int(depot)
                    name = self.get_name(depot) or 'Unknown'
                    if len(name) >= 37:
                        name = name[:37] + '...'

                print u'{colour}{depot:>9} {name:40} {line}{off}'.format(
                    depot=depot,
                    name=name,
                    line=l,
                    colour=COLOURS[source],
                    off=COLOURS['off']
                )


if __name__ == '__main__':
    logging.getLogger('SteamCacheLogWatcher').addHandler(logging.NullHandler())

    parser = argparse.ArgumentParser()
    parser.add_argument(
        'log_path',
        type=str,
        help='path to the folder that contains access.log'
    )
    parser.add_argument(
        'db_path',
        type=str,
        default=None,
        help='path to where to store depot name cache data'
    )
    parser.add_argument(
        '--verbose',
        '-v',
        dest='verbosity',
        action='count',
        help='verbosity (use multiple times to increase verbosity)'
    )
    args = parser.parse_args()

    if args.verbosity > 0:
        level = max(1, 6 - args.verbosity) * 10
        logging.basicConfig(level=level)

    sclw = SteamCacheLogWatcher(args.log_path, args.db_path)
    try:
        sclw.run()
    except KeyboardInterrupt:
        pass
