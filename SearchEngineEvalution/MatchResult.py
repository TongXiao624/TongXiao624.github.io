import json
import math

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


