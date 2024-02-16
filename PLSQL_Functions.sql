SET SERVEROUTPUT ON;

--Sa se ieftineasca cu 20% cele mai putin cumparate 5 jocuri pentru cele 3 platforme cu cele mai putine jocuri vandute pentru
CREATE OR REPLACE PROCEDURE ieftinire_jocuri
    IS
        TYPE tablou_indexat IS TABLE OF joc%ROWTYPE
                            INDEX BY BINARY_INTEGER;
        TYPE tablou_imbricat IS TABLE OF versiune%ROWTYPE;
        TYPE vector IS VARRAY(3) OF platforma%ROWTYPE;
        
        t_jocuri tablou_indexat;
        t_platforme vector := vector();
        t_versiuni tablou_imbricat := tablou_imbricat();
        k INTEGER;
        v_nume_joc joc.titlu%TYPE;
        v_nume_platforma platforma.nume_platforma%TYPE;
        v_pret versiune.pret%TYPE;
        v_ver versiune%ROWTYPE;
        v_count NUMBER;
    
    BEGIN
        SELECT *
        BULK COLLECT INTO t_jocuri
        FROM joc
        WHERE id_joc IN (SELECT id_joc
                        FROM (SELECT id_joc 
                            FROM comanda_contine
                            GROUP BY id_joc
                            ORDER BY SUM(numar))
                        WHERE ROWNUM <= 5);
        
        SELECT *
        BULK COLLECT INTO t_platforme
        FROM platforma
        WHERE id_platforma IN (SELECT id_platforma
                        FROM (SELECT id_platforma
                            FROM comanda_contine
                            GROUP BY id_platforma
                            ORDER BY SUM(numar))
                        WHERE ROWNUM <= 3);
                      
        FOR i in t_jocuri.FIRST..t_jocuri.LAST LOOP
            FOR j in t_platforme.FIRST..t_platforme.LAST LOOP
                SELECT COUNT(*)
                INTO v_count
                FROM versiune
                WHERE id_joc = t_jocuri(i).id_joc AND id_platforma = t_platforme(j).id_platforma;
                IF v_count = 1 THEN
                    SELECT *
                    INTO v_ver
                    FROM versiune
                    WHERE id_joc = t_jocuri(i).id_joc AND id_platforma = t_platforme(j).id_platforma;
                    t_versiuni.EXTEND;
                    t_versiuni(t_versiuni.LAST) := v_ver;
                END IF;
            END LOOP;
        END LOOP;
        
        k := t_versiuni.FIRST;
        WHILE k <= t_versiuni.LAST LOOP
            t_versiuni(k).pret := t_versiuni(k).pret * 4 / 5;
            k := t_versiuni.NEXT(k);
        END LOOP;
        
        k := t_versiuni.FIRST;
        WHILE k <= t_versiuni.LAST LOOP
            SELECT titlu
            INTO v_nume_joc
            FROM joc
            WHERE id_joc = t_versiuni(k).id_joc;
            
            SELECT nume_platforma
            INTO v_nume_platforma
            FROM platforma
            WHERE id_platforma = t_versiuni(k).id_platforma;
            
            SELECT pret
            INTO v_pret
            FROM versiune
            WHERE id_joc = t_versiuni(k).id_joc AND id_platforma = t_versiuni(k).id_platforma;
            
            DBMS_OUTPUT.PUT_LINE('Jocul ' || v_nume_joc || ' de pe platforma ' || v_nume_platforma || ' avea pretul ' || v_pret || ' si a scazut la ' || t_versiuni(k).pret || '.');
            
            UPDATE versiune
            SET pret = t_versiuni(k).pret
            WHERE id_joc = t_versiuni(k).id_joc AND id_platforma = t_versiuni(k).id_platforma;
            
            k := t_versiuni.NEXT(k);
        END LOOP;
END;
/

ROLLBACK;

BEGIN
    ieftinire_jocuri();
END;
/



--Sa se afiseze date despre un magazin (nume, adresa, numar angajati, media salariilor) si lista angajatilor sai

CREATE OR REPLACE PROCEDURE date_magazin
    IS
        TYPE refcursor IS REF CURSOR RETURN magazin%ROWTYPE;
        c_magazine refcursor;
        CURSOR c_angajati (id_mag magazin.id_magazin%TYPE) IS
            SELECT *
            FROM angajat
            WHERE id_magazin = id_mag;
        v_mag magazin%ROWTYPE;
        v_nr_ang NUMBER;
        v_avg_sal NUMBER;
    BEGIN
        OPEN c_magazine FOR
            SELECT * FROM magazin;
        LOOP
            FETCH c_magazine INTO v_mag;
            EXIT WHEN c_magazine%NOTFOUND;
            
            DBMS_OUTPUT.PUT_LINE('-------------------------------------');
            DBMS_OUTPUT.PUT_LINE(v_mag.nume_magazin);
            DBMS_OUTPUT.PUT_LINE('Adresa: ' || v_mag.adresa);
            DBMS_OUTPUT.PUT_LINE('-------------------------------------');
            
            v_nr_ang := 0;
            v_avg_sal := 0;
            
            FOR v_ang IN c_angajati(v_mag.id_magazin) LOOP
                DBMS_OUTPUT.PUT_LINE(v_ang.nume || ' ' || v_ang.prenume || ' ' || v_ang.salariu);
                v_nr_ang := v_nr_ang + 1;
                v_avg_sal := v_avg_sal + v_ang.salariu;
            END LOOP;
            
            IF v_nr_ang = 0 THEN
                DBMS_OUTPUT.PUT_LINE('Magazinul nu are angajati');
            ELSE
                v_avg_sal := v_avg_sal / v_nr_ang;
                DBMS_OUTPUT.PUT_LINE('-------------------------------------');
                DBMS_OUTPUT.PUT_LINE('Numarul de angajati: ' || v_nr_ang);
                DBMS_OUTPUT.PUT_LINE('Salariul mediu: ' || v_avg_sal);
            END IF;
            DBMS_OUTPUT.PUT_LINE('-------------------------------------');
            DBMS_OUTPUT.PUT_LINE('');
        END LOOP;
        CLOSE c_magazine;
    END;
/

BEGIN
    date_magazin();
END;
/



--Pentru un magazin dat sa se returneze numarul total de jocuri vandute de angajatii sai

CREATE OR REPLACE FUNCTION vanzari_magazin
    (v_nume_mag magazin.nume_magazin%TYPE)
RETURN NUMBER IS
        v_id_mag magazin.id_magazin%TYPE;
        v_nr_ang NUMBER;
        v_nr_comenzi NUMBER;
        v_joc_vand NUMBER;
        NO_EMPLOYEES EXCEPTION;
        NO_SALES EXCEPTION;
    BEGIN
        SELECT id_magazin
        INTO v_id_mag
        FROM magazin
        WHERE UPPER(nume_magazin) LIKE ('%' || UPPER(v_nume_mag) || '%');
      
        SELECT COUNT(*)
        INTO v_nr_ang
        FROM angajat
        WHERE id_magazin = v_id_mag;
        IF v_nr_ang = 0 THEN
            RAISE NO_EMPLOYEES;
        END IF;
        
        SELECT COUNT(*)
        INTO v_nr_comenzi
        FROM comanda
        WHERE id_angajat IN (SELECT id_angajat FROM angajat
                            WHERE id_magazin = v_id_mag);
        IF v_nr_comenzi = 0 THEN
            RAISE NO_SALES;
        END IF;
        
        SELECT SUM(numar)
        INTO v_joc_vand
        FROM comanda_contine JOIN comanda USING (id_comanda)
            JOIN angajat USING (id_angajat)
        WHERE id_magazin = v_id_mag;
        
        RETURN v_joc_vand;
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            DBMS_OUTPUT.PUT_LINE('Nu exista magazin cu acel nume.');
            RETURN -1;
        WHEN TOO_MANY_ROWS THEN
            DBMS_OUTPUT.PUT_LINE('Exista mai multe magazine cu acel nume.');
            RETURN -1;
        WHEN NO_EMPLOYEES THEN
            DBMS_OUTPUT.PUT_LINE('Magazinul nu are angajati.');
            RETURN 0;
        WHEN NO_SALES THEN
            DBMS_OUTPUT.PUT_LINE('Magazinul nu are vanzari.');
            RETURN 0;
    END;
/

BEGIN
    DBMS_OUTPUT.PUT_LINE(vanzari_magazin('Gameshop Galati'));
    DBMS_OUTPUT.PUT_LINE(vanzari_magazin('Gameshop'));
    DBMS_OUTPUT.PUT_LINE(vanzari_magazin('Brasov'));
    DBMS_OUTPUT.PUT_LINE(vanzari_magazin('Londra'));
END;
/

INSERT INTO magazin
VALUES(315, 'Gamecorner Budapesta 3', 'K?nyves K?lm?n krt. 12-14, 1097', 19, NULL);

BEGIN
    DBMS_OUTPUT.PUT_LINE(vanzari_magazin('Gamecorner Budapesta 3'));
END;
/

ROLLBACK;



--Sa se afiseze stocul si nr de jocuri vandute pentru un dezvoltator si toate orasele dintr-o anumita tara

CREATE OR REPLACE PROCEDURE stoc_dezvoltator
    (v_nume_dez dezvoltator.nume_dezvoltator%TYPE,
    v_nume_tara tara.nume_tara%TYPE)
    IS
        TYPE tablou_orase IS TABLE OF oras%ROWTYPE;
    
        v_id_dez dezvoltator.id_dezvoltator%TYPE;
        v_id_tara tara.id_tara%TYPE;
        
        v_nr_orase NUMBER;
        v_stoc NUMBER;
        v_vanzari NUMBER;
        t_orase tablou_orase;
        k NUMBER;
        
        NO_CITIES EXCEPTION;
    BEGIN
        BEGIN
            SELECT id_dezvoltator
            INTO v_id_dez
            FROM dezvoltator
            WHERE UPPER(nume_dezvoltator) LIKE ('%' || UPPER(v_nume_dez) || '%');
        EXCEPTION
            WHEN NO_DATA_FOUND THEN
                DBMS_OUTPUT.PUT_LINE('Nu exista dezvoltator cu acel nume.');
                RAISE;
            WHEN TOO_MANY_ROWS THEN
                DBMS_OUTPUT.PUT_LINE('Exista mai multi dezvoltatori cu acel nume.');
                RAISE;
        END;
        
        BEGIN
            SELECT id_tara
            INTO v_id_tara
            FROM tara
            WHERE UPPER(nume_tara) LIKE ('%' || UPPER(v_nume_tara) || '%');
        EXCEPTION
            WHEN NO_DATA_FOUND THEN
                DBMS_OUTPUT.PUT_LINE('Nu exista tara cu acel nume.');
                RAISE;
            WHEN TOO_MANY_ROWS THEN
                DBMS_OUTPUT.PUT_LINE('Exista mai multe tari cu acel nume.');
                RAISE;
        END;
        
        SELECT COUNT(*)
        INTO v_nr_orase
        FROM oras
        WHERE id_tara = v_id_tara;
        IF v_nr_orase = 0 THEN
            RAISE NO_CITIES;
        END IF;
        
        SELECT *
        BULK COLLECT INTO t_orase
        FROM oras
        WHERE id_tara = v_id_tara;
        
        k := t_orase.FIRST;
        WHILE k <= t_orase.LAST LOOP
            SELECT SUM(nr_produse)
            INTO v_stoc
            FROM contribuie JOIN stoc USING (id_joc)
                JOIN magazin USING (id_magazin)
            WHERE id_dezvoltator = v_id_dez
                AND id_oras = t_orase(k).id_oras;
                
            SELECT SUM(numar)
            INTO v_vanzari
            FROM contribuie JOIN comanda_contine USING (id_joc)
                JOIN comanda USING (id_comanda)
                JOIN angajat USING (id_angajat)
                JOIN magazin USING (id_magazin)
            WHERE id_dezvoltator = v_id_dez
                AND id_oras = t_orase(k).id_oras;
                
            IF v_stoc IS NULL THEN
                v_stoc := 0;
            END IF;
            IF v_vanzari IS NULL THEN
                v_vanzari := 0;
            END IF;
            
            DBMS_OUTPUT.PUT_LINE('In orasul ' || t_orase(k).nume_oras || ' dezvolatorul are stocul ' || v_stoc || ' si suma totala de vanzari ' || v_vanzari || '.');
            k := t_orase.NEXT(k);
        END LOOP;
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            DBMS_OUTPUT.PUT_LINE('Eroare NO_DATA_FOUND');
        WHEN TOO_MANY_ROWS THEN
            DBMS_OUTPUT.PUT_LINE('Eroare TOO_MANY_ROWS');
        WHEN NO_CITIES THEN
            DBMS_OUTPUT.PUT_LINE('Nu exista orase in acea tara.');
    END;
/

BEGIN
    stoc_dezvoltator('RGG Studios', 'Romania');
    stoc_dezvoltator('Rob', 'Romania');
    stoc_dezvoltator('Atlus', 'Bulgaria');
    stoc_dezvoltator('Atlus', 'ia');
    
    stoc_dezvoltator('Atlus', 'Romania');
END;
/

INSERT INTO tara
VALUES ('PO', 'Polonia');

BEGIN
    stoc_dezvoltator('Atlus', 'Polonia');
END;
/

ROLLBACK;



--Sa nu se poata face o comanda in afara programului (8 - 22 de luni pana vineri, 10 - 20 sambata, 10 - 16 duminica)

CREATE OR REPLACE TRIGGER comanda_in_program
    BEFORE INSERT ON comanda
DECLARE
    v_zi_sapt NUMBER;
    v_ora NUMBER;
BEGIN
    v_zi_sapt := TO_NUMBER(TO_CHAR(SYSDATE, 'D'));
    v_ora := TO_NUMBER(TO_CHAR(SYSDATE, 'HH24'));
    IF (v_zi_sapt BETWEEN 1 AND 5) AND (v_ora < 8 OR v_ora >= 22) THEN
        RAISE_APPLICATION_ERROR(-20001, 'Comanda facuta in afara programului');
    ELSIF (v_zi_sapt = 6) AND (v_ora < 10 OR v_ora >= 20) THEN
        RAISE_APPLICATION_ERROR(-20001, 'Comanda facuta in afara programului');
    ELSIF (v_zi_sapt = 7) AND (v_ora < 10 OR v_ora >= 16) THEN
        RAISE_APPLICATION_ERROR(-20001, 'Comanda facuta in afara programului');
    END IF;
END;
/

INSERT INTO comanda
VALUES(17311230, 1000000, 1000, SYSDATE, 'CASH');

ROLLBACK;

DROP TRIGGER comanda_in_program;



--Sa se valideze datele unui angajat la inserarea, modificarea si stergerea sa

CREATE OR REPLACE TRIGGER validare_angajat
    BEFORE INSERT OR UPDATE OR DELETE ON angajat
    FOR EACH ROW
DECLARE
    v_manager NUMBER;
BEGIN
    IF INSERTING OR UPDATING THEN
        IF (:NEW.telefon IS NOT NULL) AND (:NEW.telefon NOT LIKE '+%') THEN
            RAISE_APPLICATION_ERROR(-20002, 'Numar de telefon invalid');
        ELSIF (:NEW.email IS NOT NULL) AND (:NEW.email NOT LIKE '%_@__%.__%') THEN 
            RAISE_APPLICATION_ERROR(-20003, 'Email invalid');
        ELSIF :NEW.salariu < 500 THEN
            RAISE_APPLICATION_ERROR(-20004, 'Salariu invalid');
        END IF;
    END IF;
    
    IF UPDATING THEN
        IF :NEW.salariu < :OLD.salariu * 3 / 4 THEN
            RAISE_APPLICATION_ERROR(-20004, 'Salariu invalid');
        END IF;
    ELSIF DELETING THEN
        SELECT COUNT(*)
        INTO v_manager
        FROM magazin
        WHERE id_manager = :OLD.id_angajat;
        
        IF v_manager != 0 THEN 
            RAISE_APPLICATION_ERROR(-20005, 'Angajatul inca este manager intr-un magazin');
        END IF;
    END IF;
END;
/

DELETE FROM angajat WHERE id_angajat = 1001;

UPDATE angajat
SET salariu = 400
WHERE id_angajat = 1001;

UPDATE angajat
SET salariu = 600
WHERE id_angajat = 1001;

UPDATE angajat
SET telefon = '012834114'
WHERE id_angajat = 1001;

UPDATE angajat
SET email = '@i.c'
WHERE id_angajat = 1001;

ROLLBACK;

DROP TRIGGER validare_angajat;



--Sa se interzica crearea, alterarea sau stergerea de tabele noi

CREATE OR REPLACE TRIGGER fara_schimbari
    BEFORE CREATE OR DROP OR ALTER ON SCHEMA
BEGIN
    IF SYS.DICTIONARY_OBJ_TYPE LIKE 'TABLE' THEN
        IF SYS.SYSEVENT LIKE 'CREATE' THEN
            RAISE_APPLICATION_ERROR(-20006, 'Nu aveti voie sa mai adaugati tabele');
        ELSIF SYS.SYSEVENT LIKE 'DROP' THEN
            RAISE_APPLICATION_ERROR(-20007, 'Nu aveti voie sa stergeti tabele');
        ELSIF SYS.SYSEVENT LIKE 'ALTER' THEN
            RAISE_APPLICATION_ERROR(-20008, 'Nu aveti voie sa alterati tabele');
        END IF;
    END IF;
END;
/

CREATE TABLE tabel (coloana_1 NUMBER(2));
ALTER TABLE angajat ADD (coloana_2 NUMBER(2));
DROP TABLE angajat;

DROP TRIGGER fara_schimbari;



--Pachet cu obiectele din cerintele anterioare

CREATE OR REPLACE PACKAGE pachet_proiect AS
    PROCEDURE ieftinire_jocuri_ex6;
    PROCEDURE date_magazin_ex7;
    FUNCTION vanzari_magazin_ex8
        (v_nume_mag magazin.nume_magazin%TYPE)
        RETURN NUMBER;
    PROCEDURE stoc_dezvoltator_ex9
        (v_nume_dez dezvoltator.nume_dezvoltator%TYPE,
        v_nume_tara tara.nume_tara%TYPE);
END pachet_proiect;
/

CREATE OR REPLACE PACKAGE BODY pachet_proiect AS
    PROCEDURE ieftinire_jocuri_ex6
    IS
        TYPE tablou_indexat IS TABLE OF joc%ROWTYPE
                            INDEX BY BINARY_INTEGER;
        TYPE tablou_imbricat IS TABLE OF versiune%ROWTYPE;
        TYPE vector IS VARRAY(3) OF platforma%ROWTYPE;
        
        t_jocuri tablou_indexat;
        t_platforme vector := vector();
        t_versiuni tablou_imbricat := tablou_imbricat();
        k INTEGER;
        v_nume_joc joc.titlu%TYPE;
        v_nume_platforma platforma.nume_platforma%TYPE;
        v_pret versiune.pret%TYPE;
        v_ver versiune%ROWTYPE;
        v_count NUMBER;
    
    BEGIN
        SELECT *
        BULK COLLECT INTO t_jocuri
        FROM joc
        WHERE id_joc IN (SELECT id_joc
                        FROM (SELECT id_joc 
                            FROM comanda_contine
                            GROUP BY id_joc
                            ORDER BY SUM(numar))
                        WHERE ROWNUM <= 5);
        
        SELECT *
        BULK COLLECT INTO t_platforme
        FROM platforma
        WHERE id_platforma IN (SELECT id_platforma
                        FROM (SELECT id_platforma
                            FROM comanda_contine
                            GROUP BY id_platforma
                            ORDER BY SUM(numar))
                        WHERE ROWNUM <= 3);
                      
        FOR i in t_jocuri.FIRST..t_jocuri.LAST LOOP
            FOR j in t_platforme.FIRST..t_platforme.LAST LOOP
                SELECT COUNT(*)
                INTO v_count
                FROM versiune
                WHERE id_joc = t_jocuri(i).id_joc AND id_platforma = t_platforme(j).id_platforma;
                IF v_count = 1 THEN
                    SELECT *
                    INTO v_ver
                    FROM versiune
                    WHERE id_joc = t_jocuri(i).id_joc AND id_platforma = t_platforme(j).id_platforma;
                    t_versiuni.EXTEND;
                    t_versiuni(t_versiuni.LAST) := v_ver;
                END IF;
            END LOOP;
        END LOOP;
        
        k := t_versiuni.FIRST;
        WHILE k <= t_versiuni.LAST LOOP
            t_versiuni(k).pret := t_versiuni(k).pret * 4 / 5;
            k := t_versiuni.NEXT(k);
        END LOOP;
        
        k := t_versiuni.FIRST;
        WHILE k <= t_versiuni.LAST LOOP
            SELECT titlu
            INTO v_nume_joc
            FROM joc
            WHERE id_joc = t_versiuni(k).id_joc;
            
            SELECT nume_platforma
            INTO v_nume_platforma
            FROM platforma
            WHERE id_platforma = t_versiuni(k).id_platforma;
            
            SELECT pret
            INTO v_pret
            FROM versiune
            WHERE id_joc = t_versiuni(k).id_joc AND id_platforma = t_versiuni(k).id_platforma;
            
            DBMS_OUTPUT.PUT_LINE('Jocul ' || v_nume_joc || ' de pe platforma ' || v_nume_platforma || ' avea pretul ' || v_pret || ' si a scazut la ' || t_versiuni(k).pret || '.');
            
            UPDATE versiune
            SET pret = t_versiuni(k).pret
            WHERE id_joc = t_versiuni(k).id_joc AND id_platforma = t_versiuni(k).id_platforma;
            
            k := t_versiuni.NEXT(k);
        END LOOP;
    END;
    
    PROCEDURE date_magazin_ex7
    IS
        TYPE refcursor IS REF CURSOR RETURN magazin%ROWTYPE;
        c_magazine refcursor;
        CURSOR c_angajati (id_mag magazin.id_magazin%TYPE) IS
            SELECT *
            FROM angajat
            WHERE id_magazin = id_mag;
        v_mag magazin%ROWTYPE;
        v_nr_ang NUMBER;
        v_avg_sal NUMBER;
    BEGIN
        OPEN c_magazine FOR
            SELECT * FROM magazin;
        LOOP
            FETCH c_magazine INTO v_mag;
            EXIT WHEN c_magazine%NOTFOUND;
            
            DBMS_OUTPUT.PUT_LINE('-------------------------------------');
            DBMS_OUTPUT.PUT_LINE(v_mag.nume_magazin);
            DBMS_OUTPUT.PUT_LINE('Adresa: ' || v_mag.adresa);
            DBMS_OUTPUT.PUT_LINE('-------------------------------------');
            
            v_nr_ang := 0;
            v_avg_sal := 0;
            
            FOR v_ang IN c_angajati(v_mag.id_magazin) LOOP
                DBMS_OUTPUT.PUT_LINE(v_ang.nume || ' ' || v_ang.prenume || ' ' || v_ang.salariu);
                v_nr_ang := v_nr_ang + 1;
                v_avg_sal := v_avg_sal + v_ang.salariu;
            END LOOP;
            
            IF v_nr_ang = 0 THEN
                DBMS_OUTPUT.PUT_LINE('Magazinul nu are angajati');
            ELSE
                v_avg_sal := v_avg_sal / v_nr_ang;
                DBMS_OUTPUT.PUT_LINE('-------------------------------------');
                DBMS_OUTPUT.PUT_LINE('Numarul de angajati: ' || v_nr_ang);
                DBMS_OUTPUT.PUT_LINE('Salariul mediu: ' || v_avg_sal);
            END IF;
            DBMS_OUTPUT.PUT_LINE('-------------------------------------');
            DBMS_OUTPUT.PUT_LINE('');
        END LOOP;
        CLOSE c_magazine;
    END;
    
    FUNCTION vanzari_magazin_ex8
        (v_nume_mag magazin.nume_magazin%TYPE)
    RETURN NUMBER IS
        v_id_mag magazin.id_magazin%TYPE;
        v_nr_ang NUMBER;
        v_nr_comenzi NUMBER;
        v_joc_vand NUMBER;
        NO_EMPLOYEES EXCEPTION;
        NO_SALES EXCEPTION;
    BEGIN
        SELECT id_magazin
        INTO v_id_mag
        FROM magazin
        WHERE UPPER(nume_magazin) LIKE ('%' || UPPER(v_nume_mag) || '%');
      
        SELECT COUNT(*)
        INTO v_nr_ang
        FROM angajat
        WHERE id_magazin = v_id_mag;
        IF v_nr_ang = 0 THEN
            RAISE NO_EMPLOYEES;
        END IF;
        
        SELECT COUNT(*)
        INTO v_nr_comenzi
        FROM comanda
        WHERE id_angajat IN (SELECT id_angajat FROM angajat
                            WHERE id_magazin = v_id_mag);
        IF v_nr_comenzi = 0 THEN
            RAISE NO_SALES;
        END IF;
        
        SELECT SUM(numar)
        INTO v_joc_vand
        FROM comanda_contine JOIN comanda USING (id_comanda)
            JOIN angajat USING (id_angajat)
        WHERE id_magazin = v_id_mag;
        
        RETURN v_joc_vand;
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            DBMS_OUTPUT.PUT_LINE('Nu exista magazin cu acel nume.');
            RETURN -1;
        WHEN TOO_MANY_ROWS THEN
            DBMS_OUTPUT.PUT_LINE('Exista mai multe magazine cu acel nume.');
            RETURN -1;
        WHEN NO_EMPLOYEES THEN
            DBMS_OUTPUT.PUT_LINE('Magazinul nu are angajati.');
            RETURN 0;
        WHEN NO_SALES THEN
            DBMS_OUTPUT.PUT_LINE('Magazinul nu are vanzari.');
            RETURN 0;
    END;
    
    PROCEDURE stoc_dezvoltator_ex9
        (v_nume_dez dezvoltator.nume_dezvoltator%TYPE,
        v_nume_tara tara.nume_tara%TYPE)
    IS
        TYPE tablou_orase IS TABLE OF oras%ROWTYPE;
    
        v_id_dez dezvoltator.id_dezvoltator%TYPE;
        v_id_tara tara.id_tara%TYPE;
        
        v_nr_orase NUMBER;
        v_stoc NUMBER;
        v_vanzari NUMBER;
        t_orase tablou_orase;
        k NUMBER;
        
        NO_CITIES EXCEPTION;
    BEGIN
        BEGIN
            SELECT id_dezvoltator
            INTO v_id_dez
            FROM dezvoltator
            WHERE UPPER(nume_dezvoltator) LIKE ('%' || UPPER(v_nume_dez) || '%');
        EXCEPTION
            WHEN NO_DATA_FOUND THEN
                DBMS_OUTPUT.PUT_LINE('Nu exista dezvoltator cu acel nume.');
                RAISE;
            WHEN TOO_MANY_ROWS THEN
                DBMS_OUTPUT.PUT_LINE('Exista mai multi dezvoltatori cu acel nume.');
                RAISE;
        END;
        
        BEGIN
            SELECT id_tara
            INTO v_id_tara
            FROM tara
            WHERE UPPER(nume_tara) LIKE ('%' || UPPER(v_nume_tara) || '%');
        EXCEPTION
            WHEN NO_DATA_FOUND THEN
                DBMS_OUTPUT.PUT_LINE('Nu exista tara cu acel nume.');
                RAISE;
            WHEN TOO_MANY_ROWS THEN
                DBMS_OUTPUT.PUT_LINE('Exista mai multe tari cu acel nume.');
                RAISE;
        END;
        
        SELECT COUNT(*)
        INTO v_nr_orase
        FROM oras
        WHERE id_tara = v_id_tara;
        IF v_nr_orase = 0 THEN
            RAISE NO_CITIES;
        END IF;
        
        SELECT *
        BULK COLLECT INTO t_orase
        FROM oras
        WHERE id_tara = v_id_tara;
        
        k := t_orase.FIRST;
        WHILE k <= t_orase.LAST LOOP
            SELECT SUM(nr_produse)
            INTO v_stoc
            FROM contribuie JOIN stoc USING (id_joc)
                JOIN magazin USING (id_magazin)
            WHERE id_dezvoltator = v_id_dez
                AND id_oras = t_orase(k).id_oras;
                
            SELECT SUM(numar)
            INTO v_vanzari
            FROM contribuie JOIN comanda_contine USING (id_joc)
                JOIN comanda USING (id_comanda)
                JOIN angajat USING (id_angajat)
                JOIN magazin USING (id_magazin)
            WHERE id_dezvoltator = v_id_dez
                AND id_oras = t_orase(k).id_oras;
                
            IF v_stoc IS NULL THEN
                v_stoc := 0;
            END IF;
            IF v_vanzari IS NULL THEN
                v_vanzari := 0;
            END IF;
            
            DBMS_OUTPUT.PUT_LINE('In orasul ' || t_orase(k).nume_oras || ' dezvolatorul are stocul ' || v_stoc || ' si suma totala de vanzari ' || v_vanzari || '.');
            k := t_orase.NEXT(k);
        END LOOP;
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            DBMS_OUTPUT.PUT_LINE('Eroare NO_DATA_FOUND');
        WHEN TOO_MANY_ROWS THEN
            DBMS_OUTPUT.PUT_LINE('Eroare TOO_MANY_ROWS');
        WHEN NO_CITIES THEN
            DBMS_OUTPUT.PUT_LINE('Nu exista orase in acea tara.');
    END;
END pachet_proiect;
/



--Un flux de actiuni pentru suplimentarea stocului si facerea de comenzi

CREATE OR REPLACE PACKAGE flux_comanda AS
    PROCEDURE suplimentare_stoc
        (v_mag magazin.id_magazin%TYPE, v_joc joc.id_joc%TYPE, v_plat platforma.id_platforma%TYPE, cantitate stoc.nr_produse%TYPE);
        
    PROCEDURE creare_comanda
        (v_client client.id_client%TYPE, v_plata comanda.metoda_plata%TYPE, v_angajat angajat.id_angajat%TYPE, v_online BOOLEAN, v_adresa comanda_online.adresa%TYPE);
        
    PROCEDURE adaugare_item
        (v_joc joc.id_joc%TYPE, v_plat platforma.id_platforma%TYPE, cantitate comanda_contine.numar%TYPE);
        
    FUNCTION verificare_stoc
        (v_mag magazin.id_magazin%TYPE, v_joc joc.id_joc%TYPE, v_plat platforma.id_platforma%TYPE, cantitate stoc.nr_produse%TYPE)
        RETURN BOOLEAN;
        
    FUNCTION pret_comanda
        RETURN NUMBER;
        
    PROCEDURE facere_comanda;
END flux_comanda;
/

CREATE OR REPLACE PACKAGE BODY flux_comanda AS
    TYPE item_comanda IS RECORD
    ( 
        id_joc joc.id_joc%TYPE,
        id_platforma platforma.id_platforma%TYPE,
        cantitate comanda_contine.numar%TYPE
    );
    
    TYPE tablou_iteme IS TABLE OF item_comanda;
    
    TYPE comanda_noua IS RECORD
    (
        id_client client.id_client%TYPE,
        metoda_plata comanda.metoda_plata%TYPE,
        id_angajat angajat.id_angajat%TYPE,
        is_online BOOLEAN,
        adresa comanda_online.adresa%TYPE,
        lista_iteme tablou_iteme := tablou_iteme()
    );
    
    comanda_curenta comanda_noua;
    
    INVALID_CLIENT EXCEPTION;
    INVALID_EMPLOYEE EXCEPTION;
    INVALID_GAME EXCEPTION;
    INVALID_STOC EXCEPTION;
    INVALID_SHOP EXCEPTION;
    
    PROCEDURE suplimentare_stoc
        (v_mag magazin.id_magazin%TYPE, v_joc joc.id_joc%TYPE, v_plat platforma.id_platforma%TYPE, cantitate stoc.nr_produse%TYPE)
    IS
        v_in_stoc NUMBER;
        v_valid_joc NUMBER;
        v_valid_mag NUMBER;
    BEGIN
        SELECT COUNT(*)
        INTO v_valid_joc
        FROM versiune 
        WHERE id_joc = v_joc AND id_platforma = v_plat;
        
        IF v_valid_joc = 0 THEN
            RAISE INVALID_GAME;
        END IF;
        
        SELECT COUNT(*)
        INTO v_valid_mag
        FROM magazin
        WHERE id_magazin = v_mag;
        
        IF v_valid_mag = 0 THEN
            RAISE INVALID_SHOP;
        END IF;
        
        SELECT COUNT(*)
        INTO v_in_stoc
        FROM stoc
        WHERE id_magazin = v_mag AND id_joc = v_joc AND id_platforma = v_plat;
        
        IF v_in_stoc = 0 THEN
            INSERT INTO stoc
            VALUES(v_mag, v_joc, v_plat, cantitate);
        ELSE
            UPDATE stoc
            SET nr_produse = nr_produse + cantitate
            WHERE id_magazin = v_mag AND id_joc = v_joc AND id_platforma = v_plat;
        END IF;
    EXCEPTION 
        WHEN INVALID_GAME THEN
            DBMS_OUTPUT.PUT_LINE('Joc invalid');
        WHEN INVALID_SHOP THEN
            DBMS_OUTPUT.PUT_LINE('Magazin invalid');
    END;
    
    PROCEDURE creare_comanda
        (v_client client.id_client%TYPE, v_plata comanda.metoda_plata%TYPE, v_angajat angajat.id_angajat%TYPE, v_online BOOLEAN, v_adresa comanda_online.adresa%TYPE) 
    IS
        v_valid_client NUMBER;
        v_valid_angajat NUMBER;
    BEGIN
        SELECT COUNT(*)
        INTO v_valid_client
        FROM client
        WHERE id_client = v_client;
        
        SELECT COUNT(*)
        INTO v_valid_angajat
        FROM angajat
        WHERE id_angajat = v_angajat;
        
        IF v_valid_client = 0 THEN
            RAISE INVALID_CLIENT;
        ELSIF v_valid_angajat = 0 THEN
            RAISE INVALID_EMPLOYEE;
        END IF;
        
        comanda_curenta.id_client := v_client;
        comanda_curenta.metoda_plata := v_plata;
        comanda_curenta.id_angajat := v_angajat;
        comanda_curenta.is_online := v_online;
        comanda_curenta.adresa := v_adresa;
    EXCEPTION
        WHEN INVALID_CLIENT THEN
            DBMS_OUTPUT.PUT_LINE('Clientul nu exista');
        WHEN INVALID_EMPLOYEE THEN
            DBMS_OUTPUT.PUT_LINE('Angajatul nu exista');
    END;
    
    PROCEDURE adaugare_item
        (v_joc joc.id_joc%TYPE, v_plat platforma.id_platforma%TYPE, cantitate comanda_contine.numar%TYPE)
    IS
        v_in_lista BOOLEAN := FALSE;
        v_valid_joc NUMBER;
        v_nou_item item_comanda;
        k INTEGER;
    BEGIN
        SELECT COUNT(*)
        INTO v_valid_joc
        FROM versiune 
        WHERE id_joc = v_joc AND id_platforma = v_plat;
        
        IF v_valid_joc = 0 THEN
            RAISE INVALID_GAME;
        END IF;
        
        k := comanda_curenta.lista_iteme.FIRST;
        WHILE k <= comanda_curenta.lista_iteme.LAST LOOP
            IF comanda_curenta.lista_iteme(k).id_joc = v_joc AND comanda_curenta.lista_iteme(k).id_platforma = v_plat THEN
                v_in_lista := TRUE;
                comanda_curenta.lista_iteme(k).cantitate := comanda_curenta.lista_iteme(k).cantitate + cantitate;
            END IF;
            k := comanda_curenta.lista_iteme.NEXT(k);
        END LOOP;
        IF v_in_lista = FALSE THEN
            v_nou_item.id_joc := v_joc;
            v_nou_item.id_platforma := v_plat;
            v_nou_item.cantitate := cantitate;
            comanda_curenta.lista_iteme.EXTEND;
            comanda_curenta.lista_iteme(comanda_curenta.lista_iteme.LAST) := v_nou_item;
        END IF;
    EXCEPTION 
        WHEN INVALID_GAME THEN
            DBMS_OUTPUT.PUT_LINE('Joc invalid');
    END;
    
    FUNCTION verificare_stoc
        (v_mag magazin.id_magazin%TYPE, v_joc joc.id_joc%TYPE, v_plat platforma.id_platforma%TYPE, cantitate stoc.nr_produse%TYPE)
        RETURN BOOLEAN 
    IS
        v_in_tabel NUMBER;
        v_nr_stoc stoc.nr_produse%TYPE;
        v_in_stoc BOOLEAN;
    BEGIN
        SELECT COUNT(*)
        INTO v_in_tabel
        FROM stoc
        WHERE id_magazin = v_mag AND id_joc = v_joc AND id_platforma = v_plat;
        
        IF v_in_tabel = 0 THEN
            v_in_stoc := FALSE;
        ELSE
            SELECT nr_produse
            INTO v_nr_stoc
            FROM stoc
            WHERE id_magazin = v_mag AND id_joc = v_joc AND id_platforma = v_plat;
            
            IF v_nr_stoc < cantitate THEN
                v_in_stoc := FALSE;
            ELSE
                v_in_stoc := TRUE;
            END IF;
        END IF;
        
        RETURN v_in_stoc;
    END;
    
    FUNCTION pret_comanda
        RETURN NUMBER
    IS
        v_total NUMBER;
        v_pret versiune.pret%TYPE;
        k INTEGER;
    BEGIN
        v_total := 0;
        k := comanda_curenta.lista_iteme.FIRST;
        WHILE k <= comanda_curenta.lista_iteme.LAST LOOP
            SELECT pret
            INTO v_pret
            FROM versiune 
            WHERE id_joc = comanda_curenta.lista_iteme(k).id_joc AND id_platforma = comanda_curenta.lista_iteme(k).id_platforma;
            
            v_total := v_total + v_pret * comanda_curenta.lista_iteme(k).cantitate;
            k := comanda_curenta.lista_iteme.NEXT(k);
        END LOOP;
        
        RETURN v_total;
    EXCEPTION 
        WHEN NO_DATA_FOUND THEN
            DBMS_OUTPUT.PUT_LINE('Joc invalid in lista comenzii');
    END;
    
    PROCEDURE facere_comanda
    IS
        k INTEGER;
        v_valid_stoc BOOLEAN;
        v_mag magazin.id_magazin%TYPE;
        v_id_comanda comanda.id_comanda%TYPE;
    BEGIN
        SELECT id_magazin
        INTO v_mag
        FROM angajat
        WHERE id_angajat = comanda_curenta.id_angajat;
        
        k := comanda_curenta.lista_iteme.FIRST;
        WHILE k <= comanda_curenta.lista_iteme.LAST LOOP
            v_valid_stoc := verificare_stoc(v_mag, comanda_curenta.lista_iteme(k).id_joc, comanda_curenta.lista_iteme(k).id_platforma, comanda_curenta.lista_iteme(k).cantitate);
            IF v_valid_stoc = FALSE THEN
                RAISE INVALID_STOC;
            END IF;
            
            k := comanda_curenta.lista_iteme.NEXT(k);
        END LOOP;
        
        v_id_comanda := secventa_comanda.NEXTVAL;
        
        INSERT INTO comanda
        VALUES (v_id_comanda, comanda_curenta.id_client, comanda_curenta.id_angajat, SYSDATE, comanda_curenta.metoda_plata);
        
        IF comanda_curenta.is_online = TRUE THEN
            INSERT INTO comanda_online
            VALUES (v_id_comanda, comanda_curenta.adresa, SYSDATE + 2);
        END IF;
        
        k := comanda_curenta.lista_iteme.FIRST;
        WHILE k <= comanda_curenta.lista_iteme.LAST LOOP
            UPDATE stoc
            SET nr_produse = nr_produse - comanda_curenta.lista_iteme(k).cantitate
            WHERE id_joc = comanda_curenta.lista_iteme(k).id_joc AND id_platforma = comanda_curenta.lista_iteme(k).id_platforma AND id_magazin = v_mag;
        
            INSERT INTO comanda_contine
            VALUES (comanda_curenta.lista_iteme(k).id_joc, comanda_curenta.lista_iteme(k).id_platforma, v_id_comanda, comanda_curenta.lista_iteme(k).cantitate);
        
            k := comanda_curenta.lista_iteme.NEXT(k);
        END LOOP;
        
        comanda_curenta.lista_iteme.DELETE();
        
        comanda_curenta.id_client := NULL;
        comanda_curenta.metoda_plata := NULL;
        comanda_curenta.id_angajat := NULL;
        comanda_curenta.is_online := NULL;
        comanda_curenta.adresa := NULL;
    EXCEPTION
        WHEN INVALID_STOC THEN
            comanda_curenta.lista_iteme.DELETE();
            comanda_curenta.id_client := NULL;
            comanda_curenta.metoda_plata := NULL;
            comanda_curenta.id_angajat := NULL;
            comanda_curenta.is_online := NULL;
            comanda_curenta.adresa := NULL;
            DBMS_OUTPUT.PUT_LINE('Nu exista stoc sufficient');
        WHEN OTHERS THEN
            comanda_curenta.lista_iteme.DELETE();
            comanda_curenta.id_client := NULL;
            comanda_curenta.metoda_plata := NULL;
            comanda_curenta.id_angajat := NULL;
            comanda_curenta.is_online := NULL;
            comanda_curenta.adresa := NULL;
            DBMS_OUTPUT.PUT_LINE('Data invalide');
    END;
    
END flux_comanda;
/

EXECUTE flux_comanda.creare_comanda(1000007, 'CASH', 1000, TRUE, NULL);
EXECUTE flux_comanda.creare_comanda(1000000, 'CASH', 999, TRUE, NULL);
EXECUTE flux_comanda.creare_comanda(1000000, 'CASH', 1000, TRUE, NULL);

EXECUTE flux_comanda.adaugare_item(100290, 2, 1);
EXECUTE flux_comanda.adaugare_item(1, 2, 1);

BEGIN
    DBMS_OUTPUT.PUT_LINE(flux_comanda.pret_comanda());
END;
/

EXECUTE flux_comanda.suplimentare_stoc(300, 1, 2, 1);
EXECUTE flux_comanda.suplimentare_stoc(299, 100290, 2, 1);
EXECUTE flux_comanda.suplimentare_stoc(300, 100290, 2, 1);

EXECUTE flux_comanda.facere_comanda();
EXECUTE flux_comanda.facere_comanda();

EXECUTE flux_comanda.creare_comanda(1000000, 'CASH', 1000, TRUE, NULL);
EXECUTE flux_comanda.adaugare_item(40741, 4, 5);
BEGIN
    DBMS_OUTPUT.PUT_LINE(flux_comanda.pret_comanda());
END;
/
EXECUTE flux_comanda.facere_comanda();

ROLLBACK;
