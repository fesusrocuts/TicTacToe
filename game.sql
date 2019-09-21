####################################################
USE mysql;
DROP DATABASE IF EXISTS game;
CREATE DATABASE IF NOT EXISTS game;
USE game;
DROP TABLE IF EXISTS TicTacToe;
CREATE TABLE TicTacToe
    (
    ID INT NOT NULL,
    A VARCHAR(1) NULL,
    B VARCHAR(1) NULL,
    C VARCHAR(1) NULL
    );
INSERT INTO TicTacToe(ID,A,B,C)
VALUES
    (1,NULL,NULL,NULL),
    (2,NULL,NULL,NULL),
    (3,NULL,NULL,NULL);
SELECT * FROM TicTacToe;
####################################################
DROP TABLE IF EXISTS ttt_PlayerTurn;
CREATE TABLE ttt_PlayerTurn (turn VARCHAR(1) NOT NULL);
INSERT INTO ttt_PlayerTurn (turn) VALUES ('X');
####################################################
DROP TABLE IF EXISTS ttt_PlayerTurn;
CREATE TABLE ttt_PlayerTurn (turn VARCHAR(1) NOT NULL);
INSERT INTO ttt_PlayerTurn (turn) VALUES ('X');
####################################################
DELIMITER //
DROP PROCEDURE IF EXISTS ttt_CheckVictory//
CREATE PROCEDURE ttt_CheckVictory ()
BEGIN
DECLARE NO INT; -- NUMBER OPTIONS
SET
    @A1 = (SELECT A FROM TicTacToe WHERE ID = 1),
    @A2 = (SELECT A FROM TicTacToe WHERE ID = 2),
    @A3 = (SELECT A FROM TicTacToe WHERE ID = 3),
    @B1 = (SELECT B FROM TicTacToe WHERE ID = 1),
    @B2 = (SELECT B FROM TicTacToe WHERE ID = 2),
    @B3 = (SELECT B FROM TicTacToe WHERE ID = 3),
    @C1 = (SELECT C FROM TicTacToe WHERE ID = 1),
    @C2 = (SELECT C FROM TicTacToe WHERE ID = 2),
    @C3 = (SELECT C FROM TicTacToe WHERE ID = 3);

    CASE
    -- Horizontal wins
        -- Horizontal win on row 1
        WHEN
            @A1 = @B1 AND @B1 = @C1
        THEN     (SELECT *, CONCAT('Player ', @A1, ' is victorious!') AS 'Result' FROM TicTacToe);
        -- Horizontal win on row 2
        WHEN
            @A2 = @B2 AND @B2 = @C2
        THEN     (SELECT *, CONCAT('Player ', @A2, ' is victorious!') AS 'Result' FROM TicTacToe);
        -- Horizontal win on row 3
        WHEN
            @A3 = @B3 AND @B3 = @C3
        THEN     (SELECT *, CONCAT('Player ', @A3, ' is victorious!') AS 'Result' FROM TicTacToe);
    -- Vertical wins
        -- Vertical win on column A
        WHEN
            @A1 = @A2 AND @A2 = @A3
        THEN     (SELECT *, CONCAT('Player ', @A1, ' is victorious!') AS 'Result' FROM TicTacToe);
        -- Vertical win on column B
        WHEN
            @B1 = @B2 AND @B2 = @B3
        THEN     (SELECT *, CONCAT('Player ', @B1, ' is victorious!') AS 'Result' FROM TicTacToe);
        -- Vertical win on column C
        WHEN
            @C1 = @C2 AND @C2 = @C3
        THEN     (SELECT *, CONCAT('Player ', @C1, ' is victorious!') AS 'Result' FROM TicTacToe);
    -- Diagonal wins
        -- Diagonal win from A1
        WHEN
            @A1 = @B2 AND @B2 = @C3
        THEN     (SELECT *, CONCAT('Player ', @A1, ' is victorious!') AS 'Result' FROM TicTacToe);
        -- Diagonal win from A3
        WHEN
            @A3 = @B2 AND @B2 = @C1
        THEN     (SELECT *, CONCAT('Player ', @A3, ' is victorious!') AS 'Result' FROM TicTacToe);
    -- Game continues
        ELSE
          SET NO = (SELECT SUM(r.t) t from (select sum(IF(A IS NULL,1,0)+IF(B IS NULL,1,0)+IF(C IS NULL,1,0)) as t from TicTacToe group by a) as r);
          IF NO > 0 THEN
            (SELECT *, 'Game is still ongoing'  AS 'Result' FROM TicTacToe);
          ELSE
            (SELECT *, 'Game is TIED'  AS 'Result' FROM TicTacToe);
          END IF;
    END CASE;
END//
DELIMITER ;
####################################################
DELIMITER //
DROP PROCEDURE IF EXISTS ttt_PlayerMove//
CREATE PROCEDURE ttt_PlayerMove(p_move VARCHAR(1), p_column VARCHAR(1), p_row INT)
BEGIN
    DECLARE R1 INT;

    -- Check for valid player input
    IF p_move NOT IN ('X', 'O')
        THEN (SELECT 'Move must be X or O');
    END IF;
    -- Check for valid column
    IF p_column NOT IN ('A', 'B', 'C')
        THEN (SELECT 'Column must be A, B or C');
    END IF;
    -- Check for valid row
    IF p_row NOT IN (1,2,3)
        THEN (SELECT 'Row must be 1, 2 or 3');
    END IF;

    -- Check for player turn and update player turn
    IF p_move != (SELECT turn FROM ttt_PlayerTurn)
      THEN (SELECT
                CONCAT('This turn belongs to player ', (SELECT turn FROM ttt_PlayerTurn), '!')
      );
    ELSE
      -- Check if move is validated
      SET R1 = 0;
      IF 'A' = p_column THEN
        SET R1 = (SELECT COUNT(*) FROM TicTacToe WHERE A IS NULL AND ID = p_row);
      END IF;
      IF 'B' = p_column THEN
        SET R1 = (SELECT COUNT(*) FROM TicTacToe WHERE B IS NULL AND ID = p_row);
      END IF;
      IF 'C' = p_column THEN
        SET R1 = (SELECT COUNT(*) FROM TicTacToe WHERE C IS NULL AND ID = p_row);
      END IF;

      IF R1 = 1 THEN
        SELECT CONCAT('Good, ', p_move, ' have played! ');
        -- UPDATE TicTacToe SET p_column = p_move WHERE ID = p_row;
        CASE
          WHEN p_column = "A" AND p_row = 1 THEN
            UPDATE TicTacToe SET A = CONCAT("", p_move) WHERE ID = 1;
          WHEN p_column = "B" AND p_row = 1 THEN
            UPDATE TicTacToe SET B = CONCAT("", p_move) WHERE ID = 1;
          WHEN p_column = "C" AND p_row = 1 THEN
            UPDATE TicTacToe SET C = CONCAT("", p_move) WHERE ID = 1;
          WHEN p_column = "A" AND p_row = 2 THEN
            UPDATE TicTacToe SET A = CONCAT("", p_move) WHERE ID = 2;
          WHEN p_column = "B" AND p_row = 2 THEN
            UPDATE TicTacToe SET B = CONCAT("", p_move) WHERE ID = 2;
          WHEN p_column = "C" AND p_row = 2 THEN
            UPDATE TicTacToe SET C = CONCAT("", p_move) WHERE ID = 2;
          WHEN p_column = "A" AND p_row = 3 THEN
            UPDATE TicTacToe SET A = CONCAT("", p_move) WHERE ID = 3;
          WHEN p_column = "B" AND p_row = 3 THEN
            UPDATE TicTacToe SET B = CONCAT("", p_move) WHERE ID = 3;
          WHEN p_column = "C" AND p_row = 3 THEN
            UPDATE TicTacToe SET C = CONCAT("", p_move) WHERE ID = 3;
          END CASE;
          UPDATE ttt_PlayerTurn SET turn = CASE WHEN turn = 'X' THEN 'O' WHEN turn = 'O' THEN 'X' END;
      ELSE (SELECT CONCAT('The movement is wrong, please try again! '));
      END IF;
    END IF;
    -- Check if victory is achieved
    CALL ttt_CheckVictory();
END//
DELIMITER ;
####################################################
DELIMITER //
DROP PROCEDURE IF EXISTS ttt_ResetBoard//
CREATE PROCEDURE ttt_ResetBoard()
BEGIN
UPDATE TicTacToe SET A=NULL,B=NULL,C=NULL WHERE ID IN (1,2,3);
UPDATE ttt_PlayerTurn SET turn = 'X';
END//
DELIMITER ;
####################################################
# THE PLAYER WHO SHOULD PLAY IS X
# THIS EXAMPLE IS TO GAME TIED
CALL ttt_PlayerMove('X','A',1);
CALL ttt_PlayerMove('O','B',2);
CALL ttt_PlayerMove('X','C',3);
CALL ttt_PlayerMove('O','B',1);
CALL ttt_PlayerMove('X','B',3);
CALL ttt_PlayerMove('O','A',3);
CALL ttt_PlayerMove('X','C',1);
CALL ttt_PlayerMove('O','C',2);
CALL ttt_PlayerMove('X','A',2);
# YOU WANT SEE HOW IS THE PLAY
CALL ttt_CheckVictory();
# RESTART TO PLAY
CALL ttt_ResetBoard();
SELECT * FROM TicTacToe;
####################################################
