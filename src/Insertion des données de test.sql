-- Insertion d'utilisateurs
INSERT INTO Utilisateur (Login) VALUES ('Gumball');
INSERT INTO Utilisateur (Login) VALUES ('Darwin');
INSERT INTO Utilisateur (Login) VALUES ('Anaïs');

-- Insertion de messages
INSERT INTO Message (idMessage, Message, DateM, idMessage_1, Login, Login_1) VALUES (1, 'Ceci est le premier message.', TO_DATE('2023-01-01', 'YYYY-MM-DD'), NULL, 'Gumball', 'Darwin');
INSERT INTO Message (idMessage, Message, DateM, idMessage_1, Login, Login_1) VALUES (2, 'Ceci est le deuxi�me message.', TO_DATE('2023-02-01', 'YYYY-MM-DD'), NULL, 'Darwin', 'Anaïs');
INSERT INTO Message (idMessage, Message, DateM, idMessage_1, Login, Login_1) VALUES (3, 'Ceci est le troisi�me message.', TO_DATE('2023-03-01', 'YYYY-MM-DD'), NULL, 'Anaïs', 'Gumball');

-- Insertion de sessions
INSERT INTO SESSIONS (idSession, Login) VALUES (1, 'Gumball');
INSERT INTO SESSIONS (idSession, Login) VALUES (2, 'Darwin');
INSERT INTO SESSIONS (idSession, Login) VALUES (3, 'Anaïs');

-- Insertion de sympathisants
INSERT INTO SYMPATHISER (Login, Login_1) VALUES ('Gumball', 'Darwin');
INSERT INTO SYMPATHISER (Login, Login_1) VALUES ('Gumball', 'Anaïs');
INSERT INTO SYMPATHISER (Login, Login_1) VALUES ('Darwin', 'Anaïs');

-- Insertion de idgen
INSERT INTO IDGEN (NewIDForMessage) VALUES (1);