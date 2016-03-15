# distutils: language = c++
import numpy as np
cimport numpy as np

ctypedef np.double_t DOUBLE

cdef class PlanetArray:
    cdef np.ndarray[DOUBLE, ndim=1, mode="c"] x, y, z
    cdef np.ndarray[DOUBLE, ndim=1, mode="c"] v_x, v_y, v_z
    cdef np.ndarray[DOUBLE, ndim=1, mode="c"] a_x, a_y, a_z

    cpdef int get_number_of_planets(self)

