# distutils: language = c++
cimport cython
import os
from pyspace.utils import dump_vtk

cdef class Simulator:
    def __init__(self, PlanetArray pa, double G, double dt, str sim_name = ""):
        self.planets = pa
        self.G = G
        self.dt = dt
        self.sim_name = sim_name

        self.x_ptr = <double*> self.planets.x.data
        self.y_ptr = <double*> self.planets.y.data
        self.z_ptr = <double*> self.planets.z.data

        self.v_x_ptr = <double*> self.planets.v_x.data
        self.v_y_ptr = <double*> self.planets.v_y.data
        self.v_z_ptr = <double*> self.planets.v_z.data

        self.a_x_ptr = <double*> self.planets.a_x.data
        self.a_y_ptr = <double*> self.planets.a_y.data
        self.a_z_ptr = <double*> self.planets.a_z.data

        self.m_ptr = <double*> self.planets.m.data

        self.num_planets = pa.get_number_of_planets()

    cpdef simulate(self, double total_time, bint dump_output = False):
        """Implement this in derived classes to get final state"""
        raise NotImplementedError("Simulator::simulate called")

cdef class BruteForceSimulator(Simulator):
    """Simulator using Brute Force algorithm"""
    def __cinit__(self, PlanetArray pa, double G, double dt, str sim_name = ""):
        """Constructor for BruteForceSimulator

        Parameters
        ----------

        pa: PlanetArray
            Planet array for simulation

        G: double
            Universal Gravitational constant

        dt: double
            Time step for simulation

        Notes
        -----

        Uses brute force for simulation

        """
        Simulator.__init__(self, pa, G, dt, sim_name)

    @cython.cdivision(True)
    cdef void _simulate(self, double total_time, bint dump_output = False):

        cdef double G = self.G
        cdef double dt = self.dt

        cdef int n_steps = <int> floor(total_time/dt)
        cdef int i

        for i from 0<=i<n_steps:
            brute_force_update(self.x_ptr, self.y_ptr, self.z_ptr,
                    self.v_x_ptr, self.v_y_ptr, self.v_z_ptr,
                    self.a_x_ptr, self.a_y_ptr, self.a_z_ptr,
                    self.m_ptr, G, dt, self.num_planets)
            if dump_output:
                dump_vtk(self.planets, self.sim_name + str(i), self.sim_name)

    cpdef simulate(self, double total_time, bint dump_output = False):
        """Calculates position and velocity of all particles
        after time 'total_time'

        Parameters
        ----------

        total_time: double
            Total time for simulation

        """
        if dump_output and (not os.path.isdir(self.sim_name)):
            os.mkdir(self.sim_name)

        self._simulate(total_time, dump_output)


