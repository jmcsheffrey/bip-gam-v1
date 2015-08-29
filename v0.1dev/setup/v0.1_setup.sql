-- TODO:  Need to re add user, import_, stagin_, changes_ tables
CREATE TABLE `import_employees` (
 `PKEY` int(11) NOT NULL AUTO_INCREMENT,
 `APID` varchar(5) DEFAULT NULL,
 `full_name` varchar(100) DEFAULT NULL,
 `unique_id` varchar(8) DEFAULT NULL,
 `status` varchar(8) DEFAULT NULL,
 `first_name` varchar(50) DEFAULT NULL,
 `middle_name` varchar(50) DEFAULT NULL,
 `last_name` varchar(50) DEFAULT NULL,
 `school_email` varchar(100) DEFAULT NULL,
 `homeroom` varchar(6) DEFAULT NULL,
 `referred_to_as` varchar(50) DEFAULT NULL,
 `gender` varchar(1) DEFAULT NULL,
 `birthdate` varchar(10) DEFAULT NULL,
 `date_of_hire` varchar(10) DEFAULT NULL,
 `position` varchar(100) DEFAULT NULL,
 PRIMARY KEY (`PKEY`),
 UNIQUE KEY `#` (`PKEY`),
 UNIQUE KEY `Unique ID` (`unique_id`),
 KEY `#_2` (`PKEY`),
 KEY `Unique ID_2` (`unique_id`)
) ENGINE=InnoDB AUTO_INCREMENT=91 DEFAULT CHARSET=utf8

CREATE TABLE `import_students` (
 `PKEY` int(11) NOT NULL AUTO_INCREMENT,
 `APID` varchar(5) DEFAULT NULL,
 `full_name` varchar(100) DEFAULT NULL,
 `unique_id` varchar(8) DEFAULT NULL,
 `status` varchar(8) DEFAULT NULL,
 `first_name` varchar(50) DEFAULT NULL,
 `middle_name` varchar(50) DEFAULT NULL,
 `last_name` varchar(50) DEFAULT NULL,
 `school_email` varchar(100) DEFAULT NULL,
 `grade` varchar(2) DEFAULT NULL,
 `homeroom` varchar(3) DEFAULT NULL,
 `referred_to_as` varchar(50) DEFAULT NULL,
 `gender` varchar(1) DEFAULT NULL,
 `birthdate` varchar(10) DEFAULT NULL,
 `entry_date` varchar(10) DEFAULT NULL,
 PRIMARY KEY (`PKEY`),
 UNIQUE KEY `#` (`PKEY`),
 UNIQUE KEY `Unique ID` (`unique_id`),
 KEY `#_2` (`PKEY`),
 KEY `Unique ID_2` (`unique_id`)
) ENGINE=InnoDB AUTO_INCREMENT=627 DEFAULT CHARSET=utf8

CREATE TABLE `staging_employees` (
 `PKEY` int(11) NOT NULL AUTO_INCREMENT,
 `APID` varchar(5) DEFAULT NULL,
 `full_name` varchar(100) DEFAULT NULL,
 `unique_id` varchar(8) DEFAULT NULL,
 `status` varchar(8) DEFAULT NULL,
 `first_name` varchar(50) DEFAULT NULL,
 `middle_name` varchar(50) DEFAULT NULL,
 `last_name` varchar(50) DEFAULT NULL,
 `school_email` varchar(100) DEFAULT NULL,
 `homeroom` varchar(6) DEFAULT NULL,
 `referred_to_as` varchar(50) DEFAULT NULL,
 `gender` varchar(1) DEFAULT NULL,
 `birthdate` date DEFAULT NULL,
 `date_of_hire` date DEFAULT NULL,
 `position` varchar(100) DEFAULT NULL,
 PRIMARY KEY (`PKEY`),
 UNIQUE KEY `#` (`PKEY`),
 UNIQUE KEY `Unique ID` (`unique_id`),
 KEY `#_2` (`PKEY`),
 KEY `Unique ID_2` (`unique_id`)
) ENGINE=InnoDB AUTO_INCREMENT=91 DEFAULT CHARSET=utf8

CREATE TABLE `staging_students` (
 `PKEY` int(11) NOT NULL AUTO_INCREMENT,
 `APID` varchar(5) DEFAULT NULL,
 `full_name` varchar(100) DEFAULT NULL,
 `unique_id` varchar(8) DEFAULT NULL,
 `status` varchar(8) DEFAULT NULL,
 `first_name` varchar(50) DEFAULT NULL,
 `middle_name` varchar(50) DEFAULT NULL,
 `last_name` varchar(50) DEFAULT NULL,
 `school_email` varchar(100) DEFAULT NULL,
 `grade` varchar(2) DEFAULT NULL,
 `homeroom` varchar(3) DEFAULT NULL,
 `referred_to_as` varchar(50) DEFAULT NULL,
 `gender` varchar(1) DEFAULT NULL,
 `birthdate` date DEFAULT NULL,
 `entry_date` date DEFAULT NULL,
 PRIMARY KEY (`PKEY`),
 UNIQUE KEY `#` (`PKEY`),
 UNIQUE KEY `Unique ID` (`unique_id`),
 KEY `#_2` (`PKEY`),
 KEY `Unique ID_2` (`unique_id`)
) ENGINE=InnoDB AUTO_INCREMENT=626 DEFAULT CHARSET=utf8

CREATE TABLE `users` (
 `unique_id` varchar(8) NOT NULL,
 `status` varchar(8) NOT NULL,
 `manual_entry` varchar(2) NOT NULL DEFAULT 'N',
 `population` varchar(3) NOT NULL,
 `first_name` varchar(50) NOT NULL,
 `middle_name` varchar(50) NOT NULL,
 `last_name` varchar(50) NOT NULL,
 `user_name` varchar(20) NOT NULL,
 `school_email` varchar(100) DEFAULT NULL,
 `grade` varchar(2) DEFAULT NULL,
 `homeroom` varchar(6) DEFAULT NULL,
 `referred_to_as` varchar(50) DEFAULT NULL,
 `gender` varchar(1) NOT NULL,
 `birthdate` date NOT NULL,
 `start_date` date NOT NULL,
 `position` varchar(100) NOT NULL,
 `description` varchar(100) NOT NULL,
 PRIMARY KEY (`unique_id`),
 UNIQUE KEY `user_name` (`user_name`),
 UNIQUE KEY `email_address` (`school_email`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8

CREATE TABLE `groupings` (
 `unique_id` int(11) NOT NULL AUTO_INCREMENT,
 `population` varchar(3) CHARACTER SET latin1 NOT NULL,
 `name_short` varchar(2) CHARACTER SET latin1 NOT NULL,
 `name_long` varchar(100) CHARACTER SET latin1 NOT NULL,
 `google_id_folder` varchar(100) CHARACTER SET latin1 NOT NULL,
 PRIMARY KEY (`unique_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8

CREATE TABLE `groups` (
 `unique_id` varchar(8) NOT NULL,
 `group_name` varchar(100) NOT NULL,
 `group_email` varchar(100) NOT NULL,
 `group_folder` varchar(100) NOT NULL,
 `grouping` varchar(8) NOT NULL,
 `department` varchar(50) NOT NULL,
 `cohort` varchar(50) NOT NULL,
 `schedule` varchar(100) NOT NULL,
 `google_id_folder` varchar(100) NOT NULL,
PRIMARY KEY (`unique_id`),
 UNIQUE KEY `unique_id` (`unique_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE `groups_members` (
 `unique_id_group` varchar(8) NOT NULL,
 `unique_id_user` varchar(8) NOT NULL,
 `member_type` varchar(3) NOT NULL,
 PRIMARY KEY (`unique_id_group`,`unique_id_user`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE `sync_config` (
 `config_name` varchar(50) NOT NULL,
 `config_value` varchar(250) NOT NULL,
 PRIMARY KEY (`config_name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE `sync_destination` (
 `sync_dest_id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
 `sync_dest_name` varchar(100) NOT NULL,
 PRIMARY KEY (`sync_dest_id`),
 UNIQUE KEY `sync_dest_name` (`sync_dest_name`)
) ENGINE=InnoDB AUTO_INCREMENT=1003 DEFAULT CHARSET=utf8;

CREATE TABLE `sync_status_user` (
 `sync_dest_id` int(11) NOT NULL,
 `unique_id_user` varchar(8) NOT NULL,
 `status` varchar(5) NOT NULL,
 `last_update` datetime NOT NULL,
 PRIMARY KEY (`sync_dest_id`,`unique_id_user`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE `users_stuviewers` (
 `unique_id_stu` varchar(8) NOT NULL,
 `unique_id_viewer` varchar(8) NOT NULL,
 `relationship` varchar(20) NOT NULL,
 UNIQUE KEY `stu_key` (`unique_id_stu`,`unique_id_viewer`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE `systems` (
 `unique_id` int(11) NOT NULL AUTO_INCREMENT,
 `LocationPrimary` varchar(50) DEFAULT NULL,
 `LocationSecondary` varchar(50) DEFAULT NULL,
 `Status` varchar(50) DEFAULT NULL,
 `Substatus` varchar(50) DEFAULT NULL,
 `MachineName` varchar(50) DEFAULT NULL,
 `Population` varchar(50) DEFAULT NULL,
 `Subpopulation` varchar(50) DEFAULT NULL,
 `MakeModel` varchar(50) DEFAULT NULL,
 `MakeModelDetailed` varchar(50) DEFAULT NULL,
 `MACAddresses` varchar(50) DEFAULT NULL,
 `StaticIPs` varchar(50) DEFAULT NULL,
 `DestinationRack` varchar(50) DEFAULT NULL,
 `MachineClass` varchar(50) DEFAULT NULL,
 `MachineType` varchar(50) DEFAULT NULL,
 `OSType` varchar(50) DEFAULT NULL,
 `OSVersion` varchar(50) DEFAULT NULL,
 `OSBit` varchar(50) DEFAULT NULL,
 `CPUCores` varchar(50) DEFAULT NULL,
 `CPUSpeed` varchar(50) DEFAULT NULL,
 `CPUBit` varchar(50) DEFAULT NULL,
 `CPUType` varchar(50) DEFAULT NULL,
 `RAM` varchar(50) DEFAULT NULL,
 `HDAvailable` varchar(50) DEFAULT NULL,
 `RAID` varchar(50) DEFAULT NULL,
 `HD1` varchar(50) DEFAULT NULL,
 `HD2` varchar(50) DEFAULT NULL,
 `HD3` varchar(50) DEFAULT NULL,
 `HD4` varchar(50) DEFAULT NULL,
 `HD5` varchar(50) DEFAULT NULL,
 `HD6` varchar(50) DEFAULT NULL,
 `Notes` varchar(50) DEFAULT NULL,
 `SerialNumber` varchar(50) DEFAULT NULL,
 `PurchaseDate` date DEFAULT NULL,
 `LastUpdateDate` date DEFAULT NULL,
 `NextYearLocation` varchar(50) DEFAULT NULL,
 PRIMARY KEY (`unique_id`),
 UNIQUE KEY `unique_id` (`unique_id`)
) ENGINE=InnoDB AUTO_INCREMENT=200045 DEFAULT CHARSET=utf8;
