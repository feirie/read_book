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


```