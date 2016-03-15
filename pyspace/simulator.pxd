# distutils: language = c++
from libcpp.vector cimport vector
from libc.math cimport floor
from pyspace.planet cimport PlanetArray

cdef extern from "pyspace.h":
    cdef void update(double*, double*, double*, double*, double*, double*,
            double*, double*, double*, double*, double, double, int) nogil

cdef class Simulator:
    cdef PlanetArray pa_wrapper

    cdef double* x
    cdef double* y
    cdef double* z

    cdef double* v_x
    cdef double* v_y
    cdef double* v_z

    cdef double* a_x
    cdef double* a_y
    cdef double* a_z

    cdef double* m

    cdef double G
    cdef double dt
    cdef int num_planets

    cdef void _get_final_state(self, double) nogil
    cpdef get_final_state(self, double)

