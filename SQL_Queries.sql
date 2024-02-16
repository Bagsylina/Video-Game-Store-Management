--Sa se afiseze jocul, descrierea sa ("Fara descriere" daca nu are), "Da" sau "Nu" daca jocul are multiplayer, luna si anul in care au fost lansate prima data
--jocurile pentru jocurile lansate ianinte de 2018 sortate dupa data lansarii 

WITH lans_init AS (SELECT MIN(data_lansare) data_init, id_joc 
                FROM versiune 
                GROUP BY id_joc)
SELECT id_joc, titlu, NVL(descriere, 'Fara descriere') descriere, DECODE(multiplayer, 1, 'Da', 'Nu') multiplayer, TO_CHAR(data_init, 'mm-yyyy') data_lansare
FROM joc JOIN lans_init USING (id_joc)
WHERE TO_NUMBER(TO_CHAR(data_init, 'yyyy')) < 2018
ORDER BY data_init;

--Sa se afiseze jocurile (id, titlu, gen) care sunt si pe playstation, iar acea versiune se afla in stoc intr-un magazin

SELECT id_joc, titlu, gen
FROM joc j
WHERE EXISTS(SELECT id_platforma FROM versiune JOIN platforma USING (id_platforma)
                    JOIN stoc USING (id_joc, id_platforma)
            WHERE UPPER(nume_platforma) like '%PLAYSTATION%' AND id_joc = j.id_joc AND nr_produse > 0 AND nr_produse IS NOT NULL);
            
--Se cer orasele in care sunt cel putin 2 magazine si media salariilor angajatilor din ele 
--pentru orasele care au media salariului peste media totala a tuturor oraselor
                            
SELECT id_oras, nume_oras, ROUND(AVG(salariu)) Salariu_mediu
FROM oras JOIN magazin USING (id_oras)
JOIN angajat USING (id_magazin)
GROUP BY id_oras, nume_oras
HAVING AVG(salariu) > (SELECT AVG(AVG(salariu))
                        FROM oras JOIN magazin USING (id_oras)
                                JOIN angajat USING (id_magazin)
                        GROUP BY id_oras)
AND COUNT(DISTINCT id_magazin) >= 2;

--Sa se afiseze pentru fiecare magazin (pe langa id si nume):
--pentru magazinele din Romania numarul de angajati
--pentru magazinele din Marea Britanie media salariilor angajatilor
--pentru magazinele din Olanda cel mai mare salariu
--iar pentru restul magazinelor cel mai mic salariu

SELECT id_magazin, nume_magazin,
CASE LOWER(nume_tara)
    WHEN 'romania' THEN COUNT(id_angajat)
    WHEN 'marea britanie' THEN ROUND(AVG(salariu))
    WHEN 'olanda' THEN MAX(salariu)
    ELSE MIN(salariu)
END "Raspuns"
FROM angajat JOIN magazin USING (id_magazin)
            JOIN oras USING (id_oras)
            JOIN tara USING (id_tara)
GROUP BY id_magazin, nume_magazin, nume_tara;

--Sa se afiseze pentru fiecare client numarul total de jocuri cumparate si numarul de jocuri cumparate online

SELECT cl.id_client, nume, prenume, SUM(numar) total_cumparat, SUM(NVL2(co.id_comanda, numar, 0)) cumparat_online
FROM client cl JOIN comanda c ON (cl.id_client = c.id_client)
        JOIN comanda_contine cc ON (cc.id_comanda = c.id_comanda)
        LEFT JOIN comanda_online co ON (c.id_comanda = co.id_comanda)
GROUP BY cl.id_client, nume, prenume;



--Sa se scada pretul cu 25% jocurilor publicate de Atlus

UPDATE versiune
SET pret = pret * 0.75
WHERE id_joc IN (SELECT id_joc FROM joc
                JOIN contribuie USING (id_joc)
                JOIN editor USING (id_editor)
                WHERE nume_editor = 'Atlus');
                
--Sa se creasca salariul cu 400 angajatilor din Romania angajati inainte de mai 2023

UPDATE angajat
SET salariu = salariu + 400
WHERE id_magazin IN (SELECT id_magazin FROM magazin
                    JOIN oras USING (id_oras)
                    JOIN tara USING (id_tara)
                    WHERE nume_tara = 'Romania')
AND data_angajare < TO_DATE('MAY-2023','MON-YYYY');
                
--Sa se dubleze numarul jucatorilor din jocurile online ce se afla pe PC

UPDATE joc_online
SET nr_jucatori = nr_jucatori * 2
WHERE id_joc IN (SELECT id_joc FROM versiune
            JOIN platforma USING (id_platforma)
            WHERE tip_platforma = 'PC');
--Sa se stearga jocurile cu versiuni de sub 10GB

DELETE FROM joc
WHERE id_joc IN (SELECT id_joc FROM versiune WHERE dimensiune < 10);

--Sa se sterga platformele pentru care nu exista jocuri in stoc

DELETE FROM platforma p
WHERE NOT EXISTS (SELECT id_platforma FROM stoc WHERE p.id_platforma = id_platforma);

--Sa se stearga clientii care nu au facut nicio comanda online
DELETE FROM client
WHERE id_client NOT IN (SELECT id_client
                        FROM comanda JOIN comanda_online USING(id_comanda)); 
        
        

--Ce stoc au jocurile in total de la fiecare dezvoltator in fiecare tara

SELECT nume_dezvoltator, nume_tara, SUM(NVL(nr_produse, 0)) numar
FROM dezvoltator d CROSS JOIN tara t
            LEFT JOIN oras o ON (o.id_tara = t.id_tara)
            LEFT JOIN magazin m ON (o.id_oras = m.id_oras)
            LEFT JOIN contribuie c ON (d.id_dezvoltator = c.id_dezvoltator)
            LEFT JOIN stoc s ON (c.id_joc = s.id_joc AND s.id_magazin = m.id_magazin)
GROUP BY nume_dezvoltator, nume_tara;

--Care sunt jocurile care se afla pe toate platformele de tip PC

SELECT id_joc, titlu
FROM joc JOIN versiune USING (id_joc)
WHERE id_platforma IN (SELECT id_platforma
                FROM platforma
                WHERE tip_platforma = 'PC')
GROUP BY id_joc, titlu
HAVING COUNT(id_platforma) = (SELECT COUNT(*)
                        FROM platforma
                        WHERE tip_platforma = 'PC');

--Sa se afiseze primele 5 jocuri dupa numarul total de vanzari.

SELECT id_joc, titlu, nr_vanzari
FROM (SELECT id_joc, titlu, SUM(numar) nr_vanzari 
    FROM joc JOIN comanda_contine USING(id_joc)
    GROUP BY id_joc, titlu
    ORDER BY nr_vanzari DESC)
WHERE ROWNUM <= 5;



--Sa se afiseze angajatii care lucreaza in bucuresti si care s-au angajat inainte de 2023

--neoptimizat
SELECT id_angajat, nume, prenume
FROM angajat JOIN magazin USING (id_magazin)
            JOIN oras USING (id_oras)
WHERE nume_oras = 'Bucuresti' AND TO_NUMBER(TO_CHAR(data_angajare, 'yyyy')) < 2023;

--optimizat
SELECT id_angajat, nume, prenume
FROM (SELECT id_oras FROM oras WHERE nume_oras = 'Bucuresti')
    JOIN (SELECT id_magazin, id_oras FROM magazin) USING (id_oras)
    JOIN (SELECT id_angajat, nume, prenume, id_magazin FROM angajat
        WHERE TO_NUMBER(TO_CHAR(data_angajare, 'yyyy')) < 2023) USING (id_magazin);