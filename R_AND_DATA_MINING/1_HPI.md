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
```