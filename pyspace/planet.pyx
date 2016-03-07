# distutils: language = c++
from libcpp.vector cimport vector
from utils cimport Vector, SimObject

cdef class PlanetArray:
    cdef vector[SimObject] obj_list

    def __cinit__(self, int res_len):
        self.obj_list.reserve(res_len)

    cdef inline void _add_planet(self, double mass, double radius, Vector init_pos,
            Vector init_vel, int planet_id) nogil:
        cdef SimObject new_planet = SimObject(mass, radius, init_pos.v,
                init_vel.v, planet_id)
        self.obj_list.push_back(new_planet)

    cpdef add_planet(self, double mass, double radius, Vector init_pos,
            Vector init_vel, int planet_id):
        self._add_planet(mass, radius, init_pos, init_vel, int planet_id)

    def __dealloc__(self):
        del self.obj

