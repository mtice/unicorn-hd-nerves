#!/usr/bin/env python

import time
import unicornhathd
# @spec render() :: :ok
#   def render, do: GenServer.call(HAL, :render)
while True:
    for rotation in [0, 90, 180, 270]:
        print('Showing lines at rotation: {}'.format(rotation))

        unicornhathd.clear()
        unicornhathd.rotation(rotation)
        unicornhathd.set_pixel(0, 0, 64, 64, 64)
        print('R G B ALL 64: {}'.format(rotation))
        unicornhathd.show()
        time.sleep(5.0)

        for x in range(1, 16):
            unicornhathd.set_pixel(x, 0, 255, 0, 0)
            print('HORIZINTAL CHANGE: {}'.format(rotation))
            unicornhathd.show()
            time.sleep(0.5 / 16)

        time.sleep(5.0)

        for y in range(1, 16):
            unicornhathd.set_pixel(0, y, 0, 0, 255)
            print('VERTICAL CHANGE: {}'.format(rotation))
            unicornhathd.show()
            time.sleep(0.5 / 16)

        time.sleep(5.0)

        for b in range(1, 16):
            unicornhathd.set_pixel(b, b, 0, 255, 0)
            print('G CHANGE: {}'.format(rotation))
            unicornhathd.show()
            time.sleep(0.5 / 16)

        time.sleep(5.0)
