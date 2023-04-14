CREATE TABLE unit (id INT PRIMARY KEY NOT NULL, unit_name VARCHAR(64) NOT NULL, unit_short VARCHAR(8));

CREATE TABLE city (id INT PRIMARY KEY NOT NULL, city_name VARCHAR(128) NOT NULL, postal_code VARCHAR(16) NOT NULL);

CREATE TABLE employee (id INT PRIMARY KEY NOT NULL, employee_code VARCHAR(32) NOT NULL, first_name VARCHAR(64) NOT NULL, 
    last_name VARCHAR(64) NOT NULL);

CREATE TABLE customer (id INT PRIMARY KEY NOT NULL, first_name VARCHAR(64) NOT NULL, last_name VARCHAR(64) NOT NULL, 
    user_name VARCHAR(64) NOT NULL, password VARCHAR(64) NOT NULL, time_inserted TIMESTAMP NOT NULL, confirmation_code VARCHAR(255) NOT NULL, 
    time_confirmed TIMESTAMP, contact_email VARCHAR(128) NOT NULL, contact_phone VARCHAR(128), city_id INT REFERENCES city(id), 
    address VARCHAR(255), delivery_city_id INT REFERENCES city(id), delivery_address VARCHAR(255));

CREATE TABLE item (id INT PRIMARY KEY NOT NULL, item_name VARCHAR(255) NOT NULL, price DECIMAL(10,2) NOT NULL, item_photo TEXT, 
    description TEXT, unit_id INT REFERENCES unit(id) NOT NULL);

CREATE TABLE placed_order (id INT PRIMARY KEY NOT NULL, customer_id INT REFERENCES customer(id) NOT NULL, time_placed TIMESTAMP NOT NULL, 
    details TEXT, delivery_city_id INT REFERENCES city(id) NOT NULL, delivery_address VARCHAR(255) NOT NULL, grade_customer INT, grade_employee INT);

CREATE TABLE delivery (id INT PRIMARY KEY NOT NULL, delivery_time_planned TIMESTAMP NOT NULL, delivery_time_actual TIMESTAMP, notes TEXT, 
    placed_order_id INT REFERENCES placed_order(id) NOT NULL, employee_id INT REFERENCES employee(id));

CREATE TABLE box (id INT PRIMARY KEY NOT NULL, box_code VARCHAR(32) NOT NULL, delivery_id INT REFERENCES delivery(id) NOT NULL, 
    employee_id INT REFERENCES employee(id) NOT NULL);

CREATE TABLE item_in_box (id INT PRIMARY KEY NOT NULL, box_id INT REFERENCES box(id) NOT NULL, item_id INT REFERENCES item(id) NOT NULL, 
    quantity DECIMAL(10,3) NOT NULL, is_replacement bool NOT NULL);

CREATE TABLE order_item (id INT PRIMARY KEY NOT NULL, placed_order_id INT REFERENCES placed_order(id) NOT NULL, item_id INT REFERENCES item(id) NOT NULL, 
    quantity DECIMAL(10,3) NOT NULL, price DECIMAL(10,2) NOT NULL);

CREATE TABLE status_catalog (id INT PRIMARY KEY NOT NULL, status_name VARCHAR(128) NOT NULL);

CREATE TABLE order_status (id INT PRIMARY KEY NOT NULL, placed_order_id INT REFERENCES placed_order(id) NOT NULL, 
    status_catalog_id INT REFERENCES status_catalog(id) NOT NULL, status_time TIMESTAMP NOT NULL, details TEXT);

CREATE TABLE notes (id INT PRIMARY KEY NOT NULL, placed_order_id INT REFERENCES placed_order(id) NOT NULL, employee_id INT REFERENCES employee(id), 
    customer_id INT REFERENCES customer(id), note_time TIMESTAMP, note_TEXT TEXT);

