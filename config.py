#!/usr/bin/env python3
# -*- coding: utf-8 -*-

import re
from configparser import RawConfigParser
from cryptography.fernet import Fernet
from os.path import expanduser, exists
from secrets import choice
from sys import argv
from string import ascii_letters, digits


def generate_password() -> str:
    return "".join(choice(ascii_letters + digits + "!@#$%^&*-+") for _ in range(16))


def generate_key() -> str:
    return Fernet.generate_key().decode()


def main() -> bool:
    result = False

    try:
        # Print welcome message
        print("\nRunning config.py...\n")

        # Init
        default = "[DATA EXPUNGED]"
        replace_dict = {}

        # Get bot
        bot = argv[1]
        path = expanduser(f"~/scp-079/{bot}/config.ini")

        # Check the file
        if not exists(path):
            print(f"Config file {path} does not exist!")
            return False

        # Get global config
        global_path = expanduser(f"~/scp-079/scripts/config.ini")

        # Check the global file
        if not exists(global_path):
            print(f"[ERROR] Global config file {global_path} does not exist!")
            return False

        # Get bot's config
        config = RawConfigParser()
        config.read(path)

        # Get global config
        global_config = RawConfigParser()
        global_config.read(global_path)

        # Check values
        for section in config:
            if not global_config.has_section(section):
                global_config[section] = {}

            for key in config[section]:
                if config[section][key] != default:
                    if global_config[section].get(key, default) == default:
                        global_config[section][key] = config[section][key]
                    continue

                if global_config[section].get(key, default) == default:
                    if key not in {"key", "password"}:
                        value = ""
                        while not value:
                            value = input(f"Please input the value of [{section}] {key}: ")
                    elif key == "key":
                        value = generate_key()
                    elif key == "password":
                        value = generate_password()
                    else:
                        value = "[DATA EXPUNGED]"
                else:
                    value = global_config[section][key]

                replace_dict[key] = value
                global_config[section][key] = value

        # Get bot config.ini as text
        with open(path, "r", encoding="utf-8") as f:
            config_text = f.read()

        # Replace
        for key in replace_dict:
            pattern = fr"{key}.?=.?\[DATA EXPUNGED\]"
            replacement = f"{key} = {replace_dict[key]}"
            config_text = re.sub(pattern, replacement, config_text)

        # Write bot config.ini
        with open(path, "w") as f:
            f.write(config_text)

        # Write global config.ini
        with open(global_path, "w") as f:
            global_config.write(f)

        # Print goodbye message
        print("\nDone config.py!")

        result = True
    except Exception as e:
        print(f"[ERROR] {e}")

    return result


if __name__ == "__main__":
    main()
