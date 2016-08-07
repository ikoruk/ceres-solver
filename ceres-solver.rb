class CeresSolver < Formula
  desc "C++ library for large-scale optimization"
  homepage "http://ceres-solver.org/"
  url "http://ceres-solver.org/ceres-solver-1.11.0.tar.gz"
  sha256 "4d666cc33296b4c5cd77bad18ffc487b3223d4bbb7d1dfb342ed9a87dc9af844"
  revision 2
  head "https://ceres-solver.googlesource.com/ceres-solver.git"

  # bottle do
  #   sha256 "f11c49891b9e084fc4d82aac72c85c04595435502e7f92014c3b5910e56211cd" => :el_capitan
  #   sha256 "6ceffb043d52314e66ec22ba947af3944b30c86c41b06ea4db17e640066723ab" => :yosemite
  #   sha256 "f0ff74807c03feabd7430ad886af57a1c8e1beb0d8f8e731adb442570d046a50" => :mavericks
  # end

  option "without-test", "Do not build and run the tests (not recommended)."
  deprecated_option "without-tests" => "without-test"

  depends_on "cmake" => :run
  depends_on "glog"
  depends_on "gflags"
  depends_on "eigen"
  depends_on "suite-sparse" => :recommended

  def suite_sparse_options
    Tab.for_formula(Formula["suite-sparse"])
  end

  patch :DATA

  def install
    ENV['CC'] = '/usr/local/opt/llvm/bin/clang'
    ENV['CXX'] = '/usr/local/opt/llvm/bin/clang++ -stdlib=libc++'
    ENV['CXXFLAGS'] = '-nostdinc++ -I/usr/local/opt/llvm/include/c++/v1'
    ENV['LDFLAGS'] = '-L/usr/local/opt/llvm/lib'
    cmake_args = std_cmake_args + ["-DBUILD_SHARED_LIBS=ON"]
    cmake_args << "-DMETIS_LIBRARY=#{Formula["metis4"].opt_lib}/libmetis.dylib" if suite_sparse_options.with? "metis4"
    cmake_args << "-DEIGEN_INCLUDE_DIR=#{Formula["eigen"].opt_include}/eigen3"
    system "cmake", ".", *cmake_args
    system "make"
    system "make", "test" if build.with? "test"
    system "make", "install"
    pkgshare.install "examples"
    pkgshare.install "data"
    doc.install "docs/html"
  end
end

__END__
diff --git a/CMakeLists.txt b/CMakeLists.txt
index 25c8ae2..07e39d3 100644
--- a/CMakeLists.txt
+++ b/CMakeLists.txt
@@ -400,12 +400,6 @@ if (NOT CUSTOM_BLAS)
 endif (NOT CUSTOM_BLAS)
 
 if (OPENMP)
-  # Clang does not (yet) support OpenMP.
-  if (CMAKE_CXX_COMPILER_ID STREQUAL "Clang")
-    update_cache_variable(OPENMP OFF)
-    message("-- Compiler is Clang, disabling OpenMP.")
-    list(APPEND CERES_COMPILE_OPTIONS CERES_NO_THREADS)
-  else (CMAKE_CXX_COMPILER_ID STREQUAL "Clang")
     # Find quietly s/t as we can continue without OpenMP if it is not found.
     find_package(OpenMP QUIET)
     if (OPENMP_FOUND)
@@ -424,7 +418,6 @@ if (OPENMP)
       update_cache_variable(OPENMP OFF)
       list(APPEND CERES_COMPILE_OPTIONS CERES_NO_THREADS)
     endif (OPENMP_FOUND)
-  endif (CMAKE_CXX_COMPILER_ID STREQUAL "Clang")
 else (OPENMP)
   message("-- Building without OpenMP (disabling multithreading).")
   list(APPEND CERES_COMPILE_OPTIONS CERES_NO_THREADS)
diff --git a/internal/ceres/CMakeLists.txt b/internal/ceres/CMakeLists.txt
index 5d24a8a..c65609e 100644
--- a/internal/ceres/CMakeLists.txt
+++ b/internal/ceres/CMakeLists.txt
@@ -151,7 +151,7 @@ endif (BLAS_FOUND AND LAPACK_FOUND)
 
 if (OPENMP_FOUND)
   if (NOT MSVC)
-    list(APPEND CERES_LIBRARY_PRIVATE_DEPENDENCIES gomp)
+    list(APPEND CERES_LIBRARY_PRIVATE_DEPENDENCIES /usr/local/opt/llvm/lib/libomp.dylib)
     list(APPEND CERES_LIBRARY_PRIVATE_DEPENDENCIES ${CMAKE_THREAD_LIBS_INIT})
   endif (NOT MSVC)
 endif (OPENMP_FOUND)
