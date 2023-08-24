import pyodbc
import getpass
import os
import csv
import tkinter as tk
from tkinter import filedialog

print('Please choose or create a folder to save your CSV file in')

# Sets root TK window to hidden. TK can be used later to create a GUI
root = tk.Tk()
root.withdraw()

# Sets directory to save CSV file
file_path = filedialog.askdirectory()

# Prompt user for desired file name and append .csv
file_name = input('Choose a name for your CSV file: ')
file_name = file_name + '.CSV'
absolute_name = file_path + '\\' + file_name

# Set credentials
print("Let's get you logged into Teradata . . . . .")
username = input('Enter username: ')
password = getpass.getpass('Enter Password: ')

# Connect to Teradata
print('Connecting to Teradata . . . . .')
connection = pyodbc.connect('DSN=poedw2;Trusted_Connection=yes;UID=' + username + ';PWD=' + password + ';', autocommit=True)
cursor = connection.cursor()

# Take user input for query then execute query
print('Enter SQL Query: ')
lines = []
while True:
    line = input()
    if line:
        lines.append(' ' + line)
    else:
        break

print('Fetching SQL results . . . . .')
query = ''.join(lines)
cursor.execute(query)
results = cursor.fetchall()

with open(absolute_name, 'w', newline='') as my_file:
    fwriter = csv.writer(my_file)
    column_header = [column[0] for column in cursor.description]
    fwriter.writerow(column_header)
    for row in results:
        fwriter.writerow(row)

print('Done. Goodbye :)')