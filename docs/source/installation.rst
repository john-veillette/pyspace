============
Installation
============

------------
Dependencies
------------

- Numpy
- PyEVTK (``pip install pyevtk``)
- gcc compiler
- OpenMP (optional)
- ParaView / MayaVi or any other vtk rendering tool (optional)

-------------
Linux and OSX
-------------

To install the latest stable version, run::
    
    $ pip install pyspace

To install development version, clone this repository by:: 

    $ git clone https://github.com/adityapb/pyspace.git

To install, run::

    $ python setup.py install

To install without OpenMP, set ``USE_OPENMP`` environment variable
to 0 and then install::

    $ export USE_OPENMP=0 
    $ python setup.py install

**PySpace doesn't support Windows currently**

-----------------
Running the tests
-----------------

For running the tests you will need to install ``nose``, install using::

    $ pip install nose

To run the tests, cd to pyspace/tests directory and run::
    
    $ nosetests -v

