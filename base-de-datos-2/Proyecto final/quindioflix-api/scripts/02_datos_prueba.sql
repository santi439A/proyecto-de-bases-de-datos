-- =====================================================
-- QUINDIOFLIX - DATOS DE PRUEBA
-- =====================================================

-- EMPLEADOS
INSERT INTO empleado (empleado_id, nombre, email, telefono, cargo, departamento_id, supervisor_id)
VALUES (1, 'Carlos Rodriguez', 'carlos@quindioflix.com', '3001111111', 'JEFE_TECNOLOGIA', 1, NULL);

INSERT INTO empleado (empleado_id, nombre, email, telefono, cargo, departamento_id, supervisor_id)
VALUES (2, 'Maria Garcia', 'maria@quindioflix.com', '3002222222', 'JEFE_CONTENIDO', 2, NULL);

INSERT INTO empleado (empleado_id, nombre, email, telefono, cargo, departamento_id, supervisor_id)
VALUES (3, 'Juan Lopez', 'juan@quindioflix.com', '3003333333', 'JEFE_MARKETING', 3, NULL);

INSERT INTO empleado (empleado_id, nombre, email, telefono, cargo, departamento_id, supervisor_id)
VALUES (4, 'Ana Martinez', 'ana@quindioflix.com', '3004444444', 'JEFE_SOPORTE', 4, NULL);

INSERT INTO empleado (empleado_id, nombre, email, telefono, cargo, departamento_id, supervisor_id)
VALUES (5, 'Pedro Sanchez', 'pedro@quindioflix.com', '3005555555', 'JEFE_FINANZAS', 5, NULL);

INSERT INTO empleado (empleado_id, nombre, email, telefono, cargo, departamento_id, supervisor_id)
VALUES (6, 'Laura Diaz', 'laura@quindioflix.com', '3006666666', 'GESTOR_CONTENIDO', 2, 2);

INSERT INTO empleado (empleado_id, nombre, email, telefono, cargo, departamento_id, supervisor_id)
VALUES (7, 'Diego Fernandez', 'diego@quindioflix.com', '3007777777', 'MODERADOR', 4, 4);

INSERT INTO empleado (empleado_id, nombre, email, telefono, cargo, departamento_id, supervisor_id)
VALUES (8, 'Sofia Ramirez', 'sofia@quindioflix.com', '3008888888', 'DESARROLLADOR', 1, 1);

-- Actualizar jefes de departamento
UPDATE departamento SET jefe_id = 1 WHERE departamento_id = 1;
UPDATE departamento SET jefe_id = 2 WHERE departamento_id = 2;
UPDATE departamento SET jefe_id = 3 WHERE departamento_id = 3;
UPDATE departamento SET jefe_id = 4 WHERE departamento_id = 4;
UPDATE departamento SET jefe_id = 5 WHERE departamento_id = 5;

-- USUARIOS
INSERT INTO usuario (usuario_id, nombre, email, telefono, fecha_nacimiento, ciudad_residencia, plan_id, fecha_registro, estado_cuenta)
VALUES (1, 'Andres Perez', 'andres@mail.com', '3101111111', DATE '1985-05-15', 'Armenia', 1, DATE '2025-01-10', 'ACTIVO');

INSERT INTO usuario (usuario_id, nombre, email, telefono, fecha_nacimiento, ciudad_residencia, plan_id, fecha_registro, estado_cuenta)
VALUES (2, 'Carmen Torres', 'carmen@mail.com', '3102222222', DATE '1990-08-20', 'Bogota', 2, DATE '2025-01-15', 'ACTIVO');

INSERT INTO usuario (usuario_id, nombre, email, telefono, fecha_nacimiento, ciudad_residencia, plan_id, fecha_registro, estado_cuenta)
VALUES (3, 'Roberto Silva', 'roberto@mail.com', '3103333333', DATE '1978-12-01', 'Medellin', 3, DATE '2025-02-01', 'ACTIVO');

INSERT INTO usuario (usuario_id, nombre, email, telefono, fecha_nacimiento, ciudad_residencia, plan_id, fecha_registro, estado_cuenta)
VALUES (4, 'Elena Vargas', 'elena@mail.com', '3104444444', DATE '1995-03-25', 'Cali', 1, DATE '2025-02-10', 'ACTIVO');

INSERT INTO usuario (usuario_id, nombre, email, telefono, fecha_nacimiento, ciudad_residencia, plan_id, fecha_registro, estado_cuenta)
VALUES (5, 'Fernando Morales', 'fernando@mail.com', '3105555555', DATE '1988-11-30', 'Pereira', 2, DATE '2025-03-01', 'SUSPENDIDO');

INSERT INTO usuario (usuario_id, nombre, email, telefono, fecha_nacimiento, ciudad_residencia, plan_id, fecha_registro, estado_cuenta)
VALUES (6, 'Patricia Rojas', 'patricia@mail.com', '3106666666', DATE '1992-07-14', 'Armenia', 3, DATE '2025-03-15', 'ACTIVO');

INSERT INTO usuario (usuario_id, nombre, email, telefono, fecha_nacimiento, ciudad_residencia, plan_id, fecha_registro, estado_cuenta)
VALUES (7, 'Luis Mendoza', 'luis@mail.com', '3107777777', DATE '1982-09-08', 'Bogota', 1, DATE '2025-04-01', 'ACTIVO');

INSERT INTO usuario (usuario_id, nombre, email, telefono, fecha_nacimiento, ciudad_residencia, plan_id, fecha_registro, estado_cuenta)
VALUES (8, 'Claudia Guzman', 'claudia@mail.com', '3108888888', DATE '1997-01-20', 'Medellin', 2, DATE '2025-04-10', 'ACTIVO');

INSERT INTO usuario (usuario_id, nombre, email, telefono, fecha_nacimiento, ciudad_residencia, plan_id, fecha_registro, estado_cuenta)
VALUES (9, 'Miguel Castro', 'miguel@mail.com', '3109999999', DATE '1991-06-05', 'Cali', 3, DATE '2025-05-01', 'ACTIVO');

INSERT INTO usuario (usuario_id, nombre, email, telefono, fecha_nacimiento, ciudad_residencia, plan_id, fecha_registro, estado_cuenta)
VALUES (10, 'Isabel Ruiz', 'isabel@mail.com', '3110000000', DATE '1989-10-12', 'Armenia', 2, DATE '2025-05-15', 'ACTIVO');

-- PERFILES
INSERT INTO perfil (perfil_id, usuario_id, nombre, avatar, tipo) VALUES (1, 1, 'Andres', 'avatar_1.png', 'ADULTO');
INSERT INTO perfil (perfil_id, usuario_id, nombre, avatar, tipo) VALUES (2, 1, 'Niña Andres', 'avatar_2.png', 'INFANTIL');
INSERT INTO perfil (perfil_id, usuario_id, nombre, avatar, tipo) VALUES (3, 2, 'Carmen', 'avatar_3.png', 'ADULTO');
INSERT INTO perfil (perfil_id, usuario_id, nombre, avatar, tipo) VALUES (4, 3, 'Roberto', 'avatar_4.png', 'ADULTO');
INSERT INTO perfil (perfil_id, usuario_id, nombre, avatar, tipo) VALUES (5, 3, 'Hijo Roberto', 'avatar_5.png', 'INFANTIL');
INSERT INTO perfil (perfil_id, usuario_id, nombre, avatar, tipo) VALUES (6, 4, 'Elena', 'avatar_6.png', 'ADULTO');
INSERT INTO perfil (perfil_id, usuario_id, nombre, avatar, tipo) VALUES (7, 5, 'Fernando', 'avatar_7.png', 'ADULTO');
INSERT INTO perfil (perfil_id, usuario_id, nombre, avatar, tipo) VALUES (8, 6, 'Patricia', 'avatar_8.png', 'ADULTO');
INSERT INTO perfil (perfil_id, usuario_id, nombre, avatar, tipo) VALUES (9, 6, 'Hijo Patricia', 'avatar_9.png', 'INFANTIL');
INSERT INTO perfil (perfil_id, usuario_id, nombre, avatar, tipo) VALUES (10, 7, 'Luis', 'avatar_10.png', 'ADULTO');
INSERT INTO perfil (perfil_id, usuario_id, nombre, avatar, tipo) VALUES (11, 8, 'Claudia', 'avatar_11.png', 'ADULTO');
INSERT INTO perfil (perfil_id, usuario_id, nombre, avatar, tipo) VALUES (12, 9, 'Miguel', 'avatar_12.png', 'ADULTO');
INSERT INTO perfil (perfil_id, usuario_id, nombre, avatar, tipo) VALUES (13, 10, 'Isabel', 'avatar_13.png', 'ADULTO');

-- CONTENIDO
INSERT INTO contenido (contenido_id, categoria_id, titulo, anno_lanzamiento, duracion_minutos, sinopsis, clasificacion_edad, fecha_agregado, es_original, empleado_responsable_id)
VALUES (1, 1, 'El Ultimo Amanecer', 2024, 118, 'Una historia post-apocalíptica sobre supervivencia', '+16', DATE '2025-01-15', 1, 6);

INSERT INTO contenido (contenido_id, categoria_id, titulo, anno_lanzamiento, duracion_minutos, sinopsis, clasificacion_edad, fecha_agregado, es_original, empleado_responsable_id)
VALUES (2, 1, 'Amor en Tiempo de Guerra', 2023, 125, 'Drama romántico durante el conflicto armado', '+13', DATE '2025-01-20', 0, 6);

INSERT INTO contenido (contenido_id, categoria_id, titulo, anno_lanzamiento, duracion_minutos, sinopsis, clasificacion_edad, fecha_agregado, es_original, empleado_responsable_id)
VALUES (3, 2, 'Caso Cerrado', 2024, NULL, 'Serie de suspenso sobre un detective', '+16', DATE '2025-02-01', 1, 6);

INSERT INTO contenido (contenido_id, categoria_id, titulo, anno_lanzamiento, duracion_minutos, sinopsis, clasificacion_edad, fecha_agregado, es_original, empleado_responsable_id)
VALUES (4, 2, 'Los NiÃ±os del Sol', 2023, NULL, 'Serie infantil animada', 'TP', DATE '2025-02-15', 1, 6);

INSERT INTO contenido (contenido_id, categoria_id, titulo, anno_lanzamiento, duracion_minutos, sinopsis, clasificacion_edad, fecha_agregado, es_original, empleado_responsable_id)
VALUES (5, 3, 'Colombia Verde', 2024, 90, 'Documental sobre la biodiversidad colombiana', '+7', DATE '2025-03-01', 0, 6);

INSERT INTO contenido (contenido_id, categoria_id, titulo, anno_lanzamiento, duracion_minutos, sinopsis, clasificacion_edad, fecha_agregado, es_original, empleado_responsable_id)
VALUES (6, 4, 'Salsa Classics', 2024, 60, 'Las mejores canciones de salsa', 'TP', DATE '2025-03-10', 1, 6);

INSERT INTO contenido (contenido_id, categoria_id, titulo, anno_lanzamiento, duracion_minutos, sinopsis, clasificacion_edad, fecha_agregado, es_original, empleado_responsable_id)
VALUES (7, 5, 'Tech Today', 2024, 45, 'Podcast sobre tecnología semanal', '+7', DATE '2025-03-15', 1, 6);

INSERT INTO contenido (contenido_id, categoria_id, titulo, anno_lanzamiento, duracion_minutos, sinopsis, clasificacion_edad, fecha_agregado, es_original, empleado_responsable_id)
VALUES (8, 1, 'El Silencio del Monte', 2024, 105, 'Terror psicológico en las montañas', '+18', DATE '2025-04-01', 0, 6);

INSERT INTO contenido (contenido_id, categoria_id, titulo, anno_lanzamiento, duracion_minutos, sinopsis, clasificacion_edad, fecha_agregado, es_original, empleado_responsable_id)
VALUES (9, 1, 'La Gran Fuga 2', 2023, 130, 'Secuela de la película más vista', '+13', DATE '2025-04-10', 0, 6);

INSERT INTO contenido (contenido_id, categoria_id, titulo, anno_lanzamiento, duracion_minutos, sinopsis, clasificacion_edad, fecha_agregado, es_original, empleado_responsable_id)
VALUES (10, 2, 'Crónicas Quindianas', 2024, NULL, 'Serie dramática sobre la historia regional', '+16', DATE '2025-04-15', 1, 6);

-- TEMPORADAS Y EPISODIOS
INSERT INTO temporada (temporada_id, contenido_id, numero) VALUES (1, 3, 1);
INSERT INTO temporada (temporada_id, contenido_id, numero) VALUES (2, 3, 2);
INSERT INTO temporada (temporada_id, contenido_id, numero) VALUES (3, 4, 1);
INSERT INTO temporada (temporada_id, contenido_id, numero) VALUES (4, 7, 1);
INSERT INTO temporada (temporada_id, contenido_id, numero) VALUES (5, 10, 1);

INSERT INTO episodio (episodio_id, temporada_id, numero, titulo, duracion_minutos) VALUES (1, 1, 1, 'El Comienzo', 45);
INSERT INTO episodio (episodio_id, temporada_id, numero, titulo, duracion_minutos) VALUES (2, 1, 2, 'La Investigación', 50);
INSERT INTO episodio (episodio_id, temporada_id, numero, titulo, duracion_minutos) VALUES (3, 1, 3, 'El Descubrimiento', 48);
INSERT INTO episodio (episodio_id, temporada_id, numero, titulo, duracion_minutos) VALUES (4, 2, 1, 'Nuevo Capítulo', 42);
INSERT INTO episodio (episodio_id, temporada_id, numero, titulo, duracion_minutos) VALUES (5, 2, 2, 'Giro Inesperado', 55);
INSERT INTO episodio (episodio_id, temporada_id, numero, titulo, duracion_minutos) VALUES (6, 3, 1, 'Amanecer en el Bosque', 22);
INSERT INTO episodio (episodio_id, temporada_id, numero, titulo, duracion_minutos) VALUES (7, 3, 2, 'Los Amigos del Sol', 25);
INSERT INTO episodio (episodio_id, temporada_id, numero, titulo, duracion_minutos) VALUES (8, 4, 1, 'Inteligencia Artificial', 60);
INSERT INTO episodio (episodio_id, temporada_id, numero, titulo, duracion_minutos) VALUES (9, 4, 2, 'Blockchain Explicado', 55);
INSERT INTO episodio (episodio_id, temporada_id, numero, titulo, duracion_minutos) VALUES (10, 5, 1, 'Origenes', 50);
INSERT INTO episodio (episodio_id, temporada_id, numero, titulo, duracion_minutos) VALUES (11, 5, 2, 'La Independencia', 52);

-- CONTENIDO_GENERO
INSERT INTO contenido_genero (contenido_id, genero_id) VALUES (1, 6);
INSERT INTO contenido_genero (contenido_id, genero_id) VALUES (1, 4);
INSERT INTO contenido_genero (contenido_id, genero_id) VALUES (2, 5);
INSERT INTO contenido_genero (contenido_id, genero_id) VALUES (2, 3);
INSERT INTO contenido_genero (contenido_id, genero_id) VALUES (3, 4);
INSERT INTO contenido_genero (contenido_id, genero_id) VALUES (3, 11);
INSERT INTO contenido_genero (contenido_id, genero_id) VALUES (4, 8);
INSERT INTO contenido_genero (contenido_id, genero_id) VALUES (4, 12);
INSERT INTO contenido_genero (contenido_id, genero_id) VALUES (5, 10);
INSERT INTO contenido_genero (contenido_id, genero_id) VALUES (5, 13);
INSERT INTO contenido_genero (contenido_id, genero_id) VALUES (6, 14);
INSERT INTO contenido_genero (contenido_id, genero_id) VALUES (7, 22);
INSERT INTO contenido_genero (contenido_id, genero_id) VALUES (8, 7);
INSERT INTO contenido_genero (contenido_id, genero_id) VALUES (8, 4);
INSERT INTO contenido_genero (contenido_id, genero_id) VALUES (9, 1);
INSERT INTO contenido_genero (contenido_id, genero_id) VALUES (9, 4);
INSERT INTO contenido_genero (contenido_id, genero_id) VALUES (10, 3);
INSERT INTO contenido_genero (contenido_id, genero_id) VALUES (10, 13);

-- REPRODUCCIONES
INSERT INTO reproduccion (reproduccion_id, perfil_id, contenido_id, episodio_id, fecha_inicio, fecha_fin, dispositivo, porcentaje_avance)
VALUES (1, 1, 1, NULL, TO_TIMESTAMP('2025-05-01 10:00:00','YYYY-MM-DD HH24:MI:SS'), TO_TIMESTAMP('2025-05-01 11:58:00','YYYY-MM-DD HH24:MI:SS'), 'TV', 100);

INSERT INTO reproduccion (reproduccion_id, perfil_id, contenido_id, episodio_id, fecha_inicio, fecha_fin, dispositivo, porcentaje_avance)
VALUES (2, 1, 2, NULL, TO_TIMESTAMP('2025-05-02 14:00:00','YYYY-MM-DD HH24:MI:SS'), TO_TIMESTAMP('2025-05-02 15:50:00','YYYY-MM-DD HH24:MI:SS'), 'COMPUTADOR', 100);

INSERT INTO reproduccion (reproduccion_id, perfil_id, contenido_id, episodio_id, fecha_inicio, fecha_fin, dispositivo, porcentaje_avance)
VALUES (3, 3, 3, 1, TO_TIMESTAMP('2025-05-03 20:00:00','YYYY-MM-DD HH24:MI:SS'), TO_TIMESTAMP('2025-05-03 20:45:00','YYYY-MM-DD HH24:MI:SS'), 'CELULAR', 100);

INSERT INTO reproduccion (reproduccion_id, perfil_id, contenido_id, episodio_id, fecha_inicio, fecha_fin, dispositivo, porcentaje_avance)
VALUES (4, 4, 5, NULL, TO_TIMESTAMP('2025-05-04 15:00:00','YYYY-MM-DD HH24:MI:SS'), TO_TIMESTAMP('2025-05-04 16:30:00','YYYY-MM-DD HH24:MI:SS'), 'TABLET', 100);

INSERT INTO reproduccion (reproduccion_id, perfil_id, contenido_id, episodio_id, fecha_inicio, fecha_fin, dispositivo, porcentaje_avance)
VALUES (5, 2, 4, 6, TO_TIMESTAMP('2025-05-05 09:00:00','YYYY-MM-DD HH24:MI:SS'), TO_TIMESTAMP('2025-05-05 09:22:00','YYYY-MM-DD HH24:MI:SS'), 'TV', 100);

INSERT INTO reproduccion (reproduccion_id, perfil_id, contenido_id, episodio_id, fecha_inicio, fecha_fin, dispositivo, porcentaje_avance)
VALUES (6, 6, 8, NULL, TO_TIMESTAMP('2025-05-10 22:00:00','YYYY-MM-DD HH24:MI:SS'), NULL, 'COMPUTADOR', 45);

INSERT INTO reproduccion (reproduccion_id, perfil_id, contenido_id, episodio_id, fecha_inicio, fecha_fin, dispositivo, porcentaje_avance)
VALUES (7, 8, 6, NULL, TO_TIMESTAMP('2025-05-11 11:00:00','YYYY-MM-DD HH24:MI:SS'), TO_TIMESTAMP('2025-05-11 11:55:00','YYYY-MM-DD HH24:MI:SS'), 'CELULAR', 100);

-- FAVORITOS
INSERT INTO favorito (perfil_id, contenido_id, fecha_agregado) VALUES (1, 1, DATE '2025-05-01');
INSERT INTO favorito (perfil_id, contenido_id, fecha_agregado) VALUES (1, 8, DATE '2025-05-10');
INSERT INTO favorito (perfil_id, contenido_id, fecha_agregado) VALUES (3, 3, DATE '2025-05-03');
INSERT INTO favorito (perfil_id, contenido_id, fecha_agregado) VALUES (4, 5, DATE '2025-05-04');
INSERT INTO favorito (perfil_id, contenido_id, fecha_agregado) VALUES (6, 8, DATE '2025-05-10');
INSERT INTO favorito (perfil_id, contenido_id, fecha_agregado) VALUES (8, 6, DATE '2025-05-11');

-- RESEÑAS
INSERT INTO resena (resena_id, perfil_id, contenido_id, calificacion, texto, fecha_publicacion)
VALUES (1, 1, 1, 5, 'Excelente película, muy recomendable', DATE '2025-05-01');

INSERT INTO resena (resena_id, perfil_id, contenido_id, calificacion, texto, fecha_publicacion)
VALUES (2, 1, 2, 4, 'Buen drama, algo largo', DATE '2025-05-02');

INSERT INTO resena (resena_id, perfil_id, contenido_id, calificacion, texto, fecha_publicacion)
VALUES (3, 3, 3, 5, 'Serie muy addictive', DATE '2025-05-03');

INSERT INTO resena (resena_id, perfil_id, contenido_id, calificacion, texto, fecha_publicacion)
VALUES (4, 4, 5, 4, 'Documental interesante', DATE '2025-05-04');

INSERT INTO resena (resena_id, perfil_id, contenido_id, calificacion, texto, fecha_publicacion)
VALUES (5, 6, 8, 3, 'Da miedo pero no me gustó tanto', DATE '2025-05-10');

-- REPORTES
INSERT INTO reporte (reporte_id, contenido_id, perfil_id, moderador_id, motivo, estado, fecha_reporte, fecha_resolucion)
VALUES (1, 8, 6, 7, 'Contenido muy violento para la clasificación', 'APROBADO', DATE '2025-05-11', DATE '2025-05-12');

INSERT INTO reporte (reporte_id, contenido_id, perfil_id, moderador_id, motivo, estado, fecha_reporte, fecha_resolucion)
VALUES (2, 1, 7, NULL, 'No funciona el audio', 'PENDIENTE', DATE '2025-05-15', NULL);

-- FACTURAS
INSERT INTO factura (factura_id, usuario_id, periodo, monto_total, estado_factura, fecha_emision, fecha_vencimiento)
VALUES (1, 1, '2025-05', 14900, 'PAGADA', DATE '2025-05-01', DATE '2025-05-31');

INSERT INTO factura (factura_id, usuario_id, periodo, monto_total, estado_factura, fecha_emision, fecha_vencimiento)
VALUES (2, 2, '2025-05', 24900, 'PAGADA', DATE '2025-05-01', DATE '2025-05-31');

INSERT INTO factura (factura_id, usuario_id, periodo, monto_total, estado_factura, fecha_emision, fecha_vencimiento)
VALUES (3, 3, '2025-05', 34900, 'PAGADA', DATE '2025-05-01', DATE '2025-05-31');

-- PAGOS
INSERT INTO pago (pago_id, factura_id, fecha_pago, monto_pagado, metodo_pago, estado_pago, referencia)
VALUES (1, 1, DATE '2025-05-03', 14900, 'TCREDITO', 'EXITOSO', 'REF-00001');

INSERT INTO pago (pago_id, factura_id, fecha_pago, monto_pagado, metodo_pago, estado_pago, referencia)
VALUES (2, 2, DATE '2025-05-05', 24900, 'PSE', 'EXITOSO', 'REF-00002');

INSERT INTO pago (pago_id, factura_id, fecha_pago, monto_pagado, metodo_pago, estado_pago, referencia)
VALUES (3, 3, DATE '2025-05-02', 34900, 'NEQUI', 'EXITOSO', 'REF-00003');

COMMIT;