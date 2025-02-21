# Decoding Digital Engagement: Building a Predictive Model to Forecast Customer Click Behaviour on Online Advertisements

## Overview
This capstone project focuses on developing a predictive model to forecast customer interactions with online advertisements, specifically focusing on ad clicks. The primary objective is to analyze historical data to identify patterns and trends that can help businesses tailor their advertising efforts and improve engagement rates. By leveraging machine learning techniques such as logistic regression, decision trees, random forests, and XGBoost, the project aims to provide actionable insights into user behavior and enhance the effectiveness of digital marketing strategies.

The project was completed as part of the requirements for the degree of Master of Science in IT for Business Data Analytics at International Business School, Hungary.

## Key Features
- Data Preparation : Comprehensive cleaning, transformation, and aggregation of datasets from participant files, ground truth data, and log files.
- Exploratory Data Analysis (EDA) : Detailed analysis of numerical and categorical variables to uncover relationships between features and ad click behavior.
- Model Development : Implementation and evaluation of multiple machine learning models, including:
  - Logistic Regression
  - Decision Trees
  - Random Forests
  - XGBoost
- Evaluation Criteria : Focus on F1 score for the minority class (ad clicks) due to class imbalance in the dataset.
- Feature Importance : Identification of critical features influencing ad click predictions, such as cursor position, ad placement, and user demographics.
- Recommendations : Insights for targeted advertising, budget allocation, and customer retargeting strategies
 
## Technologies Used
- Programming Language : Python
- Libraries :
  - Pandas, NumPy: Data manipulation and analysis
  - Matplotlib, Seaborn: Visualization
  - Scikit-learn: Machine learning algorithms and preprocessing
  - XGBoost: Gradient boosting framework
  - Imbalanced-learn: Handling class imbalance
  - PCA: Dimensionality reduction
- Tools :
  - Jupyter Notebook: Development environment
  - Google Colab: Cloud-based computation
  - GitHub: Version control and collaboration
 
## Exploratory Data Analysis (EDA)
Key findings from the EDA include:
- Age vs. Ad Clicked : Younger users tend to engage more with ads.
- Income vs. Ad Clicked : No significant correlation between income levels and ad clicks.
- d Position : Ads placed in the top-left position receive higher click-through rates.
- Temporal Patterns : Higher ad click activity during lunch hours and weekdays (especially Mondays).
  
These insights highlight the importance of non-linear models for capturing complex relationships in the data.

## Model Interpretation & Selection
After testing multiple algorithms, the XGBoost model demonstrated the best performance:
- F1 Score : 50% for the minority class (ad clicks)
- Overall Accuracy : 74%
- Hyperparameters :
  - Gamma: 0.2
  - Learning Rate: 0.01
  - Number of Estimators: 100
  - Subsample: 0.7
  - Maximum Depth: 8
  - Col Sample: 0.8
  
XGBoost was chosen over other models due to its robustness in handling non-linear relationships and interactions among variables.

## Evaluation Criteria
The evaluation criteria prioritized the F1 score for the minority class (ad clicks) because:
- The dataset is imbalanced, with fewer ad clicks compared to non-clicks.
- False negatives (missing an actual ad click) are more costly than false positives (incorrectly predicting a click).
  
## Recommendations
Based on the project's findings, businesses can:
- Targeted Advertising : Customize ad content for users predicted to engage with ads.
- Optimize Ad Placement : Place ads in high-performing positions, such as the top-left corner.
- Efficient Budget Allocation : Focus resources on users with a higher likelihood of clicking ads.
- Customer Retargeting : Identify and re-engage users who previously interacted with ads but did not convert.

## Future Work
Future research directions include:
- Exploring deep learning models like LSTM to capture sequential patterns in user interactions.
- Incorporating attention mechanisms to highlight important features or time steps.
- Conducting comparative analyses between ensemble methods (e.g., XGBoost) and neural networks.
- Expanding the dataset to improve model generalization.





















