# This code sample uses the 'requests' library:
# http://docs.python-requests.org
import requests
import json
import csv

# Point to file
users_csv = ""

# Provide Int value for the column that contains the atlassian id (0 based index)
# If first column, then leave 0
id_column_index = 0

headers = {
    "Content-Type": "application/json",
    "Authorization": "Bearer <api_token>"
}

payload = json.dumps( {
    "message": "Account Disabled"
} )

########## READ CSV ##########
try:
    with open(users_csv) as file:
        reader = csv.reader(file)

        for line in reader:
            atlassian_id = line[id_column_index]
            url = "https://api.atlassian.com/users/" + atlassian_id + "/manage/lifecycle/disable"

            response = requests.request(
                "POST",
                url,
                data=payload,
                headers=headers
            )
            
            print(response.text)

except:
    print('File not found')
########## READ CSV END ##########