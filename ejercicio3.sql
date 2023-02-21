CREATE TABLE peajes
(
    id     SERIAL       NOT NULL,
    nombre VARCHAR(256) NOT NULL,
    CONSTRAINT peajes_id_pk PRIMARY KEY (id),
    CONSTRAINT peajes_nombre_uk UNIQUE (nombre)
);

CREATE TABLE vehiculos
(
    id     SERIAL       NOT NULL,
    nombre VARCHAR(256) NOT NULL,
    CONSTRAINT vehiculos_id_pk PRIMARY KEY (id),
    CONSTRAINT vehiculos_nombre_uk UNIQUE (nombre)
);

CREATE TABLE vehiculo_tarifas
(
    id          SERIAL  NOT NULL,
    peaje_id    INTEGER NOT NULL,
    vehiculo_id INTEGER NOT NULL,
    tarifa      INTEGER NOT NULL,
    date        DATE    NOT NULL,
    CONSTRAINT vehiculo_tarifas_id_pk PRIMARY KEY (id),
    CONSTRAINT vehiculo_tarifas_vehiculo_id_fk FOREIGN KEY (vehiculo_id) REFERENCES vehiculos (id),
    CONSTRAINT vehiculo_tarifas_peaje_id_fk FOREIGN KEY (peaje_id) REFERENCES peajes (id)
);

INSERT INTO peajes (nombre)
VALUES ('Peaje Zambrano');

INSERT INTO vehiculos (nombre)
VALUES ('Turismo'),
       ('3 ejes'),
       ('4 ejes'),
       ('5 ejes');

INSERT INTO vehiculo_tarifas (vehiculo_id, peaje_id, tarifa, date)
VALUES ((SELECT id FROM vehiculos WHERE nombre = 'Turismo'),
        (SELECT id FROM peajes WHERE peajes.nombre = 'Peaje Zambrano'), 20, '2022-01-29'),
       ((SELECT id FROM vehiculos WHERE nombre = 'Turismo'),
        (SELECT id FROM peajes WHERE peajes.nombre = 'Peaje Zambrano'), 23, '2022-01-30'),
       ((SELECT id FROM vehiculos WHERE nombre = '3 ejes'),
        (SELECT id FROM peajes WHERE peajes.nombre = 'Peaje Zambrano'), 25, '2022-01-30'),
       ((SELECT id FROM vehiculos WHERE nombre = '4 ejes'),
        (SELECT id FROM peajes WHERE peajes.nombre = 'Peaje Zambrano'), 30, '2022-01-30'),
       ((SELECT id FROM vehiculos WHERE nombre = '5 ejes'),
        (SELECT id FROM peajes WHERE peajes.nombre = 'Peaje Zambrano'), 60, '2022-01-30');

SELECT p.nombre, vt.date, v.nombre, vt.tarifa
FROM peajes p
         INNER JOIN vehiculo_tarifas vt on p.id = vt.peaje_id
         INNER JOIN vehiculos v on vt.vehiculo_id = v.id
WHERE vt.date = '2022-01-30';

