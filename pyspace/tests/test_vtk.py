from pyspace.utils import dump_vtk
import numpy
from pyspace.planet import PlanetArray
from pyspace.simulator import BruteForceSimulator
import unittest

class TestVTK(unittest.TestCase):
    def setUp(self):
        x, y, z = numpy.mgrid[0:1:0.04, 0:1:0.04, 0:1:0.04]
        self.x = x.ravel(); self.y = y.ravel(); self.z = z.ravel()
        self.pa = PlanetArray(x=self.x, y=self.y, z=self.z)

    def test_vtk_dump(self):
        dump_vtk(self.pa, "points")

    def test_simulator_custom_vtk_dump(self):
        sim = BruteForceSimulator(self.pa, G = 1, dt = 1, sim_name = "test_vtk")
        sim.set_data(a_x = 'a_x')
        sim.simulate(1, dump_output = True)

