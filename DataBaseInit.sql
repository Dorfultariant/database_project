create table Member (
        MemberID INTEGER PRIMARY KEY NOT NULL,
        FirstName VARCHAR(20) NOT NULL,
        LastName VARCHAR(20) NOT NULL,
        Address VARCHAR(50) NOT NULL,
        PhoneNumber VARCHAR(10) UNIQUE NOT NULL,
        Email VARCHAR(50) UNIQUE
);

create table Loan (
        LoanID INTEGER PRIMARY KEY NOT NULL,
        LoanDate VARCHAR(12) NOT NULL,
        DueDate VARCHAR(12) NOT NULL,
        ReturnDate VARCHAR(12),
        FKMemberID INTEGER NOT NULL,
        FOREIGN KEY (FKMemberID) REFERENCES Member(MemberID) ON DELETE CASCADE
);

create table Book (
        BookID INTEGER PRIMARY KEY NOT NULL,
        Title VARCHAR(50) NOT NULL,
        ISBN VARCHAR(13) NOT NULL CHECK(LENGTH(ISBN) IN (10, 13)),
        PublishDate VARCHAR(12),
        IsLoaned BOOL NOT NULL DEFAULT FALSE,
        FKAuthorID INTEGER,
        FKPublisherID INTEGER,
        FOREIGN KEY (FKAuthorID) REFERENCES Author(AuthorID) ON DELETE SET NULL,
        FOREIGN KEY (FKPublisherID) REFERENCES Publisher(PublisherID) ON DELETE SET NULL
);

create table BooksInLoan (
        FKBookID INTEGER NOT NULL,
        FKLoanID INTEGER NOT NULL,
        FOREIGN KEY (FKBookID) REFERENCES Book(BookID) ON DELETE CASCADE,
        FOREIGN KEY (FKLoanID) REFERENCES Loan(LoanID) ON DELETE CASCADE
);

create table Genre (
        GenreID INTEGER PRIMARY KEY NOT NULL,
        GenreName VARCHAR(20) NOT NULL UNIQUE
);

create table GenresOfBook (
        FKBookID INTEGER NOT NULL,
        FKGenreID INTEGER NOT NULL,
        FOREIGN KEY (FKBookID) REFERENCES Book(BookID) ON DELETE CASCADE,
        FOREIGN KEY (FKGenreID) REFERENCES Genre(GenreID) ON DELETE CASCADE
);

create table Author (
        AuthorID INTEGER PRIMARY KEY NOT NULL,
        AuthorFirstName VARCHAR(20),
        AuthorLastName VARCHAR(20),
        Nationality VARCHAR(15)
);

create table Publisher (
        PublisherID INTEGER PRIMARY KEY NOT NULL,
        PublisherName VARCHAR(20) UNIQUE,
        Address VARCHAR(50),
        Email VARCHAR(50) UNIQUE
);

create view LoanView as
        select Member.MemberID as "Member id",
        Loan.LoanID as "Loan id",
        Loan.LoanDate as "Loan Date",
        Loan.DueDate as "Due Date",
        Book.BookID as "Book id",
        Book.Title as "Book Title"
        from Loan
        join Member on Loan.FKMemberID = Member.MemberID
        join BooksInLoan on BooksInLoan.FKLoanID = Loan.LoanID
        join Book on Book.BookID = BooksInLoan.FKBookID;

create view BooksByTitle as
        select book.Title as "Title",
        group_concat(Genre.GenreName,",") as "Genre",
        author.AuthorFirstName || " " || author.AuthorLastName as "Author",
        publisher.PublisherName as "Publisher",
        book.PublishDate as "Released",
        book.IsLoaned as "Loaned"
        from book
        left join author on author.AuthorID = book.FKAuthorID
        left join publisher on publisher.PublisherID = book.FKPublisherID
        left join GenresOfBook on GenresOfBook.FKBookID = book.BookID
        left join genre on genre.GenreID = GenresOfBook.FKGenreID
        group By book.Title
        order by book.title;

-- MemberID is used often to find target members
CREATE INDEX MemberIDX ON Member(MemberID);
CREATE INDEX FKMemberIDX ON Loan(FKMemberID);
-- Book id is used a lot for targeting books
CREATE INDEX BookIDX ON Book(BookID);

