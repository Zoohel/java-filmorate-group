DROP TABLE IF EXISTS FILMS_GENRES;
DROP TABLE IF EXISTS FRIENDS;
DROP TABLE IF EXISTS GENRES;
DROP TABLE IF EXISTS LIKES;
DROP TABLE IF EXISTS REVIEWS_LIKES;
DROP TABLE IF EXISTS REVIEWS;
DROP TABLE IF EXISTS DIRECTOR_FILMS;
DROP TABLE IF EXISTS DIRECTORS;
DROP TABLE IF EXISTS FILMS;
DROP TABLE IF EXISTS MPAA;
DROP TABLE IF EXISTS USERS;

-- СОЗДАНИЕ ТАБЛИЦ
CREATE TABLE IF NOT EXISTS MPAA
(
    MPAA_ID BIGINT GENERATED BY DEFAULT AS IDENTITY PRIMARY KEY,
    NAME    VARCHAR
);

CREATE UNIQUE INDEX IF NOT EXISTS MPA_MPA_ID_UINDEX
    ON MPAA (MPAA_ID);

CREATE TABLE IF NOT EXISTS FILMS
(
    FILM_ID      BIGINT GENERATED BY DEFAULT AS IDENTITY PRIMARY KEY,
    NAME         VARCHAR(255),
    DESCRIPTION  VARCHAR(255),
    RELEASE_DATE DATE,
    DURATION     VARCHAR(10),
    MPAA_ID      INT,
    CONSTRAINT FK_MPAA FOREIGN KEY (MPAA_ID) REFERENCES MPAA (MPAA_ID) ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE UNIQUE INDEX IF NOT EXISTS FILMS_FILM_ID_UINDEX
    ON FILMS (FILM_ID);

CREATE TABLE IF NOT EXISTS USERS
(
    USER_ID  BIGINT GENERATED BY DEFAULT AS IDENTITY PRIMARY KEY,
    EMAIL    VARCHAR(30) NOT NULL,
    LOGIN    VARCHAR(30) NOT NULL,
    NAME     VARCHAR(30),
    BIRTHDAY DATE
);

CREATE UNIQUE INDEX IF NOT EXISTS USERS_USER_ID_UINDEX
    ON USERS (USER_ID);

CREATE TABLE IF NOT EXISTS LIKES
(
    USER_ID BIGINT,
    FILM_ID BIGINT,
    CONSTRAINT LIKES_PK PRIMARY KEY (USER_ID, FILM_ID),
    CONSTRAINT FK_FILMS FOREIGN KEY (FILM_ID) REFERENCES FILMS (FILM_ID),
    CONSTRAINT FK_USERS FOREIGN KEY (USER_ID) REFERENCES USERS (USER_ID)

);

CREATE TABLE IF NOT EXISTS GENRES
(
    GENRE_ID INT GENERATED BY DEFAULT AS IDENTITY NOT NULL PRIMARY KEY,
    NAME     VARCHAR(50)                          NOT NULL
);

CREATE UNIQUE INDEX IF NOT EXISTS GENRE_GENRE_ID_UINDEX
    ON GENRES (GENRE_ID);

CREATE TABLE IF NOT EXISTS FILMS_GENRES
(
    FILM_ID  BIGINT NOT NULL,
    GENRE_ID INT    NOT NULL,
    CONSTRAINT FILMS_GENRES_PK PRIMARY KEY (FILM_ID, GENRE_ID),
    CONSTRAINT FILMS_GENRES_FK_1 FOREIGN KEY (FILM_ID) REFERENCES FILMS (FILM_ID),
    CONSTRAINT FILMS_GENRES_FK_2 FOREIGN KEY (GENRE_ID) REFERENCES GENRES (GENRE_ID)
);

CREATE TABLE IF NOT EXISTS FRIENDS
(
    FRIEND_ID BIGINT NOT NULL,
    USER_ID   BIGINT NOT NULL,
    CONSTRAINT PK_FRIENDS PRIMARY KEY (USER_ID, FRIEND_ID),
    CONSTRAINT FK_FRIENDS1 FOREIGN KEY (USER_ID) REFERENCES USERS (USER_ID),
    CONSTRAINT FK_FRIENDS2 FOREIGN KEY (FRIEND_ID) REFERENCES USERS (USER_ID)
);

CREATE TABLE IF NOT EXISTS REVIEWS
(
    REVIEW_ID   BIGINT AUTO_INCREMENT,
    FILM_ID     BIGINT,
    USER_ID     BIGINT,
    CONTENT     VARCHAR(256) NOT NULL,
    IS_POSITIVE BOOLEAN      NOT NULL, -- FALSE: НЕГАТИВНЫЙ, TRUE: ПОЛОЖИТЕЛЬНЫЙ
    USEFUL      INTEGER      NOT NULL DEFAULT 0,
    CONSTRAINT REVIEW_PK PRIMARY KEY (REVIEW_ID),
    CONSTRAINT FK_REVIEWS_USER_ID FOREIGN KEY (USER_ID) REFERENCES USERS (USER_ID) ON DELETE CASCADE,
    CONSTRAINT FK_REVIEWS_FILM_ID FOREIGN KEY (FILM_ID) REFERENCES FILMS (FILM_ID) ON DELETE CASCADE
);

CREATE UNIQUE INDEX IF NOT EXISTS REVIEWS_REVIEWS_ID_UINDEX
    ON REVIEWS (REVIEW_ID);

CREATE TABLE IF NOT EXISTS REVIEWS_LIKES
(
    REVIEW_ID BIGINT,
    USER_ID   BIGINT,
    IS_LIKE   BOOLEAN NOT NULL, -- FALSE: ДИЗЛАЙК, TRUE: ЛАЙК
    CONSTRAINT PK_REVIEWS_LIKE PRIMARY KEY (REVIEW_ID, USER_ID),
    CONSTRAINT FK_REVIEWS_LIKE_REVIEWS_ID FOREIGN KEY (REVIEW_ID) REFERENCES REVIEWS (REVIEW_ID) ON DELETE CASCADE,
    CONSTRAINT FK_REVIEWS_LIKE_USER_ID FOREIGN KEY (USER_ID) REFERENCES USERS (USER_ID) ON DELETE CASCADE
);

CREATE TABLE IF NOT EXISTS DIRECTORS
(
    DIRECTOR_ID BIGINT GENERATED BY DEFAULT AS IDENTITY PRIMARY KEY,
    NAME        VARCHAR(256) NOT NULL
);

CREATE TABLE IF NOT EXISTS DIRECTOR_FILMS
(
    DIRECTOR_ID BIGINT NOT NULL,
    FILM_ID     BIGINT NOT NULL,
    CONSTRAINT FK_DIRECTOR_FILMS1 FOREIGN KEY (DIRECTOR_ID) REFERENCES DIRECTORS (DIRECTOR_ID) ON DELETE CASCADE,
    CONSTRAINT FK_DIRECTOR_FILMS2 FOREIGN KEY (FILM_ID) REFERENCES FILMS (FILM_ID) ON DELETE CASCADE
);