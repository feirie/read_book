```r
houseIndex<-read.csv("House-index-canberra.csv")
names(houseIndex)<-c("date","index")
dim(houseIndex)
n<-nrow(houseIndex)
cat(paste("HPI from",houseIndex$date[1],"to",houseIndex$date[n]))
lct <- Sys.getlocale("LC_TIME")
Sys.setlocale("LC_TIME", "C")
dates<-strptime(houseIndex$date,format="%d-%b-%y")
houseIndex$year<-dates$year+1900
houseIndex$month<-dates$mon+1
fromYear<-houseIndex$year[1]

#another way
houseIndex$year<-as.numeric(format(dates,"%Y"))
houseIndex$month<-as.numeric(format(dates,"%m"))
Sys.setlocale("LC_TIME", lct)
#数据探索
plot(houseIndex$index,pty=1,type="l",lty="solid",xaxt="n",xlab="",ylab="Index",main=paste("HPI - Since ",fromYear,sep=""))
nYear<-n/12
posEveryYear<-12*(1:nYear)-11
axis(1,labels=houseIndex$date[posEveryYear],las=3,at=posEveryYear)
abline(h=1:4,col="gray",lty="dotted")
posEvery5Year<-12*(5*1:ceiling(nYear/5)-4)-11
abline(v=posEvery5Year,col="gray",lty="dotted")
#尽管使用函数grid可以在图表中添加参考网格线，但是网格线的位置不需要与每一个年份的起始位置对其。因此，上面首先计算参考线的位置，再使用abline绘制网格。

#查看每个月HPI的增长量
houseIndex$delta<-houseIndex$index-c(1,houseIndex$index[-n])
plot(houseIndex$delta,main="Increase in HPI",xaxt="n",xlab="")
axis(1,labels=houseIndex$date[posEveryYear],las=3,at=posEveryYear)
abline(h=0,lty="dotted")
#与2003年之前对比，2003年之后的HPI波动似乎更大。然而这是因为从1990年到2005年HPI从1增加至5.

#查看每个月的增长率
houseIndex$rate<-houseIndex$index/c(1,houseIndex$index[-n])-1
plot(houseIndex$rate,xaxt="n",xlab="",ylab="HPI Increase Rate",col=ifelse(houseIndex$rate>0,"green","red"),pch=ifelse(houseIndex$rate>0,"+","o"))
axis(1,labels=houseIndex$date[posEveryYear],las=3,at=posEveryYear)
abline(h=0,lty="dotted")
#从图中可以看出1)HPI增长的月份比下降的月份要多；2)增长率通常比下降率要大，大部分的增长率在0%~2%的范围内，大部分的下降率在0%~1%之间；3）1995-1996和2008-2009两个时间段内出现了较大幅度的降低，同时2002-2003出现了最大的增长。


#分组条形图来展示HPI的月增长率
rateMatrix<-xtabs(rate~month+year,data=houseIndex)
round(rateMatrix[,1:4],digits=4)
barplot(rateMatrix,beside = T,space = c(0,2),col=ifelse(rateMatrix>0,"green","red"),ylab="HPI Increase Rate",cex.names = 1.2)
numPositiveMonths<-colSums(rateMatrix>0)
barplot(numPositiveMonths,xlab="Year",ylab="Number of Months with Increased HPI")
yearlyMean<-colMeans(rateMatrix)
barplot(yearlyMean,main="Yearly Average Increase Rates of HPI",col=ifelse(yearlyMean>0,"green","red"),xlab="Year")
monthlyMean=rowMeans(rateMatrix)
plot(names(monthlyMean),monthlyMean,type="b",xlab="Month",main="Monthly Average Increase Rages of HPI")

#查看HPI增长率的分布
summary(houseIndex$rate)
boxplot(houseIndex$rate,ylab="HPI Increase Rate")
boxplot(rate~year,data=houseIndex,xlab="year",ylab="HPI Increase Rate")
boxplot(rate~month,data=houseIndex,xlab="month",ylab="HPI Increase Rate")
#4月和5月是房价增长最快的月份，因为在这两个月中平均增长率最高，大部分的增长率都是正数。其他一些增长率较高的月份为6月、1月和9月。房价增长率较慢的月份为3月、7月和8月。

#HPI趋势与季节性成分
#使用函数ts将指数转换为一个时间序列对象，然后使用函数stl对该时间序列进行分解
hpi<-ts(houseIndex$index,start=c(1990,1),frequency = 12)
f<-stl(hpi,"per")
plot(f)
plot(f$time.series[1:12,"seasonal"],type="b",xlab="Month",ylab="Seasonal Components")

#实现时间序列分解的另一个函数是decompose
f2<-decompose(hpi)
plot(f2)
plot(f2$figure,type="b",xlab="Month",ylab="Seasonal Components")

#HPI预测
startYear<-1990
endYear<-2010
nYearAhead<-4
fit<-arima(hpi,order=c(1,2,2),seasonal = list(order=c(0,0,1),period=12))
fore<-predict(fit,n.ahead = 12*nYearAhead)
ts.plot(hpi,fore$pred,U,L,col=c("black","blue","green","red"),lty=c(1,5,2,2),gpars=list(xaxt="n",xlab=""),ylab="Index",main="House Price Trading Index Forecast(Canberra)")
years<-startYear:(endYear+nYearAhead+1)
axis(1,labels=paste("Jan ",years,sep = ""),las=3,at=years)
grid()
legend("topleft",col=c("black","blue","green","red"),lty=c(1,5,2,2),c("Actual Index","Forecast","Upper Bound(95% Confidence)","Lower Bound(95% Confidence)"))

ts.plot(fore$pred,U,L,col=c("blue","green","red"),lty=c(5,2,2),gpars=list(xaxt="n",xlab=""),ylab="Index",main="House Price Trading Index Forecast(Canberra)")
years<-endYear+(1:(nYearAhead+1))
axis(1,labels=paste("Jan ",years,sep=""),las=3,at=years)
grid(col="gray",lty="dotted")
legend("topleft",col=c("blue","green","red"),lty=c(5,2,2),c("Forecast","Upper Bound(95% Confidence)","Lower Bound(95% Confidence)"))

#房地产估价
newHpi<-ts(c(hpi,fore$pred),start = c(1990,1),frequency = 12)
startDate<-start(newHpi)
startYear<-startDate[1]
m<-9+(2009-startYear)*12
n<-9+(2011-startYear)*12
100*(newHpi[n]/newHpi[m]-1)
round(535000*newHpi[n]/newHpi[m])  #2009/9一套房子以535000卖出，两年后这套房子的价格是多少
```