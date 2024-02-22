## This program utilizes template python program given in the Week task Topic 6
import sqlite3 as sq
from datetime import datetime, timedelta
import os

db = sq.connect("prokkis.db")
cur = db.cursor()
cur.execute("PRAGMA foreign_keys = ON;")
 
def initDB():
    try:
        f = open("sqlcmd.sql", "r")
        command = ""
        for l in f.readlines():
            command += l
        cur.executescript(command)

    except FileNotFoundError:
        print("sqlcmd.sql file not found. Abort!")
        print("Include sqlcmd.sql file in the same folder as databaser.py")
        return False

    except sq.Error as e:
        print("DB exists, hopefully...")
        print(e)

    return True


def menu():
    print()
    print("##### MENU OPTIONS #####")
    print("1) List Tables")
    print("2) Modify Member")
    print("3) Modify Book")
    print()
    print("4) List Member Loans")
    print("5) Find Books")
    print()
    print("6) Insert Book")
    print("7) Insert Member")
    print()
    print("8) Loan Book")
    print("9) Return Book")
    print()
    print("10) Remove Book")
    print("11) Remove Member")
    print()
    print("12) Input from sql file")

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


def findByID(table, target):
    printTable(table)
    userIn = input(f"Give {table} ID: ")

    cmd = f"SELECT * FROM {table} WHERE {target} = ?;"
    cur.execute(cmd, (userIn,))
    row = cur.fetchone()
    if not row:
        print("Data not found. Abort!")
        return False
    row_id = row[0]
    print()
    return row_id


def listLoans():
    print()
    print("##### LOANS #####")
    print()
    user_id = findByID("Member", "member_id")
    if not user_id: return False
    cmd = """SELECT * FROM LoanView WHERE "Member id" = ?;"""
    cur.execute(cmd, (user_id,))
    printTable()
    
    return True


def loanBook():
    user_id = findByID("Member", "member_id")
    if not user_id: return False
    cmd = """SELECT * FROM BooksByTitle WHERE "Loaned" = 0;"""
    print("Available books:")
    cur.execute(cmd)
    printTable()
    
    loan_date = datetime.now().strftime("%m/%d/%Y")
    due_date = (datetime.now() + timedelta(days = 14)).strftime("%m/%d/%Y")
    
    cmd = f"INSERT INTO loan (loan_date, due_date, fk_member_id) VALUES ('{loan_date}','{due_date}','{user_id}');"
    cur.execute(cmd)
    last_loan_id = cur.lastrowid

    bookIn = input("Loan Book by Title (0 or enter to exit): ")
    while (bookIn != "0" and bookIn != ""):
        cmd = f"SELECT * FROM Book WHERE title = ? AND is_loaned = 0;"
        cur.execute(cmd, (bookIn,))
        book = cur.fetchone()
        if book:
            book_id = book[0]
            cmd = f"INSERT INTO booksinloan (fk_book_id, fk_loan_id) VALUES ({book_id}, {last_loan_id});"
            cur.execute(cmd)
            cmd = f"UPDATE Book SET is_loaned = 1 WHERE book_id = {book_id};"
            cur.execute(cmd)
            db.commit()
            print("Loan Complete")
        else:
            print("Could not loan book, try again")
        bookIn = input("Loan Book by Title (0 or enter to exit): ")
    return


### Prints Formatted Table or View ###
# Param = Optional, or table name as string
# Counts max column width and dynamically sizes the table
# Returns None
## Helpful link: https://stackoverflow.com/questions/9989334/create-nice-column-output-in-python
def printTable(*args):
    if len(args):
        cmd = f"SELECT * FROM {args[0]};"
        cur.execute(cmd)
    
    cols = [c[0] for c in cur.description]
    rows = cur.fetchall()

    col_widths = [
        max(len(str(value)) for value in col)
        for col in zip(*rows, cols) ]
    
    print()
    head = " | ".join(n.ljust(w) for n, w in zip(cols, col_widths))
    print(head)

    for r in rows:
        print(" | ".join(str(item).ljust(w) for item, w in zip(r, col_widths)))
    print()
    return


def returnBooksOrLoans(*args):
    loan_ids = []
    returnLoan = False
    splitted = []
    
    if not len(args):
        user_id = findByID("Member", "member_id")
        if not user_id: return False
        cmd = 'SELECT * FROM LoanView WHERE "Member id" = ?;'
        cur.execute(cmd, (user_id,))
        printTable()
    
        userIn = input("Return books by 'Book id' or 'a, Loan id' for all in loan (0 or enter to exit): ")
        ## Parse user input
        for i in userIn.split(','):
            splitted.append(i.strip())
        # if user pressed enter or 0 -> make exit
        if "0" in splitted or '' in splitted or not len(splitted):
            return False

    else:
        user_id = args[0]
        returnLoan = True
        cmd = "SELECT loan_id FROM Loan WHERE fk_member_id = ?;"
        cur.execute(cmd, (user_id,))
        res = cur.fetchall()
    
        for r in res:
            loan_ids.append(r[0])
        print(loan_ids)


    books_to_return = []
    # This is separating loan ids to be returned
    for com in splitted:
        if returnLoan:
            loan_ids.append(int(com))
        if com == "a":
            returnLoan = True
            continue
        else:
            books_to_return.append(int(com))

    if not returnLoan and not returnSingleBooks(books_to_return):
        return False
    if not returnLoans(loan_ids):
        return False

    print("Books returned!")
    print()
    return True


def returnSingleBooks(book_ids):
    for book_id in book_ids:
        try:
            cmd = "UPDATE Book SET is_loaned = 0 WHERE book_id = ?;"
            cur.execute(cmd, (book_id,))
            cmd = "DELETE FROM BooksInLoan WHERE fk_book_id = ?;"
            cur.execute(cmd, (book_id,))
        except sq.OperationalError as e:
            print("Could not return books")
            print(e)
            return False      
        db.commit()
    
    return True
    

def returnLoans(loan_ids):
    for loan_id in loan_ids:
        try:
            cmd = "SELECT fk_book_id FROM BooksInLoan WHERE fk_loan_id = ?;"
            cur.execute(cmd,(loan_id,))
            book_ids = cur.fetchall()
            for i in book_ids:
                cmd = "UPDATE Book SET is_loaned = 0 WHERE book_id = ?;"
                cur.execute(cmd, i)
            
            cmd = "DELETE FROM BooksInLoan WHERE fk_loan_id = ?;"
            cur.execute(cmd, (loan_id,))
            cmd = "DELETE FROM Loan WHERE loan_id = ?;"
            cur.execute(cmd, (loan_id,))
            db.commit()

        except sq.OperationalError as e:
            print("Could not return loan")
            print(e)
            return False
    return True


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
        returnBooksOrLoans(bookID)
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
    if userID == "" or not userID.isnumeric():
        print("Returning to menu.")
        return

    user = cur.execute(f"SELECT first_name,last_name from Member WHERE member_id = {userID}").fetchone()
    userIn = input(f"Are you sure you want to delete {user} ")
    if userIn.capitalize() == "Y":
        if returnBooksOrLoans(userID):
            cmd = f"DELETE FROM Member WHERE member_id = {userID}"
            cur.execute(cmd)
            print("User deleted!")
            print("User books returned.")
            db.commit()
        else:
            print("Could not delete user. Abort!")
    else:
        db.rollback()
        
    return


def listTableContent():
    print()
    print("1: List Books")
    print("2: List Authors")
    print("3: List Publishers")
    print("4: List Genres")
    print("5: List Members")
    userIn = input("Option (0 or enter to exit): ")
    if userIn == "" or userIn == "0": return
    if (userIn == "1"):
        printTable("Book")
    elif (userIn == "2"):
        printTable("Author")
    elif (userIn == "3"):
        printTable("Publisher")
    elif (userIn == "4"):
        printTable("Genre")
    elif (userIn == "5"):
        printTable("Member")
    else:
        print("Invalid input,")
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


def modifyMember():
    cmd = ""
    opt = "-1"
    user_id = findByID("Member", "member_id")
    if not user_id: return False
    while (opt != "0" or opt != ""):
        print("1: First name")
        print("2: Last name")
        print("3: Address")
        print("4: Phone number")
        print("5: Email")
        opt = input("What to modify (0 or enter to exit): ")
        if opt == "" or opt == "0": return
        if opt == "1":
            cmd = "UPDATE Member SET first_name = ? WHERE member_id = ?;"
        elif opt == "2":
            cmd = "UPDATE Member SET last_name = ? WHERE member_id = ?;"
        elif opt == "3":
            cmd = "UPDATE Member SET address = ? WHERE member_id = ?;"
        elif opt == "4":
            cmd = "UPDATE Member SET phone_number = ? WHERE member_id = ?;"
        elif opt == "5":
            cmd = "UPDATE Member SET email = ? WHERE member_id = ?;"
        newData = input("New value: ")
        try:
            cur.execute(cmd, (newData,user_id))
        
        except sq.OperationalError as e:
            print("Could not modify data. Abort!")
            print(e)
            return False
        except sq.DatabaseError as e:
            print("Could not modify data. Abort!")
            print(e)
            return False
        db.commit()
        printTable("Member")
        print("Member information updated!")
        print()
    return True


def modifyBook():
    cmd = ""
    opt = "-1"
    user_id = findByID("Book", "book_id")
    if not user_id: return False
    while (opt != "0" or opt != ""):
        print("1: Title")
        print("2: ISBN")
        print("3: Publish Date")
        opt = input("What to modify (0 or enter to exit): ")
        if opt == "" or opt == "0": return
        if opt == "1":
            cmd = "UPDATE Book SET title = ? WHERE book_id = ?;"
        elif opt == "2":
            cmd = "UPDATE Book SET isbn = ? WHERE book_id = ?;"
        elif opt == "3":
            cmd = "UPDATE Book SET publish_date = ? WHERE book_id = ?;"
    
        newData = input("New value: ")
        try:
            cur.execute(cmd, (newData,user_id))
        
        except sq.OperationalError as e:
            print("Could not modify data. Abort!")
            print(e)
            return False
        except sq.DatabaseError as e:
            print("Could not modify data. Abort!")
            print(e)
            return False
        db.commit()
        printTable("Book")
        print("Book information updated!")
    return True


def main():
    if not os.path.isfile("prokkis.db"):
        if not initDB(): return -1

    userIn = -1
    while(userIn != "0"):
        userIn = menu() 
        ## List Books, Authors, Publishers, Genres, Members 
        if   (userIn == "1"):
            listTableContent()
        elif (userIn == "2"):
            modifyMember()
        elif (userIn == "3"):
            modifyBook()
        elif (userIn == "4"):
            listLoans()
        elif (userIn == "5"):
            findBooks()
        elif (userIn == "6"):
            insertBook()
        elif (userIn == "7"):
            insertMember()
        elif (userIn == "8"):
            loanBook()
        elif (userIn == "9"):
            returnBooksOrLoans()
        elif (userIn == "10"):
            removeBook()
        elif (userIn == "11"):
            removeMember()
        elif (userIn == "12"):
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
