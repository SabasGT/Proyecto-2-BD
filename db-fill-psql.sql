CREATE TABLE unit (id INT PRIMARY KEY NOT NULL, unit_name VARCHAR(64) NOT NULL, unit_short VARCHAR(8));

INSERT INTO unit (SELECT id, unit_name, unit_short FROM unit_dump WHERE unit_name IS NOT NULL);

CREATE TABLE city (id INT PRIMARY KEY NOT NULL, city_name VARCHAR(128) NOT NULL, postal_code VARCHAR(16) NOT NULL);

ALTER TABLE city_dump
RENAME "Zip Code" TO postal_code;

ALTER TABLE city_dump
RENAME "Official USPS city name" TO city_name;

INSERT INTO city (SELECT id, city_name, postal_code FROM city_dump);

CREATE TABLE employee (id INT PRIMARY KEY NOT NULL, employee_code VARCHAR(32) NOT NULL, first_name VARCHAR(64) NOT NULL, 
    last_name VARCHAR(64) NOT NULL);

INSERT INTO employee (SELECT id, employee_code, first_name, last_name FROM employee_dump WHERE last_name IS NOT NULL);

CREATE TABLE customer (id INT PRIMARY KEY NOT NULL, first_name VARCHAR(64) NOT NULL, last_name VARCHAR(64) NOT NULL, 
    user_name VARCHAR(64) NOT NULL, password VARCHAR(64) NOT NULL, time_inserted TIMESTAMP NOT NULL, confirmation_code VARCHAR(255) NOT NULL, 
    time_confirmed TIMESTAMP, contact_email VARCHAR(128) NOT NULL, contact_phone VARCHAR(128), city_id INT REFERENCES city(id), 
    address VARCHAR(255), delivery_city_id INT REFERENCES city(id), delivery_address VARCHAR(255));

INSERT INTO customer (SELECT id, first_name, last_name, user_name, password, time_inserted, confirmation_code, time_confirmed, contact_email, contact_phone, city_id, address, delivery_city_id, delivery_address FROM customer_dump WHERE contact_email IS NOT NULL);

CREATE TABLE item (id INT PRIMARY KEY NOT NULL, item_name VARCHAR(255) NOT NULL, price DECIMAL(10,2) NOT NULL, item_photo TEXT, 
    description TEXT, unit_id INT REFERENCES unit(id) NOT NULL);

INSERT INTO item (SELECT id, item_name, price, item_photo, description, unit_id FROM item_dump WHERE item_name IS NOT NULL);

CREATE TABLE placed_order (id INT PRIMARY KEY NOT NULL, customer_id INT REFERENCES customer(id) NOT NULL, time_placed TIMESTAMP NOT NULL, 
    details TEXT, delivery_city_id INT REFERENCES city(id) NOT NULL, delivery_address VARCHAR(255) NOT NULL, grade_customer INT, grade_employee INT);

INSERT INTO placed_order (SELECT id, customer_id, time_placed, details, delivery_city_id, delivery_address, grade_customer, grade_employee FROM placed_order_dump WHERE delivery_address IS NOT NULL);

CREATE TABLE delivery (id INT PRIMARY KEY NOT NULL, delivery_time_planned TIMESTAMP NOT NULL, delivery_time_actual TIMESTAMP, notes TEXT, 
    placed_order_id INT REFERENCES placed_order(id) NOT NULL, employee_id INT REFERENCES employee(id));

INSERT INTO delivery (SELECT id, delivery_time_planned, delivery_time_actual, notes, placed_order_id, employee_id FROM delivery_dump WHERE placed_order_id IS NOT NULL);

CREATE TABLE "box" (id INT PRIMARY KEY NOT NULL, box_code VARCHAR(32) NOT NULL, delivery_id INT REFERENCES delivery(id) NOT NULL, 
    employee_id INT REFERENCES employee(id) NOT NULL);

INSERT INTO "box" (SELECT id, box_code, delivery_id, employee_id FROM box_dump WHERE box_code IS NOT NULL);

CREATE TABLE item_in_box (id INT PRIMARY KEY NOT NULL, box_id INT REFERENCES box(id) NOT NULL, item_id INT REFERENCES item(id) NOT NULL, 
    quantity DECIMAL(10,3) NOT NULL, is_replacement bool NOT NULL);

INSERT INTO item_in_box (SELECT id, box_id, item_id, quantity, is_replacement FROM item_in_box_dump WHERE quantity IS NOT NULL);

CREATE TABLE order_item (id INT PRIMARY KEY NOT NULL, placed_order_id INT REFERENCES placed_order(id) NOT NULL, item_id INT REFERENCES item(id) NOT NULL, 
    quantity DECIMAL(10,3) NOT NULL, price DECIMAL(10,2) NOT NULL);

INSERT INTO order_item (SELECT id, placed_order_id, item_id, quantity, price FROM order_item_dump WHERE price IS NOT NULL);

CREATE TABLE status_catalog (id INT PRIMARY KEY NOT NULL, status_name VARCHAR(128) NOT NULL);

INSERT INTO status_catalog (SELECT id, status_name FROM status_catalog_dump WHERE status_name IS NOT NULL);

CREATE TABLE order_status (id INT PRIMARY KEY NOT NULL, placed_order_id INT REFERENCES placed_order(id) NOT NULL, 
    status_catalog_id INT REFERENCES status_catalog(id) NOT NULL, status_time TIMESTAMP NOT NULL, details TEXT);

INSERT INTO order_status (SELECT id, placed_order_id, status_catalog_id, status_time, details FROM order_status_dump WHERE status_time IS NOT NULL);

CREATE TABLE notes (id INT PRIMARY KEY NOT NULL, placed_order_id INT REFERENCES placed_order(id) NOT NULL, employee_id INT REFERENCES employee(id), 
    customer_id INT REFERENCES customer(id), note_time TIMESTAMP, note_TEXT TEXT);

INSERT INTO notes (SELECT id, placed_order_id, employee_id, customer_id, note_time, note_TEXT FROM notes_dump WHERE placed_order_id IS NOT NULL);

