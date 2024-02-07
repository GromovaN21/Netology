-----Home Work # 1
create table if not exists сollections (
	id serial primary key,
	name varchar(60) not null,
	year integer not null
	);
	
create table if not exists albums (
	id serial primary key,
	name varchar(60) not null,
	year integer not null,
	CHECK (CHAR_LENGTH(name) <= 60)
	);

create table if not exists songs (
	id serial primary key,
	albums_id INTEGER NOT NULL REFERENCES albums(id),
	name varchar(60) not null,
	duration integer not null,
	CHECK (duration > 0),
	CHECK (CHAR_LENGTH(name) <= 60)
	);

create table if not exists singers (
	id serial primary key,
	name varchar(60) not null,
	UNIQUE (name)
	);
	
create table if not exists genres (
	id serial primary key,
	name varchar(60) not null
	);
	
create table if not exists songscollections (
	collections_id INTEGER NOT NULL REFERENCES сollections(id),
	songs_id INTEGER NOT NULL REFERENCES songs(id)
	);
	
create table if not exists singersalbums (
	albums_id INTEGER NOT NULL REFERENCES albums(id),
	singers_id INTEGER NOT NULL REFERENCES singers(id)
	);


create table if not exists singersgenres (
	singer_id INTEGER NOT NULL REFERENCES singers(id),
	genre_id integer not null references genres(id)
	);
------Home Work # 2
create table if not exists departments (
	id serial primary key,
	name varchar(60) NOT NULL,
	description text 
	);
create table if not exists employees (
	id serial primary key,
	name varchar(60) NOT NULL,
	department_id integer not null references departments(id),
	officer_id integer references employees
	);
	
