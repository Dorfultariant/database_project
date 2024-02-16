create table Member (
	member_id INT PRIMARY KEY NOT NULL,
	member_firstname VARCHAR(100) NOT NULL,
	member_surname VARCHAR(100) NOT NULL,
	address VARCHAR(100) NOT NULL,
	phone_number VARCHAR(25),
	email VARCHAR(75)
);

create table Loan (
	loan_id INT PRIMARY KEY NOT NULL,
	loan_date VARCHAR(100) NOT NULL,
	due_date VARCHAR(100) NOT NULL,
	return_date VARCHAR(25),
	fk_member_id INT NOT NULL,
	FOREIGN KEY (fk_member_id) REFERENCES Member(member_id) ON DELETE CASCADE 
);

create table Book (
	book_id INT PRIMARY KEY NOT NULL,
	title VARCHAR(100) NOT NULL,
	isbn VARCHAR(20) NOT NULL UNIQUE CHECK(LENGTH(isbn) IN (10, 13)),
	publish_date VARCHAR(50),
	loan_status BOOL NOT NULL DEFAULT FALSE,
	fk_author_id INT,
	fk_publisher_id INT,
	FOREIGN KEY (fk_author_id) REFERENCES Author(author_id) ON DELETE CASCADE,	
	FOREIGN KEY (fk_publisher_id) REFERENCES Publisher(publisher_id) ON DELETE CASCADE
);

create table BooksInLoan (
	fk_book_id INT NOT NULL,
	fk_loan_id INT NOT NULL,
	FOREIGN KEY (fk_book_id) REFERENCES Book(book_id) ON DELETE CASCADE,
	FOREIGN KEY (fk_loan_id) REFERENCES Loan(loan_id) ON DELETE CASCADE
);

create table Genre (
	genre_id INT PRIMARY KEY NOT NULL,
	genre_name VARCHAR(50) NOT NULL
);

create table GenresOfBook (
	fk_book_id INT NOT NULL,
	fk_genre_id INT NOT NULL,
	FOREIGN KEY (fk_book_id) REFERENCES Book(book_id) ON DELETE CASCADE,
	FOREIGN KEY (fk_genre_id) REFERENCES Genre(genre_id) ON DELETE CASCADE
);

create table Author (
	author_id INT PRIMARY KEY NOT NULL,
	author_firstname VARCHAR(70),
	author_surname VARCHAR(70),
	nationality VARCHAR(50)
);

create table Publisher (
	publisher_id INT PRIMARY KEY NOT NULL,
	publisher_name VARCHAR(100),
	address VARCHAR(100),
	email VARCHAR(50)
);

