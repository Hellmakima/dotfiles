# checks for changes in clipboard nad sends keystrokes after 3 seconds. runs at 1Hz

import time
import pyperclip
from pynput.keyboard import Controller, Key

keyboard = Controller()

last_clipboard = pyperclip.paste()

while True:
    current = pyperclip.paste()

    if current != last_clipboard:
        time.sleep(3)  # wait before typing

        for ch in current:
            keyboard.type(ch)
            if ch == '\n':
                keyboard.press(Key.ctrl)
                keyboard.press(Key.backspace)
                keyboard.release(Key.backspace)
                keyboard.release(Key.ctrl)

        last_clipboard = current

    time.sleep(1)