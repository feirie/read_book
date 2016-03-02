本案例是通过KDD Cup 1998竞赛来演示如何使用决策树预测客户反馈与效益最大化，同样的方法已经在真实的商业应用中取得成功。本次竞赛的目标是估计一个直邮的回复量，以便获得最多的捐款。数据集中有两个目标变量，TARGET_B是一个二进制变量，表示当一条记录中的TARGET_D变量中有捐款时，该条记录是否对邮件做了回复。
```r
cup98<-read.csv("cup98LRN.txt")
dim(cup98)
(response.percentage<-round(100*prop.table(table(cup98$TARGET_B)),digits=1))
pie(response.percentage,labels=paste("TARGET_B=",names(response.percentage),"\n",response.percentage,"%",sep=" "))

#查看捐款数额大于0的记录，即变量TARGET_D的值大于0的所有记录
cup98pos<-cup98[cup98$TARGET_D>0,]
targetPos<-cup98pos$TARGET_D
summary(targetPos)
boxplot(targetPos)

#查看捐款数额大于0并且不是所有的捐款都是美元的记录，并将非美元的捐款兑换为美元，再绘制条形图。从图中可以看到大部分客户的捐款数额都不超过25美元，但都是5的倍数。
length(targetPos)
sum(!(targetPos %in% 1:200))
targetPos<-round(targetPos)
barplot(table(targetPos),las=2)

cup98$TARGET_D2<-cut(cup98$TARGET_D,right = F,breaks = c(0,0.1,10,15,20,25,30,50,max(cup98$TARGET_D)))
table(cup98$TARGET_D2)
cup98pos$TARGET_D2<-cut(cup98pos$TARGET_D,right = F,breaks = c(0,0.1,10,15,20,25,30,50,max(cup98pos$TARGET_D)))

#RFA_2R中所有字段全都是L，大约99.7%的记录中的NOEXCH字段的值都为0，这两个字段都可以删除
table(cup98$RFA_2R)
round(100*prop.table(table(cup98$NOEXCH)),digits=3)

varSet <- c(
 # demographics
 "ODATEDW", "OSOURCE", "STATE", "ZIP", "PVASTATE", "DOB",
"RECINHSE", "MDMAUD", "DOMAIN", "CLUSTER", "AGE", "HOMEOWNR",
"CHILD03", "CHILD07", "CHILD12", "CHILD18", "NUMCHLD",
"INCOME", "GENDER", "WEALTH1", "HIT",
 # donor interests
 "COLLECT1", "VETERANS", "BIBLE", "CATLG", "HOMEE", "PETS",
"CDPLAY", "STEREO", "PCOWNERS", "PHOTO", "CRAFTS", "FISHER",
"GARDENIN", "BOATS", "WALKER", "KIDSTUFF", "CARDS", "PLATES",
 # PEP star RFA status
 "PEPSTRFL",
 # summary variables of promotion history
 "CARDPROM", "MAXADATE", "NUMPROM", "CARDPM12", "NUMPRM12",
 # summary variables of giving history
 "RAMNTALL", "NGIFTALL", "CARDGIFT", "MINRAMNT", "MAXRAMNT",
"LASTGIFT", "LASTDATE", "FISTDATE", "TIMELAG", "AVGGIFT",
 # ID & targets
 "CONTROLN", "TARGET_B", "TARGET_D", "TARGET_D2", "HPHONE_D",
 # RFA (Recency/Frequency/Donation Amount)
 "RFA_2F", "RFA_2A", "MDMAUD_R", "MDMAUD_F", "MDMAUD_A",
 #others
 "CLUSTER2", "GEOCODE2")
cup98<-cup98[,varSet]

#数据探索分析需要遵循3个步骤。
#1.查看单个变量的的分布情况，这样做是为了了解每一个变量值的分布情况并找出缺失值和离群点，以便确定变量是否需要进行转换或者是否应该用于建模。
#2.要查看目标变量（因变量）与预测变量（自变量）之间的关系，这可以用于特征选择。
#3.查看预测变量之间的关系，以便删除冗余变量。
idx.num<-which(sapply(cup98,is.numeric))
layout(matrix(c(1,2),1,2))
myHist<-function(x){hist(cup98[,x],main=NULL,xlab=x)}
sapply(names(idx.num[4:5]),myHist)
layout(matrix(1))
boxplot(cup98$HIT)
cup98$HIT[cup98$HIT>200]
boxplot(cup98$HIT[cup98$HIT<200])
#从图中可以看到，有小部分的值与其余大部分的HIT值远远分开。进一步查看发现这些值全都为240或241.在实际应用中，这种情况需要与领域专家共同研究，因为有可能属于正常情况，在训练数据时应该保留这些值；另一方面这几个可能是离群点，在建模时应该将这些值剔除。另一种方法是数据重构不需要删除离群点。数据重构的一种原始的方法是使用所有记录中HIT的均值或者中位数进行替换。在这个案例中的处理方法是重构数据。

#查看捐赠者在不同年龄段的分布情况，图中显示年龄在30-60岁人群的平均捐赠金额比其他年龄段的高，因为30-60岁年龄段的人群是主要劳动力。
AGE2<-cut(cup98pos$AGE,right = F,breaks = seq(0,100,by=5))
boxplot(cup98pos$TARGET_D~AGE2,ylim=c(0,40),las=3)


#查看捐赠者在不同性别上的分布情况，共同账户J的捐赠者数量少于性别为男性M或女性F的捐赠者
attach(cup98pos)
boxplot(TARGET_D~GENDER,ylim=c(0,80))
plot(density(TARGET_D[GENDER=="F"]),xlim=c(0,60),col=1,lty=1)
lines(density(TARGET_D[GENDER=="M"]),col=2,lty=2)
lines(density(TARGET_D[GENDER=="J"]),col=3,lty=3)
legend("topright",c("Female","Male","Joint account"),col=1:3,lty=1:3)
detach(cup98pos)

#
correlation<-cor(cup98$TARGET_D,cup98[,idx.num],use = "pairwise.complete.obs")
correlation<-abs(correlation)
(correlation<-correlation[,order(correlation,decreasing = T)])
cor(cup98[,idx.num])
pairs(cup98)

#绘制数值变量的散布图，并基于目标变量设置点的颜色，下面使用函数jitter()添加少量的噪声数据，在存在大量重叠数据点的情况这种设置很有用。
color<-ifelse(cup98$TARGET_D>0,"blue","black")
pch<-ifelse(cup98$TARGET_D>0,"+",".")
plot(jitter(cup98$AGE),jitter(cup98$HIT),pch=pch,col=color,cex=0.7,ylim=c(0,70),xlab="AGE",ylab="HIT")
legend("topright",c("TARGET_D>0","TARGET_D=0"),col=c("blue","black"),pch=c("+","."))

myChisqTest<-function(x){
	t1<-table(cup98pos[,x],cup98pos$TARGET_D2)
	plot(t1,main=x,las=1)
	print(x)
	print(chisq.test(t1))
}

#训练决策树
#使用party包的函数ctree()创建一颗决策树
#MinSplit控制一个节点中实例的最少数量以便进行分割
#MinBusket设置一个叶子节点中实例的最小数量
#MaxSurrogate表示替代分裂点的数量以便用于评估
#MaxDepth控制决策树的深度
nRec<-dim(cup98)[1]
trainSize<-round(nRec*0.7)
testSize<-nRec-trainSize
MinSplit<-1000
MinBucket<-400
MaxSurrogate<-4
MaxDepth<-10
(strParameters<-paste(MinSplit,MinBucket,MaxSurrogate,MaxDepth,sep="-"))
LoopNum<-10
cost<-0.68
varSet2 <- c("AGE", "AVGGIFT", "CARDGIFT", "CARDPM12",
"CARDPROM", "CLUSTER2", "DOMAIN", "GENDER", "GEOCODE2", "HIT",
"HOMEOWNR", "HPHONE_D", "INCOME", "LASTGIFT", "MAXRAMNT",
"MDMAUD_F", "MDMAUD_R", "MINRAMNT", "NGIFTALL", "NUMPRM12",
"PCOWNERS", "PEPSTRFL", "PETS", "RAMNTALL", "RECINHSE",
"RFA_2A", "RFA_2F", "STATE", "TIMELAG")
cup98<-cup98[,c("TARGET_D",varSet2)]
library(party)

pdf(paste("evaluation-tree-",strParmeters,".pdf",spe=""),width=12,height=9,paper="a4r",pointsize = 6)
cat(date(),"\n")
cat(" trainSize=", trainSize, ", testSize=", testSize, "\n")
cat(" MinSplit=", MinSplit, ", MinBucket=", MinBucket, ", MaxSurrogate=", MaxSurrogate, ", MaxDepth=", MaxDepth, "\n\n")
allTotalDonation <- matrix(0, nrow=testSize, ncol=LoopNum)
allAvgDonation <- matrix(0, nrow=testSize, ncol=LoopNum)
allDonationPercentile <- matrix (0, nrow=testSize, ncol=LoopNum)

for(loopCnt in 1:LoopNum){
  cat(date(), ": iteration = ", loopCnt, "\n")
  trainIdx<-sample(1:nRec,trainSize)
  trainData<-cup98[trainIdx,]
  testData<-cup98[-trainIdx,]
  
  myCtree<-ctree(TARGET_D~.,data=trainData,controls=ctree_control(minsplit=MinSplit, minbucket=MinBucket,
  maxsurrogate=MaxSurrogate, maxdepth=MaxDepth))
  print(object.size(myCtree),units="auto")
  save(myCtree, file=paste("cup98-ctree-", paste(MinSplit,MinBucket,MaxSurrogate,MaxDepth,sep="-"), "-run-",
                            loopCnt, ".rdata", sep=""))
  figTitle <- paste("Tree", loopCnt)
  plot(myCtree, main=figTitle, type="simple",
       ip_args=list(pval=FALSE), ep_args=list(digits=0,abbreviate=TRUE),
       tp_args=list(digits=2))
  pred<-predict(myCtree,newdata=testData)
  plot(pred,testData$TARGET_D)
  print(sum(testData$TARGET_D[pred>cost]-cost))
  s1<-sort(pred,decreasing=T,method="quick",index.return=T)
  totalDonation<-cumsum(testData$TARGET_D[s1$ix])
  avgDonation<-totalDonation/(1:testSize)
  donationPercentile<-100*totalDonation/sum(testData$TARGET_D)
  allTotalDonation[,loopCnt] <- totalDonation
  allAvgDonation[,loopCnt] <- avgDonation
  allDonationPercentile[,loopCnt] <- donationPercentile
  plot(totalDonation, type="l")
  grid()
}
graphics.off()
cat(date(), ": Loop completed.\n\n\n")
fnlTotalDonation <- rowMeans(allTotalDonation)
fnlAvgDonation <- rowMeans(allAvgDonation)
fnlDonationPercentile <- rowMeans(allDonationPercentile)
rm(trainData, testData, pred)
results <- data.frame(cbind(allTotalDonation,fnlTotalDonation))
names(results) <- c(paste("run.",1:LoopNum), "Average")
write.csv(results, paste("evaluation-TotalDonation-",strParameters, ".csv", sep=""))


#模型评估
result <- read.csv("evaluation-TotalDonation-1000-400-4-10.csv")

```