=====================
The PySpace Framework
=====================

This document is an introduction to the design of PySpace. This provides high level details
on the functionality of PySpace. This should allow the user to use the module and extend it
effectively.

To understand the framework, we will work through a general N-body problem.

--------------
N-body problem
--------------

Consider a problem of :math:`n` bodies with mass :math:`m_i` for the :math:`i^{th}` planet. 

Equations
~~~~~~~~~

.. math::
    :label: force    

    a_i = \sum_{\substack{j=1 \\ j\neq i}}^{n} G \frac{m_j}{r_{ij}^3} (\vec{r_j} - \vec{r_i})

Numerical Integration
~~~~~~~~~~~~~~~~~~~~~

``BruteForceSimulator`` uses leap frog integrator for updating velocity and positions of planets.

.. math::
    :label: position

    x_{i+1} = x_i + v_i\Delta t + \frac{1}{2}a_i\Delta t^2

.. math::
    :label: velocity

    v_{i+1} = v_i + \frac{1}{2}(a_i + a_{i+1})\Delta t


Understanding the framework
~~~~~~~~~~~~~~~~~~~~~~~~~~~

We will be using ``pyspace.planet.PlanetArray`` for storing planets.

``pyspace.planet.PlanetArray`` stores numpy arrays for :math:`x, y, z, v_x, v_y, v_z, a_x, a_y, \
a_z, m` and also stores a raw pointer to each numpy array.

``pyspace.simulator.BruteForceSimulator`` then passes these raw pointers to the C++ function, 
``brute_force_update`` which then updates the pointers using the above numerical integration 
scheme.

-------------
Visualization
-------------

PySpace dumps a vtk output of the simulations. These can then be visualized using tools such as 
Paraview, MayaVi, etc.

The vtk dump is controlled by the ``dump_output`` flag in ``Simulator::simulate``.
The vtk dump by default only dumps ``v_x`` ie. x component of velocity.
For dumping custom data, use ``dump_vtk`` function in ``pyspace.utils`` module.

