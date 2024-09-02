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
WHERE visited_on >= (
                      SELECT DATE_ADD(MIN(visited_on), INTERVAL 6 DAY)
                      FROM customer
                    )

--Ex 5

SELECT ROUND(SUM(tiv_2016),2) AS tiv_2016
FROM Insurance 
WHERE tiv_2015 =
                ( 
                  SELECT tiv_2015
                  FROM Insurance 
                  GROUP BY tiv_2015
                  HAVING COUNT(*) > 1 
                )
AND pid IN 
          (
           SELECT  pid
           FROM Insurance 
           GROUP BY lat, lon
           HAVING COUNT(*) = 1
          )
-- Ex 6
SELECT Department,
       Employee,
       Salary
FROM (
        SELECT   
               D.Name as Department,
               E.name as Employee,
               E.salary,
               DENSE_RANK() OVER(PARTITION BY E.departmentId ORDER BY E.salary DESC ) AS RANK_SALARY
        FROM Employee as E
        JOIN Department AS D
        ON E.departmentId = D.id
     ) AS CTE
WHERE RANK_SALARY <= 3

--Ex 7
SELECT
      person_name
FROM 
      (
        SELECT 
              person_name,
              weight,
              SUM(weight) OVER(ORDER BY turn ) as cumsum
       FROM Queue
      ) AS CTE
WHERE cumsum <= 1000
ORDER BY cumsum DESC
LIMIT 1

--Ex 8
      
WITH CTE AS (
SELECT *,
       DENSE_RANK() 
            OVER(
                PARTITION by product_id ORDER BY change_date DESC
                ) As rank_date FROM products
WHERE change_date <='2019-08-16'
            )
SELECT product_id,
       new_price As price
FROM CTE
WHERE rank_date = 1

UNION

SELECT product_id, 10
FROM products
WHERE product_id NOT IN (
                         SELECT product_id 
                         FROM CTE
                        )





