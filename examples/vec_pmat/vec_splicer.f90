! vec_splicer.f90
! Hand-written splicer code for the KryLAVA Fortran wrappers.
!
! After moving the lifecycle into krylava.yaml, the ONLY thing that must stay in
! a splicer is `component_part`: the custom derived-type data members
! (NLocal/ng/bs/comm + arr/B).  Splicer text is inserted verbatim and is keyed
! per instantiation, so there is one block per type.  The four size members are
! identical; only arr/B change kind with VarType.
!
! Everything else is generated for every instantiation from krylava.yaml:
!   * `call vec%create(...)`  -> wrapping the C++ `void create(...)` method,
!     with fstatements that allocate the C++ object (f_pre_call) and wire the
!     arr/B pointers (f_post_call), wformat-expanded per type.
!   * `call vec%destroy()`    -> the destructor renamed via F_name_function.
!   * maxpy / mdot            -> renamed via F_name_function.
!
! Lines outside splicer blocks are ignored by Shroud.

! Module-level kinds needed by the component_part members below.
! (C_INT32_T / C_INT64_T are already use-associated by the generated module.)
! splicer begin module_use
use iso_c_binding, only : C_DOUBLE, C_FLOAT
! splicer end module_use

! splicer begin class.PVector_double.component_part
integer(kind=local_size_t) :: NLocal=-1
integer(kind=local_size_t) :: ng = 0
integer(kind=C_INT) :: bs=1
integer(kind=C_INT) :: comm
real(kind=C_DOUBLE), dimension(:),  pointer, contiguous :: arr
real(kind=C_DOUBLE), dimension(:, :), pointer, contiguous :: B
! splicer end class.PVector_double.component_part

! splicer begin class.PVector_float.component_part
integer(kind=local_size_t) :: NLocal=-1
integer(kind=local_size_t) :: ng = 0
integer(kind=C_INT) :: bs=1
integer(kind=C_INT) :: comm
real(kind=C_FLOAT), dimension(:),  pointer, contiguous :: arr
real(kind=C_FLOAT), dimension(:, :), pointer, contiguous :: B
! splicer end class.PVector_float.component_part

! splicer begin class.PVector_int32_t.component_part
integer(kind=local_size_t) :: NLocal=-1
integer(kind=local_size_t) :: ng = 0
integer(kind=C_INT) :: bs=1
integer(kind=C_INT) :: comm
integer(kind=C_INT32_T), dimension(:),  pointer, contiguous :: arr
integer(kind=C_INT32_T), dimension(:, :), pointer, contiguous :: B
! splicer end class.PVector_int32_t.component_part

! splicer begin class.PVector_int64_t.component_part
integer(kind=local_size_t) :: NLocal=-1
integer(kind=local_size_t) :: ng = 0
integer(kind=C_INT) :: bs=1
integer(kind=C_INT) :: comm
integer(kind=C_INT64_T), dimension(:),  pointer, contiguous :: arr
integer(kind=C_INT64_T), dimension(:, :), pointer, contiguous :: B
! splicer end class.PVector_int64_t.component_part
