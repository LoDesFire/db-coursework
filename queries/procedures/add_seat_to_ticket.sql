DELIMITER //

CREATE PROCEDURE AddSeatToTicket(
    IN p_ticket_id INT,
    IN p_seat_id INT
)
BEGIN
    -- Insert the seat into the ticket_seats table
    INSERT INTO ticket_seats (ticket_id, seat_id)
    VALUES (p_ticket_id, p_seat_id);
END //

DELIMITER ;