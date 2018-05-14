#!/usr/bin/env python3
# -*- coding: utf-8 -*-

from pymemcache.client.hash import HashClient
from pprintpp import pprint
import socket

host = socket.gethostbyname("localhost")

client = HashClient([
    (host, 11211),
    (host, 11212)
])

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