-- changes to be replicated on other systems
ALTER TABLE  `users_stuviewers` DEFAULT CHARACTER SET utf8 COLLATE utf8_general_ci;
ALTER TABLE  `users` ADD  `referredto_name` VARCHAR( 100 ) NOT NULL ;
ALTER TABLE  `sync_status_user` CHANGE  `unique_id`  `unique_id_user` VARCHAR( 8 ) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL ;
ALTER TABLE  `sync_status_user` CHANGE  `sync_dest_it`  `sync_dest_id` INT( 11 ) NOT NULL ;
ALTER TABLE  `systems` CHANGE  `InternalSystemsID`  `unique_id` INT( 11 ) NOT NULL AUTO_INCREMENT ;
ALTER TABLE  `systems` CHANGE  `Class`  `MachineClass` VARCHAR( 50 ) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL ;
ALTER TABLE  `systems` CHANGE  `Type`  `MachineType` VARCHAR( 50 ) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL ;
CREATE TABLE `sync_config` (
 `config_name` varchar(20) CHARACTER SET latin1 NOT NULL,
 `config_value` varchar(250) CHARACTER SET latin1 NOT NULL,
 PRIMARY KEY (`config_name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
CREATE TABLE `groups` (
 `unique_id` varchar(8) CHARACTER SET latin1 NOT NULL,
 `name` varchar(100) CHARACTER SET latin1 NOT NULL,
 `group_name` varchar(100) CHARACTER SET latin1 NOT NULL,
 `group_email` varchar(100) CHARACTER SET latin1 NOT NULL,
 PRIMARY KEY (`unique_id`),
 UNIQUE KEY `unique_id` (`unique_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
CREATE TABLE `groups_members` (
 `unique_id_group` varchar(8) CHARACTER SET latin1 NOT NULL,
 `unique_id_user` varchar(8) CHARACTER SET latin1 NOT NULL,
 `member_type` varchar(3) CHARACTER SET latin1 NOT NULL,
 PRIMARY KEY (`unique_id_group`,`unique_id_user`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
