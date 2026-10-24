# Customer Churn Prediction & Retention Intelligence

## Project Overview
This project aims to analyze bank customer data, identify patterns associated with customer churn, and develop machine learning models to predict which customers are likely to leave the bank.

The project combines Data Analytics, SQL, Python, Machine Learning, and Power BI to turn customer data into actionable business insights that can support customer retention strategies.

## Business Problem
Customer churn can reduce a bank's revenue and increase the cost of acquiring new customers. Understanding which customers are more likely to leave can help a bank prioritize retention efforts.

This project investigates:
- Which customer characteristics are associated with churn?
- How do age, geography, account balance, and product usage relate to churn?
- Does customer activity have a relationship with churn?
- Can machine learning identify customers who may leave?
- How can business teams use these insights to prioritize retention actions?

## Project Objectives
- Understand the dataset and assess its data quality.
- Perform exploratory data analysis (EDA).
- Analyze customer churn patterns using SQL.
- Engineer appropriate features for machine learning.
- Train and evaluate classification models.
- Interpret model predictions and important churn drivers.
- Build a Power BI dashboard for business insights and retention analysis.
- Document findings and recommendations for a professional portfolio.

## Dataset
**Dataset name:** Bank Customer Churn Modeling  
**Expected file name:** `Churn_Modelling.csv`

The dataset commonly contains these columns:

- `RowNumber`
- `CustomerId`
- `Surname`
- `CreditScore`
- `Geography`
- `Gender`
- `Age`
- `Tenure`
- `Balance`
- `NumOfProducts`
- `HasCrCard`
- `IsActiveMember`
- `EstimatedSalary`
- `Exited`

**Target variable:** `Exited`
- `1` — Customer exited the bank.
- `0` — Customer did not exit the bank.

The identifier columns `RowNumber`, `CustomerId`, and `Surname` will be excluded from predictive features unless a specific analytical purpose justifies otherwise.

Dataset source: [Bank Customer Churn Modeling — Kaggle](https://www.kaggle.com/datasets/barelydedicated/bank-customer-churn-modeling)

*Note: Confirm the actual columns, row count, and data quality after downloading the dataset.*

## Tools and Technologies
- **Excel:** Initial data inspection and data quality checks
- **MySQL:** Data querying and business analysis
- **Python:** Data cleaning, analysis, and visualization
- **Pandas and NumPy:** Data manipulation
- **Matplotlib and Seaborn:** Data visualization
- **Scikit-learn:** Machine learning and model evaluation
- **Power BI:** Interactive dashboard and retention insights
- **Git and GitHub:** Version control and project documentation

## Project Workflow
1. Business Understanding and Data Setup
2. Excel Data Quality Checks and Initial Analysis
3. MySQL Business Analysis
4. Python Exploratory Data Analysis
5. Feature Engineering and Machine Learning
6. Model Evaluation and Explainability
7. Power BI Retention Dashboard
8. Business Insights and Recommendations

## Planned Machine Learning Models
The models will be selected and evaluated based on actual experimental results. Potential candidates include:

- Logistic Regression
- Random Forest
- HistGradientBoosting Classifier

Evaluation may include:
- ROC-AUC
- Precision
- Recall
- F1-score
- Confusion Matrix
- Precision-Recall AUC

The final model will be selected based on appropriate evaluation metrics and the business objective of identifying customers at risk of churn. No performance results will be reported until the models have been trained and evaluated.

## Planned Power BI Dashboard
The dashboard may include:
- Executive Overview
- Customer Churn Drivers
- Model Performance
- Customer Retention Action List

Dashboard visuals and recommendations will be based on validated analysis and actual model predictions.

## Expected Deliverables
- Data quality report
- SQL analysis queries
- Python notebooks
- Exploratory data analysis visualizations
- Trained machine learning model
- Model evaluation report
- Power BI dashboard
- Business insights and retention recommendations

## Repository Structure
```text
bank-customer-churn/
├── data/
│   ├── raw/
│   └── processed/
├── notebooks/
├── sql/
├── models/
├── powerbi/
├── reports/
├── images/
├── .gitignore
├── README.md
└── requirements.txt
```

## Data and Privacy
Raw datasets and generated files containing customer-level information should be handled carefully. The repository's `.gitignore` file should exclude raw data, local environment files, and large or sensitive files where appropriate. Check the dataset's license before redistribution.

## Project Status
**Status:** In Progress

The project will be updated as each phase is completed. Final findings, model metrics, dashboard screenshots, and business recommendations will be added after validation.

## Author
**Siddhesh Bhalekar**

Aspiring Data Analyst | Data Scientist

GitHub: [bhalekarsiddhesh45-sys](https://github.com/bhalekarsiddhesh45-sys)
