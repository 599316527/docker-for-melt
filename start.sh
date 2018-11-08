#!/bin/sh
Xvfb :99 -screen 0 1280x768x24 -nolisten tcp &
DISPLAY=:99 qmelt $@

