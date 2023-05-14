-- Generated by Oracle SQL Developer Data Modeler 22.2.0.165.1149
--   at:        2022-12-23 09:28:25 EET
--   site:      Oracle Database 12c
--   type:      Oracle Database 12c



-- predefined type, no DDL - MDSYS.SDO_GEOMETRY

-- predefined type, no DDL - XMLTYPE

CREATE TABLE clienti (
    id_client       NUMBER(2) NOT NULL,
    nume_client     VARCHAR2(50) NOT NULL,
    nume_utilizator VARCHAR2(20) NOT NULL,
    parola          VARCHAR2(31) NOT NULL,
    tip_utilizator  VARCHAR2(20) NOT NULL
)
LOGGING;

ALTER TABLE clienti
    ADD CONSTRAINT clienti_nume_client_ck CHECK ( length(nume_client) >= 5
                                                  AND REGEXP_LIKE ( nume_client,
                                                                    '^[a-zA-Z_ ]*$' ) );

ALTER TABLE clienti
    ADD CONSTRAINT clienti_nume_util_ck CHECK ( length(nume_utilizator) >= 5
                                                AND REGEXP_LIKE ( nume_utilizator,
                                                                  '^[a-zA-Z_ 0-9]*$' ) );

ALTER TABLE clienti
    ADD CONSTRAINT clienti_parola_ck CHECK ( length(parola) >= 8
                                             AND REGEXP_LIKE ( parola,
                                                               '[A-Za-z0-9][!@#$%*_]' ) );

ALTER TABLE clienti
    ADD CONSTRAINT clienti_tip_utilizator_ck CHECK ( tip_utilizator IN ( 'Administrator', 'Utilizator' ) );

ALTER TABLE clienti ADD CONSTRAINT clienti_pk PRIMARY KEY ( id_client );

CREATE OR REPLACE FUNCTION gaseste_id_dupa_username (
    username VARCHAR2
) RETURN NUMBER IS
    var_id_client NUMBER;
BEGIN
    SELECT
        id_client
    INTO var_id_client
    FROM
        clienti
    WHERE
        nume_utilizator = username;

    IF var_id_client = NULL THEN
        raise_application_error(-20004, 'Clientul nu se afla in baza de date');
    END IF;
    RETURN var_id_client;
END;
/

CREATE TABLE aprovizionari (
    cantitate_aprovizionare NUMBER(3) NOT NULL,
    pret_aprovizionare      NUMBER(4) NOT NULL,
    data_aprovizionare      DATE DEFAULT SYSDATE NOT NULL,
    id_produs               NUMBER(2) NOT NULL
)
LOGGING;

ALTER TABLE aprovizionari ADD CONSTRAINT aprovizionari_cantitate_ck CHECK ( cantitate_aprovizionare > 0 );

ALTER TABLE aprovizionari
    ADD CONSTRAINT aprovizionari_pret_apro_ck CHECK ( pret_aprovizionare BETWEEN 10 AND 9999 );

ALTER TABLE aprovizionari ADD CONSTRAINT aprovizionari_pk PRIMARY KEY ( id_produs );

CREATE TABLE bonusuri (
    id_bonus  NUMBER(2) NOT NULL,
    tip_cadou VARCHAR2(20) NOT NULL
)
LOGGING;

ALTER TABLE bonusuri
    ADD CONSTRAINT bonusuri_tip_cadou_ck CHECK ( tip_cadou IN ( 'Amandina', 'Ecler', 'Macarons', 'Nimic', 'Tort',
                                                                'Zozole' ) );

ALTER TABLE bonusuri ADD CONSTRAINT bonusuri_pk PRIMARY KEY ( id_bonus );

CREATE TABLE comenzi (
    id_comanda   NUMBER(2) NOT NULL,
    pret_comanda NUMBER(5) DEFAULT 0 NOT NULL,
    data_comanda DATE DEFAULT SYSDATE NOT NULL,
    id_client    NUMBER(2) NOT NULL,
    id_bonus     NUMBER(2) NOT NULL
)
LOGGING;

ALTER TABLE comenzi ADD CONSTRAINT comenzi_pret_comanda_ck CHECK ( pret_comanda >= 0 );

ALTER TABLE comenzi ADD CONSTRAINT comenzi_pk PRIMARY KEY ( id_comanda );

CREATE TABLE detalii_client (
    numar_telefon VARCHAR2(10) NOT NULL,
    adresa_client VARCHAR2(80) NOT NULL,
    email_client  VARCHAR2(40) NOT NULL,
    cod_postal    VARCHAR2(6) NOT NULL,
    id_client     NUMBER(2) NOT NULL
)
LOGGING;

ALTER TABLE detalii_client
    ADD CONSTRAINT detalii_nr_telefon_ck CHECK ( REGEXP_LIKE ( numar_telefon,
                                                               '^[0-9]{10}$' ) );

ALTER TABLE detalii_client
    ADD CONSTRAINT detalii_adresa_client_ck CHECK ( length(adresa_client) > 5
                                                    AND REGEXP_LIKE ( adresa_client,
                                                                      '^[a-zA-Z_ 0-9]*$' ) );

ALTER TABLE detalii_client
    ADD CONSTRAINT detalii_email_ck CHECK ( REGEXP_LIKE ( email_client,
                                                          '[a-z0-9._%-]+@[a-z0-9._%-]+\.[a-z]{2,4}' ) );

ALTER TABLE detalii_client
    ADD CONSTRAINT detalii_cod_postal_ck CHECK ( length(cod_postal) = 6 );

CREATE UNIQUE INDEX detalii_client__idx ON
    detalii_client (
        id_client
    ASC )
        LOGGING;

ALTER TABLE detalii_client ADD CONSTRAINT detalii_email_client_uk UNIQUE ( email_client );

CREATE TABLE detalii_comanda (
    id_produs  NUMBER(2) NOT NULL,
    id_comanda NUMBER(2) NOT NULL,
    cantitate  NUMBER(3) NOT NULL
)
LOGGING;

ALTER TABLE detalii_comanda ADD CONSTRAINT detalii_comanda_pk PRIMARY KEY ( id_produs,
                                                                            id_comanda );

CREATE TABLE produse (
    id_produs             NUMBER(2) NOT NULL,
    nume_produs           VARCHAR2(20),
    pret_produs           NUMBER(4) NOT NULL,
    cantitate_disponibila NUMBER(3) NOT NULL
)
LOGGING;

ALTER TABLE produse
    ADD CONSTRAINT produse_nume_produs_ck CHECK ( length(nume_produs) > 0 );

ALTER TABLE produse
    ADD CONSTRAINT produse_pret_produs_ck CHECK ( pret_produs BETWEEN 10 AND 9999 );

ALTER TABLE produse ADD CONSTRAINT produse_cantitate_disp_ck CHECK ( cantitate_disponibila >= 0 );

ALTER TABLE produse ADD CONSTRAINT produse_pk PRIMARY KEY ( id_produs );

ALTER TABLE produse ADD CONSTRAINT produse_nume_produs_uk UNIQUE ( nume_produs );

CREATE TABLE venituri (
    total_investit NUMBER(5) DEFAULT 0,
    total_vandut   NUMBER(5) DEFAULT 0,
    profit_brut    NUMBER(5) AS (total_vandut - total_investit),
    profit_net     NUMBER(5) AS ((total_vandut - total_investit) - taxe * total_vandut),
    taxe           NUMBER(2) NOT NULL
)
LOGGING;

ALTER TABLE venituri
    ADD CONSTRAINT venituri_total_investit_ck CHECK ( length(total_investit) >= 0 );

ALTER TABLE venituri
    ADD CONSTRAINT venituri_total_vandut_ck CHECK ( length(total_vandut) >= 0 );

ALTER TABLE venituri
    ADD CONSTRAINT venituri_profit_brut_ck CHECK ( length(profit_brut) > 0 );

ALTER TABLE venituri
    ADD CONSTRAINT venituri_profit_net_ck CHECK ( length(profit_net) > 0 );

ALTER TABLE venituri
    ADD CONSTRAINT venituri_taxe_ck CHECK ( length(taxe) > 0 );

ALTER TABLE comenzi
    ADD CONSTRAINT bonus_comenzi_fk FOREIGN KEY ( id_bonus )
        REFERENCES bonusuri ( id_bonus )
    NOT DEFERRABLE;

ALTER TABLE comenzi
    ADD CONSTRAINT clienti_comenzi_fk FOREIGN KEY ( id_client )
        REFERENCES clienti ( id_client )
    NOT DEFERRABLE;

ALTER TABLE detalii_client
    ADD CONSTRAINT clienti_detalii_fk FOREIGN KEY ( id_client )
        REFERENCES clienti ( id_client )
    NOT DEFERRABLE;

ALTER TABLE detalii_comanda
    ADD CONSTRAINT detalii_comanda_comenzi_fk FOREIGN KEY ( id_comanda )
        REFERENCES comenzi ( id_comanda )
    NOT DEFERRABLE;

ALTER TABLE detalii_comanda
    ADD CONSTRAINT detalii_comanda_produse_fk FOREIGN KEY ( id_produs )
        REFERENCES produse ( id_produs )
    NOT DEFERRABLE;

ALTER TABLE aprovizionari
    ADD CONSTRAINT produse_aprovizionari_fk FOREIGN KEY ( id_produs )
        REFERENCES produse ( id_produs )
    NOT DEFERRABLE;

CREATE OR REPLACE TRIGGER aprovizionari_data_trg 
    BEFORE INSERT OR UPDATE ON APROVIZIONARI 
    FOR EACH ROW 
BEGIN
    IF ( :new.data_aprovizionare < SYSDATE or :new.data_aprovizionare > SYSDATE ) THEN
        raise_application_error(-20003, 'Data invalida: '
                                        || to_char(:new.data_aprovizionare, 'DD.MM.YYYY')
                                        || 'Aprovizionarile nu pot fi plasate in date din trecut/viitor!');

    END IF;
END; 
/

CREATE OR REPLACE TRIGGER aprovizionari_trg 
    BEFORE INSERT ON APROVIZIONARI 
    FOR EACH ROW 
BEGIN
    update produse 
    set produse.cantitate_disponibila = produse.cantitate_disponibila + :new.cantitate_aprovizionare
    where produse.id_produs = :new.id_produs;
    
    update venituri 
    set venituri.total_investit = venituri.total_investit + :new.cantitate_aprovizionare * :new.pret_aprovizionare;
END; 
/

CREATE OR REPLACE TRIGGER cantitate_trg 
    BEFORE INSERT ON DETALII_COMANDA 
    FOR EACH ROW 
DECLARE
    cant_disponibila number;
BEGIN
    select produse.cantitate_disponibila into cant_disponibila from produse where produse.id_produs = :new.id_produs;
    IF :new.cantitate > cant_disponibila THEN
        RAISE_APPLICATION_ERROR( -20000, 'Comanda nu poate fi plasata.Stoc insuficient!' );
	END IF;
END; 
/

CREATE OR REPLACE TRIGGER detalii_comanda_trg 
    BEFORE INSERT ON DETALII_COMANDA 
    FOR EACH ROW 
BEGIN
    update produse
    set cantitate_disponibila = cantitate_disponibila - :new.cantitate
    where id_produs = :new.id_produs;

    update comenzi 
    set comenzi.pret_comanda = comenzi.pret_comanda + :new.cantitate * (select produse.pret_produs from produse where :new.id_produs = produse.id_produs)
    where comenzi.id_comanda = :new.id_comanda;
    
    update venituri 
    set venituri.total_vandut = venituri.total_vandut + :new.cantitate * (select produse.pret_produs from produse where :new.id_produs = produse.id_produs);
END; 
/

CREATE OR REPLACE TRIGGER pret_aprovizionare_trg 
    BEFORE INSERT ON APROVIZIONARI 
    FOR EACH ROW 
DECLARE
    pret_vanzare number;
BEGIN
    select produse.pret_produs into pret_vanzare from produse where produse.id_produs = :new.id_produs;
    IF (:new.pret_aprovizionare > pret_vanzare) THEN
        RAISE_APPLICATION_ERROR( -20001, 'Pret achizitie mai mare ca cel de vanzare!' );
	END IF;
END; 
/

CREATE SEQUENCE clienti_id_client_seq START WITH 1 NOCACHE ORDER;

CREATE OR REPLACE TRIGGER clienti_id_client_trg BEFORE
    INSERT ON clienti
    FOR EACH ROW
    WHEN ( new.id_client IS NULL )
BEGIN
    :new.id_client := clienti_id_client_seq.nextval;
END;
/

CREATE SEQUENCE comenzi_id_comanda_seq START WITH 1 NOCACHE ORDER;

CREATE OR REPLACE TRIGGER comenzi_id_comanda_trg BEFORE
    INSERT ON comenzi
    FOR EACH ROW
    WHEN ( new.id_comanda IS NULL )
BEGIN
    :new.id_comanda := comenzi_id_comanda_seq.nextval;
END;
/

CREATE SEQUENCE produse_id_produs_seq START WITH 1 NOCACHE ORDER;

CREATE OR REPLACE TRIGGER produse_id_produs_trg BEFORE
    INSERT ON produse
    FOR EACH ROW
    WHEN ( new.id_produs IS NULL )
BEGIN
    :new.id_produs := produse_id_produs_seq.nextval;
END;
/



-- Oracle SQL Developer Data Modeler Summary Report: 
-- 
-- CREATE TABLE                             8
-- CREATE INDEX                             1
-- ALTER TABLE                             34
-- CREATE VIEW                              0
-- ALTER VIEW                               0
-- CREATE PACKAGE                           0
-- CREATE PACKAGE BODY                      0
-- CREATE PROCEDURE                         0
-- CREATE FUNCTION                          1
-- CREATE TRIGGER                           8
-- ALTER TRIGGER                            0
-- CREATE COLLECTION TYPE                   0
-- CREATE STRUCTURED TYPE                   0
-- CREATE STRUCTURED TYPE BODY              0
-- CREATE CLUSTER                           0
-- CREATE CONTEXT                           0
-- CREATE DATABASE                          0
-- CREATE DIMENSION                         0
-- CREATE DIRECTORY                         0
-- CREATE DISK GROUP                        0
-- CREATE ROLE                              0
-- CREATE ROLLBACK SEGMENT                  0
-- CREATE SEQUENCE                          3
-- CREATE MATERIALIZED VIEW                 0
-- CREATE MATERIALIZED VIEW LOG             0
-- CREATE SYNONYM                           0
-- CREATE TABLESPACE                        0
-- CREATE USER                              0
-- 
-- DROP TABLESPACE                          0
-- DROP DATABASE                            0
-- 
-- REDACTION POLICY                         0
-- TSDP POLICY                              0
-- 
-- ORDS DROP SCHEMA                         0
-- ORDS ENABLE SCHEMA                       0
-- ORDS ENABLE OBJECT                       0
-- 
-- ERRORS                                   0
-- WARNINGS                                 0