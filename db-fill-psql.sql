CREATE TABLE unit (id INT PRIMARY KEY NOT NULL, unit_name varchar(64) NOT NULL, unit_short varchar(8));

CREATE TABLE item (id INT PRIMARY KEY NOT NULL, item_name varchar(255) NOT NULL, price decimal(10,2) NOT NULL, item_photo text, description text, unit_id int REFERENCES unit(id) NOT NULL);

CREATE TABLE order_item (id INT PRIMARY KEY NOT NULL, placed_order_id int REFERENCES placed_order(id) NOT NULL, item_id int REFERENCES item(id) NOT NULL, quantity decimal(10,3) NOT NULL, price decimal(10,2) NOT NULL);

CREATE TABLE item_in_box (id INT PRIMARY KEY NOT NULL, box_id int REFERENCES box(id) NOT NULL, item_id int REFERENCES item(id) NOT NULL, quantity decimal(10,3) NOT NULL, is_replacement bool NOT NULL);

CREATE TABLE placed_order (id INT PRIMARY KEY NOT NULL, customer_id int REFERENCES customer(id) NOT NULL, time_placed timestamp NOT NULL, details text, delivery_city_id varchar(255) NOT NULL, grade_customer int, grade_employee int);

CREATE TABLE delivery (id INT PRIMARY KEY NOT NULL, delivery_time_planned timestamp NOT NULL, delivery_time_actual timestamp, notes text, placed_order_id int REFERENCES placed_order(id) NOT NULL, employee_id int REFERENCES employee(id));

CREATE TABLE box (id INT PRIMARY KEY NOT NULL, box_code varchar(32) NOT NULL, delivery_id int REFERENCES delivery(id) NOT NULL, employee_id int REFERENCES employee(id) NOT NULL);

CREATE TABLE order_status (id INT PRIMARY KEY NOT NULL, placed_order_id int REFERENCES placed_order(id) NOT NULL, status_catalog_id int REFERENCES status_catalog(id) NOT NULL, status_time timestamp NOT NULL, details text);

CREATE TABLE notes (id INT PRIMARY KEY NOT NULL, placed_order_id int REFERENCES placed_order(id) NOT NULL, employee_id int REFERENCES employee(id), customer_id int REFERENCES customer(id), note_time timestamp, note_text text);

CREATE TABLE status_catalog (id INT PRIMARY KEY NOT NULL, status_name varchar(128) NOT NULL);

CREATE TABLE city (id INT PRIMARY KEY NOT NULL, city_name varchar(128) NOT NULL, postal_code varchar(16) NOT NULL);

CREATE TABLE customer (id INT PRIMARY KEY NOT NULL, first_name varchar(64) NOT NULL, last_name varchar(64) NOT NULL, user_name varchar(64) NOT NULL, password varchar(64) NOT NULL, time_inserted timestamp NOT NULL, confirmation_code varchar(255) NOT NULL, time_confirmed timestamp, contact_email varchar(128) NOT NULL, contact_phone varchar(128), city_id int REFERENCES city(id), address varchar(255), delivery_city_id int REFERENCES city(id), delivery_address varchar(255));

CREATE TABLE employee (id INT PRIMARY KEY NOT NULL, employee_code varchar(32) NOT NULL, first_name varchar(64) NOT NULL, last_name varchar(64) NOT NULL);

