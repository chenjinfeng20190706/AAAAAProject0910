*** Settings ***
Library  pyLib.SchoolStudentOperation
Variables  cfg.py
Suite Setup     addStudent      zhugekongming    诸葛孔明     ${g_grade8_id}    ${class_8g_1c_id}
                        ...     13585215269      studentId
Suite Teardown  deleteStudent  ${studentId}