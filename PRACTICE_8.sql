-- Ex 1
SELECT 
      ROUND(
            (
             COUNT(
              CASE
               WHEN order_date = customer_pref_delivery_date THEN 1 END
                  )/COUNT(*)
            )*100,2
           ) AS immediate_percentage
FROM (

      SELECT
            customer_id,
            MIN(order_date) AS order_date,
            customer_pref_delivery_date
      FROM Delivery
      GROUP BY customer_id
) AS CTE 

-- Ex 2
SELECT  ROUND(
          COUNT(CASE
                WHEN day_diff = 1 THEN 1 END)/COUNT( DISTINCT player_id),2) AS fraction
FROM (
        SELECT player_id,
               device_id,
               event_date,
               (event_date - LAG(event_date) 
                            OVER(PARTITION BY player_id)) AS day_diff

        FROM Activity
     ) AS CTE

-- Ex 3
SELECT ID, 
       CASE 
           WHEN ID % 2 = 0 THEN LAG(STUDENT) OVER(ORDER BY ID)
           ELSE COALESCE(LEAD(STUDENT) OVER(ORDER BY ID), STUDENT)
       END AS STUDENT
FROM SEAT
-- Ex 4
--Ex 4

SELECT visited_on,
       amount,
       average_amount
FROM (    

       SELECT visited_on,
              ROUND(
                    SUM(amount) OVER(ORDER BY visited_on
                                     ROWS BETWEEN 6 PRECEDING AND CURRENT ROW),2
                   ) AS amount,
              ROUND(
                    AVG(amount) OVER(ORDER BY visited_on
                              ROWS BETWEEN 6 PRECEDING AND CURRENT ROW),2
                   ) AS average_amount      
       FROM(      
             SELECT visited_on,
                    SUM(amount) AS amount,
                    AVG(amount) AS average_amount
             FROM Customer
             GROUP BY visited_on
           ) AS CTE
     ) AS CTE2
WHERE visited_on >= '2019-01-07'
