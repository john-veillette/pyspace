from pyspace.simulator import BruteForceSimulator
from pyspace.planet import PlanetArray
import numpy
import unittest

class TestBruteForceSimulator(unittest.TestCase):
    def setUp(self):
        x, y, z = numpy.mgrid[0:1:0.04, 0:1:0.04, 0:1:0.04]
        self.x = x.ravel(); self.y = y.ravel(); self.z = z.ravel()

        self.pa = PlanetArray(x=self.x, y=self.y, z=self.z)

    def test_simulator_init(self):
        try:
            sim = BruteForceSimulator(self.pa, 100, 1)
        except:
            self.fail("Simulator initialization failed!")

    def test_get_final_state(self):
        sim = BruteForceSimulator(self.pa, 100, 1)

        try:
            sim.get_final_state(1)
        except:
            self.fail("get_final_state() failed!")

if __name__ == "__main__":
    unittest.main()

