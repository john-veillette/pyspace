# PySpace
**A python-based toolbox for galactic simulations** <br><br>
[![Build Status](https://travis-ci.com/adityapb/pyspace.svg?token=cRaLayDadtZBxrGbfQPp&branch=master)](https://travis-ci.com/adityapb/pyspace) <br>

##Features
* A python interface for high performance C++ implementation of N-body simulation algorithms.
* PySpace has a numpy friendly API which makes it easier to use.
* Dumps vtk output which allows users to take advantage of tools like ParaView, MayaVi, etc. for visualization.

##Algorithms
* Brute Force *O(n<sup>2</sup>)*

##Installation
###Dependencies
* Numpy
* PyEVTK (Install [here](https://pypi.python.org/pypi/PyEVTK))

###Linux and OSX
Clone this repository by `git clone https://github.com/adityapb/pyspace.git` <br>
Run `python setup.py install` to install.

**PySpace doesn't support Windows currently**

##Contributing
Use PEP 8 coding standard for python and follow [this](https://users.ece.cmu.edu/~eno/coding/CppCodingStandard.html) for C++. 

