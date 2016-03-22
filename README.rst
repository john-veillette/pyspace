PySpace
=======

| **A python-based toolbox for galactic simulations**
|
| |Build Status| |Docs Status|

Here's a video of planets arranged in cube simulation using PySpace.

.. raw:: html

    <div align="center">
        <iframe width="420" height="315" src="https://www.youtube.com/embed/aJneOtU__LY" frameborder="0" allowfullscreen>
        </iframe>
    </div>


Documentation
-------------

The documentation for this project can be found at `http://pyspace.readthedocs.org/ <http://pyspace.readthedocs.org/>`_.

Features
--------

-  A python interface for high performance C++ implementation of N-body
   simulation algorithms.
-  PySpace has a numpy friendly API which makes it easier to use.
-  Parallel support using OpenMP.
-  Dumps vtk output which allows users to take advantage of tools like
   ParaView, MayaVi, etc. for visualization.

Algorithms
----------

-  Brute Force :math:`O(n^2)`

Installation
------------

Dependencies
~~~~~~~~~~~~

-  Numpy
-  PyEVTK (``pip install pyevtk``)

Linux and OSX
~~~~~~~~~~~~~

| Clone this repository by
  ``git clone https://github.com/adityapb/pyspace.git``
| Run ``python setup.py install`` to install.
|
| **PySpace doesn't support Windows currently**

Contributing
------------

Use PEP 8 coding standard for python and follow
`this <https://users.ece.cmu.edu/~eno/coding/CppCodingStandard.html>`__
for C++.

.. |Build Status| image:: https://travis-ci.org/adityapb/pyspace.svg?branch=master
    :target: https://travis-ci.org/adityapb/pyspace
   
.. |Docs Status| image:: https://readthedocs.org/projects/pyspace/badge/?version=stable
   :target: http://pyspace.readthedocs.org/en/stable/?badge=stable
   :alt: Documentation Status
