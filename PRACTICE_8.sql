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
