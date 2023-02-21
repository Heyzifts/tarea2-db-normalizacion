CREATE TABLE transportes
(
    id     SERIAL       NOT NULL,
    nombre VARCHAR(256) NOT NULL,
    CONSTRAINT transportes_id_pk PRIMARY KEY (id),
    CONSTRAINT transportes_nombre_uk UNIQUE (nombre)
);

CREATE TABLE rutas
(
    id            SERIAL       NOT NULL,
    nombre        VARCHAR(256) NOT NULL,
    transporte_id INTEGER      NOT NULL,
    CONSTRAINT rutas_id_pk PRIMARY KEY (id),
    CONSTRAINT rutas_nombre_uk UNIQUE (nombre),
    CONSTRAINT rutas_transporte_id_fk FOREIGN KEY (transporte_id) REFERENCES transportes (id)
);

CREATE TABLE ruta_precios
(
    id      SERIAL  NOT NULL,
    ruta_id INTEGER NOT NULL,
    tarifa  INTEGER NOT NULL,
    date    DATE    NOT NULL,
    CONSTRAINT ruta_precios_id_pk PRIMARY KEY (id),
    CONSTRAINT ruta_precios_ruta_id_fk FOREIGN KEY (ruta_id) REFERENCES rutas (id)
);

INSERT INTO transportes (nombre)
VALUES ('Transporte Sula');

INSERT INTO rutas (nombre, transporte_id)
VALUES ('centro - salida', (SELECT id FROM transportes WHERE nombre = 'Transporte Sula')),
       ('centro - satelite', (SELECT id FROM transportes WHERE nombre = 'Transporte Sula')),
       ('centro - progreso', (SELECT id FROM transportes WHERE nombre = 'Transporte Sula')),
       ('salida - satelite', (SELECT id FROM transportes WHERE nombre = 'Transporte Sula')),
       ('salida - progreso', (SELECT id FROM transportes WHERE nombre = 'Transporte Sula')),
       ('satelite - progreso', (SELECT id FROM transportes WHERE nombre = 'Transporte Sula'));

INSERT INTO ruta_precios (ruta_id, tarifa, date)
VALUES ((SELECT id FROM rutas WHERE nombre = 'centro - salida'), 8, '2022-01-29'),
       ((SELECT id FROM rutas WHERE nombre = 'centro - salida'), 10, '2022-01-30'),
       ((SELECT id FROM rutas WHERE nombre = 'centro - satelite'), 15, '2022-01-30'),
       ((SELECT id FROM rutas WHERE nombre = 'centro - progreso'), 25, '2022-01-30'),
       ((SELECT id FROM rutas WHERE nombre = 'salida - satelite'), 11, '2022-01-30'),
       ((SELECT id FROM rutas WHERE nombre = 'salida - progreso'), 20, '2022-01-30'),
       ((SELECT id FROM rutas WHERE nombre = 'satelite - progreso'), 30, '2022-01-30');


SELECT t.nombre as transporte, rp.date as date, r.nombre as ruta, rp.tarifa as precio
FROM transportes t
         INNER JOIN rutas r on t.id = r.transporte_id
         INNER JOIN ruta_precios rp on r.id = rp.ruta_id
WHERE rp.date = '2022-01-30';

