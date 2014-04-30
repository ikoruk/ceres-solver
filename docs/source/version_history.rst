.. _chapter-version-history:

========
Releases
========

HEAD
====

New Features
------------

#. Parameters can now have upper and/or lower bounds when using the
   trust region minimizer.
#. Problems in which the sparsity structure of the Jacobian changes
   over the course of the optimization can now be solved much more
   efficiently. (Richard Stebbing)
#. Improved support for Microsoft Visual C++ including the ability to
   build and ship DLLs. (Björn Piltz, Alex Stewart and Sergey
   Sharybin)
#. Simpler and more informative solver termination type
   reporting. (See below for more details)
#. New `website <http://www.ceres-solver.org>`_ based entirely on
   Sphinx.
#. ``AutoDiffLocalParameterization`` allows the use of automatic
   differentiation for defining ``LocalParameterization`` objects
   (Alex Stewart)
#. LBFGS is faster due to fewer memory copies.
#. Parameter blocks are not restricted to be less than 32k in size,
   they can be upto 2G in size.
#. Faster ``SPARSE_NORMAL_CHOLESKY`` solver when using ``CX_SPARSE``
   as the sparse linear algebra library.
#. ``Problem::IsParameterBlockPresent`` can be used to check if a
   parameter block is already present in the problem.
#. ``Problem::GetParameterzation`` can be used to access the
   parameterization associated with a parameter block.
#. Added the (2,4,9) template specialization for PartitionedMatrixView
   and SchurEliminator.
#. An example demonstrating the use of
   DynamicAutoDiffCostFunction. (Joydeep Biswas)
#. An example demonstrating the use of dynamic sparsity (Richard
   Stebbing)
#. An example from Blender demonstrating the use of a custom
   ``IterationCallback``. (Sergey Sharybin)


Backward Incompatible API Changes
---------------------------------

#. ``Solver::Options::linear_solver_ordering`` used to be a naked
   pointer that Ceres took ownership of. This is error prone behaviour
   which leads to problems when copying the ``Solver::Options`` struct
   around. This has been replaced with a ``shared_ptr`` to handle
   ownership correctly across copies.

#. The enum used for reporting the termination/convergence status of
   the solver has been renamed from ``SolverTerminationType`` to
   ``TerminationType``.

   The enum values have also changed. ``FUNCTION_TOLERANCE``,
   ``GRADIENT_TOLERANCE`` and ``PARAMETER_TOLERANCE`` have all been
   replaced by ``CONVERGENCE``.

   ``NUMERICAL_FAILURE`` has been replaed by ``FAILURE``.

   ``USER_ABORT`` has been renamed to ``USER_FAILURE``.

   Further ``Solver::Summary::error`` has been renamed to
   ``Solver::Summary::message``. It contains a more detailed
   explanation for why the solver terminated.

#. ``Solver::Options::gradient_tolerance`` used to be a relative
   gradient tolerance. i.e., The solver converged when

   .. math::
      \|g(x)\|_\infty < \text{gradient_tolerance} * \|g(x_0)\|_\infty

   where :math:`g(x)` is the gradient of the objective function at
   :math:`x` and :math:`x_0` is the parmeter vector at the start of
   the optimization.

   This has changed to an absolute tolerance, i.e. the solver
   converges when

   .. math::
      \|g(x)\|_\infty < \text{gradient_tolerance}

#. Ceres cannot be built without the line search minimizer
   anymore. Thus the preprocessor define
   ``CERES_NO_LINE_SEARCH_MINIMIZER`` has been removed.

Bug Fixes
---------

#. Variety of code cleanups, optimizations and bug fixes to the line
   search minimizer code (Alex Stewart)
#. Fixed ``BlockSparseMatrix::Transpose`` when the matrix has row and
   column blocks. (Richard Bowen)
#. Better error checking when ``Problem::RemoveResidualBlock`` is
   called. (Alex Stewart)
#. Fixed a memory leack in ``SchurComplementSolver``.
#. Added ``epsilon()`` method to ``NumTraits<ceres::Jet<T, N> >``. (Filippo
   Basso)
#. Fixed a bug in `CompressedRowSparseMatrix::AppendRows`` and
   ``DeleteRows``.q
#. Handle empty problems consistently.
#. Restore the state of the ``Problem`` after a call to
   ``Problem::Evaluate``. (Stefan Leutenegger)
#. Better error checking and reporting for linear solvers.
#. Use explicit formula to solve quadratic polynomials instead of the
   eigenvalue solver.
#. Fix constant parameter handling in inner iterations (Mikael
   Persson).
#. SuiteSparse errors do not cause a fatal crash anymore.
#. Fix ``corrector_test.cc``.
#. Relax the requirements on loss function derivatives.
#. Minor bugfix to logging.h (Scott Ettinger)
#. Updated ``gmock`` and ``gtest`` to the latest upstream version.
#. Fix build breakage on old versions of SuiteSparse.
#. Fixed build issues related to Clang / LLVM 3.4 (Johannes
   Schönberger)
#. METIS_FOUND is never set. Changed the commit to fit the setting of
   the other #._FOUND definitions. (Andreas Franek)
#. Variety of bug fixes to the ``CMake`` build system (Alex Stewart)
#. Removed fictious shared library target from the NDK build.
#. Solver::Options now uses ``shared_ptr`` to handle ownership of
   ``Solver::Options::linear_solver_ordering`` and
   ``Solver::Options::inner_iteration_ordering``. As a consequence the
   ``NDK`` build now depends on ``libc++`` from the ``LLVM`` project.
#. Variety of lint cleanups (William Rucklidge & Jim Roseborough)
#. Various internal cleanups.


1.8.0
=====

New Features
------------
#. Significant improved ``CMake`` files with better robustness,
   dependency checking and GUI support. (Alex Stewart)
#. Added ``DynamicNumericDiffCostFunction`` for numerically
   differentiated cost functions whose sizing is determined at run
   time.
#. ``NumericDiffCostFunction`` now supports a dynamic number of
   residuals just like ``AutoDiffCostFunction``.
#. ``Problem`` exposes more of its structure in its API.
#. Faster automatic differentiation (Tim Langlois)
#. Added the commonly occuring ``2_d_d`` template specialization for
   the Schur Eliminator.
#. Faster ``ITERATIVE_SCHUR`` solver using template specializations.
#. Faster ``SCHUR_JACOBI`` preconditioner construction.
#. Faster ``AngleAxisRotatePoint``.
#. Faster Jacobian evaluation when a loss function is used.
#. Added support for multiple clustering algorithms in visibility
   based preconditioning, including a new fast single linkage
   clustering algorithm.

Bug Fixes
---------
#. Fix ordering of ParseCommandLineFlags() & InitGoogleTest() for
   Windows. (Alex Stewart)
#. Remove DCHECK_GE checks from fixed_array.h.
#. Fix build on MSVC 2013 (Petter Strandmark)
#. Fixed ``AngleAxisToRotationMatrix`` near zero.
#. Move ``CERES_HASH_NAMESPACE`` macros to ``collections_port.h``.
#. Fix handling of unordered_map/unordered_set on OSX 10.9.0.
#. Explicitly link to libm for ``curve_fitting_c.c``. (Alex Stewart)
#. Minor type conversion fix to autodiff.h
#. Remove RuntimeNumericDiffCostFunction.
#. Fix operator= ambiguity on some versions of Clang. (Alex Stewart)
#. Various Lint cleanups (William Rucklidge & Jim Roseborough)
#. Modified installation folders for Windows. (Pablo Speciale)
#. Added librt to link libraries for SuiteSparse_config on Linux. (Alex Stewart)
#. Check for presence of return-type-c-linkage option with
   Clang. (Alex Stewart)
#. Fix Problem::RemoveParameterBlock after calling solve. (Simon Lynen)
#. Fix a free/delete bug in covariance_impl.cc
#. Fix two build errors. (Dustin Lang)
#. Add RequireInitialization = 1 to NumTraits::Jet.
#. Update gmock/gtest to 1.7.0
#. Added IterationSummary::gradient_norm.
#. Reduced verbosity of the inner iteration minimizer.
#. Fixed a bug in TrustRegionMinimizer. (Michael Vitus)
#. Removed android/build_android.sh.


1.7.0
=====

Backward Incompatible API Changes
---------------------------------

#. ``Solver::Options::sparse_linear_algebra_library`` has been renamed
   to ``Solver::Options::sparse_linear_algebra_library_type``.

New Features
------------

#. Sparse and dense covariance estimation.
#. A new Wolfe line search. (Alex Stewart)
#. ``BFGS`` line search direction. (Alex Stewart)
#. C API
#. Speeded up the use of loss functions > 17x.
#. Faster ``DENSE_QR``, ``DENSE_NORMAL_CHOLESKY`` and ``DENSE_SCHUR``
   solvers.
#. Support for multiple dense linear algebra backends. In particular
   optimized ``BLAS`` and ``LAPACK`` implementations (e.g., Intel MKL,
   ACML, OpenBLAS etc) can now be used to do the dense linear
   algebra for ``DENSE_QR``, ``DENSE_NORMAL_CHOLESKY`` and
   ``DENSE_SCHUR``
#. Use of Inner iterations can now be adaptively stopped. Iteration
   and runtime statistics for inner iterations are not reported in
   ``Solver::Summary`` and ``Solver::Summary::FullReport``.
#. Improved inner iteration step acceptance criterion.
#. Add BlockRandomAccessCRSMatrix.
#. Speeded up automatic differentiation by 7\%.
#. Bundle adjustment example from libmv/Blender (Sergey Sharybin)
#. Shared library building is now controlled by CMake, rather than a custom
   solution. Previously, Ceres had a custom option, but this is now deprecated
   in favor of CMake's built in support for switching between static and
   shared. Turn on BUILD_SHARED_LIBS to get shared Ceres libraries.
#. No more dependence on Protocol Buffers.
#. Incomplete LQ factorization.
#. Ability to write trust region problems to disk.
#. Add sinh, cosh, tanh and tan functions to automatic differentiation
   (Johannes Schönberger)
#. Simplifications to the cmake build file.
#. ``miniglog`` can now be used as a replacement for ``google-glog``
   on non Android platforms. (This is NOT recommended).

Bug Fixes
---------

#. Fix ``ITERATIVE_SCHUR`` solver to work correctly when the schur
   complement is of size zero. (Soohyun Bae)
#. Fix the ``spec`` file for generating ``RPM`` packages (Brian Pitts
   and Taylor Braun-Jones).
#. Fix how ceres calls CAMD (Manas Jagadev)
#. Fix breakage on old versions of SuiteSparse. (Fisher Yu)
#. Fix warning C4373 in Visual Studio (Petter Strandmark)
#. Fix compilation error caused by missing suitesparse headers and
   reorganize them to be more robust. (Sergey Sharybin)
#. Check GCC Version before adding -fast compiler option on
   OSX. (Steven Lovegrove)
#. Add documentation for minimizer progress output.
#. Lint and other cleanups (William Rucklidge and James Roseborough)
#. Collections port fix for MSC 2008 (Sergey Sharybin)
#. Various corrections and cleanups in the documentation.
#. Change the path where CeresConfig.cmake is installed (Pablo
   Speciale)
#. Minor errors in documentation (Pablo Speciale)
#. Updated depend.cmake to follow CMake IF convention. (Joydeep
   Biswas)
#. Stablize the schur ordering algorithm.
#. Update license header in split.h.
#. Enabling -O4 (link-time optimization) only if compiler/linker
   support it. (Alex Stewart)
#. Consistent glog path across files.
#. ceres-solver.spec: Use cleaner, more conventional Release string
   (Taylor Braun-Jones)
#. Fix compile bug on RHEL6 due to missing header (Taylor Braun-Jones)
#. CMake file is less verbose.
#. Use the latest upstream version of google-test and gmock.
#. Rationalize some of the variable names in ``Solver::Options``.
#. Improve Summary::FullReport when line search is used.
#. Expose line search parameters in ``Solver::Options``.
#. Fix update of L-BFGS history buffers after they become full. (Alex
   Stewart)
#. Fix configuration error on systems without SuiteSparse installed
   (Sergey Sharybin)
#. Enforce the read call returns correct value in ``curve_fitting_c.c``
   (Arnaud Gelas)
#. Fix DynamicAutoDiffCostFunction (Richard Stebbing)
#. Fix Problem::RemoveParameterBlock documentation (Johannes
   Schönberger)
#. Fix a logging bug in parameter_block.h
#. Refactor the preconditioner class structure.
#. Fix an uninitialized variable warning when building with ``GCC``.
#. Fix a reallocation bug in
   ``CreateJacobianBlockSparsityTranspose``. (Yuliy Schwartzburg)
#. Add a define for O_BINARY.
#. Fix miniglog-based Android NDK build; now works with NDK r9. (Scott Ettinger)


1.6.0
=====

New Features
------------

#. Major Performance improvements.

   a. Schur type solvers (``SPARSE_SCHUR``, ``DENSE_SCHUR``,
      ``ITERATIVE_SCHUR``) are significantly faster due to custom BLAS
      routines and fewer heap allocations.

   b. ``SPARSE_SCHUR`` when used with ``CX_SPARSE`` now uses a block
      AMD for much improved factorization performance.

   c. The jacobian matrix is pre-ordered so that
      ``SPARSE_NORMAL_CHOLESKY`` and ``SPARSE_SCHUR`` do not have to
      make copies inside ``CHOLMOD``.

   d. Faster autodiff by replacing division by multplication by inverse.

   e. When compiled without threads, the schur eliminator does not pay
      the penalty for locking and unlocking mutexes.

#. Users can now use ``linear_solver_ordering`` to affect the
   fill-reducing ordering used by ``SUITE_SPARSE`` for
   ``SPARSE_NORMAL_CHOLESKY``.
#. ``Problem`` can now report the set of parameter blocks it knows about.
#. ``TrustRegionMinimizer`` uses the evaluator to compute the gradient
   instead of a matrix vector multiply.
#. On ``Mac OS``, whole program optimization is enabled.
#. Users can now use automatic differentiation to define new
   ``LocalParameterization`` objects. (Sergey Sharybin)
#. Enable larger tuple sizes for Visual Studio 2012. (Petter Strandmark)


Bug Fixes
---------

#. Update the documentation for ``CostFunction``.
#. Fixed a typo in the documentation. (Pablo Speciale)
#. Fix a typo in suitesparse.cc.
#. Bugfix in ``NumericDiffCostFunction``. (Nicolas Brodu)
#. Death to BlockSparseMatrixBase.
#. Change Minimizer::Options::min_trust_region_radius to double.
#. Update to compile with stricter gcc checks. (Joydeep Biswas)
#. Do not modify cached CMAKE_CXX_FLAGS_RELEASE. (Sergey Sharybin)
#. ``<iterator>`` needed for back_insert_iterator. (Petter Strandmark)
#. Lint cleanup. (William Rucklidge)
#. Documentation corrections. (Pablo Speciale)


1.5.0
=====

Backward Incompatible API Changes
---------------------------------

#. Added ``Problem::Evaluate``. Now you can evaluate a problem or any
   part of it without calling the solver.

   In light of this the following settings have been deprecated and
   removed from the API.

   - ``Solver::Options::return_initial_residuals``
   - ``Solver::Options::return_initial_gradient``
   - ``Solver::Options::return_initial_jacobian``
   - ``Solver::Options::return_final_residuals``
   - ``Solver::Options::return_final_gradient``
   - ``Solver::Options::return_final_jacobian``

   Instead we recommend using something like this.

   .. code-block:: c++

     Problem problem;
     // Build problem

     vector<double> initial_residuals;
     problem.Evaluate(Problem::EvaluateOptions(),
                      NULL, /* No cost */
                      &initial_residuals,
                      NULL, /* No gradient */
                      NULL  /* No jacobian */ );

     Solver::Options options;
     Solver::Summary summary;
     Solver::Solve(options, &problem, &summary);

     vector<double> final_residuals;
     problem.Evaluate(Problem::EvaluateOptions(),
                      NULL, /* No cost */
                      &final_residuals,
                      NULL, /* No gradient */
                      NULL  /* No jacobian */ );


New Features
------------
#. Problem now supports removal of ParameterBlocks and
   ResidualBlocks. There is a space/time tradeoff in doing this which
   is controlled by
   ``Problem::Options::enable_fast_parameter_block_removal``.

#. Ceres now supports Line search based optimization algorithms in
   addition to trust region algorithms. Currently there is support for
   gradient descent, non-linear conjugate gradient and LBFGS search
   directions.
#. Added ``Problem::Evaluate``. Now you can evaluate a problem or any
   part of it without calling the solver. In light of this the
   following settings have been deprecated and removed from the API.

   - ``Solver::Options::return_initial_residuals``
   - ``Solver::Options::return_initial_gradient``
   - ``Solver::Options::return_initial_jacobian``
   - ``Solver::Options::return_final_residuals``
   - ``Solver::Options::return_final_gradient``
   - ``Solver::Options::return_final_jacobian``

#. New, much improved HTML documentation using Sphinx.
#. Changed ``NumericDiffCostFunction`` to take functors like
   ``AutoDiffCostFunction``.
#. Added support for mixing automatic, analytic and numeric
   differentiation. This is done by adding ``CostFunctionToFunctor``
   and ``NumericDiffFunctor`` objects to the API.
#. Sped up the robust loss function correction logic when residual is
   one dimensional.
#. Sped up ``DenseQRSolver`` by changing the way dense jacobians are
   stored. This is a 200-500% improvement in linear solver performance
   depending on the size of the problem.
#. ``DENSE_SCHUR`` now supports multi-threading.
#. Greatly expanded ``Summary::FullReport``:

   - Report the ordering used by the ``LinearSolver``.
   - Report the ordering used by the inner iterations.
   - Execution timing breakdown into evaluations and linear solves.
   - Effective size of the problem solved by the solver, which now
     accounts for the size of the tangent space when using a
     ``LocalParameterization``.
#. Ceres when run at the ``VLOG`` level 3 or higher will report
   detailed timing information about its internals.
#. Remove extraneous initial and final residual evaluations. This
   speeds up the solver a bit.
#. Automatic differenatiation with a dynamic number of parameter
   blocks. (Based on an idea by Thad Hughes).
#. Sped up problem construction and destruction.
#. Added matrix adapters to ``rotation.h`` so that the rotation matrix
   routines can work with row and column major matrices. (Markus Moll)
#. ``SCHUR_JACOBI`` can now be used without ``SuiteSparse``.
#. A ``.spec`` file for producing RPMs. (Taylor Braun-Jones)
#. ``CMake`` can now build the sphinx documentation (Pablo Speciale)
#. Add support for creating a CMake config file during build to make
   embedding Ceres in other CMake-using projects easier. (Pablo
   Speciale).
#. Better error reporting in ``Problem`` for missing parameter blocks.
#. A more flexible ``Android.mk`` and a more modular build. If binary
   size and/or compile time is a concern, larger parts of the solver
   can be disabled at compile time.

Bug Fixes
---------
#. Compilation fixes for MSVC2010 (Sergey Sharybin)
#. Fixed "deprecated conversion from string constant to char*"
   warnings. (Pablo Speciale)
#. Correctly propagate ifdefs when building without Schur eliminator
   template specializations.
#. Correct handling of ``LIB_SUFFIX`` on Linux. (Yuliy Schwartzburg).
#. Code and signature cleanup in ``rotation.h``.
#. Make examples independent of internal code.
#. Disable unused member in ``gtest`` which results in build error on
   OS X with latest Xcode. (Taylor Braun-Jones)
#. Pass the correct flags to the linker when using
   ``pthreads``. (Taylor Braun-Jones)
#. Only use ``cmake28`` macro when building on RHEL6. (Taylor
   Braun-Jones)
#. Remove ``-Wno-return-type-c-linkage`` when compiling with
   GCC. (Taylor Braun-Jones)
#. Fix ``No previous prototype`` warnings. (Sergey Sharybin)
#. MinGW build fixes. (Sergey Sharybin)
#. Lots of minor code and lint fixes. (William Rucklidge)
#. Fixed a bug in ``solver_impl.cc`` residual evaluation. (Markus
   Moll)
#. Fixed varidic evaluation bug in ``AutoDiff``.
#. Fixed ``SolverImpl`` tests.
#. Fixed a bug in ``DenseSparseMatrix::ToDenseMatrix()``.
#. Fixed an initialization bug in ``ProgramEvaluator``.
#. Fixes to Android.mk paths (Carlos Hernandez)
#. Modify ``nist.cc`` to compute accuracy based on ground truth
   solution rather than the ground truth function value.
#. Fixed a memory leak in ``cxsparse.cc``. (Alexander Mordvintsev).
#. Fixed the install directory for libraries by correctly handling
   ``LIB_SUFFIX``. (Taylor Braun-Jones)

1.4.0
=====

Backward Incompatible API Changes
---------------------------------

The new ordering API breaks existing code. Here the common case fixes.

**Before**

.. code-block:: c++

 options.linear_solver_type = ceres::DENSE_SCHUR
 options.ordering_type = ceres::SCHUR

**After**


.. code-block:: c++

  options.linear_solver_type = ceres::DENSE_SCHUR


**Before**

.. code-block:: c++

 options.linear_solver_type = ceres::DENSE_SCHUR;
 options.ordering_type = ceres::USER;
 for (int i = 0; i < num_points; ++i) {
   options.ordering.push_back(my_points[i])
 }
 for (int i = 0; i < num_cameras; ++i) {
   options.ordering.push_back(my_cameras[i])
 }
 options.num_eliminate_blocks = num_points;


**After**

.. code-block:: c++

 options.linear_solver_type = ceres::DENSE_SCHUR;
 options.ordering = new ceres::ParameterBlockOrdering;
 for (int i = 0; i < num_points; ++i) {
   options.linear_solver_ordering->AddElementToGroup(my_points[i], 0);
 }
 for (int i = 0; i < num_cameras; ++i) {
   options.linear_solver_ordering->AddElementToGroup(my_cameras[i], 1);
 }


New Features
------------

#. A new richer, more expressive and consistent API for ordering
   parameter blocks.
#. A non-linear generalization of Ruhe & Wedin's Algorithm II. This
   allows the user to use variable projection on separable and
   non-separable non-linear least squares problems. With
   multithreading, this results in significant improvements to the
   convergence behavior of the solver at a small increase in run time.
#. An image denoising example using fields of experts. (Petter
   Strandmark)
#. Defines for Ceres version and ABI version.
#. Higher precision timer code where available. (Petter Strandmark)
#. Example Makefile for users of Ceres.
#. IterationSummary now informs the user when the step is a
   non-monotonic step.
#. Fewer memory allocations when using ``DenseQRSolver``.
#. GradientChecker for testing CostFunctions (William Rucklidge)
#. Add support for cost functions with 10 parameter blocks in
   ``Problem``. (Fisher)
#. Add support for 10 parameter blocks in ``AutoDiffCostFunction``.


Bug Fixes
---------

#. static cast to force Eigen::Index to long conversion
#. Change LOG(ERROR) to LOG(WARNING) in ``schur_complement_solver.cc``.
#. Remove verbose logging from ``DenseQRSolve``.
#. Fix the Android NDK build.
#. Better handling of empty and constant Problems.
#. Remove an internal header that was leaking into the public API.
#. Memory leak in ``trust_region_minimizer.cc``
#. Schur ordering was operating on the wrong object (Ricardo Martin)
#. MSVC fixes (Petter Strandmark)
#. Various fixes to ``nist.cc`` (Markus Moll)
#. Fixed a jacobian scaling bug.
#. Numerically robust computation of ``model_cost_change``.
#. Signed comparison compiler warning fixes (Ricardo Martin)
#. Various compiler warning fixes all over.
#. Inclusion guard fixes (Petter Strandmark)
#. Segfault in test code (Sergey Popov)
#. Replaced ``EXPECT/ASSERT_DEATH`` with the more portable
   ``EXPECT_DEATH_IF_SUPPORTED`` macros.
#. Fixed the camera projection model in Ceres' implementation of
   Snavely's camera model. (Ricardo Martin)


1.3.0
=====

New Features
------------

#. Android Port (Scott Ettinger also contributed to the port)
#. Windows port. (Changchang Wu and Pierre Moulon also contributed to the port)
#. New subspace Dogleg Solver. (Markus Moll)
#. Trust region algorithm now supports the option of non-monotonic steps.
#. New loss functions ``ArcTanLossFunction``, ``TolerantLossFunction``
   and ``ComposedLossFunction``. (James Roseborough).
#. New ``DENSE_NORMAL_CHOLESKY`` linear solver, which uses Eigen's
   LDLT factorization on the normal equations.
#. Cached symbolic factorization when using ``CXSparse``.
   (Petter Strandark)
#. New example ``nist.cc`` and data from the NIST non-linear
   regression test suite. (Thanks to Douglas Bates for suggesting this.)
#. The traditional Dogleg solver now uses an elliptical trust
   region (Markus Moll)
#. Support for returning initial and final gradients & Jacobians.
#. Gradient computation support in the evaluators, with an eye
   towards developing first order/gradient based solvers.
#. A better way to compute ``Solver::Summary::fixed_cost``. (Markus Moll)
#. ``CMake`` support for building documentation, separate examples,
   installing and uninstalling the library and Gerrit hooks (Arnaud
   Gelas)
#. ``SuiteSparse4`` support (Markus Moll)
#. Support for building Ceres without ``TR1`` (This leads to
   slightly slower ``DENSE_SCHUR`` and ``SPARSE_SCHUR`` solvers).
#. ``BALProblem`` can now write a problem back to disk.
#. ``bundle_adjuster`` now allows the user to normalize and perturb the
   problem before solving.
#. Solver progress logging to file.
#. Added ``Program::ToString`` and ``ParameterBlock::ToString`` to
   help with debugging.
#. Ability to build Ceres as a shared library (MacOS and Linux only),
   associated versioning and build release script changes.
#. Portable floating point classification API.


Bug Fixes
---------

#. Fix how invalid step evaluations are handled.
#. Change the slop handling around zero for model cost changes to use
   relative tolerances rather than absolute tolerances.
#. Fix an inadvertant integer to bool conversion. (Petter Strandmark)
#. Do not link to ``libgomp`` when building on
   windows. (Petter Strandmark)
#. Include ``gflags.h`` in ``test_utils.cc``. (Petter
   Strandmark)
#. Use standard random number generation routines. (Petter Strandmark)
#. ``TrustRegionMinimizer`` does not implicitly negate the
   steps that it takes. (Markus Moll)
#. Diagonal scaling allows for equal upper and lower bounds. (Markus Moll)
#. TrustRegionStrategy does not misuse LinearSolver:Summary anymore.
#. Fix Eigen3 Row/Column Major storage issue. (Lena Gieseke)
#. QuaternionToAngleAxis now guarantees an angle in $[-\pi, \pi]$. (Guoxuan Zhang)
#. Added a workaround for a compiler bug in the Android NDK to the
   Schur eliminator.
#. The sparse linear algebra library is only logged in
   Summary::FullReport if it is used.
#. Rename the macro ``CERES_DONT_HAVE_PROTOCOL_BUFFERS``
   to ``CERES_NO_PROTOCOL_BUFFERS`` for consistency.
#. Fix how static structure detection for the Schur eliminator logs
   its results.
#. Correct example code in the documentation. (Petter Strandmark)
#. Fix ``fpclassify.h`` to work with the Android NDK and STLport.
#. Fix a memory leak in the ``levenber_marquardt_strategy_test.cc``
#. Fix an early return bug in the Dogleg solver. (Markus Moll)
#. Zero initialize Jets.
#. Moved ``internal/ceres/mock_log.h`` to ``internal/ceres/gmock/mock-log.h``
#. Unified file path handling in tests.
#. ``data_fitting.cc`` includes ``gflags``
#. Renamed Ceres' Mutex class and associated macros to avoid
   namespace conflicts.
#. Close the BAL problem file after reading it (Markus Moll)
#. Fix IsInfinite on Jets.
#. Drop alignment requirements for Jets.
#. Fixed Jet to integer comparison. (Keith Leung)
#. Fix use of uninitialized arrays. (Sebastian Koch & Markus Moll)
#. Conditionally compile gflag dependencies.(Casey Goodlett)
#. Add ``data_fitting.cc`` to the examples ``CMake`` file.


1.2.3
=====

Bug Fixes
---------

#. ``suitesparse_test`` is enabled even when ``-DSUITESPARSE=OFF``.
#. ``FixedArray`` internal struct did not respect ``Eigen``
   alignment requirements (Koichi Akabe & Stephan Kassemeyer).
#. Fixed ``quadratic.cc`` documentation and code mismatch
   (Nick Lewycky).

1.2.2
=====

Bug Fixes
---------

#. Fix constant parameter blocks, and other minor fixes (Markus Moll)
#. Fix alignment issues when combining ``Jet`` and
   ``FixedArray`` in automatic differeniation.
#. Remove obsolete ``build_defs`` file.

1.2.1
=====

New Features
------------

#. Powell's Dogleg solver
#. Documentation now has a brief overview of Trust Region methods and
   how the Levenberg-Marquardt and Dogleg methods work.

Bug Fixes
---------

#. Destructor for ``TrustRegionStrategy`` was not virtual (Markus Moll)
#. Invalid ``DCHECK`` in ``suitesparse.cc`` (Markus Moll)
#. Iteration callbacks were not properly invoked (Luis Alberto Zarrabeiti)
#. Logging level changes in ConjugateGradientsSolver
#. VisibilityBasedPreconditioner setup does not account for skipped camera pairs. This was debugging code.
#. Enable SSE support on MacOS
#. ``system_test`` was taking too long and too much memory (Koichi Akabe)

1.2.0
=====

New Features
------------

#. ``CXSparse`` support.
#. Block oriented fill reducing orderings. This reduces the
   factorization time for sparse ``CHOLMOD`` significantly.
#. New Trust region loop with support for multiple trust region step
   strategies. Currently only Levenberg-Marquardt is supported, but
   this refactoring opens the door for Dog-leg, Stiehaug and others.
#. ``CMake`` file restructuring.  Builds in ``Release`` mode by   default, and now has platform specific tuning flags.
#. Re-organized documentation. No new content, but better
   organization.


Bug Fixes
---------

#. Fixed integer overflow bug in ``block_random_access_sparse_matrix.cc``.
#. Renamed some macros to prevent name conflicts.
#. Fixed incorrent input to ``StateUpdatingCallback``.
#. Fixes to AutoDiff tests.
#. Various internal cleanups.


1.1.1
=====

Bug Fixes
---------

#. Fix a bug in the handling of constant blocks. (Louis Simard)
#. Add an optional lower bound to the Levenberg-Marquardt regularizer
   to prevent oscillating between well and ill posed linear problems.
#. Some internal refactoring and test fixes.

1.1.0
=====

New Features
------------

#. New iterative linear solver for general sparse problems - ``CGNR``
   and a block Jacobi preconditioner for it.
#. Changed the semantics of how ``SuiteSparse`` dependencies are
   checked and used. Now ``SuiteSparse`` is built by default, only if
   all of its dependencies are present.
#. Automatic differentiation now supports dynamic number of residuals.
#. Support for writing the linear least squares problems to disk in
   text format so that they can loaded into ``MATLAB``.
#. Linear solver results are now checked for nan and infinities.
#. Added ``.gitignore`` file.
#. A better more robust build system.


Bug Fixes
---------

#. Fixed a strict weak ordering bug in the schur ordering.
#. Grammar and typos in the documents and code comments.
#. Fixed tests which depended on exact equality between floating point values.

1.0.0
=====

Initial Release. Nathan Wiegand contributed to the Mac OSX port.
