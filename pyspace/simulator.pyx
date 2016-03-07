# distutils: language = c++
cimport cython

cdef class Simulator:
    def __cinit__(self, PlanetArray arr, Config conf):
        self._eng = new Engine(&arr.obj_list, &conf.cfg)

    cpdef update(self):
        self._eng.update()

    @cython.cdivision(True)
    cdef void _get_final_state(self, double total_time) nogil:
        cdef double dt = self._eng.config.step_size
        cdef int n_steps = <int> floor(total_time/dt)
        cdef int i
        for i from 0<=i<n_steps:
            self._eng.update()

    cpdef get_final_state(self, double total_time):
        """Calculates position and velocity of all particles
        after time 'total_time'
        """
        self._start_simulation(total_time)

    def __dealloc__(self):
        del self._eng

