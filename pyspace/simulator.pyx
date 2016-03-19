# distutils: language = c++
cimport cython

cdef class Simulator:
    def __cinit__(self, PlanetArray pa, double G, double dt):
        self.planets = pa
        self.G = G
        self.dt = dt
        self.num_planets = pa.get_number_of_planets()

    @cython.cdivision(True)
    cdef void _get_final_state(self, double total_time) nogil:

        cdef double* x_ptr = <double*> self.planets.x.data
        cdef double* y_ptr = <double*> self.planets.y.data
        cdef double* z_ptr = <double*> self.planets.z.data

        cdef double* v_x_ptr = <double*> self.planets.v_x.data
        cdef double* v_y_ptr = <double*> self.planets.v_y.data
        cdef double* v_z_ptr = <double*> self.planets.v_z.data

        cdef double* a_x_ptr = <double*> self.planets.a_x.data
        cdef double* a_y_ptr = <double*> self.planets.a_y.data
        cdef double* a_z_ptr = <double*> self.planets.a_z.data

        cdef double* m_ptr = <double*> self.planets.m.data

        cdef double G = self.G
        cdef double dt = self.dt

        cdef int n_steps = <int> floor(total_time/dt)
        cdef int i

        for i from 0<=i<n_steps:
            update( x_ptr, y_ptr, z_ptr,
                    v_x_ptr, v_y_ptr, v_z_ptr,
                    a_x_ptr, a_y_ptr, a_z_ptr,
                    m_ptr, G, dt, self.num_planets)

    cpdef get_final_state(self, double total_time):
        """Calculates position and velocity of all particles
        after time 'total_time'
        """
        self._get_final_state(total_time)

