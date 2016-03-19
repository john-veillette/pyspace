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
    cdef void brute_force_update(double*, double*, double*,
            double*, double*, double*,
            double*, double*, double*,
            double*, double, double, int) nogil

cdef class Simulator:
    cdef PlanetArray planets

    cdef double G
    cdef double dt
    cdef int num_planets

    cdef double* x_ptr
    cdef double* y_ptr
    cdef double* z_ptr

    cdef double* v_x_ptr
    cdef double* v_y_ptr
    cdef double* v_z_ptr

    cdef double* a_x_ptr
    cdef double* a_y_ptr
    cdef double* a_z_ptr

    cdef double* m_ptr

    cpdef get_final_state(self, double)

cdef class BruteForceSimulator(Simulator):

    cdef void _get_final_state(self, double) nogil
    cpdef get_final_state(self, double)

