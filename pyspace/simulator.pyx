# distutils: language = c++
cimport cython

cdef class Simulator:
    def __init__(self, PlanetArray pa, double G, double dt):
        self.planets = pa
        self.G = G
        self.dt = dt

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

    cpdef get_final_state(self, double total_time):
        """Implement this in derived classes to get final state"""
        raise NotImplementedError("Simulator::get_final_state called")

cdef class BruteForceSimulator(Simulator):
    """Simulator using Brute Force algorithm"""
    def __cinit__(self, PlanetArray pa, double G, double dt):
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
        Simulator.__init__(self, pa, G, dt)

    @cython.cdivision(True)
    cdef void _get_final_state(self, double total_time) nogil:

        cdef double G = self.G
        cdef double dt = self.dt

        cdef int n_steps = <int> floor(total_time/dt)
        cdef int i

        for i from 0<=i<n_steps:
            brute_force_update(self.x_ptr, self.y_ptr, self.z_ptr,
                    self.v_x_ptr, self.v_y_ptr, self.v_z_ptr,
                    self.a_x_ptr, self.a_y_ptr, self.a_z_ptr,
                    self.m_ptr, G, dt, self.num_planets)

    cpdef get_final_state(self, double total_time):
        """Calculates position and velocity of all particles
        after time 'total_time'

        Parameters
        ----------

        total_time: double
            Total time for simulation

        """
        self._get_final_state(total_time)


