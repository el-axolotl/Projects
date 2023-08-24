import os
import requests
import json
from Settings import *

# Global variables
SUBDOMAIN = os.environ.get('SUBDOMAIN')
USERNAME = os.environ.get('USERNAME')
TOKEN = os.environ.get('TOKEN')
URL = "https://{}.zendesk.com/api/v2/".format(SUBDOMAIN)

def addSecondaryEmail(user_id, secondary_email, name):
    """
    Adds a verified secondary email to the account

    :param str user_id: The user ID to update
    :param str secondary_email: The secondary email to add
    """

    # The API URL to update users
    update_url = URL + "users/{}".format(user_id)

    # The body of the JSON object
    body = { 'user': { 'email': secondary_email, 'verified': True } }

    # JSON headers
    headers = {'content-type': 'application/json'}

    # Encode data
    payload = json.dumps(body)

    # Do the HTTP put request
    response = requests.put(update_url, data=payload, auth=(USERNAME, TOKEN), headers=headers)

    # Check for HTTP codes other than 200. 200 = OK
    if response.status_code != 200:
        print('Status:', response.status_code, "Problem adding a secondary email to {}'s account.".format(name))

    # Report success
    else:
        print("Successfully added secondary email to {}'s account.".format(name))

def getAllUsers():
    """Gets all the users"""
    # The API URL to get all the users
    get_all_users_url = URL + "users"

    # Do the HTTP GET request
    response = requests.get(get_all_users_url, auth=(USERNAME, TOKEN))

    # Check for HTTP codes other than 200. 200 = OK
    if response.status_code != 200:
        print('Status:', response.status_code, "Problem getting all the users")

    else:
        data = response.json()
        return data

def deleteUser(user_id, email):
    """
    Deletes a Zendesk End-User

    :param str user_id: The End-User ID
    :param str email: The End-User's email
    """
    # The API URL to delete the user
    delete_url = URL + "users/{}".format(user_id)

    # Do the HTTP DELETE request
    response = requests.delete(delete_url, auth=(USERNAME, TOKEN))

    # Check for HTTP codes other than 200. 200 = OK
    if response.status_code != 200:
        print('Status:', response.status_code, "Problem deleting {}'s account. It's possible that they have open tickets assigned to them, or requested by them.".format(email))

    # Report success
    else:
        print("Successfully deleted {}'s account".format(email))

def getUser(name):
    """
    Gets a User object

    :param str name: The End-User's name to search for
    """
    if ' ' in name:
        name.replace(' ', '_')

    # The API URL for searching
    search_url = URL + "users/search.json?query={}".format(name)

    # Do the HTTP GET request
    response = requests.get(search_url, auth=(USERNAME, TOKEN))

    # Check for HTTP codes other than 200
    if response.status_code != 200:
        print('Status:', response.status_code, 'Problem with searching the user.')

    # Decode the JSON response into a dictionary and use the data
    else:
        data = response.json()
        return data

def getAllSuspendedTickets():
    """
    Gets all the suspended tickets
    """
    # The API URL for getting the suspended tickets
    suspended_tickets_url = URL + "suspended_tickets"

    # Do the HTTP GET request
    response = requests.get(suspended_tickets_url, auth=(USERNAME, TOKEN))

    # Check for HTTP codes other than 200
    if response.status_code != 200:
        print('Status:', response.status_code, 'Problem with getting the suspended tickets.')

    # Decode the JSON response into a dictionary and use the data
    else:
        data = response.json()
        return data

def recoverSuspendedTicket(ticket_id):
    """
    Attempts to recover a suspended ticket

    :param str ticket_id: The suspended ticket ID to recover
    """
    # The API URL for recovering suspended_tickets
    recover_url = URL + "suspended_tickets/{}/recover".format(ticket_id)

    # Do the HTTP PUT request
    response = requests.put(recover_url, auth=(USERNAME, TOKEN))

    # Check for HTTP codes other than 200
    if response.status_code != 200:
        print('Status:', response.status_code, 'Problem with recovering ticket ID: {}.'.format(ticket_id))

    # Decode the JSON response into a dictionary and use the data
    else:
        print("Successfully recovered ticket ID: {}".format(ticket_id))

def deleteSuspendedTicket(ticket_id):
    """
    DO NOT USE: Deletes a suspended ticket without record

    :param str ticket_id: The suspended ticket ID to delete
    """
    # The API URL for deleting suspended tickets
    delete_url = URL + "suspended_tickets/{}".format(ticket_id)

    # Do the HTTP PUT request
    response = requests.delete(delete_url, auth=(USERNAME, TOKEN))

    # Check for HTTP codes other than 200
    if response.status_code != 200:
        print('Status:', response.status_code, 'Problem with deleting ticket ID: {}.'.format(ticket_id))

    # Decode the JSON response into a dictionary and use the data
    else:
        print("Successfully deleted ticket ID: {}".format(ticket_id))