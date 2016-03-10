#distutils: language = c++
from libcpp.vector cimport vector
from libcpp.string cimport string

cdef extern from "pyspace.h":
    cdef cppclass cVector:
        double x, y, z
        cVector() nogil except +
        cVector(double, double, double) nogil except +

    cdef cppclass SimConfig:
        double G, step_size
        SimConfig() nogil except +
        SimConfig(double, double) nogil except +
        SimConfig(string) nogil except +

    cdef cppclass SimObject:
        double mass, radius
        cVector* position
        cVector* velocity
        cVector* acceleration
        SimObject() nogil except +
        SimObject(double, double, cVector*, cVector*, int) nogil except +

    cdef cppclass Engine:
        vector[SimObject] *obj_list
        SimConfig* config
        Engine(vector[SimObject]*, SimConfig*) nogil except +
        void update() nogil

cdef class Vector:
    cdef cVector v

cdef class Config:
    cdef SimConfig cfg

    cpdef load(self, string filename)
