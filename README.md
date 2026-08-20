# Retail Sales Analytics Dashboard

An end-to-end analysis of retail sales performance — from raw data to an
interactive Power BI dashboard — built to identify where profit and growth
opportunities exist across categories, regions, and products.

---

## 1. The Question

Retail businesses often track total sales closely but miss where profit is
actually being made or lost. This project set out to answer:

- Which product categories drive the most profit, not just the most sales?
- Are there regions or products that sell well but quietly underperform on margin?
- Which specific products, despite strong sales, are actually losing money?

## 2. The Data

- **Source:** Sample Superstore dataset (retail transactions across regions,
  categories, and products, spanning multiple years)
- **Size:** 9,994 order line items
- **Fields used:** Order Date, Region, Category, Sub-Category, Product Name,
  Sales, Profit, Discount, Customer, Segment

## 3. Cleaning & Validation

Before analysis, the dataset was checked for missing values in the critical
fields (Order Date, Sales, Profit, Region). Result: **zero missing values**
across all four fields — the dataset was clean and ready for analysis.

See `retail_analysis_queries_sqlite.sql`, Section 1, for the exact validation
queries used.

## 4. Analysis

SQL was run directly against the dataset (SQLite) to verify performance
numbers independently before trusting the BI tool's visuals. Key techniques
used: `GROUP BY` aggregation, `HAVING` filters to flag underperforming
products, and margin calculations (`profit / sales`) to rank performance by
efficiency rather than raw volume.

See `retail_analysis_queries_sqlite.sql` for the full set of queries and results.

## 5. Visualization

An interactive **Power BI dashboard** was built on top of the same dataset,
featuring:
- KPI cards for Total Sales, Profit, Margin, Orders, and Customers, each with
  a year-over-year comparison
- Category and sub-category breakdowns by sales and profit
- Regional performance comparison
- Top 10 products by sales
- A context panel explaining the objective, key questions, and data source
  directly on the dashboard

*(Dashboard screenshot / link to be added here.)*

## 6. Key Findings

- **Furniture generates the second-highest sales (~$742K) but the lowest
  profit margin of all categories (2.5%)** — compared to 17.4% for Technology
  and 17.0% for Office Supplies — signaling a pricing or discount issue
  specific to this category.
- **Copiers is the top-performing sub-category by profit ($55.6K)**, ahead of
  higher-volume sub-categories like Phones and Accessories, showing strong
  margin efficiency worth replicating.
- **Three of the top 10 best-selling products are actually losing money**:
  the Cisco TelePresence System EX90 (-$1,811), the GBC DocuBind P400
  (-$1,878), and the High Speed Automatic Electric Letter Opener (-$262) —
  each drives meaningful sales volume while eroding overall profit.
- **The West region leads in both sales ($725K) and profit ($108K)**, while
  the South region has the lowest order count (822) among all regions.

## 7. Recommendation

Review pricing and discount strategy within the Furniture category to close
the margin gap with other categories. Reassess the three loss-making
top-selling products identified above — through repricing, renegotiated
supplier costs, or discontinuation — since high sales volume is currently
masking a real profit leak. Apply the same pricing approach that makes
Copiers profitable to other lower-margin sub-categories where possible.

---

## Tools Used
SQL (SQLite) · Power BI · DAX

## Files in this repository
- `retail_analysis_queries_sqlite.sql` — full SQL analysis (cleaning, aggregation, product/region/category performance)
- `README.md` — this file
- *(Power BI `.pbix` file / dashboard export to be added)*
