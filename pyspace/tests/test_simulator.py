from pyspace.simulator import Simulator
from pyspace.utils import Config
from pyspace.planet import PlanetArray
from pyspace.utils import Vector
import unittest

class TestSimulator(unittest.TestCase):
    def setUp(self):
        pass

    def test_simulator_init(self):
        pa = PlanetArray(res_len=2)
        conf = Config(G=1, dt = 0.1)
        
        pos_sun = Vector(0, 0, 0)
        vel_sun = Vector(0, 0, 0)
            
        pos_planet = Vector(1000, 0, 0)
        vel_planet = Vector(0, 0, 0)
    
        pa.add_planet(mass=10**3, radius=5, init_pos=pos_sun, init_vel=vel_sun, planet_id=0)
        pa.add_planet(mass=1, radius=1, init_pos=pos_planet, init_vel=vel_planet, planet_id=1)
            
        try:
            sim = Simulator(pa, conf)
        except:
            self.fail("Simulator initialization failed!")

if __name__ == "__main__":
    unittest.main()

