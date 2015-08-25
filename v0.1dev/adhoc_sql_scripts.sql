#stuff for "down & dirty" workings on the database
insert into staging_students select * from import_students where grade in ('3','4',)
  
