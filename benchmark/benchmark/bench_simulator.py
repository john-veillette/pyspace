#!usr/bin/env python
from pyspace.simulator import BarnesSimulator, BruteForceSimulator
from benchmark import Benchmark

class BruteForce(Benchmark):
    def __init__(self):
        Benchmark.__init__(self)

    def time_simulate(self):
        """Time BruteForceSimulator.simulate"""
        sim = BruteForceSimulator(self.pa, 1, 1, sim_name = "square_grid")
        sim.simulate(10, dump_output = False)

class BarnesHut(Benchmark):
    def __init__(self):
        Benchmark.__init__(self)

    def time_simulate(self):
        """Time BarnesSimulator.simulate"""
        sim = BarnesSimulator(self.pa, 1, 1, 0, sim_name = "square_grid")
        sim.simulate(10, dump_output = False)

