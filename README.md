# IT Service Desk — SLA, Productivity & Customer Experience Analytics

> End-to-end Data Analytics project using **Python, MySQL, and Power BI** to analyze IT service desk operations, SLA performance, resolution efficiency, agent productivity, and customer experience.

![Project Banner](images/project-banner.png)

## 📌 Project Overview

The **IT Service Desk Analytics** project analyzes **50,000 service desk tickets** covering **April 2024 to March 2025**.

The goal is to turn operational ticket data into actionable business insights around:

- Ticket volume and workload
- SLA compliance and breaches
- Resolution time and service efficiency
- Agent productivity
- Reopened and recurring issues
- Customer satisfaction
- Customer support demand
- Monthly operational trends

### Analytics Workflow

```text
Raw Ticket Data
      ↓
Python EDA & Data Quality
      ↓
MySQL Business Analysis
      ↓
Power BI Data Modeling & DAX
      ↓
Interactive Dashboard
      ↓
Business Insights
```

---

## 🎯 Business Problem

IT support teams manage large numbers of incidents across departments, priorities, channels, and issue categories. Without structured analysis, it is difficult to identify SLA gaps, workload concentration, recurring issues, and customer-experience patterns.

This project provides a centralized analytical view that helps answer questions such as:

- Which departments generate the most tickets?
- Where are SLA breaches concentrated?
- Which priorities require the most resolution time?
- Which agents resolve the highest number of tickets?
- Which support issues are most common or frequently reopened?
- Which customers generate high support demand?
- Which channels are used most often?
- How do ticket volume and SLA performance change over time?

---

## 📊 Dataset

**Rows:** 50,000 tickets  
**Period:** April 2024 – March 2025  
**Granularity:** One row represents one support ticket

### Main Columns

| Column | Description |
|---|---|
| `Ticket_ID` | Unique ticket identifier |
| `Ticket_Date` | Ticket creation date |
| `Customer_ID` | Customer identifier |
| `Department` | Business department |
| `Agent_Name` | Assigned support agent |
| `Category` | Main issue category |
| `Sub_Category` | Detailed support issue |
| `Priority` | Low / Medium / High / Critical |
| `Status` | Resolved / Open / In Progress / Pending |
| `Resolution_Time_Hours` | Time taken to resolve the ticket |
| `SLA_Target_Hours` | Target resolution time |
| `SLA_Status` | Met / Breached |
| `Customer_Satisfaction` | Customer rating |
| `Reopened` | Whether the ticket was reopened |
| `Channel` | Email / Portal / Phone / Chat |
| `Root_Cause` | Identified issue cause |
| `Month` | Ticket month |
| `Year` | Ticket year |

---

# 🛠️ Tools & Technologies

### Python
- Pandas
- NumPy
- Matplotlib
- Seaborn
- Jupyter Notebook

**Purpose:** data validation, cleaning checks, EDA, statistical summaries, trend analysis, and visualization.

### SQL / MySQL

**Purpose:** KPI analysis, aggregations, SLA analysis, customer analysis, CTEs, ranking, window functions, and time-series comparisons.

### Power BI

**Purpose:** data modeling, DAX measures, KPI cards, interactive visuals, slicers, and dashboard storytelling.

### GitHub

**Purpose:** project documentation, version control, code organization, and portfolio presentation.

---

# 🐍 Python EDA

The Python notebook covers:

### Data Quality
- Dataset dimensions and structure
- Data types
- Missing-value analysis
- Duplicate analysis
- Unique-value analysis
- Date-range validation
- Descriptive statistics

### Operational Analysis
- Ticket status distribution
- Priority distribution
- Department workload
- Category and sub-category analysis
- Support channel analysis
- Root-cause analysis

### SLA Analysis
- Overall SLA compliance
- SLA breaches
- SLA breaches by department
- Monthly SLA compliance
- Priority-level SLA analysis

### Resolution Analysis
- Average, median, and maximum resolution time
- Resolution-time distribution
- Resolution time by priority
- Agent-level resolution analysis

### Customer Analysis
- Customer satisfaction distribution
- Satisfaction by department
- Reopened tickets
- Reopened-ticket percentage
- Reopened tickets by category
- Customer-level ticket volume

### Time-Series & Advanced Analysis
- Monthly ticket trend
- Monthly SLA trend
- Department KPI summary
- Priority vs SLA analysis
- Category vs status analysis
- Correlation analysis
- Business insight generation

---

# 🗄️ SQL Analysis

The project contains **35 business-focused SQL queries**.

### Core Analysis
- Total tickets
- Resolved and open tickets
- Tickets by priority
- Tickets by department
- Tickets by category
- Tickets by channel
- Root-cause analysis

### SLA & Operations
- SLA compliance percentage
- SLA breaches by department
- SLA breach rate by priority
- SLA breach rate by department
- Critical tickets breaching SLA
- Average resolution time
- Resolution time by priority

### Agent Analysis
- Top 10 agents by resolved tickets
- Agent productivity
- Agent resolution performance
- Department-wise agent ranking
- Top 3 agents within each department

### Customer Analysis
- Tickets per customer
- Top 10 customers by ticket volume
- High-frequency customers
- Customer satisfaction by priority
- Reopened-ticket rate by category

### Advanced SQL Concepts
- `CTE`
- `CASE`
- `HAVING`
- Aggregate functions
- `RANK()`
- `DENSE_RANK()`
- `ROW_NUMBER()`
- `LAG()`
- Month-over-month analysis

---

# 📈 Power BI Dashboard

The Power BI report contains **3 analytical pages** designed around service-desk management questions.

## 1. SERVICE DESK OVERVIEW

### KPIs
- Total Tickets
- Resolved Tickets
- Open Tickets
- SLA Compliance %
- Average Resolution Time

### Visuals
- Monthly Ticket Trend
- Tickets by Priority
- Tickets by Category
- SLA Compliance
- Tickets by Department
- Resolution Time by Priority
- Top 5 Support Issues

![Service Overview](images/service-overview.png)

---

## 2. SLA & PERFORMANCE

### KPIs
- SLA Compliance %
- SLA Breached
- Average Resolution Time
- Reopened Tickets

### Visuals
- SLA Breaches by Department
- SLA Performance by Department
- Resolution Time by Priority
- Top 10 Agents by Resolved Tickets
- Monthly SLA Compliance Trend
- Resolution Time Distribution

![SLA & Performance](images/sla-performance.png)

---

## 3. CUSTOMER INTELLIGENCE

### KPIs
- Total Customers
- Average Tickets per Customer
- Average Customer Satisfaction
- Reopened Tickets
- High-Frequency Customers

### Visuals
- Top 10 Customers by Ticket Volume
- Customer Satisfaction by Department
- Reopened Tickets by Category
- Tickets by Channel
- Monthly Customer Satisfaction Trend

![Customer Intelligence](images/customer-intelligence.png)

---

# 🧮 Key DAX Measures

### Total Tickets

```DAX
Total Tickets =
COUNTROWS(Tickets)
```

### Resolved Tickets

```DAX
Resolved Tickets =
CALCULATE(
    [Total Tickets],
    Tickets[Status] = "Resolved"
)
```

### SLA Compliance %

```DAX
SLA Compliance % =
DIVIDE(
    CALCULATE(
        [Total Tickets],
        Tickets[SLA_Status] = "Met"
    ),
    [Total Tickets]
)
```

### Average Resolution Time

```DAX
Avg Resolution Time =
AVERAGE(Tickets[Resolution_Time_Hours])
```

### Total Customers

```DAX
Total Customers =
DISTINCTCOUNT(Tickets[Customer_ID])
```

### High-Frequency Customers

```DAX
High-Frequency Customers =
COUNTROWS(
    FILTER(
        VALUES(Tickets[Customer_ID]),
        CALCULATE([Total Tickets]) > 10
    )
)
```

---

# 📌 KPI Snapshot

Current dataset snapshot:

| KPI | Value |
|---|---:|
| Total Tickets | 50,000 |
| SLA Compliance | ~79.3% |
| Resolved Tickets | ~77.9% |
| Average Resolution Time | ~5.87 hours |
| Analysis Period | Apr 2024 – Mar 2025 |

> Values may change if the dataset is regenerated or transformed.

---

# 💡 Business Insights & Use Cases

### SLA Management
Use department, priority, and monthly SLA analysis to identify areas with higher breach levels and investigate service bottlenecks.

### Workforce & Agent Productivity
Compare resolved-ticket volumes and average resolution time across agents to understand workload distribution and operational efficiency.

### Recurring Issue Management
Use category, sub-category, and root-cause analysis to identify repeated technical problems and opportunities for permanent fixes.

### Customer Experience
Monitor satisfaction, reopened tickets, and customer ticket frequency to understand support quality and demand patterns.

### Operational Planning
Monthly ticket and SLA trends can support staffing, capacity planning, and service-level monitoring.

---

# 📁 Repository Structure

```text
IT-Service-Desk-Analytics/
│
├── data/
│   └── IT_Service_Desk_Tickets_50000.csv
│
├── python/
│   └── IT_Service_Desk_EDA.ipynb
│
├── sql/
│   └── IT_Service_Desk_Analysis.sql
│
├── powerbi/
│   └── IT_Service_Desk_Analytics.pbix
│
├── images/
│   ├── project-banner.png
│   ├── service-overview.png
│   ├── sla-performance.png
│   └── customer-intelligence.png
│
├── README.md
└── LICENSE
```

---

# 🚀 How to Reproduce

## 1. Clone the repository

```bash
git clone https://github.com/your-username/IT-Service-Desk-Analytics.git
cd IT-Service-Desk-Analytics
```

## 2. Run Python EDA

Open:

```text
python/IT_Service_Desk_EDA.ipynb
```

Install dependencies:

```bash
pip install pandas numpy matplotlib seaborn jupyter
```

Run the notebook cells to reproduce the analysis.

## 3. Run SQL Analysis

Create the database:

```sql
CREATE DATABASE IT_Service_Desk;
USE IT_Service_Desk;
```

Import the CSV as the `Tickets` table and execute:

```text
sql/IT_Service_Desk_Analysis.sql
```

## 4. Open Power BI

Open:

```text
powerbi/IT_Service_Desk_Analytics.pbix
```

Use the slicers and page navigator to explore the report.

---

# 🎯 Business Questions Answered

1. What is the overall ticket volume?
2. What percentage of tickets meet the SLA?
3. Which departments have the most SLA breaches?
4. Which priority has the highest resolution time?
5. Which agents resolve the most tickets?
6. What are the most common support issues?
7. Which categories have the most reopened tickets?
8. How does customer satisfaction vary by department and priority?
9. Which customers generate the highest support demand?
10. How does ticket volume change month over month?
11. How does SLA performance change over time?
12. Which root causes contribute most to support demand?

---

# 📚 Skills Demonstrated

**Data Analytics:** Data Cleaning, EDA, KPI Analysis, Trend Analysis, Business Insights  
**Python:** Pandas, NumPy, Matplotlib, Seaborn, Jupyter  
**SQL:** Aggregations, CTEs, CASE, HAVING, Window Functions, Ranking, LAG, Time-Series Analysis  
**Power BI:** Data Modeling, DAX, KPI Cards, Interactive Visuals, Slicers, Dashboard Design  
**Other:** GitHub, Documentation, Business Storytelling

---

# 🧑‍💻 Author

**Govind Vaid**  
BSc Computer Science | Aspiring Data Analyst

**Core Skills:** Python • SQL • Excel • Power BI • Tableau

---

# ⭐ Project Highlights

- **50,000+ service desk records**
- **3 Power BI analytical pages**
- **35 SQL business queries**
- **Python EDA notebook**
- **SLA, productivity, operations, and customer analytics**
- **End-to-end analytics workflow from raw data to dashboard insights**

---

## 📬 Portfolio Links

Replace these placeholders before publishing:

- GitHub :https://github.com/vaidgovind36
- LinkedIn:https://www.linkedin.com/in/govind-vaid-820377342/

---

## ⭐ Note

This project is created for portfolio and learning purposes. The dataset represents a simulated IT service desk environment and should not be interpreted as real company operational data.
