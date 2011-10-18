# The MIT License
#
# Copyright (c) 2011 daniperez
# 
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
# 
# The above copyright notice and this permission notice shall be included in
# all copies or substantial portions of the Software.
# 
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
# THE SOFTWARE.
#

# -------------------------------------------------------------------
# add_doxygen_test_suite
# -------------------------------------------------------------------
#
# add_doxygen_test_suite - Adds a test that checks that doxygen is well formed. 
#
#  add_doxygen_test_suite () 
#
macro ( add_doxygen_test_suite )

    if ( UNIX )

        add_test (
                   NAME "DoxygenErrors" 
                   WORKING_DIRECTORY ${PROJECT_SOURCE_DIR}
                   COMMAND "${CMAKE_SOURCE_DIR}/scripts/doxytest.sh"
                           "${DOXYGEN_EXECUTABLE}"
                           "${DOXYFILE}"
                 )
    endif ()

endmacro ()

# -------------------------------------------------------------------
# solve_instance 
# -------------------------------------------------------------------
#
# solve_instance - Solves an instance and checks the solution. 
#
#  solve_instance ( NAME MODEL INITIAL_SOLUTION SOLUTION CMD_ARGS ) 
#
# TARGET is the executable to execute. CHECKER_TARGET is the executable of
# the checker. NAME is the name of the instance to solve. MODEL is the
# parameters of the problem as per ROADEF's specs.
# INITIAL_SOLUTION is the initial feasible solution. SOLUTION is the output
# file to write. Finally, CMD_ARGS are other arguments to append to TARGET call.
#
macro ( solve_instance TARGET CHECKER_TARGET NAME MODEL INITIAL_SOLUTION SOLUTION CMD_ARGS )

    add_test ( NAME "testsuite-${NAME}-solution" 
               COMMAND "${TARGET}"
                       "-p" "${MODEL}"
                       "-i" "${INITIAL_SOLUTION}"
                       "-o" "${SOLUTION}"
                       "${CMD_ARGS}" )

    add_test ( NAME "testsuite-${NAME}-solution-check" 
               COMMAND "${CHECKER_TARGET}"
                       "${MODEL}"
                       "${INITIAL_SOLUTION}"
                       "${SOLUTION}" )
    
    # ${NAME} target writes log messages whereas "check" doesn't
    # (only in case of failure)
    add_custom_target (
               "${NAME}"
               COMMAND ${CMAKE_CTEST_COMMAND}
                       -V
                       -R "testsuite-${NAME}-solution"
                       -E "testsuite-${NAME}-solution-check"
               DEPENDS MainTestSuite ExampleMain )
endmacro ()

find_path ( ROADEF11COMMON_INCLUDE_DIR "Service.hpp" PATHS "roadef11-common/service/" NO_DEFAULT_PATH )

mark_as_advanced ( ROADEF11COMMON_INCLUDE_DIR )