library(survival)
library(survminer)
library(dplyr)

data(ovarian)
ovarian$resid.ds <- factor(ovarian$resid.ds, levels = c("1", "2"), labels = c("no", "yes"))
ovarian$ecog.ps  <- factor(ovarian$ecog.ps,  levels = c("1", "2"), labels = c("good", "bad"))

ovarian <- ovarian %>% mutate(age_group = ifelse(age >= 50, "old", "young"))
ovarian$age_group <- factor(ovarian$age_group)

surv_object <- Surv(time = ovarian$futime, event = ovarian$fustat)
fit1 <- survfit(surv_object ~ rx, data=ovarian)
summary(fit1)
ggsurvplot(fit1, data=ovarian, pval=TRUE)

fit2 <- survfit(surv_object ~ resid.ds, data=ovarian)
ggsurvplot(fit2, data=ovarian, pval=TRUE)

fit.coxph <- coxph(surv_object ~ rx + resid.ds + age_group + ecog.ps, data = ovarian)
ggforest(fit.coxph, data = ovarian)


fit1 <- survfit(surv_object ~ IS_DEPT_ELECTRONICS + IS_DEPT_FURNITURE, data = data)
ggsurvplot(fit1, data = data, pval = TRUE)
plot(surv_object)

temp <- survreg(Surv(futime, fustat) ~ ecog.ps + rx, ovarian, dist='weibull', scale=1)


###
data <- read.csv("mart_prediction.csv")
###
data$censored <- ifelse(is.na(data$NEXT_ORDER_DAYS), 0, 1)
data$IS_DEPT_ELECTRONICS <- factor(data$IS_DEPT_ELECTRONICS)
data$IS_DEPT_FURNITURE <- factor(data$IS_DEPT_FURNITURE)
data$IS_DEPT_ELSE <- factor(data$IS_DEPT_ELSE)
data$NEW_CHANNEL <- factor(data$NEW_CHANNEL)
###
surv_object <- Surv(time = data$NEXT_ORDER_DAYS_V2, event = data$censored)
###
cox <- coxph(surv_object ~ IS_DEPT_ELECTRONICS + IS_DEPT_FURNITURE + IS_DEPT_ELSE + NEW_CHANNEL, data = data)
cox <- coxph(surv_object ~ 1, data = data)
model1 <- survreg(Surv(NEXT_ORDER_DAYS_V2, censored) ~ IS_DEPT_ELECTRONICS, data = data[data$NEXT_ORDER_DAYS_V2 > 0,], dist='exponential')
model2 <- survreg(Surv(NEXT_ORDER_DAYS_V2, censored) ~ IS_DEPT_ELECTRONICS, data = data[data$NEXT_ORDER_DAYS_V2 > 0,], dist='weibull')
###
testData <- head(data, 10000)
b <- predict(model1, newdata=testData, type="quantile", p=(1:98)/100)

png(); 
plot(x=predict(model1, newdata=testData,  type="quantile", p=(1:98)/100,  y=(1:98)/100 , type='l') )
dev.off()

###

predict.survreg
cox_fit <- survfit(cox)
autoplot(cox_fit)
summary(cox)
ggforest(cox, data = data)


a <- predict(cox)



data(stanford2)
fit <- survreg(Surv(time,status) ~ age + I(age^2), data=stanford2, dist='lognormal')
#with(stanford2, plot(age, time, xlab='Age', ylab='Days', xlim=c(0,65), ylim=c(.1, 10^5), log='y', type='n'))
#with(stanford2, points(age, time, pch=c(2,4)[status+1], cex=.7))
pred <- predict(fit, newdata=list(age=60:65), type='quantile', p=c(.1, .5, .9)) 
#matlines(1:65, pred, lty=c(2,1,2), col=1) 


# Predicted Weibull survival curve for a lung cancer subject with
#  ECOG score of 2
lfit <- survreg(Surv(time, status) ~ ph.ecog, data=lung)
pct <- 1:98/100   # The 100th percentile of predicted survival is at +infinity
ptime <- predict(lfit, newdata=data.frame(ph.ecog=2), type='quantile', p=pct, se=TRUE)
matplot(cbind(ptime$fit, ptime$fit + 2*ptime$se.fit,
              ptime$fit - 2*ptime$se.fit)/30.5, 1-pct,
        xlab="Months", ylab="Survival", type='l', lty=c(1,2,2), col=1)





data(veteran)
head(veteran)
#
surv_object <- Surv(time = veteran$time, event = veteran$status)
#
km_fit <- survreg (surv_object ~ celltype + karno + diagtime + age + prior + trt, data= veteran, dist="w") #Fit a parametric survival regression model
cox    <- coxph (surv_object ~ trt + celltype + karno + diagtime + age + prior, data = veteran)
survConcordance(surv_object ~ prior, data = veteran)
#
curve <- survfit (cox) #creates survival curves
curve <- basehaz(cox, centered=TRUE) #survival curve with cumulative hazard
curve <- survfit (surv_object ~ 1, data=veteran)
#
summary(curve)
curve$cumhaz
summary(km_fit)
summary(survfit(cox), time = 5, age= 60)
str(summary(survfit(cox), time = 150))
summary(km_fit, times = c(1,30,60,90*(1:10)))
#
predict(km_fit, type = 'response')
predict(km_fit, type = 'link')
predict(km_fit, type = 'lp')
predict(km_fit, type = 'linear')
predict(km_fit, type = 'quantile', p=c(0.1))
#
predict(cox, type = 'lp')
temp <- veteran[1,]
predict(cox, temp, type = 'risk') #hazard ratio
predict(cox, type = 'expected')
sum(predict(cox, type = 'expected'))
predict(cox, type = 'terms')
predict(cox, type = 'survival')


km_trt_fit <- survfit(Surv(time, status) ~ trt, data=veteran)
summary(km_trt_fit)
plot(km_trt_fit)

data(vet)

a <- predict(cox)
plot(sort(a))
