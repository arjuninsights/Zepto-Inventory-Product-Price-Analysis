--creating Table
create table zepto_inventory(
---stock keeping unit as primary key
sku_id number(10) generated as identity primary key,
--product category
category varchar2(100) not null,
--profuct name
name varchar2(100) not null,
--product mrp price
mrp number(10,2),
--discount on product
discountPercent number(5,2),
--count of available product 
availableQuantity number(3),
--after discount selling price
discountedSellingPrice number(10,2),
--weight of product in grams
weightInGms number(5),
--Stock availability
outOfStock varchar2(10),
--selling quantity
quantity number(5)
)

--importing csv file data into zepto_inventory table
--sample data 
select * from zepto_inventory fetch first 10 rows only;

--total records 
select count(*) from zepto_inventory;

--checking null values
select * from zepto_inventory where CATEGORY is null or NAME is null or MRP is null or 
DISCOUNTPERCENT is null or AVAILABLEQUANTITY is null or DISCOUNTEDSELLINGPRICE is null or
WEIGHTINGMS is null or OUTOFSTOCK is null or QUANTITY is null;
-- we have no null values

--different product category
select distinct CATEGORY from zepto_inventory order by category;
--we have total 14 unique product

--Product in Stock vs Out of Stock
select OUTOFSTOCK,count(*) from zepto_inventory group by OUTOFSTOCK;

--product name present multiple time 
SELECT name,count(sku_id) as "No of SKUs" from zepto_inventory group by name 
having count(sku_id)>1
order by "No of SKUs" desc;


--select * from zepto_inventory
--Data Cleaning
select * from zepto_inventory where mrp=0 or DISCOUNTEDSELLINGPRICE=0;
--There is one row found with 0 mrp and 0 DISCOUNTEDSELLINGPRICE whose sku is 3607.
--lets delete it
delete from zepto_inventory where SKU_ID=3607;
--1 row deleted.

select * from zepto_inventory fetch first 5 rows only;
--if you notice something here mrp and DISCOUNTEDSELLINGPRICE is not in rupees they are in paise form
update zepto_inventory set mrp=mrp/100.0,DISCOUNTEDSELLINGPRICE=DISCOUNTEDSELLINGPRICE/100.0;
--3,732 rows updated.
select mrp,DISCOUNTEDSELLINGPRICE from zepto_inventory fetch first 5 rows only;

--now its time to solve business problem
--q1. find the top10 best-value products based on the discount percentage
select distinct name,mrp,DISCOUNTPERCENT from zepto_inventory order by DISCOUNTPERCENT desc fetch first 10 rows only;

--q2. What are the Products with high mrp but out of stock
select distinct name,mrp,OUTOFSTOCK from zepto_inventory where OUTOFSTOCK='TRUE' and mrp>=250 order by mrp desc;

--q3 Calculate the estimated revenue for each category

select category,sum(DISCOUNTEDSELLINGPRICE*AVAILABLEQUANTITY)"Total Revenue" 
from zepto_inventory group by category order by "Total Revenue" desc;

--find all the products where mrp is greater than 500rupee and discount is less than 10%

select distinct name,mrp,DISCOUNTPERCENT from zepto_inventory where mrp>500 and DISCOUNTPERCENT<10
order by mrp desc;


--Identify the top 5 category offering the highest average discount percentage
select CATEGORY,round(avg(DISCOUNTPERCENT),2)as Average_Discount from zepto_inventory 
group by CATEGORY order by Average_Discount desc fetch first 5 rows only; 

--find the price per gram for products above 100g and sort by best value

select name,WEIGHTINGMS,DISCOUNTEDSELLINGPRICE,
round(DISCOUNTEDSELLINGPRICE/WEIGHTINGMS,2) as Price_Per_Grams
from zepto_inventory where WEIGHTINGMS>100 order by Price_Per_Grams desc;
-- group the products into weight category based on weightingrams columns low medium and high
select name,WEIGHTINGMS,case when WEIGHTINGMS<1000 then 'Low' 
                             when WEIGHTINGMS<5000 then 'Medium'
                             else 'High' end as Weight_Category
 from zepto_inventory; 
 
--what is the total inventary weight per category                             
select * from zepto_inventory fetch first 5 rows only;

select category, sum(WEIGHTINGMS*AVAILABLEQUANTITY) as Total_weight 
from zepto_inventory 
group by category
order by Total_weight desc;


drop table zepto_inventory;