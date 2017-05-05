# Анализ на човешки ресурси чрез симулирани данни

### Проект на Християн Марков и Пламен Никифоров, спец. Статистика по дисциплината "Приложна статистика"
### ФМИ 2017 г.


## Задача
* Анализ на служителите в дадената симулирана фирма
* Предсказване кои ще напуснат и защо
* Съпоставка на различни модели
   * Логистична регресия (Logistic Regression)
   * Дърво на решенията (Decision Tree)
   * Случайна гора (Random Forest)

***

## Начални данни

Даните са свалени от [Kaggle](https://www.kaggle.com/ludobenistant/hr-analytics) и представляват .csv файл с 10499 реда и 10 колони - 9 предиктора и 1 отклик.

### Зареждане и проверка

Зареждаме файла по обичайния начин с **read.csv**:

     HR_comma_sep <- read.csv("~/PrilStat/HR_comma_sep.csv")

Преглеждаме го:

     > summary(HR_comma_sep)
     satisfaction_level last_evaluation  number_project  average_montly_hours time_spend_company
     Min.   :0.0900     Min.   :0.3600   Min.   :2.000   Min.   : 96.0        Min.   : 2.000    
     1st Qu.:0.4400     1st Qu.:0.5600   1st Qu.:3.000   1st Qu.:156.0        1st Qu.: 3.000    
     Median :0.6400     Median :0.7200   Median :4.000   Median :200.0        Median : 3.000    
     Mean   :0.6128     Mean   :0.7161   Mean   :3.803   Mean   :201.1        Mean   : 3.498    
     3rd Qu.:0.8200     3rd Qu.:0.8700   3rd Qu.:5.000   3rd Qu.:245.0        3rd Qu.: 4.000    
     Max.   :1.0000     Max.   :1.0000   Max.   :7.000   Max.   :310.0        Max.   :10.000    
     Work_accident         left        promotion_last_5years    sales              salary         
     Min.   :0.0000   Min.   :0.0000   Min.   :0.00000       Length:14999       Length:14999      
     1st Qu.:0.0000   1st Qu.:0.0000   1st Qu.:0.00000       Class :character   Class :character  
     Median :0.0000   Median :0.0000   Median :0.00000       Mode  :character   Mode  :character  
     Mean   :0.1446   Mean   :0.2381   Mean   :0.02127                                            
     3rd Qu.:0.0000   3rd Qu.:0.0000   3rd Qu.:0.00000                                            
     Max.   :1.0000   Max.   :1.0000   Max.   :1.00000 

Последните 2 характеристики - sales и salary са от класа character, всички други са числови, включително и left, но това ще го оправим по-нататък.

Важно е да разберем дали имаме липсващи данни:

     > sum(is.na(HR_comma_sep))
     [1] 0

Тъй като всички клетки са запълнени и няма нелогични стойности, може да започнем с разделянето на тренировъчен и тестови сет.

***

## Подготовка на данните за моделиране

Ще разделим информацията на две: с едната ще тренираме моделите, а с другата ще ги тестваме.

    # partition data in 2 sets

    library(caret)

    hrdata <- HR_comma_sep # save dataset copy

    trainIndex <- createDataPartition(hrdata$left, p = .7,list = FALSE,times = 1) # 70%-30% split
    trainData <- hrdata[ trainIndex,]
    testData  <- hrdata[-trainIndex,]

Използваме разделение 70-30 в полза на тренировъчния сет trainData. Така получаваме 10500 реда в trainData и 4499 в testData.

Нека проверим има ли зависимост между отделни променливи. Ще използваме корелация:

     # correlations
     library(corrplot) # for plot

     HR_correlation <- cor(HR_comma_sep[,1:8]) # only run on numeric values and save

     corrplot(HR_correlation, method="number") # fancy plot with numbers
     corrplot(HR_correlation, method="circle") # fancy plot with circles

![Корелация 1](http://i.imgur.com/Azu77Ro.png)

![Корелация 2](http://i.imgur.com/gUkDqrY.png)

***

## Първи модел: логистична регресия

Избрали сме три променливи.

     # logistic regression
     attach(trainData) # run after partitioning

     glm.fit = glm(left ~ average_montly_hours + last_evaluation 
              + time_spend_company, family = binomial)

     detach(trainData)

     attach(testData)

     glm.probsTest = predict(glm.fit,testData,type = "response")
     glm.predTest = rep(0,nrow(testData))
     glm.predTest[glm.probsTest>.35]=1
     table(glm.predTest,left) # confusion matrix
     mean(glm.predTest == left) # accuracy %

     detach(testData)

Получаваме следните резултати:

Праг 0.35:

     > table(glm.predTest,left) # confusion matrix
                      left
     glm.predTest    0    1
                0 3231 1009
                1  217   42
     > mean(glm.predTest == left) # accuracy %
     [1] 0.727495

Праг 0.5:

     > table(glm.predTest,left) # confusion matrix
                 left
     glm.predTest    0    1
                0 3399 1051
                1   49    0
     > mean(glm.predTest == left) # accuracy %
     [1] 0.7555012

Разликата между процентите е минимална, но при втората таблица забелязваме, че моделът не е познал изобщо напусналите.

***

## Втори модел: дърво на решенията

    # Decision Tree

    library(caret) # for decision tree
    library(dplyr)
    library(rattle) # for plot
    library(rpart) # for plot

    trainData$left <- as.factor(trainData$left) # factorize
    testData$left <- as.factor(testData$left)

    decisionTreeModel <- train(left~.,method="rpart",data=trainData) # model with all variables on the training subset

    fancyRpartPlot(decisionTreeModel$finalModel) # fancy plot

    testData$pred <- predict(decisionTreeModel,testData) # get predictions
    testData = testData %>% mutate(accurate = 1*(left == pred))
    table(testData$pred,testData$left) # confusion matrix
    sum(testData$accurate)/nrow(testData) # accuracy %

Получаваме следните резултати:

![Дърво на решенията](http://i.imgur.com/NJcJba8.png)

     > table(testData$pred,testData$left) # confusion matrix
   
            0    1
       0 3383  347
       1   69  700
     > sum(testData$accurate)/nrow(testData) # accuracy %
     [1] 0.907535

Успеваемостта е много по-висока, вече засичаме правилно и напусналите служители.

***

### Трети модел: случайна гора

Тъй като random forest не работи при повече от 53 различни нива на характеристика, трябва да обединим някои от тях:

     for (i in 1:14999)
         if(hrdata$average_montly_hours[i] < 160){
            hrdata$average_montly_hours[i] = "low"
         }else if(hrdata$average_montly_hours[i] >= 160 && hrdata$average_montly_hours[i] < 240){
            hrdata$average_montly_hours[i] = "medium"
         }else
            hrdata$average_montly_hours[i] = "high"
  
     for (i in 1:14999)
         if(hrdata$last_evaluation[i] < 0.6){
            hrdata$last_evaluation[i] = "low"
         }else if(hrdata$last_evaluation[i] >= 0.7 && hrdata$last_evaluation[i] < 0.85){
            hrdata$last_evaluation[i] = "medium"
         }else
            hrdata$last_evaluation[i] = "high"
    
     for (i in 1:14999)
         if(hrdata$satisfaction_level[i] < 0.4){
            hrdata$satisfaction_level[i] = "low"
         }else if(hrdata$satisfaction_level[i] >= 0.4 && hrdata$satisfaction_level[i] < 0.75){
            hrdata$satisfaction_level[i] = "medium"
         }else
            hrdata$satisfaction_level[i] = "high"

Нека изпробваме модела:

     library(randomForest)
     library(dplyr)

     #hrdata <- HR_comma_sep # HR_comma_sep is the dataset
     hrdata[] <- lapply(hrdata, factor) # factorize everything
     trainIndex <- createDataPartition(hrdata$left, p = .7,list = FALSE,times = 1) # 70%-30% split
     trainData <- hrdata[ trainIndex,]
     testData  <- hrdata[-trainIndex,]

     rfModel <- randomForest(left~.,trainData,ntree=50) # random forest model using all variables
     testData$pred <- predict(rfModel,testData) # predictions
     testData = testData %>% mutate(accurate = 1*(left == pred))  
     table(testData$pred,testData$left) # confusion matrix
     sum(testData$accurate)/nrow(testData) # accuracy %

Получаваме следните резултати:

     > table(testData$pred,testData$left) # confusion matrix
   
             0    1
        0 3378   79
        1   50  992
     > sum(testData$accurate)/nrow(testData) # accuracy %
     [1] 0.971327

### Изводи

* Логистичната регресия ни дава добър % точност, но често заблуждава
* Дърво на решенията показва резултатите в лесен за разбиране вид, с още по-голяма точност
* Случайна гора е най-добрият от изпробваните модели
* Може да пробваме K nearest neighbours и Cluster analysis, предвид зависимостите в данните
