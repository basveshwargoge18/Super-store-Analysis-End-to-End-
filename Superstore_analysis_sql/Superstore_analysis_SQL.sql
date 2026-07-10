create database superstore;
use superstore;
CREATE TABLE superstore (
    row_id INT,
    order_id VARCHAR(50),
    order_date DATE,
    ship_date DATE,
    ship_mode VARCHAR(50),
    customer_id VARCHAR(50),
    customer_name VARCHAR(100),
    segment VARCHAR(50),
    country VARCHAR(50),
    city VARCHAR(50),
    state VARCHAR(50),
    postal_code VARCHAR(20),
    region VARCHAR(50),
    product_id VARCHAR(50),
    category VARCHAR(50),
    sub_category VARCHAR(50),
    product_name VARCHAR(255),
    sales DECIMAL(10,2),
    quantity INT,
    discount DECIMAL(5,2),
    profit DECIMAL(10,2),
    order_year INT,
    order_month VARCHAR(20),
    shipping_days INT
);

SET SQL_SAFE_UPDATES = 0;

ALTER TABLE superstore
MODIFY order_month INT,
MODIFY order_year INT,
MODIFY shipping_days INT;


-- Questions on Superstore dataset;

-- Q1. Which category generates the highest profit?

SELECT category, SUM(profit) AS total_profit
FROM superstore
GROUP BY category
ORDER BY total_profit DESC;

/*Insight:

The Technology category typically generates the highest profit among all categories.
This indicates that technology products have better margins and pricing power.
The business should focus on expanding this category to maximize profitability.
*/

-- Q2. Which sub-category is the most and least profitable?

select sub_category, sum(profit) as total_profit
from superstore
group by sub_category
order by total_profit desc;

/*Insight:

Certain sub-categories (like Phones or Copiers) are highly profitable, contributing significantly to total profit.
Others (such as Tables or Bookcases) tend to generate low or negative profits.
This highlights a performance gap within product lines, requiring strategic focus.
*/

-- Q3. What is total sales and profit by region?

select region,sum(profit) as total_profit,sum(sales) as total_sales
from superstore
group by region
ORDER BY total_profit DESC;

/*Insight:

Some regions generate high sales but comparatively lower profit, indicating inefficiencies.
Regions with both high sales and profit are key revenue drivers.
The company should analyze cost structures and discount strategies in low-profit regions.
*/

-- Q4. Which state contributes the most to overall profit?

select state,sum(profit) as total_profit 
from superstore
group by state
ORDER BY total_profit DESC
limit 1;

/*Insight:

A single state (commonly California in this dataset) contributes the highest share of total profit.
This suggests strong market performance and demand in that region.
The business should strengthen its presence and customer base in top-performing states.
*/

-- Q5. Which sub-categories are causing losses?

select sub_category,sum(profit) as total_loss
from superstore 
group by sub_category
having sum(profit) < 0
order by total_loss asc;

/*Insight:

Some sub-categories consistently generate negative total profit, making them loss-making segments.
These losses may be due to:
High discounts
Low pricing
High operational costs
Immediate attention is required to optimize or reconsider these product lines.
*/

-- Q6. Which products are consistently loss-making?

SELECT product_name
FROM superstore
GROUP BY product_name
HAVING MAX(profit) < 0;

/*Insight:

Certain products incur losses in every transaction, indicating structural issues.
These products are not just occasionally unprofitable but consistently damaging revenue.
The company should consider:
Discontinuing these products
Revising pricing or supply chain costs
*/

-- Q7. In which region and segment do we see highest losses?

select region,segment, sum(profit) as total_loss
from superstore
group by region,segment
order by sum(profit) asc;

/* No region and segment combination is generating an overall loss.

However, some combinations have significantly lower profit compared to others,
indicating potential inefficiencies.

Business Suggestion:
Focus on improving performance in low-profit regions rather than eliminating them.
*/

-- Q8. Which are the top 10 loss-making orders?

select order_id,sum(profit) as total_loss
from superstore
group by order_id
having sum(profit)<0
order by sum(profit) asc
limit 10;

/* Insight:

A small number of orders contribute disproportionately to total losses.
These orders often include high discounts and low-margin products.
Indicates poor pricing or discount strategy on specific transactions.
*/

-- Q9.How does discount impact profit across orders?

select discount, avg(profit) as avg_profit
from superstore
group by discount
order by discount;

/*Insight:

There is a negative relationship between discount and profit.
Orders with high discounts (above ~30%) frequently result in losses.
Suggests that aggressive discounting is hurting overall profitability.
*/

-- Q10.Which sub-categories have the lowest profit margin?

select sub_category, sum(profit) / sum(sales) AS profit_margin
from superstore 
group by sub_category
order by profit_margin asc;
/*Insight:

Certain sub-categories (like Furniture-related items) show very low or negative profit margins.
High sales in these areas do not translate into profit.
Indicates need for cost control or pricing revision.
*/

-- Q11.What is the monthly sales and profit trend?

select order_month,sum(sales) as total_sales,sum(profit) as total_profit
from superstore
group by order_month
order by order_month asc;

/*Insight:

Sales show seasonal patterns, with peaks in certain months (likely festive or year-end periods).
Profit does not always follow sales → high sales months can still have low profit.
Indicates inefficiencies like discounting or high costs during peak periods.
*/

-- Q12.What is the year-over-year growth in sales?

select order_year,sum(sales) as total_sales
from superstore
group by order_year
order by order_year asc;

/*Insight:

Sales generally show positive growth over years, indicating business expansion.
However, growth rate may fluctuate, showing periods of slowdown or acceleration.
Important to align growth with profitability, not just revenue.
*/

-- Q13. Who are the top 5 customers by profit?

select customer_name, sum(profit) as profit
from superstore
group by customer_name
order by sum(profit) desc
limit 5;

/*Insight:

A small group of customers contributes a significant portion of total profit.
These are high-value customers and should be retained with loyalty strategies.
Highlights importance of customer segmentation.
*/

-- Q14.Rank sub-categories based on profit within each category.

select
    category,
    sub_category,
    sum(profit) as total_profit,
    rank() over (partition by category order by sum(profit) desc) as rank_in_category
from superstore
group by category, sub_category;

/*Insight:

Profitability varies significantly within each category.
Some sub-categories consistently outperform others.
Helps in:
Prioritizing high-performing products
Eliminating or improving low-performing ones
*/




