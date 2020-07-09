library(survival)
library(rpart)
library(dplyr)
# Read Data
query <- 'select * from mart_ftb'
data <- exeQueryString (query, stringsAsFactors = TRUE)

### Train & Test sets
data_train <- data
data_score <- data[!is.na(data$IS_SCORE),]
data_nm    <- data[!is.na(data$NET_MARGIN_FWD_90D),]

### Survival object
surv <- Surv(time = data_train$OUTCOME_TIME, event = data_train$OUTCOME_CENSORED)
### Model fitting 
cox <- coxph(surv ~ QUARTER + 
                    NEW_CHANNEL +
                    USERGROUP_V2 +
                    TIME_BETWEEN_REG_FIRST, data = data_train)
### Curve Object
curve            <- basehaz(cox, centered=TRUE); names(curve) <- c("chaz", "time") #survival curve with cumulative hazard
curve$haz        <- c(curve$chaz[1], diff(curve$chaz))
curve$conv_30    <- 1 - exp(-lead(curve$chaz, 30)) - (1 - exp(-lead(curve$chaz, 0)))
curve$conv_60    <- 1 - exp(-lead(curve$chaz, 60)) - (1 - exp(-lead(curve$chaz, 0)))
curve$conv_90    <- 1 - exp(-lead(curve$chaz, 90)) - (1 - exp(-lead(curve$chaz, 0)))
head(curve, 5)
conversion <- function(time)
{
   if (time > 1000) (return (0.007422))
   i = which(curve$time == time)
   return(curve[i,]$conv_90)
}

### Propensity to convert in next 90 days
data_score$baseline_hazard <- sapply(data_score$OUTCOME_TIME, conversion)
data_score$risk            <- predict(cox, newdata = data_score, type = 'risk') #hazard ratio
data_score$score           <- data_score$baseline_hazard * data_score$risk
###
linearMod <- lm(NET_MARGIN_FWD_90D ~ QUARTER + 
                                     NEW_CHANNEL +
                                     USERGROUP_V2 +
                                     TIME_BETWEEN_REG_FIRST, data = data_nm)
data_score$nm <- predict(linearMod, newdata = data_score)
data_score$nm_pred <- data_score$score * data_score$nm

### Bucketing values into bins


a <- sort(data_score$score); plot(a)
abline(h=0.012, col="blue")
abline(h=0.071, col="blue")
abline(h=0.145, col="blue")

tags <- c("1","2", "3")
breaks <- c(0, 20, 50, 1000)
data_score$bins <- cut(data_score$nm_pred, 
                            breaks=breaks, 
                            include.lowest=TRUE, 
                            right=FALSE, 
                            labels=tags
)
aggregate(data_score$nm_pred, by=list(data_score$bins), FUN=sum)
aggregate(data_score$nm_pred, by=list(data_score$bins), FUN=length)



### How to bin
data_score     <- data_score[order(data_score$score),]
data_score$rnk <- 1:nrow(data_score)
fit <- rpart(formula = score ~ rnk, 
                data = data_score, 
             control = rpart.control(cp = 0.075), 
              method = "anova"
)
fit

i <- 68205; data_score[i,]$nm_pred;
i <- 93735; data_score[i,]$nm_pred;

tags <- c("1","2", "3")
breaks <- c(0, 24.8, 47.43, 10000)
data_score$bins <- cut(data_score$nm_pred, 
                       breaks=breaks, 
                       include.lowest=TRUE, 
                       right=FALSE, 
                       labels=tags
)
data_score <- data_score[!is.na(data_score$nm_pred),]
aggregate(data_score$nm_pred, by=list(data_score$bins), FUN=mean)
aggregate(data_score$nm_pred, by=list(data_score$bins), FUN=length)

a <- sort(data_score$nm_pred); plot(a)
abline(h = 24.8, col="blue")
abline(h = 47.43, col="blue")

