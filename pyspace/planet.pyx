# distutils: language = c++
import numpy as np
cimport numpy as np

cdef class PlanetArray:
    def __cinit__(self, ndarray x, ndarray y, ndarray z,
            ndarray v_x = None, ndarray v_y = None,  ndarray v_z = None,
            ndarray m = None):
        self.x = x
        self.y = y
        self.z = z

        cdef int num_planets = self.get_number_of_planets()

        if v_x is None:
            self.v_x = np.zeros(num_planets)
        else:
            self.v_x = v_x

        if v_y is None:
            self.v_y = np.zeros(num_planets)
        else:
            self.v_y = v_y

        if v_z is None:
            self.v_z = np.zeros(num_planets)
        else:
            self.v_y = v_y

        if m is None:
            self.m = np.ones(num_planets)
        else:
            self.m = m

        self.a_x = np.zeros(num_planets)
        self.a_y = np.zeros(num_planets)
        self.a_z = np.zeros(num_planets)

    cpdef int get_number_of_planets(self):
        return self.x.size

