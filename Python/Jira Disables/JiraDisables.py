"""
Synopsis: This is a script to grab Jira Tickets that contain the disabled users'
    username in the Ticket Title, then check Active Directory to disable user 
    accounts.

Author: Christopher Munoz

Creation Date: 11/15/2019
"""

import csv
import os
from pyad import *
from jira import JIRA
import getpass

# If Active Directory Attribute: userAccountControl is 514 then the user is disabled.
disabledCode = 514
passw = getpass.getpass()

try:
    jira = JIRA(server='server.domain.com', basic_auth=('username',passw))

except:
    print('Authentication failed.')

ticket_list = jira.search_issues(jql_str='project = KEY AND assignee = TEAM AND status = open')

for x in ticket_list:
    ready_to_close_ticket = []
    
    # Grabs the Summary of the ticket
    summary = x.fields.summary

    cnStartIndex = summary.find('(')
    cnEndIndex = summary.find(')')

    # Returns the string between given indexes
    # Left of : is inclusive
    # Right of : is exclusive
    user = summary[cnStartIndex + 1:cnEndIndex]
    np_account = 'np_' + user
    admin_account = 'Admin ' + user
    phone = 'Cell Phone - ' + user

    # Attempt to find user account and confirm disable
    try:
        user_object = aduser.ADUser.from_cn(user)
        userAccountCode = user_object.get_attribute('userAccountControl')

        if userAccountCode[0] == disabledCode:
            print('{} is disabled.'.format(user))
            ready_to_close_ticket.append(True)
    except:
        user_object = None
        ready_to_close_ticket.append(False)
        print('{} not found. User might be listed as another name'.format(user))

    # Attempt to find np account and disable
    try:
        np_object = aduser.ADUser.from_cn(np_account)
        np_object.disable()
        print('{} found. {} is now disabled.'.format(np_object, np_object))
    except:
        np_object = None
        print('{} not found.'.format(np_account))

    # Attempt to find admin account
    try:
        admin_object = aduser.ADUser.from_cn(admin_account)
        ready_to_close_ticket.append(False)
        print('{} was found. Please delete with Domain Admin account.'.format(admin_object))
    except:
        admin_object = None
        print('{} not found.'.format(admin_account))

    # Attempt to find Phone Contact
    try:
        phone_object = aduser.ADUser.from_cn(phone)
        ready_to_close_ticket.append(False)
        print('{} was found. Please delete with Domain Admin account.'.format(phone_object))
    except:
        phone_object = None
        print('{} not found'.format(phone))

    print('Ready to close: {}'.format(all(ready_to_close_ticket)))
