#!/usr/bin/python
import sqlite3 as sqlite
import json
import sys


conn = sqlite.connect('data.db')
c = conn.cursor()

# $ python sqlite.py drop
if len(sys.argv) > 1 and sys.argv[1] == "drop":
    print "drop tables"
    c.execute("DROP TABLE categories")
    c.execute("DROP TABLE questions")
    c.execute("DROP TABLE alternatives")


c.execute('''CREATE TABLE IF NOT EXISTS categories (id INTEGER PRIMARY KEY, category TEXT)''')
c.execute('''CREATE TABLE IF NOT EXISTS questions (id INTEGER PRIMARY KEY, type_question INTEGER, question TEXT, answer TEXT, category_id INTEGER REFERENCES category(id) )''')
c.execute('''CREATE TABLE IF NOT EXISTS alternatives (id INTEGER PRIMARY KEY, question_id INTEGER REFERENCES question(id), alternative TEXT, is_correct INTEGER)''')

categories_json = open('categories.json')
data = json.load(categories_json)
#insert categories
for cat in data:
   c.execute("INSERT OR IGNORE INTO categories VALUES (?, ?)", (cat["id"], cat["category"]))

#insert questions and alternatives
question_json = open('questions.json')
data = json.load(question_json)
for quest in data:
    c.execute("INSERT OR IGNORE INTO questions (id, type_question, question, answer, category_id) VALUES (?, ?, ?, ?, ?)", (quest["id"], quest["type_question"], quest["question"], quest["answer"], quest["id_category"]))

    for alternative in quest["alternatives"]:
        is_correct = 1 if alternative["is_correct"] else 0
        c.execute("INSERT OR IGNORE INTO alternatives (id, question_id, alternative, is_correct) VALUES (?, ?, ?, ?)", (alternative["id"], alternative["question_id"], alternative["alternative"], is_correct))


print "done"

conn.commit()
categories_json.close()
question_json.close()

#for a in c.execute("SELECT id, question, category_id, type_question, answer FROM questions"):
#    print a
