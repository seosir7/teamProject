# 인구수 자료 읽어옴
nation <- read.csv('population.csv', stringsAsFactors = F)
head(nation)
# 전 인구수에( 남녀, 0~14세, 노도가능인구 65세이상인구로 분류등등)

population <- nation[7] # 토탈 값만 받아옴
class(population) # 데이터 프레임

total_population <- as.integer(population[c(6:nrow(population)),]) # integer로 변환
class(total_population)
norm_pop <- total_population / (max(total_population) - min(total_population)) # 정규화 
# norm_pop

population2 <- nation[12] # 생산 가능 인구 
work_population <-  as.integer(population2[c(6:nrow(population2)),]) # integer로 변환
worker_ratio <- work_population/total_population # 총인구대비 노동가능인구 비율 구함
norm_work <- worker_ratio/ (max(worker_ratio) - min(worker_ratio)) # 노동가능인구 비율 정규화 
# norm_work

socialinfra <- read.csv('socialInfra.csv') # 인프라 읽어옴 
infra_num <- socialinfra[8] # 합계만 읽어옴 
class(infra_num)
infra_num <- infra_num[c(1:nrow(infra_num)),] # 계 빼줌 숫자만 infra_num
infra_num <- as.integer(as.vector(infra_num)) # integer로 변환
infra_ratio <- infra_num/total_population # 총인구 대비 인프라 수 비율 구함  
# infra_ratio

norm_infra <-  infra_ratio / (max(infra_ratio) - min(infra_ratio))  # 정규화 해줌 

tax <- read.csv('3_2_지방자립도.csv')
tax_num <- tax[4] # 재정자립도만 가져옴
tax_num <- as.numeric(as.vector(tax_num[c(5:nrow(tax_num)),]))
class(tax_num) # numeric화 함 
norm_tax = tax_num / (max(tax_num) - min(tax_num)) # 정규화 함

business <- read.csv('4-총사업체 수.csv')
business_num <- business[3] # 사업체수 개만 빼옴 
business_num <- business_num[c(4:nrow(business_num)),] # 숫자 아닌것 들 제외 
business_num <- as.integer(as.vector(business_num)) # integer화
business_ratio <- business_num / work_population # 총인구 대비 사업체수 비율 
norm_business <- business_ratio / (max(business_ratio) - min(business_ratio)) # 정규화 

second <- read.csv('44.csv') # 추가한것 3번째 분석 제조업 상세
head(second[9])
second_num <- second[9]
second_num <- second_num[c(6:nrow(second_num)-1),]
second_num
second_num <- as.integer(as.vector(second_num))
second_num[is.na(second_num)] <- 0
second_ratio <- second_num / business_num
norm_second <- second_ratio / (max(second_ratio) - min(second_ratio))

third <- read.csv('7_234_3차산업.csv') 
# 숙박시설, 식품, 금융, 유통, 어린이집, 병원, 학원 
third_num <- third[10] # 합계만 가져옴
third_num <- as.integer(as.vector(third_num[c(5:nrow(third_num)),])) # 변수 integer로 바꿈 
w = mean(business_num)*0.782 / mean(third_num) #가중치 준것? / 
third_num <- third_num * w # 3차 서비스 산업 비중에 맞춰 가중치 줌
third_ratio <- third_num / business_num # 총사업체 중 3차산업 비중 
norm_third <- third_ratio / (max(third_ratio) - min(third_ratio)) # 정규화 

totaldf <- data.frame(norm_pop, norm_infra, norm_second, norm_third, norm_business, norm_tax)

# 정규화된 인구수, 인프라, 2차산업, 3차산업, 총사업체수, 지방자립도 를 데이터 프레임에 담음

totaldf

nation_name <- nation[1] #지역이름 / 수원시 세종시 ....

nation_name <- as.vector(nation_name[c(6:nrow(nation_name)),]) # 쓸데없는거 제거 
rownames(totaldf) <- nation_name # totaldf의 행에 지방이름을 넣음

cor(totaldf)
# 우리는 지방자립도에 가장 영향있는 것을 찾으면 됨 - 1순위 인구수(0.77353118) 2순위 2차산업(제조업)(0.46096929) 
# 결론 인구와 2차산업이 지방자립도에 가장 영향있는 것으로 나옴

pcr_r <- prcomp(totaldf[-6])
pcr_r # 변수를 줄이는 것 요인별 변동성을 줄이는 건데 / 1차와 2차가 대게 80% 이상나와야하는데 그렇지 않아서 요인분석을 쓰지 않음 
lm(formula = norm_tax ~., totaldf) # 종속변수를 지방자립도로 두고  


#방문객 수 포함한 분석
tour_num <- read.csv('관광객수.csv')
tnum <- tour_num[3]
tnum <-  as.vector(tnum[c(2:nrow(tnum)),])
tnum[tnum == '-'] <- 0
tnum <- as.integer(tnum)

df <- data.frame(norm_work, norm_infra, norm_second, norm_third, norm_business,tnum, norm_tax)
ndf <- df[c(-3,-4,-5,-7,-14,-15,-16,-17,-18, -31),]
#방문객 없는 도시 제외
tnum
cor(ndf)
lm(formula = norm_tax ~., ndf)

       