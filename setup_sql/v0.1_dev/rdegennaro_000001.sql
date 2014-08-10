ALTER TABLE  `users_stuviewers` DEFAULT CHARACTER SET utf8 COLLATE utf8_general_ci;
ALTER TABLE  `users` ADD  `referredto_name` VARCHAR( 100 ) NOT NULL ;
ALTER TABLE  `sync_status_user` CHANGE  `unique_id`  `unique_id_user` VARCHAR( 8 ) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL ;
ALTER TABLE  `sync_status_user` CHANGE  `sync_dest_it`  `sync_dest_id` INT( 11 ) NOT NULL ;
ALTER TABLE  `systems` CHANGE  `InternalSystemsID`  `unique_id` INT( 11 ) NOT NULL AUTO_INCREMENT ;
ALTER TABLE  `systems` CHANGE  `Class`  `MachineClass` VARCHAR( 50 ) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL ;
ALTER TABLE  `systems` CHANGE  `Type`  `MachineType` VARCHAR( 50 ) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL ;
