use cs336project;

-- Disable foreign key checks
SET FOREIGN_KEY_CHECKS = 0;

-- Drop existing tables if they exist
DROP TABLE IF EXISTS `questions_answers`;
DROP TABLE IF EXISTS `goes`;
DROP TABLE IF EXISTS `manages`;
DROP TABLE IF EXISTS `books`;
DROP TABLE IF EXISTS `reservations`;
DROP TABLE IF EXISTS `schedule`;
DROP TABLE IF EXISTS `stations`;
DROP TABLE IF EXISTS `employees`;
DROP TABLE IF EXISTS `customers`;
DROP TABLE IF EXISTS `trains`;

-- Re-enable foreign key checks
SET FOREIGN_KEY_CHECKS = 1;

-- Create `trains` table
CREATE TABLE `trains` (
  `TrainID` char(10) NOT NULL,
  `TransitLineName` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`TrainID`)
) ENGINE=InnoDB;

-- Create `customers` table
CREATE TABLE `customers` (
  `username` varchar(255) NOT NULL,
  `password` varchar(255) NOT NULL,
  `fname` varchar(255) DEFAULT NULL,
  `lname` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`username`)
) ENGINE=InnoDB;

-- Create `employees` table
CREATE TABLE `employees` (
  `ssn` char(11) NOT NULL,
  `username` varchar(255) NOT NULL,
  `isAdmin` tinyint(1) DEFAULT '0',
  `isRep` tinyint(1) DEFAULT '0',
  PRIMARY KEY (`ssn`),
  FOREIGN KEY (`username`) REFERENCES `customers`(`username`)
    ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB;

-- Create `stations` table
CREATE TABLE `stations` (
  `stationID` char(10) NOT NULL,
  `stationName` varchar(50) DEFAULT NULL,
  `state` varchar(50) DEFAULT NULL,
  `location` varchar(100) DEFAULT NULL,
  `stopNumber` int DEFAULT NULL,
  `city` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`stationID`),
  CHECK (`stopNumber` >= 0)
) ENGINE=InnoDB;

-- Create `schedule` table
CREATE TABLE `schedule` (
  `schedule_id` int NOT NULL AUTO_INCREMENT,
  `train_id` char(10) NOT NULL,
  `origin` varchar(256) NOT NULL,
  `destination` varchar(256) NOT NULL,
  `stop_number` int DEFAULT NULL,
  `departure_time` datetime NOT NULL,
  `arrival_time` datetime NOT NULL,
  `fare` decimal(10,2) DEFAULT NULL,
  PRIMARY KEY (`schedule_id`),
  FOREIGN KEY (`train_id`) REFERENCES `trains`(`TrainID`)
    ON DELETE CASCADE ON UPDATE CASCADE,
  CHECK (`fare` >= 0),
  CHECK (`stop_number` >= 0)
) ENGINE=InnoDB;

-- Create `reservations` table
CREATE TABLE `reservations` (
  `reservation_id` int NOT NULL AUTO_INCREMENT,
  `schedule_id` int NOT NULL,
  `passenger_id` varchar(255) NOT NULL,
  `date` date NOT NULL,
  `trip_type` varchar(50) NOT NULL,
  `total_fare` decimal(10,2) NOT NULL,
  PRIMARY KEY (`reservation_id`),
  FOREIGN KEY (`schedule_id`) REFERENCES `schedule`(`schedule_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  FOREIGN KEY (`passenger_id`) REFERENCES `customers`(`username`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB;


-- Create `books` table
CREATE TABLE `books` (
  `reservation_id` int NOT NULL,
  `username` varchar(255) NOT NULL,
  PRIMARY KEY (`reservation_id`, `username`),
  FOREIGN KEY (`reservation_id`) REFERENCES `reservations`(`reservation_id`)
    ON DELETE CASCADE ON UPDATE CASCADE,
  FOREIGN KEY (`username`) REFERENCES `customers`(`username`)
    ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB;

-- Create `manages` table
CREATE TABLE `manages` (
  `schedule_id` int NOT NULL,
  `ssn` char(11) NOT NULL,
  PRIMARY KEY (`schedule_id`, `ssn`),
  FOREIGN KEY (`schedule_id`) REFERENCES `schedule`(`schedule_id`)
    ON DELETE CASCADE ON UPDATE CASCADE,
  FOREIGN KEY (`ssn`) REFERENCES `employees`(`ssn`)
    ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB;

-- Create `goes` table
CREATE TABLE `goes` (
  `schedule_id` int NOT NULL,
  `station_id` char(10) NOT NULL,
  `train_id` char(10) NOT NULL,
  PRIMARY KEY (`schedule_id`, `station_id`, `train_id`),
  FOREIGN KEY (`schedule_id`) REFERENCES `schedule`(`schedule_id`)
    ON DELETE CASCADE ON UPDATE CASCADE,
  FOREIGN KEY (`station_id`) REFERENCES `stations`(`stationID`)
    ON DELETE CASCADE ON UPDATE CASCADE,
  FOREIGN KEY (`train_id`) REFERENCES `trains`(`TrainID`)
    ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB;

-- Insert data for `trains`
INSERT INTO trains (TrainID, TransitLineName)
VALUES
('T001', 'Northeast Corridor Line'),
('T002', 'North Jersey Coast Line'),
('T003', 'Raritan Valley Line'); 

INSERT INTO stations (stationID, stationName, state, location, stopNumber, city)
VALUES
-- Northeast Corridor Line
('ST001', 'Trenton', 'NJ', '456 State St', 1, 'Trenton'),
('ST002', 'Hamilton', 'NJ', '1 Hamilton Ave', 2, 'Hamilton'),
('ST003', 'Princeton Junction', 'NJ', '100 Wallace Rd', 3, 'Princeton Junction'),
('ST004', 'New Brunswick', 'NJ', '123 Main St', 4, 'New Brunswick'),
('ST005', 'Edison', 'NJ', '1 Central Ave', 5, 'Edison'),
('ST006', 'Metropark', 'NJ', '60 Wood Ave', 6, 'Iselin'),
('ST007', 'Rahway', 'NJ', '1 E Milton Ave', 7, 'Rahway'),
('ST008', 'Elizabeth', 'NJ', 'Broad St & West Grand St', 8, 'Elizabeth'),
('ST009', 'Newark Penn', 'NJ', '25 Raymond Plaza W', 9, 'Newark'),
('ST010', 'Secaucus Junction', 'NJ', '675 County Ave', 10, 'Secaucus'),
('ST011', 'New York Penn', 'NY', '8th Avenue', 11, 'New York'),
-- North Jersey Coast Line
('ST012', 'Bay Head', 'NJ', '100 Main St', 12, 'Bay Head'),
('ST013', 'Point Pleasant Beach', 'NJ', '50 Arnold Ave', 13, 'Point Pleasant Beach'),
('ST014', 'Belmar', 'NJ', '100 8th Ave', 14, 'Belmar'),
('ST015', 'Asbury Park', 'NJ', '100 Main St', 15, 'Asbury Park'),
('ST016', 'Long Branch', 'NJ', '200 Long Branch Ave', 16, 'Long Branch'),
('ST017', 'Red Bank', 'NJ', '1 Monmouth St', 17, 'Red Bank'),
('ST018', 'Hazlet', 'NJ', '100 Main St', 18, 'Hazlet'),
('ST019', 'Perth Amboy', 'NJ', '200 Smith St', 19, 'Perth Amboy'),
('ST020', 'Woodbridge', 'NJ', '10 Pearl St', 20, 'Woodbridge'),
-- Raritan Valley Line
('ST022', 'High Bridge', 'NJ', '100 Bridge St', 22, 'High Bridge'),
('ST023', 'Annandale', 'NJ', '50 Main St', 23, 'Annandale'),
('ST024', 'Lebanon', 'NJ', '100 Main St', 24, 'Lebanon'),
('ST025', 'White House', 'NJ', '123 Main St', 25, 'White House'),
('ST026', 'Somerville', 'NJ', '1 Main St', 26, 'Somerville'),
('ST027', 'Bound Brook', 'NJ', '100 Main St', 27, 'Bound Brook'),
('ST028', 'Plainfield', 'NJ', '200 Front St', 28, 'Plainfield'),
('ST029', 'Westfield', 'NJ', '1 North Ave', 29, 'Westfield'),
('ST030', 'Cranford', 'NJ', '1 North Ave', 30, 'Cranford'),
('ST031', 'Roselle Park', 'NJ', '50 Chestnut St', 31, 'Roselle Park'),
('ST032', 'Union', 'NJ', '900 Green Ln', 32, 'Union');
-- Insert data for `schedule`

INSERT INTO schedule (train_id, origin, destination, stop_number, departure_time, arrival_time, fare)
VALUES
('T001', 'New Brunswick', 'New York Penn', 1, '2024-12-10 08:00:00', '2024-12-10 10:30:00', 20.00);

-- Insert data for `goes`
INSERT INTO goes (schedule_id, station_id, train_id)
VALUES
(1, 'ST001', 'T001'),
(1, 'ST002', 'T001'),
(1, 'ST003', 'T001'),
(1, 'ST004', 'T001'),
(1, 'ST005', 'T001'),
(1, 'ST006', 'T001'),
(1, 'ST007', 'T001'),
(1, 'ST008', 'T001'),
(1, 'ST009', 'T001'),
(1, 'ST010', 'T001'),
(1, 'ST011', 'T001');

-- Insert data for `customers`
INSERT INTO customers (username, password, fname, lname)
VALUES
('user1', 'pass1', 'John', 'Doe'), 
('user2', 'pass2', 'Alice', 'Smith'), 
('user3', 'pass3', 'Bob', 'Brown'),
('admin1', 'adminpass', 'Jane', 'Admin'),
('rep1', 'reppass', 'Mike', 'Rep');

INSERT INTO employees (ssn, username, isAdmin, isRep)
VALUES
('123-45-6789', 'admin1', 1, 0), 
('987-65-4321', 'rep1', 0, 1);  

select * from employees;
select * from schedule;
select * from reservations;

