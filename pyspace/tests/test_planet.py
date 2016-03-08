from pyspace.planet import PlanetArray
from pyspace.utils import Vector
import unittest

class TestPlanetArray(unittest.TestCase):
    def setUp(self):
        pass

    def test_init_planet_array(self):
        try:
            pa = PlanetArray()
        except:
            self.fail("Initialization failed!")

if __name__ == "__main__":
    unittest.main()
