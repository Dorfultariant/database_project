import sqlite3 as sq
db = sq.connect("prokkis.db")
cur = db.cursor()

def initDB():
    try:
        f = open("sqlcmd.sql", "r")
        command = ""
        for l in f.readlines():
            command += l

        cur.executescript(command)
    except sq.OperationalError:
        print("DB exists, init skip")
    except:
        print("Oh no! .sql not found.")

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
    print("You want to insert book? Nice!")
    title =         input("Book name?: ")
    isbn =          input("ISBN?: ")
    publishDate =   input("publish date? MM/DD/YYYY: ")
    author =        input("Author? (firstname surname): ")
    publisher =     input("Publisher: ")

    if (len(isbn) != 10 and len(isbn) != 13):
        input("ISBN number was incorrect. Press enter to continue")
        return
    
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
        print(cur.fetchone())

    print()
    author_id = 123124141341234134
    cmd = f"INSERT INTO book (title, isbn, publish_date,fk_author_id,fk_publisher_id) VALUES ('{title}','{isbn}','{publishDate}',{author_id},{publisherID})"
    cur.execute(cmd)   
    cmd = f"SELECT * from book where title = '{title}'"
    addedData = cur.execute(cmd)
    if addedData:
        print("Following data is added to database.\n",addedData.fetchone())
        db.commit()
    print()
    return


def insertMember():
    return


def loanBook():
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


def listMemberLoans():
    cmd = ""

    cur.execute(cmd)


    return


def main():
    initDB()

    userIn = -1
    while(userIn != "0"):
        userIn = menu()
        if (userIn in ["1", "2", "3","4","5"]):
            listTableContent(userIn) 
        elif (userIn == "6"):
            listMemberLoans()
        elif (userIn == "7"):
            findBooks()
        elif (userIn == "8"):
            insertBook()
        elif (userIn == "0"):
            print("Kiitos Ohjelman Käytöstä!")
        else:
            print("Try again.")
                
        input("Press enter to continue")

    return 0

main()

