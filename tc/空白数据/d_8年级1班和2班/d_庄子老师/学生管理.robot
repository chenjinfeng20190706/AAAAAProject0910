*** Settings ***
Library     pyLib.SchoolStudentOperation
Variables   cfg.py

*** Test Cases ***
添加学生1：tc002001
    ${retAdd}   addStudent      wangshufen    王淑芬     2    ${class_8g_1c_id}    13585215269
    should be true  $retAdd["retcode"]==0

    ${retList}  listStudents
    log to console  ${retlist}
    ${studentList}  evaluate  $retList["retlist"]
    log to console  ${studentList}
    studentListShouldContain  ${studentList}    ${class_8g_1c_id}   wangshufen    王淑芬
                       ...    13585215269       &{retAdd}[id]
    [Teardown]  deleteStudent    &{retAdd}[id]
