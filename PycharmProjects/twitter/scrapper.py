import tweepy
import time
class MyListener(tweepy.Stream):
    def on_data(self, data):
        try:
            print(data)
            saveFile = open('tweets.csv', 'a')  # makes a csv file that appends all tweets to that file
            saveFile.write(str(data))  # writes the collected data on the file
            saveFile.write('\n')  # write each file in a new line
            saveFile.close()  # closes the file after writing on it
            return True
        except BaseException as e:  # throwing an error in case of any problems e.g. internet stops working
            print('failed on data', str(e))
            time.sleep(5)

        def on_error(self, status):
            print(status)

twitter_stream = MyListener(
        'consumer_key', 'consumer_secret', 'access_token', 'access_token_secret'

)
twitter_stream.filter(track = ['coronavirus', 'covid','moderna', 'pfizer', 'boostershot','BioNTech', 'vaccine', 'omicron', 'mask','quarantine'], languages=['en'])