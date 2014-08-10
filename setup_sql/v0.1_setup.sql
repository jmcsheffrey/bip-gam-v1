CREATE TABLE `sync_destination` (
 `sync_dest_id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
 `sync_dest_name` varchar(100) NOT NULL,
 PRIMARY KEY (`sync_dest_id`),
 UNIQUE KEY `sync_dest_name` (`sync_dest_name`)
) ENGINE=InnoDB AUTO_INCREMENT=1003 DEFAULT CHARSET=utf8

CREATE TABLE `sync_status_user` (
 `sync_dest_id` int(11) NOT NULL,
 `unique_id_user` varchar(8) NOT NULL,
 `status` varchar(5) NOT NULL,
 `last_update` datetime NOT NULL,
 PRIMARY KEY (`sync_dest_id`,`unique_id_user`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8

CREATE TABLE `users` (
 `unique_id` varchar(8) NOT NULL,
 `status` varchar(6) NOT NULL,
 `population` varchar(3) NOT NULL,
 `first_name` varchar(50) NOT NULL,
 `middle_name` varchar(50) NOT NULL,
 `last_name` varchar(50) NOT NULL,
 `user_name` varchar(100) NOT NULL,
 `email_address` varchar(100) NOT NULL,
 `referredto_name` varchar(100) NOT NULL,
 PRIMARY KEY (`unique_id`),
 UNIQUE KEY `user_name` (`user_name`),
 UNIQUE KEY `email_address` (`email_address`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8

CREATE TABLE `users_stuviewers` (
 `unique_id_stu` varchar(8) CHARACTER SET utf8 NOT NULL,
 `unique_id_viewer` varchar(8) CHARACTER SET utf8 NOT NULL,
 `relationship` varchar(20) CHARACTER SET utf8 NOT NULL,
 UNIQUE KEY `stu_key` (`unique_id_stu`,`unique_id_viewer`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8

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
 PRIMARY KEY (`InternalSystemsID`),
 UNIQUE KEY `InternalSystemsID` (`InternalSystemsID`)
) ENGINE=InnoDB AUTO_INCREMENT=200045 DEFAULT CHARSET=utf8
