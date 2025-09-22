CREATE DATABASE IF NOT EXISTS TikTokDB;

USE TikTokDB;

CREATE TABLE IF NOT EXISTS usuarios (
	id_usuario INT NOT NULL UNIQUE,
    nombre VARCHAR(100),
    correo VARCHAR(100),
    fecha DATE,
    país VARCHAR(100) NOT NULL,
    PRIMARY KEY (id_usuario));

CREATE TABLE IF NOT EXISTS videos (
	id_video INT NOT NULL UNIQUE,
    id_usuario INT,
    título VARCHAR(100),
    descripción VARCHAR(100),
    fecha DATE,
    duración INT,
    PRIMARY KEY (id_video),
	FOREIGN KEY (id_usuario) REFERENCES usuarios(id_usuario));
    
CREATE TABLE IF NOT EXISTS comentarios (
	id_comentario INT NOT NULL UNIQUE,
    id_video INT,
    id_usuario INT,
    texto VARCHAR(100) NOT NULL,
    fecha DATE,
    PRIMARY KEY (id_comentario),
    FOREIGN KEY (id_video) REFERENCES videos(id_video),
	FOREIGN KEY (id_usuario) REFERENCES usuarios(id_usuario));
    
CREATE TABLE IF NOT EXISTS likes (
	id_like INT NOT NULL UNIQUE,
    id_video INT,
    id_usuario INT,
    fecha DATE,
    PRIMARY KEY (id_like),
    FOREIGN KEY (id_video) REFERENCES videos(id_video),
	FOREIGN KEY (id_usuario) REFERENCES usuarios(id_usuario));
    
CREATE TABLE IF NOT EXISTS seguidores (
	id_follow INT NOT NULL UNIQUE,
    id_usuarioseguidor INT,
    id_usuarioseguido INT,
    fecha DATE,
    PRIMARY KEY (id_follow),
    FOREIGN KEY (id_usuarioseguidor) REFERENCES usuarios(id_usuario),
	FOREIGN KEY (id_usuarioseguido) REFERENCES usuarios(id_usuario));
    
INSERT INTO usuarios (id_usuario, nombre, correo, fecha, país)
VALUES (1, "Hugo","hugo@gmail","2025-09-14", "España"),
(2, "Andrea","andrea@gmail","2025-09-16", "España"),
(3, "Merche","merche@gmail","2025-09-24", "Grecia");

INSERT INTO videos (id_video, id_usuario, título, descripción, fecha, duración)
VALUES (1, 1, "Libro","Leer","2025-09-14", 10),
(2, 2, "Cocina","Receta","2025-09-16", 30),
(3, 3, "Ski","Ski trip","2025-09-24", 15);

INSERT INTO comentarios (id_comentario, id_video, id_usuario, texto, fecha)
VALUES (1, 1, 1, "Top","2025-09-14"),
(2, 2, 2, "MMMM","2025-09-16"),
(3, 3, 3, "wow","2025-09-24");

INSERT INTO likes (id_like, id_video, id_usuario, fecha)
VALUES (1, 1, 1,"2025-09-14"),
(2, 2, 2,"2025-09-16"),
(3, 3, 3,"2025-09-24");

INSERT INTO seguidores (id_follow, id_usuarioseguidor, id_usuarioseguido, fecha)
VALUES (1, 1, 1,"2025-09-14"),
(2, 2, 2,"2025-09-16"),
(3, 3, 3,"2025-09-24");

SELECT * FROM tiktokdb.usuarios;

SELECT * FROM tiktokdb.videos;

SELECT * FROM tiktokdb.comentarios;

SELECT * FROM tiktokdb.likes;

SELECT * FROM tiktokdb.seguidores;

SELECT v.id_video, v.título, v.descripción, u.nombre AS creador, v.fecha, v.duración
FROM videos AS v
JOIN usuarios u ON v.id_usuario = u.id_usuario;

SELECT v.título, COUNT(l.id_like) AS total_likes
FROM videos AS v
LEFT JOIN likes l ON v.id_video = l.id_video
GROUP BY v.id_video, v.título;

SELECT c.texto, c.fecha, u.nombre AS autor, v.título AS video
FROM comentarios AS c
JOIN usuarios u ON c.id_usuario = u.id_usuario
JOIN videos v ON c.id_video = v.id_video;