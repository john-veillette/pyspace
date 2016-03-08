# distutils: language = c++
from libcpp.vector cimport vector
from libcpp.string cimport string
from utils cimport Vector, SimObject

cdef class PlanetArray:
    cdef vector[SimObject] obj_list

    cdef inline void _add_planet(self, double, double, Vector,
            Vector, int) nogil

    cpdef add_planet(self, double, double, Vector,
            Vector, int)
