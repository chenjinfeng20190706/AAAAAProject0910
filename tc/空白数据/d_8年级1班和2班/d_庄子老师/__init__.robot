*** Settings ***
Library  pyLib.SchoolTeacherOperation
Variables  cfg.py
Suite Setup     addTeacher  zhuangzi     庄子     ${g_subject_math_id}   ${class_8g_1c_id}  13691845359
    ...     354440717@qq.com    360782199305203518        teacherId
Suite Teardown  deleteTeacher   ${teacherId}