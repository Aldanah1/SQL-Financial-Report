

--Sales and product join--

/* Join 'gwz_sales' and 'gwz_produc' to calculate the product margin. 
Save the result as 'gwz_sales_margin' table */

SELECT
  s.date_date
  ,s.orders_id
  ,s.products_id
  ,s.qty
  ,s.turnover
  ,p.purchase_price
  ,ROUND(s.qty*p.purchase_price,2) AS purchase_cost
  ,s.turnover - ROUND(s.qty*p.purchase_price,2) AS margin
FROM `course16.gwz_sales` s
LEFT  JOIN `course16.gwz_product` p ON s.products_id = p.products_id


--Check the primary key for 'gwz_sales_margin'.

SELECT 
 orders_id
 ,products_id
 ,COUNT(*) AS nb
FROM `course16.gwz_sales_margin`
GROUP BY
	orders_id
	,products_id
HAVING nb >= 2


--Replace the LEFT JOIN with a RIGHT JOIN in the query

SELECT
  s.date_date
  ,s.orders_id
  ,p.products_id
  ,s.qty
  ,s.turnover
  ,p.purchase_price
  ,ROUND(s.qty*p.purchase_price,2) AS purchase_cost
  ,s.turnover - ROUND(s.qty*p.purchase_price,2) AS margin
FROM `course16.gwz_sales` s
RIGHT JOIN `course16.gwz_product` p 
USING (products_id)

/* We have 1375630 rows with the left join and 1375632 rows with the right join. */

--Select the products that do not appear in the sales

SELECT
  p.products_id
FROM `course16.gwz_sales` s
RIGHT JOIN `course16.gwz_product` p 
USING (products_id)
WHERE
  s.products_id IS NULL

 
--To make sure that column purchase_price has a non-null value

SELECT 
	orders_id
	,products_id
	,purchase_price
FROM `course16.gwz_sales_margin`
WHERE purchase_price IS NULL


--Sales and ship join--

/* We want to calculate the operational_margin column
   which is the product margin + shipping revenu (shipping_fee) - the operational costs (ship_cost+log_cost).
   Join 'gwz_sales_margin' with 'gwz_ship'.
   Save the result as 'gwz_orders_operational'. */


WITH orders_join AS 
  (
SELECT
  date_date
  ,orders_id
  ,ROUND(SUM(qty),2) AS qty
  ,ROUND(SUM(turnover),2) AS turnover
  ,ROUND(SUM(margin),2) AS margin
  ,ROUND(SUM(purchase_cost),2) AS purchase_cost
FROM `course16.gwz_sales_margin`
GROUP BY 
  date_date ,orders_id
  )

SELECT
  o.date_date
  ,o.orders_id
  ,o.turnover
  ,o.margin
  ,o.purchase_cost
  ,o.qty
  ,s.shipping_fee
  ,s.log_cost
  ,s.ship_cost
  ,o.margin + s.shipping_fee - (s.log_cost + s.ship_cost) AS operational_margin 
FROM orders_join o
LEFT JOIN `course16.gwz_ship` s 
ON o.orders_id = s.orders_id
ORDER BY
  date_date ,orders_id



--a primary key test on 'gwz_orders_operational'

SELECT
  orders_id,
  count(*) as nb
FROM `course16.gwz_orders_operational`
GROUP BY
	orders_id
HAVING nb >= 2


--To check null values in the shipping_fee, ship_cost, or log_cost columns.
SELECT
     orders_id
	,shipping_fee
    ,ship_cost
	 log_cost
FROM `course16.gwz_orders_operational`
WHERE 
   shipping_fee IS NULL
	OR log_cost IS NULL
	OR ship_cost IS NULL



/*  To get the financial KPI by day, Aggregate gwz_orders_operational on date
     Then Save it as 'gwz_finance_day'. */

SELECT
  date_date
  ,COUNT(orders_id) AS nb_transaction
  ,ROUND(SUM(turnover),0) AS turnover 
  ,SUM(qty) AS qty 
  ,ROUND(AVG(turnover),1) AS average_basket
  ,ROUND(SUM(turnover)/COUNT(orders_id),1) AS average_basket_bis
  ,ROUND(SUM(purchase_cost),0) AS purchase_cost 
  ,ROUND(SUM(log_cost),0) AS log_cost 
  ,ROUND(SUM(ship_cost),0) AS ship_cost 
  ,ROUND(SUM(shipping_fee),0) AS shipping_fee 
  ,ROUND(SUM(margin),0) AS margin 
  ,ROUND(SUM(operational_margin),0) AS operational_margin  
FROM `course16.gwz_orders_operational`
GROUP BY
  date_date
ORDER BY
  date_date DESC


/* We want to include 'ads_cost' in 'gwz_finance_day' to calculate 
   'ads_margin' which is ( 'margin_operational' - 'ads_cost' ). */

/* Aggregate 'gwz_campaign' on 'date_date'. 
   Save the result in 'gwz_campaign_day'. */

select  
  date_date,
  sum(ads_cost) AS ads_cost
from  `course16.gwz_campaign`
group by date_date  
order by date_date


-- Join 'gwz_finance_day' and 'gwz_campaign_day', save the view as 'gwz_finance_ads_day'. 

SELECT
  o.date_date
  ,o.nb_transaction
  ,o.turnover 
  ,o.qty 
  ,o.purchase_cost 
  ,o.average_basket
  ,o.shipping_fee 
  ,o.log_cost 
  ,o.ship_cost
  ,c.ads_cost
  ,o.margin 
  ,o.operational_margin  
  ,o.operationnal_margin - ads_cost AS ads_margin
FROM `course16.gwz_finance_day` o
LEFT JOIN `course16.gwz_campaign_day` c 
ON o.date_date = c.date_date


/* To observe the KPIs over the past three months (July, August, and September 2021) */

SELECT
  EXTRACT(MONTH FROM date_date) AS month
  ,SUM(turnover) AS turnover
  ,SUM(nb_transaction) AS nb_transaction
  ,ROUND(SUM(margin)/SUM(nb_transaction),1) AS margin_ord  
  ,ROUND(SUM(margin)/SUM(turnover)*100,1) AS margin_percent  
  ,ROUND(SUM(shipping_fee)/SUM(nb_transaction),1) AS shipping_fee_ord  
  ,ROUND(SUM(turnover)/SUM(nb_transaction),1) AS average_basket
  ,ROUND(SUM(ads_cost)/SUM(nb_transaction),1) AS ads_cost_ord 
  ,ROUND(SUM(log_cost+ship_cost)/SUM(nb_transaction),1) AS ship_cost_ord 
  ,SUM(ads_margin) AS ads_margin
  ,ROUND(SUM(ads_margin)/SUM(nb_transaction),1) AS ads_margin_ord 
FROM `course16.gwz_finance_ads_day`
WHERE date_date BETWEEN '2021-07-01' and '2021-09-30'
GROUP BY
  month
ORDER BY
  month DESC



