# distutils: language = c++
import numpy as np
cimport numpy as np

cdef extern from "numpy/arrayobject.h":
    ctypedef int intp
    ctypedef extern class numpy.ndarray [object PyArrayObject]:
        cdef char *data
        cdef int nd
        cdef intp *dimensions
        cdef intp *strides
        cdef int flags

cdef class PlanetArray:
    cdef public ndarray x
    cdef public ndarray y
    cdef public ndarray z
    cdef public ndarray v_x
    cdef public ndarray v_y
    cdef public ndarray v_z
    cdef public ndarray a_x
    cdef public ndarray a_y
    cdef public ndarray a_z
    cdef public ndarray m

    cpdef int get_number_of_planets(self)

