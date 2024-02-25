CREATE TABLE Utilisateur(
   Login VARCHAR(50),
   PRIMARY KEY(Login)
);

CREATE TABLE Message(
   idMessage INT,
   Message VARCHAR(1000),
   DateM DATE,
   idMessage_1 INT,
   Login VARCHAR(50) NOT NULL,
   Login_1 VARCHAR(50) NOT NULL,
   PRIMARY KEY(idMessage),
   FOREIGN KEY(idMessage_1) REFERENCES Message(idMessage) ON DELETE CASCADE,
   FOREIGN KEY(Login) REFERENCES Utilisateur(Login) ON DELETE CASCADE,
   FOREIGN KEY(Login_1) REFERENCES Utilisateur(Login) ON DELETE CASCADE
);

CREATE TABLE SESSIONS(
   idSession INT,
   Login VARCHAR(50) NOT NULL,
   PRIMARY KEY(idSession),
   FOREIGN KEY(Login) REFERENCES Utilisateur(Login) ON DELETE CASCADE
);

CREATE TABLE SYMPATHISER(
   Login VARCHAR(50),
   Login_1 VARCHAR(50),
   PRIMARY KEY(Login, Login_1),
   FOREIGN KEY(Login) REFERENCES Utilisateur(Login) ON DELETE CASCADE,
   FOREIGN KEY(Login_1) REFERENCES Utilisateur(Login) ON DELETE CASCADE
);

CREATE TABLE IDGEN(
    NewIDForMessage INT,
    PRIMARY KEY(NewIDForMessage)
);