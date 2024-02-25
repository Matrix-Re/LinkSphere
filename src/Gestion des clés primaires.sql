-------------------------------------------------------
--
-- CREATION D'UN TRIGGER SUR LA TABLE MESSAGE
CREATE OR REPLACE TRIGGER PRIM_KEY_GEN
AFTER INSERT ON Message 
BEGIN
	UPDATE IDGEN Set NewIDForMessage = NewIDForMessage + 1;
END;