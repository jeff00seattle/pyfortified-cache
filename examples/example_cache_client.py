#!/usr/bin/env python3
# -*- coding: utf-8 -*-

import pyfortified_cache as pyf_cache
from pprintpp import pprint

request_params = {
            'user': 'john',
            'pass': 'john1234'
        }

request_url = 'http://www.someurl.com'
cache_group_name = 'some group'
client_unique_hash = '1414141'

cache_key = pyf_cache.create_cache_key(request_params, request_url, cache_group_name, client_unique_hash)
assert cache_key is not None
pprint(cache_key)
pprint(type(cache_key))


cache_name = 'cache_a'
cache_required = False
client_unique_hash = '1414141'

cache_client = pyf_cache.CacheClient(cache_name, cache_required, client_unique_hash)
assert cache_client is not None
pprint(cache_client)
pprint(type(cache_client))

cache_key = 'a5587ee0e950fb8d2677b17f54f75ad3'
cache_value = {
    'param1': 'text',
    'param2': {
        'p1': 123,
        'p2': 'xyz'
    }
}
cache_group_name = 'group_test'

cache_client.put(cache_key, cache_value, cache_group_name)

value, key = cache_client.get(cache_key=cache_key, cache_group_name=cache_group_name)
assert value == cache_value and key == cache_key
pprint(value)
pprint(type(value))
pprint(key)
pprint(type(key))



test_cache_value = {"user": "john", "pass": 'doe'}
cache_client = pyf_cache.CacheClient(cache_name='cache_cc')

# Put a value
cache_client.put(cache_key, test_cache_value, cache_group_name)

# Should be able to get the value
value, key = cache_client.get(cache_key=cache_key, cache_group_name=cache_group_name)
assert value == test_cache_value and key == cache_key

local_only = False

# Delete the value, when getting should have a None
cache_client.delete(cache_key, cache_group_name, local_only)
value, key = cache_client.get(cache_key, cache_group_name, local_only)
assert value is None


local_only = True

# Delete the value, when getting should have a None
cache_client.delete(cache_key, cache_group_name, local_only)
value, key = cache_client.get(cache_key, cache_group_name, local_only)
assert value is None