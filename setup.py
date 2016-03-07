from distutils.core import setup
from setuptools import find_packages
from distutils.extension import Extension

requires = ["cython"]

from Cython.Build import cythonize

ext_modules = []

ext_modules += [
        Extension(
            "pyspace.utils",
            ["pyspace/utils.pyx"],
            include_dirs = ["src"]
            )
        ]

ext_modules += [
        Extension(
            "pyspace.planet",
            ["pyspace/planet.pyx"],
            include_dirs = ["src"]
            )
        ]

ext_modules += [
        Extension(
            "pyspace.simulator",
            ["pyspace/simulator.pyx"],
            include_dirs = ["src"]
            )
        ]

ext_modules = cythonize(ext_modules)

setup(
        name="pyspace",
        version="0.0.1",
        install_requires=requires,
        packages=find_packages(),
        ext_modules = ext_modules
    )

