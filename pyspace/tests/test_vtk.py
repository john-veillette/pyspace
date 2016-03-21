from pyspace.utils import dump_vtk
import numpy
from pyspace.planet import PlanetArray

def test_vtk_dump():
    x, y, z = numpy.mgrid[0:1:0.04, 0:1:0.04, 0:1:0.04]
    x = x.ravel(); y = y.ravel(); z = z.ravel()
    v_x = numpy.ones_like(x)
    pa = PlanetArray(x=x, y=y, z=z, v_x=v_x)
    dump_vtk(pa, "points")

