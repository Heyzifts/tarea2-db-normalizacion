CREATE TABLE restaurantes
(
    id     SERIAL       NOT NULL,
    nombre VARCHAR(256) NOT NULL,
    CONSTRAINT restaurantes_id_pk PRIMARY KEY (id),
    CONSTRAINT restaurantes_nombre_uk UNIQUE (nombre)
);

CREATE TABLE productos
(
    id             SERIAL       NOT NULL,
    nombre         VARCHAR(256) NOT NULL,
    restaurante_id INTEGER      NOT NULL,
    CONSTRAINT productos_id_pk PRIMARY KEY (id),
    CONSTRAINT productos_nombre_restaurante_id_uk UNIQUE (nombre, restaurante_id),
    CONSTRAINT productos_restaurante_id_fk FOREIGN KEY (restaurante_id) REFERENCES restaurantes (id)
);


CREATE TABLE producto_precios
(
    id          SERIAL         NOT NULL,
    producto_id INTEGER        NOT NULL,
    precio      numeric(10, 2) NOT NULL,
    date        date           NOT NULL,
    CONSTRAINT producto_precios_id_pk PRIMARY KEY (id),
    CONSTRAINT producto_precios_producto_id_fk FOREIGN KEY (producto_id) REFERENCES productos (id)
);

CREATE TABLE ordenes
(
    id SERIAL NOT NULL,
    CONSTRAINT ordenes_id_pk PRIMARY KEY (id)
);

CREATE TABLE orden_productos
(
    id         SERIAL  NOT NULL,
    orden_id   INTEGER NOT NULL,
    product_id INTEGER NOT NULL,
    cantidad   INTEGER NOT NULL,
    CONSTRAINT orden_productos_id_pk PRIMARY KEY (id),
    CONSTRAINT orden_productos_orden_id_fk FOREIGN KEY (orden_id) REFERENCES ordenes (id),
    CONSTRAINT orden_productos_producto_id FOREIGN KEY (product_id) REFERENCES productos (id)
);


INSERT INTO restaurantes (nombre)
VALUES ('Dennys'),
       ('Pizza Hut');

INSERT INTO productos (nombre, restaurante_id)
VALUES ('Hamburgers', (SELECT id FROM restaurantes WHERE restaurantes.nombre = 'Dennys')),
       ('Pollo', (SELECT id FROM restaurantes WHERE restaurantes.nombre = 'Dennys')),
       ('Pollo', (SELECT id FROM restaurantes WHERE restaurantes.nombre = 'Pizza Hut')),
       ('Carne', (SELECT id FROM restaurantes WHERE restaurantes.nombre = 'Dennys')),
       ('Refresco', (SELECT id FROM restaurantes WHERE restaurantes.nombre = 'Dennys')),
       ('Pizza', (SELECT id FROM restaurantes WHERE restaurantes.nombre = 'Pizza Hut'));

INSERT INTO producto_precios (producto_id, precio, date)
VALUES ((SELECT id FROM productos WHERE nombre = 'Hamburgers'), 100, '2023-01-30'),
       ((SELECT id
         FROM productos
         WHERE nombre = 'Pollo'
           AND restaurante_id = (SELECT id FROM restaurantes WHERE restaurantes.nombre = 'Dennys')), 50, '2023-01-30'),
       ((SELECT id
         FROM productos
         WHERE nombre = 'Pollo'
           AND restaurante_id = (SELECT id FROM restaurantes WHERE restaurantes.nombre = 'Pizza Hut')), 50,
        '2023-01-30'),
       ((SELECT id FROM productos WHERE nombre = 'Carne'), 90, '2023-01-30'),
       ((SELECT id FROM productos WHERE nombre = 'Refresco'), 20, '2023-01-30'),
       ((SELECT id FROM productos WHERE nombre = 'Pizza'), 150, '2023-01-30');

INSERT INTO ordenes (id)
VALUES (DEFAULT);

INSERT INTO orden_productos (orden_id, product_id, cantidad)
VALUES ((SELECT id FROM ordenes LIMIT 1), (SELECT id FROM productos WHERE nombre = 'Hamburgers'), 2),
       ((SELECT id FROM ordenes LIMIT 1), (SELECT id
                                           FROM productos
                                           WHERE nombre = 'Pollo'
                                             AND restaurante_id =
                                                 (SELECT id FROM restaurantes WHERE restaurantes.nombre = 'Dennys')),
        1),
       ((SELECT id FROM ordenes LIMIT 1), (SELECT id
                                           FROM productos
                                           WHERE nombre = 'Pollo'
                                             AND restaurante_id =
                                                 (SELECT id FROM restaurantes WHERE restaurantes.nombre = 'Pizza Hut')),
        2),
       ((SELECT id FROM ordenes LIMIT 1), (SELECT id FROM productos WHERE nombre = 'Carne'), 1),
       ((SELECT id FROM ordenes LIMIT 1), (SELECT id FROM productos WHERE nombre = 'Refresco'), 2),
       ((SELECT id FROM ordenes LIMIT 1), (SELECT id FROM productos WHERE nombre = 'Pizza'), 2);

SELECT r.nombre      as restaurante,
       p.nombre      as producto,
       op.cantidad,
       ((SELECT precio FROM producto_precios WHERE producto_precios.producto_id = p.id ORDER BY date DESC LIMIT 1) *
        op.cantidad) as precio
FROM ordenes o
         INNER JOIN orden_productos op on o.id = op.orden_id
         INNER JOIN productos p on p.id = op.product_id
         INNER JOIN restaurantes r on r.id = p.restaurante_id
ORDER BY r.nombre;

