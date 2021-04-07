*** Settings ***
Library   pyLib.SchoolClassOperation
Library   pyLib.SchoolTeacherOperation
Suite Setup     run keywords  deleteAllTeachers    AND     deleteAllClasses
Suite Teardown  run keywords  deleteAllTeachers    AND     deleteAllClasses