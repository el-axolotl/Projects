import os

abspath = os.path.abspath(__file__)
dname = os.path.dirname(abspath)
env = "{}/.env".format(dname)

with open(env,'r') as file:
    lines = file.readlines()

    for line in lines:
        os.environ[line[:line.find('=')]] = line[line.find('=')+1:-1]