-- get list of users that are of "classes" of users that exist in live data, but not in import
--  * can ignore users in live data that status = 'INACTIVE'
--  * can ignore users in live data that manual_entry != 'N'
select * from users

-- get list of new ID's by comparing import_ with users
select * from users
