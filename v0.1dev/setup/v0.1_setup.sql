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
 `Notes` varchar(254) DEFAULT NULL,
 `SerialNumber` varchar(50) DEFAULT NULL,
 `PurchaseDate` date DEFAULT NULL,
 `LastUpdateDate` date DEFAULT NULL,
 `NextYearLocation` varchar(50) DEFAULT NULL,
 PRIMARY KEY (`unique_id`),
 UNIQUE KEY `InternalSystemsID` (`unique_id`)
) ENGINE=InnoDB AUTO_INCREMENT=200151 DEFAULT CHARSET=utf8;

CREATE TABLE `users` (
 `unique_id` varchar(8) NOT NULL,
 `update_date` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
 `status` varchar(8) NOT NULL,
 `manual_entry` varchar(2) NOT NULL DEFAULT 'N',
 `population` varchar(3) NOT NULL,
 `household_id` varchar(20) DEFAULT NULL,
 `first_name` varchar(50) NOT NULL,
 `middle_name` varchar(50) NOT NULL,
 `last_name` varchar(50) NOT NULL,
 `user_name` varchar(20) DEFAULT NULL,
 `school_email` varchar(100) DEFAULT NULL,
 `grade` varchar(2) DEFAULT NULL,
 `expected_grad_year` int(11) NOT NULL,
 `homeroom_room` varchar(6) DEFAULT NULL,
 `homeroom_teacher_first` varchar(50) DEFAULT NULL,
 `homeroom_teacher_last` varchar(50) DEFAULT NULL,
 `referred_to_as` varchar(50) DEFAULT NULL,
 `gender` varchar(1) NOT NULL,
 `birthdate` date NOT NULL,
 `start_date` date NOT NULL,
 `position` varchar(100) NOT NULL,
 `description` varchar(100) NOT NULL,
 PRIMARY KEY (`unique_id`),
 UNIQUE KEY `unique_id` (`unique_id`),
 UNIQUE KEY `user_name` (`user_name`),
 UNIQUE KEY `email_address` (`school_email`),
 KEY `unique_id_2` (`unique_id`),
 KEY `unique_id_3` (`unique_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8

CREATE TABLE `import_students` (
 `PKEY` int(11) NOT NULL AUTO_INCREMENT,
 `APID` varchar(5) DEFAULT NULL,
 `full_name` varchar(100) DEFAULT NULL,
 `unique_id` varchar(8) DEFAULT NULL,
 `status` varchar(8) DEFAULT NULL,
 `household_id` varchar(20) DEFAULT NULL,
 `first_name` varchar(50) DEFAULT NULL,
 `middle_name` varchar(50) DEFAULT NULL,
 `last_name` varchar(50) DEFAULT NULL,
 `school_email` varchar(100) DEFAULT NULL,
 `grade` varchar(2) DEFAULT NULL,
 `expected_grad_year` varchar(4) DEFAULT NULL,
 `homeroom` varchar(3) DEFAULT NULL,
 `homeroom_teacher_first` varchar(50) DEFAULT NULL,
 `homeroom_teacher_last` varchar(50) DEFAULT NULL,
 `referred_to_as` varchar(50) DEFAULT NULL,
 `gender` varchar(1) DEFAULT NULL,
 `birthdate` varchar(10) DEFAULT NULL,
 `entry_date` varchar(10) DEFAULT NULL,
 PRIMARY KEY (`PKEY`),
 UNIQUE KEY `#` (`PKEY`),
 UNIQUE KEY `Unique ID` (`unique_id`),
 KEY `#_2` (`PKEY`),
 KEY `Unique ID_2` (`unique_id`)
) ENGINE=InnoDB AUTO_INCREMENT=152 DEFAULT CHARSET=utf8;

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
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE `staging_students` (
 `PKEY` int(11) NOT NULL AUTO_INCREMENT,
 `APID` varchar(5) DEFAULT NULL,
 `full_name` varchar(100) DEFAULT NULL,
 `unique_id` varchar(8) DEFAULT NULL,
 `status` varchar(8) DEFAULT NULL,
 `household_id` varchar(20) DEFAULT NULL,
 `first_name` varchar(50) DEFAULT NULL,
 `middle_name` varchar(50) DEFAULT NULL,
 `last_name` varchar(50) DEFAULT NULL,
 `school_email` varchar(100) DEFAULT NULL,
 `grade` varchar(2) DEFAULT NULL,
 `expected_grad_year` int(11) NOT NULL,
 `homeroom_room` varchar(3) DEFAULT NULL,
 `homeroom_teacher_first` varchar(50) DEFAULT NULL,
 `homeroom_teacher_last` varchar(50) DEFAULT NULL,
 `referred_to_as` varchar(50) DEFAULT NULL,
 `gender` varchar(1) DEFAULT NULL,
 `birthdate` date DEFAULT NULL,
 `entry_date` date DEFAULT NULL,
 PRIMARY KEY (`PKEY`),
 UNIQUE KEY `#` (`PKEY`),
 UNIQUE KEY `Unique ID` (`unique_id`),
 KEY `#_2` (`PKEY`),
 KEY `Unique ID_2` (`unique_id`)
) ENGINE=InnoDB AUTO_INCREMENT=152 DEFAULT CHARSET=utf8;

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
) ENGINE=InnoDB AUTO_INCREMENT=91 DEFAULT CHARSET=utf8;

CREATE TABLE `groupings` (
 `unique_id` int(11) NOT NULL AUTO_INCREMENT,
 `population` varchar(3) CHARACTER SET latin1 NOT NULL,
 `name_short` varchar(2) CHARACTER SET latin1 NOT NULL,
 `name_long` varchar(100) CHARACTER SET latin1 NOT NULL,
 `email` varchar(100) NOT NULL,
 `folder` varchar(100) NOT NULL,
 `google_orgunit` varchar(100) NOT NULL,
 `google_id_folder` varchar(100) CHARACTER SET latin1 NOT NULL,
 PRIMARY KEY (`unique_id`)
) ENGINE=InnoDB AUTO_INCREMENT=12 DEFAULT CHARSET=utf8;

CREATE TABLE `groupings_users` (
 `unique_id_grouping` int(11) NOT NULL,
 `unique_id_user` varchar(8) NOT NULL,
 PRIMARY KEY (`unique_id_grouping`,`unique_id_user`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
