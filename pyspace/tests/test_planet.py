from pyspace.planet import PlanetArray
from pyspace.utils import Vector
import unittest

class TestPlanetArray(unittest.TestCase):
    def setUp(self):
        pass

    def test_init_planet_array(self):
        try:
            pa = PlanetArray(res_len=2)
            
            pos_sun = Vector(0, 0, 0)
            vel_sun = Vector(0, 0, 0)
        
            pos_planet = Vector(1000, 0, 0)
            vel_planet = Vector(0, 0, 0)
    
            pa.add_planet(mass=10**3, radius=5, init_pos=pos_sun, init_vel=vel_sun, planet_id=0)
            pa.add_planet(mass=1, radius=1, init_pos=pos_planet, init_vel=vel_planet, planet_id=1)
 
        except:
            self.fail("Planet array initialization failed!")

if __name__ == "__main__":
    unittest.main()

