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