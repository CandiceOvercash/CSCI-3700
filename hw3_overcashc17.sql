DROP VIEW member_book;
DROP TABLE History;
DROP TABLE CurrentLoan;
DROP TABLE Member;
DROP TABLE Book;

CREATE TABLE Book
(
        book_id varchar(6) PRIMARY KEY,
        isbn varchar(15),
        title varchar(11),
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
INSERT INTO Book VALUES(102, 9783161484102, 'Finding Emo', 'Sydney' , 2003, 'Children');
INSERT INTO Book VALUES(103, 9783161484103, 'BehindStone' , 'Mary', 1000, 'Reference');
INSERT INTO Book VALUES(104, 9783161484104, 'GameofTones', 'Rowling', 1997, 'Fiction');
INSERT INTO Book VALUES(105, 9783161484105, 'UntiledLife', 'Undisclosed',2007, 'Reference');
INSERT INTO Book VALUES(106, 9783161484106, 'Commandment', 'God', 16, 'Reference');
INSERT INTO Book VALUES(107, 9783161484107, 'Hey Batman!', 'S. Lee', 1978, 'Reference');
INSERT INTO Book VALUES(108, 9783161484107, 'Hey Batman!', 'S. Lee', 1978, 'Reference');
INSERT INTO Book VALUES(109, 9783161484109, 'XQuery, Why', 'A. Jackson', 1991, 'Reference');
INSERT INTO Book VALUES(110, 9783161484010, 'XML for Me', 'Book. Spears', 1990, 'Reference');

 --Member(member_id, lastname, firstname, address, phonenumber, booklimit)
INSERT INTO Member VALUES(201,'Jones','David','address1',9191234567, 3);
INSERT INTO Member VALUES(202,'Hill','Mark','address2',9191234567, 13);
INSERT INTO Member VALUES(203,'Smith','John','81 Barnes St.',9191234567, 3);
INSERT INTO Member VALUES(204,'Tatum','Chan','21 Jump St.',94373329333, 2);
INSERT INTO Member VALUES(205,'Man','Muff','350 Dairy Ln.',18002253669, 4);
 
--CurrentLoan(member_id, book_id, loandate, duedate) 
INSERT INTO  CurrentLoan VALUES(202, 101, '13-SEP-17', '14-NOV-17');
INSERT INTO  CurrentLoan VALUES(203, 105, '12-SEP-17', '13-NOV-17');
INSERT INTO  CurrentLoan VALUES(201, 106, '13-SEP-17', '14-NOV-17');

--History(member_id, book_id, loandate, returndate)
INSERT INTO History VALUES(202, 101, '13-NOV-16', '24-NOV-16');
INSERT INTO History VALUES(203, 110, '13-OCT-16', '14-NOV-16');
INSERT INTO History VALUES(204, 103, '13-SEP-16', '14-NOV-16');
INSERT INTO History VALUES(202, 101, '13-SEP-17', '14-NOV-17');
INSERT INTO History VALUES(201, 106,  '13-SEP-17', '14-NOV-17');

COMMIT;

PROMPT <<<< Table building is complete. >>>>

--Password ohng8z

PROMPT +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

PROMPT Problem 1 For each member (using member_id, lastname and firstname), 
PROMPT find the number of books currently checked out by the member.

             SELECT member.member_id, lastname, firstname, count(*)
             FROM CurrentLoan, Member
             WHERE CurrentLoan.member_id = member.member_id
             GROUP BY member.member_id, lastname, firstname;
          

PROMPT +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

PROMPT Problem 2 List the ISBN and title of the books with at least two copies


SELECT isbn, title 
FROM Book  
GROUP BY (isbn, title)
HAVING COUNT(isbn) > 1;


PROMPT +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

PROMPT Problem 3 Create a view call  that includes member_id, lastname, firstname, book_id,
PROMPT  and title, that shows which member has borrowed which book, including currently and in the past. 

CREATE VIEW member_book as 
     (SELECT Member.member_id, Member.lastname, Member.firstname, CurrentLoan.book_id, Book.title 
        FROM Member , CurrentLoan , Book 
        WHERE CurrentLoan.book_id = Book.book_id 
        AND Member.member_id = CurrentLoan.member_id) 
     UNION 
     (SELECT Member.member_id, Member.lastname, Member.firstname, History.book_id, Book.title 
        FROM Member, History, Book 
        WHERE Book.book_id = History.book_id 
        AND Member.member_id = History.member_id);


PROMPT +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

PROMPT Problem 4 Use the view to find the book_id and title of all the books 
PROMPT checked out by John Smith in the past or currently


SELECT book_id, title 
FROM member_book 
WHERE firstname ='John' AND lastname ='Smith';


PROMPT +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

PROMPT Problem 5 DELETE member David Jones and all the relevant records. 
PROMPT Make sure you DELETE related tuples FROM all the relevant relations, and DELETE them in the right order.


SELECT *
FROM Member;

DELETE
FROM CurrentLoan
WHERE (CurrentLoan.member_id) 
IN
        (SELECT Member.member_id 
         FROM Member
         WHERE lastname='Jones' and firstname='David'
         );
DELETE
FROM History    
WHERE (History.member_id) 
IN
        (SELECT Member.member_id
         FROM Member
         WHERE lastname='Jones' and firstname='David'
         );
DELETE
FROM Member
WHERE lastname ='Jones' and firstname ='David';

SELECT *
FROM Member;





PROMPT +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

PROMPT Problem 6  Increase the booklimit by 2 for all members, but the maximum booklimit is 10. 
PROMPT Display the member _id and the booklimit for each member before and after you make the changes.

SELECT member_id, booklimit
FROM Member;

UPDATE Member
SET booklimit = 10
WHERE booklimit > 8;

UPDATE Member
SET booklimit = booklimit + 2
WHERE booklimit < 9;


SELECT member_id, booklimit
FROM Member;
