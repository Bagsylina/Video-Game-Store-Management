--Data Insertion

CREATE SEQUENCE secventa_client
START WITH 1000000
INCREMENT BY 1;

CREATE SEQUENCE secventa_comanda
START WITH 1000000000
INCREMENT BY 37182341
MINVALUE 1000000000
MAXVALUE 9999999999
CYCLE;

INSERT ALL
INTO tara VALUES ('RO', 'Romania')
INTO tara VALUES ('NL', 'Olanda')
INTO tara VALUES ('GB', 'Marea Britanie')
INTO tara VALUES ('IT', 'Italia')
INTO tara VALUES ('HU', 'Ungaria')
SELECT * FROM DUAL;

INSERT ALL
INTO oras VALUES(11, 'Bucuresti', 'RO')
INTO oras VALUES(12, 'Galati', 'RO')
INTO oras VALUES(13, 'Cluj', 'RO')
INTO oras VALUES(14, 'Amsterdam', 'NL')
INTO oras VALUES(15, 'Brasov', 'RO')
INTO oras VALUES(16, 'Londra', 'GB')
INTO oras VALUES(17, 'Roma', 'IT')
INTO oras VALUES(18, 'Rotterdam', 'NL')
INTO oras VALUES(19, 'Budapesta', 'HU')
INTO oras VALUES(20, 'Milano', 'IT')
SELECT * FROM DUAL;


INSERT ALL
INTO magazin
VALUES(300, 'Gameshop AFI', 'Bulevardul General Paul Teodorescu 4', 11, NULL)
INTO magazin
VALUES(301, 'Gameshop Centru Vechi', 'Strada Lipscani 55, Bucure?ti', 11, NULL)
INTO magazin
VALUES(302, 'Gamecorner Tiglina', 'Strada Br?ilei nr. 163, 800309', 12, NULL)
INTO magazin
VALUES(303, 'Gamecorner Gorjului', 'Bulevardul Iuliu Maniu 67', 11, NULL)
INTO magazin
VALUES(304, 'Gameshop Cluj', 'Strada Alexandru Vaida Voevod 59, 400436', 13, NULL)
INTO magazin
VALUES(305, 'Gameshop Amsterdam', NULL, 14, NULL)
INTO magazin
VALUES(306, 'Megagame Brasov', 'Bulevardul 15 Noiembrie 78', 15, NULL)
INTO magazin
VALUES(307, 'Gamecorner Walworth', 'East St, London SE17 1EL', 16, NULL)
INTO magazin
VALUES(308, 'Gameshop Roma', NULL, 17, NULL)
INTO magazin
VALUES(309, 'Gameshop Rotterdam', 'Willem Ruyslaan 225, 3063 ER', 18, NULL)
INTO magazin
VALUES(310, 'Megashop Londra', '12 Walbrook, London EC4N 8AA', 16, NULL)
INTO magazin
VALUES(311, 'Gamecorner Budapesta 1', 'Magl?di ?t 14/B, 1106', 19, NULL)
INTO magazin
VALUES(312, 'Gamecorner Potcoava', 'Strada Brailei, Nr.17, Complex Comercial Potcoava de Aur', 12, NULL)
INTO magazin
VALUES(313, 'Gameshop Milano', 'Via Lorenteggio, 219, 20147 Milano MI', 20, NULL)
INTO magazin
VALUES(314, 'Gamecorner Budapesta 2', 'K?nyves K?lm?n krt. 12-14, 1097', 19, NULL)
SELECT * FROM DUAL;

INSERT ALL
INTO joc
VALUES(100290, 'Nier: Automata', 'Nier: Automata spune povestea androizilor 2B, 9S si A2 si lupta lor pentru recapatarea distopiei controlate de masinarii puternice.', 'Action JRPG', 0, 18)
INTO joc
VALUES(40741, 'Persona 5 Royal', 'Scoate-ti masca si alatura-te Hotilor Fantoma si furturilor lor magnifice, cum infiltreaza mintilor oamenilor corupti, facandu-i sa-si schimbe caile.', 'Turn-based JRPG', 0, 16)
INTO joc
VALUES(40742, 'Persona 5 Strikers', NULL, 'Hack and Slash', 0, 16)
INTO joc
VALUES(460000, 'Rainbow Six: Siege', 'Rainbow Six: Siege este un shooter tactic de elita pe echipe, unde planificarile superioare si executiile trimfa.', 'Team Shooter', 1, 18)
INTO joc
VALUES(101000, 'Shin Megami Tensei V', NULL, 'Turn-based JRPG', 0, 16)
INTO joc
VALUES(102000, 'Counter Strike 2', NULL, 'Team Shooter', 1, 18)
INTO joc
VALUES(103000, 'Brawl Stars', NULL, 'Topdown Shooter', 1, 7)
INTO joc
VALUES(104000, 'Minecraft Bedrock', NULL, 'Sandbox', 1, 7)
INTO joc
VALUES(105000, 'Ghost Recon: Wildlands', NULL, 'Open World', 1, 18)
INTO joc
VALUES(106000, 'Cyberpunk 2077', NULL, 'Action RPG', 0, 18)
INTO joc
VALUES(107000, 'The Witcher 3', NULL, 'Open World', 0, 18)
INTO joc
VALUES(108000, 'Geometry Dash', NULL, 'Platformer', 0, 3)
INTO joc
VALUES(25200, 'Soul Hackers 2', NULL, 'Turn-based JRPG', 0, 16)
INTO joc
VALUES(109000, 'Roblox', NULL, 'Sandbox', 1, 3)
SELECT * FROM DUAL;

INSERT ALL
INTO joc_online VALUES(460000, 3800000, 1, 1)
INTO joc_online VALUES(102000, 10000000, 0, 0)
INTO joc_online VALUES(103000, 1000000, 1, 1)
INTO joc_online VALUES(104000, 30000000, 1, 0)
INTO joc_online VALUES(105000, 20000, 1, 1)
INTO joc_online VALUES(109000, 17800000, 1, 1)
SELECT * FROM DUAL;

INSERT ALL
INTO platforma VALUES(1, 'Windows', 'PC')
INTO platforma VALUES(2, 'Playstation 4', 'Consola')
INTO platforma VALUES(3, 'Playstation 5', 'Consola')
INTO platforma VALUES(4, 'Xbox One', 'Consola')
INTO platforma VALUES(5, 'Xbox Series X', 'Consola')
INTO platforma VALUES(6, 'Xbox Series S', 'Consola')
INTO platforma VALUES(7, 'Nintendo Switch', 'Handheld')
INTO platforma VALUES(8, 'Steam Deck', 'Handheld')
INTO platforma VALUES(9, 'Android', 'Telefon')
INTO platforma VALUES(10, 'IOS', 'Telefon')
INTO platforma VALUES(11, 'Stadia', 'Cloud')
INTO platforma VALUES(12, 'Linux', 'PC')
SELECT * FROM DUAL;


INSERT ALL
INTO versiune VALUES(100290, 1, 40.8, TO_DATE('17-03-2017', 'dd-mm-yyyy'), 40)
INTO versiune VALUES(100290, 2, 38, TO_DATE('23-02-2017', 'dd-mm-yyyy'), 40)
INTO versiune VALUES(100290, 4, 38, TO_DATE('26-06-2018', 'dd-mm-yyyy'), 40)
INTO versiune VALUES(100290, 7, 15, TO_DATE('06-10-2022', 'dd-mm-yyyy'), 60)
INTO versiune VALUES(100290, 8, 40.8, TO_DATE('17-03-2017', 'dd-mm-yyyy'), 40)
INTO versiune VALUES(40741, 1, 39.3, TO_DATE('21-10-2022', 'dd-mm-yyyy'), 60)
INTO versiune VALUES(40741, 2, 33.2, TO_DATE('31-03-2020', 'dd-mm-yyyy'), 40)
INTO versiune VALUES(40741, 3, 39.3, TO_DATE('21-10-2022', 'dd-mm-yyyy'), 60)
INTO versiune VALUES(40741, 4, 39.3, TO_DATE('21-10-2022', 'dd-mm-yyyy'), 60)
INTO versiune VALUES(40741, 5, 39.3, TO_DATE('21-10-2022', 'dd-mm-yyyy'), 60)
INTO versiune VALUES(40741, 6, 39.3, TO_DATE('21-10-2022', 'dd-mm-yyyy'), 60)
INTO versiune VALUES(40741, 7, 21.1, TO_DATE('21-10-2022', 'dd-mm-yyyy'), 60)
INTO versiune VALUES(40741, 8, 39.3, TO_DATE('21-10-2022', 'dd-mm-yyyy'), 60)
INTO versiune VALUES(40742, 1, 31.5, TO_DATE('23-02-2021', 'dd-mm-yyyy'), 40)
INTO versiune VALUES(40742, 2, 31.5, TO_DATE('23-02-2021', 'dd-mm-yyyy'), 40)
INTO versiune VALUES(40742, 3, 31.5, TO_DATE('23-02-2021', 'dd-mm-yyyy'), 40)
INTO versiune VALUES(40742, 7, 18.2, TO_DATE('23-02-2021', 'dd-mm-yyyy'), 40)
INTO versiune VALUES(460000, 1, 54.5, TO_DATE('01-12-2015', 'dd-mm-yyyy'), 20)
INTO versiune VALUES(460000, 2, 40.2, TO_DATE('01-12-2015', 'dd-mm-yyyy'), 20)
INTO versiune VALUES(460000, 4, 40.2, TO_DATE('01-12-2015', 'dd-mm-yyyy'), 20)
INTO versiune VALUES(460000, 3, 50.7, TO_DATE('01-12-2020', 'dd-mm-yyyy'), 30)
INTO versiune VALUES(460000, 5, 50.7, TO_DATE('01-12-2020', 'dd-mm-yyyy'), 30)
INTO versiune VALUES(460000, 6, 50.7, TO_DATE('01-12-2020', 'dd-mm-yyyy'), 30)
INTO versiune VALUES(460000, 11, 0, TO_DATE('30-6-2021', 'dd-mm-yyyy'), 8)
INTO versiune VALUES(101000, 7, 16, TO_DATE('12-11-2021', 'dd-mm-yyyy'), 60)
INTO versiune VALUES(102000, 1, 30.7, TO_DATE('21-08-2012','dd-mm-yyyy'), 10)
INTO versiune VALUES(102000, 8, 30.7, TO_DATE('21-08-2012','dd-mm-yyyy'), 10)
INTO versiune VALUES(102000, 12, 30.7, TO_DATE('23-09-2014','dd-mm-yyyy'), 10)
INTO versiune VALUES(103000, 9, 2.99, TO_DATE('12-12-2018','dd-mm-yyyy'), 0)
INTO versiune VALUES(103000, 10, 2.99, TO_DATE('12-12-2018','dd-mm-yyyy'), 0)
INTO versiune VALUES(104000, 1, 2, TO_DATE('29-07-2015','dd-mm-yyyy'), 20)
INTO versiune VALUES(104000, 2, 2, TO_DATE('29-07-2015','dd-mm-yyyy'), 20)
INTO versiune VALUES(104000, 4, 2, TO_DATE('29-07-2015','dd-mm-yyyy'), 20)
INTO versiune VALUES(104000, 7, 2, TO_DATE('29-07-2015','dd-mm-yyyy'), 20)
INTO versiune VALUES(104000, 9, 0.33, TO_DATE('07-10-2011','dd-mm-yyyy'), 8)
INTO versiune VALUES(104000, 10, 0.33, TO_DATE('17-11-2011','dd-mm-yyyy'), 8)
INTO versiune VALUES(105000, 1, 76.3, TO_DATE('07-03-2017','dd-mm-yyyy'), 50)
INTO versiune VALUES(105000, 2, 76.3, TO_DATE('07-03-2017','dd-mm-yyyy'), 50)
INTO versiune VALUES(105000, 4, 76.3, TO_DATE('07-03-2017','dd-mm-yyyy'), 50)
INTO versiune VALUES(105000, 11, 0, TO_DATE('07-03-2017','dd-mm-yyyy'), 50)
INTO versiune VALUES(106000, 1, 70, TO_DATE('10-12-2020','dd-mm-yyyy'), 60)
INTO versiune VALUES(106000, 3, 70, TO_DATE('10-12-2020','dd-mm-yyyy'), 60)
INTO versiune VALUES(106000, 5, 70, TO_DATE('10-12-2020','dd-mm-yyyy'), 60)
INTO versiune VALUES(106000, 6, 70, TO_DATE('10-12-2020','dd-mm-yyyy'), 60)
INTO versiune VALUES(107000, 1, 43.7, TO_DATE('19-05-2015','dd-mm-yyyy'), 30)
INTO versiune VALUES(107000, 2, 43.7, TO_DATE('19-05-2015','dd-mm-yyyy'), 30)
INTO versiune VALUES(107000, 4, 43.7, TO_DATE('19-05-2015','dd-mm-yyyy'), 30)
INTO versiune VALUES(107000, 3, 43.7, TO_DATE('14-12-2022','dd-mm-yyyy'), 30)
INTO versiune VALUES(107000, 5, 43.7, TO_DATE('14-12-2022','dd-mm-yyyy'), 30)
INTO versiune VALUES(107000, 6, 43.7, TO_DATE('14-12-2022','dd-mm-yyyy'), 30)
INTO versiune VALUES(107000, 7, 19.2, TO_DATE('15-10-2019','dd-mm-yyyy'), 40)
INTO versiune VALUES(108000, 1, 0.18, TO_DATE('22-12-2014','dd-mm-yyyy'), 4)
INTO versiune VALUES(108000, 9, 0.18, TO_DATE('13-08-2013','dd-mm-yyyy'), 4)
INTO versiune VALUES(108000, 10, 0.18, TO_DATE('13-08-2013','dd-mm-yyyy'), 4)
INTO versiune VALUES(108000, 12, 0.18, TO_DATE('22-12-2014','dd-mm-yyyy'), 4)
INTO versiune VALUES(25200, 1, 20.5, TO_DATE('26-08-2022','dd-mm-yyyy'), 60)
INTO versiune VALUES(25200, 2, 20.5, TO_DATE('26-08-2022','dd-mm-yyyy'), 60)
INTO versiune VALUES(25200, 4, 20.5, TO_DATE('26-08-2022','dd-mm-yyyy'), 60)
INTO versiune VALUES(109000, 1, 1, TO_DATE('01-09-2006','dd-mm-yyyy'), 0)
INTO versiune VALUES(109000, 9, 1, TO_DATE('16-07-2014','dd-mm-yyyy'), 0)
INTO versiune VALUES(109000, 10, 1, TO_DATE('11-12-2012','dd-mm-yyyy'), 0)
INTO versiune VALUES(109000, 12, 1, TO_DATE('01-09-2006','dd-mm-yyyy'), 0)
SELECT * FROM DUAL;


INSERT ALL
INTO stoc VALUES(300, 100290, 1, 20)
INTO stoc VALUES(300, 100290, 2, 15)
INTO stoc VALUES(300, 40741, 4, 4)
INTO stoc VALUES(300, 40741, 1, 30)
INTO stoc VALUES(300, 40741, 7, 10)
INTO stoc VALUES(300, 101000, 7, 3)
INTO stoc VALUES(300, 102000, 1, 300)
INTO stoc VALUES(300, 106000, 1, 98)
INTO stoc VALUES(300, 25200, 1, 134)
INTO stoc VALUES(301, 101000, 7, 201)
INTO stoc VALUES(301, 102000, 1, 153)
INTO stoc VALUES(301, 103000, 10, 40)
INTO stoc VALUES(301, 104000, 1, 329)
INTO stoc VALUES(301, 105000, 1, 104)
INTO stoc VALUES(301, 106000, 1, 30)
INTO stoc VALUES(301, 107000, 1, 309)
INTO stoc VALUES(301, 108000, 1, 980)
INTO stoc VALUES(301, 109000, 1, 189)
INTO stoc VALUES(302, 100290, 1, 4)
INTO stoc VALUES(302, 100290, 4, 5)
INTO stoc VALUES(302, 100290, 7, 1)
INTO stoc VALUES(302, 101000, 7, 1)
INTO stoc VALUES(302, 104000, 1, 35)
INTO stoc VALUES(302, 105000, 1, 16)
INTO stoc VALUES(304, 460000, 1, 20)
INTO stoc VALUES(304, 460000, 2, 20)
INTO stoc VALUES(304, 460000, 4, 20)
INTO stoc VALUES(304, 105000, 1, 30)
INTO stoc VALUES(304, 105000, 2, 30)
INTO stoc VALUES(304, 105000, 4, 30)
INTO stoc VALUES(305, 40741, 7, 178)
INTO stoc VALUES(305, 40742, 7, 341)
INTO stoc VALUES(305, 101000, 7, 250)
INTO stoc VALUES(305, 25200, 2, 999)
INTO stoc VALUES(306, 100290, 1, 20)
INTO stoc VALUES(306, 100290, 2, 15)
INTO stoc VALUES(306, 40741, 4, 4)
INTO stoc VALUES(306, 40741, 1, 30)
INTO stoc VALUES(306, 40741, 7, 10)
INTO stoc VALUES(306, 101000, 7, 3)
INTO stoc VALUES(306, 102000, 1, 300)
INTO stoc VALUES(306, 106000, 1, 98)
INTO stoc VALUES(306, 25200, 1, 134)
INTO stoc VALUES(306, 102000, 8, 153)
INTO stoc VALUES(306, 103000, 10, 40)
INTO stoc VALUES(306, 104000, 1, 329)
INTO stoc VALUES(306, 105000, 1, 104)
INTO stoc VALUES(306, 106000, 3, 30)
INTO stoc VALUES(306, 107000, 1, 309)
INTO stoc VALUES(306, 108000, 1, 980)
INTO stoc VALUES(306, 109000, 1, 189)
INTO stoc VALUES(307, 101000, 7, 539)
INTO stoc VALUES(308, 100290, 1, 12)
INTO stoc VALUES(308, 101000, 7, 13)
INTO stoc VALUES(308, 105000, 1, 15)
INTO stoc VALUES(308, 108000, 10, 10)
INTO stoc VALUES(310, 100290, 1, 20)
INTO stoc VALUES(310, 100290, 2, 15)
INTO stoc VALUES(310, 40741, 4, 4)
INTO stoc VALUES(310, 40741, 1, 30)
INTO stoc VALUES(310, 40741, 7, 10)
INTO stoc VALUES(310, 101000, 7, 3)
INTO stoc VALUES(310, 102000, 1, 300)
INTO stoc VALUES(310, 106000, 1, 98)
INTO stoc VALUES(310, 25200, 1, 134)
INTO stoc VALUES(310, 102000, 8, 153)
INTO stoc VALUES(310, 103000, 10, 40)
INTO stoc VALUES(310, 104000, 1, 329)
INTO stoc VALUES(310, 105000, 1, 104)
INTO stoc VALUES(310, 106000, 3, 30)
INTO stoc VALUES(310, 107000, 1, 309)
INTO stoc VALUES(310, 108000, 1, 980)
INTO stoc VALUES(310, 109000, 1, 189)
INTO stoc VALUES(310, 100290, 4, 12)
INTO stoc VALUES(310, 108000, 10, 10)
INTO stoc VALUES(312, 101000, 7, 5)
INTO stoc VALUES(312, 104000, 9, 5)
INTO stoc VALUES(312, 103000, 9, 5)
INTO stoc VALUES(312, 108000, 9, 5)
INTO stoc VALUES(313, 109000, 1, 10)
INTO stoc VALUES(313, 109000, 9, 10)
INTO stoc VALUES(313, 109000, 10, 10)
INTO stoc VALUES(313, 109000, 12, 10)
SELECT * FROM DUAL;


INSERT ALL
INTO dezvoltator VALUES(100, 'PlatinumGames')
INTO dezvoltator VALUES(110, 'Atlus')
INTO dezvoltator VALUES(210, 'P Studio')
INTO dezvoltator VALUES(120, 'Omega Force')
INTO dezvoltator VALUES(130, 'Ubisoft')
INTO dezvoltator VALUES(140, 'Valve')
INTO dezvoltator VALUES(150, 'Hidden Path')
INTO dezvoltator VALUES(160, 'Supercell')
INTO dezvoltator VALUES(170, 'CD Projekt Red')
INTO dezvoltator VALUES(180, 'RobTop')
INTO dezvoltator VALUES(190, 'Roblox Corp.')
INTO dezvoltator VALUES(200, 'Mojang')
SELECT * FROM DUAL;

INSERT ALL
INTO editor VALUES(100, 'Square Enix')
INTO editor VALUES(210, 'Atlus')
INTO editor VALUES(220, 'Sega')
INTO editor VALUES(300, 'Ubisoft')
INTO editor VALUES(400, 'Valve')
INTO editor VALUES(500, 'Supercell')
INTO editor VALUES(600, 'CD Projeckt')
INTO editor VALUES(700, 'RobTop')
INTO editor VALUES(800, 'Roblox Corp.')
INTO editor VALUES(900, 'Mojang')
SELECT * FROM DUAL;

INSERT ALL
 INTO contribuie VALUES(100290, 100, 100)
 INTO contribuie VALUES(40741, 110, 210)
 INTO contribuie VALUES(40741, 210, 210)
 INTO contribuie VALUES(40741, 110, 220)
 INTO contribuie VALUES(40741, 210, 220)
 INTO contribuie VALUES(40742, 210, 210)
 INTO contribuie VALUES(40742, 120, 210)
 INTO contribuie VALUES(460000, 130, 300)
 INTO contribuie VALUES(101000, 110, 210)
 INTO contribuie VALUES(101000, 110, 220)
 INTO contribuie VALUES(102000, 140, 400)
 INTO contribuie VALUES(102000, 150, 400)
 INTO contribuie VALUES(103000, 160, 500)
 INTO contribuie VALUES(104000, 200, 900)
 INTO contribuie VALUES(105000, 130, 300)
 INTO contribuie VALUES(106000, 170, 600)
 INTO contribuie VALUES(107000, 170, 600)
 INTO contribuie VALUES(108000, 180, 700)
 INTO contribuie VALUES(25200, 110, 210)
 INTO contribuie VALUES(25200, 110, 220)
 INTO contribuie VALUES(109000, 190, 800)
SELECT * FROM DUAL;

INSERT ALL
 INTO limba VALUES('EN', 'Engleza')
 INTO limba VALUES('JP', 'Japoneza')
 INTO limba VALUES('RO', 'Romana')
 INTO limba VALUES('IT', 'Italiana')
 INTO limba VALUES('SP', 'Spaniola')
SELECT * FROM DUAL;

INSERT ALL
 INTO joc_in_limba VALUES(100290, 'EN', 1)
 INTO joc_in_limba VALUES(100290, 'JP', 1)
 INTO joc_in_limba VALUES(40741, 'EN', 1)
 INTO joc_in_limba VALUES(40741, 'JP', 1)
 INTO joc_in_limba VALUES(40741, 'IT', 0)
 INTO joc_in_limba VALUES(40741, 'SP', 0)
 INTO joc_in_limba VALUES(40742, 'EN', 1)
 INTO joc_in_limba VALUES(40742, 'JP', 1)
 INTO joc_in_limba VALUES(101000, 'EN', 1)
 INTO joc_in_limba VALUES(101000, 'JP', 1)
 INTO joc_in_limba VALUES(25200, 'EN', 1)
 INTO joc_in_limba VALUES(25200, 'JP', 1)
 INTO joc_in_limba VALUES(460000, 'EN', 1)
 INTO joc_in_limba VALUES(460000, 'JP', 0)
 INTO joc_in_limba VALUES(460000, 'IT', 0)
 INTO joc_in_limba VALUES(460000, 'SP', 0)
 INTO joc_in_limba VALUES(102000, 'EN', 1)
 INTO joc_in_limba VALUES(103000, 'EN', 1)
 INTO joc_in_limba VALUES(104000, 'EN', 0)
 INTO joc_in_limba VALUES(104000, 'JP', 0)
 INTO joc_in_limba VALUES(104000, 'RO', 0)
 INTO joc_in_limba VALUES(104000, 'SP', 0)
 INTO joc_in_limba VALUES(104000, 'IT', 0)
 INTO joc_in_limba VALUES(109000, 'EN', 0)
 INTO joc_in_limba VALUES(109000, 'JP', 0)
 INTO joc_in_limba VALUES(109000, 'RO', 0)
 INTO joc_in_limba VALUES(109000, 'SP', 0)
 INTO joc_in_limba VALUES(109000, 'IT', 0)
 INTO joc_in_limba VALUES(105000, 'EN', 1)
 INTO joc_in_limba VALUES(105000, 'IT', 1)
 INTO joc_in_limba VALUES(106000, 'EN', 1)
 INTO joc_in_limba VALUES(106000, 'SP', 1)
 INTO joc_in_limba VALUES(107000, 'EN', 1)
 INTO joc_in_limba VALUES(108000, 'EN', 0)
SELECT * FROM DUAL;

INSERT ALL
 INTO angajat
VALUES(1000, 300, 'Floricel', 'Andreea Renata', 'renata@gmail.com', '+40756701314', 501, TO_DATE('11-09-2006','dd-mm-yyyy'))
 INTO angajat
VALUES(1001, 300, 'Ionescu', 'Ion', 'the_ion@gmail.com', '+40756742812', 1700, TO_DATE('11-09-2019','dd-mm-yyyy'))
 INTO angajat
VALUES(1002, 301, 'Pinduchi', 'Andreea Corina', 'corina@gmail.com', '+40756319217', 2050, TO_DATE('07-05-2022','dd-mm-yyyy'))
 INTO angajat
VALUES(1003, 301, 'Vasiliu', 'Ana', 'ana@ana.com', '+40726791325', 2000, TO_DATE('11-05-2022','dd-mm-yyyy'))
 INTO angajat
VALUES(1004, 301, 'Tenea', 'Andrada', 'andrada@gmail.com', '+40759312203', 1970, TO_DATE('13-05-2023','dd-mm-yyyy'))
 INTO angajat
VALUES(1005, 302, 'Burlacu', 'Eduard Daniel', NULL, '+40756771315', 2300, TO_DATE('10-10-2022','dd-mm-yyyy'))
 INTO angajat
VALUES(1006, 303, 'Smadu', 'Andrei', 'smadu@andrei.ro', NULL, 2500, TO_DATE('12-02-2023','dd-mm-yyyy'))
 INTO angajat
VALUES(1007, 304, 'Coman', 'Andrei David', 'coman@coman.com', '+40770649949', 2400, TO_DATE('11-11-2022','dd-mm-yyyy'))
 INTO angajat(id_angajat, id_magazin, nume, prenume, email, telefon, salariu)
VALUES(1008, 305, 'Sefer', 'Emanuel Adrian', 'emanu@gamil.com', '+31756771315', 3000)
 INTO angajat
VALUES(1009, 306, 'Adamita', 'Stefan David', NULL, '+40756781315', 1000, TO_DATE('23-09-2020','dd-mm-yyyy'))
 INTO angajat
VALUES(1010, 306, 'Melinte', 'Florin', NULL, NULL, 3000, TO_DATE('19-07-2019','dd-mm-yyyy'))
 INTO angajat
VALUES(1011, 306, 'Berechet', 'Tudor', 'budor@gmail.com', '+40756781315', 2000, sysdate)
 INTO angajat
VALUES(1012, 307, 'Williams', 'Will', 'will@will.will', NULL, 1000, TO_DATE('15-04-1998','dd-mm-yyyy'))
 INTO angajat
VALUES(1013, 308, 'Giovanna', 'Giorno', NULL, NULL, 10000, TO_DATE('16-04-2001','dd-mm-yyyy'))
 INTO angajat(id_angajat, id_magazin, nume, salariu)
VALUES(1014, 309, 'Theodore', 700)
 INTO angajat
VALUES(1015, 310, 'White', 'Sandra', 'london1@gameshop.com', '+44000111222', 632, TO_DATE('13-05-2023','dd-mm-yyyy'))
 INTO angajat
VALUES(1016, 310, 'Black', 'Jonathan Joe', 'london2@gameshop.com', '+44333111222', 701, TO_DATE('12-05-2023','dd-mm-yyyy'))
 INTO angajat
VALUES(1017, 311, 'Popescu', 'Popa', 'popa@gameshop.com', '+40700111222', 502, TO_DATE('13-05-2023','dd-mm-yyyy'))
 INTO angajat
VALUES(1018, 312, 'Lovin', 'Raluca', 'raluca@gameshop.com', '+40710111222', 3000, TO_DATE('09-05-2023','dd-mm-yyyy'))
 INTO angajat
VALUES(1019, 313, 'Petru', 'Mihai', 'mihai@gameshop.com', '+40700611222', 1200, TO_DATE('08-05-2023','dd-mm-yyyy'))
 INTO angajat
VALUES(1020, 314, 'Popescu', 'Ana', NULL, '+40700111262', 1029, TO_DATE('13-05-2023','dd-mm-yyyy'))
SELECT * FROM DUAL;

UPDATE magazin SET id_manager = 1001 WHERE id_magazin = 300;
UPDATE magazin SET id_manager = 1002 WHERE id_magazin = 301;
UPDATE magazin SET id_manager = 1005 WHERE id_magazin = 302;
UPDATE magazin SET id_manager = 1006 WHERE id_magazin = 303;
UPDATE magazin SET id_manager = 1007 WHERE id_magazin = 304;
UPDATE magazin SET id_manager = 1008 WHERE id_magazin = 305;
UPDATE magazin SET id_manager = 1010 WHERE id_magazin = 306;
UPDATE magazin SET id_manager = 1013 WHERE id_magazin = 308;
UPDATE magazin SET id_manager = 1014 WHERE id_magazin = 309;
UPDATE magazin SET id_manager = 1015 WHERE id_magazin = 310;
UPDATE magazin SET id_manager = 1018 WHERE id_magazin = 312;
UPDATE magazin SET id_manager = 1019 WHERE id_magazin = 313;

INSERT INTO client
VALUES(secventa_client.nextval, 'Cazan', 'George', 'george@gmail.com', '+40763192452');
INSERT INTO client
VALUES(secventa_client.nextval, 'Onodi', 'Paul', 'paul@gmail.com', '+40763693212');
INSERT INTO client
VALUES(secventa_client.nextval, 'Jansen', 'Liam', NULL, '+31756821387');
INSERT INTO client
VALUES(secventa_client.nextval, 'Greyson', 'Henry', 'henry@yahoo.com', NULL);
INSERT INTO client
VALUES(secventa_client.nextval, 'Cocu', 'Elena', 'elena@cocu.com', '+40769695674');
INSERT INTO client
VALUES(secventa_client.nextval, 'De Lucca', 'Antonio', NULL, NULL);
INSERT INTO client
VALUES(secventa_client.nextval, 'Nagy', 'Zoltan', 'nagy@zoltan.com', '+40711112222');

INSERT INTO comanda
VALUES(secventa_comanda.nextval, 1000000, 1001, TO_DATE('11-05-2023','dd-mm-yyyy'), 'cash');
INSERT INTO comanda
VALUES(secventa_comanda.nextval, 1000000, 1002, TO_DATE('09-05-2023','dd-mm-yyyy'), 'card');
INSERT INTO comanda
VALUES(secventa_comanda.nextval, 1000001, 1005, TO_DATE('05-05-2023','dd-mm-yyyy'), 'rate');
INSERT INTO comanda
VALUES(secventa_comanda.nextval, 1000003, 1012, TO_DATE('02-05-2023','dd-mm-yyyy'), 'card');
INSERT INTO comanda
VALUES(secventa_comanda.nextval, 1000003, 1015, TO_DATE('03-05-2023','dd-mm-yyyy'), 'card');
INSERT INTO comanda
VALUES(secventa_comanda.nextval, 1000002, 1008, TO_DATE('13-05-2023','dd-mm-yyyy'), 'mixt');
INSERT INTO comanda
VALUES(secventa_comanda.nextval, 1000000, 1006, TO_DATE('13-05-2023','dd-mm-yyyy'), 'cash');
INSERT INTO comanda(id_comanda, id_client, id_angajat)
VALUES(secventa_comanda.nextval, 1000004, 1007);
INSERT INTO comanda
VALUES(secventa_comanda.nextval, 1000005, 1013, TO_DATE('15-05-2023','dd-mm-yyyy'), 'cash');
INSERT INTO comanda
VALUES(secventa_comanda.nextval, 1000006, 1020, TO_DATE('11-05-2023','dd-mm-yyyy'), 'card');
INSERT INTO comanda
VALUES(secventa_comanda.nextval, 1000001, 1018, TO_DATE('07-05-2023','dd-mm-yyyy'), 'cash');
INSERT INTO comanda
VALUES(secventa_comanda.nextval, 1000005, 1019, TO_DATE('04-05-2023','dd-mm-yyyy'), 'cash');

INSERT ALL
 INTO comanda_online VALUES(1037182341, 'Str. Preciziei 24, Bucure?ti 062204', TO_DATE('10-05-2023','dd-mm-yyyy'))
 INTO comanda_online VALUES(1111547023, 'Wandsworth Bridge Rd., London SW6 2NY', TO_DATE('05-05-2023','dd-mm-yyyy'))
 INTO comanda_online VALUES(1185911705, 'Vijzelstraat 15, 1017 HD Amsterdam', TO_DATE('14-05-2023','dd-mm-yyyy'))
 INTO comanda_online VALUES(1409005751, 'Parcheggio pubblico, Via Borgo Palazzo, 217, 24125 Bergamo BG', TO_DATE('20-05-2023','dd-mm-yyyy'))
 INTO comanda_online VALUES(1371823410, 'Strada General Ioan Dragalina 10, Gala?i 800402', TO_DATE('07-05-2023','dd-mm-yyyy'))
SELECT * FROM DUAL;

INSERT ALL
 INTO comanda_contine VALUES(101000, 7, 1000000000, 2)
 INTO comanda_contine VALUES(101000, 7, 1037182341, 1)
 INTO comanda_contine VALUES(40741, 7, 1037182341, 1)
 INTO comanda_contine VALUES(100290, 7, 1037182341, 1)
 INTO comanda_contine VALUES(460000, 1, 1074364682, 1)
 INTO comanda_contine VALUES(105000, 1, 1074364682, 1)
 INTO comanda_contine VALUES(25200, 2, 1111547023, 5)
 INTO comanda_contine VALUES(104000, 9, 1148729364, 12)
 INTO comanda_contine VALUES(104000, 10, 1148729364, 3)
 INTO comanda_contine VALUES(106000, 1, 1185911705, 1)
 INTO comanda_contine VALUES(101000, 7, 1223094046, 1)
 INTO comanda_contine VALUES(101000, 7, 1260276387, 1)
 INTO comanda_contine VALUES(102000, 1, 1260276387, 1)
 INTO comanda_contine VALUES(103000, 9, 1260276387, 1)
 INTO comanda_contine VALUES(40741, 1, 1297458728, 1)
 INTO comanda_contine VALUES(40742, 1, 1297458728, 1)
 INTO comanda_contine VALUES(100290, 1, 1334641069, 1)
 INTO comanda_contine VALUES(100290, 1, 1371823410, 2)
 INTO comanda_contine VALUES(102000, 1, 1371823410, 2)
 INTO comanda_contine VALUES(106000, 1, 1371823410, 2)
 INTO comanda_contine VALUES(40741, 1, 1371823410, 2)
 INTO comanda_contine VALUES(107000, 1, 1371823410, 2)
 INTO comanda_contine VALUES(104000, 1, 1371823410, 2)
 INTO comanda_contine VALUES(101000, 7, 1409005751, 20)
SELECT * FROM DUAL;

COMMIT;