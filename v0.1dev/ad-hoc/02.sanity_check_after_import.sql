-- run these checks to see if data looks bad

-- no grades for students should be without leading zeros
-- results should be zero
select * from import_students where grade in ('3','4','5','6','7','8','9');

-- homerooms for students should be 3 digit room number
select * from import_students where not (upper(homeroom) REGEXP '^-?[0-9]+$');

-- homerooms for employees should be 3 digit room number, or "OFF" or "A" & then number
select *
  from import_employees
  where (
    (not (upper(homeroom) REGEXP '^-?[0-9]+$'))
     and
    ((substring(upper(homeroom),1,1) != 'A')
      and (substring(upper(homeroom),1,3) != 'OFF')
      and (substring(upper(homeroom),1,5) != 'NURSE')
      and (substring(upper(homeroom),1,6) != 'RECEPT')
    )
  )

-- get list of users that are of "classes" of users that exist in live data, but not in import
--  * can ignore users in live data that status = 'INACTIVE'
--  * can ignore users in live data that manual_entry != 'N'
select * from users
