import numpy
from distutils.core import setup
from setuptools import find_packages
from distutils.extension import Extension
from Cython.Build import cythonize

requires = ["cython"]

ext_modules = []

ext_modules += [
        Extension(
            "pyspace.planet",
            ["pyspace/planet.pyx"],
            include_dirs = [numpy.get_include()]
            )
        ]

ext_modules += [
        Extension(
            "pyspace.simulator",
            ["pyspace/simulator.pyx", "src/pyspace.cpp"],
            include_dirs = ["src", numpy.get_include()],
            )
        ]

ext_modules = cythonize(ext_modules)

setup(
        name="PySpace",
        author="PySpace developers",
        description="A toolbox for trajectory calculation and simulation",
        version="0.0.1",
        install_requires=requires,
        packages=find_packages(),
        ext_modules = ext_modules
    )

