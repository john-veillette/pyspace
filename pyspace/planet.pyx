# distutils: language = c++

cdef class PlanetArray:
    def __init__(self,  x, np.ndarray y, np.ndarray z,
            np.ndarray v_x = None, np.ndarray v_y = None,  np.ndarray v_z = None,
            np.ndarray m = None):
        cdef int num_planets = self.get_number_of_planets()
        self.x = np.ascontiguousarray(x, dtype = np.double)
        self.y = np.ascontiguousarray(y, dtype = np.double)
        self.z = np.ascontiguousarray(z, dtype = np.double)


        if v_x is None:
            self.v_x = np.zeros(num_planets, dtype = np.double, order = "c")
        else:
            self.v_x = np.ascontiguousarray(v_x, dtype = np.double)

        if v_y is None:
            self.v_y = np.zeros(num_planets, dtype = np.double, order = "c")
        else:
            self.v_x = np.ascontiguousarray(v_x, dtype = np.double)

        if v_z is None:
            self.v_z = np.zeros(num_planets, dtype = np.double, order = "c")
        else:
            self.v_x = np.ascontiguousarray(v_x, dtype = np.double)

        if m is None:
            self.m = np.ones(num_planets, dtype = np.double, order = "c")
        else:
            self.m = np.ascontiguousarray(m, dtype = np.double)

        self.a_x = np.zeros(num_planets, dtype = np.double, order = "c")
        self.a_y = np.zeros(num_planets, dtype = np.double, order = "c")
        self.a_z = np.zeros(num_planets, dtype = np.double, order = "c")

    cpdef int get_number_of_planets(self):
        return self.x.size


