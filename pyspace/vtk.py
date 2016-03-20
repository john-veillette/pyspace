from pyspace.planet import PlanetArray
from evtk.hl import pointsToVTK

def dump_vtk(pa, filename):
    pointsToVTK(filename, pa.x, pa.y, pa.z, data = \
            {"v_x" : pa.v_x, "v_y" : pa.v_y, "v_z" : pa.v_z})

