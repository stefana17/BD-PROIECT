---INSERARE TABELE---

--CLIENTI
insert into clienti(nume_client, nume_utilizator, parola, tip_utilizator) values ('Hriscu Stefana', 'StefanaH17', 'Sefy@sefy17', 'Administrator');
insert into clienti(nume_client, nume_utilizator, parola, tip_utilizator) values ('Pislariu Andreea', 'AndreeaP30', 'Mitu_tsucki30', 'Utilizator');
insert into clienti(nume_client, nume_utilizator, parola, tip_utilizator) values ('Ganea Luiza', 'LuissaG23', 'Zoro@sefu23', 'Utilizator');
insert into clienti(nume_client, nume_utilizator, parola, tip_utilizator) values ('Rosca Ana Maria', 'Anzertrop22', 'Tomas@frumosu22', 'Utilizator');
insert into clienti(nume_client, nume_utilizator, parola, tip_utilizator) values ('Husman Carla', 'Carlita26', 'Koreea@desud05', 'Utilizator');
insert into clienti(nume_client, nume_utilizator, parola, tip_utilizator) values ('Barbaliu Bianca', 'BiancaB19', 'Papusa_barbie03', 'Utilizator');
insert into clienti(nume_client, nume_utilizator, parola, tip_utilizator) values ('Aluchienesei Georgiana', 'GeorgianaA19', 'Mojo_Jojo04', 'Utilizator');

--DETALII CLIENT
insert into detalii_client(numar_telefon, adresa_client, email_client, cod_postal, id_client) values ('0743376692','Strada Vasile Lupu Nr 87 Bl L2 Sc C Et Parter Ap 1', 'hriscu_stefana@yahoo.com', '700319', gaseste_id_dupa_username('StefanaH17'));
insert into detalii_client(numar_telefon, adresa_client, email_client, cod_postal, id_client) values ('0745783345','Str Crinului Nr 12', 'pislariu.andreea@yahoo.com', '700456', gaseste_id_dupa_username('AndreeaP30'));
insert into detalii_client(numar_telefon, adresa_client, email_client, cod_postal, id_client) values ('0751981525','Strada Dorului Nr 46 Bl C2 Sc A Et 1 Ap 2', 'ganealuiza23@yahoo.com', '700412', gaseste_id_dupa_username('LuissaG23'));
insert into detalii_client(numar_telefon, adresa_client, email_client, cod_postal, id_client) values ('0732675126','Str Ion Creanga Nr 35', 'rosca.ana22@gmail.com', '700323', gaseste_id_dupa_username('Anzertrop22'));
insert into detalii_client(numar_telefon, adresa_client, email_client, cod_postal, id_client) values ('0744567686','Strada Ion Bratianu Nr 92', 'husman_carla@yahoo.com', '700312', gaseste_id_dupa_username('Carlita26'));
insert into detalii_client(numar_telefon, adresa_client, email_client, cod_postal, id_client) values ('0736561412','Strada Gandului Nr 27 Bl V3 Sc B Et 4 Ap 14', 'bianca_barb19@gmail.com', '700123', gaseste_id_dupa_username('BiancaB19'));
insert into detalii_client(numar_telefon, adresa_client, email_client, cod_postal, id_client) values ('0746523222','Str Mihai Codreanu Nr 67', 'aluchienesei_geo19@yahoo.com', '700256', gaseste_id_dupa_username('GeorgianaA19'));


--PRODUSE
insert into produse(nume_produs, pret_produs, cantitate_disponibila) values ('Tort', 100, 50);
insert into produse(nume_produs, pret_produs, cantitate_disponibila) values ('Ecler', 20, 40);
insert into produse(nume_produs, pret_produs, cantitate_disponibila) values ('Alba-ca-Zapada', 23, 25);
insert into produse(nume_produs, pret_produs, cantitate_disponibila) values ('Macarons', 12, 120);
insert into produse(nume_produs, pret_produs, cantitate_disponibila) values ('Zozole', 20, 250);
insert into produse(nume_produs, pret_produs, cantitate_disponibila) values ('Tarta cu mere', 15, 30);
insert into produse(nume_produs, pret_produs, cantitate_disponibila) values ('Amandina', 21, 20);
insert into produse(nume_produs, pret_produs, cantitate_disponibila) values ('Pachet de biscuiti', 11, 35);

--BONUSURI
insert into bonusuri(id_bonus, tip_cadou) values (1,'Amandina');
insert into bonusuri(id_bonus, tip_cadou) values (2,'Ecler');
insert into bonusuri(id_bonus, tip_cadou) values (3,'Macarons');
insert into bonusuri(id_bonus, tip_cadou) values (4,'Tort');
insert into bonusuri(id_bonus, tip_cadou) values (5,'Zozole');
insert into bonusuri(id_bonus, tip_cadou) values (6,'Nimic');

--VENITURI (se calculeaza automat)
insert into venituri(taxe) values (10);

--APROVIZIONARI
insert into aprovizionari(id_produs, pret_aprovizionare, cantitate_aprovizionare) values (1, 50, 50);
insert into aprovizionari(id_produs, pret_aprovizionare, cantitate_aprovizionare) values (2, 10, 15);
insert into aprovizionari(id_produs, pret_aprovizionare, cantitate_aprovizionare) values (3, 20, 35);
insert into aprovizionari(id_produs, pret_aprovizionare, cantitate_aprovizionare) values (4, 10, 50);
insert into aprovizionari(id_produs, pret_aprovizionare, cantitate_aprovizionare) values (5, 10, 150);
insert into aprovizionari(id_produs, pret_aprovizionare, cantitate_aprovizionare) values (6, 13, 30);
insert into aprovizionari(id_produs, pret_aprovizionare, cantitate_aprovizionare) values (7, 20, 20);
insert into aprovizionari(id_produs, pret_aprovizionare, cantitate_aprovizionare) values (8, 10, 70);

--COMENZI
begin
    insert into comenzi(id_client, id_bonus) 
        values (gaseste_id_dupa_username('Carlita26'), 6);
    insert into detalii_comanda(id_produs, id_comanda, cantitate) values (1, comenzi_id_comanda_seq.currval, 2);
    commit;
end;
/

begin
    insert into comenzi(id_client, id_bonus) 
        values (gaseste_id_dupa_username('LuissaG23'), 4);
    update produse
        set cantitate_disponibila = cantitate_disponibila - 1 
        where nume_produs = (select tip_cadou from bonusuri where id_bonus = 4);
    insert into detalii_comanda(id_produs, id_comanda, cantitate) values (1, comenzi_id_comanda_seq.currval, 5);
    insert into detalii_comanda(id_produs, id_comanda, cantitate) values (7, comenzi_id_comanda_seq.currval, 20);
    commit;
end;
/

begin
    insert into comenzi(id_client, id_bonus) 
        values (gaseste_id_dupa_username('AndreeaP30'), 3);
    update produse
        set cantitate_disponibila = cantitate_disponibila - 20 
        where nume_produs = (select tip_cadou from bonusuri where id_bonus = 3);
    insert into detalii_comanda(id_produs, id_comanda, cantitate) values (2, comenzi_id_comanda_seq.currval, 10);
    insert into detalii_comanda(id_produs, id_comanda, cantitate) values (7, comenzi_id_comanda_seq.currval, 10);
    insert into detalii_comanda(id_produs, id_comanda, cantitate) values (4, comenzi_id_comanda_seq.currval, 30);
    commit;
end;
/

select * from produse;

begin
    insert into comenzi(id_client, id_bonus) 
        values (gaseste_id_dupa_username('BiancaB19'), 5);
     update produse
        set cantitate_disponibila = cantitate_disponibila - 100 
        where nume_produs = (select tip_cadou from bonusuri where id_bonus = 5);   
    insert into detalii_comanda(id_produs, id_comanda, cantitate) values (3, comenzi_id_comanda_seq.currval, 15);
    insert into detalii_comanda(id_produs, id_comanda, cantitate) values (6, comenzi_id_comanda_seq.currval, 20);
    insert into detalii_comanda(id_produs, id_comanda, cantitate) values (8, comenzi_id_comanda_seq.currval, 40);
    commit;
end;
/

begin
    insert into comenzi(id_client, id_bonus) 
        values (gaseste_id_dupa_username('Carlita26'), 2);
     update produse
        set cantitate_disponibila = cantitate_disponibila - 10 
        where nume_produs = (select tip_cadou from bonusuri where id_bonus = 2);   
    insert into detalii_comanda(id_produs, id_comanda, cantitate) values (8, comenzi_id_comanda_seq.currval, 10);
    insert into detalii_comanda(id_produs, id_comanda, cantitate) values (5, comenzi_id_comanda_seq.currval, 40);
    insert into detalii_comanda(id_produs, id_comanda, cantitate) values (6, comenzi_id_comanda_seq.currval, 10);
    commit;
end;
/
-----
begin
    insert into comenzi(id_client, id_bonus) 
        values (gaseste_id_dupa_username('Carlita26'), 2);
     update produse
        set cantitate_disponibila = cantitate_disponibila - 10 
        where nume_produs = (select tip_cadou from bonusuri where id_bonus = 2);   
    insert into detalii_comanda(id_produs, id_comanda, cantitate) values (8, comenzi_id_comanda_seq.currval, 10);
    insert into detalii_comanda(id_produs, id_comanda, cantitate) values (5, comenzi_id_comanda_seq.currval, 40);
    insert into detalii_comanda(id_produs, id_comanda, cantitate) values (6, comenzi_id_comanda_seq.currval, 10);
    commit;
end;
/
-----
begin
    insert into comenzi(id_client, id_bonus) 
        values (gaseste_id_dupa_username('GeorgianaA19'), 4);
     update produse
        set cantitate_disponibila = cantitate_disponibila - 10 
        where nume_produs = (select tip_cadou from bonusuri where id_bonus = 4);   
    insert into detalii_comanda(id_produs, id_comanda, cantitate) values (1, comenzi_id_comanda_seq.currval, 2);
    insert into detalii_comanda(id_produs, id_comanda, cantitate) values (3, comenzi_id_comanda_seq.currval, 10);
    insert into detalii_comanda(id_produs, id_comanda, cantitate) values (4, comenzi_id_comanda_seq.currval, 20);
    insert into detalii_comanda(id_produs, id_comanda, cantitate) values (8, comenzi_id_comanda_seq.currval, 20);
    commit;
end;
/

--AICI TRANZACTIA NU VA REUSI DEOARECE SE VOR COMANDA MAI MULTE AMANDINE DECAT SUNT IN STOC
begin
    insert into comenzi(id_client, id_bonus) 
        values (gaseste_id_dupa_username('Anzertrop22'), 5);
    update produse
        set cantitate_disponibila = cantitate_disponibila - 10 
        where nume_produs = (select tip_cadou from bonusuri where id_bonus = 5);
    insert into detalii_comanda(id_produs, id_comanda, cantitate) values (1, comenzi_id_comanda_seq.currval, 1);
    insert into detalii_comanda(id_produs, id_comanda, cantitate) values (7, comenzi_id_comanda_seq.currval, 20);
    commit;
end;
/

---VALIDARE TRIGGERE RAMASE--

--APROVIZIONARI
--PRET_APROVIZIONARE ESTE MAI MARE CA PRETUL DE VANZARE
insert into aprovizionari(id_produs, pret_aprovizionare, cantitate_aprovizionare) values (1, 150, 50);

--DATA DE APROVIZIONARE NU ESTE DATA CURENTA
insert into aprovizionari(id_produs, data_aprovizionare, pret_aprovizionare, cantitate_aprovizionare) values (1, sysdate - 1, 50, 50);