attach(train)#run after encoding and partitioning

glm.fit = glm(left~average_montly_hours+last_evaluation+time_spend_company,family = binomial)
detach(train)
attach(test)
glm.probsTest = predict(glm.fit,test,type = "response")
glm.predTest = rep(0,3000)
glm.predTest[glm.probsTest>.5]=1
table(glm.predTest,left)
mean(glm.predTest == left)
detach(test)