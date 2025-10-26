## SQL-Financial-Report 2023
 
<h2>Overview 👀🌐 </h2>
<b> The goal is to create a financial report in order to accurately track profitability for Greenweez which is an organic e-commerce website. <br>
Tools used: Google BigQuery, Power BI for visualization. </b>
<br />


<h2> Data Dictionary 📚 </h2>

- <b> 'gwz_sales' table </b> <br />
   contains data related to sales <br />
-date_date <br />
-orders_id <br />
-products_id <br />
-turnover <br />
-qty

- <b> 'gwz_ship' table </b> <br />
 contains data related to the ship <br />
-orders_id  <br />
-shipping_fee  <br />
-log_cost  <br />
-ship_cost  <br />

- <b> 'gwz_product' table </b> <br />
 contains data related to the product <br />
-products_id <br />
-purchase_price 

- <b> 'gwz_campaign' table </b> <br />
   contains data related to the campaign <br />
-date_date <br />
-campaign_name <br />
-ads_cost <br />



<h2> Dashboard 📊 </h2>

![VS1](https://github.com/Aldanah1/SQL-Financial-Report/assets/114359920/68b0edd2-3b86-4eb3-8912-0fb6ef734332)

![VS2](https://github.com/Aldanah1/SQL-Financial-Report/assets/114359920/d0ac3e99-0a80-4710-be27-c6a356935c00)


<h2> Conclusion 🔍   </h2>


<b> 
 There is a significant decrease in both ads_margin and average_ads_margin per order. This is because of:<br />
  1- An increase in ads_cost by orders over the last three months.  <br />
  2- 2.5% decrease in margin percentage in September.   <br />

<b>

