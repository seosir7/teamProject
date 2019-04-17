from bs4 import BeautifulSoup
import re
from konlpy.tag import Okt
from collections import Counter

from konlpy.tag import Twitter
import matplotlib
import matplotlib.pyplot as plt
 
from matplotlib import font_manager, rc

import pytagcloud
import webbrowser

a=('result1(facebook).txt')
b=('result2(facebook).txt')
c=('result(instagram).txt')
d=('result.txt')
e=('result(naver).txt')

# linelists = facefile2.readlines()
# print(type(linelists) 
 

# for i in range(1,5):
#     print(i)
 
face1 = open(a,'r')
face2 = open(b,'r')
insta = open(c,'r')
twit = open(d,'r')
nav = open(e,'r')

v2face1 = face1.readlines()
v2face2 = face2.readlines()
v2insta = insta.readlines()
v2twit = twit.readlines()
v2nav= nav.readlines()

totalSNS = v2face1 + v2face2 + v2insta + v2twit +v2nav
v2nav





# print(totalSNS)
print(type(totalSNS))

# # print(type(face1))
# soup = BeautifulSoup(totalSNS, 'html.parser')
# aa = soup.text
# print(aa)
# print(type(aa))
     
# 텍스트를 한 줄씩 처리하기
 
FinTotal = str(totalSNS)


# print(FinTotal)
print(type(FinTotal)) 
     
# 모두 합친것 정규화 
reFinTotal = re.sub(r'[^\w]', ' ', FinTotal) 

# print( newtext )
print(type(reFinTotal))        

okt = Okt()
      
wordcloud=okt.nouns(reFinTotal)

# print(wordcloud)
     
count = Counter(wordcloud)

# print(count)
print(type(count))

countdict = dict(count)


countdict['스피루리나'] = 0
countdict['미래'] = 0
countdict['식량'] = 0
countdict['마야'] = 0
countdict['마야인'] = 0
countdict['아즈텍'] = 0




print(type(countdict))
print(countdict)


keys = sorted(countdict.items(), key=lambda x:x[1], reverse=True)

wordInfo = dict()
for word, count in keys[:500]:
    print("{0}({1}) ".format(word, count), end="")
    if (count > 60) and len(word) >= 2 :
        wordInfo[word] = count

def saveWordCloud( wordInfo ):
    taglist = pytagcloud.make_tags(dict(wordInfo).items(), minsize=15,maxsize=65)
    print( type(taglist) ) # <class 'list'>
    filename = 'wordcloud.png'
     
    pytagcloud.create_tag_image(taglist, filename, \
               size=(640, 480), fontname='korean', rectangular=False)
    webbrowser.open( filename )


def showGraph( wordInfo ):
    font_location = 'c:/Windows/fonts/malgun.ttf'
    font_name = font_manager.FontProperties(fname=font_location).get_name()
    matplotlib.rc('font', family=font_name) 
     
    plt.xlabel('주요 단어')
    plt.ylabel('빈도 수')
    plt.grid(False)
     
    barcount = 10 # 10개만 그리겠다.
     
    Sorted_Dict_Values = sorted(wordInfo.values(), reverse=True)    
    print( Sorted_Dict_Values )
    print('dd')
    plt.bar(range(barcount), Sorted_Dict_Values[0:barcount], align='center')
      
    Sorted_Dict_Keys = sorted(wordInfo, key=wordInfo.get, reverse=True)
    print( Sorted_Dict_Keys )
    plt.xticks(range(barcount), list(Sorted_Dict_Keys)[0:barcount], rotation='70')
      
    filename = 'SNScrawling.png'
    plt.savefig( filename, dpi=400, bbox_inches='tight' )
    print( filename + ' 파일이 저장되었습니다.')      
    plt.show()        



saveWordCloud( wordInfo )
showGraph(wordInfo)



