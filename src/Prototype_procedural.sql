CREATE OR REPLACE PACKAGE LinkSphere AS
  -- CREATION DE LA PROCEDURE POUR CREER LES UTILISATEURS
  PROCEDURE ajouterUtilisateur (loginUtilisateur IN VARCHAR);

  -- CREATION DE LA PROCEDURE POUR SUPPRIMER UN UTILISATEUR
  PROCEDURE supprimerUtilisateur;

  -- CREATION DE LA PROCEDURE POUR SE CONNECTER A UN COMPTE
  PROCEDURE connexion (loginUtilisateur IN VARCHAR);

  -- CREATION DE LA PROCEDURE POUR SE CONNECTER A UN COMPTE
  PROCEDURE deconnexion;

  -- CREATION DE LA PROCEDURE POUR AJOUTER UN AMI
  PROCEDURE ajouterAmi (loginAmi IN VARCHAR);

  -- CREATION DE LA PROCEDURE POUR SUPPRIMER UN AMI
  PROCEDURE supprimerAmi (loginAmi IN VARCHAR);

  -- CREATION DE LA PROCEDURE POUR AFFICHER LE MUR D'UN UTILISATEUR
  PROCEDURE afficherMur (loginUtilisateur IN VARCHAR);

  -- CREATION DE LA PROCEDURE POUR AJOUTER UN MESSAGE SUR LE MUR D'UN AMI
  PROCEDURE ajouterMessageMur(loginAmi IN VARCHAR, message IN VARCHAR);

  -- CREATION DE LA PROCEDURE POUR SUPPRIMER UN MESSAGE D'UN MUR
  PROCEDURE supprimerMessageMur(id_message IN INT);

  -- CREATION DE LA PROCEDURE POUR REPONDRE A UN MESSAGE
  PROCEDURE repondreMessageMur(id_message IN INT, messageReponse IN VARCHAR);

  -- CREATION DE LA PROCEDURE POUR AFFICHER LA LISTE DES AMIS D'UN UTILISATEUR
  PROCEDURE afficherAmi(loginUtilisateur IN VARCHAR);

  -- CREATION DE LA PROCEDURE POUR RECHERCHER DES MEMBRES PAR LEUR PREFIXE
  PROCEDURE compterAmi(loginUtilisateur IN VARCHAR);

  -- CREATION DE LA PROCEDURE POUR RECHERCHER DES MEMBRES PAR LEUR PREFIXE
  PROCEDURE chercherMembre(prefixeLoginMembre IN VARCHAR);

  -- CREATION D'UNE FONCTION PERMETTANT DE SAVOIR SI DEUX UTILISATEUR SON AMI
  FUNCTION estAmi (X IN VARCHAR, Y IN VARCHAR) RETURN BOOLEAN;

  -- CREATION D'UNE FONCTION PERMETTANT D'OBTENIR LE LOGIN DE L'UTILISATEUR CONNECTER
  FUNCTION getCurrentLogin RETURN VARCHAR;

  FUNCTION getNewIdMessage RETURN INT;

END LinkSphere;
/

CREATE OR REPLACE PACKAGE BODY LinkSphere AS
    -- CREATION DE LA PROCEDURE POUR CREER LES UTILISATEURS
    PROCEDURE ajouterUtilisateur (loginUtilisateur IN VARCHAR)
    IS
    BEGIN
      INSERT INTO Utilisateur(Login) VALUES (loginUtilisateur);
      DBMS_OUTPUT.PUT_LINE('Utilisateur ' || loginUtilisateur || ' � �t� ajout�');
      COMMIT;
    EXCEPTION
      WHEN DUP_VAL_ON_INDEX  THEN
        -- Gestion de l'exception ORA-06512 avec la cl� primaire
        DBMS_OUTPUT.PUT_LINE('Erreur : l"utilisateur ' || loginUtilisateur || ' existe d�j�, veuillez saisir un autre login.');
    END ajouterUtilisateur;
    
    -------------------------------------------------------
    --
    -- CREATION DE LA PROCEDURE POUR SUPPRIMER UN UTILISATEUR
    PROCEDURE supprimerUtilisateur
    IS
      User_Login VARCHAR(20);
    BEGIN
      User_Login := getCurrentLogin();

      DELETE FROM UTILISATEUR WHERE Login = User_Login;
      DBMS_OUTPUT.PUT_LINE('L"utilisateur ' || User_Login || ' a ete supprime');
      COMMIT;
    EXCEPTION
      WHEN NO_DATA_FOUND THEN
        DBMS_OUTPUT.PUT_LINE('Veuillez vous connecter avant de supprimer le compte');
    END supprimerUtilisateur;
    
    ---------------------------------------------------------
    --
    -- CREATION DE LA PROCEDURE POUR SE CONNECTER A UN COMPTE
    PROCEDURE connexion (loginUtilisateur IN VARCHAR)
    IS
      SESSION_ID INT;
    BEGIN
      SELECT SYS_CONTEXT('USERENV', 'SID') INTO SESSION_ID FROM DUAL;
    
      INSERT INTO SESSIONS(idSession, Login) VALUES (SESSION_ID, loginUtilisateur);
      DBMS_OUTPUT.PUT_LINE('Bienvenue ' || loginUtilisateur);
      COMMIT;
    EXCEPTION
      WHEN OTHERS THEN
        -- Gestion de l'exception ORA-02291 avec la foreing key
        IF SQLCODE = -2291 THEN
          -- Affichage d'un message ou traitement sp�cifique
          DBMS_OUTPUT.PUT_LINE('Erreur : l"utilisateur ' || loginUtilisateur || ' n"existe pas.');
        END IF;
    END connexion;
    
    -------------------------------------------------------
    --
    -- CREATION DE LA PROCEDURE POUR SE CONNECTER A UN COMPTE
    PROCEDURE deconnexion
    IS
      SESSION_ID INT;
    BEGIN
      SELECT SYS_CONTEXT('USERENV', 'SID') INTO SESSION_ID FROM DUAL;
    
      DELETE FROM SESSIONS WHERE idSession = SESSION_ID;
      DBMS_OUTPUT.PUT_LINE('Vous �tes maintenant d�connecter');
      COMMIT;
    END deconnexion;
    
    -------------------------------------------------------
    --
    -- CREATION DE LA PROCEDURE POUR AJOUTER UN AMI
    PROCEDURE ajouterAmi (loginAmi IN VARCHAR)
    IS
	User_Login VARCHAR(20);
    BEGIN
      User_Login := getCurrentLogin();

	  IF estAmi(User_Login, loginAmi) = FALSE THEN
	    INSERT INTO SYMPATHISER(LOGIN, LOGIN_1) VALUES(User_Login, loginAmi);
		DBMS_OUTPUT.PUT_LINE('Vous �tes maintenant ami avec ' || loginAmi);
	  ELSE
	    DBMS_OUTPUT.PUT_LINE('Vous �tes d�j� ami avec ' || loginAmi);
	  END IF;
      COMMIT;
    EXCEPTION
      WHEN NO_DATA_FOUND THEN
        DBMS_OUTPUT.PUT_LINE('Veuillez vous connecter avant d"ajouter un ami');
      WHEN OTHERS THEN
        IF SQLCODE = -2291 THEN
    	  DBMS_OUTPUT.PUT_LINE('L"utilisateur ' || loginAmi || ' n"existe pas.');
    	END IF;
    END ajouterAmi;
    
    -------------------------------------------------------
    --
    -- CREATION DE LA PROCEDURE POUR SUPPRIMER UN AMI
    PROCEDURE supprimerAmi (loginAmi IN VARCHAR)
    IS
      User_Login VARCHAR(20);
    BEGIN
      User_Login := getCurrentLogin();
      
	  IF estAmi(User_Login, loginAmi) = TRUE THEN
		  DELETE FROM SYMPATHISER WHERE (LOGIN = User_Login AND LOGIN_1 = loginAmi)
			OR
			(LOGIN = loginAmi AND LOGIN_1 = User_Login);
		  DBMS_OUTPUT.PUT_LINE('Vous n"�tes plus ami avec ' || loginAmi);
	  ELSE
	    DBMS_OUTPUT.PUT_LINE('Vous n"�tre d�j� pas ami avec ' || loginAmi);
	  END IF;
      COMMIT;
    EXCEPTION
      WHEN NO_DATA_FOUND THEN
        DBMS_OUTPUT.PUT_LINE('Veuillez vous connecter avant de supprimer un ami');
    END supprimerAmi;
    
    -------------------------------------------------------
    --
    -- CREATION DE LA PROCEDURE POUR AFFICHER LE MUR D'UN UTILISATEUR
    PROCEDURE afficherMur (loginUtilisateur IN VARCHAR) IS
    BEGIN
        DBMS_OUTPUT.PUT_LINE('Mur de ' || loginUtilisateur);

        FOR message IN (
            SELECT M.IDMESSAGE, M.MESSAGE, U.Login AS NomUtilisateur
            FROM MESSAGE M
                     INNER JOIN UTILISATEUR U ON M.LOGIN = U.LOGIN
            WHERE M.LOGIN_1 = loginUtilisateur AND M.IDMESSAGE_1 IS NULL
               OR M.IDMESSAGE = (SELECT IDMESSAGE FROM MESSAGE WHERE IDMESSAGE_1 IS NULL AND LOGIN = loginUtilisateur)
            ORDER BY M.DATEM
            )
            LOOP
                DBMS_OUTPUT.PUT_LINE(message.NomUtilisateur || ' - ID_Message:' || message.IDMESSAGE || ' : ' || message.MESSAGE);
            END LOOP;

    END afficherMur;


-------------------------------------------------------
    --
    -- CREATION DE LA PROCEDURE POUR AFFICHER LE MUR D'UN UTILISATEUR
    PROCEDURE ajouterMessageMur(loginAmi IN VARCHAR, message IN VARCHAR) IS
        User_Login VARCHAR(20);
        NewIDMessage INT;
    BEGIN
        -- Récupération de l'id de l'utilisateur connecté
        User_Login := getCurrentLogin();

        -- Vérification si l'utilisateur ajoute un message sur son propre mur ou sur le mur d'un ami
        IF loginAmi = User_Login OR estAmi(User_Login, loginAmi) = TRUE THEN
            NewIDMessage := getNewIdMessage();
            INSERT INTO Message (idMessage, Message, DateM, Login, Login_1)
            VALUES (NewIDMessage, message, SYSDATE, User_Login, loginAmi);

            DBMS_OUTPUT.PUT_LINE('Le message a été publié');
        ELSE
            DBMS_OUTPUT.PUT_LINE('Vous ne pouvez pas publier de message sur le mur de l''utilisateur car vous n''êtes pas ami');
        END IF;

        COMMIT;
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            DBMS_OUTPUT.PUT_LINE('Veuillez vous connecter avant de publier un message');
    END ajouterMessageMur;
    
    -------------------------------------------------------
    --
    -- CREATION DE LA PROCEDURE POUR SUPPRIMER UN MESSAGE D'UN MUR
    PROCEDURE supprimerMessageMur(id_message IN INT)
    IS
      EstMonMur INT;
    BEGIN
	  -- On v�rifie que le message appartient au mur de l'utilisateur   
      SELECT COUNT(*) INTO EstMonMur FROM Message WHERE idMessage = id_message AND Login_1 = getCurrentLogin();
    
      IF EstMonMur = 1 THEN
        DELETE FROM Message WHERE idMessage = id_message;
    	DBMS_OUTPUT.PUT_LINE('Le message vient d"etre supprime');
      ELSE
        DBMS_OUTPUT.PUT_LINE('Vous ne pouvez pas supprimer le message');
      END IF;
    
      COMMIT;
    EXCEPTION
      WHEN NO_DATA_FOUND THEN
        DBMS_OUTPUT.PUT_LINE('Veuillez vous connecter avant de supprimer un message sur votre mur');
    END supprimerMessageMur;
    
    -------------------------------------------------------
    --
    -- CREATION DE LA PROCEDURE POUR REPONDRE A UN MESSAGE
    PROCEDURE repondreMessageMur(id_message IN INT, messageReponse IN VARCHAR)
    IS
      User_Login VARCHAR(20);
      loginAmi VARCHAR(20);
      NewIDMessage INT;
    BEGIN
    
      -- On r�cup�re l'id de l'utilisateur connecter
      User_Login := getCurrentLogin();
    
      -- On r�cuper l'id de l'utilisateur au quel apartien le mur
      SELECT Login_1 INTO loginAmi FROM Message WHERE idMessage = id_message;

      IF estAmi(loginAmi,User_Login) = TRUE THEN
        -- On g�nere l'id du message
        SELECT NewIDForMessage INTO NewIDMessage FROM IDGEN;
    
        -- On cr�er la r�ponse
        INSERT INTO Message (idMessage, Message, DateM, idMessage_1, Login, Login_1) VALUES (NewIDMessage, messageReponse, SYSDATE, id_message, User_Login, loginAmi);
        DBMS_OUTPUT.PUT_LINE('La reponse au message a ete publie');
      ELSE
        DBMS_OUTPUT.PUT_LINE('Vous ne pouvez pas r�pondre au message car vous n"etes pas ami avec l"utilisateur');
      END IF;
      COMMIT;
    EXCEPTION
      WHEN NO_DATA_FOUND THEN
        DBMS_OUTPUT.PUT_LINE('Veuillez vous connecter avant de repondre � un message');
    END repondreMessageMur;
    
    -------------------------------------------------------
    --
    -- CREATION DE LA PROCEDURE POUR AFFICHER LA LISTE DES AMIS D'UN UTILISATEUR
    PROCEDURE afficherAmi(loginUtilisateur IN VARCHAR)
    IS
    BEGIN
      DBMS_OUTPUT.PUT_LINE('La liste des amis de ' || loginUtilisateur || ' sont :');
      FOR membre IN (
	  SELECT Login FROM SYMPATHISER WHERE Login_1 = loginUtilisateur
	  UNION
	  SELECT Login_1 FROM SYMPATHISER WHERE Login = loginUtilisateur)
      LOOP
        -- On affiche la liste des membre trouv�
        DBMS_OUTPUT.PUT_LINE('1 - ' || membre.Login);
      END LOOP;
    END afficherAmi;
 
    -------------------------------------------------------
    --
    -- CREATION DE LA PROCEDURE POUR RECHERCHER DES MEMBRE PAR LEUR PREFIXE
    PROCEDURE compterAmi(loginUtilisateur IN VARCHAR)
    IS
       NbAmi INT;
    BEGIN
	   SELECT SUM(AMI) INTO NbAmi FROM
	   (
         SELECT COUNT(*) AS AMI FROM SYMPATHISER WHERE Login = loginUtilisateur
	       UNION
	     SELECT COUNT(*) AS AMI FROM SYMPATHISER WHERE Login_1 = loginUtilisateur
	   );
    
       -- Affichage du nombre d'amis
       DBMS_OUTPUT.PUT_LINE(loginUtilisateur || ' a ' || NbAmi || ' ami(s)');
    END compterAmi;
    
    -------------------------------------------------------
    --
    -- CREATION DE LA PROCEDURE POUR RECHERCHER DES MEMBRE PAR LEUR PREFIXE
    PROCEDURE chercherMembre(prefixeLoginMembre IN VARCHAR)
    IS
    BEGIN
      FOR membre IN (SELECT Login FROM UTILISATEUR WHERE Login LIKE(prefixeLoginMembre || '%'))
      LOOP
        -- On affiche la liste des membre trouv�
        DBMS_OUTPUT.PUT_LINE('Login : ' || membre.Login);
      END LOOP;
    
    EXCEPTION
      WHEN NO_DATA_FOUND THEN
        DBMS_OUTPUT.PUT_LINE('Aucun utilisateur trouv�');
    END chercherMembre;
	--
	-------------------------------------------------------
    --
    -- CREATION D'UNE FONCTION PERMETTANT DE SAVOIR SI DEUX UTILISATEUR SON AMI
	FUNCTION estAmi (X IN VARCHAR, Y IN VARCHAR)
	RETURN BOOLEAN
	IS
		estAmiResult NUMBER(1);
	BEGIN
		SELECT SUM(AMI) INTO estAmiResult FROM
		(
		SELECT COUNT(*) AS AMI FROM SYMPATHISER WHERE Login = X AND Login_1 = Y
		UNION
		SELECT COUNT(*) AS AMI FROM SYMPATHISER WHERE Login = Y AND Login_1 = X
		);
		RETURN estAmiResult > 0;
	END estAmi;
	-------------------------------------------------------
    --
    -- CREATION D'UNE FONCTION PERMETTANT D'OBTENIR LE LOGIN DE L'UTILISATEUR CONNECTER
	FUNCTION getCurrentLogin
	RETURN VARCHAR
	IS
		CurrentLogin VARCHAR(50);
		Session_ID NUMBER(10);
	BEGIN 
		SELECT SYS_CONTEXT('USERENV', 'SID') INTO SESSION_ID FROM DUAL;
      
		SELECT Login INTO CurrentLogin FROM SESSIONS WHERE idSession = SESSION_ID;

		RETURN CurrentLogin;
	 EXCEPTION
		  WHEN NO_DATA_FOUND THEN
			RETURN '';
	END getCurrentLogin;

    FUNCTION getNewIdMessage RETURN INT IS
        v_NewIDMessage INT;
    BEGIN
        SELECT NewIDForMessage INTO v_NewIDMessage FROM IDGEN;
        RETURN v_NewIDMessage;
    EXCEPTION
        WHEN OTHERS THEN
            RETURN NULL;
    END getNewIdMessage;
    
END LinkSphere;
/