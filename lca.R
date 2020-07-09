library(poLCA)
head(data_test)
x <- data_test[1:10000,]
#######
col <- c("IS_DEPT_ELECTRONICS")
y1 <- sort(as.character(unique(x[,col])))
y2 <- seq(1:length(y1))
f <- function(name) {return (y2[which(y1 == name)])}
x$IS_DEPT_ELECTRONICS_v2 <- sapply(x[, col], FUN = f) 
#######
col <- c("IS_DEPT_COMPUTERS")
y1 <- sort(as.character(unique(x[,col])))
y2 <- seq(1:length(y1))
f <- function(name) {return (y2[which(y1 == name)])}
x$IS_DEPT_COMPUTERS_v2 <- sapply(x[, col], FUN = f) 
#######
col <- c("IS_DEPT_FURNITURE")
y1 <- sort(as.character(unique(x[,col])))
y2 <- seq(1:length(y1))
f <- function(name) {return (y2[which(y1 == name)])}
x$IS_DEPT_FURNITURE_v2 <- sapply(x[, col], FUN = f) 
#######
col <- c("IS_DEPT_BABY_AND_KIDS")
y1 <- sort(as.character(unique(x[,col])))
y2 <- seq(1:length(y1))
f <- function(name) {return (y2[which(y1 == name)])}
x$IS_BABY_AND_KIDS_v2 <- sapply(x[, col], FUN = f) 
#######
col <- c("IS_DEPT_JEWELRY")
y1 <- sort(as.character(unique(x[,col])))
y2 <- seq(1:length(y1))
f <- function(name) {return (y2[which(y1 == name)])}
x$IS_JEWELRY_v2 <- sapply(x[, col], FUN = f)
#######
col <- c("IS_DEPT_TELEVISION")
y1 <- sort(as.character(unique(x[,col])))
y2 <- seq(1:length(y1))
f <- function(name) {return (y2[which(y1 == name)])}
x$IS_TELEVISION_v2 <- sapply(x[, col], FUN = f)
#######
col <- c("IS_DEPT_ELSE")
y1 <- sort(as.character(unique(x[,col])))
y2 <- seq(1:length(y1))
f <- function(name) {return (y2[which(y1 == name)])}
x$IS_ELSE_v2 <- sapply(x[, col], FUN = f)
#######
col <- c("NEW_CHANNEL")
y1 <- sort(as.character(unique(x[,col])))
y2 <- seq(1:length(y1))
f <- function(name) {return (y2[which(y1 == name)])}
x$NEW_CHANNEL_v2 <- sapply(x[, col], FUN = f)
#######
col <- c("QUARTER")
y1 <- sort(as.character(unique(x[,col])))
y2 <- seq(1:length(y1))
f <- function(name) {return (y2[which(y1 == name)])}
x$QUARTER_v2 <- sapply(x[, col], FUN = f)
#######
col <- c("PROFILEDESC")
y1 <- sort(as.character(unique(x[,col])))
y2 <- seq(1:length(y1))
f <- function(name) {return (y2[which(y1 == name)])}
x$PROFILEDESC_v2 <- sapply(x[, col], FUN = f)

#####
res2 = poLCA(cbind(IS_DEPT_ELECTRONICS_v2,
                   IS_DEPT_COMPUTERS_v2,
                   IS_DEPT_FURNITURE_v2,
                   IS_BABY_AND_KIDS_v2,
                   IS_JEWELRY_v2,
                   IS_TELEVISION_v2,
                   IS_ELSE_v2,
                   NEW_CHANNEL_v2, 
                   QUARTER_v2
                   ) ~ 1, 
                   maxiter=1000, 
                   nclass=7, 
                   nrep=5,
                   graphs=FALSE,
                   data=x
             )

x$predclass <- res2$predclass
x$OUTCOME <- ifelse(is.na(x$TEST_DAYS_TO_EVENT), 0, 1)
a <- aggregate(x$score, by=list(x$predclass), FUN=mean)
b <- aggregate(x$OUTCOME, by=list(x$predclass), FUN=mean)
