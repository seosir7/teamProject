subpop <- read.csv('subpopulation.csv', stringsAsFactors = F)
# 종교인원, 신혼부부, 초혼비율, 총내원일수 에 대한 각지방에 자료 
tax <- read.csv('tax2.csv', stringsAsFactors = F)
#지역별 지방세 (2015)금액, 주민등록 인구수 
population <- read.csv('건강보험시도별연령별성별적용인구현황_20161231.csv')
# 건강보험적용 인구수  세대별로 나옴 
head(population)
library(dplyr)
sido_population <- population %>% group_by(시도) %>% summarize(total = sum(건강보험적용인구수))
sido_population 
#데이터프레임
# 나이별로 되있던 자료를 전세대를 지역별로 합침
class(sido_population)
only_pop <- as.numeric(unlist(sido_population[2]))
# only_pop
# numeric으로 바꿈 

sido <- as.list(subpop[1])
sido # 지역명만 빼옴 

mysido <- list()
tax_sido <- list()
for (i in 1:length(sido[[1]])) {
  mysido[[i]] <- paste(sido[[1]][i],'계', sep='')
  tax_sido[[i]] <- tax[tax[1] == mysido[[i]],3]
}


tax_sido <- as.numeric(tax_sido)
tax_sido # 시도별 지방세 수입액 
norm_tax <- (tax_sido - min(tax_sido)) / (max(tax_sido) - min(tax_sido)) 
# 정규화 시도별 지방세수익을 정규화 

subpop <- subpop[order(subpop[1]),] #  컬럼 1을 기준으로 정렬 
subpop

subpop[2] <- subpop[2]*10000/only_pop
subpop[2]
subpop[3] <- subpop[3]/100
subpop[4] <- subpop[4]/100
subpop[5] <- subpop[5]/only_pop
subpop[6] <- norm_tax

cor(subpop[-1])


mysido2 <- as.list(unique(population[1]))
men_youth <- list()
men_adult <- list()
men_middle <- list()
men_old <- list()
women_youth <- list()
women_adult <- list()
women_middle <- list()
women_old <- list()

# 각 변수 리스트에 담음 

for (i in 1:length(sido[[1]])) {
  mypop <- population[population == as.character(mysido2[[1]][i]),]  
  men_youth[[i]] <- sum(mypop[c(1:4),4])/sum(mypop[4])
  men_adult[[i]] <- sum(mypop[c(5:9),4])/sum(mypop[4])
  men_middle[[i]] <- sum(mypop[c(10:14),4])/sum(mypop[4])
  men_old[[i]] <- sum(mypop[c(15:19),4])/sum(mypop[4])
  women_youth[[i]] <- sum(mypop[c(20:23),4])/sum(mypop[4])
  women_adult[[i]] <- sum(mypop[c(24:28),4])/sum(mypop[4])
  women_middle[[i]] <- sum(mypop[c(29:33),4])/sum(mypop[4])
  women_old[[i]] <- sum(mypop[c(33:38),4])/sum(mypop[4])
}    

mydf2 <- data.frame(unlist(mysido2), unlist(men_youth),unlist(women_youth), unlist(men_adult), unlist(women_adult), unlist(men_middle), unlist(women_middle), unlist(men_old), unlist(women_old))
# 각 데이터를 데이터 프레임에 담음 

mydf2
length(mydf2)

mydf2[-1] # 1컬럼 시도 빼줌 

mydf2[10] <- norm_tax
mydf2[10]
mydf2[2] <- (mydf2[2] - min(mydf2[2])) / (max(mydf2[2]) - min(mydf2[2])) # 젊은 남성 정규화 
mydf2[3] <- (mydf2[3] - min(mydf2[3])) / (max(mydf2[3]) - min(mydf2[3])) # 젊은 여성 정규화 
mydf2[4] <- (mydf2[4] - min(mydf2[4])) / (max(mydf2[4]) - min(mydf2[4])) # 성인 남성 정규화
mydf2[5] <- (mydf2[5] - min(mydf2[5])) / (max(mydf2[5]) - min(mydf2[5])) # 성인 여성 정규화
mydf2[6] <- (mydf2[6] - min(mydf2[6])) / (max(mydf2[6]) - min(mydf2[6])) # 중년 남성 정규화
mydf2[7] <- (mydf2[7] - min(mydf2[7])) / (max(mydf2[7]) - min(mydf2[7])) # 중년 여성 정규화
mydf2[8] <- (mydf2[8] - min(mydf2[8])) / (max(mydf2[8]) - min(mydf2[8])) # 장년 남성 정규화 
mydf2[9] <- (mydf2[9] - min(mydf2[9])) / (max(mydf2[9]) - min(mydf2[9])) # 장년 여성 정규화

new_mydf2 <- mydf2[-8, -1] # 세종시 -8 제외
new_mydf2

cor(new_mydf2)
# 어린 남성은 1, 어린 여성(0.9946793)과 2.성인 남성(0.4458435 ) // 과 가장 높은 상관성 
# 어린 여성 1. 어린 남성(0.9946793), 2, 성인 남성 (0.4628136)
# 성인 남성 1. 성인여성( 0.8396158 ), 2. 어린 여성(0.4628136) 3. 어린 남성(0.4458435)
# 성인 여성 1. 성인 남성(0.8396158), 2. 중년 여성(0.3712004)
# 중년 남성 1. 중년 여성 (0.2389184) 다른 것들은 모두 음의 상관관계 
# 중년 여성 1. 성인 남성( 0.4061202), 2. 성인여성(0.3712004) / ㅇ
# 노년 남성 - 1. 노년 여성(0.99380598) 그외에 대부분 음의 상관관계
# 노년 여성 - 1. 노년 남성(0.99380598) 그 외에 대부분 음의 상관관계

# 세금 대비 영향을 미치는 비율
# 어린 남성,어린여성   -0.66592154, -0.64898562 
# 성인 남성, 성인여성 0.16428744, 0.41099328
# 중년 남성, 중년 여성 -0.19245588, 0.59175058
# 노년 남성, 노년 여성 -0.04124511, -0.06831208

# 결론 


#need to be normalized
new_mydf2
library(car)
plot(mydf2) # 플로트 해석 아직 
result <- lm(formula=V10~., new_mydf2)
# 회기분석 종속변수를 지역 전체 인구수 중 가장 영향을 미치는 것? 

result
vif(result)
# 분산 팽창 요인은 공차 한계의 역수로 표시한다.
# 공차 한계 : 한 독립 변수가 다른 독립 변수들에 의하여 설명이 되지 않는 부분을 의미한다.
# VIF는 10 이상이면 다중 공선성을 의심해봐야 한다

# 다중 공선성 : 독립 변수들 간의 강한 상관 관계로 인하여 회귀 분석의 결과를 신뢰할 수 없게 되는 현상을 말한다.
# 강한 상관 관계를 갖는 독립 변수를 제거하여 해결한다.
# 다중 공선성 문제가 의심이 되는 경우에는 반드시 상관 계수를 구해보도록 한다.

plot(lm(formula=unlist(men_adult)~unlist(women_adult), new_mydf2))
plot(lm(formula=unlist(women_adult)~unlist(men_adult), new_mydf2))

pcr_result <- prcomp(new_mydf2)
pcr_result
# Standard deviations (1, .., p=9):
# [1] 0.572964538 0.361021844 0.250103009 0.098478882 0.084358916 0.059848807 0.016701387 0.007339317 0.004238892

#  두요인이 0.57+0.36 = 93%을 넘기에 요인분석 가능 

summary(pcr_result)
# 이 성분을 가진 

adult <- unlist(men_adult) + unlist(women_adult)
adult
youth <- unlist(men_youth) + unlist(women_youth)

pcr_df <- data.frame(adult, youth, norm_tax)
pcr_df
result2 <- lm(formula=norm_tax~., pcr_df)
result2
# 성인이 긍정적인 영향을 미친다. / 
vif(result2)
# 다중 공선성에 맞기에 회기분석을 이용 해게  된다.
lm(result2)

# 청년 남성과는 양의 상관관계 이고 노년 남여성과의 음의 상관관계를 가지는  1번째 요인 성인남여성 / 2번째 요인을 어린애들로 하고 

