create table Member (
        MemberID INTEGER PRIMARY KEY NOT NULL,
        FirstName VARCHAR(10) NOT NULL,
        LastName VARCHAR(15) NOT NULL,
        Address VARCHAR(30) NOT NULL,
        PhoneNumber VARCHAR(10) UNIQUE NOT NULL,
        Email VARCHAR(25) UNIQUE
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
        Title VARCHAR(20) NOT NULL,
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
        AuthorFirstName VARCHAR(10),
        AuthorLastName VARCHAR(15),
        Nationality VARCHAR(15)
);

create table Publisher (
        PublisherID INTEGER PRIMARY KEY NOT NULL,
        PublisherName VARCHAR(20) UNIQUE,
        Address VARCHAR(30),
        Email VARCHAR(25) UNIQUE
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

insert into Member (MemberID, FirstName, LastName, Address, PhoneNumber, Email) values (1000,'Land', 'Witling'      , '88 Gulseth Hill'     , '962-756-5469'        , 'lwitling0@webs.com'                  );
insert into Member (MemberID, FirstName, LastName, Address, PhoneNumber, Email) values (1001,'Claudian', 'Runciman' , '0562 Quincy Park'    , '795-238-0413'        , 'crunciman1@meetup.com'               );
insert into Member (MemberID, FirstName, LastName, Address, PhoneNumber, Email) values (1002,'Mair', 'Wolfarth'     , '460 Johnson Park'    , '597-488-0051'        , 'mwolfarth2@network.org'   );
insert into Member (MemberID, FirstName, LastName, Address, PhoneNumber, Email) values (1003,'Tildi', 'Mechell'     , '3 Fuller Point', '794-466-0234'              , 'tmechell3@berkeley.edu');
insert into Member (MemberID, FirstName, LastName, Address, PhoneNumber, Email) values (1004,'Paulette', 'Cleugh'   , '288 Glacier Hill Park', '894-248-7363'       , 'pcleugh4@examiner.com');
insert into Member (MemberID, FirstName, LastName, Address, PhoneNumber, Email) values (1005,'Merrile', 'McDunlevy' , '9746 Bellgrove Avenue', '687-335-0735'       , 'mmcdunlevy5@flavors.me');
insert into Member (MemberID, FirstName, LastName, Address, PhoneNumber, Email) values (1006,'Welch', 'Newsham'     , '04 Gina Parkway', '874-919-3047'             , 'wnewsham6@tinyurl.com');
insert into Member (MemberID, FirstName, LastName, Address, PhoneNumber, Email) values (1007,'Travers', 'Lemerle'   , '4 Garrison Trail', '842-761-3997'            , 'tlemerle7@google.de');
insert into Member (MemberID, FirstName, LastName, Address, PhoneNumber, Email) values (1008,'Booth', 'Vickress'    , '22363 American Court', '388-446-1641'        , 'bvickress8@instagram.com');
insert into Member (MemberID, FirstName, LastName, Address, PhoneNumber, Email) values (1009,'Jaime', 'Giorgiutti'  , '541 Ronald Regan Drive', '790-945-5224'      , 'jgiorgiutti9@live.com');
insert into Member (MemberID, FirstName, LastName, Address, PhoneNumber, Email) values (1010,'Tod', 'Jacox'         , '85 Corry Junction', '886-669-3327'           , 'tjacoxa@linkedin.com');
insert into Member (MemberID, FirstName, LastName, Address, PhoneNumber, Email) values (1011,'Vonni', 'Scola'       , '5206 Emmet Park', '553-152-2523'             , 'vscolab@npr.org');
insert into Member (MemberID, FirstName, LastName, Address, PhoneNumber, Email) values (1012,'Romona', 'Axe'        , '793 Dapin Place', '559-431-6500'             , 'raxec@drupal.org');
insert into Member (MemberID, FirstName, LastName, Address, PhoneNumber, Email) values (1013,'Dal', 'Borgnet'       , '776 Westerfield Court', '787-794-8796'       , 'dborgnetd@ebay.com');
insert into Member (MemberID, FirstName, LastName, Address, PhoneNumber, Email) values (1014,'Janella', 'Wattingham', '6 Old Shore Trail', '108-611-8564'           , 'jwattinghame@amazon.com');
insert into Member (MemberID, FirstName, LastName, Address, PhoneNumber, Email) values (1015,'Tobiah', 'Everett'    , '9 Summerview Drive', '567-952-0538'          , 'teverettf@craigslist.org');
insert into Member (MemberID, FirstName, LastName, Address, PhoneNumber, Email) values (1016,'Minda', 'Gerok'       , '10 Pankratz Alley', '353-260-9110'           , 'mgerokg@gov.uk');
insert into Member (MemberID, FirstName, LastName, Address, PhoneNumber, Email) values (1017,'Gardiner', 'Welband'  , '492 Eagle Crest Way', '464-855-7728'         , 'gw@networksolutions.com');
insert into Member (MemberID, FirstName, LastName, Address, PhoneNumber, Email) values (1018,'Zachery', 'Percifull' , '00 Acker Court', '367-337-4336'              , 'zpercifulli@army.mil');
insert into Member (MemberID, FirstName, LastName, Address, PhoneNumber, Email) values (1019,'Alyse', 'Cornfoot'    , '0 Northview Center', '648-288-6657'          , 'acornfootj@buzzfeed.com');

insert into Genre (GenreID, GenreName) values (3000   ,'Comedy');
insert into Genre (GenreID, GenreName) values (3001   ,'Action');
insert into Genre (GenreID, GenreName) values (3002   ,'Drama');
insert into Genre (GenreID, GenreName) values (3003   ,'Mystery');
insert into Genre (GenreID, GenreName) values (3004   ,'Thriller');
insert into Genre (GenreID, GenreName) values (3005   ,'Documentary');
insert into Genre (GenreID, GenreName) values (3006   ,'War');
insert into Genre (GenreID, GenreName) values (3007   ,'Romance');
insert into Genre (GenreID, GenreName) values (3008   ,'Adventure');
insert into Genre (GenreID, GenreName) values (3009   ,'Horror');

insert into Author (AuthorID, AuthorFirstName, AuthorLastName, Nationality) values (4000, 'Celinda', 'Challicombe'    , 'Norway');
insert into Author (AuthorID, AuthorFirstName, AuthorLastName, Nationality) values (4001, 'Darsie', 'Caldero'         , 'Spain');
insert into Author (AuthorID, AuthorFirstName, AuthorLastName, Nationality) values (4002, 'Alverta', 'Jessopp'        , 'Colombia');
insert into Author (AuthorID, AuthorFirstName, AuthorLastName, Nationality) values (4003, 'Florette', 'Timewell'      , 'Prussia');
insert into Author (AuthorID, AuthorFirstName, AuthorLastName, Nationality) values (4004, 'Finn', 'Chapelle'          , 'New Zealand');
insert into Author (AuthorID, AuthorFirstName, AuthorLastName, Nationality) values (4005, 'Evaleen', 'Denington'      , 'United Kingdom');
insert into Author (AuthorID, AuthorFirstName, AuthorLastName, Nationality) values (4006, 'Der', 'Gilford'            , 'Germany');
insert into Author (AuthorID, AuthorFirstName, AuthorLastName, Nationality) values (4007, 'Laura', 'Butterfield'      , 'Finland');
insert into Author (AuthorID, AuthorFirstName, AuthorLastName, Nationality) values (4008, 'Munroe', 'Formby'          , 'Sweden');
insert into Author (AuthorID, AuthorFirstName, AuthorLastName, Nationality) values (4009, 'Sidonnie', 'Langan'        , 'Japan');


insert into Publisher (PublisherID, PublisherName, Address, Email) values (5000, 'Gevee', '4 Everett Street'          , 'tcaldecourt0@ca.gov');
insert into Publisher (PublisherID, PublisherName, Address, Email) values (5001, 'Dablist', '32 Susan Avenue'         , 'edominguez1@taobao.com');
insert into Publisher (PublisherID, PublisherName, Address, Email) values (5002, 'Jetpulse', '9084 Marcy Terrace'     , 'tdickin2@google.com.br');
insert into Publisher (PublisherID, PublisherName, Address, Email) values (5003, 'Divanoodle', '714 Sullivan Plaza'   , 'bgeratasch3@jigsy.com');
insert into Publisher (PublisherID, PublisherName, Address, Email) values (5004, 'Mynte', '68538 Garrison Circle'     , 'sewence4@rambler.su');
insert into Publisher (PublisherID, PublisherName, Address, Email) values (5005, 'Testi', '68538 Garrison Circle'     , 'sewence2@rambler.su');


insert into Loan (LoanID, LoanDate, DueDate, FKMemberID) values (6000, '11/25/3153', '5/11/4111'   , 1000  );
insert into Loan (LoanID, LoanDate, DueDate, FKMemberID) values (6001, '6/22/4246' , '11/29/4815'   , 1000  );
insert into Loan (LoanID, LoanDate, DueDate, FKMemberID) values (6002, '3/17/6069' , '4/12/5617'    , 1001  );
insert into Loan (LoanID, LoanDate, DueDate, FKMemberID) values (6003, '9/28/3419' , '6/20/6936'    , 1005  );
insert into Loan (LoanID, LoanDate, DueDate, FKMemberID) values (6004, '12/3/2587' , '1/21/3255'    , 1007  );
insert into Loan (LoanID, LoanDate, DueDate, FKMemberID) values (6005, '12/14/8613', '5/15/6546'    , 1011  );
insert into Loan (LoanID, LoanDate, DueDate, FKMemberID) values (6006, '5/2/3282'  , '9/24/4019'   , 1017  );
insert into Loan (LoanID, LoanDate, DueDate, FKMemberID) values (6007, '9/24/7006' , '7/20/3240'   , 1003  );
insert into Loan (LoanID, LoanDate, DueDate, FKMemberID) values (6008, '1/28/7512' , '4/3/4044'     , 1002  );
insert into Loan (LoanID, LoanDate, DueDate, FKMemberID) values (6009, '12/24/6899', '4/14/8836'   , 1001  );


insert into Book (BookID, Title, ISBN, PublishDate, IsLoaned, FKAuthorID, FKPublisherID) values (2000,  'The Item'         , '9513807274'  , '7/15/1996'   , 1 , 4000, 5001 );
insert into Book (BookID, Title, ISBN, PublishDate, IsLoaned, FKAuthorID, FKPublisherID) values (2001,  'Style Wars'        , '3788792957'  , '2/21/2078'   , 1 , 4000, 5001 );
insert into Book (BookID, Title, ISBN, PublishDate, IsLoaned, FKAuthorID, FKPublisherID) values (2002,  'Cimarron'          , '5983915355'  , '6/28/1907'   , 1 , 4000, 5001 );
insert into Book (BookID, Title, ISBN, PublishDate, IsLoaned, FKAuthorID, FKPublisherID) values (2003,  'Ziegfeld Follies'  , '1745407987'  , '7/9/2010'    , 0 , 4001, 5000 );
insert into Book (BookID, Title, ISBN, PublishDate, IsLoaned, FKAuthorID, FKPublisherID) values (2004,  'Law, Hot Wind Blows', '9507172505' , '6/16/2041'   , 1 , 4001, 5000 );
insert into Book (BookID, Title, ISBN, PublishDate, IsLoaned, FKAuthorID, FKPublisherID) values (2005,  'Grace Unplugged'   , '2097531830'  , '6/4/1978'    , 0 , 4002, 5000 );
insert into Book (BookID, Title, ISBN, PublishDate, IsLoaned, FKAuthorID, FKPublisherID) values (2006,  'The Overcoat'      , '660089606X'  , '11/25/2028'  , 1 , 4003, 5002 );
insert into Book (BookID, Title, ISBN, PublishDate, IsLoaned, FKAuthorID, FKPublisherID) values (2007,  'Make Your Move'    , '3828944272'  , '5/23/1931'   , 0 , 4004, 5002 );
insert into Book (BookID, Title, ISBN, PublishDate, IsLoaned, FKAuthorID, FKPublisherID) values (2008,  'Thr3e'             , '520348323X'  , '12/16/2091'  , 1 , 4005, 5002 );
insert into Book (BookID, Title, ISBN, PublishDate, IsLoaned, FKAuthorID, FKPublisherID) values (2009,  'The Company'       , '8644701363'  , '8/22/1968'   , 0 , 4005, 5003 );
insert into Book (BookID, Title, ISBN, PublishDate, IsLoaned, FKAuthorID, FKPublisherID) values (2010,  'Escape Artist'     , '2982580977'  , '12/18/2100'  , 1 , 4005, 5003 );
insert into Book (BookID, Title, ISBN, PublishDate, IsLoaned, FKAuthorID, FKPublisherID) values (2011,  'Phantom of the Opera', '0774945400', '5/20/2100'   , 1 , 4005, 5003 );
insert into Book (BookID, Title, ISBN, PublishDate, IsLoaned, FKAuthorID, FKPublisherID) values (2012,  'Have No Memories'  , '9835419051'  , '10/1/1989'   , 1 , 4005, 5003 );
insert into Book (BookID, Title, ISBN, PublishDate, IsLoaned, FKAuthorID, FKPublisherID) values (2013,  'Like Someone In Love', '8115336319', '11/4/2100'   , 0 , 4006, 5003 );
insert into Book (BookID, Title, ISBN, PublishDate, IsLoaned, FKAuthorID, FKPublisherID) values (2014,  'The Circle'        , '5119542824'  , '3/22/1994'   , 1 , 4007, 5004 );
insert into Book (BookID, Title, ISBN, PublishDate, IsLoaned, FKAuthorID, FKPublisherID) values (2015,  'The Trip'         , '3359810104'  , '11/20/1973'  , 0 , 4008, 5004 );
insert into Book (BookID, Title, ISBN, PublishDate, IsLoaned, FKAuthorID, FKPublisherID) values (2016,  'New York Doll'     , '3340780285'  , '4/6/1991'    , 1 , 4009, 5004 );
insert into Book (BookID, Title, ISBN, PublishDate, IsLoaned, FKAuthorID, FKPublisherID) values (2017,  'Butterflies'       , '5381452640'  , '8/28/2001'   , 1 , 4009, 5002 );
insert into Book (BookID, Title, ISBN, PublishDate, IsLoaned, FKAuthorID, FKPublisherID) values (2018,  'Loving'            , '7126549326'  , '5/23/2005'   , 0 , 4002, 5004 );
insert into Book (BookID, Title, ISBN, PublishDate, IsLoaned, FKAuthorID, FKPublisherID) values (2019,  'Rosenstrasse'      , '5744750746'  , '3/9/2046'    , 1 , 4003, 5001 );


insert into GenresOfBook (FKBookID, FKGenreID) values (2000, 3000);
insert into GenresOfBook (FKBookID, FKGenreID) values (2000, 3002);
insert into GenresOfBook (FKBookID, FKGenreID) values (2001, 3005);
insert into GenresOfBook (FKBookID, FKGenreID) values (2001, 3006);
insert into GenresOfBook (FKBookID, FKGenreID) values (2001, 3009);
insert into GenresOfBook (FKBookID, FKGenreID) values (2002, 3003);
insert into GenresOfBook (FKBookID, FKGenreID) values (2002, 3001);
insert into GenresOfBook (FKBookID, FKGenreID) values (2003, 3005);
insert into GenresOfBook (FKBookID, FKGenreID) values (2003, 3006);
insert into GenresOfBook (FKBookID, FKGenreID) values (2004, 3007);
insert into GenresOfBook (FKBookID, FKGenreID) values (2005, 3008);
insert into GenresOfBook (FKBookID, FKGenreID) values (2005, 3005);
insert into GenresOfBook (FKBookID, FKGenreID) values (2006, 3004);
insert into GenresOfBook (FKBookID, FKGenreID) values (2006, 3003);
insert into GenresOfBook (FKBookID, FKGenreID) values (2006, 3002);
insert into GenresOfBook (FKBookID, FKGenreID) values (2007, 3001);
insert into GenresOfBook (FKBookID, FKGenreID) values (2008, 3001);
insert into GenresOfBook (FKBookID, FKGenreID) values (2008, 3007);
insert into GenresOfBook (FKBookID, FKGenreID) values (2009, 3009);


insert into GenresOfBook (FKBookID, FKGenreID) values (2010, 3002);
insert into GenresOfBook (FKBookID, FKGenreID) values (2011, 3002);
insert into GenresOfBook (FKBookID, FKGenreID) values (2012, 3001);
insert into GenresOfBook (FKBookID, FKGenreID) values (2013, 3006);
insert into GenresOfBook (FKBookID, FKGenreID) values (2014, 3005);
insert into GenresOfBook (FKBookID, FKGenreID) values (2015, 3007);
insert into GenresOfBook (FKBookID, FKGenreID) values (2016, 3008);
insert into GenresOfBook (FKBookID, FKGenreID) values (2016, 3003);
insert into GenresOfBook (FKBookID, FKGenreID) values (2017, 3004);
insert into GenresOfBook (FKBookID, FKGenreID) values (2018, 3005);
insert into GenresOfBook (FKBookID, FKGenreID) values (2019, 3005);
insert into GenresOfBook (FKBookID, FKGenreID) values (2019, 3002);
insert into GenresOfBook (FKBookID, FKGenreID) values (2019, 3001);
insert into GenresOfBook (FKBookID, FKGenreID) values (2018, 3007);


insert into BooksInLoan (FKBookID, FKLoanID) values (2000, 6000);
insert into BooksInLoan (FKBookID, FKLoanID) values (2001, 6000);
insert into BooksInLoan (FKBookID, FKLoanID) values (2002, 6000);
insert into BooksInLoan (FKBookID, FKLoanID) values (2008, 6002);
insert into BooksInLoan (FKBookID, FKLoanID) values (2012, 6004);
insert into BooksInLoan (FKBookID, FKLoanID) values (2016, 6005);
insert into BooksInLoan (FKBookID, FKLoanID) values (2014, 6006);
insert into BooksInLoan (FKBookID, FKLoanID) values (2017, 6007);
insert into BooksInLoan (FKBookID, FKLoanID) values (2011, 6007);
insert into BooksInLoan (FKBookID, FKLoanID) values (2010, 6009);
insert into BooksInLoan (FKBookID, FKLoanID) values (2004, 6008);
insert into BooksInLoan (FKBookID, FKLoanID) values (2019, 6008);
insert into BooksInLoan (FKBookID, FKLoanID) values (2006, 6009);



