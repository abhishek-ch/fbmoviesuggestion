#http://stackoverflow.com/questions/26965624/cant-import-requests-oauthlib
#https://dev.twitter.com/rest/reference/get/friends/list

#http://www.academia.edu/8460155/Plotting_spatial_data_in_R_using_ggplot2
#http://www.milanor.net/blog/?p=594

import pprint
import twitter
import requests
import sys
import json
sys.path.append('/usr/local/lib/python2.7/site-packages/')
from requests_oauthlib import OAuth2Session
from requests_oauthlib import OAuth1

api = OAuth1('MIgAEnO0XHTPKdMv3qiGKr6nu',
                    client_secret='CMYO2quM7fUzcVuvx8JjALiKjC9cnpXeJFqQLtv2pnECJCCZKz',
                    resource_owner_key='69009666-XkI1bcxXtE4qXfOtbRYCgkiJJvpCfsmS0fq4OSq9d',
                    resource_owner_secret='w89WtxJDAwakPToMqoFtpQYJIfht6YS3a8136hpcyW7eG')






#loc = requests.get(url='https://api.twitter.com/1.1/followers/list.json', auth=api)


#print pprint.pprint(loc.json())





val = requests.get(url='https://api.twitter.com/1.1/followers/list.json?cursor=-1&screen_name=GreenFraud&skip_status=true&include_user_entities=false&count=5000', auth=api)
with open('followers_3.json', 'w') as outfile:
  json.dump(val.json(), outfile)


#print pprint.pprint(val.json())
