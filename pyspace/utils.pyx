# distutils: language = c++ 

cdef class Vector:
    def __cinit__(self, double x = 0, double y = 0, double z = 0):
        self.v = cVector(x, y, z)

cdef class Config:
    def __cinit__(self, double G = 0, double dt = 0):
        self.cfg = SimConfig(G, dt)

    cpdef load(self, string filename):
        self.cfg = SimConfig(filename)

