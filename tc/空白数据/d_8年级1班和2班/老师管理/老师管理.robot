*** Settings ***
Library  pyLib.SchoolTeacherOperation
Variables  cfg.py
*** Test Cases ***
添加老师1:tc001001

    ${retAdd}  addTeacher  chenjinfeng     陈锦峰     ${g_subject_math_id}   ${class_8g_1c_id} ${class_8g_2c_id}   13691845359
    ...     354440717@qq.com    360782199305203518        teacherId
    should be true  $retAdd["retcode"] == 0

    ${ret}  listTeachers
    ${retList}  evaluate  $ret["retlist"]
    #log to console  ${retList}
    should be true  $retList[0]["username"]=="chenjinfeng"
    should be true  $retList[0]["teachclasslist"]==[$class_8g_1c_id,$class_8g_2c_id]
    should be true  $retList[0]["realname"]=="陈锦峰"
    should be true  $retList[0]["id"]==$retAdd["id"]
    should be true  $retList[0]["phonenumber"]=="13691845359"
    should be true  $retList[0]["email"]=="354440717@qq.com"
    should be true  $retList[0]["idcardnumber"]=="360782199305203518"
    [Teardown]      deleteTeacher  ${teacherId}



