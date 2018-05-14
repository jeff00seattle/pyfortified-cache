#!/usr/bin/env python3
# -*- coding: utf-8 -*-

import os
import sys
from pprintpp import pprint
import socket

from pymemcache_client import (
    PymemcacheClient
)

host = socket.gethostbyname("localhost")

def example_pymemcache_client_none():
    function_name = sys._getframe().f_code.co_name
    pprint("^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^")
    pprint(function_name)
    pprint("^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^")

    pymemcache_client = PymemcacheClient(config=None)
    pprint("Pymemcache Config: {0}".format(dict(pymemcache_client.config)))
    pprint("Pymemcache Servers: {0}".format(pymemcache_client.memcached_servers))
    pprint("CacheClient Client: {0}".format(vars(pymemcache_client.cache_client)))

    pprint("CacheClient Client Type: {0}".format(type(pymemcache_client.cache_client)))

    try:
        pymemcache_client.cache_client.set('some_key', 'some_value')
    except ConnectionRefusedError as ex:
        print("ConnectionRefusedError: {0}".format(ex))
    except Exception as ex:
        print("Exception: {0}".format(ex))

    result = pymemcache_client.cache_client.get('some_key')
    pprint(result)


def example_pymemcache_client_basic():
    function_name = sys._getframe().f_code.co_name
    pprint("^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^")
    pprint(function_name)
    pprint("^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^")

    config = {
        "servers": [{"host": "localhost", "port": 11211}],
        "client_type": "basic"
    }

    pymemcache_client = PymemcacheClient(config=config)
    pprint("Pymemcache Config: {0}".format(dict(pymemcache_client.config)))
    pprint("Pymemcache Servers: {0}".format(pymemcache_client.memcached_servers))
    pprint("CacheClient Client: {0}".format(vars(pymemcache_client.cache_client)))

    pprint("CacheClient Client Type: {0}".format(type(pymemcache_client.cache_client)))

    try:
        pymemcache_client.cache_client.set('some_key', 'some_value')
    except ConnectionRefusedError as ex:
        print("ConnectionRefusedError: {0}".format(ex))
    except Exception as ex:
        print("Exception: {0}".format(ex))

    result = pymemcache_client.cache_client.get('some_key')
    pprint(result)


def example_pymemcache_client_hash():
    function_name = sys._getframe().f_code.co_name
    pprint("^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^")
    pprint(function_name)
    pprint("^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^")

    config = {
        "servers": [{"host": "localhost", "port": 11211}],
        "client_type": "hash"
    }

    pymemcache_client = PymemcacheClient(config=config)
    pprint("Pymemcache Config: {0}".format(dict(pymemcache_client.config)))
    pprint("Pymemcache Servers: {0}".format(pymemcache_client.memcached_servers))
    pprint("CacheClient Client: {0}".format(vars(pymemcache_client.cache_client)))

    pprint("CacheClient Client Type: {0}".format(type(pymemcache_client.cache_client)))

    try:
        pymemcache_client.cache_client.set('some_key', 'some_value')
    except ConnectionRefusedError as ex:
        print("ConnectionRefusedError: {0}".format(ex))
    except Exception as ex:
        print("Exception: {0}".format(ex))

    result = pymemcache_client.cache_client.get('some_key')
    pprint(result)


def example_pymemcache_client_file():
    function_name = sys._getframe().f_code.co_name
    pprint("^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^")
    pprint(function_name)
    pprint("^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^")

    full_path = os.path.realpath(__file__)
    path = os.path.dirname(full_path)
    config_file = "{}/resources/example_pymemcache.json".format(path)

    pymemcache_client = PymemcacheClient(config_file=config_file)
    pprint("Pymemcache Config: {0}".format(dict(pymemcache_client.config)))
    pprint("Pymemcache Servers: {0}".format(pymemcache_client.memcached_servers))
    pprint("CacheClient Client: {0}".format(vars(pymemcache_client.cache_client)))

    pprint("CacheClient Client Type: {0}".format(type(pymemcache_client.cache_client)))

    try:
        pymemcache_client.cache_client.set('some_key', 'some_value')
    except ConnectionRefusedError as ex:
        print("ConnectionRefusedError: {0}".format(ex))
    except Exception as ex:
        print("Exception: {0}".format(ex))

    result = pymemcache_client.cache_client.get('some_key')
    pprint(result)



def main():
    example_pymemcache_client_none()
    example_pymemcache_client_basic()
    example_pymemcache_client_hash()
    example_pymemcache_client_file()


if __name__ == '__main__':
    sys.exit(main())
