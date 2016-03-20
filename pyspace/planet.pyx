# distutils: language = c++
import numpy as np
cimport numpy as np
from libc.math cimport sqrt

cdef class PlanetArray:
    def __cinit__(self, ndarray x, ndarray y, ndarray z,
            ndarray v_x = None, ndarray v_y = None,  ndarray v_z = None,
            ndarray m = None):
        """Constructor for PlanetArray

        Parameters
        ----------

        x: np.ndarray
            'x' coordinates of planets

        y: np.ndarray
            'y' coordinates of planets

        z: np.ndarray
            'z' coordinates of planets

        v_x: np.ndarray
            'x' components of initial velocity
            Default value: 0

        v_y: np.ndarray
            'y' components of initial velocity
            Default value: 0

        v_z: np.ndarray
            'z' components of initial velocity
            Default value: 0

        m: np.ndarray
            Mass of planets
            Default value: 1

        """
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
        """Returns number of planets in the PlanetArray"""
        return self.x.size

    cpdef double dist(self, int i, int j):
        """Distance between planet 'i' and planet 'j'"""
        return sqrt((self.x[i] - self.x[j])**2 + (self.y[i] - self.y[j])**2 + \
                (self.z[i] - self.z[j])**2)

