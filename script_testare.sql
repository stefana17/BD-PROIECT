---VIZUALIZARE---

--1. SA SE MAREASCA PRETURILE CU 10%. SA SE AFISEZE NUMELE PRODUSULUI SI PRETUL INAINTE SI DUPA MODIFICARE
select nume_produs, pret_produs
    from produse;
    
update produse
    set pret_produs = pret_produs + pret_produs * 10/100;
    
select nume_produs, pret_produs
    from produse;
    
--2. SA SE SCHIMBE NUMARUL DE TELEFON AL CLIENTULUI CU USERNAME-UL "AndreeaP30". SA SE AFISEZE NUMELE CLIENTULUI SI NUMARUL DE TELEFON
select nume_client, numar_telefon 
    from clienti, detalii_client
    where clienti.id_client = detalii_client.id_client
    and nume_utilizator = 'AndreeaP30';
    
update detalii_client 
    set numar_telefon = '0766666666'
    where id_client = (select id_client from clienti where nume_utilizator = 'AndreeaP30');

select nume_client, numar_telefon 
    from clienti, detalii_client
    where clienti.id_client = detalii_client.id_client
    and nume_utilizator = 'AndreeaP30';
    
--3. SA SE AFISEZE NUMARUL DE PRODUSE CARE AU PRETUL IN INTERVALUL 0, 50 SI NUMARUL DE PRODUSE CARE AU PRETUL IN INTERVALUL 51, 100
with
    interval1 as ( 
        select count(id_produs) as i1 
            from produse 
            where (pret_produs between 0 and 50) ),
    interval2 as ( 
        select count(id_produs) as i2 
            from produse 
            where (pret_produs between 51 and 100) )
select i1 as "(0-50]", i2 as "[51-100]"
from interval1, interval2;

--4. SA SE DETERMINTE CATE COMENZI S-AU REALIZAT PANA IN MOMENTUL ACTUAL SI SA SE DENUMEASCA "Numar Comenzi"
select * from comenzi; 

select count(id_comanda) as "Numar Comenzi"
from comenzi;
            
--5. SA SE DETERMINE CARE A FOST CEL MAI CUMPARAT PRODUS
select * from detalii_comanda;

/*select p.nume_produs
    from produse p, detalii_comanda d
    group by p.nume_produs
    having count(d.id_produs)=(select max(count(p.id_produs))
            from produse p, detalii_comanda d
            where p.id_produs = d.id_produs
            group by p.nume_produs);*/
            
with 
    produs as (
        select nume_produs name, count(detalii_comanda.id_produs) p_cnt
        from detalii_comanda, produse
        where produse.id_produs = detalii_comanda.id_produs
        group by nume_produs),
    maxim as (
        select max(p_cnt) numar 
        from produs)
select name
from produs, maxim
where p_cnt = numar;

--6. SA SE DETERMINE CEL MAI FIDEL CLIENT
with
    comanda as (
        select nume_client name, count(comenzi.id_comanda) c_cnt
        from comenzi, clienti
        where comenzi.id_client = clienti.id_client
        group by nume_client),
    maxim as (
        select max(c_cnt) numar 
        from comanda)
select name
from comanda, maxim
where c_cnt = numar;

--7. SA SE DETERMINE CARE SUNT CLIENTII CARE STAU LA BLOC
select nume_client
    from clienti, detalii_client
    where clienti.id_client = detalii_client.id_client
    and adresa_client like '%Bl%';
    
--8. SA SE AFISEZE NUMELE CLIENTUL CARE A PRIMIT TORT CA BONUS
select nume_client
    from clienti, bonusuri, comenzi
    where clienti.id_client = comenzi.id_client
    and comenzi.id_bonus = bonusuri.id_bonus
    and tip_cadou = 'Tort';
    
--9. SA SE AFISEZE PRODUSUL CARE A FOST OFERIT SPRE VANZARE IN CANTITATEA CEA MAI MARE
select nume_produs
    from produse
    where id_produs = (select id_produs
                from aprovizionari
                where cantitate_aprovizionare = (select max(cantitate_aprovizionare) from aprovizionari ));

--10. SA SE AFISEZE INFORMATII DESPRE CLIENTI
select clienti.id_client, nume_client, nume_utilizator, parola, tip_utilizator, numar_telefon, adresa_client, email_client, cod_postal
    from clienti, detalii_client
    where clienti.id_client = detalii_client.id_client;

---ADAUGARE---

--11. SA SE ADAUGE COLOANA data_expirare in tabela PRODUSE
alter table produse
    add(data_expirare DATE);
    
desc produse;

---VALIDARE CONSTRANGERI---

--12. FOLOSIND COMANDA UPDATE IN TABELA CLIENTI SA SE INCALCE CONSTRANGEREA clienti_nume_client_ck
update clienti set nume_client = 'Ana';

--13. FOLOSIND COMANDA UPDATE IN TABELA CLIENTI SA SE INCALCE CONSTRANGEREA clienti_nume_util_ck
update clienti set nume_utilizator = 'Sef.smecher12';

--14. FOLOSIND COMANDA UPDATE IN TABELA CLIENTI SA SE INCALCE CONSTRANGEREA clienti_parola_ck
update clienti set parola = 'Bd@p23';

--15. FOLOSIND COMANDA UPDATE IN TABELA CLIENTI SA SE INCALCE CONSTRANGEREA clienti_tip_utilizator
update clienti set tip_utilizator = 'Vizitator';

--16. FOLOSIND COMANDA UPDATE IN TABELA BONUSURI SA SE INCALCE CONSTRANGEREA bonusuri_tip_cadou_ck
update bonusuri set tip_cadou = 'Padurea neagra';

--17. FOLOSIND COMANDA UPDATE IN TABELA COMENZI SA SE INCALCE CONSTRANGEREA comenzi_pret_comanda_ck
update comenzi set pret_comanda = -25;

--18. FOLOSIND COMANDA UPDATE IN TABELA DETALII_CLIENT SA SE INCALCE CONSTRANGEREA detalii_nr_telefon_ck
update detalii_client set numar_telefon = '003932912q';

--19. FOLOSIND COMANDA UPDATE IN TABELA DETALII_CLIENT SA SE INCALCE CONSTRANGEREA detalii_adresa_client_ck
update detalii_client set adresa_client = 'Str. Valea Adanca Nr.12';

--20. FOLOSIND COMANDA UPDATE IN TABELA DETALII_CLIENT SA SE INCALCE CONSTRANGEREA detalii_email_ck
update detalii_client set email_client = 'papusica!!frumusica12@yahoo.com';

--21. FOLOSIND COMANDA UPDATE IN TABELA PRODUSE SA SE INCALCE CONSTRANGEREA produse_pret_produs_ck
update produse set pret_produs = 5;

--22. FOLOSIND COMANDA UPDATE IN TABELA PRODUSE SA SE INCALCE CONSTRANGEREA produse_cantitate_disp_ck
update produse set cantitate_disponibila = -25;

---STERGERE---
-- SA SE STEARGA INREGISTRAREA TAXEI DIN TABELA VENITURI
delete from venituri
    where taxe = 10;
 
        


