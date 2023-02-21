CREATE TABLE combustibles
(
    id     SERIAL NOT NULL,
    nombre VARCHAR(30)
);

CREATE TABLE precios
(
    id             SERIAL         NOT NULL,
    combustible_id INTEGER        NOT NULL,
    date           date           not null,
    price          NUMERIC(10, 2) NOT NULL,
    pais_id        INTEGER        NOT NULL,
    CONSTRAINT precios_id_pk PRIMARY KEY (id),
    CONSTRAINT precios_pais_id_fk FOREIGN KEY (pais_id) REFERENCES paises (id)
);

CREATE TABLE paises
(
    id        SERIAL       NOT NULL,
    nombre    VARCHAR(256) NOT NULL,
    moneda_id INTEGER      NOT NULL,
    CONSTRAINT paises_id_pk PRIMARY KEY (id),
    CONSTRAINT paises_nombre_uk UNIQUE (nombre),
    CONSTRAINT paises_moneda_id_fk FOREIGN KEY (moneda_id) REFERENCES monedas (id)
);

CREATE TABLE monedas
(
    id     SERIAL       NOT NULL,
    nombre VARCHAR(100) NOT NULL,
    CONSTRAINT monedas_id_pk PRIMARY KEY (id),
    CONSTRAINT monedas_nombre_uk UNIQUE (nombre)
);

INSERT INTO combustibles (nombre)
VALUES ('Superior'),
       ('Regular'),
       ('Diesel'),
       ('LPG');

INSERT INTO monedas (nombre)
VALUES ('LPS');

INSERT INTO paises (nombre, moneda_id)
VALUES ('Honduras', (SELECT id FROM monedas WHERE monedas.nombre = 'LPS'));

INSERT INTO precios (combustible_id, date, price, pais_id)
VALUES ((SELECT id FROM combustibles WHERE combustibles.nombre = 'Superior'), '2023-01-30', 100,
        (SELECT id FROM paises WHERE paises.nombre = 'Honduras')),
       ((SELECT id FROM combustibles WHERE combustibles.nombre = 'Superior'), '2023-02-15', 130,
        (SELECT id FROM paises WHERE paises.nombre = 'Honduras'));


SELECT c.nombre                                                                                            as Combustible,
       (SELECT price FROM precios WHERE precios.combustible_id = c.id ORDER BY date DESC LIMIT 1 OFFSET 1) as Antes,
       (SELECT price FROM precios WHERE precios.combustible_id = c.id ORDER BY date DESC LIMIT 1)          as Despues
FROM combustibles AS c;

