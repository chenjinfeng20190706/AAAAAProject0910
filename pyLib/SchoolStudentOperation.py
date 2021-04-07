import requests,pprint,json
from robot.api import logger
from robot.libraries.BuiltIn import BuiltIn
from cfg import g_vcode

class SchoolStudentOperation:
    URL = "http://ci.ytesting.com/api/3school/students"
    def listStudents(self):
        params = {
            "vcode": g_vcode,
            "action": "search_with_pagenation"
        }
        response = requests.get(self.URL,params=params)
        ret = response.json()
        pprint.pprint(ret)
        return ret
    def addStudent(self,
                   username,
                   realname,
                   gradeid,
                   classid,
                   phonenumber,
                   isSavedId=None
                   ):
        payload = {
            "vcode" : g_vcode,
            "action" : "add",
            "username" : username,
            "realname" : realname,
            "gradeid" : int(gradeid),
            "classid" : int(classid),
            "phonenumber" : phonenumber
        }
        response = requests.post(self.URL,data=payload)
        ret = response.json()
        pprint.pprint(ret)
        if isSavedId:
            print("before")
            BuiltIn().set_global_variable("${%s}"%isSavedId, ret["id"])
            print(f"global var set: ${isSavedId}:{ret['id']}")
        return ret

    def modifyStudent(self,
                      studentId,
                      newRealName=None,
                      newPhoneNumber=None,
                      ):
        url = f"{self.URL}/{studentId}"
        payload = {
            "vcode": g_vcode,
            "action": "modify"
        }
        if newRealName is not None:
            payload["realname"]=newRealName
        if newPhoneNumber is not None:
            payload["phonenumber"]=newPhoneNumber
        response = requests.put(url,data=payload)
        ret = response.json()
        pprint.pprint(ret)
        return ret

    def deleteStudent(self,studentId):
        url = f"{self.URL}/{studentId}"
        payload = {
            "vcode" : g_vcode
        }
        response = requests.delete(url,data=payload)
        ret = response.json()
        pprint.pprint(ret)
        return ret
    def deleteAllStudents(self):
        #删除之前，先列出所有的老师，获得老师的id，再用循环进行删除
        studentList = self.listStudents()
        pprint.pprint(studentList)
        for one in studentList["retlist"]:
            self.deleteStudent(one["id"])
        #删除之后，列出所有老师检查是否全部删除
        studentList = self.listStudents()
        if studentList["retlist"]:
            raise Exception(
                "can not delete all students!!!"
            )

    def studentListShouldContain(self,
                               studentList,
                               classid,
                               username,
                               realname,
                               phonenumber,
                               studentId,
                               exceptedTimes = 1   #用这个exceptedTimes是为了，不包含的
                               # 时候，exceptedTimes=0，就是不包含。
                               ):
        item = {
            "classid": classid,
            "username": username,
            "realname": realname,
            "phonenumber": phonenumber,
            "id": studentId
        }

        pprint.pprint(item)
        occurTimes = studentList.count(item)
        logger.info(f"occur {occurTimes} times")
        logger.info(f"occur {int(exceptedTimes)} times")
        if occurTimes != int(exceptedTimes):
            raise   Exception(
                f"studentList contains {occurTimes} times,except {exceptedTimes} times!!!"
            )
if __name__ == '__main__':
    s1 = SchoolStudentOperation()
    s1.listStudents()
    # addStudet1 = s1.addStudent("shudent007","学生007",1,51958,"18298021850")
    # addStudet2 = s1.addStudent("shudent008","学生008",1,51958,"18298021850")

    # s1.modifyStudent(5232,"学生008","88888888888")
    # s1.deleteStudent(5232)
    s1.deleteAllStudents()
    ret = s1.listStudents()
    # studentList = ret["retlist"]
    # s1.studentListShouldContain(studentList,51958,"shudent007","学生007","18298021850",addStudet1["id"])




