-- be sure to import employee and student information
--   * unique_id is a unique column, so watch for errors in import.
--   * no classes/groupings yet.


-- the stuff below is just scratch so I don't loose it

truncate import_students
truncate import_employees

insert into users
  select `unique_id`, `status`, 'N' as `manual_entry`, 'STU' as `population`, `first_name`, `middle_name`, `last_name`,
    concat(lower(first_name), '_', lower(last_name)) as `user_name`,
    concat(lower(first_name), '_', lower(last_name), '@student.sscps.org') as `school_email`,
    `grade`, `homeroom`, `referred_to_as`, `gender`,
    STR_TO_DATE(`birthdate`,'%m/%d/%Y'),
    STR_TO_DATE(`entry_date`,'%m/%d/%Y'),
    '' as position,
    concat('SSCSPS Grade ', `grade`, ' Student') as description
  from import_students
  where `grade` in ('04','05','06','07','08','09','10','11','12')
  order by grade, last_name, first_name, middle_name;

insert into users
  select `unique_id`, `status`, 'N' as `manual_entry`, 'STU' as `population`, `first_name`, `middle_name`, `last_name`,
    concat (lower(substring(first_name,1,1)), lower(last_name)) as `user_name`,
    concat (lower(substring(first_name,1,1)), lower(last_name), '@sscps.org') as `school_email`,
    '' as `grade`, `homeroom`, `referred_to_as`, `gender`,
    STR_TO_DATE(`birthdate`,'%m/%d/%Y'),
    STR_TO_DATE(`date_of_hire`,'%m/%d/%Y'),
    position,
    'SSCSPS Employee' as description
  from import_employees
  order by last_name, first_name, middle_name;

SELECT * FROM `users` where population = 'STU' order by school_email
