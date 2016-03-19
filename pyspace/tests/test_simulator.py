from pyspace.simulator import Simulator
from pyspace.planet import PlanetArray
import numpy
import unittest

class TestSimulator(unittest.TestCase):
    def setUp(self):
        pass

    def test_simulator_init(self):
        x, y, z = numpy.mgrid[0:1:0.04, 0:1:0.04, 0:1:0.04]
        x = x.ravel(); y = y.ravel(); z = z.ravel()

        pa = PlanetArray(x=x, y=y, z=z)

        try:
            sim = Simulator(pa, 100, 1)
        except:
            self.fail("Simulator initialization failed!")

if __name__ == "__main__":
    unittest.main()

