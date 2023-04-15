CREATE TABLE unit_dump (id INT PRIMARY KEY NOT NULL, unit_name VARCHAR(64) NOT NULL, unit_short VARCHAR(8));

CREATE TABLE city_dump (id SERIAL PRIMARY KEY NOT NULL, "Zip Code" VARCHAR(16) NOT NULL, "Official USPS city name" VARCHAR(128));

CREATE TABLE employee_dump (id INT PRIMARY KEY NOT NULL, employee_code VARCHAR(32) NOT NULL, first_name VARCHAR(64) NOT NULL, 
    last_name VARCHAR(64) NOT NULL);

CREATE TABLE customer_dump (id INT PRIMARY KEY NOT NULL, first_name VARCHAR(64) NOT NULL, last_name VARCHAR(64) NOT NULL, 
    user_name VARCHAR(64) NOT NULL, password VARCHAR(64) NOT NULL, time_inserted TIMESTAMP NOT NULL, confirmation_code VARCHAR(255) NOT NULL, 
    time_confirmed TIMESTAMP, contact_email VARCHAR(128) NOT NULL, contact_phone VARCHAR(128), city_id INT REFERENCES city_dump(id), 
    address VARCHAR(255), delivery_city_id INT REFERENCES city_dump(id), delivery_address VARCHAR(255));

CREATE TABLE item_dump (id INT PRIMARY KEY NOT NULL, item_name VARCHAR(255) NOT NULL, price DECIMAL(10,2) NOT NULL, item_photo TEXT, 
    description TEXT, unit_id INT REFERENCES unit_dump(id) NOT NULL);

CREATE TABLE placed_order_dump (id INT PRIMARY KEY NOT NULL, customer_id INT REFERENCES customer_dump(id) NOT NULL, time_placed TIMESTAMP NOT NULL, 
    details TEXT, delivery_city_id INT REFERENCES city_dump(id) NOT NULL, delivery_address VARCHAR(255) NOT NULL, grade_customer INT, grade_employee INT);

CREATE TABLE delivery_dump (id INT PRIMARY KEY NOT NULL, delivery_time_planned TIMESTAMP NOT NULL, delivery_time_actual TIMESTAMP, notes TEXT, 
    placed_order_id INT REFERENCES placed_order_dump(id) NOT NULL, employee_id INT REFERENCES employee_dump(id));

CREATE TABLE box_dump (id INT PRIMARY KEY NOT NULL, box_code VARCHAR(32) NOT NULL, delivery_id INT REFERENCES delivery_dump(id) NOT NULL, 
    employee_id INT REFERENCES employee_dump(id) NOT NULL);

CREATE TABLE item_in_box_dump (id INT PRIMARY KEY NOT NULL, box_id INT REFERENCES box_dump(id) NOT NULL, item_id INT REFERENCES item_dump(id) NOT NULL, 
    quantity DECIMAL(10,3) NOT NULL, is_replacement bool NOT NULL);

CREATE TABLE order_item_dump (id INT PRIMARY KEY NOT NULL, placed_order_id INT REFERENCES placed_order_dump(id) NOT NULL, item_id INT REFERENCES item_dump(id) NOT NULL, 
    quantity DECIMAL(10,3) NOT NULL, price DECIMAL(10,2) NOT NULL);

CREATE TABLE status_catalog_dump (id INT PRIMARY KEY NOT NULL, status_name VARCHAR(128) NOT NULL);

CREATE TABLE order_status_dump (id INT PRIMARY KEY NOT NULL, placed_order_id INT REFERENCES placed_order_dump(id) NOT NULL, 
    status_catalog_id INT REFERENCES status_catalog_dump(id) NOT NULL, status_time TIMESTAMP NOT NULL, details TEXT);

CREATE TABLE notes_dump (id INT PRIMARY KEY NOT NULL, placed_order_id INT REFERENCES placed_order_dump(id) NOT NULL, employee_id INT REFERENCES employee_dump(id), 
    customer_id INT REFERENCES customer_dump(id), note_time TIMESTAMP, note_TEXT TEXT);

