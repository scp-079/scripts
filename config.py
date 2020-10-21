#!/usr/bin/env python3
# -*- coding: utf-8 -*-

import logging
from configparser import RawConfigParser
from cryptography.fernet import Fernet
from os.path import expanduser, exists
from secrets import choice
from sys import argv
from string import ascii_letters, digits
from typing import Optional

# Path variables
CONFIG_PATH = "data/config/config.ini"

# Enable logging
logging.basicConfig(
    format="%(asctime)s - %(name)s - %(levelname)s - %(message)s",
    level=logging.WARNING,
    filename="log",
    filemode="a"
)
logger = logging.getLogger(__name__)


def check_value(section: str, key: str, value: str, global_config: bool = False) -> bool:
    # Check the value
    result = False

    try:
        if global_config:
            prefix = " [global] "
        else:
            prefix = " "

        if section == "bots":
            return check_bots(key, value, prefix)

        if section == "channels":
            return check_channels(key, value, prefix)

        result = True
    except Exception as e:
        logger.warning(f"Check value error: {e}", exc_info=True)

    return result


def check_bots(key: str, value: str, prefix: str) -> bool:
    # Check the value in bots section
    result = False

    try:
        value = get_int(value)

        if not value or value <= 0:
            print(f"[ERROR]{prefix}[bots] {key} - should be a positive integer")
            return False

        result = True
    except Exception as e:
        logger.warning(f"Check bots error: {e}", exc_info=True)

    return result


def check_channels(key: str, value: str, prefix: str) -> bool:
    # Check the value in channels section
    result = False

    try:
        value = get_int(value)

        if not value or value >= 0:
            print(f"[ERROR]{prefix}[channels] {key} - should be a negative integer")
            return False

        if key.endswith("channel_id") and not str(value).startswith("-100"):
            print(f"[ERROR]{prefix}[channels] {key} - please use a channel instead")
            return False

        if not str(value).startswith("-100"):
            print(f"[ERROR]{prefix}[channels] {key} - please use a supergroup instead")
            return False

        result = True
    except Exception as e:
        logger.warning(f"Check channels error: {e}", exc_info=True)

    return result


def generate_password() -> str:
    # Generate a random password
    return "".join(choice(ascii_letters + digits + "!@#$%^&*-+") for _ in range(16))


def generate_key() -> str:
    # Generate a required key
    return Fernet.generate_key().decode()


def get_input(section: str, key: str) -> str:
    # Get input value
    result = "[DATA EXPUNGED]"

    try:
        while not result or result == "[DATA EXPUNGED]" or not check_value(section, key, result):
            result = input(f"Please input [{section}] {key}: ")
    except Exception as e:
        logger.warning(f"Get input error: {e}", exc_info=True)

    return result


def get_int(text: str) -> Optional[int]:
    # Get a int from a string
    result = None

    try:
        result = int(text)
    except Exception as e:
        logger.info(f"Get int error: {e}", exc_info=True)

    return result


def get_value(section: str, key: str) -> str:
    # Get key's value
    result = "[DATA EXPUNGED]"

    try:
        if key not in {"key", "password"}:
            return get_input(section, key)

        if key == "key":
            return generate_key()

        if key == "password":
            return generate_password()
    except Exception as e:
        logger.warning(f"Get value error: {e}", exc_info=True)

    return result


def main() -> bool:
    # Main function
    result = False

    try:
        # Print welcome message
        print("\nRunning config.py...\n")

        # Init
        default = "[DATA EXPUNGED]"
        replace_dict = {}

        # Get bot
        bot = argv[1]

        # TODO TEMP
        if exists(f"~/scp-079/{bot}/examples/config.ini"):
            CONFIG_PATH = "data/config/config.ini"
        else:
            CONFIG_PATH = "config.ini"

        # Get bot config path
        path = expanduser(f"~/scp-079/{bot}/{CONFIG_PATH}")

        # Check the bot file
        if not exists(path):
            print(f"Config file {path} does not exist!")
            return False

        # Get global config path
        global_path = expanduser(f"~/scp-079/scripts/config.ini")

        # Check the global file
        if not exists(global_path):
            print(f"[ERROR] Global config file {global_path} does not exist!")
            return False

        # Get the bot's config
        config = RawConfigParser()
        config.read(path)

        # Get global config
        global_config = RawConfigParser()
        global_config.read(global_path)

        # Check values
        for section in config:
            # Append new section in global config
            if not global_config.has_section(section):
                global_config[section] = {}

            # Check keys
            for key in config[section]:
                # Bot's config.ini has default value
                if config[section][key] != default:
                    if global_config[section].get(key, default) == default:
                        global_config[section][key] = config[section][key]
                    continue

                # Global config.ini doesn't have default value
                if global_config[section].get(key, default) == default:
                    value = get_value(section, key)
                elif key == "bot_token":
                    value = get_input(section, key)
                elif check_value(section, key, global_config[section][key], True):
                    value = global_config[section][key]
                else:
                    value = get_input(section, key)

                replace_dict[key] = value
                global_config[section][key] = value

        # Get bot config.ini as text
        with open(path, "r", encoding="utf-8") as f:
            config_text = f.read()

        # Replace
        for key in replace_dict:
            old = f"{key} = [DATA EXPUNGED]"
            new = f"{key} = {replace_dict[key]}"
            config_text = config_text.replace(old, new)

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
        print(f"[ERROR] please check the log file ~/scp-079/scripts/log")
        logger.warning(f"Main error: {e}", exc_info=True)

    return result


if __name__ == "__main__":
    main()
