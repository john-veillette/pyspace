#!usr/bin/env python
from pyspace.planet import PlanetArray

def get_planet_array(name = '', **props):
    pa = PlanetArray(name, props)
    return pa

