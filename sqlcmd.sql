create table Member (
        member_id INTEGER PRIMARY KEY NOT NULL,
        first_name VARCHAR(100) NOT NULL,
        last_name VARCHAR(100) NOT NULL,
        address VARCHAR(100) NOT NULL,
        phone_number VARCHAR(25),
        email VARCHAR(75)
);

create table Loan (
        loan_id INTEGER PRIMARY KEY NOT NULL,
        loan_date VARCHAR(100) NOT NULL,
        due_date VARCHAR(100) NOT NULL,
        return_date VARCHAR(25),
        fk_member_id INTEGER NOT NULL,
        FOREIGN KEY (fk_member_id) REFERENCES Member(member_id) ON DELETE CASCADE
);

create table Book (
        book_id INTEGER PRIMARY KEY NOT NULL,
        title VARCHAR(100) NOT NULL,
        isbn VARCHAR(20) NOT NULL CHECK(LENGTH(isbn) IN (10, 13)),
        publish_date VARCHAR(50),
        loan_status BOOL NOT NULL DEFAULT FALSE,
        fk_author_id INTEGER,
        fk_publisher_id INTEGER,
        FOREIGN KEY (fk_author_id) REFERENCES Author(author_id) ON DELETE CASCADE,
        FOREIGN KEY (fk_publisher_id) REFERENCES Publisher(publisher_id) ON DELETE CASCADE
);

create table BooksInLoan (
        fk_book_id INTEGER NOT NULL,
        fk_loan_id INTEGER NOT NULL,
        FOREIGN KEY (fk_book_id) REFERENCES Book(book_id) ON DELETE CASCADE,
        FOREIGN KEY (fk_loan_id) REFERENCES Loan(loan_id) ON DELETE CASCADE
);

create table Genre (
        genre_id INTEGER PRIMARY KEY NOT NULL,
        genre_name VARCHAR(50) NOT NULL
);

create table GenresOfBook (
        fk_book_id INTEGER NOT NULL,
        fk_genre_id INTEGER NOT NULL,
        FOREIGN KEY (fk_book_id) REFERENCES Book(book_id) ON DELETE CASCADE,
        FOREIGN KEY (fk_genre_id) REFERENCES Genre(genre_id) ON DELETE CASCADE
);

create table Author (
        author_id INTEGER PRIMARY KEY NOT NULL,
        author_firstname VARCHAR(70),
        author_surname VARCHAR(70),
        nationality VARCHAR(50)
);

create table Publisher (
        publisher_id INTEGER PRIMARY KEY NOT NULL,
        publisher_name VARCHAR(100),
        address VARCHAR(100),
        email VARCHAR(50)
);


insert into Member (member_id, first_name, last_name, address, phone_number, email) values (1000,'Land', 'Witling', '88 Gulseth Hill', '962-756-5469', 'lwitling0@webs.com');
insert into Member (member_id, first_name, last_name, address, phone_number, email) values (1001,'Claudian', 'Runciman', '0562 Quincy Park', '795-238-0413', 'crunciman1@meetup.com');
insert into Member (member_id, first_name, last_name, address, phone_number, email) values (1002,'Mair', 'Wolfarth', '460 Johnson Park', '597-488-0051', 'mwolfarth2@networkadvertising.org');
insert into Member (member_id, first_name, last_name, address, phone_number, email) values (1003,'Tildi', 'Mechell', '3 Fuller Point', '794-466-0234', 'tmechell3@berkeley.edu');
insert into Member (member_id, first_name, last_name, address, phone_number, email) values (1004,'Paulette', 'Cleugh', '288 Glacier Hill Park', '894-248-7363', 'pcleugh4@examiner.com');
insert into Member (member_id, first_name, last_name, address, phone_number, email) values (1005,'Merrile', 'McDunlevy', '9746 Bellgrove Avenue', '687-335-0735', 'mmcdunlevy5@flavors.me');
insert into Member (member_id, first_name, last_name, address, phone_number, email) values (1006,'Welch', 'Newsham', '04 Gina Parkway', '874-919-3047', 'wnewsham6@tinyurl.com');
insert into Member (member_id, first_name, last_name, address, phone_number, email) values (1007,'Travers', 'Lemerle', '4 Garrison Trail', '842-761-3997', 'tlemerle7@google.de');
insert into Member (member_id, first_name, last_name, address, phone_number, email) values (1008,'Booth', 'Vickress', '22363 American Court', '388-446-1641', 'bvickress8@instagram.com');
insert into Member (member_id, first_name, last_name, address, phone_number, email) values (1009,'Jaime', 'Giorgiutti', '541 Ronald Regan Drive', '790-945-5224', 'jgiorgiutti9@live.com');
insert into Member (member_id, first_name, last_name, address, phone_number, email) values (1010,'Tod', 'Jacox', '85 Corry Junction', '886-669-3327', 'tjacoxa@linkedin.com');
insert into Member (member_id, first_name, last_name, address, phone_number, email) values (1011,'Vonni', 'Scola', '5206 Emmet Park', '553-152-2523', 'vscolab@npr.org');
insert into Member (member_id, first_name, last_name, address, phone_number, email) values (1012,'Romona', 'Axe', '793 Dapin Place', '559-431-6500', 'raxec@drupal.org');
insert into Member (member_id, first_name, last_name, address, phone_number, email) values (1013,'Dal', 'Borgnet', '776 Westerfield Court', '787-794-8796', 'dborgnetd@ebay.com');
insert into Member (member_id, first_name, last_name, address, phone_number, email) values (1014,'Janella', 'Wattingham', '6 Old Shore Trail', '108-611-8564', 'jwattinghame@amazon.com');
insert into Member (member_id, first_name, last_name, address, phone_number, email) values (1015,'Tobiah', 'Everett', '9 Summerview Drive', '567-952-0538', 'teverettf@craigslist.org');
insert into Member (member_id, first_name, last_name, address, phone_number, email) values (1016,'Minda', 'Gerok', '10 Pankratz Alley', '353-260-9110', 'mgerokg@gov.uk');
insert into Member (member_id, first_name, last_name, address, phone_number, email) values (1017,'Gardiner', 'Welband', '492 Eagle Crest Way', '464-855-7728', 'gwelbandh@networksolutions.com');
insert into Member (member_id, first_name, last_name, address, phone_number, email) values (1018,'Zachery', 'Percifull', '00 Acker Court', '367-337-4336', 'zpercifulli@army.mil');
insert into Member (member_id, first_name, last_name, address, phone_number, email) values (1019,'Alyse', 'Cornfoot', '0 Northview Center', '648-288-6657', 'acornfootj@buzzfeed.com');

insert into Genre (genre_id, genre_name) values (3000,'Comedy');
insert into Genre (genre_id, genre_name) values (3001,'Action');
insert into Genre (genre_id, genre_name) values (3002,'Drama');
insert into Genre (genre_id, genre_name) values (3003,'Mystery');
insert into Genre (genre_id, genre_name) values (3004,'Thriller');
insert into Genre (genre_id, genre_name) values (3005,'Documentary');
insert into Genre (genre_id, genre_name) values (3006,'War');
insert into Genre (genre_id, genre_name) values (3007,'Romance');
insert into Genre (genre_id, genre_name) values (3008,'Adventure');
insert into Genre (genre_id, genre_name) values (3009,'Horror');

insert into Author (author_id, author_firstname, author_surname, nationality) values (4000, 'Celinda', 'Challicombe'    , 'Norway');
insert into Author (author_id, author_firstname, author_surname, nationality) values (4001, 'Darsie', 'Caldero'         , 'Spain');
insert into Author (author_id, author_firstname, author_surname, nationality) values (4002, 'Alverta', 'Jessopp'        , 'Colombia');
insert into Author (author_id, author_firstname, author_surname, nationality) values (4003, 'Florette', 'Timewell'      , 'Prussia');
insert into Author (author_id, author_firstname, author_surname, nationality) values (4004, 'Finn', 'Chapelle'          , 'New Zealand');
insert into Author (author_id, author_firstname, author_surname, nationality) values (4005, 'Evaleen', 'Denington'      , 'United Kingdom');
insert into Author (author_id, author_firstname, author_surname, nationality) values (4006, 'Der', 'Gilford'            , 'Germany');
insert into Author (author_id, author_firstname, author_surname, nationality) values (4007, 'Laura', 'Butterfield'      , 'Finland');
insert into Author (author_id, author_firstname, author_surname, nationality) values (4008, 'Munroe', 'Formby'          , 'Sweden');
insert into Author (author_id, author_firstname, author_surname, nationality) values (4009, 'Sidonnie', 'Langan'        , 'Japan');

insert into Publisher (publisher_id, publisher_name, address, email) values (5000, 'Gevee', '4 Everett Street', 'tcaldecourt0@ca.gov');
insert into Publisher (publisher_id, publisher_name, address, email) values (5001, 'Dablist', '32 Susan Avenue', 'edominguez1@taobao.com');
insert into Publisher (publisher_id, publisher_name, address, email) values (5002, 'Jetpulse', '9084 Marcy Terrace', 'tdickin2@google.com.br');
insert into Publisher (publisher_id, publisher_name, address, email) values (5003, 'Divanoodle', '714 Sullivan Plaza', 'bgeratasch3@jigsy.com');
insert into Publisher (publisher_id, publisher_name, address, email) values (5004, 'Mynte', '68538 Garrison Circle', 'sewence4@rambler.ru');
insert into Publisher (publisher_id, publisher_name, address, email) values (5005, 'Testi', '68538 Garrison Circle', 'sewence4@rambler.ru');

insert into Loan (loan_id, loan_date, due_date, fk_member_id) values (6000, '11/25/3153', '5/11/4111'       , 1000  );
insert into Loan (loan_id, loan_date, due_date, fk_member_id) values (6001, '6/22/4246', '11/29/4815'       , 1000  );
insert into Loan (loan_id, loan_date, due_date, fk_member_id) values (6002, '3/17/6069', '4/12/5617'        , 1001  );
insert into Loan (loan_id, loan_date, due_date, fk_member_id) values (6003, '9/28/3419', '6/20/6936'        , 1005  );
insert into Loan (loan_id, loan_date, due_date, fk_member_id) values (6004, '12/3/2587', '1/21/3255'        , 1007  );
insert into Loan (loan_id, loan_date, due_date, fk_member_id) values (6005, '12/14/8613', '5/15/6546'       , 1011  );
insert into Loan (loan_id, loan_date, due_date, fk_member_id) values (6006, '5/2/3282', '9/24/4019'         , 1017  );
insert into Loan (loan_id, loan_date, due_date, fk_member_id) values (6007, '9/24/7006', '7/20/3240'        , 1003  );
insert into Loan (loan_id, loan_date, due_date, fk_member_id) values (6008, '1/28/7512', '4/3/4044'         , 1002  );
insert into Loan (loan_id, loan_date, due_date, fk_member_id) values (6009, '12/24/6899', '4/14/8836'       , 1001  );

insert into Book (book_id, title, isbn, publish_date, fk_author_id, fk_publisher_id) values (2000,  'Item, The' , '9513807274', '7/15/1996'                                                , 4000, 5001 );
insert into Book (book_id, title, isbn, publish_date, fk_author_id, fk_publisher_id) values (2001,  'Style Wars', '3788792957', '2/21/2078'                                                , 4000, 5001 );
insert into Book (book_id, title, isbn, publish_date, fk_author_id, fk_publisher_id) values (2002,  'Cimarron'  , '5983915355', '6/28/1907'                                                , 4000, 5001 );
insert into Book (book_id, title, isbn, publish_date, fk_author_id, fk_publisher_id) values (2003,  'Ziegfeld Follies'  , '1745407987', '7/9/2010'                                         , 4001, 5000 );
insert into Book (book_id, title, isbn, publish_date, fk_author_id, fk_publisher_id) values (2004,  'Law, The (a.k.a. Where the Hot Wind Blows!) (Legge, La)', '9507172505', '6/16/2041'   , 4001, 5000 );
insert into Book (book_id, title, isbn, publish_date, fk_author_id, fk_publisher_id) values (2005,  'Grace Unplugged'   , '2097531830', '6/4/1978'                                         , 4002, 5000 );
insert into Book (book_id, title, isbn, publish_date, fk_author_id, fk_publisher_id) values (2006,  'Overcoat, The (Il cappotto)', '660089606X', '11/25/2028'                              , 4003, 5002 );
insert into Book (book_id, title, isbn, publish_date, fk_author_id, fk_publisher_id) values (2007,  'Make Your Move', '3828944272', '5/23/1931'                                            , 4004, 5002 );
insert into Book (book_id, title, isbn, publish_date, fk_author_id, fk_publisher_id) values (2008,  'Thr3e (Three)', '520348323X', '12/16/2091'                                            , 4005, 5002 );
insert into Book (book_id, title, isbn, publish_date, fk_author_id, fk_publisher_id) values (2009,  'The Company', '8644701363', '8/22/1968'                                               , 4005, 5003 );
insert into Book (book_id, title, isbn, publish_date, fk_author_id, fk_publisher_id) values (2010,  'Escape Artist, The', '2982580977', '12/18/2100'                                       , 4005, 5003 );
insert into Book (book_id, title, isbn, publish_date, fk_author_id, fk_publisher_id) values (2011,  'Phantom of the Opera, The', '0774945400', '5/20/2100'                                 , 4005, 5003 );
insert into Book (book_id, title, isbn, publish_date, fk_author_id, fk_publisher_id) values (2012,  'Butterflies Have No Memories', '9835419051', '10/1/1989'                              , 4005, 5003 );
insert into Book (book_id, title, isbn, publish_date, fk_author_id, fk_publisher_id) values (2013,  'Like Someone In Love', '8115336319', '11/4/2100'                                      , 4006, 5003 );
insert into Book (book_id, title, isbn, publish_date, fk_author_id, fk_publisher_id) values (2014,  'The Circle', '5119542824', '3/22/1994'                                                , 4007, 5004 );
insert into Book (book_id, title, isbn, publish_date, fk_author_id, fk_publisher_id) values (2015,  'Trip, The', '3359810104', '11/20/1973'                                                , 4008, 5004 );
insert into Book (book_id, title, isbn, publish_date, fk_author_id, fk_publisher_id) values (2016,  'New York Doll', '3340780285', '4/6/1991'                                              , 4009, 5004 );
insert into Book (book_id, title, isbn, publish_date, fk_author_id, fk_publisher_id) values (2017,  'Bloody Mama', '5381452640', '8/28/2001'                                               , 4009, 5002 );
insert into Book (book_id, title, isbn, publish_date, fk_author_id, fk_publisher_id) values (2018,  'Loving', '7126549326', '5/23/2005'                                                    , 4002, 5004 );
insert into Book (book_id, title, isbn, publish_date, fk_author_id, fk_publisher_id) values (2019,  'Rosenstrasse', '5744750746', '3/9/2046'                                               , 4003, 5001 );

insert into GenresOfBook (fk_book_id, fk_genre_id) values (2000, 3000);
insert into GenresOfBook (fk_book_id, fk_genre_id) values (2000, 3002);
insert into GenresOfBook (fk_book_id, fk_genre_id) values (2001, 3005);
insert into GenresOfBook (fk_book_id, fk_genre_id) values (2001, 3006);
insert into GenresOfBook (fk_book_id, fk_genre_id) values (2001, 3009);
insert into GenresOfBook (fk_book_id, fk_genre_id) values (2002, 3003);
insert into GenresOfBook (fk_book_id, fk_genre_id) values (2002, 3001);
insert into GenresOfBook (fk_book_id, fk_genre_id) values (2003, 3005);
insert into GenresOfBook (fk_book_id, fk_genre_id) values (2003, 3006);
insert into GenresOfBook (fk_book_id, fk_genre_id) values (2004, 3007);
insert into GenresOfBook (fk_book_id, fk_genre_id) values (2005, 3008);
insert into GenresOfBook (fk_book_id, fk_genre_id) values (2005, 3005);
insert into GenresOfBook (fk_book_id, fk_genre_id) values (2006, 3004);
insert into GenresOfBook (fk_book_id, fk_genre_id) values (2006, 3003);
insert into GenresOfBook (fk_book_id, fk_genre_id) values (2006, 3002);
insert into GenresOfBook (fk_book_id, fk_genre_id) values (2007, 3001);
insert into GenresOfBook (fk_book_id, fk_genre_id) values (2008, 3001);
insert into GenresOfBook (fk_book_id, fk_genre_id) values (2008, 3007);
insert into GenresOfBook (fk_book_id, fk_genre_id) values (2009, 3009);

insert into GenresOfBook (fk_book_id, fk_genre_id) values (2010, 3002);
insert into GenresOfBook (fk_book_id, fk_genre_id) values (2011, 3002);
insert into GenresOfBook (fk_book_id, fk_genre_id) values (2012, 3001);
insert into GenresOfBook (fk_book_id, fk_genre_id) values (2013, 3006);
insert into GenresOfBook (fk_book_id, fk_genre_id) values (2014, 3005);
insert into GenresOfBook (fk_book_id, fk_genre_id) values (2015, 3007);
insert into GenresOfBook (fk_book_id, fk_genre_id) values (2016, 3008);
insert into GenresOfBook (fk_book_id, fk_genre_id) values (2016, 3003);
insert into GenresOfBook (fk_book_id, fk_genre_id) values (2017, 3004);
insert into GenresOfBook (fk_book_id, fk_genre_id) values (2018, 3005);
insert into GenresOfBook (fk_book_id, fk_genre_id) values (2019, 3005);
insert into GenresOfBook (fk_book_id, fk_genre_id) values (2019, 3002);
insert into GenresOfBook (fk_book_id, fk_genre_id) values (2019, 3001);
insert into GenresOfBook (fk_book_id, fk_genre_id) values (2018, 3007);

insert into BooksInLoan (fk_book_id, fk_loan_id) values (2000, 6000);
insert into BooksInLoan (fk_book_id, fk_loan_id) values (2001, 6000);
insert into BooksInLoan (fk_book_id, fk_loan_id) values (2002, 6000);
insert into BooksInLoan (fk_book_id, fk_loan_id) values (2003, 6001);
insert into BooksInLoan (fk_book_id, fk_loan_id) values (2005, 6001);
insert into BooksInLoan (fk_book_id, fk_loan_id) values (2007, 6001);
insert into BooksInLoan (fk_book_id, fk_loan_id) values (2008, 6002);
insert into BooksInLoan (fk_book_id, fk_loan_id) values (2009, 6003);
insert into BooksInLoan (fk_book_id, fk_loan_id) values (2012, 6004);
insert into BooksInLoan (fk_book_id, fk_loan_id) values (2016, 6005);
insert into BooksInLoan (fk_book_id, fk_loan_id) values (2014, 6006);
insert into BooksInLoan (fk_book_id, fk_loan_id) values (2017, 6007);
insert into BooksInLoan (fk_book_id, fk_loan_id) values (2011, 6007);
insert into BooksInLoan (fk_book_id, fk_loan_id) values (2010, 6009);
insert into BooksInLoan (fk_book_id, fk_loan_id) values (2004, 6008);
insert into BooksInLoan (fk_book_id, fk_loan_id) values (2019, 6008);
insert into BooksInLoan (fk_book_id, fk_loan_id) values (2006, 6009);



