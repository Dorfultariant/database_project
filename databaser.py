## This program utilizes template python program given in the Week task Topic 6
import sqlite3 as sq
from datetime import datetime, timedelta

db = sq.connect("prokkis.db")
cur = db.cursor()
cur.execute("PRAGMA foreign_keys = ON;")

def initDB():
    try:
        f = open("sqlcmd.sql", "r")
        command = ""
        for l in f.readlines():
            command += l
        ##print("Creation successful")
        ##print(command)
        cur.executescript(command)
    
    except sq.OperationalError as x:
        print("DB exists, init skip", x)
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
    print()
    print("14) Input from sql file")

    print("Your selection: ", end="")
    userIn = input()
    
    return userIn


def insertBook():
    print("You want to insert book? Nice!")
    title =         input("Book name?: ")
    genres = set()
 
    genreInput = 1
    dbgenres = cur.execute("SELECT * FROM Genre")
    dbgenres = dbgenres.fetchall()

    while genreInput != "0":
        print()
        for c,i in enumerate(dbgenres):
            print(f"{c+1}:",i[1])
        print("To stop insert 0")
        genreInput = input("Insert genre number: ")
        if genreInput.isdigit() and int(genreInput) <= len(dbgenres) and int(genreInput) > 0:
            genreInput = int(genreInput)-1
            genres.add(dbgenres[genreInput][0])
        
            
        
    print(genres)
    isbn = input("ISBN?: ")
    if (len(isbn) != 10 and len(isbn) != 13):
        input("ISBN number was incorrect. Press enter to return menu.")
        return
    publishDate = input("publish date? MM/DD/YYYY: ")
    author_firstname = input("Author firstname: ")
    author_surname = input("Author surname: ")
    publisher = input("Publisher: ")
    

    cmd = f"SELECT * FROM Author WHERE author_firstname = '{author_firstname}' AND author_surname = '{author_surname}'"
    authorData = cur.execute(cmd)
    row = authorData.fetchone()
    if row != None:
        authorID = row[0]
        print("AuthorID:",authorID)
    else:
        print("Author is not in database.")
        nationality = input("Give nationality for author: ")
        cmd = f"INSERT INTO Author (author_firstname,author_surname,nationality) VALUES ('{author_firstname}','{author_surname}','{nationality}')"
        cur.execute(cmd)
        cur.execute(f"SELECT * from Author where author_firstname = '{author_firstname}' AND author_surname = '{author_surname}'")
        authorData = cur.fetchone()
        authorID = authorData[0]
        # print(cur.fetchone())

    
    cmd = f"SELECT * FROM Publisher WHERE publisher_name = '{publisher}'"
    publisherData = cur.execute(cmd)
    row = publisherData.fetchone()
    if row != None:
        publisherID = row[0]
        print("publisherID:",publisherID)
    else:
        print("Publisher is not in database.")
        print("Give adress for publisher: ",end="")
        address = input()
        print("Give e-mail for publisher: ",end="")
        email = input()
        cmd = f"INSERT INTO Publisher (publisher_name,address,email) VALUES ('{publisher}','{address}','{email}')"
        cur.execute(cmd)
        cur.execute(f"SELECT * from publisher where publisher_name = '{publisher}'")
        publisherData = cur.fetchone()
        publisherID = publisherData[0]

    print()
    cmd = f"INSERT INTO book (title, isbn, publish_date,fk_author_id,fk_publisher_id) VALUES ('{title}','{isbn}','{publishDate}',{authorID},{publisherID})"
    cur.execute(cmd)   
    cmd = f"SELECT * from book where title = '{title}'"
    addedData = cur.execute(cmd)
    addedData = addedData.fetchone()
    for i in genres:
        print("tulostetaan...",i)
        genreInsertcmd = f"INSERT INTO GenresOfBook (fk_book_id,fk_genre_id) VALUES ('{addedData[0]}',{i})"
        cur.execute(genreInsertcmd)
    if addedData:
        print("Following data is added to database.\n",addedData)
        db.commit()
    print()
    return


def insertMember():
    print("You are adding member to database.")
    memberFirstName = input("Insert first name: ")
    memberSurname = input("Insert surname: ")
    memberAddress = input("Insert home adress: ")
    memberPhoneNumber = input("Insert phone number: ")
    memberEmail = input("insert email: ")
    print()
    memberData = (memberFirstName,memberSurname,memberAddress,memberPhoneNumber,memberEmail)
    print("You are adding:")
    for i in memberData:
        print(i)
    if input("Is this correct? y/n").capitalize() == "Y":
        insertcmd = f"INSERT INTO Member (first_name,last_name,address,phone_number,email) VALUES ('{memberFirstName}','{memberSurname}','{memberAddress}','{memberPhoneNumber}','{memberEmail}')"
        testiinsertti = cur.execute(insertcmd)
        print("testiinsertti",testiinsertti.fetchall())
        cmd = f"SELECT first_name,last_name,address,phone_number,email FROM Member WHERE first_name = '{memberFirstName}' and last_name = '{memberSurname}' and address = '{memberAddress}' and phone_number = '{memberPhoneNumber}' and email = '{memberEmail}'"
        insertedData = cur.execute(cmd)
        row = insertedData.fetchone()

        if memberData == row:   #tests that information is inserted correctly to members
            db.commit()
            print("Member inserted to database!")
        else:
            print("Something went wrong inputting member to database. Rollback.")
            db.rollback()
    else:
        print("Returning back to menu.")
        
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


def returnBook(*args):
    loan_ids = []
    returnLoan = False
    splitted = []
    
    if len(args) == 0:
        listTableContent("5")
        userIn = input("Which user is returning the book (give member_id): ")
        cmd = f"select * from member where member_id = ?;"
        cur.execute(cmd, (userIn,))
        user = cur.fetchone()
        if not user:
            print("User not found. Abort!")
            return
        user_id = user[0]
        print()


        cmd = 'select * from Loan_view where "Member id" = ?;'
        cur.execute(cmd, (user_id,))
        rows = cur.fetchall()

        cols = [c[0] for c in cur.description]
        col_width = [9, 9, 10, 10, 9, 50]
        head = " | ".join(n.ljust(w) for n, w in zip(cols, col_width))
        print(head)
        for r in rows:
            print(" | ".join(str(item).ljust(w) for item, w in zip(r, col_width)))
        print()
        
        userIn = input("Return books by 'Book id' or 'a, Loan id' for all in loan (0 or enter to exit): ")
        splitted = [i.strip() for i in userIn.split(",")]

        if "0" in splitted or '' in splitted:
            return
        if len(splitted) < 1:
            return
    else:
        user_id = args[0]
        returnLoan = True
        cmd = "select loan_id from Loan where fk_member_id = ?;"
        cur.execute(cmd, (user_id,))
        res = cur.fetchall()
        #print(res)
        for r in res:
            loan_ids.append(r[0])
        print(loan_ids)


    books_to_return = []
    for com in splitted:
        if returnLoan:
            loan_ids.append(int(com))

        if com == "a":
            returnLoan = True
            continue
        else:
            books_to_return.append(int(com))

    
    if not returnLoan:
        for book_id in books_to_return:
            try:
                cmd = "update Book set loan_status = 0 where book_id = ?;"
                cur.execute(cmd, (book_id,))
                cmd = "delete from BooksInLoan where fk_book_id = ?;"
                cur.execute(cmd, (book_id,))
            except sq.OperationalError as e:
                print("Could not return books")
                print(e)
                return              
        db.commit()
        return

    for loan_id in loan_ids:
        try:
            cmd = "select fk_book_id from BooksInLoan where fk_loan_id = ?;"
            cur.execute(cmd,(loan_id,))
            book_ids = cur.fetchall()
            for i in book_ids:
                cmd = "update Book set loan_status = 0 where book_id = ?;"
                cur.execute(cmd, i)
            
            cmd = "delete from BooksInLoan where fk_loan_id = ?;"
            cur.execute(cmd, (loan_id,))
            cmd = "delete from Loan where loan_id = ?;"
            cur.execute(cmd, (loan_id,))
            db.commit()

        except sq.OperationalError as e:
            print("Could not return loan")
            print(e)
            
    return


def removeBook():
    print()
    searchParameter = input("Search parameter for deleting book: ")
    bookcmd = f"SELECT * FROM Book WHERE title LIKE '%{searchParameter}%'"
    books = cur.execute(bookcmd)
    for book in books:
        print(book)
    print()
    bookID = input("Give book id you want to delete: ")
    if bookID == "":
        print("Returning to menu.")
        return
    book = cur.execute(f"SELECT title from Book WHERE book_id = {bookID}").fetchone()
    userIn = input(f"Are you sure you want to delete {book} ")
    if userIn.capitalize() == "Y":
        cmd = f"DELETE FROM Book WHERE book_id = {bookID}"
        returnBook(bookID)
        cur.execute(cmd)
        print("Book deleted!")
        db.commit()
    else:
        db.rollback()
    return


def removeMember():
    print()
    searchParameter = input("Give surname you want to search: ")
    userscmd = f"SELECT * FROM Member WHERE last_name LIKE '%{searchParameter}%'"
    users = cur.execute(userscmd)
    for user in users.fetchall():
        print(user)
    print()
    userID = input("Give user id you want to delete: ")
    if userID == "":
        print("Returning to menu.")
        return
    user = cur.execute(f"SELECT first_name,last_name from Member WHERE member_id = {userID}").fetchone()
    userIn = input(f"Are you sure you want to delete {user} ")
    if userIn.capitalize() == "Y":
        cmd = f"DELETE FROM Member WHERE member_id = {userID}"
        cur.execute(cmd)
        print("User deleted!")
        returnBook(userID)
        print("User books returned.")
        db.commit()
    else:
        db.rollback()
        
    return


def listTableContent(userIn):
    if (userIn == "1"):
        cmd = "SELECT * FROM Book;"
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
    db.row_factory = sq.Row
    cur2 = db.cursor()
    print()
    print()
    types = {"0":"title","1":"genre","2":"publisher","3":"released","4":"loaned"}
    userIn1 = "11"
    while userIn1 not in types.keys():
        for c,i in enumerate(types):
            print(f"{c}: {types[i]}")
        userIn1 = input("Search parameter: ")
    userIn1 = types[userIn1]
    print()
    tempList = set()
    if userIn1 not in ["title","loaned"]:
        for i in cur2.execute(f"SELECT {userIn1} from BooksByTitle").fetchall():
            i = i[0]
            i = i.split(",")
            for j in i:
                tempList.add(j)
        for i in tempList:
            print(i)
        userIn2 = input(f"Following {userIn1} are available. Type in search keyword: ")
    elif userIn1 == "loaned":
        userIn2 = "1"
    else:
        userIn2 = input("Give search word: ")
    booksByTitle = cur2.execute(f"Select * from BooksByTitle where {userIn1} like '%{userIn2}%'").fetchall()
    print()
    print("|{:30} |{:24} |{:20} |{:15} |{:>10} |{:6} |\n{:s}".format("Title","Genre","Author","Publisher","Released","Loaned","-"*118))
    for j in booksByTitle:
        print("|{:30} |{:24} |{:20} |{:15} |{:>10} |{:6} |".format(j["Title"][:30],j["Genre"][:24],j["Author"][:20],j["Publisher"],j["Released"][:10].replace("/","."),j["Loaned"]))
    return

def inputFromSQL():
    fName = input("Give sql filename: ")
    try:
        f = open(fName, "r")
        command = ""
        addedData = []
        for l in f.readlines():
            command += l
            if command.endswith(";\n") or command.endswith(";"):
                cur.execute(command)
                addedData.append(command)
                command = ""

    except sq.OperationalError as x:
        print(x)
        db.rollback()
    except sq.DatabaseError as x:
        print(x)
        db.rollback()
    except sq.Error as x:
        print("Oh no! .sql not found.. or something else is off",x)
        db.rollback()
    except:
        print("something went wrong. Rolling back.")
        db.rollback()
    print("This data is inputted.")
    for i in addedData:
        print(i,end="")
    print()
    if input("Are you sure you wanto to save this data? y/n: ").capitalize() == "Y":
        db.commit()
        print("Data saved to database.")
    else:
        print("Data roll backed.")
        db.rollback()
    return


def deleteAuthor(): #69
    print(cur.execute("SELECT * FROM booksinloan").fetchall())
    cmd = f"DELETE FROM author WHERE author_id = 4000"
    cur.execute(cmd)
    print(cur.execute("SELECT * FROM booksinloan").fetchall())
    # db.commit()
    return

def main():
    initDB()

    userIn = -1
    while(userIn != "0"):
        userIn = menu() 
        ## List Books, Authors, Publishers, Genres, Members 
        if   (userIn in ["1", "2", "3","4","5"]):
            listTableContent(userIn) 

        elif (userIn == "6"):
            listLoans()

        elif (userIn == "7"):
            findBooks()
        
        elif (userIn == "8"):
            insertBook()
        
        elif (userIn == "9"):
            insertMember()
        
        elif (userIn == "10"):
            loanBook()

        elif (userIn == "11"):
            returnBook()

        elif (userIn == "12"):
            removeBook()

        elif (userIn == "13"):
            removeMember()
            
        elif (userIn == "14"):
            inputFromSQL()
            
        elif (userIn == "69"):
            deleteAuthor()

        elif (userIn == "0"):
            continue
        
        else:
            print("Try again.")
                
        input("Press enter to continue")
    
    db.close()
    print()
    print("Kiitos Ohjelman Käytöstä!")
    return 0

main()
