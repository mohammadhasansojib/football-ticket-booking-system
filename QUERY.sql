-- =========================================================================
-- SYSTEM: Football Ticket Booking System Database Setup Template
-- DESCRIPTION: Pseudo-DDL Template for Table Creation & Data Insertion
-- INSTRUCTIONS: Replace 'TYPE' and the constraint placeholders with your own
--               actual data types, relational keys, and check criteria.
-- =========================================================================

-- DROP TABLES IF THEY ALREADY EXIST TO PREVENT CONFLICTS
DROP TABLE IF EXISTS Bookings;
DROP TABLE IF EXISTS Matches;
DROP TABLE IF EXISTS Users;

-- =========================================================================
-- 1. CREATE USERS TABLE
-- =========================================================================
CREATE TABLE Users (
    user_id int,
    full_name varchar(50) not null,
    email varchar(254) not null,
    role varchar(40) not null,
    phone_number varchar(20),
    
    constraint pk_users_id primary key(user_id),
    constraint unique_users_email unique(email),
    constraint check_users_role check (role in ('Ticket Manager', 'Football Fan'))
);

-- =========================================================================
-- 2. CREATE MATCHES TABLE
-- =========================================================================
CREATE TABLE Matches (
    match_id int,
    fixture varchar(254) not null,
    tournament_category varchar(254) not null,
    base_ticket_price numeric(10, 2) not null,
    match_status varchar(30) not null,
    
    constraint pk_matches_id primary key(match_id),
    constraint check_matches_ticket_price check (base_ticket_price >= 0),
    constraint check_matches_status check (match_status in ('Available', 'Selling Fast', 'Sold Out', 'Postponed'))
);

-- =========================================================================
-- 3. CREATE BOOKINGS TABLE
-- =========================================================================
CREATE TABLE Bookings (
    booking_id int,
    user_id int not null,
    match_id int not null,
    seat_number varchar(30),
    payment_status varchar(30),
    total_cost numeric(10, 2) not null,
    
    constraint pk_bookings_id primary key(booking_id),
    constraint fk_users_id foreign key (user_id) references Users(user_id),
    constraint fk_matches_id foreign key (match_id) references Matches(match_id),
    constraint check_bookings_total_cost check (total_cost >= 0),
    constraint check_bookings_payment_status check (payment_status in ('Pending', 'Confirmed', 'Cancelled', 'Refunded'))
);


-- =========================================================================
-- DATA SEEDING: INSERT SAMPLE DATA INTO USERS
-- =========================================================================
INSERT INTO Users (user_id, full_name, email, role, phone_number) VALUES
(1, 'Tanvir Rahman', 'tanvir@mail.com', 'Football Fan', '+8801711111111'),
(2, 'Asif Haque', 'asif@mail.com', 'Football Fan', '+8801722222222'),
(3, 'Sajjad Rahman', 'sajjad@mail.com', 'Ticket Manager', '+8801733333333'),
(4, 'Jannat Ara', 'jannat@mail.com', 'Football Fan', NULL);

-- =========================================================================
-- DATA SEEDING: INSERT SAMPLE DATA INTO MATCHES
-- =========================================================================
INSERT INTO Matches (match_id, fixture, tournament_category, base_ticket_price, match_status) VALUES
(101, 'Real Madrid vs Barcelona', 'Champions League', 150.00, 'Available'),
(102, 'Man City vs Liverpool', 'Premier League', 120.00, 'Selling Fast'),
(103, 'Bayern Munich vs PSG', 'Champions League', 130.00, 'Available'),
(104, 'AC Milan vs Inter Milan', 'Serie A', 90.00, 'Sold Out'),
(105, 'Juventus vs Roma', 'Serie A', 80.00, 'Available');

-- =========================================================================
-- DATA SEEDING: INSERT SAMPLE DATA INTO BOOKINGS
-- =========================================================================
INSERT INTO Bookings (booking_id, user_id, match_id, seat_number, payment_status, total_cost) VALUES
(501, 1, 101, 'A-12', 'Confirmed', 150.00),
(502, 1, 102, 'B-04', 'Confirmed', 120.00),
(503, 2, 101, 'A-13', 'Confirmed', 150.00),
(504, 2, 101, NULL, NULL, 150.00),
(505, 3, 102, 'C-20', 'Pending', 120.00);



-- part 2: SQL queries

-- Query 1: Retrieve all upcoming football matches belonging to the 'Champions League' where the match status is 'Available'.
select match_id, fixture, base_ticket_price from matches where tournament_category = 'Champions League' and match_status = 'Available';

-- Query 2: Search for all users whose full names start with 'Tanvir' or contain the phrase 'Haque' (case-insensitive).
select user_id, full_name, email from users where full_name ilike 'Tanvir%' or full_name ilike '%Haque%';

-- Query 3: Retrieve all booking records where the payment status is missing (NULL), replacing the empty result with 'Action Required'.
select booking_id, user_id, match_id, coalesce(payment_status, 'Action Required') as systematic_status from bookings where payment_status is null;

-- Query 4: Retrieve match booking details along with the User's full name and the scheduled Match fixture teams.
select
  booking_id,
  full_name,
  fixture,
  total_cost
from bookings b
inner join users u
on b.user_id = u.user_id
inner join matches m
on b.match_id = m.match_id;

-- Query 5: Display a comprehensive list of all users and their booking IDs, ensuring that fans who have never bought a ticket are still listed.
select
  u.user_id,
  full_name,
  booking_id
from users u
left join bookings b
on u.user_id = b.user_id;

-- Query 6: Find all ticket bookings where the total cost is strictly higher than the average cost of all ticket bookings.
select
  booking_id,
  match_id,
  total_cost
from bookings
where total_cost > (
  select avg(total_cost) from bookings
);

-- Query 7: Retrieve the top 2 most expensive matches sorted by base ticket price, skipping the absolute highest premium match.
select
  match_id,
  fixture,
  base_ticket_price
from matches
order by base_ticket_price desc
limit 2 offset 1;






