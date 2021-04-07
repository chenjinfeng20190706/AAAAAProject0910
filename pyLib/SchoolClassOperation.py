import requests,pprint
from cfg import g_vcode
from robot.api import logger
from robot.libraries.BuiltIn import BuiltIn
class SchoolClassOperation:

    URL = "http://ci.ytesting.com/api/3school/school_classes"

    def listClasses(self,gradeId=None):
        if  gradeId:
            params = {
                "vcode":g_vcode,
                "action":"list_classes_by_schoolgrade",
                "gradeid":int(gradeId)
            }
        else:
            params = {
                "vcode": g_vcode,
                "action": "list_classes_by_schoolgrade",
            }
        response = requests.get(self.URL,params=params)
        ret = response.json()
        pprint.pprint(ret)
        return ret

    def addClass(self,gradeId,className,studentLimit,idSavedName=None):
        payload = {
            "vcode" : g_vcode,
            "action" : "add",
            "grade" : int(gradeId),
            "name"  : className,
            "studentlimit" : int(studentLimit)
        }
        response = requests.post(self.URL,data=payload)
        ret = response.json()
        pprint.pprint(ret)

        if idSavedName:
            print("before")
            BuiltIn().set_global_variable("${%s}"%idSavedName,ret["id"])
            print(f"global var set: ${idSavedName}:{ret['id']}")

        return ret

    def modifyClass(self,classId,newName,newStudentLimit):
        url = f"{self.URL}/{classId}"
        payload = {
            "vcode" : g_vcode,
            "action" : "modify",
            "name" : newName,
            "studentlimit" : int(newStudentLimit),
        }
        response = requests.put(url,data=payload)
        ret = response.json()
        pprint.pprint(ret)
        return ret
    def deleteClass(self,classId):
        #url = f"{self.URL}/{int(classId)}"  本来就是字符串来的，不管classid以什么方式传进来最终都是字符串
        url = f"{self.URL}/{classId}"
        payload = {
            "vcode":g_vcode
        }
        response = requests.delete(url,data=payload)
        ret = response.json()
        pprint.pprint(ret)
        return ret
    def deleteAllClasses(self):
        # 先列出所有的班级，根据id进行删除
        deleteBeforeRet = self.listClasses()
        pprint.pprint(deleteBeforeRet,indent=2)
        # 删除列出的所有的班级
        classes = deleteBeforeRet["retlist"]
        for one in classes:
            self.deleteClass(one["id"])
        #再列出所有的班级，检查是否全部删除干净
        deleteAfterRet = self.listClasses()
        if deleteAfterRet["retlist"]:
            raise Exception(
                "cannot delete all school classes!!!"
            )
    def classListShouldContain(self,
                               classList,
                               className,
                               grade,
                               invitecode,
                               studentLimit,
                               studentNumber,
                               classId,
                               exceptedTimes = 1   #用这个exceptedTimes是为了，不包含的
                               # 时候，exceptedTimes=0，就是不包含。
                               ):
        item = {
            "name": className,
            "grade__name": grade,
            "invitecode": invitecode,
            "studentlimit": int(studentLimit),
            "studentnumber": int(studentNumber),
            "id": classId,
            "teacherlist": []
        }
        occurTimes = classList.count(item)
        logger.info(f"occur {occurTimes} times")
        logger.info(f"occur {int(exceptedTimes)} times")
        if occurTimes != int(exceptedTimes):
            raise   Exception(
                f"classlist contains {occurTimes} times,except {exceptedTimes} times!!!"
            )

if __name__ == '__main__':
    s1 = SchoolClassOperation()
    # pprint.pprint(s1.listClasses())
    # s1.addClass(1,"1班",60)
    # s1.addClass(1,"2班",70)
    # s1.addClass(1,"3班",80)
    s1.addClass(1,"4班",90)
    # pprint.pprint(s1.listClasses())
    # s1.deleteAllClasses()
    # pprint.pprint(s1.listClasses())
    # s1.modifyClass(42277,"xin二班",80)
    # pprint.pprint(s1.listClasses())
