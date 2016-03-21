from pyspace.planet import PlanetArray
from pyspace.utils import get_planet_array
import unittest
import numpy

class TestPlanetArray(unittest.TestCase):
    def setUp(self):
        x, y, z = numpy.mgrid[0:1:0.04, 0:1:0.04, 0:1:0.04]
        self.x = x.ravel(); self.y = y.ravel(); self.z = z.ravel()

    def test_init_planet_array(self):
        try:
            pa = PlanetArray(x=self.x, y=self.y, z=self.z)

        except:
            self.fail("Planet array initialization failed!")

    def test_get_planet_array(self):
        try:
            pa = get_planet_array(x=self.x, y=self.y, z=self.z)

        except:
            self.fail("get_planet_array failed!")


if __name__ == "__main__":
    unittest.main()

