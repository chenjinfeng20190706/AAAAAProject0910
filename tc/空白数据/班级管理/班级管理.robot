*** Settings ***
Library     pyLib.SchoolClassOperation
Variables   cfg.py

*** Test Cases ***
添加班级1:tc000001
    ${retAdd}     addClass    ${g_grade8_id}   3班  60
    should be true  $retAdd['retcode']==0
    ${ret}  listClasses  2
    ${retList}  evaluate  $ret["retlist"]
#    classListShouldContain      ${retList}
#    ...     3班      八年级     &{retAdd}[invitecode]
#    ...     60       0         &{retAdd}[id]
#一起执行的时候就不能用这个来判断了。不是这个问题，是自己后面有添加班级的覆盖了初始化环境里面其中的8年级二班的id，导致d_8年级1班和2班清除的时候删除不来2班的！！！自己挖的坑，但是学会了分析啊。
    should be true  $retList[0]["id"]==$retAdd["id"]
    should be true  $retList[0]["invitecode"]==$retAdd["invitecode"]
    should be true  $retList[0]["name"]=="3班"
    should be true  $retList[0]["grade__name"]=="八年级"
    should be true  $retList[0]["studentlimit"]==60
    should be true  $retList[0]["studentnumber"]==0
    should be true  $retList[0]["teacherlist"]==[]
    [Teardown]  deleteClass  &{retAdd}[id]
修改班级3：tc000053
    ${retModify}    modifyClass     88888888     不存在的班级  100
    #log  &{retModify}[retcode]     测试用
    should be true  $retModify["retcode"]==404
    #log  &{retModify}[reason]      测试用
    should be true  $retModify["reason"]=="id 为`88888888`的班级不存在"
删除班级1：tc000081
    ${retDelete}    deleteClass     88888888
    #log  &{retDelete}[retcode]     测试用
    should be true  $retDelete["retcode"]==404
    #log  &{retDelete}[reason]     测试用
    should be true  $retDelete["reason"]=="id 为`88888888`的班级不存在"

