DROP VIEW number_books;
DROP TABLE History;
DROP TABLE CurrentLoan;
DROP TABLE Member;
DROP TABLE Book;

CREATE TABLE Book
(
        book_id varchar(6) PRIMARY KEY,
        isbn varchar(15),
        title varchar(30),
        author varchar(15),
        publishyear number(5),
        category varchar(20)
);

CREATE TABLE Member
(
        member_id varchar(6) PRIMARY KEY,
        lastname varchar(5),
        firstname varchar(5),
        address varchar(15),
        phonenumber varchar(15),
        booklimit int
       );

CREATE TABLE CurrentLoan
(
        member_id varchar(6),
        book_id varchar(4),
        loandate date,
        duedate date,
        FOREIGN KEY(member_id) REFERENCES Member(member_id),
        FOREIGN KEY(book_id) REFERENCES Book(book_id)
);

CREATE TABLE History
(
        member_id varchar(6),
        book_id varchar(4),
        loandate date,
        returndate date, 
        PRIMARY KEY(member_id,book_id,loandate),
        FOREIGN KEY(member_id) REFERENCES Member(member_id),
        FOREIGN KEY(book_id) REFERENCES Book(book_id)     
);


--Book(book_id, isbn, title, author, publishyear, category)
INSERT INTO Book VALUES(101, 9783161484101, 'FureverHere', 'Lisa', 2017, 'Fiction');
INSERT INTO Book VALUES(102, 9783161484102, 'Finding Emo', 'Lisa' , 2003, 'Children');
INSERT INTO Book VALUES(103, 9783161484103, 'Harry Potter', 'Lisa', 1000, 'Reference');
INSERT INTO Book VALUES(104, 9783161484104, 'Harry Potter 1', 'Rowling', 1997, 'Fiction');
INSERT INTO Book VALUES(105, 9783161484105, 'Harry Potter 2', 'Undisclosed',2007, 'Reference');
INSERT INTO Book VALUES(106, 9783161484106, 'Hey Batman!', 'S. Lee', 1978, 'Reference');
INSERT INTO Book VALUES(107, 9783161484107, 'Hey Batman!', 'S. Lee', 1978, 'Reference');
INSERT INTO Book VALUES(108, 9783161484107, 'Hey Batman!', 'S. Lee', 1978, 'Reference');
INSERT INTO Book VALUES(109, 9783161484109, 'XML and XQuery', 'A. Jackson', 1991, 'Reference');
INSERT INTO Book VALUES(110, 9783161484010, 'XQuery: The XML Query Language', 'S.', 1990, 'Reference');

 --Member(member_id, lastname, firstname, address, phonenumber, booklimit)
INSERT INTO Member VALUES(201,'Jones','David','address1',9191234567, 40);
INSERT INTO Member VALUES(202,'Hill','Mark','address2',9191234567, 13);
INSERT INTO Member VALUES(203,'Smith','John','81 Barnes St.',9191234567, 3);
INSERT INTO Member VALUES(204,'Tatum','Chan','21 Jump St.',94373329333, 2);
INSERT INTO Member VALUES(205,'Man','Muff','350 Dairy Ln.',18002253669, 4);
 
--jones has  title1 and title2
INSERT INTO  CurrentLoan VALUES(201, 109, '12-SEP-17', '13-NOV-17');
INSERT INTO History VALUES(202, 104, '13-SEP-16', '14-NOV-16');
INSERT INTO History VALUES(202, 103, '13-SEP-17', '14-NOV-17');
INSERT INTO History VALUES(202, 105, '13-SEP-17', '14-NOV-17');



--Problem 6 inserts
INSERT INTO History VALUES(201, 109, '13-SEP-16', '14-NOV-16');

INSERT INTO  CurrentLoan VALUES(202, 110, '12-SEP-17', '13-NOV-17');


COMMIT;

PROMPT <<<< Table building is complete. >>>>

--Password ohng8z




PROMPT +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

PROMPT Problem 1 Find the lastname and firstname of the member(s) who have the highest limit allowed. 


SELECT lastname, firstname, MAX(booklimit) as book_limit
FROM member  
GROUP BY lastname, firstname 
HAVING MAX(booklimit) =
        (
            SELECT MAX(booklimit) 
            FROM member
        );



PROMPT +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

PROMPT Problem 2  Find the lastname and firstname of members who have borrowed both books titled 
PROMPT “XML and XQuery” and “XQuery: The XML Query Language” either currently or in the past. 

(
    (   
        SELECT lastname, firstname
        FROM Member
        INNER JOIN CurrentLoan ON Member.member_id = CurrentLoan.member_id
        INNER JOIN Book ON CurrentLoan.book_id = Book.book_id
        WHERE Book.title = 'XML and XQuery'
    )
        UNION
    (
        SELECT lastname, firstname
        FROM Member
        INNER JOIN History ON Member.member_id = History.member_id
        INNER JOIN Book ON History.book_id = Book.book_id
        WHERE Book.title = 'XML and XQuery'
    )
)
INTERSECT
(
    (
        SELECT lastname, firstname
        From Member
        INNER JOIN CurrentLoan ON Member.member_id = CurrentLoan.member_id
        INNER JOIN Book ON CurrentLoan.book_id = Book.book_id
        WHERE Book.title = 'XQuery: The XML Query Language'
    )
        UNION
    (
        SELECT lastname, firstname
        from Member
        INNER JOIN History ON Member.member_id = History.member_id
        INNER JOIN Book ON History.book_id = Book.book_id
        WHERE Book.title = 'XQuery: The XML Query Language'
    )
);



PROMPT +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

PROMPT Problem 3 Find the name of the author(s) that has the largest number of different 
PROMPT books owned by the library (multiple copies of the same book only count as one book).
-- lisa = 3. Lee = 2. 

SELECT author, COUNT(distinct isbn) as TOTAL_Books
FROM book  
GROUP BY author 
HAVING COUNT (distinct isbn) =
    (
        SELECT MAX(mycount) 
        FROM 
        (
            SELECT author, COUNT(distinct isbn) mycount 
            FROM book
            GROUP BY author
        )
    );



PROMPT **** OR ****


SELECT author, COUNT(distinct isbn) as TOTAL_Books
FROM book  
GROUP BY author 
HAVING COUNT (distinct isbn) > = all
            (
                SELECT author, COUNT(distinct isbn) mycount 
                FROM book
                GROUP BY author
            );

--where is for individule tuples, having is for individule groups. 8:30 10/5



PROMPT +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

PROMPT Problem 4  For each member (using both member ID, last name, and first name), 
PROMPT list the number of books he/she has currently checked out, and the number of
PROMPT books he/she checked out in the past. If a person checked out the same book 
PROMPT multiple times, it will be counted multiple times. Zero count should also be listed as 0
-- 
-- 9:15 10/5. 12:30 she says a part of her solution is missing.
SELECT Member.member_id, lastname, firstname, COUNT(Books.book_id) AS Loaned
FROM Member
LEFT OUTER JOIN
    (
        SELECT member_id, book_id 
        FROM History
        UNION ALL
        SELECT member_id, book_id 
        FROM CurrentLoan
    ) Books 
        ON Member.member_id = Books.member_id
GROUP BY Member.member_id, lastname, firstname
ORDER BY Member.member_id;




PROMPT +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

PROMPT Problem 5  List the member ID, first name and last name of members who have borrowed 
PROMPT (either currently or in the past) all the books in the library with “Harry Potter” in the title. 
PROMPT If any of such books have multiple copies, he or she must have borrowed at least one copy of 
Prompt each of such books. 
--19:25 10/5

SELECT Member.member_id, member.lastname, member.firstname
FROM Member,
(
    (   
        SELECT lastname, firstname
        FROM Member
        INNER JOIN CurrentLoan ON Member.member_id = CurrentLoan.member_id
        INNER JOIN Book ON CurrentLoan.book_id = Book.book_id
        WHERE Book.title like '%Harry Potter%'
    )
        intersect
    (
        SELECT lastname, firstname
        FROM Member
        INNER JOIN History ON Member.member_id = History.member_id
        INNER JOIN Book ON History.book_id = Book.book_id
        WHERE Book.title like '%Harry Potter%'
    )
);