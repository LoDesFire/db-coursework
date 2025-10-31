DELIMITER //

CREATE TRIGGER hash_and_validate_password_insert
BEFORE INSERT ON users
FOR EACH ROW
BEGIN
    IF NEW.password_hash IS NOT NULL THEN
        IF NOT validate_password(NEW.password_hash) THEN
            SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Invalid password.';
        END IF;

        SET NEW.password_hash = SHA2(NEW.password_hash, 256);
    END IF;
END//

CREATE TRIGGER hash_and_validate_password_update
BEFORE UPDATE ON users
FOR EACH ROW
BEGIN
    IF NEW.password_hash != OLD.password_hash THEN
        IF NOT validate_password(NEW.password_hash) THEN
            SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Invalid password.';
        END IF;
    END IF;

    SET NEW.password_hash = SHA2(NEW.password_hash, 256);
END//

DELIMITER ;
