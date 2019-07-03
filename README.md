# Statistical-Data-Mining-Analyzing Association Rules
A repository containing assignment codes of the coursework Statistical Data Mining

a) Exploratory Data Analysis
Analyzing the Boston Dataset –
Creating Histogram of all the dataset attributes –
Of these attributes the Chas attribute can be removed as it is binary in nature and it provides only the information regarding the proximity of houses nearby Charles River.

Grouping Justifications -
•	The crim feature is categorized into Low for 0-10, since majority values are in the lower part of the plot,  Medium for 10-20, since the other majority of crimes are in that range and High for the rest, since the histogram is spread across from 0 till 80 sparsely.
•	The zn feature is categorized into Small for-1-30, since majority values are in the lower part of the plot, and they are decimal in nature so -1 would cover the 0.0 values.  Medium for 30-70, since the other majority of residential land zones are in that range and High for the rest, since the histogram is spread across from 0 till 100 sparsely.
•	The indus feature is categorized into Small, Medium and Large again since it spreads across a small range of values 0 – 25.
•	The nox feature is categorized into Low, Medium and High. Since it contains small number of values distributed across 0.4 to 0.8.
•	The rm feature is categorized into Small, Medium and Large, since it contains at least 4 to at most 9 rooms per housing, so three categories for Small for singles, Medium for married couples and Large for families.
•	The age feature is categorized into "Young", "Middle-aged", "Senior", "Elderly" since it has higher frequencies for across a wide range of values from 0-100.
•	The dis feature is categorized into "Close", "Near", "Far" since the distance from employment centers is distributed across the range 2-12.
•	The feature rad is categorized into “Accessible” and “Not Accessible” since it only has more frequency of values in the 0-6 and values greater than 20.
•	The feature tax, again categorized into "Low","Medium","High" values as it too is distributed across values 200 to 700 and majority are either accumulated in the first half of the plot and the rest at the end.
•	The feature ptratio, is categorized into "Low", "Medium", "High" values as it has lower range values from 2 to 12.
•	The feature black, is categorized into "Low","High" as the proportion of blacks by town values are concentrated at the higher end then the lower end.
•	The feature lstat and medv, is categorized into "Low","Medium","High"  since the values are spread across 0 to 50, which is small in size.
  
			
b)
After ordering the ordinal values of the entire dataset and converting into categorical ones, I’ve created a binary incidence matrix. And generated an item frequency plot providing a visualization of the data –
 
	
Item frequency plot was created with a minimum support threshold of 0.1 for each feature, so it incorporated a total of 25 features.
Apriori algorithm is then applied to the dataset, for this particular case I’ve given a minimum support threshold of 0.05 and a confidence threshold of 0.6, since the support of features ‘ptratio = Low’ is pretty low and with any higher support value , we can’t incorporate ptratio into the association rules. Hence the minimum threshold decision.
A total of 161197 rules were created.
 
 c)
Rules for Low Crime Areas , with lift>1 to show really good dependencies found by the rule-
 
So from the association rules generated, it can be observed that if the person wants to stay at a place in Boston with Low crime rate then he would most likely need to be around houses that are newly built, and also in places where the proportion of land that is zoned for lots over 25000 sq. ft. is medium to large.
 
Also, since the person also needs to stay at a place where the distance is closer to the city, he must look for and adjust to places with Medium crime rate, if not that then with places where black population is pretty low.
So in general the person wanting to live nearby the city and also in a place with lower crime rate needs to find places with proportion of land that is zoned for lots over 25000 sq. ft. is medium to large, age of the house relatively new and population of black lower than most.

d)
The association rules for ptratio on calculation shows that, if a person wants to live in a place with lower pupil to teacher ratio, they should look for places with higher Nitrogen Oxide levels, or places where  there is accessibility to radial highways  or places where there are generally lower status of population available.
 


e)
 Upon fitting a regression model, it can be seen that there are no linear relationships between any of those features with ptratio, 
We get really good p-values for the features which is the same in case of association rules as shown in the summary of the multiple regression model fit on Boston dataset-
We can see the same results, that is for nox, rad and lstat having the least p-values indicating that their relationship to ptratio is indeed linearly dependent and would have higher effects on it than other features. So it can be said that the results are comparable to association rules.
 
Now I have further divided the training and test set and built and on building a regression model and predicting the ptratio upon doing so gives us a mean squared error of about 5.4–
> errorpredictedinlm
[1] 5.451909

Conclusion
•	Association rules give us clear relation between the antecedent and the consequent, based on their probabilities whereas a regression model gives a relationship between two values.
•	Regression model would be preferred when the error values would be lesser, and since the range of values for ptratio is only between 13-50, a 5.5 mean squared error would not be accurate enough to describe a relation between the attributes. 
•	Association rules would be preferred when there is a need to know distinctly relationship between and two features, which is clearly calculated and shown by the rules generated by the Apriori algorithm. But mainly, in this case, since the relationship between features is not that evidently shown in the regression model, Association rules should be preferred.
