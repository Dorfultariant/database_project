## This program utilizes template python program given in the Week task Topic 6
import sqlite3 as sq
from datetime import datetime, timedelta

db = sq.connect("prokkis.db")
cur = db.cursor()

def initDB():
    try:
        f = open("sqlcmd.sql", "r")
        command = ""
        for l in f.readlines():
            command += l
        ##print("Creation successful")
        ##print(command)
        cur.executescript(command)


    except sq.OperationalError:
        print("DB exists, init skip")
    except:
        print("Oh no! .sql not found.. or something else is off")
    return



def menu():
    print()
    print("##### MENU OPTIONS #####")
    print("1) List Books")
    print("2) List Authors")
    print("3) List Publishers")
    print("4) List Genres")
    print("5) List Members")
    print()
    print("6) List Member Loans")
    print("7) Find Books")
    print()
    print("8) Insert Book")
    print("9) Insert Member")
    print()
    print("10) Loan Book")
    print("11) Return Book")
    print()
    print("12) Remove Book")
    print("13) Remove Member")
    
    print("Your selection: ", end="")
    userIn = input()
    
    return userIn


def insertBook():
    return


def insertMember():
    return

def listLoans():
    print()
    print("#### LOANS ####")
    print()
    cmd = "select * from member;"
    cur.execute(cmd)
    for m in cur.fetchall():
        print(m)
    userIn = input("Which users' loans you want to see (insert member_id): ")
    cmd = f"select * from member where member_id like '%{userIn}%';"
    cur.execute(cmd)
    user = cur.fetchone()
    if not user:
        print("User not found. Abort!")
        return
    user_id = user[0]
    cmd = f"""select Member.first_name, Member.last_name, Loan.loan_date, Loan.due_date, GROUP_CONCAT(Book.title)
                from Member
                join Loan on Member.member_id = Loan.fk_member_id
                join BooksInLoan on Loan.loan_id = BooksInLoan.fk_loan_id
                join Book on BooksInLoan.fk_book_id = Book.book_id
                where Member.member_id = {user_id}
                group by Loan.loan_id;"""
    cur.execute(cmd)
    for l in cur.fetchall():
        print(l)

    return


def loanBook():

    cmd = "select * from member;"
    cur.execute(cmd)
    for m in cur.fetchall():
        print(m)

    userIn = input("Which user is loaning the book (give member_id): ")
    cmd = f"select * from member where member_id like '%{userIn}%';"
    cur.execute(cmd)
    user = cur.fetchone()
    if not user:
        print("User not found. Abort!")
        return
    user_id = user[0]

    cmd = """select Book.title, Author.author_firstname, Author.author_surname, Publisher.publisher_name 
             from Book 
             join Author on Book.fk_author_id = Author.author_id 
             join Publisher on Book.fk_publisher_id = Publisher.publisher_id 
             where Book.loan_status = 0;""" 
    print("Available books:")
    cur.execute(cmd)

    for book in cur.fetchall():
        print(book)
    
    book_id = None

    loan_date = datetime.now().strftime("%m/%d/%Y")
    due_date = (datetime.now() + timedelta(days = 14)).strftime("%m/%d/%Y")
    
    cmd = f"insert into loan (loan_date, due_date, fk_member_id) values ('{loan_date}','{due_date}','{user_id}');"
    cur.execute(cmd)
    last_loan_id = cur.lastrowid

    bookIn = input("Which book would you like to loan (end transaction with 0): ")
    while (bookIn != "0"):

        cmd = f"select * from Book where title like '%{bookIn}%' and loan_status = 0;"
    
        cur.execute(cmd)
        book = cur.fetchone()
        
        if book:
            book_id = book[0]
            cmd = f"insert into booksinloan (fk_book_id, fk_loan_id) values ({book_id}, {last_loan_id});"
            cur.execute(cmd)
            cmd = f"update Book set loan_status = 1 where book_id = {book_id};"
            cur.execute(cmd)
            db.commit()
            print("Loan Complete")
        else:
            print("Could not loan book, try again")
        bookIn = input("Which book would you like to loan (end transaction with 0): ")

    return

def returnBook():
    return


def removeBook():
    return


def removeMember():
    return


def listTableContent(userIn):
    print("Data found:")
    if userIn == "1":
        cmd = "SELECT * FROM Book"
    elif (userIn == "2"):
        cmd = "SELECT * FROM Author;"
    elif (userIn == "3"):
        cmd = "SELECT * FROM Publisher;"
    elif (userIn == "4"):
        cmd = "SELECT * FROM Genre;"
    elif (userIn == "5"):
        cmd = "SELECT * FROM Member;"
    cur.execute(cmd)
    for row in cur.fetchall():
        print(row)
    return


def findBooks():
    print()
    print("1: Title")
    print("2: Genre")
    print("3: Author")
    print("4: Publisher")
    print("Select filter: ", end="")
    opt = input()
    print("Give search term: ", end="")
    sterm = input()
    cmd = ""
    if (opt == "1"):
        cmd = ""
    elif (opt == "2"):
        print(sterm, "2")
    else:
        print("Could not find books with given parameters.")
        return
    sq.execute(cmd)
    return



def main():
    initDB()

    userIn = -1
    while(userIn != "0"):
        userIn = menu()
        if (userIn in ["1", "2", "3","4","5"]):
            listTableContent(userIn) 
        elif (userIn == "6"):
            listLoans()
        elif (userIn == "7"):
            findBooks()
        elif (userIn == "8"):
            print("Seppo")
        elif (userIn == "10"):
            loanBook()
        elif (userIn == "0"):
            print("Kiitos Ohjelman Käytöstä!")
        else:
            print("Try again.")
                
        print()
        
    db.close()

    return

main()

