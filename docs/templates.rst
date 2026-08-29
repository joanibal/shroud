.. Copyright Shroud Project Developers. See LICENSE file for details.

   SPDX-License-Identifier: (BSD-3-Clause)

Templates
---------

Shroud will wrap templated classes and functions for explicit instantiations.
The template is given as part of the ``decl`` and the instantations are listed in the
``cxx_template`` section:

.. code-block:: yaml

  - decl: |
        template<typename ArgType>
        void TemplateArgument(ArgType arg)
    cxx_template:
    - instantiation: <int>
    - instantiation: <double>

``options`` and ``format`` may be provide to control the generated code:

.. code-block:: yaml

  - decl: template<typename T> class vector
    cxx_header: <vector>
    cxx_template:
    - instantiation: <int>
      format:
        C_impl_filename: wrapvectorforint.cpp
      options:
        optblah: two
    - instantiation: <double>

.. from templates.yaml

For a class template, the *class_name* is modified to included the
instantion type.  If only a single template parameter is provided,
then the template argument is used.  For the above example,
*C_impl_filename* will default to ``wrapvector_int.cpp`` but has been
explicitly changed to ``wrapvectorforint.cpp``.

Excluding declarations from an instantiation
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Every declaration of a class template is wrapped for every instantiation.
A member which only makes sense for some of the instantiations can be
omitted with the ``cxx_template_exclude`` field:

.. code-block:: yaml

  - decl: template<typename T> class vector
    cxx_template:
    - instantiation: <int>
    - instantiation: <double>
    - instantiation: <float>
    declarations:
    - decl: void push_back(const T& value)
    - decl: T average()
      cxx_template_exclude:
      - instantiation: <int>

``vector_int`` is wrapped without ``average``, exactly as if the declaration
were not in the YAML file at all.  No C, Fortran or Python wrapper is
created for it and it does not appear in the Fortran derived type.

``cxx_template_exclude`` names instantiations of the *enclosing class*, not
of the declaration's own ``cxx_template`` block.  If a member template is
excluded, all of its instantiations are dropped from that class.

Instantiations are matched by type, not by spelling, so ``<int, double>``
and ``<int,double>`` name the same instantiation.  It is an error to name an
instantiation which the class does not have.

Functions can be created which return a templated class:

.. code-block:: yaml

    - decl: vector<int> getVector()

The result type must be instantiated via the *cxx_template* block before
it can be used.
