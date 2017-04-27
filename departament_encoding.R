attach(HRds) #make sure to load the DF before attaching

length = length(sales)
#1-sales,2-accounting,3-hr,4-technical,5-support
#6-management,7-IT,8-product_mng,9-marketing,10-RandD
encoded_sales = vector(length = length)

for(i in 1:length){
  if(sales[i] == 'sales'){
    encoded_sales[i] = 1
  } else if(sales[i] == 'accounting'){
    encoded_sales[i] = 2
  } else if(sales[i] == 'hr'){
    encoded_sales[i] = 3
  } else if(sales[i] == 'technical'){
    encoded_sales[i] = 4
  } else if(sales[i] == 'support'){
    encoded_sales[i] = 5
  } else if(sales[i] == 'management'){
    encoded_sales[i] = 6
  } else if(sales[i] == 'IT'){
    encoded_sales[i] = 7
  } else if(sales[i] == 'product_mng'){
    encoded_sales[i] = 8
  } else if(sales[i] == 'marketing'){
    encoded_sales[i] = 9
  } else if(sales[i] == 'RandD'){
    encoded_sales[i] = 10
  }
}

HRds = HRds[-grep('sales',colnames(HRds))]
HRds$enc_sales = encoded_sales
detach(HRds)