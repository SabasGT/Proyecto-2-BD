-- No estoy seguro que LIMIT acepte subqueries, podemos usar el siguiente WHERE:
-- WHERE ROWNUM < (subquery de 5%) 
-- ROWNUM puede no estar en PSQL, capaz es necesario SELECT row_number() over() IMPORTANTE
--QUERY A
SELECT DISTINCT cty.*
    FROM placed_order AS po
    NATURAL JOIN 
    (SELECT placed_order_id AS id, Sum(price * quantity) AS cost
        FROM order_item
        GROUP BY placed_order_id
    ORDER BY cost DESC
    LIMIT (SELECT FLOOR(Count(id) * 0.05) FROM placed_order)) AS ord_cost
    JOIN city AS cty
        ON po.delivery_city_id =  cty.id

--Calculo de coste total de una orden
SELECT placed_order_id AS po_id, Sum(price * quantity) AS cost
    FROM order_item
    GROUP BY placed_order_id
ORDER BY cost DESC

--Calculo de 5%
SELECT FLOOR(Count(id) * 0.05) FROM placed_order


--QUERY B REVISAR
SELECT DISTINCT cty.*
    FROM
    (SELECT delivery_city_id AS id, AVG(d.delay) AS avg_delay
        FROM placed_order AS po
        JOIN 
        (SELECT placed_order_id AS poid, (delivery_time_actual - delivery_time_planned) AS delay
            FROM delivery
            WHERE (delivery_time_actual > delivery_time_planned)) AS d
            ON po.id = d.poid
        GROUP BY delivery_city_id
        ORDER BY avg_delay) AS d2
	NATURAL JOIN city AS cty
LIMIT 5;


(SELECT placed_order_id AS poid, (delivery_time_actual - delivery_time_planned) AS delay
            FROM delivery
            WHERE (delivery_time_actual > delivery_time_planned)) AS d
            ON po.id = d.poid
        ORDER BY d.delay DESC)

--QUERY C
SELECT c.*
    FROM customer AS c
    NATURAL JOIN 
    (SELECT customer_id AS id, Count(id) AS qty
        FROM placed_order
        GROUP BY customer_id) AS count
    ORDER BY qty DESC
LIMIT 10;


--Probar si DENSE_RANK asi nos da lo que necesitamos
--QUERY D
SELECT i.*
    FROM placed_order AS po
    JOIN order_item AS oi
        ON po.id = oi.placed_order_id
    JOIN item AS i
        ON i.id = oi.item_id
    JOIN
    (SELECT placed_order_id
        FROM (SELECT placed_order_id, DENSE_RANK() OVER (ORDER BY (delivery_time_actual - delivery_time_planned) DESC) AS rnk
                FROM delivery
                WHERE delivery_time_actual > delivery_time_planned) AS dt
        WHERE rnk = 1) AS dt_rnk
        ON dt_rnk.placed_order_id = po.id

--Rankeamos ordenes por tamano del intervalo de retraso y agarramos las que tienen rango 1
SELECT placed_order_id
    FROM (SELECT placed_order_id, DENSE_RANK() OVER (ORDER BY (delivery_time_actual - delivery_time_planned) DESC) AS rnk
            FROM delivery
            WHERE delivery_time_actual > delivery_time_planned)
    WHERE rnk = 1