#!/usr/bin/env python3
# -*- coding: utf-8 -*-

from pymemcache.client.base import Client
from pprintpp import pprint
import socket

host = socket.gethostbyname("localhost")

# setup Memcached client running under 11211 port on localhost
client = Client((host, 11211))

pprint(type(client))

# cache some value under some key and expire it after 10 seconds
try:
    client.set('some_key', 'some_value', expire=10)
except ConnectionRefusedError as ex:
    print("ConnectionRefusedError: {0}".format(ex))
except Exception as ex:
    print("Exception: {0}".format(ex))

# retrieve value for the same key
result = client.get('some_key')
pprint(result)