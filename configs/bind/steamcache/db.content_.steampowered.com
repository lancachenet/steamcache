$TTL	600
@		IN	SOA	ns1 dns.steamcache.net. (
			2015040800
			604800
			600
			600
			600 )
@		IN	NS	ns1
ns1		IN	A	{{ steamcache_ip }}

@		IN	A	{{ steamcache_ip }}
