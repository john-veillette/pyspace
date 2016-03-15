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

        cdef double* x_ptr = <double*> self.pa.x.data
        cdef double* y_ptr = <double*> self.pa.y.data
        cdef double* z_ptr = <double*> self.pa.z.data

        cdef double* v_x_ptr = <double*> self.pa.v_x.data
        cdef double* v_y_ptr = <double*> self.pa.v_y.data
        cdef double* v_z_ptr = <double*> self.pa.v_z.data

        cdef double* a_x_ptr = <double*> self.pa.a_x.data
        cdef double* a_y_ptr = <double*> self.pa.a_y.data
        cdef double* a_z_ptr = <double*> self.pa.a_z.data

        cdef double* m_ptr = <double*> self.pa.m.data


        cdef double G = self.G
        cdef double dt = self.dt

        cdef int n_steps = <int> floor(total_time/dt)
        cdef int i

        for i from 0<=i<n_steps:
            update(self.x, self.y, self.z,
                    self.v_x, self.v_y, self.v_z,
                    self.a_x, self.a_y, self.a_z,
                    self.m, G, dt, self.num_planets)

    cpdef get_final_state(self, double total_time):
        """Calculates position and velocity of all particles
        after time 'total_time'
        """
        self._get_final_state(total_time)

