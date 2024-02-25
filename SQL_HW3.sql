-----Home Work # 3
DROP TABLE IF EXISTS collections CASCADE;

create table if not exists collections (
	id serial primary key,
	name varchar(60) not null,
	year integer not null
	);
	
DROP TABLE IF EXISTS albums CASCADE;
create table if not exists albums (
	id serial primary key,
	name varchar(60) not null,
	year integer not null,
	CHECK (CHAR_LENGTH(name) <= 60)
	);
	
DROP TABLE IF EXISTS songs CASCADE;
create table if not exists songs (
	id serial primary key,
	album_id INTEGER NOT NULL REFERENCES albums(id),
	name varchar(60) not null,
	duration integer not null,
	CHECK (duration > 0),
	CHECK (CHAR_LENGTH(name) <= 60)
	);
	
DROP TABLE IF EXISTS singers CASCADE;
create table if not exists singers (
	id serial primary key,
	name varchar(60) not null,
	UNIQUE (name)
	);

DROP TABLE IF EXISTS genres CASCADE;
create table if not exists genres (
	id serial primary key,
	name varchar(60) not null
	);

DROP TABLE IF EXISTS songscollections CASCADE;
create table if not exists songscollections (
	collection_id INTEGER NOT NULL REFERENCES collections(id),
	song_id INTEGER NOT NULL REFERENCES songs(id)
	);

DROP TABLE IF EXISTS singersalbums CASCADE;
create table if not exists singersalbums (
	album_id INTEGER NOT NULL REFERENCES albums(id),
	singer_id INTEGER NOT NULL REFERENCES singers(id)
	);

DROP TABLE IF EXISTS singersgenres CASCADE;
create table if not exists singersgenres (
	singer_id INTEGER NOT NULL REFERENCES singers(id),
	genre_id integer not null references genres(id)
	);

INSERT INTO singers (id, name) VALUES 
    (1, 'Исполнитель 1'),
    (2, 'Исполнитель 2'),
    (3, 'Исполнитель3'),
    (4, 'Исполнитель4');
	
INSERT INTO genres (id, name) VALUES 
    (1, 'Жанр 1'),
    (2, 'Жанр 2'),
    (3, 'Жанр 3');
	
INSERT INTO albums (id, name, year) VALUES 
    (1, 'Альбом 1', '2000'),
    (2, 'Альбом 2','2019'),
    (3, 'Альбом 3', '2020');
	
INSERT INTO songs (id, album_id,  name , duration) VALUES 
    (1, 1, 'Трек 1', '60'),
    (2, 1, 'Трек 2', '90'),
    (3, 2, 'Трек 3', '210'),
    (4, 2, 'Трек 4', '300'),
    (5, 3, 'МойТрек 5', '90'),
    (6, 3, 'MyТрек 6', '150');
	
INSERT INTO collections (id, name, year) VALUES 
    (1, 'Сборник 1', '2023'),
    (2, 'Сборник 2', '2022'),
    (3, 'Сборник 3', '2011'),
    (4, 'Сборник 4', '2002');
	
	
INSERT INTO songscollections(collection_id, song_id) VALUES
	(1, 1),
	(1, 2),
	(2, 3),
	(2, 4),
	(3, 5),
	(4, 5);

INSERT INTO singersalbums(album_id, singer_id) VALUES
	(1, 1),
	(1, 2),
	(1, 3),
	(2, 2),
	(2, 3),
	(3, 2),
	(3, 4);
	
INSERT INTO singersgenres(singer_id, genre_id) VALUES
	(1, 1),
	(2, 2),
	(3, 3),
	(4, 1),
	(1, 2),
	(2, 3);
	
------1. Название и продолжительность самого длительного трека.	
SELECT name, duration FROM songs
WHERE duration = (SELECT MAX(duration) FROM songs);

-------2 Название треков, продолжительность которых не менее 3,5 минут.

SELECT name, duration FROM songs
WHERE duration > 210;


-------3 Названия сборников, вышедших в период с 2018 по 2020 год включительно.
SELECT name, year FROM collections
WHERE 2018<= year AND year<= 2020;


-------4 Исполнители, чьё имя состоит из одного слова.


SELECT name FROM singers
WHERE LENGTH(name)=LENGTH(replace(name, ' ', ''));

-------5 Название треков, которые содержат слово «мой» или «my»

SELECT name FROM songs
WHERE LOWER(name) LIKE '%мой%' OR LOWER(name) LIKE '%my%';


--------Задание 3 
--------1 Количество исполнителей в каждом жанре.
SELECT sg.genre_id, COUNT(sg.singer_id) FROM singersgenres sg
GROUP BY sg.genre_id
ORDER BY sg.genre_id ASC;
	
	
---------2Количество треков, вошедших в альбомы 2019–2020 годов.
SELECT a.id, a.name, a.year, COUNT(s.id) FROM songs s
LEFT JOIN albums a ON s.album_id= a.id
WHERE a.year<=2020 AND a.year>=2019
GROUP BY a.id;

----------3Средняя продолжительность треков по каждому альбому.
SELECT a.name, AVG(s.duration) FROM songs s
LEFT JOIN albums a ON s.album_id= a.id
GROUP BY a.id
ORDER BY a.id ASC;

--------4 Все исполнители, которые не выпустили альбомы в 2020 году.
SELECT * FROM singers WHERE id not in (
SELECT s.id from albums a
JOIN singersalbums sa ON sa.album_id = a.id
JOIN singers s ON sa.singer_id = s.id
WHERE a.year = '2020');

-----5 Названия сборников, в которых присутствует конкретный исполнитель (выберите его сами).------CHECK
SELECT c.name, singers.name FROM songscollections sc
LEFT JOIN collections c ON sc.collection_id=c.id
LEFT JOIN songs s ON sc.song_id=s.id
LEFT JOIN singersalbums sa ON sa.album_id=s.album_id
LEFT JOIN singers ON singers.id=sa.singer_id 
WHERE singers.name= 'Исполнитель 1';

----------Задание 4(необязательное)
----------1   Названия альбомов, в которых присутствуют исполнители более чем одного жанра.
SELECT a.name, COUNT(g.name) FROM albums a 
LEFT JOIN singersalbums sa ON sa.album_id = a.id
LEFT JOIN singers ON singers.id = sa.singer_id
LEFT JOIN singersgenres sg ON sg.singer_id=singers.id
LEFT JOIN genres g ON sg.genre_id=g.id
GROUP BY a.name
HAVING COUNT(a.name) > 1;

-----2. Наименования треков, которые не входят в сборники.
SELECT * FROM songs
LEFT JOIN songscollections sc ON songs.id= sc.song_id
WHERE sc.collection_id is null;

-----3 Исполнитель или исполнители, написавшие самый короткий по продолжительности трек, — теоретически таких треков может быть несколько.
SELECT singers.name FROM songs
LEFT JOIN albums ON albums.id=songs.album_id
LEFT JOIN singersalbums sa ON albums.id=sa.album_id
LEFT JOIN singers ON singers.id= sa.singer_id
WHERE songs.duration = (SELECT MIN(songs.duration) FROM songs);

-----4. Названия альбомов, содержащих наименьшее количество треков.
SELECT albums.name FROM songs
LEFT JOIN albums ON albums.id=songs.album_id
LEFT JOIN singersalbums sa ON albums.id=sa.album_id
LEFT JOIN singers ON singers.id= sa.singer_id
GROUP BY albums.name
ORDER BY COUNT(songs.id) ASC
LIMIT 1; 
