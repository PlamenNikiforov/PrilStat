attach(HRds) #make sure to load the DF before attaching

length = length(salary)
encoded_salary = vector(length = length) #1-low,2-medium,3-high

for(i in 1:length){
  if(salary[i] == 'low'){
    encoded_salary[i] = 1
  } else if(salary[i] == 'medium'){
    encoded_salary[i] = 2
  } else if(salary[i] == 'high'){
    encoded_salary[i] = 3
  }
}

HRds = HRds[-grep('salary',colnames(HRds))]
HRds$enc_salary = encoded_salary