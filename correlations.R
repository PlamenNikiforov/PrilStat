# correlations
library(corrplot) # for plot

HR_correlation <- cor(HR_comma_sep[,1:8]) # only run on numeric values and save

corrplot(HR_correlation, method="number") # fancy plot with numbers
corrplot(HR_correlation, method="circle") # fancy plot with circles