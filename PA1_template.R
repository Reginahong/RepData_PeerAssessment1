## Loading and preprocessing the data

echo = TRUE
setwd("D:/Users/sshong/Desktop/R working file/Course 5 Reproducible Research/Week2_Project1")
unzip("repdata%2Fdata%2Factivity.zip")
activity <- NULL
activity <- read.csv("activity.csv",header = TRUE,sep = ",")
head(activity)

### All the variables created are set to NULL

echo = TRUE
df_summary <- NULL
su2 <- NULL
su <- NULL
mn_int <- NULL
activity2 <- NULL
mean_su2 <- NULL
median_su2 <- NULL
activity2_weekend <- NULL
activity2_weekday <- NULL
mean_activity2_weekday <- NULL
mean_activity2_weekend <- NULL

##What is mean total number of steps taken per day?

###Calculate the total number of steps taken per day

echo = TRUE
su <- tapply(activity$steps,activity$date,sum,na.rm=TRUE)

###Make a histogram of the total number of steps taken each day

echo = TRUE
hist(su,xlab = "sum of steps per day",main = "Histogram of steps per day")

###Calculate and report the mean and median of the total number of steps taken per day

echo = TRUE
mean_su <- round(mean(su))
median_su <- round(median(su))

print(c("The mean is",mean_su))

print(c("The median is",median_su))

##What is the average daily activity pattern?

###Make a time series plot (i.e. type = "l") of the 5-minute interval (x-axis) and the average number of steps taken, averaged across all days (y-axis)

echo = TRUE
mn_int <- tapply(activity$steps,activity$interval,mean,na.rm = TRUE)
plot(mn_int~unique(activity$interval),type="l",xlab="5-min interval",main="Time series plot")

###Which 5-minute interval, on average across all the days in the dataset, contains the maximum number of steps?

echo = TRUE
mn_int[which.max(mn_int)]

##Imputing missing values

###Calculate and report the total number of missing values in the dataset (i.e. the total number of rows with NAs)

echo = TRUE
table(is.na(activity)==TRUE)
summary(activity)

###Devise a strategy for filling in all of the missing values in the dataset.
####Create a new dataset that is equal to the original dataset but with the missing data filled in

echo = TRUE
activity2 <- activity
for (i in 1:nrow(activity)){
  if(is.na(activity$steps[i])){
    activity2$steps[i] <- mn_int[[as.character(activity[i,"interval"])]]
  }
}

####Make a histogram of the total number of steps taken each day and Calculate and report the mean and median total number of steps taken per day. 

echo = TRUE
su2 <- tapply (activity2$steps,activity2$date,sum,na.rm=TRUE)
hist(su2,xlab="sum of steps per day",main = "Histogram of steps per day")

mean_su2 <- round(mean(su2))
median_su2 <- round(median(su2))

echo = TRUE
print(c("The mean is",mean_su2))

print(c("The median is",median_su2))

####Do these values differ from the estimates from the first part of the assignment?

echo = TRUE
df_summary <- rbind(df_summary, data.frame(mean = c(mean_su, mean_su2), median = c(median_su, median_su2)))
rownames(df_summary) <- c("with NA's", "without NA's")
print(df_summary)

####What is the impact of imputing missing data on the estimates of the total daily number of steps?

echo = TRUE
summary (activity2)

##Are there differences in activity patterns between weekdays and weekends?

###Create a new factor variable in the dataset with two levels - "weekday" and "weekend" indicating whether a given date is a weekday or weekend day.

echo = TRUE
activity2$weekday <- c("weekday")
activity2[weekdays(as.Date(activity2[, 2])) %in% c("Saturday", "Sunday", "samedi", "dimanche", "saturday", "sunday", "Samedi", "Dimanche"), ][4] <- c("weekend")
table(activity2$weekday == "weekend")

activity2$weekday <- factor(activity2$weekday)

###Make a panel plot containing a time series plot (i.e. type = "l") of the 5-minute interval (x-axis) and the average number of steps taken, averaged across all weekday days or weekend days (y-axis). 

echo = TRUE
activity2_weekend <- subset(activity2, activity2$weekday == "weekend")
activity2_weekday <- subset(activity2, activity2$weekday == "weekday")

mean_activity2_weekday <- tapply(activity2_weekday$steps, activity2_weekday$interval, mean)
mean_activity2_weekend <- tapply(activity2_weekend$steps, activity2_weekend$interval, mean)

echo = TRUE
library(lattice)
df_weekday <- NULL
df_weekend <- NULL
df_final <- NULL
df_weekday <- data.frame(interval = unique(activity2_weekday$interval), avg = as.numeric(mean_activity2_weekday), day = rep("weekday", length(mean_activity2_weekday)))
df_weekend <- data.frame(interval = unique(activity2_weekend$interval), avg = as.numeric(mean_activity2_weekend), day = rep("weekend", length(mean_activity2_weekend)))
df_final <- rbind(df_weekday, df_weekend)

xyplot(avg ~ interval | day, data = df_final, layout = c(1, 2), 
       type = "l", ylab = "Number of steps")

##It can be observed that there is a small difference between the period.