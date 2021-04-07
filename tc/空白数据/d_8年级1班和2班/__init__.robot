*** Settings ***
Library   pyLib.SchoolClassOperation
Library  pyLib.SchoolTeacherOperation
Variables  cfg.py
Suite Setup  run keywords  addClass    ${g_grade8_id}    1班   60    class_8g_1c_id
             ...     AND   addClass    ${g_grade8_id}    2班   80    class_8g_2c_id
#我初始化新添加了一个班级（8年级1班），在进入这个环境之前是空环境，我离开这个环境也应该保持这样
#的环境(注意：用删除全部的课程不合适)----所以我要删除刚才添加的这门课程，根据id来删除，但是id是
#addClass返回来的，在Settings表中，又不能用一个变量来保接收返回值，所以需要一个RF层面的全局变量！
#在addClass函数中实现。
Suite Teardown      run keywords    deleteClass     ${class_8g_1c_id}
                    ...     AND     deleteClass     ${class_8g_2c_id}