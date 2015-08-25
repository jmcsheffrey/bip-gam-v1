-- run these checks to see if data looks bad

-- no grades for students should be without leading zeros
-- results should be zero
select * from import_students where grade in ('3','4','5','6','7','8','9');
