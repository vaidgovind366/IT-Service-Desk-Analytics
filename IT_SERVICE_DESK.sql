CREATE DATABASE IT_SERVICE_DESK; 
USE IT_SERVICE_DESK;


SELECT COUNT(*) AS total_rows
FROM Tickets;

SELECT *
FROM Tickets
LIMIT 10;


-- Total Tickets
SELECT COUNT(*) AS Total_Tickets
FROM Tickets;

-- Resolved Tickets
SELECT COUNT(*) AS Resolved_Tickets
FROM Tickets
WHERE Status = 'Resolved';


-- Open Tickets
SELECT COUNT(*) AS Open_Tickets
FROM Tickets
WHERE Status = 'Open';

-- Tickets by Priority
SELECT
    Priority,
    COUNT(*) AS Ticket_Count
FROM Tickets
GROUP BY Priority
ORDER BY Ticket_Count DESC;

-- Tickets by Department
SELECT
    Department,
    COUNT(*) AS Ticket_Count
FROM Tickets
GROUP BY Department
ORDER BY Ticket_Count DESC;

-- 6. Find the number of tickets in each category
SELECT
    Category,
    COUNT(*) AS Ticket_Count
FROM Tickets
GROUP BY Category
ORDER BY Ticket_Count DESC;

-- 7. Calculate the overall SLA compliance percentage
SELECT
    ROUND(
        SUM(CASE WHEN SLA_Status = 'Met' THEN 1 ELSE 0 END)
        * 100.0 / COUNT(*),
        2
    ) AS SLA_Compliance_Percentage
FROM Tickets;

-- 8. Find the number of SLA breaches for each department
SELECT
    Department,
    COUNT(*) AS SLA_Breaches
FROM Tickets
WHERE SLA_Status = 'Breached'
GROUP BY Department
ORDER BY SLA_Breaches DESC;

-- 9. Calculate the average ticket resolution time
SELECT
    ROUND(AVG(Resolution_Time_Hours), 2) AS Avg_Resolution_Time_Hours
FROM Tickets;

-- 10. Compare average resolution time across different priorities
SELECT
    Priority,
    ROUND(AVG(Resolution_Time_Hours), 2) AS Avg_Resolution_Hours
FROM Tickets
GROUP BY Priority
ORDER BY Avg_Resolution_Hours DESC;

-- 11. Find the top 10 agents based on resolved tickets
SELECT
    Agent_Name,
    COUNT(*) AS Resolved_Tickets
FROM Tickets
WHERE Status = 'Resolved'
GROUP BY Agent_Name
ORDER BY Resolved_Tickets DESC
LIMIT 10;


-- 12. Count the total number of reopened tickets
SELECT
    COUNT(*) AS Reopened_Tickets
FROM Tickets
WHERE Reopened = 'Yes';


-- 13. Find which categories have the highest number of reopened tickets
SELECT
    Category,
    COUNT(*) AS Reopened_Tickets
FROM Tickets
WHERE Reopened = 'Yes'
GROUP BY Category
ORDER BY Reopened_Tickets DESC;

-- 14. Analyze ticket volume across different support channels
SELECT
    Channel,
    COUNT(*) AS Ticket_Count
FROM Tickets
GROUP BY Channel
ORDER BY Ticket_Count DESC;


-- 15. Identify the most common root causes of IT support tickets
SELECT
    Root_Cause,
    COUNT(*) AS Ticket_Count
FROM Tickets
GROUP BY Root_Cause
ORDER BY Ticket_Count DESC;


-- 16. Analyze the monthly ticket volume
-- Business Purpose: Identify months with high or low ticket workload

SELECT
    YEAR(Ticket_Date) AS Ticket_Year,
    MONTH(Ticket_Date) AS Ticket_Month,
    COUNT(*) AS Total_Tickets
FROM Tickets
GROUP BY
    YEAR(Ticket_Date),
    MONTH(Ticket_Date)
ORDER BY
    Ticket_Year,
    Ticket_Month;
    

-- 17. Calculate SLA compliance for each month
-- Business Purpose: Track whether SLA performance is improving over time

SELECT
    YEAR(Ticket_Date) AS Ticket_Year,
    MONTH(Ticket_Date) AS Ticket_Month,

    ROUND(
        SUM(CASE WHEN SLA_Status = 'Met' THEN 1 ELSE 0 END)
        * 100.0 / COUNT(*),
        2
    ) AS SLA_Compliance_Percentage

FROM Tickets
GROUP BY
    YEAR(Ticket_Date),
    MONTH(Ticket_Date)
ORDER BY
    Ticket_Year,
    Ticket_Month;
    
    
-- 18. Analyze overall performance of each department
-- Business Purpose: Compare workload, resolution time and SLA breaches

SELECT
    Department,
    COUNT(*) AS Total_Tickets,

    SUM(
        CASE
            WHEN Status = 'Resolved' THEN 1
            ELSE 0
        END
    ) AS Resolved_Tickets,

    ROUND(
        AVG(Resolution_Time_Hours),
        2
    ) AS Avg_Resolution_Hours,

    SUM(
        CASE
            WHEN SLA_Status = 'Breached' THEN 1
            ELSE 0
        END
    ) AS SLA_Breaches

FROM Tickets
GROUP BY Department
ORDER BY Total_Tickets DESC;



-- 19. Find the top 5 most common support issues
-- Business Purpose: Identify recurring IT problems

SELECT
    Sub_Category,
    COUNT(*) AS Ticket_Count
FROM Tickets
GROUP BY Sub_Category
ORDER BY Ticket_Count DESC
LIMIT 5;



-- 20. Find high and critical priority tickets that are not resolved
-- Business Purpose: Identify tickets that may require immediate attention

SELECT
    Ticket_ID,
    Ticket_Date,
    Department,
    Agent_Name,
    Priority,
    Status,
    Resolution_Time_Hours,
    SLA_Status
FROM Tickets
WHERE Priority IN ('High', 'Critical')
  AND Status <> 'Resolved'
ORDER BY Priority, Ticket_Date;



-- 21. Rank agents based on the number of resolved tickets
-- Business Purpose: Compare agent productivity using a window function

WITH AgentPerformance AS (
    SELECT
        Agent_Name,
        COUNT(*) AS Resolved_Tickets
    FROM Tickets
    WHERE Status = 'Resolved'
    GROUP BY Agent_Name
)

SELECT
    Agent_Name,
    Resolved_Tickets,
    RANK() OVER (
        ORDER BY Resolved_Tickets DESC
    ) AS Agent_Rank
FROM AgentPerformance
ORDER BY Agent_Rank;



-- 22. Rank departments based on total ticket volume
-- Business Purpose: Identify departments handling the highest workload

WITH DepartmentTickets AS (
    SELECT
        Department,
        COUNT(*) AS Total_Tickets
    FROM Tickets
    GROUP BY Department
)

SELECT
    Department,
    Total_Tickets,
    DENSE_RANK() OVER (
        ORDER BY Total_Tickets DESC
    ) AS Department_Rank
FROM DepartmentTickets
ORDER BY Department_Rank;



-- 23. Find the top 3 agents in each department
-- Business Purpose: Compare agent productivity within each department

WITH AgentPerformance AS (
    SELECT
        Department,
        Agent_Name,
        COUNT(*) AS Resolved_Tickets
    FROM Tickets
    WHERE Status = 'Resolved'
    GROUP BY
        Department,
        Agent_Name
),

RankedAgents AS (
    SELECT
        Department,
        Agent_Name,
        Resolved_Tickets,
        ROW_NUMBER() OVER (
            PARTITION BY Department
            ORDER BY Resolved_Tickets DESC
        ) AS Agent_Rank
    FROM AgentPerformance
)

SELECT
    Department,
    Agent_Name,
    Resolved_Tickets,
    Agent_Rank
FROM RankedAgents
WHERE Agent_Rank <= 3
ORDER BY
    Department,
    Agent_Rank;
    
    
-- 24. Compare monthly ticket volume with the previous month
-- Business Purpose: Analyze month-over-month workload changes

WITH MonthlyTickets AS (
    SELECT
        YEAR(Ticket_Date) AS Ticket_Year,
        MONTH(Ticket_Date) AS Ticket_Month,
        COUNT(*) AS Total_Tickets
    FROM Tickets
    GROUP BY
        YEAR(Ticket_Date),
        MONTH(Ticket_Date)
)

SELECT
    Ticket_Year,
    Ticket_Month,
    Total_Tickets,

    LAG(Total_Tickets) OVER (
        ORDER BY Ticket_Year, Ticket_Month
    ) AS Previous_Month_Tickets

FROM MonthlyTickets
ORDER BY
    Ticket_Year,
    Ticket_Month;
    
    
    
-- 25. Calculate month-over-month ticket growth
-- Business Purpose: Identify increases or decreases in support workload

WITH MonthlyTickets AS (
    SELECT
        YEAR(Ticket_Date) AS Ticket_Year,
        MONTH(Ticket_Date) AS Ticket_Month,
        COUNT(*) AS Total_Tickets
    FROM Tickets
    GROUP BY
        YEAR(Ticket_Date),
        MONTH(Ticket_Date)
),

MonthlyComparison AS (
    SELECT
        Ticket_Year,
        Ticket_Month,
        Total_Tickets,

        LAG(Total_Tickets) OVER (
            ORDER BY Ticket_Year, Ticket_Month
        ) AS Previous_Month_Tickets

    FROM MonthlyTickets
)

SELECT
    Ticket_Year,
    Ticket_Month,
    Total_Tickets,
    Previous_Month_Tickets,

    ROUND(
        (
            (Total_Tickets - Previous_Month_Tickets)
            * 100.0
            / NULLIF(Previous_Month_Tickets, 0)
        ),
        2
    ) AS MoM_Growth_Percentage

FROM MonthlyComparison
ORDER BY
    Ticket_Year,
    Ticket_Month;
    
    
    
-- 26. Calculate the total tickets raised by each customer
-- Business Purpose: Identify customers generating high support demand

SELECT
    Customer_ID,
    COUNT(*) AS Total_Tickets
FROM Tickets
GROUP BY Customer_ID
ORDER BY Total_Tickets DESC;


-- 27. Find the top 10 customers with the highest ticket volume
-- Business Purpose: Identify high-support-demand customers

SELECT
    Customer_ID,
    COUNT(*) AS Total_Tickets
FROM Tickets
GROUP BY Customer_ID
ORDER BY Total_Tickets DESC
LIMIT 10;



-- 28. Find customers who raised more than 10 tickets
-- Business Purpose: Identify high-frequency customers

SELECT
    Customer_ID,
    COUNT(*) AS Total_Tickets
FROM Tickets
GROUP BY Customer_ID
HAVING COUNT(*) > 10
ORDER BY Total_Tickets DESC;



-- 29. Calculate SLA breach rate for each priority
-- Business Purpose: Identify which priority level has higher SLA risk

SELECT
    Priority,

    COUNT(*) AS Total_Tickets,

    SUM(
        CASE
            WHEN SLA_Status = 'Breached' THEN 1
            ELSE 0
        END
    ) AS SLA_Breaches,

    ROUND(
        SUM(
            CASE
                WHEN SLA_Status = 'Breached' THEN 1
                ELSE 0
            END
        ) * 100.0 / COUNT(*),
        2
    ) AS SLA_Breach_Rate

FROM Tickets
GROUP BY Priority
ORDER BY SLA_Breach_Rate DESC;



-- 30. Analyze agent resolution performance
-- Business Purpose: Compare workload and average resolution time

SELECT
    Agent_Name,
    COUNT(*) AS Total_Tickets,

    SUM(
        CASE
            WHEN Status = 'Resolved' THEN 1
            ELSE 0
        END
    ) AS Resolved_Tickets,

    ROUND(
        AVG(Resolution_Time_Hours),
        2
    ) AS Avg_Resolution_Hours

FROM Tickets
GROUP BY Agent_Name
ORDER BY Resolved_Tickets DESC;



-- 31. Find critical priority tickets that breached the SLA
-- Business Purpose: Identify high-risk service incidents

SELECT
    Ticket_ID,
    Ticket_Date,
    Department,
    Agent_Name,
    Category,
    Priority,
    Resolution_Time_Hours,
    SLA_Target_Hours,
    SLA_Status
FROM Tickets
WHERE Priority = 'Critical'
  AND SLA_Status = 'Breached'
ORDER BY Resolution_Time_Hours DESC;



-- 32. Calculate SLA breach rate for each department
-- Business Purpose: Identify departments with SLA performance issues

SELECT
    Department,

    COUNT(*) AS Total_Tickets,

    SUM(
        CASE
            WHEN SLA_Status = 'Breached' THEN 1
            ELSE 0
        END
    ) AS SLA_Breaches,

    ROUND(
        SUM(
            CASE
                WHEN SLA_Status = 'Breached' THEN 1
                ELSE 0
            END
        ) * 100.0 / COUNT(*),
        2
    ) AS SLA_Breach_Rate

FROM Tickets
GROUP BY Department
ORDER BY SLA_Breach_Rate DESC;



-- 33. Analyze customer satisfaction across ticket priorities
-- Business Purpose: Understand how ticket priority relates to customer experience

SELECT
    Priority,
    ROUND(
        AVG(Customer_Satisfaction),
        2
    ) AS Avg_Customer_Satisfaction
FROM Tickets
GROUP BY Priority
ORDER BY Avg_Customer_Satisfaction DESC;



-- 34. Calculate reopened ticket rate for each category
-- Business Purpose: Identify categories where issues are frequently reopened

SELECT
    Category,

    COUNT(*) AS Total_Tickets,

    SUM(
        CASE
            WHEN Reopened = 'Yes' THEN 1
            ELSE 0
        END
    ) AS Reopened_Tickets,

    ROUND(
        SUM(
            CASE
                WHEN Reopened = 'Yes' THEN 1
                ELSE 0
            END
        ) * 100.0 / COUNT(*),
        2
    ) AS Reopened_Rate

FROM Tickets
GROUP BY Category
ORDER BY Reopened_Rate DESC;



-- 35. Create a complete department-level KPI report
-- Business Purpose: Combine major service desk KPIs into one report

SELECT
    Department,

    COUNT(*) AS Total_Tickets,

    SUM(
        CASE
            WHEN Status = 'Resolved' THEN 1
            ELSE 0
        END
    ) AS Resolved_Tickets,

    SUM(
        CASE
            WHEN Status = 'Open' THEN 1
            ELSE 0
        END
    ) AS Open_Tickets,

    SUM(
        CASE
            WHEN SLA_Status = 'Breached' THEN 1
            ELSE 0
        END
    ) AS SLA_Breaches,

    ROUND(
        AVG(Resolution_Time_Hours),
        2
    ) AS Avg_Resolution_Hours,

    ROUND(
        AVG(Customer_Satisfaction),
        2
    ) AS Avg_Satisfaction,

    SUM(
        CASE
            WHEN Reopened = 'Yes' THEN 1
            ELSE 0
        END
    ) AS Reopened_Tickets

FROM Tickets
GROUP BY Department
ORDER BY Total_Tickets DESC;