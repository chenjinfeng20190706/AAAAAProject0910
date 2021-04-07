*** Settings ***
Library   pyLib.SchoolClassOperation
Variables  cfg.py
*** Test Cases ***
添加班级2:tc000002
    ${retAdd}   addClass    ${g_grade8_id}   3班  80
    should be true  $retAdd['retcode']==0

    ${ret}  listClasses
#    ${retList}  evaluate  $ret["retlist"]
#    classListShouldContain      ${retList}
    classListShouldContain      &{ret}[retlist]
    ...     3班      八年级     &{retAdd}[invitecode]
    ...     80       0          &{retAdd}[id]
    # 特别注意：根据字典的键取值要用&！！！！！！！！！！！！！！！而且不需要引号！！！！！！
    [Teardown]  deleteClass    &{retAdd}[id]
添加班级3:tc000003
    # 最好的检查方式是：在增加之前列出班级，在增加之后再次列出班级，前后是一致的。
    ${retAdd}   addClass    ${g_grade8_id}   1班  80
    log     &{retAdd}[retcode]
    should be true  $retAdd["retcode"]==1
    log     &{retAdd}[reason]
    should be true  $retAdd["reason"]=="duplicated class name"

    ${ret}  listClasses
    ${retList}  evaluate  $ret["retlist"]
    classListShouldContain      ${retList}
    ...     1班      八年级     &{retAdd}[invitecode]
    ...     80       0         &{retAdd}[id]
#    [Teardown]  deleteClass    &{retAdd}[id]     可以不用删除了，因为本来也没有添加成功！
修改班级1：tc000051
    #增加一个班级用来修改的
    ${retAdd}   addClass    ${g_grade8_id}   3班  80  needModifyClassId   #这里只用了一次，好像也没什么必要
    should be true  $retAdd['retcode']==0
    #修改班级
    ${retModify}    modifyClass     ${needModifyClassId}    xin二班   60
    should be true  $retModify["retcode"]==0
    #列出班级，检查是否修改成功
    ${ret}  listClasses
    ${retList}  evaluate  $ret["retlist"]
    classListShouldContain  ${retList}
    ...     xin二班      八年级     &{retAdd}[invitecode]
    ...     60       0          &{retAdd}[id]
    [Teardown]  deleteClass    &{retAdd}[id]
修改班级2：tc000052
    #跟直播的时候确定一下这个用例是fail的。


    #增加一个班级用来修改的
    ${retAdd}   addClass    ${g_grade8_id}   3班  80
    should be true  $retAdd['retcode']==0
    ${classId}  evaluate  $retAdd["id"]
    #修改之前列出一下系统中的班级
    ${modifyBefore}     listClasses
    #修改班级，修改的班级名字和8年级1班的班级名字相同
    ${retModify}    modifyClass     ${classId}    1班   80
    log  &{retModify}[retcode]
    should be true  $retModify["retcode"]==1
    log  &{retModify}[reason]
    should be true  $retModify["reason"]=="duplicated class name"
    #修改之后列出一下系统中的班级
    ${modifyAfter}     listClasses

    #修改前后列出的班级是一致的
    should be true  $modifyBefore==$modifyAfter
    [Teardown]  deleteClass  ${classId}
删除班级2：tc000082
    #添加一个班级用来删除的
    ${retAdd}   addClass    ${g_grade8_id}   3班  80  class_8g3c_id
    should be true  $retAdd['retcode']==0
    #列出班级，刚才添加的班级在列出的班级里面
    ${ret}  listClasses
    ${retList}  evaluate  $ret["retlist"]
    classListShouldContain      ${retList}
    ...     3班      八年级     &{retAdd}[invitecode]
    ...     80       0         &{retAdd}[id]
    #删除刚才添加的班级
    ${ret}  deleteClass     ${class_8g3c_id}
    should be true  $ret["retcode"]==0

    #列出班级，刚才添加的班级不在列出的班级里面了
    ${ret}  listClasses
    ${retList}  evaluate  $ret["retlist"]
    classListShouldContain      ${retList}
    ...     3班      八年级     &{retAdd}[invitecode]
    ...     80       0         &{retAdd}[id]    0







