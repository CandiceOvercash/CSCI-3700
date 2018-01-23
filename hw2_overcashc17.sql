DROP TABLE History;
DROP TABLE CurrentLoan;
DROP TABLE Member;
DROP TABLE Book;

--Problem 1

PROMPT Problem 1

CREATE TABLE Book
(
        book_id varchar(7) PRIMARY KEY,
        isbn varchar(22),
        title varchar(22),
        author varchar(22),
        publish_year number(5),
        category varchar(22)
);

CREATE TABLE Member
(
        member_id varchar(7) PRIMARY KEY,
        lastname varchar(22),
        firstname varchar(22),
        address varchar(50),
        phone_number int,
        book_limit int
       );

CREATE TABLE CurrentLoan
(
        member_id varchar(7),
        book_id varchar(7),
        loan_date date,
        due_date date,
        FOREIGN KEY(member_id) REFERENCES Member(member_id),
        FOREIGN KEY(book_id) REFERENCES Book(book_id)
);

CREATE TABLE History
(
        member_id varchar(7),
        book_id varchar(7),
        loan_date date,
        return_date date, 
        PRIMARY KEY(member_id,book_id,loan_date),
        FOREIGN KEY(member_id) REFERENCES Member(member_id),
        FOREIGN KEY(book_id) REFERENCES Book(book_id)     
);



PROMPT Problem 2

--Book(book_ID, ISBN, title, author, publish_year, category)
INSERT INTO Book VALUES(01234, 9783161484101, 'FureverFirends', 'Lisa Overcash', 2017, 'fiction');
INSERT INTO Book VALUES(10001, 9783161484102, 'Finding Emo', 'Sydney' , 2003, 'children');
INSERT INTO Book VALUES(12034, 9783161484103, 'Behind the Stone' , 'Mary', 1000, 'reference');
INSERT INTO Book VALUES(12304, 9783161484104, 'Game of Tones', 'J.K Rowling', 1997, 'fiction');
INSERT INTO Book VALUES(12340, 9783161484105, 'Untiled XQuery', 'Undisclosed',2007, 'reference');
INSERT INTO Book VALUES(10002, 9783161484106, '10 Commandments', 'God', 16, 'reference');
INSERT INTO Book VALUES(23140, 9783161484107, 'Batman!', 'Stan Lee', 1978, 'reference');
INSERT INTO Book VALUES(33331, 9783161484108, 'XML and XQuery Attacks', 'Jane Doe', 2001, 'reference');
INSERT INTO Book VALUES(23401, 9783161484109, 'XQuery', 'Allen Jackson', 1991, 'reference');
INSERT INTO Book VALUES(33332, 9783161484110, 'XML or XQuery', 'Brittney Spears', 1990, 'reference');

 --Member(member_ID, lastname, firstname, address, phone_number, limit)
INSERT INTO Member VALUES(85679,'Greg','Andy','address1',9191234567, 3);
INSERT INTO Member VALUES(95678,'Hill','Mark','address2',9191234567, 3);
INSERT INTO Member VALUES(10000,'Smith','John','81 Barnes Street',9191234567, 3);
INSERT INTO Member VALUES(65789,'Tatum','Channing','21 Jump Street',94373329333, 2);
INSERT INTO Member VALUES(75689,'Man','Muffin','350 Dairy Lane',18002253669, 4);
 
--CurrentLoan(member_ID, book_ID, loan_date, due_date) 
INSERT INTO  CurrentLoan VALUES(10000, 10001, '13-SEP-17', '14-NOV-17');
INSERT INTO  CurrentLoan VALUES(10000, 10002, '12-SEP-17', '13-NOV-17');
--History(member_id, book_ID, loan_date, return_date)
INSERT INTO History VALUES(10000, 10001, '13-NOV-16', '24-NOV-16');
INSERT INTO History VALUES(75689, 01234, '13-OCT-16', '14-NOV-16');
INSERT INTO History VALUES(95678, 01234, '13-SEP-16', '14-NOV-16');

COMMIT;

PROMPT Problem 3

SELECT book_id, title, author, publish_year
FROM Book
WHERE (title like '%XML%XQuery%' or title like'%XQuery%XML%')
ORDER BY Book.publish_year desc;

Prompt Problem 4

SELECT Book.book_id, title, due_date
FROM   Member, Book, CurrentLoan
WHERE  Book.book_id = CurrentLoan.book_id 
AND Member.member_id = CurrentLoan.member_id 
AND firstname ='John'
AND lastname ='Smith';

PROMPT  Problem 5

SELECT Member.member_id, lastname, firstname 
FROM Member MINUS(
                SELECT Member.member_id,lastname,firstname
                FROM Member,CurrentLoan
                WHERE Member.member_id=CurrentLoan.member_id 
                UNION 
                        SELECT Member.member_id,lastname,firstname
                        FROM Member,History
                        WHERE Member.member_id=History.member_id);
