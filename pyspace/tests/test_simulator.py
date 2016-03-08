from pyspace.simulator import Simulator
from pyspace.utils import Config
from pyspace.planet import PlanetArray
import unittest

class TestSimulator(unittest.TestCase):
    def setUp(self):
        pass

    def test_simulator_init(self):
        pa = PlanetArray()
        conf = Config()
        try:
            sim = Simulator(pa, conf)
        except:
            self.fail("Initialization failed!")

if __name__ == "__main__":
    unittest.main()
