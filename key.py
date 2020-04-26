#!/usr/bin/env python3
# -*- coding: utf-8 -*-

from cryptography.fernet import Fernet
key = Fernet.generate_key()
print(key.decode())

