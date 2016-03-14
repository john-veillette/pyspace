# distutils: language = c++ 

cdef class Vector:
    def __cinit__(self, double x = 0, double y = 0, double z = 0):
        self.v = cVector(x, y, z)

    property x:
        def __get__(self):
            return self.v.x

        def __set__(self, x):
            self.v.x = x

    property y:
        def __get__(self):
            return self.v.y

        def __set__(self, y):
            self.v.y = y

    property z:
        def __get__(self):
            return self.v.z

        def __set__(self, z):
            self.v.z = z



cdef class Config:
    def __cinit__(self, double G = 0, double dt = 0):
        self.cfg = SimConfig(G, dt)

    cpdef load(self, string filename):
        self.cfg = SimConfig(filename)

