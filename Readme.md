# Football Ticket Booking System

Here i have designed a database for a system called `Football Ticket Booking System`. I have also practiced some queries regarding to this `Football Ticket Booking System`'s database design.

## Table of content
- [Database Design](#database-design)
    - [Entities](#entities)
    - [Relationship Cardinality](#relationship-cardinality)
- [SQL Queries](#sql-queries)
- [ER Diagram](#er-diagram)


## Database Design

### Entities
- `Users`
- `Matches`
- `Bookings`

### Relationship Cardinality
- `Users (user_id)PK` (1) --< (N) `Bookings (user_id)FK`
- `Matches (match_id)PK` (1) --< (N) `Bookings (match_id)FK`

## SQL Queries

