# distutils: language = c++
from libcpp.vector cimport vector
from libc.math cimport floor
from pyspace.planet cimport PlanetArray

cdef extern from "numpy/arrayobject.h":
    ctypedef int intp
    ctypedef extern class numpy.ndarray [object PyArrayObject]:
        cdef char *data
        cdef int nd
        cdef intp *dimensions
        cdef intp *strides
        cdef int flags

cdef extern from "pyspace.h":
    cdef void update(double*, double*, double*, double*, double*, double*,
            double*, double*, double*, double*, double, double, int) nogil

cdef class Simulator:
    cdef PlanetArray planets

    cdef double G
    cdef double dt
    cdef int num_planets

    cdef void _get_final_state(self, double) nogil
    cpdef get_final_state(self, double)

