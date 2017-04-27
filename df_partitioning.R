attach(HRds) #make sure to load the DF and run salary and departament encodeing

smp.size = floor(0.8 * nrow(HRds))

set.seed(1)

train.ind = sample(seq_len(nrow(HRds)),size = smp.size)

train = HRds[train.ind,]
test = HRds[-train.ind,]