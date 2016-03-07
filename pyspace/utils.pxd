#distutils: language = c++
from licpp.vector cimport vector
from libcpp.string cimport string

cdef extern from "pyspace.hpp":
    cdef struct cVector:
        double x, y, z
        cVector() nogil except +
        cVector(double, double, double) nogil except +

    cdef struct SimConfig:
        double G, step_size
        SimConfig() nogil except +
        SimConfig(double, double) nogil except +
        SimConfig(string) nogil except +

    cdef cppclass SimObject:
        double mass, radius
        cVector position, velocity, acceleration
        SimObject(double, double, cVector, cVector, int) nogil except +

    cdef cppclass Engine:
        Engine(vector[SimObject]*, SimConfig*) nogil except +
        void update() nogil

cdef class Vector:
    cdef cVector v

    def __cinit__(self, double x = 0, double y = 0, double z = 0):
        self.v = cVector(x, y, z)

cdef class Config:
    cdef SimConfig cfg

    def __cinit__(self, double G = 0, double dt = 0):
        self.cfg = SimConfig(G, dt)

    cpdef _load(string filename):
        self.cfg = SimConfig(filename)

