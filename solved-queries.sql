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


--QUERY C
SELECT c.*
    FROM customer AS c
    NATURAL JOIN 
    (SELECT customer_id AS id, Count(id) AS qty
        FROM placed_order
        GROUP BY customer_id) AS count
    ORDER BY qty DESC
LIMIT 10;