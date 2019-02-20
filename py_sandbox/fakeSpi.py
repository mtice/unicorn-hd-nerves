#!/usr/bin/env python
import logging

class FakeSpi:

    def __init__(self):
        self._something = 'something'
        self.max_speed_hz = 9000000

    def xfer2(self, someHugeBullshitThing):
        logging.error('>> FakeSpi.xfer2(input): ')
        logging.error(someHugeBullshitThing)

