from bs4 import BeautifulSoup
import time
import requests
from random import randint
from html.parser import HTMLParser
from playsound import playsound
import json
import math

USER_AGENT = {'User-Agent':'Mozilla/5.0 (Windows NT 10.0; Win64; x64)'
                           'AppleWebKit/537.36 (KHTML, like Gecko) Chrome/61.0.3163.100'
                           'Safari/537.36'}
class SearchEngine:
    @staticmethod
    def search(query, sleep=True):
        if sleep:  # Prevents loading too many pages too soon
            time.sleep(randint(10, 60))

        temp_url = '+'.join(query.split())  # for adding + between words for the query
        url = 'http://www.bing.com/search?q=' + temp_url

        #print(url)

        print(requests.get(url, headers=USER_AGENT, cookies={'SRCHHPGUSR': 'NRSLT=30'}).cookies)
        soup = BeautifulSoup(requests.get(url, headers=USER_AGENT, cookies={'SRCHHPGUSR': 'NRSLT=30'}).text, "lxml")     #"html.parser": python标准库

        #print(soup)

        new_results =  SearchEngine.scrape_search_result(soup)
        return new_results

    @staticmethod
    def scrape_search_result(soup):
        raw_results = soup.find_all('li', {'class': 'b_algo'})
        print(len(raw_results))
        results = []


        # implement a check to get only 10 results and also check that URLs must not be duplicated
        for result in raw_results:
            link = result.find('h2')
            if(len(results) == 10):
                return results
            results.append(link.find('a', {'href': True})['href'])

        #print(results)

        return results



#############Driver code############

f = open("search_query.txt")
queries = []
new_line = ""
while 1:
    lines = f.readlines(100)
    if not lines:
        break
    for line in lines:
        #print(line[-2:])
        if line.endswith('\n') :
            new_line = line[:-2]
            queries.append(new_line)
        else:
            queries.append(line[:-1])
print(queries)
f.close()

tuple_queries = tuple(queries)
#print(tuple_queries)

Dict_Bing_Results = dict.fromkeys(tuple_queries)
print("The Former Dict: ", Dict_Bing_Results)

query_results = []
for i in range(100):
    query_results = SearchEngine.search(tuple_queries[i])
    Dict_Bing_Results[tuple_queries[i]] = query_results

    print("The Dict "+ str(i+1) +": ", Dict_Bing_Results)


#JSON_Dict_Bing_Results = json.dump(Dict_Bing_Results)

with open('JSON_search_result.json', 'w') as f:
    json.dump(Dict_Bing_Results, f)
    print("Complete loading the file...")

#SearchEngine.search("How is library science vand information science related ")
#playsound('12193.wav')
####################################

class MatchResult:
    @staticmethod
    def match(google_result, bing_result):
        set_google_result = set(google_result)
        set_bing_result = set(bing_result)
        set_search_results_intersection = set_google_result.intersection(set_bing_result)
        list_search_results_intersection = list(set_search_results_intersection)

        bing_result_index = []
        google_result_index = []
        match_list = []
        #print(list_search_results_intersection)

        for i in range(len(list_search_results_intersection)):
            bing_result_index.append(bing_result.index(list_search_results_intersection[i]) + 1)
            google_result_index.append(google_result.index(list_search_results_intersection[i]) + 1)
            match_list.append([google_result.index(list_search_results_intersection[i]) + 1, bing_result.index(list_search_results_intersection[i]) + 1])

        #print("google_result_index: ", google_result_index,"    ;bing_result_index: " , bing_result_index)
        #print("Match List is (Google Ranking Number : Bing Ranking Number)", match_list)
        #print()

        return google_result_index, bing_result_index, match_list

class SpearmanCoefficienr:
    @staticmethod
    def rank_correlation(match_list):
        differ = 0
        n = len(match_list)

        if n == 0:
            return 0

        if n ==1:
            if match_list[0][0] == match_list[0][1]:
                return 1
            else:
                return 0

        for i in range(n):
            differ += math.pow(match_list[i][0] - match_list[i][1], 2)

        rank_ρ = 1 - ((6 * differ) / (n * (math.pow(n, 2) - 1)))

        return rank_ρ


f = open("search_query.txt")
queries = []
new_line = ""
while 1:
    lines = f.readlines(100)
    if not lines:
        break
    for line in lines:
        #print(line[-2:])
        if line.endswith('\n') :
            new_line = line[:-2]
            queries.append(new_line)
        else:
            queries.append(line[:-1])
#print(queries)
f.close()



################    Load GOOGLE Result      #####################
with open('JSON_google_result.json','r',encoding = 'utf-8') as fp_google:
    #print(type(fp))
    google_result_data = json.load(fp_google)
    #print(type(data))

#print(google_result_data)
fp_google.close()

################    Load BING Result      #####################
with open('hw1.json','r',encoding = 'utf-8') as fp_bing:
    bing_result_data = json.load(fp_bing)

#print(bing_result_data)
fp_bing.close()

#set_bing_result = set(google_result_data[queries[0]])
#set_google_result = set(bing_result_data[queries[0]])

overlapping_results_sum = 0
overlapping_results_percent = 0.0
spearman_coefficient_sum = 0

print("QUERIES\tNumber of Overlapping Results\tPercent Overlap\tSpearman Coefficient")
for i in range(len(queries)):

    g_index, b_index, match_list = MatchResult.match(google_result_data[queries[i]], bing_result_data[queries[i]])
    rank_ρ = SpearmanCoefficienr.rank_correlation(match_list)

    print("QUERY ",i+1, "\t", len(g_index), "\t", len(g_index)/10 * 100, "%\t", rank_ρ)

    overlapping_results_sum += len(g_index)
    overlapping_results_percent += len(g_index)/10 * 100
    spearman_coefficient_sum += rank_ρ

#print("===========================SUMMERY==========================")
percent_overlap = overlapping_results_sum / len(queries)
aver_spearman_coefficient = spearman_coefficient_sum / len(queries)

print("AVERAGE\t", percent_overlap, "\t", overlapping_results_percent / len(queries) , "%\t", aver_spearman_coefficient)
'''set_search_results_intersection = set_google_result.intersection(set_bing_result)
list_search_results_intersection = list(set_search_results_intersection)

bing_result_index = []
google_result_index = []
#bing_result_data[queries[0]].index(list_search_results_intersection[0])

for i in range(len(list_search_results_intersection)):
    bing_result_index.append(bing_result_data[queries[0]].index(list_search_results_intersection[i]) + 1)
    google_result_index.append(google_result_data[queries[0]].index(list_search_results_intersection[i]) + 1)

print(bing_result_data[queries[0]])
print(list_search_results_intersection, bing_result_index, google_result_index)'''
