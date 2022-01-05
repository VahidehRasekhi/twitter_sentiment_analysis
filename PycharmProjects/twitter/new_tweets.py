import csv, json

file = open("/Users/vahidehrasekhi/PycharmProjects/twitter/tweets.csv", 'r', encoding='utf-8')
reader = csv.reader(file)


out = open("/Users/vahidehrasekhi/PycharmProjects/twitter/output_tweets.json", 'w')
# col4writer = csv.writer(out)

all_tweets = []
for line in reader:
    tweets = {'text': '', 'location': '', 'hashtags': ''}
    #'followers_count': '', 'friends_count': '', 'retweeted_status': '', 'full_text': '', 'retweeted': '', 'retweet_count': ''
    # try:
    for ind,item in enumerate(line):
        if 'text' in item:
            tweets['text']= item[6:]
            break
    if item[-1] != '"':
        for indx,item in enumerate(line[ind+1:]):
            tweets['text'] += item
            # print(item)
            if len (item)>0 and item[-1] == '"':
                break
    else:
        indx = 1
    for ind1,item in enumerate(line[indx+ind:]):
        if 'location' in item:
            tweets['location'] = item[9:]
            break
    for ind2,item in enumerate(line[indx+ind+ind1+1:]):
        if 'hashtags' in item:
            tweets['hashtags'] = item[23:]
            break

    all_tweets.append(tweets)
    # except IndexError as e:
    #     print('a tweet index 3 failed', str(e))
    # print(line[16])
    # print(tweets)

f = json.dumps(all_tweets, indent=4)
out.write(f)

