*** Settings ***
Library     pyLib.SchoolStudentOperation
Variables   cfg.py

*** Test Cases ***
添加学生1：tc002002
    ${retAdd}   addStudent      wangshufen    王淑芬     2    ${class_8g_1c_id}    13088888888
    should be true  $retAdd["retcode"]==0

    ${retList}  listStudents
    log to console  ${retlist}
    ${studentList}  evaluate  $retList["retlist"]
    log to console  ${studentList}
    studentListShouldContain  ${studentList}    ${class_8g_1c_id}   wangshufen    王淑芬
                       ...    13088888888       &{retAdd}[id]
    [Teardown]  deleteStudent    &{retAdd}[id]
删除学生1：tc002081
    #在添加学生，再删除该学生之前，列出学生
    ${listBeforeDelete}     listStudents
    #添加一个学生用来删除的
    ${retAdd}   addStudent      wangshufen    王淑芬     2    ${class_8g_1c_id}    13088888888
    should be true  $retAdd["retcode"]==0
    #删除学生操作
    ${retDelete}    deleteStudent  &{retAdd}[id]
    should be true  $retDelete["retcode"]==0
    #在删除该学生之后再列出学生，和前面列出的要一致
    ${listAfterDelete}     listStudents
    should be true  $listBeforeDelete==$listAfterDelete