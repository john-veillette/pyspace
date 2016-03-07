# distutils: language = c++
from libcpp.vector cimport vector
from utils cimport cVector, SimObject, Engine, Config

cdef class Solver:
    cdef Engine* _eng

    def __cinit__(self, PlanetArray arr, Config conf):
        self._eng = new Engine(&arr.obj_list, &conf.cfg)

    cpdef update(self):
        self._eng.update()

    def __dealloc__(self):
        del self._eng
