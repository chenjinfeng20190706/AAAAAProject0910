*** Settings ***
Library  pyLib.SchoolTeacherOperation
Variables  cfg.py
*** Test Cases ***
添加老师2:tc001002
    #用例2还没有实现
    ${retAdd}   addTeacher  kongziiii    孔子     ${g_subject_science_id}   ${class_8g_1c_id} ${class_8g_2c_id}  13564854529
    ...     488362431@qq.com    36078219952183527        teacher_kongzi_Id
    should be true  $retAdd["retcode"] == 0

    ${ret}  listTeachers
    ${retList}  evaluate  $ret["retlist"]
    log to console  ${retList}
    teacherListShouldContain  ${retList}
    ...     kongziiii
    ...     ${class_8g_1c_id} ${class_8g_2c_id}
    ...     孔子
    ...     &{retAdd}[id]
    ...     13564854529
    ...     488362431@qq.com
    ...     36078219952183527
    [Teardown]  deleteTeacher  ${teacher_kongzi_Id}
添加老师3:tc001003
    #添加之前列出所有的老师
    ${retListTeacherBefore}     listTeachers

    ${retAdd}   addTeacher  zhuangzi     同名庄子     ${g_subject_science_id}   ${class_8g_1c_id} ${class_8g_2c_id}  13559421526
    ...     1127668247@qq.com    360782199602183527
    should be true  $retAdd["retcode"]==1
    should be true  $retAdd["reason"]=="登录名 zhuangzi 已经存在"

    #添加之之后列出所有的老师
    ${retListTeacherAfter}     listTeachers

    # 添加前后进行比较，列出的老师是一致的
    should be true  $retListTeacherBefore==$retListTeacherAfter
修改老师1：tc001051
    #修改前列出所有的老师
    ${retBeforeModify}  listTeachers

    #修改一个id号不存在的老师
    ${retModify}    modifyTeacher   88888888    真实姓名    ${g_subject_science_id}   49132 49133 49134 49135     电话号码
    ...     邮箱地址        身份证号

    #修改结果的判断
#    log to console  &{retModify}[retcode]
    should be true  $retModify["retcode"]==1
#    log to console  &{retModify}[reason]
    should be true  $retModify["reason"]=="id 为`88888888`的老师不存在"
    #接口文档里面给出的" id 为`88888888`的老师不存在"，注意id前面的那个空格。

    #修改之后再列出老师
    ${retafterModify}  listTeachers
    #判断前后要一致
    should be equal     ${retBeforeModify}    ${retafterModify}
修改老师2：tc001052
    #添加一个老师，用来做修改操作
    ${retAdd}   addTeacher  kongzi888666    孔子     ${g_subject_science_id}   ${class_8g_1c_id}  13564854529     488362431@qq.com    36078219952183527
    should be true  $retAdd["retcode"]==0
    log to console  &{retAdd}[id]
    ${temp}     listTeachers
    log to console  ${temp}

    #所有的参数全部传过去
#    ${retModify}    modifyTeacher   &{retAdd}[id]    孔子000000
#    ...             ${g_subject_math_id}
#    ...             ${class_8g_1c_id} ${class_8g_2c_id}
#    ...             13564854529
#    ...             488362431@qq.com
#    ...             36078219952183527

     #按照缺省的方式传参数
    ${retModify}    modifyTeacher   &{retAdd}[id]
    ...             newName=孔子000000
    ...             newSubjectId=${g_subject_math_id}
    ...             newClassList=${class_8g_1c_id} ${class_8g_2c_id}
    ...             newPhoneNumber=13564854529
    ...             newEmail=488362431@qq.com
    ...             newIdcardNumber=36078219952183527

    #要确定一下这样可不可以这样子传，还是直接就newClassList=${class_8g_1c_id} ${class_8g_2c_id}
    log to console  ${retModify}
    should be true  $retModify["retcode"]==0

    ${ret}  listTeachers
    ${retList}  evaluate  $ret["retlist"]
    log to console  ${retList}
    teacherListShouldContain  ${retList}
    ...     kongzi888666
    ...     ${class_8g_1c_id}
    ...     孔子000000
    ...     &{retAdd}[id]
    ...     13564854529
    ...     488362431@qq.com
    ...     36078219952183527
    [Teardown]  deleteTeacher   &{retAdd}[id]
删除老师1:tc001081
    #删除一个不存在的老师，就让老师的id为88888888吧
    #删除之前列出所有的老师
    ${retTeacherListBeforeDelete}   listTeachers

    #删除id为88888888(不存在)的老师
    ${ret}      deleteTeacher       88888888
    should be true  $ret["retcode"]==404
    should be true  $ret["reason"]=="id 为`88888888`的老师不存在"

    #删除之后列出所有的老师
    ${retTeacherListAfterDelete}   listTeachers
    #删除前后列出老师一致
    should be true      $retTeacherListBeforeDelete==$retTeacherListAfterDelete
删除老师2:tc001082
    #新添加一个老师，用来删除的
    ${retAdd}   addTeacher  fordelete     用来删除的     5   ${class_8g_1c_id} ${class_8g_2c_id}  15201326215
    ...     5214216359@qq.com    360782199102183527        teacher_fordelete_Id
    should be true  $retAdd["retcode"] == 0

    #根据id号删除该老师
    ${ret}  deleteTeacher   ${teacher_fordelete_Id}
#    log to console  ${ret}
    should be true  $ret["retcode"]==0

    #列出老师，判断刚才删除的老师不在列出的老师列表里面
    ${ret}  listTeachers
    ${retList}  evaluate  $ret["retlist"]
#    log to console  ${retList}
    teacherListShouldContain  ${retList}
    ...     fordelete
    ...     ${class_8g_1c_id} ${class_8g_2c_id}
    ...     用来删除的
    ...     &{retAdd}[id]
    ...     15201326215
    ...     5214216359@qq.com
    ...     360782199102183527
    ...     0
