# distutils: language = c++
from libcpp.vector cimport vector
from libc.math cimport floor
from utils cimport SimObject, Engine, Config
from planet cimport PlanetArray

cdef class Simulator:
    cdef Engine* _eng

    cpdef update(self)

    cdef void _get_final_state(self, double) nogil

    cpdef get_final_state(self, double)

