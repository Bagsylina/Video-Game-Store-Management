--Table Creation

CREATE TABLE tara(
    id_tara varchar2(2) CONSTRAINT tara_pk PRIMARY KEY,
    nume_tara varchar2(30) CONSTRAINT tara_nume_nn NOT NULL
                        CONSTRAINT tara_nume_unq UNIQUE
);
    
CREATE TABLE oras(
    id_oras number(3) CONSTRAINT oras_pk PRIMARY KEY,
    nume_oras varchar2(20) CONSTRAINT oras_nume_nn NOT NULL,
    id_tara varchar2(2) CONSTRAINT oras_fk REFERENCES tara(id_tara) ON DELETE SET NULL
);
    
CREATE TABLE magazin(
    id_magazin number(3) CONSTRAINT mag_pk PRIMARY KEY,
    nume_magazin varchar2(30),
    adresa varchar2(100),
    id_oras CONSTRAINT mag_fk_oras REFERENCES oras(id_oras) ON DELETE SET NULL,
    id_manager number(4)
);

CREATE TABLE joc(
    id_joc number(6) CONSTRAINT joc_pk PRIMARY KEY,
    titlu varchar2(30) CONSTRAINT joc_titlu_nn NOT NULL,
    descriere varchar2(300),
    gen varchar2(15),
    multiplayer number(1) CONSTRAINT joc_mp_chk CHECK(multiplayer = 0 or multiplayer = 1),
    varsta number(2) DEFAULT 3
);
    
CREATE TABLE joc_online(
    id_joc number(6) CONSTRAINT joc_on_pk PRIMARY KEY
                    CONSTRAINT joc_on_fk REFERENCES joc(id_joc) ON DELETE CASCADE,
    nr_jucatori number(8) CONSTRAINT joc_on_juc_chk CHECK(nr_jucatori > 0),
    crossplay number(1) CONSTRAINT joc_cplay_chk CHECK(crossplay = 0 or crossplay = 1),
    cross_progression number(1) CONSTRAINT joc_cprog_chk CHECK(cross_progression = 0 or cross_progression = 1)
);

CREATE TABLE platforma(
    id_platforma number(2) CONSTRAINT plat_pk PRIMARY KEY,
    nume_platforma varchar2(15) CONSTRAINT plat_nume_nn NOT NULL
                    CONSTRAINT plat_nume_unq UNIQUE,
    tip_platforma varchar2(10) CONSTRAINT plat_tip_nn NOT NULL
);

CREATE TABLE versiune(
    id_joc number(6) CONSTRAINT vers_joc_fk REFERENCES joc(id_joc) ON DELETE CASCADE,
    id_platforma number(2) CONSTRAINT vers_plat_fk REFERENCES platforma(id_platforma) ON DELETE CASCADE,
    dimensiune number(4,2),
    data_lansare date,
    pret number(4,2) CONSTRAINT vers_pret_nn NOT NULL,
    CONSTRAINT vers_pk PRIMARY KEY(id_joc, id_platforma)
);

CREATE TABLE stoc(
    id_magazin number(3) CONSTRAINT stoc_mag_fk REFERENCES magazin(id_magazin) ON DELETE CASCADE,
    id_joc number(6),
    id_platforma number(2),
    nr_produse number(3) CONSTRAINT stoc_nr_nn NOT NUll,
    CONSTRAINT stoc_pk PRIMARY KEY(id_magazin, id_joc, id_platforma),
    CONSTRAINT stoc_vers_fk FOREIGN KEY(id_joc, id_platforma) REFERENCES versiune(id_joc, id_platforma) ON DELETE CASCADE
);

CREATE TABLE dezvoltator(
    id_dezvoltator number(3) CONSTRAINT dezv_pk PRIMARY KEY,
    nume_dezvoltator varchar2(15) CONSTRAINT dezv_nume_unq UNIQUE
);

CREATE TABLE editor(
    id_editor number(3) CONSTRAINT editor_pk PRIMARY KEY,
    nume_editor varchar2(15) CONSTRAINT editor_nume_unq UNIQUE
);

CREATE TABLE contribuie(
    id_joc number(6) CONSTRAINT contr_joc_fk REFERENCES joc(id_joc) ON DELETE CASCADE,
    id_dezvoltator number(3) CONSTRAINT contr_dezv_fk REFERENCES dezvoltator(id_dezvoltator) ON DELETE CASCADE,
    id_editor number(3) CONSTRAINT contr_edit_fk REFERENCES editor(id_editor) ON DELETE CASCADE,
    CONSTRAINT contr_pk PRIMARY KEY(id_joc, id_dezvoltator, id_editor)
);

CREATE TABLE limba(
    id_limba varchar2(2) CONSTRAINT limba_pk PRIMARY KEY,
    nume_limba varchar2(15) CONSTRAINT limba_nume_unq UNIQUE
);

CREATE TABLE joc_in_limba(
    id_joc number(6) CONSTRAINT joc_lim_fk_joc REFERENCES joc(id_joc) ON DELETE CASCADE,
    id_limba varchar2(2) CONSTRAINT joc_lim_fk_lim REFERENCES limba(id_limba) ON DELETE CASCADE,
    dublare number(1) CONSTRAINT joc_lim_dub_chk CHECK(dublare = 0 or dublare = 1),
    CONSTRAINT joc_lim_pk PRIMARY KEY(id_joc, id_limba)
);

CREATE TABLE angajat(
    id_angajat number(4) CONSTRAINT ang_pk PRIMARY KEY,
    id_magazin number(3) CONSTRAINT ang_fk REFERENCES magazin(id_magazin)
                        CONSTRAINT ang_mag_nn NOT NULL,
    nume varchar2(20) CONSTRAINT ang_nume_nn NOT NULL,
    prenume varchar2(20),
    email varchar2(30),
    telefon varchar2(12),
    salariu number(5) CONSTRAINT ang_sal_chk CHECK (salariu > 500),
    data_angajare date DEFAULT SYSDATE
);

CREATE TABLE client(
    id_client number(7) CONSTRAINT clnt_pk PRIMARY KEY,
    nume varchar2(20),
    prenume varchar2(20),
    email varchar2(30),
    telefon varchar2(12)
);

CREATE TABLE comanda(
    id_comanda number(10) CONSTRAINT comd_pk PRIMARY KEY,
    id_client number(7) CONSTRAINT comd_clnt_fk REFERENCES client(id_client) ON DELETE SET NULL,
    id_angajat number(4) CONSTRAINT comd_ang_fk REFERENCES angajat(id_angajat) ON DELETE SET NULL,
    data_comanda date DEFAULT SYSDATE,
    metoda_plata varchar2(10)
);

CREATE TABLE comanda_online(
    id_comanda number(10) CONSTRAINT comd_on_pk PRIMARY KEY
                        CONSTRAINT comd_on_fk REFERENCES comanda(id_comanda) ON DELETE CASCADE,
    adresa varchar2(100),
    data_livrare date
);

CREATE TABLE comanda_contine(
    id_joc number(6),
    id_platforma number(2),
    id_comanda number(10) CONSTRAINT comd_cont_fk_comd REFERENCES comanda(id_comanda) ON DELETE CASCADE,
    numar number(2) CONSTRAINT comd_cont_chk CHECK(numar > 0),
    CONSTRAINT comd_cont_fk_ver FOREIGN KEY(id_joc, id_platforma) REFERENCES versiune(id_joc, id_platforma) ON DELETE CASCADE,
    CONSTRAINT comd_cont_pk PRIMARY KEY(id_joc, id_platforma, id_comanda) 
);

ALTER TABLE magazin
ADD CONSTRAINT mag_fk_mng FOREIGN KEY(id_manager)
REFERENCES angajat(id_angajat);