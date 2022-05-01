#CREATE DATABASE :
DROP DATABASE IF EXISTS  NUTFLUX_PROJECT;
CREATE DATABASE NUTFLUX_PROJECT;
USE NUTFLUX_PROJECT;
#-------------------------------------------------------------------------------------#
#CREATE USERS - PRO AND CASUAL AND DBA
CREATE USER  IF NOT EXISTS 'APOORVA'@'Apoorva' IDENTIFIED BY 'DBA';
CREATE USER  IF NOT EXISTS 'PRO_USER'@'Apoorva' IDENTIFIED BY 'pro12345';
CREATE USER  IF NOT EXISTS 'CASUAL_USER'@'Apoorva' IDENTIFIED BY 'cas12345';

#GRANT PRIVILEGES

GRANT ALL PRIVILEGES ON NUTFLUX_PROJECT TO 'APOORVA'@'Apoorva' WITH GRANT OPTION;
GRANT ALL PRIVILEGES ON NUTFLUX_PROJECT TO 'PRO_USER'@'Apoorva' WITH GRANT OPTION;
GRANT SELECT ON * TO 'CASUAL_USER'@'Apoorva' WITH GRANT OPTION;
FLUSH PRIVILEGES;
#-------------------------------------------------------------------------------------#

#CREATE DIMENSION TABLES 
CREATE TABLE TITLES (
    TIT_ID INT PRIMARY KEY AUTO_INCREMENT NOT NULL,
    TIT_NAME CHAR(250),
    START_DATE INT,
    END_DATE INT,
    RUNTIME INT,
    ISADULT BOOLEAN,
    ISSERIES BOOLEAN,
    IMDB_RATING FLOAT,
	TAGLINE CHAR(250)  NOT NULL
    );

CREATE TABLE TRIVIA (
TIT_ID INT NOT NULL,
TRIVIA_FACT CHAR(250) NOT NULL,
 FOREIGN KEY (TIT_ID)
        REFERENCES TITLES (TIT_ID)
) ;
CREATE TABLE DIRECTORS (
    DIR_NAME CHAR(250) UNIQUE PRIMARY KEY NOT NULL,
    DEBUT_YEAR INT,
    NATIONALITY CHAR(250),
    KNOWN_FOR TEXT,
    GENDER CHAR(10)
);

CREATE TABLE PRODUCERS (
    PRODUCER_NAME CHAR(250) UNIQUE PRIMARY KEY NOT NULL,
	GENDER CHAR(10)
);

CREATE TABLE WRITERS (
    WRITER_NAME CHAR(250) UNIQUE PRIMARY KEY NOT NULL,
    KNOWN_FOR TEXT,
    GENDER CHAR(10)
);

CREATE TABLE TV_EPISODE (
  EPI_TITLE CHAR(250) NOT NULL PRIMARY KEY,
  EPI_SYNOPSIS TEXT, 
  PARENT_TV_ID INT,
  DIRECTOR_ID CHAR(250),
  SEASON_NUM INT,
  EPI_NUM INT,
  FOREIGN KEY (PARENT_TV_ID)
        REFERENCES TITLES (TIT_ID),
  FOREIGN KEY (DIRECTOR_ID)
		references directors(DIR_NAME)
);

CREATE TABLE CELEB (
    CELEB_NAME CHAR(250) NOT NULL UNIQUE PRIMARY KEY,
    DEBUT_YEAR INT,
    NATIONALITY CHAR(250),
    GENDER CHAR(10)
);

CREATE TABLE ROLES (
	ROLE_ID INT NOT NULL UNIQUE AUTO_INCREMENT PRIMARY KEY,
	ROLE_NAME CHAR(250) NOT NULL UNIQUE
);

CREATE TABLE CATEGORY (
	CATEGORY_ID INT NOT NULL UNIQUE AUTO_INCREMENT PRIMARY KEY,
	CATEGORY CHAR(250) NOT NULL UNIQUE
);
CREATE TABLE AWARDS (
	AWARD_ID INT NOT NULL UNIQUE AUTO_INCREMENT PRIMARY KEY,
    AWARD_NAME CHAR(250) NOT NULL,
    AWARD_TYPE  CHAR(250) NOT NULL 
);

#------------------------------------------------------------------#
#RELATIONS TABLES 
CREATE TABLE TITLE_GENRE (
	TIT_ID INT NOT NULL,
    MAIN_GENRE CHAR(250) NOT NULL,
    SUB_GENRE  CHAR(250),
    FOREIGN KEY (TIT_ID)
        REFERENCES TITLES (TIT_ID),
	PRIMARY KEY (TIT_ID, MAIN_GENRE) #COMPOSITE KEY MOVIE AND MAIN GENRE
);

CREATE TABLE ROLE_CATEGORY (
	CATEGORY_ID INT NOT NULL,
	ROLE_ID INT NOT NULL,
	FOREIGN KEY (CATEGORY_ID)
        REFERENCES CATEGORY (CATEGORY_ID),
	FOREIGN KEY (ROLE_ID)
        REFERENCES ROLES (ROLE_ID),
	PRIMARY KEY (CATEGORY_ID, ROLE_ID) #COMPOSITE KEY FOR EACH CATEGORY TO A ROLE
);

CREATE TABLE CASTING_INFORMATION (
  TIT_ID INT NOT NULL,
  CELEB_NAME CHAR(250) NOT NULL,
  ROLE_ID INT NOT NULL,  
  IS_FAMOUS_FOR BOOLEAN,
  FOREIGN KEY (TIT_ID)
        REFERENCES TITLES (TIT_ID),
  FOREIGN KEY (CELEB_NAME)
        REFERENCES CELEB (CELEB_NAME),
  FOREIGN KEY (ROLE_ID)
        REFERENCES ROLES (ROLE_ID),
  PRIMARY KEY (TIT_ID,CELEB_NAME)  #COMPOSITE KEY OF MOVIE AND EACH OF ITS ACTOR  
  );
  
CREATE TABLE TITLE_DIRECTOR (
	TIT_ID INT NOT NULL,
    DIR_NAME CHAR(250) NOT NULL,
    FOREIGN KEY (TIT_ID)
        REFERENCES TITLES (TIT_ID),
	FOREIGN KEY (DIR_NAME)
        REFERENCES DIRECTORS (DIR_NAME),
	PRIMARY KEY (TIT_ID,DIR_NAME)  #COMPOSITE KEY OF MOVIE AND DIRECTOR PAIRING 
);

CREATE TABLE TITLE_PRODUCER (
	TIT_ID INT NOT NULL,
    PRODUCER CHAR(250) NOT NULL,
    FOREIGN KEY (TIT_ID)
        REFERENCES TITLES (TIT_ID),
	FOREIGN KEY (PRODUCER)
        REFERENCES PRODUCERS (PRODUCER_NAME),
	PRIMARY KEY (TIT_ID,PRODUCER)  #COMPOSITE KEY OF MOVIE AND PRODUCER PAIRING 
    );

CREATE TABLE TITLE_WRITER (
	TIT_ID INT NOT NULL,
    WRITER CHAR(250) NOT NULL,
    FOREIGN KEY (TIT_ID)
        REFERENCES TITLES (TIT_ID),
	FOREIGN KEY (WRITER)
        REFERENCES WRITERS (WRITER_NAME),
	PRIMARY KEY (TIT_ID,WRITER)  #COMPOSITE KEY OF MOVIE AND WRITER PAIRING 
);

CREATE TABLE MOVIE_AWARDS (
	TIT_ID INT NOT NULL,
    AWARD_ID INT NOT NULL,
    IS_NOMINEE BOOLEAN,
    FOREIGN KEY (TIT_ID)
        REFERENCES TITLES (TIT_ID),
	FOREIGN KEY (AWARD_ID)
        REFERENCES AWARDS (AWARD_ID),
	PRIMARY KEY (TIT_ID,AWARD_ID) #PAIRING MOVIE WITH EACH AWARD
);

CREATE TABLE CELEB_AWARDS (
	CELEB_NAME CHAR(250) NOT NULL,
    TIT_ID INT NOT NULL,
    AWARD_ID INT NOT NULL,
    IS_NOMINEE BOOLEAN,
    FOREIGN KEY (CELEB_NAME)
        REFERENCES CELEB (CELEB_NAME),
	FOREIGN KEY (TIT_ID)
        REFERENCES TITLES (TIT_ID),
	FOREIGN KEY (AWARD_ID)
        REFERENCES AWARDS (AWARD_ID)
);

CREATE TABLE DIRECTOR_AWARDS (
	DIR_NAME CHAR(250) NOT NULL,
    TIT_ID INT NOT NULL,
    AWARD_ID INT NOT NULL,
    IS_NOMINEE BOOLEAN,
    FOREIGN KEY (DIR_NAME)
        REFERENCES DIRECTORS (DIR_NAME),
	FOREIGN KEY (TIT_ID)
        REFERENCES TITLES (TIT_ID),
	FOREIGN KEY (AWARD_ID)
        REFERENCES AWARDS (AWARD_ID)
);
CREATE TABLE WRITER_AWARDS (
	WRITER_NAME CHAR(250) NOT NULL,
    TIT_ID INT NOT NULL,
    AWARD_ID INT NOT NULL,
    IS_NOMINEE BOOLEAN,
    FOREIGN KEY (WRITER_NAME)
        REFERENCES WRITERS (WRITER_NAME),
	FOREIGN KEY (TIT_ID)
        REFERENCES TITLES (TIT_ID),
	FOREIGN KEY (AWARD_ID)
        REFERENCES AWARDS (AWARD_ID)
);

  CREATE TABLE ACTOR_RELATIONS( 
	CON_ID INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
	CELEB1 CHAR(250) NOT NULL,
    CELEB2 CHAR(250) NOT NULL,
    RELATION CHAR(250) NOT NULL,
    YEAR_OF_RELATION INT NOT NULL,
    FOREIGN KEY (CELEB1) 
		REFERENCES CELEB (CELEB_NAME),
	FOREIGN KEY (CELEB2) 
		REFERENCES CELEB(CELEB_NAME)
);
#--------------------------------------------------------------------------------------------------------------------#
#Triggers  on insert on my DB. 

#TRIGGER -1 
#UPDATE DIRECTOR HEADLINES AFTER HIS MOVIE WINS AN AWARD : 
DROP TRIGGER IF EXISTS Update_head_line_after_award_Dir;
DELIMITER //
CREATE TRIGGER Update_head_line_after_award_Dir 
AFTER INSERT ON DIRECTOR_AWARDS FOR EACH ROW BEGIN 
UPDATE 
  DIRECTORS 
SET 
  KNOWN_FOR = CONCAT(
    "Awarded as Best Director for directing ", 
    (
      select concat(TIT_NAME, ' (', START_DATE, ')') 
      FROM TITLES 
      WHERE TIT_ID = new.tit_id
    )) 
WHERE 
  DIR_NAME = NEW.DIR_NAME AND NEW.IS_NOMINEE = 1;
UPDATE DIRECTORS 
SET KNOWN_FOR = CONCAT("Nominated for Best Director for directing ", 
	(
    select concat(TIT_NAME, ' (', START_DATE, ')') 
      FROM TITLES 
      WHERE TIT_ID = new.tit_id
    )) 
WHERE 
  DIR_NAME = NEW.DIR_NAME AND NEW.IS_NOMINEE = 0;
END //
DELIMITER ;

#TRIGGER - 2 
#UPDATE WRITER HEADLINES AFTER HIS MOVIE WINS AN AWARD : 
DROP TRIGGER IF EXISTS Update_head_line_after_award_writer ;
DELIMITER //
CREATE TRIGGER Update_head_line_after_award_writer 
AFTER INSERT ON WRITER_AWARDS FOR EACH ROW BEGIN 
UPDATE WRITERS 
SET KNOWN_FOR = CONCAT("Awarded as Best Writer for writing ", 
    (select concat(TIT_NAME, ' (', START_DATE, ')') 
    FROM TITLES 
	WHERE TIT_ID = new.tit_id)
  ) 
WHERE WRITER_NAME = NEW.WRITER_NAME AND NEW.IS_NOMINEE = 1;
UPDATE WRITERS 
SET KNOWN_FOR = CONCAT(
    "Nomited for Best Writer for writing ", 
    (select concat(TIT_NAME, ' (', START_DATE, ')') 
      FROM TITLES 
      WHERE TIT_ID = new.tit_id)
  ) 
WHERE WRITER_NAME = NEW.WRITER_NAME 
  AND NEW.IS_NOMINEE = 0;
END //
DELIMITER ;

#--------------------------------------------------------------------------------------------------------------------#
#INSERT 
INSERT INTO TITLES (TIT_NAME,START_DATE,END_DATE,RUNTIME,ISADULT,ISSERIES,IMDB_RATING,TAGLINE) VALUES
("Good Will Hunting",1997,1997,126,0,0,8.3,'Some people can never believe in themselves, until someone believes in them'),
('Argo',2012,2012,120, 0,  0, 7.7, 'The movie was fake, the mission was real'),
('Sherlock Holmes',2009,2009,128,0,0,7.6,"Nothing Escapes Him"),
('Sherlock',2010,2017,88,0,1,9.1,'The Game is On'),
('Manhattan',1979,1979,99,0,0,8,'Woody Allens New Comedy Hit'),
("The Godfather", 1972, 1972,177, 1, 0, 9.2,"An offer you can't refuse"),
("Dune",  2021, 2021, 155, 0, 0, 8.1,"A world beyond your experience, beyond your imagination. A place beyond your dreams. A movie beyond your imagination."),
("Dune", 1984,1984,175, 0,0, 6.3, "A Duke's son leads desert warriors against the galactic emperor and his father's evil nemesis to free their desert world from the emperor's rule."),
("Titanic",  1997, 1997,  214, 0, 0, 7.9,"Nothing On Earth Could Come Between Them"),
("Fight Club", 1999, 1999, 139, 1, 0, 8.8, "How much can you know about yourself if you've never been in a fight?"),
("A Quiet Place", 2018, 2018, 90, 0, 0, 7.5, "Listen closely, move carefully, and never make a sound. If they can't hear you, they can't hunt you."),
("Stranger Things", 2016, 2022, 44, 0, 1, 8.7, "It only gets stranger..."),
("The Amazing Spider-Man",  2012, 2012, 136, 0, 0, 6.9, "The untold story begins.");


INSERT INTO TRIVIA (TIT_ID, TRIVIA_FACT) VALUES
(1,'In 2014, after Robin Williams died, the bench in the Boston Public Garden where he and Matt Damon had their conversation scene became an impromptu memorial site.'),
(2,'For the opening scene, the director of photography gave 8mm cameras out to certain people in the crowd to make the opening scene have what would seem like this was actual footage from the riot.'),
(3,"Watson's line to Holmes, 'You know that what you're drinking is for eye surgery?', is an obscure reference to Holmes' cocaine usage."),
(4,'The character of Greg Lestrade is a combination of Inspectors Gregson and Lestrade.'),
(5, "Meryl Streep shot her scenes during breaks in filming Kramer vs. Kramer (1979)."),
(6, "Cinematographer Gordon Willis earned himself the nickname The Prince of Darkness, since his sets were so underlit."),
(7, "David Lynch, director of the previous Dune (1984), stated that he has zero interest in Dune (2021). "),
(8, "Writer and director David Lynch turned down Star Wars: Episode VI - Return of the Jedi (1983) to direct this movie, telling George Lucas, 'It's your thing, it's not my thing.'"),
(9, "The elderly couple seen hugging on the bed while water floods their room were the owners of Macys department store in New York, Rosalie Ida Straus and Isidor Straus, both of whom died on the Titanic. "),
(10, "Author Chuck Palahniuk first came up with the idea for the novel after being beaten up on a camping trip when he complained to some nearby campers about the noise of their radio. "),
(11, "Actress Millicent Simmonds has been deaf since infancy due to a medication overdose. This was the second film she starred in, with Wonderstruck (2017) being her first."),
(12, "The set for Starcourt Mall in season 3 is a real derelict mall on the outskirts of Atlanta called Gwinnett Place Mall."),
(13, "When first wearing the Spider-Man costume Andrew Garfield admitted to shedding tears.")
;

INSERT INTO CELEB (CELEB_NAME,DEBUT_YEAR,NATIONALITY,GENDER) VALUES 
("Robin Williams",1980,"American",'Male'),
("Ben Affleck",1993,"American",'Male'),
("Matt Damon",1988,"American",'Male'),
('Bryan Cranston',1983,'American','Male'),
('Robert Downey Jr',1970,'American','Male'),
('Jude Law',1992,'British','Male'),
('Benedict Cumberbatch',2006,'British','Male'),
('Martin Freeman',1997,'British','Male'),
("Woody Allen", 1950,  "American","Male"),
("Diane Keaton",1970, 'American', "Female"),
("Marlon Brando", 1949,'American' ,"Male"),
("Timothée Chalamet",2007, "American", "Male"),
("Kyle Maclachan",1984,'American','Male'),
("Leonardo DiCaprio",2004, "American","Male"),
("Brad Pitt",2006, "American","Male"),
("John Krasinski",2001,"American",'Male'),
("Emily Blunt", 2003,'British',"Female"),
("Winona Ryder", 1986, 'American', "Female"),
('Millie Bobby Brown',2016,'British','Female'),
("Andrew Garfield",2005, 'American', "Male");

INSERT INTO DIRECTORS (DIR_NAME,DEBUT_YEAR,NATIONALITY,KNOWN_FOR,GENDER) VALUES 
("Gus Van Sant",1952,"American",NULL,'Male'),
('Ben Affleck',2007,'American',NULL,'Male'),
("Guy Ritchie",1995,"American",NULL,'Male'),
("Mark Gatiss",2004,"British",NULL,'Male'),
("Steven Moffat",1989,"British",NULL,'Male'),
("Woody Allen",1935, "American",NULL ,"Male"),
("Francis Ford Coppola", 1939,"American",NULL ,"Male"),
("Denis Villeneuve", 1967,"American",NULL ,"Male"),
("James Cameron", 1954,"American",NULL ,"Male"),
("David Lynch",1989,"American",NULL,"Male"),
("David Fincher", 1962,"American",NULL ,"Male"),
("John Krasinski", 1979, "American",NULL ,"Male"),
("Matt Duffer",1984,"American",NULL ,"Male"),
("Marc Webb", 1974, "American",NULL ,"Male")
;

INSERT INTO WRITERS (WRITER_NAME,KNOWN_FOR,GENDER) VALUES
("Matt Damon",NULL,'Male'),
("Ben Affleck",NULL,'Male'),
('Chriss Terrio',NULL,'Male'),
('Michael Robert Johnson',NULL,'Male'),
('Anthony Peckman',NULL,'Male'),
('Simon Kinberg',NULL,'Male'),
('Mark Gatiss',NULL,'Male'),
('Steven Moffat',NULL,'Male'),
("Woody Allen",NULL, 'Male'),
("Mario Puzo",NULL, 'Male'),
("Francis Ford Coppola",NULL,'Male'),
("Denis Villeneuve",NULL, 'Male'),
("David Lynch",NULL,'Male'),
("James Cameron",NULL, 'Male'),
("Chuck Palahniuk",NULL, 'Male'),
("John Krasinski",NULL, 'Male'),
("Matt Duffer",NULL, 'Male'),
("James Vanderbilt",NULL, 'Male')
;
INSERT INTO PRODUCERS (PRODUCER_NAME,GENDER) VALUES
("Lawrence Bender","Male"),
('Ben Affleck','Male'),
('Grant Heslov','Male'),
('George Clooney','Male'),
('Joel Silver','Male'),
('Lionel Wigram','Male'),
('Susan Downey','Female'), 
('Dan Lin','Male'),
('Sue Vertue','Female'),
('Elaine Cameron','Female'),
('Charles Joffe','Male'),
('Francis Ford Coppola','Male'),
('Denis Villeneuve', 'Male'),
('Raffaella De Laurentiis','Female'),
('James Cameron','Male'),
('Art Linson','Male'),
('John Krasinski','Male'),
('Shawn Levy','Male'),
('Laura Ziskin','Female');

INSERT INTO TV_EPISODE (EPI_TITLE,EPI_SYNOPSIS,PARENT_TV_ID,DIRECTOR_ID,SEASON_NUM,EPI_NUM) VALUES
('A study in Pink','War vet Dr. John Watson returns to London in need of a place to stay. He meets Sherlock Holmes, a consulting detective, and the two soon find themselves digging into a string of serial "suicides."',4,"Steven Moffat",1,1),
('The Blind Banker','Mysterious symbols and murders are showing up all over London, leading Sherlock and John to a secret Chinese crime syndicate called Black Lotus.',4,"Steven Moffat",1,2),
('The Great Game','Mysterious symbols and murders are showing up all over London, leading Sherlock and John to a secret Chinese crime syndicate called Black Lotus.',4,"Steven Moffat",1,3),
('A Scandal in Belgravia','Sherlock must confiscate something of importance from a mysterious woman named Irene Adler.',4,"Steven Moffat",2,1),
('The hounds of Baskerville','Sherlock and John investigate the ghosts of a young man who has been seeing monstrous hounds out in the woods where his father died.',4,"Steven Moffat",2,2),
('The Riechenbach Fall','Jim Moriarty hatches a mad scheme to turn the whole city against Sherlock.',4,"Mark Gatiss",2,3),
('The Empty Hearse','Mycroft calls Sherlock back to London to investigate an underground terrorist organization.',4,"Steven Moffat",3,1),
('The Sign of three','Sherlock tries to give the perfect best man speech at John wedding when he suddenly realizes a murder is about to take place.',4,"Mark Gatiss",3,2),
('His last vow','Sherlock goes up against Charles Augustus Magnussen, media tycoon and a notorious blackmailer.',4,"Steven Moffat",3,3),
('The six Thatchers','Sherlock takes on the case of finding out who is going around and smashing six unique head statues of late Prime Minister Margaret Thatcher.',4,"Steven Moffat",4,1),
('The Lying Detective','Sherlock goes up against the powerful and seemingly unassailable Culverton Smith - a man with a very dark secret indeed.',4,"Mark Gatiss",4,2),
('The Final Problem','A dark secret in the Holmes family rears its head with a vengeance, putting Sherlock and friends through a series of sick, manipulative psychological and potentially fatal games.',4,"Mark Gatiss",4,3),
('Chapter One: The Vanishing of Will Byers', 'At the U.S. Dept. of Energy an unexplained event occurs.',12,"Matt Duffer",1,1),
('Chapter Two: The Weirdo on Maple Street','Mike hides the mysterious girl in his house. Joyce gets a strange phone call.',12,"Matt Duffer",1,2),
('Chapter Three: Holly, Jolly','',12,"Matt Duffer",1,3),
('Chapter Four: The Body','',12,"Matt Duffer",1,4),
('Chapter Five: The Flea and the Acrobat','',12,"Matt Duffer",1,5),
('Chapter Six: The Monster','',12,"Matt Duffer",1,6),
('Chapter Seven: The Bathtub','',12,"Matt Duffer",1,7),
('Chapter Eight: The Upside Down','',12,"Matt Duffer",1,8),
('Chapter One: MADMAX','',12,"Matt Duffer",2,1),
('Chapter Two: Trick or Treat, Freak','',12,"Matt Duffer",2,2),
('Chapter Three: The Pollywog','',12,"Matt Duffer",2,3),
('Chapter Four: Will the Wise','',12,"Matt Duffer",2,4),
('Chapter Five: Dig Dug','',12,"Matt Duffer",2,5),
('Chapter Six: The Spy','',12,"Matt Duffer",2,6),
('Chapter Seven: The Lost Sister','',12,"Matt Duffer",2,7),
('Chapter Eight: The Mind Flayer','',12,"Matt Duffer",2,8);

INSERT INTO ROLES(ROLE_NAME) VALUES
("Sean"),
("Will"),
("Chuckie"),
("Tony Mendez"),
("Jack O'Donnel"),
("Sherlock Holmes"),
("Dr. Watson"),
("Isaac"),
("Mary"),
("Don Vito Corleone"),
("Paul Atreides"),
("Jack Dawson"),
("James Bond"),
("Tyler Durden"),
("Lee Abbott"),
("Evelyn Abbott"),
("Joyce Byers"),
("Eleven"),
("Spider-Man")
;

INSERT INTO CATEGORY(CATEGORY) VALUES 
("Lawyer"),
("Teacher"),
("Student"),
("Hero"),
("Anti-hero"),
("Detective"),
("Playboy"),
("Spy"),
("Alien"),
("Superhero"),
("Philanthropist"),
("CEO"),
("Thief"),
("Archer"),
("Doctor"),
("Magician"),
("Villain"),
("Politician"),
("Comedian"),
("Singer"),
("Artist"),
("Mother")
;

INSERT INTO AWARDS (AWARD_NAME ,AWARD_TYPE) VALUES 
("Oscar","Best Writing"),
("Oscar","Best Screenpaly"),
("Oscar","Best Picture"),
("Oscar","Best Actor"),
("Oscar","Best Director"),
("Screen Actors Guild Awards","Outstanding Performance by Actor"),
("Screen Actors Guild Awards","Outstanding Performance by a Cast"),
('Golden Globe','Best Director'),
('Golden Globe','Best Motion Picture'),
('Golden Globe','Best Writing'),
('Golden Globe','Best Actor'),
('BAFTA AWARD','Best Film'),
('BAFTA AWARD','Best Direction'),
('BAFTA AWARD','Best Actor'),
('EMMY','Outstanding Actor'),
('EMMY','Outstanding Television Movie'),
('EMMY', 'Outstanding Writing'),
('EMMY', 'Outstanding Directing')
;

INSERT INTO TITLE_GENRE (TIT_ID, MAIN_GENRE, SUB_GENRE) VALUES
(1,"Drama","Romance"),
(2,"Biography","Drama"),
(3,"Action","Adventure"),
(4,"Crime","Drama"),
(5, "Comedy","Romance"),
(6, "Crime","Drama"),
(7, "Action","Adventure"),
(8, "Action","Adventure"),
(9, "Drama","Romance"),
(10, "Drama","Action"),
(11, "Drama","Horror"),
(12, "Drama","Fantasy"),
(13, "Action","Superhero")
;

INSERT INTO ACTOR_RELATIONS(CELEB1,CELEB2 ,RELATION ,YEAR_OF_RELATION) VALUES
("Diane Keaton","Woody Allen",'Dating',1996),
("John Krasinski", "Emily Blunt", "Married",2005);

INSERT INTO TITLE_DIRECTOR (TIT_ID,DIR_NAME) VALUES 
(1,"Gus Van Sant"),
(2,"Ben Affleck"),
(3,"Guy Ritchie"),
(4,"Mark Gatiss"),
(4,"Steven Moffat"),
(5, "Woody Allen"),
(6, "Francis Ford Coppola"),
(7, "Denis Villeneuve"),
(8, "David Lynch"),
(9, "James Cameron"),
(10, "David Fincher"),
(11, "John Krasinski"),
(12, "Matt Duffer"),
(13, "Marc Webb")
;

INSERT INTO TITLE_PRODUCER (TIT_ID,PRODUCER) VALUES 
(1,"Lawrence Bender"),
(2,"Ben Affleck"),
(2,"Grant Heslov"),
(2,"George Clooney"),
(3,'Joel Silver'),
(3,'Lionel Wigram'),
(3,'Susan Downey'), 
(3,'Dan Lin'),
(4,'Sue Vertue'),
(4,'Elaine Cameron'),
(5,'Charles Joffe'),
(8,'Raffaella De Laurentiis'),
(7,"Denis Villeneuve"),
(9,"James Cameron"),
(10,'Art Linson'),
(11,"John Krasinski"),
(13,'Laura Ziskin')
;

INSERT INTO TITLE_WRITER (TIT_ID,WRITER) VALUES 
(1,"Matt Damon"),
(1,"Ben Affleck"),
(2,'Chriss Terrio'),
(3,'Michael Robert Johnson'),
(3,'Anthony Peckman'),
(3,'Simon Kinberg'),
(4,'Mark Gatiss'),
(4,'Steven Moffat'),
(5,"Woody Allen"),
(6,'Mario Puzo'),
(6,'Francis Ford Coppola'),
(7,"Denis Villeneuve"),
(8,'David Lynch'),
(9,"James Cameron"),
(10,"Chuck Palahniuk"),
(11,"John Krasinski"),
(12,'James Vanderbilt')
;

INSERT INTO ROLE_CATEGORY (CATEGORY_ID,ROLE_ID) VALUES 
(2,1),
(3,2),
(3,3),
(4,4),
(8,4),
(8,5),
(4,6),
(6,6),
(15,7),
(18,8),
(19,9),
(4,10),
(4,11),
(20,12),
(4,12),
(4,13),
(8,13),
(5,14),
(7,14),
(4,15),
(4,16),
(21,16),
(21,17),
(4,18),
(9,18),
(10,19);

INSERT INTO CASTING_INFORMATION (TIT_ID,CELEB_NAME,ROLE_ID,IS_FAMOUS_FOR) VALUES
(1,"Robin Williams",1,0),
(1,"Matt Damon",2,0),
(1,"Ben Affleck",3,0),
(2,"Ben Affleck",4,0),
(2,"Bryan Cranston",5,0),
(3,"Robert Downey Jr",6,1),
(3,"Jude Law",7,0),
(4,"Benedict Cumberbatch",6,1),
(4,"Martin Freeman",7,1),
(5,"Diane Keaton",9,0),
(5,"Woody Allen",8,0),
(6,"Marlon Brando",10,1),
(7,'Kyle Maclachan',11,0),
(8,'Timothée Chalamet',11,0),
(9,'Leonardo DiCaprio',12,1),
(10,"Brad Pitt",14,0),
(11,"John Krasinski",15,0),
(11,"Emily Blunt",16,0),
(12,"Millie Bobby Brown",18,1),
(12,"Winona Ryder",17,1),
(13,"Andrew Garfield",19,1);

INSERT INTO MOVIE_AWARDS (TIT_ID,AWARD_ID,IS_NOMINEE) VALUES 
(1,3,1),
(2,3,1),
(2,12,1),
(4,16,1),
(5,4,1),
(5,12,1),
(6,3,1),
(7,3,0),
(9,3,1),
(10,12,1),
(13,12,0);

INSERT INTO WRITER_AWARDS (TIT_ID,WRITER_NAME,AWARD_ID,IS_NOMINEE) VALUES 
(1,"Ben Affleck",1,0),
(2,"Chriss Terrio",1,1),
(4,"Steven Moffat",17,1),
(5,"Woody Allen",1,1),
(5,"Woody Allen",17,1),
(6,"Mario Puzo",1,1),
(7,"Denis Villeneuve",17,0),
(11,"John Krasinski",17,0);

INSERT INTO CELEB_AWARDS (TIT_ID,CELEB_NAME,AWARD_ID,IS_NOMINEE) VALUES 
(1,"Matt Damon",4,1),
(2,"Ben Affleck",14,0),
(3,"Robert Downey Jr",11,0),
(3,"Jude Law",11,0),
(4,"Benedict Cumberbatch",16,1),
(4,"Benedict Cumberbatch",14,1),
(5,"Diane Keaton",4,1),
(5,"Woody Allen",4,0),
(6,"Marlon Brando",4,1),
(9,"Leonardo DiCaprio",4,0),
(10,"Brad Pitt",14,1),
(11,"Emily Blunt",6,0);

INSERT INTO DIRECTOR_AWARDS (TIT_ID,DIR_NAME,AWARD_ID,IS_NOMINEE) VALUES 
(1,"Gus Van Sant",5,1),
(2,"Ben Affleck",13,1),
(3,"Guy Ritchie",8,0),
(5,"Woody Allen",5,1),
(5,"Woody Allen",13,1),
(6, "Francis Ford Coppola",5,1),
(9,"James Cameron",5,1),
(10,"David Fincher",13,1);

#CHECKING TABLE AFTER INSERT TO VERIFY THAT TRIGGERS WORKED : 
#TRIGGER - 1
SELECT * from DIRECTORS where KNOWN_FOR is not NULL;

#TRIGGER - 2
SELECT * from WRITERS where KNOWN_FOR is not NULL;


#--------------------------------------------------------------------------------------------------------------------#
#VIEWS# 
#VIEW - 1 
#Mapping Celebs to their roles 
DROP 
  VIEW IF EXISTS CELEB_ROLES;
CREATE VIEW CELEB_ROLES AS 
select 
  c.celeb_name CELEBRITY, 
  ROLE_NAME ROLE_PLAYED, 
  tit_name MOVIE 
from 
  casting_information c 
  JOIN celeb a ON a.celeb_name = c.celeb_name 
  JOIN roles r ON r.role_id = c.role_id 
  JOIN titles m ON m.tit_id = c.tit_id;
SELECT * from CELEB_ROLES;

#VIEW - 2 
#AWARD WINNING DIRECTORS 
DROP 
  VIEW IF EXISTS AWARDED_DIRECTORS;
CREATE VIEW AWARDED_DIRECTORS AS 
SELECT distinct
  DIR_NAME DIRECTOR, 
  TIT_NAME MOVIE 
from 
  DIRECTOR_AWARDS A 
  JOIN TITLEs T ON T.TIT_ID = A.TIT_ID 
WHERE 
  IS_NOMINEE = 1;

SELECT * FROM AWARDED_DIRECTORS;

#VIEW - 3
#TRIVIA VIEW
DROP VIEW IF EXISTS TRIVIA_VIEW;
CREATE VIEW TRIVIA_VIEW AS
SELECT distinct 
	t.tit_id,
	Tit_name MOVIE,
    Trivia_fact TRIVIA
from 
	TITLES atit
	JOIN TRIVIA t on atit.tit_id = t.tit_id;
Select * from TRIVIA_VIEW;

#VIEW - 4
#HOW MANY WORKS ARE AWARD WINNERS
DROP VIEW IF EXISTS AWARDED_TITLES;
CREATE VIEW AWARDED_TITLES AS 
SELECT 
  t.TIT_ID, 
  TIT_NAME, 
  AWARD_NAME, 
  AWARD_TYPE 
FROM 
  TITLES t 
  JOIN MOVIE_AWARDS ma on ma.tit_id = t.tit_id 
  JOIN AWARDS a on a.award_id = ma.award_id 
UNION 
SELECT 
  t.TIT_ID, 
  TIT_NAME, 
  AWARD_NAME, 
  AWARD_TYPE 
FROM 
  TITLES t 
  JOIN DIRECTOR_AWARDS ma on ma.tit_id = t.tit_id 
  JOIN AWARDS a on a.award_id = ma.award_id 
UNION 
SELECT 
  t.TIT_ID, 
  TIT_NAME, 
  AWARD_NAME, 
  AWARD_TYPE 
FROM 
  TITLES t 
  JOIN WRITER_AWARDS ma on ma.tit_id = t.tit_id 
  JOIN AWARDS a on a.award_id = ma.award_id 
UNION 
SELECT 
  t.TIT_ID, 
  TIT_NAME, 
  AWARD_NAME, 
  AWARD_TYPE 
FROM 
  TITLES t 
  JOIN CELEB_AWARDS ma on ma.tit_id = t.tit_id 
  JOIN AWARDS a on a.award_id = ma.award_id 
order by 
  1;
select * from AWARDED_TITLES;

#--------------------------------------------------------------------------------------------------------------------#
#STORED PROCEDURE - 1 
#GETTING TOP MOVIES BASED ON GENRE : 
#Input : (GENRE, NO OF MOVIES) 
DROP PROCEDURE IF EXISTS GET_BEST_MOVIES_OF_A_GENRE;
DELIMITER //
CREATE PROCEDURE  GET_BEST_MOVIES_OF_A_GENRE(GENRE CHAR(250),no_of_movies int)
BEGIN
    SELECT TIT_NAME,IMDB_RATING
    FROM TITLES t
    LEFT JOIN TITLE_GENRE tg on tg.tit_id = t.tit_id 
    Where MAIN_GENRE = GENRE and isseries = 0
	ORDER BY IMDB_RATING desc
	LIMIT no_of_movies;
END //
DELIMITER ;

CALL GET_BEST_MOVIES_OF_A_GENRE("Drama",4);


#STORED PROCEDURE - 2 
#GETTING TOP RATED MOVIES OF EVERY YEAR  : 
#Input : (FROM YEAR, TO YEAR)
DROP PROCEDURE IF EXISTS GET_TOP_BEST_RATED_MOVIES_OF_EACH_YEAR;
DELIMITER //
CREATE PROCEDURE  GET_TOP_BEST_RATED_MOVIES_OF_EACH_YEAR(start_year int,end_year int)
BEGIN
    SELECT TIT_NAME as MOVIE, start_date as 'Year', IMDB_RATING FROM
	(
	SELECT TIT_NAME,IMDB_RATING,start_date,row_number() over (partition by start_date order by IMDB_RATING desc) topmovie
    FROM TITLES
    Where start_date between start_year and end_year
    and isseries = 0
	ORDER BY start_date,IMDB_RATING desc
	) a
WHERE topmovie = 1;
END //
DELIMITER ;

CALL GET_TOP_BEST_RATED_MOVIES_OF_EACH_YEAR(1990,2022);

#--------------------------------------------------------------------------------------------------------------------#
#QUERIES 
#1 Which role is each celebrity known for?
select 
  c.celeb_name CELEBRITY, 
  ROLE_NAME ROLE_PLAYED, 
  tit_name MOVIE 
from 
  casting_information c 
  JOIN celeb a ON a.celeb_name = c.celeb_name 
  JOIN roles r ON r.role_id = c.role_id 
  JOIN titles m ON m.tit_id = c.tit_id 
  JOIN TITLE_GENRE tg on tg.tit_id = m.tit_id 
where 
  C.IS_FAMOUS_FOR = 1;


#2 Award winning American Actors
select 
  c.celeb_name CELEBRITY, 
  aa.AWARD_NAME, 
  aa.award_type 
from 
  CELEB_AWARDS c 
  JOIN celeb a ON a.celeb_name = c.celeb_name 
  join awards aa on aa.award_id = c.award_id 
WHERE 
  a.nationality = 'American' and c.is_nominee = 1;


#3 Award winning works that are produced by female producers : 
select 
  PRODUCER_NAME, 
  TIT_NAME 
FROM 
  TITLES t 
  JOIN MOVIE_AWARDS ma on ma.TIT_ID = t.tit_ID 
  JOIN TITLE_PRODUCER tp on t.TIT_ID = tp.TIT_ID 
  JOIN PRODUCERS p on p.PRODUCER_NAME = tp.PRODUCER 
where 
  p.Gender = 'Female' 
order by 2;

#4 How many directors are also producers of a movie?
SELECT 
  TIT_NAME TITLE, 
  DIR_NAME DIRECTOR, 
  PRODUCER 
from 
  Titles t 
  JOIN TITLE_DIRECTOR td on td.tit_id = t.tit_id 
  JOIN TITLE_PRODUCER tp on tp.PRODUCER = td.DIR_NAME 
  and tp.tit_id = td.tit_id;


#5 How many actors have been directors and producers of their movie?
SELECT 
  tit_name Title, 
  c.CELEB_NAME ACTOR, 
  tp.producer PRODUCER, 
  td.DIR_NAME DIRECTOR 
from 
  TITLES t 
  join TITLE_PRODUCER tp on tp.tit_id = t.tit_id 
  join casting_information c on tp.producer = c.celeb_name 
  and c.tit_id = t.tit_id 
  JOIN TITLE_DIRECTOR td on tp.PRODUCER = td.DIR_NAME 
  and tp.tit_id = td.tit_id;


#6 All films with starring two actors that are socially connected?
SELECT 
  T.tit_name MOVIE, 
  celeb1 ACTOR1, 
  celeb2 ACTOR2 
FROM 
  TITLES t 
  JOIN CASTING_INFORMATION c1 on c1.tit_id = t.tit_id 
  JOIN CELEB cb1 on cb1.celeb_name = c1.celeb_name 
  JOIN ACTOR_RELATIONS ar on ar.celeb1 = cb1.celeb_name 
  JOIN CASTING_INFORMATION c2 on c1.tit_id = c2.tit_id 
  and ar.celeb2 = c2.celeb_name 
group by 
  t.tit_name;


#7 Count of awards per genre
#Using view AWARDED_TITLES for this query :
select 
  MAIN_GENRE, 
  count(AWARD_NAME) NO_OF_AWARDS
from 
  AWARDED_TITLES a 
  JOIN TITLE_GENRE g on g.tit_id = a.tit_id 
group by
  MAIN_GENRE 
order by 
  2 desc;

#8 Duration, and no of episodes for all TV shows 
select 
  tit_name SERIES_NAME, 
  start_date, 
  end_Date,
  count(EPI_TITLE) NO_OF_EPISODES 
from 
  TITLES t 
  join TV_EPISODE e on e.PARENT_TV_ID = t.tit_id 
group by 
  t.tit_id;


#9 Movie Trivia for award winning movies
SELECT * from TRIVIA_VIEW where TIT_ID  in (SELECT TIT_ID from AWARDED_TITLES);

#10 Roles of a franchise
SELECT distinct Role_name,Role_count No_of_movies_in_Franchise
from
(
SELECT r.Role_id,
role_name,
tit_name, 
count(t.tit_id) over (partition by r.role_id) role_count 
from
CASTING_INFORMATION c
join titles t on c.tit_id = t.tit_id
join roles r on r.role_id = c.role_id
)a 
where role_Count > 1;