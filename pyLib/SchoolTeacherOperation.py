import requests,pprint,json
from robot.api import logger
from robot.libraries.BuiltIn import BuiltIn

from cfg import g_vcode
class SchoolTeacherOperation:
    URL = "http://ci.ytesting.com/api/3school/teachers"
    def listTeachers(self,subjectid=None):
        # 可以优化！增加字典的键值对
        params = {
            "vcode": g_vcode,
            "action": "search_with_pagenation"
        }
        if subjectid:
            params = {"subjectid": subjectid}
        """
        if subjectid:
            params = {
                "vcode" : g_vcode,
                "action" : "search_with_pagenation",
                "subjectid" : subjectid
            }
        else :
            params = {
                "vcode": g_vcode,
                "action": "search_with_pagenation"
            }
        """
        response = requests.get(self.URL,params=params)
        ret = response.json()
        pprint.pprint(ret)
        return ret
    def addTeacher(self,
                   userName,
                   realName,
                   subjectid,
                   classlist,   #传这样的字符串    " 230, 231      ,232"
                   phoneNumber,
                   email,
                   idcardNumber,
                   isSavedId=None
                   ):
        # 对传进来的classlist进行处理
        temp = str(classlist).split(" ")
        # 下面的代码可以直接用列表生成式实现
        classListTemp = [{"id":int(oneid)} for oneid in temp if oneid !='']
        """
        classListTemp = []
        for one in temp:
            if one!='':
                temp = {"id":int(one)}
                # print(temp)
                classListTemp.append(temp)
                print(classListTemp)
        """
        #教授班级ID列表，是json格式的字符串    [[{"id":230},{"id":231}]]
        #列表格式的数据转换成json格式的字符串
        classList = json.dumps(classListTemp)
        payload = {
            "vcode" : g_vcode,
            "action" : "add",
            "username" : userName,
            "realname" : realName,
            "subjectid" : subjectid,
            "classlist" : classList,
            "phonenumber" : phoneNumber,
            "email" : email,
            "idcardnumber" : idcardNumber
        }
        response = requests.post(self.URL,data=payload)
        pprint.pprint(response.text)
        ret = response.json()
        pprint.pprint(ret)
        if isSavedId:
            print("before")
            BuiltIn().set_global_variable("${%s}"%isSavedId, ret["id"])
            print(f"global var set: ${isSavedId}:{ret['id']}")
        return ret

    # 修改老师的信息是可选参数，所以按照缺省值来传，在代码里面实现如果传进来的不为空
    # 就要放在payload这个字典对象里面。
    def modifyTeacher(self,
                      teacherId,
                      newRealName=None,
                      newSubjectId=None,
                      newClassList=None,
                      newPhoneNumber=None,
                      newEmail=None,
                      newIdcardNumber=None
                      ):
        url = f"{self.URL}/{teacherId}"
        payload = {
            "vcode": g_vcode,
            "action": "modify"
        }
        if newRealName is not None:
            payload["realname"]=newRealName
        if newSubjectId is not None:
            payload["subjectid"]=newSubjectId
        if newClassList is not None:
        # 对传进来的classlist进行处理
            temp = str(newClassList).split(" ")
            # newClassListTemp = [{"id":int(one)} for one in temp]

            newClassListTemp = []
            for one in temp:
                temp = {"id": int(one)}
                # print(temp)
                newClassListTemp.append(temp)
                print(newClassListTemp)

            # 教授班级ID列表，是json格式的字符串    [{"id":230},{"id":231}]
            # 列表格式的数据转换成json格式的字符串
            newClassList = json.dumps(newClassListTemp)
            payload["classlist"]=newClassList
        if newPhoneNumber is not None:
            payload["phonenumber"]=newPhoneNumber
        if newEmail is not None:
            payload["email"]=newEmail
        if newIdcardNumber is not None:
            payload["idcardnumber"]=newIdcardNumber

        response = requests.put(url,data=payload)
        print(response.text)
        ret = response.json()
        pprint.pprint(ret)
        return ret

    def deleteTeacher(self,teacherId):
        url = f"{self.URL}/{teacherId}"
        payload = {
            "vcode" : g_vcode
        }
        response = requests.delete(url,data=payload)
        ret = response.json()
        pprint.pprint(ret)
        return ret
    def deleteAllTeachers(self):
        #删除之前，先列出所有的老师，获得老师的id，再用循环进行删除
        teacherList = self.listTeachers()
        pprint.pprint(teacherList)
        for one in teacherList["retlist"]:
            self.deleteTeacher(one["id"])
        #删除之后，列出所有老师检查是否全部删除
        teacherList = self.listTeachers()
        if teacherList["retlist"]:
            raise Exception(
                "can not delete all teachers!!!"
            )


    # 这里也好像有报错--已经调试好。函数实现没问题，在用例中传老师的id的时候需要从添加老师的
    # 返回值获取，字典中取出键为id的值，注意是&{retAdd}[id]，而不是${retAdd}["id"]
    def teacherListShouldContain(self,
                               teacherList,
                               userName,
                               teachClassList,      #addTeacher的时候传进去是"43295 43296 43297"
                                                    #在列出老师中的响应格式是[43295,43296,43297]
                               realName,
                               teacherId,
                               phoneNumber,
                               email,
                               idcardNumber,
                               exceptedTimes = 1   #用这个exceptedTimes是为了，不包含的
                               # 时候，exceptedTimes=0，就是不包含。
                               ):
        # teachClassList需要处理成[230, 231]的样子
        temp = str(teachClassList).split(" ")
        # 这里又是可以用列表生成式来实现的，为啥我就不会用呢？？？？？？
        # teachClassList = [int(one) for one in temp]
        teachClassList = []
        for one in temp:
            one = int(one)
            teachClassList.append(one)
            pprint.pprint(teachClassList)
        item = {
            "username": userName,
            "teachclasslist": teachClassList,
            "realname": realName,
            "id": int(teacherId),
            "phonenumber": phoneNumber ,
            "email": email,
            "idcardnumber": idcardNumber
        }
        pprint.pprint(item)
        occurTimes = teacherList.count(item)
        logger.info(f"occur {occurTimes} times")
        logger.info(f"occur {int(exceptedTimes)} times")
        if occurTimes != int(exceptedTimes):
            raise   Exception(
                f"teacherlist contains {occurTimes} times,except {exceptedTimes} times!!!"
            )
if __name__ == '__main__':
    s1 = SchoolTeacherOperation()
    temp1 = s1.listTeachers()
    temp11 = s1.addTeacher("chenjinfeng","陈锦峰",1,"55245 55245 55245","15852152152","565485245@qq,com","360782199502122518")
    # temp22 = s1.addTeacher("chenjinfeng111","陈锦峰111",5,"43458 43459 43460","13521021525","36595428@qq,com","360782188502283512")
    # s1.deleteAllTeachers()
    # s1.modifyTeacher(11782,"陈锦峰111",2,"42584","911","110@qq,com","360782199204203527")
    # temp2 = s1.listTeachers()["retlist"]
    # pprint.pprint(temp2)
    # s1.teacherListShouldContain(temp2,"chenjinfeng","43458 43459 43460","陈锦峰",temp11["id"],"15852152152","565485245@qq,com", "360782199502122518")
    # s1.listTeachers()
    # s1.deleteTeacher(12109)
#userName, realName, subjectid, classlist, phoneNumber, email, idcardNumber
# teacherId, newRealName = None, newSubjectId = None, newClassList = None, newPhoneNumber = None, newEmail = None, newIdcardNumber = None
    s1.modifyTeacher(temp11["id"],"陈锦峰666",5,"55245 55245 55245 55248","XXXXXXXX","yyyyy@qq.com","zzzzzzzzzzzzzz")
    s1.listTeachers()


