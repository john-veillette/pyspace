#!usr/bin/env python
from pyspace.planet import PlanetArray
from pyspace.simulator import BarnesSimulator
import numpy

x, y, z = numpy.mgrid[0:500:5j, 0:500:5j, 0:500:5j]
x = x.ravel(); y = y.ravel(); z = z.ravel()

pa = PlanetArray(x, y, z)

initial_time = time()
sim =BarnesSimulator(pa, 1, 1, 0.1, "square_grid")

sim.simulate(1000, dump_output = True)

