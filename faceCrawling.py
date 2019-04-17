from selenium import webdriver
from selenium.webdriver.common.keys import Keys
from bs4 import BeautifulSoup
import time

usr = "heygun@naver.com" #아이디 
pwd = "z" # 비번

path = "C:/chromedriver_win32/chromedriver.exe" #크롬드라이버- 셀레늄쓸때 필요
driver = webdriver.Chrome(path) # 크롬브라우저로 하겠다는 뜻 
driver.get("https://facebook.com/") # .get : 주소 페이스북 열어라
# assert "Facebook" in driver.title # 이것의 의미를 모르겠어 이거 없이도 나옴 
elem = driver.find_element_by_id("email") # id가 email에를 찾아
elem.send_keys(usr) # 입력
elem = driver.find_element_by_id("pass") # id가 pass에를 찾아라
elem.send_keys(pwd)
elem.send_keys(Keys.RETURN) #의미를 모르겠다. 

# 페북 미래식량 동영상 페이지
movie = driver.get("https://m.facebook.com/search/videos/?q=%EB%AF%B8%EB%9E%98%EC%8B%9D%EB%9F%89&epa=SERP_TAB")
for i in range (1, 30):
    driver.execute_script("window.scrollTo(0, document.body.scrollHeight);") # 페이스북 과 같은 스타일 스크롤 하는 기능 코드
    time.sleep(0.5)

html = driver.page_source # driver.page_source 현재 렌더링 된 페이지의 Elements를 모두 가져올 수 있는 기능
soup = BeautifulSoup(html, 'html.parser') # 이 두개는 거의 고정이라 외우는게 편함
contents = soup.find_all('div', attrs={'class' : '_5rgt _5nk5 _5msi'}) # 내용 크롤링
tags = soup.find_all('span', attrs={'class': '_5ayu'}) # 태그 크롤링
result1 = [] # 리스트 변수 설정
result2 = []

for content in contents:
    result1.append(content.text) # contents를 리스트에 담는 작업
for tag in tags:
    result2.append(tag.text) # 이하 동문

first_result = result1 + result2 # 태그와 컨텐츠 리스트를 하나로 담음
print(first_result)
with open('result1(facebook).txt', 'wt', encoding='utf-8') as file: # 파일 txt로 save
    file.writelines(first_result)

#페북 미래식량 게시물 페이지
post = driver.get('https://m.facebook.com/graphsearch/str/%EB%AF%B8%EB%9E%98%EC%8B%9D%EB%9F%89/stories-keyword/stories-public?tsid&source=pivot')
for i in range (1, 33):
    driver.execute_script("window.scrollTo(0, document.body.scrollHeight);")
    time.sleep(0.5)
    
html2 = driver.page_source
soup2 = BeautifulSoup(html2, 'html.parser')
posts=soup2.find_all('div', attrs={'class' : '_59k _2rgt _1j-f _2rgt'})
second_result = []
for post in posts:
    second_result.append(post.text)
print(second_result)
print(len(contents)) #57건
print(len(posts)) #161건 [806/5]


with open('result2(facebook).txt', 'wt', encoding='utf-8') as file:
    file.writelines(second_result)