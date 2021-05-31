--TWORZENIE TABEL
CREATE TABLE StatusZamowienia (Id INTEGER PRIMARY KEY IDENTITY,
	Statusz varchar (20) )
INSERT INTO StatusZamowienia(Statusz) VALUES ('Przyjęte')
INSERT INTO StatusZamowienia(Statusz) VALUES ('W realizacji')
INSERT INTO StatusZamowienia(Statusz) VALUES ('Zrealizowane')


CREATE TABLE Produkt (IdProduktu INTEGER PRIMARY KEY AUTO_INCREMENT, 
	Nazwa varchar(30) NOT NULL, 
	Producent varchar(20) NOT NULL, 
	Cena float NOT NULL, 
	Gwarancja varchar(3) NOT NULL, 
	VAT float NOT NULL, 
	Opis text NOT NULL, 
	Kategoria varchar(20) NOT NULL,
	Długość float NOT NULL,
	Szerokość float NOT NULL, 
	Wysokość float NOT NULL);
INSERT INTO Produkt(Nazwa, Producent, Cena, Gwarancja, VAT, Opis, Kategoria, Długość, Szerokość, Wysokość) 
	VALUES ('Słuchawki', 'Razer', 199.99, 18, 0.23, 'Zajebiste w chuj', 'Audio', 12.6, 13.2, 14.5);
INSERT INTO Produkt(Nazwa, Producent, Cena, Gwarancja, VAT, Opis, Kategoria, Długość, Szerokość, Wysokość) 
	VALUES ('Klawiatura', 'Logitech', 299.99, 12, 0.23, 'Chujowa, nie polecam', 'I/O', 10, 10, 10);
INSERT INTO Produkt(Nazwa, Producent, Cena, Gwarancja, VAT, Opis, Kategoria, Długość, Szerokość, Wysokość) 
	VALUES ('Karta graficzna', 'NVIDIA', 1199.99, 24, 0.23, 'Cyberpunka pociągnie', 'Komponenty', 10, 15, 15);
INSERT INTO Produkt(Nazwa, Producent, Cena, Gwarancja, VAT, Opis, Kategoria, Długość, Szerokość, Wysokość) 
	VALUES ('AMysz', 'Warrior', 257.85, 18, 0.23, 'Fajna', 'I/O', 12.6, 13.2, 14.5);
INSERT INTO Produkt(Nazwa, Producent, Cena, Gwarancja, VAT, Opis, Kategoria, Długość, Szerokość, Wysokość) 
	VALUES ('Słuchawki', 'Panasonic', 257.85, 18, 0.23, 'Fajna', 'I/O', 12.6, 13.2, 14.5);


DROP TABLE KonkretnyProdukt
CREATE TABLE KonkretnyProdukt (NumerSeryjny INTEGER PRIMARY KEY IDENTITY , 
	StatusP varchar(20) NOT NULL, 
	IdProduktu int NOT NULL)
INSERT INTO KonkretnyProdukt (IdProdukt2
u, StatusP)
	VALUES ( 5, 'dostępny')

CREATE TABLE ZamówieniaKonkretnyProdukt ( IdZamówieniaKonkretnyProdukt INTEGER PRIMARY KEY IDENTITY,
	NumerSeryjny int NOT NULL,
	IdZamówienia int NOT NULL)

DROP TABLE Zamówienia
CREATE TABLE Zamówienia (IdZamówienia INTEGER PRIMARY KEY IDENTITY ,
	Cena float NOT NULL, 
	RodzajPłatności varchar(20) NOT NULL, 
	TerminDostawy datetime NOT NULL,  
	IdKlientAdres int NOT NULL, 
	StatusZamówienia varchar(20) NOT NULL)
INSERT INTO Zamówienia (IdZamówienia, Cena, RodzajPłatności, TerminDostawy, IdKlientAdres, StatusZamówienia)
	VALUES (1, (SELECT Cena FROM Produkt WHERE IdProduktu = 1), 'Karta', '2001-07-13', 1, 'Przyjęte') 


CREATE TABLE Klient (IdKlienta INTEGER PRIMARY KEY IDENTITY , 
	Imię varchar(20) NOT NULL,
	Nazwisko varchar(30) NOT NULL, 
	NIP char(10),
	Email varchar(30),
	Hasło varchar (20))

INSERT INTO Klient ( Imię, Nazwisko, Email, Hasło)
	VALUES ('Adam', 'Małysz', 'adam.malysz@gmail.com', 'skaczenajdalej')
	VALUES ('Daniel', 'Reszelski', 'daniel.reszelski@gmail.com', 'jestemglupi')

DROP TABLE Adresy
CREATE TABLE Adresy (IdAdres INTEGER PRIMARY KEY IDENTITY,
	Miejscowość varchar (20) NOT NULL,
	KodPocztowy char (6) NOT NULL,
	Ulica varchar (30) NOT NULL,
	NrDomu varchar (4) NOT NULL,
	NrMieszkania varchar (3))

INSERT INTO Adresy (Miejscowość, KodPocztowy, Ulica, NrDomu, NrMieszkania, IdKlient)
	VALUES ('Kalisz', '62-800', 'Adama Małysza', '8', '13', 2)

CREATE TABLE KlientAdres (IdKlientAdres INTEGER PRIMARY KEY IDENTITY,
	IdKlient int NOT NULL,
	IdAdres int NOT NULL)


CREATE TABLE Pracownicy (IdPracownika INTEGER PRIMARY KEY IDENTITY , 
	Imię varchar(20) NOT NULL,
	Nazwisko varchar(30) NOT NULL, 
	Stanowisko varchar(30) NOT NULL,
	LoginPr varchar (20),
	Hasło varchar (20),
	PoziomUprawnien int) 
INSERT INTO Pracownicy (Imię, Nazwisko, Stanowisko, LoginPr, Hasło, PoziomUprawnien)
	VALUES ('Wojtek', 'Fortuna', 'ObslugaKlienta', 'Wojtus', 'CiastkaZMlekiem12', 1)
	VALUES ('Kamil', 'Szczoch', 'Admin', 'Kamilek123', 'skaczeblisko', 2)
	VALUES ('root', 'root', 'root', 'root', 'root', 2)

SELECT * FROM Pracownicy


--TWORZENIE PROCEDUR SKŁADOWANYCH
--REJESTRACJA KLIENTA
CREATE PROCEDURE RejestracjaKlienta
@imie varchar (20),
@nazwisko varchar (30),
@email varchar (30),
@NIP char (10) = NULL,
@haslo varchar (20)
AS 
BEGIN
	IF (SELECT IdKlienta 
		FROM Klient
		WHERE Email = @email) IS NULL
		BEGIN
			INSERT INTO Klient ( Imię, Nazwisko, Email, NIP, Hasło)
			VALUES (@imie, @nazwisko, @email, @NIP, @haslo)
		END
END

exec RejestracjaKlienta 'Dawid', 'Kubacki', 'dawid.kubacki@gmail.com', NULL, 'jestemnielotem'

--DODAWANIE ADRESU KLIENTA
CREATE PROCEDURE DodawanieAdresu
@miasto varchar (30),
@kod char (6),
@ulica varchar (30),
@nrdomu varchar (4),
@nrmieszkania varchar (3) = NULL,
@idklient int
AS 
BEGIN
	IF ((SELECT IdAdres
		FROM Adresy
		WHERE (Miejscowość = @miasto
		AND KodPocztowy = @kod 
		AND Ulica = @ulica 
		AND NrDomu = @nrdomu 
		AND ( NrMieszkania = @nrmieszkania OR Nrmieszkania IS NULL )))) IS NULL 
			BEGIN
				INSERT INTO Adresy (Miejscowość, KodPocztowy, Ulica, NrDomu, NrMieszkania)
				VALUES (@miasto, @kod, @ulica, @nrdomu, @nrmieszkania)
			END
		IF (SELECT ka.IdKlientAdres
			FROM KlientAdres ka
				INNER JOIN Adresy a
				ON a.IdAdres = ka.IdAdres
			WHERE (ka.IdKlient = @idklient AND (a.Miejscowość = @miasto AND a.KodPocztowy = @kod AND a.Ulica = @ulica 
			AND a.NrDomu = @nrdomu AND (a.NrMieszkania = @nrmieszkania OR a.NrMieszkania IS NULL)))) IS NULL
			BEGIN
				INSERT INTO KlientAdres (IdKlient, IdAdres)
					VALUES (@idklient,
					(SELECT IdAdres
					FROM Adresy
					WHERE (Miejscowość = @miasto
					AND KodPocztowy = @kod 
					AND Ulica = @ulica 
					AND NrDomu = @nrdomu 
					AND ( NrMieszkania = @nrmieszkania OR Nrmieszkania IS NULL ))))
			END
END

exec DodawanieAdresu 'Gdańsk', '12-222', 'Staromiejska', '145', '27', '3'

--LOGOWANIE KLIENTA
CREATE PROCEDURE LogowanieKlienta
@email varchar(30),
@hasło varchar (20)
AS
BEGIN
	SELECT IdKlienta
	FROM Klient
	WHERE Email = @email
		AND Hasło = @hasło
END
exec LogowanieKlienta 'adam.malysz@gmail.com', 'skaczenajdalej'


--LOGOWANIE PRACOWNIKA
CREATE PROCEDURE LogowaniePracownika
@login varchar(30),
@hasło varchar (20)
AS
BEGIN
	SELECT IdPracownika
	FROM Pracownicy 
	WHERE LoginPr = @login
		AND Hasło = @hasło
END

exec LogowaniePracownika 'Kamilek123', 'skaczeblisko'

--WYSZUKIWANIE PO NAZWIE
CREATE PROCEDURE Szukaj
@input varchar (30)
AS 
BEGIN
	SELECT *
	FROM Produkt
	WHERE Nazwa LIKE CONCAT ('%', @input, '%')
END

exec Szukaj 'sz'


--WYŚWIETLANIE PRODUKTÓW
CREATE PROCEDURE PobierzProdukty
@kategoria varchar (30) = NULL,
@sort int = NULL
AS 
BEGIN
	IF @sort = 1 
		BEGIN
			SELECT DISTINCT IdProduktu Nazwa, Producent, Cena
			FROM Produkt p
				INNER JOIN KonkretnyProdukt kp
				ON kp.IdProduktu = p.IdProduktu
			WHERE (Kategoria = @kategoria OR @kategoria IS NULL) AND kp.StatusP = 'dostępny'
			ORDER BY Cena
		END
	IF @sort = 2 
		BEGIN
			SELECT DISTINCT IdProduktu Nazwa, Producent, Cena
			FROM Produkt p
				INNER JOIN KonkretnyProdukt kp
				ON kp.IdProduktu = p.IdProduktu
			WHERE (Kategoria = @kategoria OR @kategoria IS NULL) AND kp.StatusP = 'dostępny'
			ORDER BY Cena DESC
		END
	IF @sort = 0 
		BEGIN
			SELECT DISTINCT IdProduktu Nazwa, Producent, Cena
			FROM Produkt p
				INNER JOIN KonkretnyProdukt kp
				ON kp.IdProduktu = p.IdProduktu
			WHERE (Kategoria = @kategoria OR @kategoria IS NULL) AND kp.StatusP = 'dostępny'
			ORDER BY Nazwa
		END
END
exec PobierzProdukty 'I/O', 1


--Dodawanie pierwszego produktu do zamówienia
CREATE PROCEDURE SkladanieZamowienia
@idklienta int,
@idadres int,
@idproduktu int, 
@rodzajplatnosci varchar(20)
AS
BEGIN

	INSERT INTO Zamówienia (Cena, RodzajPłatności, TerminDostawy, IdKlientAdres, StatusZamówienia)
		VALUES(	(SELECT Cena
				FROM Produkt
				WHERE IdProduktu = @idproduktu ),
				@rodzajplatnosci,
				DATEADD(DAY, 14, CURRENT_TIMESTAMP),
				(SELECT ka.IdKlientAdres
				FROM Klient k
					INNER JOIN KlientAdres ka
					ON k.IdKlienta = ka.IdKlient
					INNER JOIN Adresy a
					ON a.IdAdres = ka.IdAdres
				WHERE ka.IdKlient = @idklienta AND ka.IdAdres = @idadres),
				'przyjęte')
	INSERT INTO ZamówieniaKonkretnyProdukt (NumerSeryjny, IdZamówienia)
		VALUES ( (SELECT TOP 1 NumerSeryjny
				FROM Produkt p
					INNER JOIN KonkretnyProdukt kp
					ON kp.IdProduktu = p.IdProduktu
				WHERE p.IdProduktu = @idproduktu AND kp.StatusP = 'dostępny'),
				(SELECT TOP 1 IdZamówienia
				FROM Zamówienia
				ORDER BY IdZamówienia DESC))
	UPDATE KonkretnyProdukt
	SET StatusP = 'Niedostępny'
	WHERE NumerSeryjny =
		(SELECT TOP 1 NumerSeryjny
		FROM Produkt p
		INNER JOIN KonkretnyProdukt kp
		ON kp.IdProduktu = p.IdProduktu
		WHERE p.IdProduktu = @idproduktu AND kp.StatusP = 'dostępny')
END



--Dodawanie następnego produktu do zamówienia
CREATE PROCEDURE NastepnyProdukt
@idproduktu int
AS 
BEGIN

	INSERT INTO ZamówieniaKonkretnyProdukt (NumerSeryjny, IdZamówienia)
		VALUES ( (SELECT TOP 1 NumerSeryjny
				FROM Produkt p
					INNER JOIN KonkretnyProdukt kp
					ON kp.IdProduktu = p.IdProduktu
				WHERE p.IdProduktu = @idproduktu AND kp.StatusP = 'dostępny'),
				(SELECT TOP 1 IdZamówienia
				FROM Zamówienia
				ORDER BY IdZamówienia DESC))
	DECLARE @NowaCena int = (
							SELECT SUM (p.cena)
							FROM Zamówienia z
								INNER JOIN ZamówieniaKonkretnyProdukt zk
								ON z.IdZamówienia = zk.IdZamówienia
								INNER JOIN KonkretnyProdukt kp
								ON zk.NumerSeryjny = kp.NumerSeryjny
								INNER JOIN Produkt p
								ON p.IdProduktu = kp.IdProduktu
							WHERE z.IdZamówienia = (
							SELECT TOP 1 IdZamówienia 
							FROM Zamówienia 
							ORDER BY IdZamówienia DESC) )
	UPDATE Zamówienia
	SET Cena = @NowaCena
	WHERE ( IdZamówienia = (
				SELECT TOP 1 IdZamówienia 
				FROM Zamówienia 
				ORDER BY IdZamówienia DESC) 
			)
	UPDATE KonkretnyProdukt
	SET StatusP = 'Niedostępny'
	WHERE NumerSeryjny =
		(SELECT TOP 1 NumerSeryjny
		FROM Produkt p
		INNER JOIN KonkretnyProdukt kp
		ON kp.IdProduktu = p.IdProduktu
		WHERE p.IdProduktu = @idproduktu AND kp.StatusP = 'dostępny')
END

--SPRAWDZENIE ILOSCI DOSTEPNYCH PRODUKTOW
CREATE PROCEDURE SprawdzIlosc
@idproduktu int
AS 
BEGIN
	SELECT COUNT (kp.IdProduktu)
	FROM Produkt p
		INNER JOIN KonkretnyProdukt kp
		ON p.IdProduktu = kp.IdProduktu
	WHERE p.IdProduktu = @idproduktu AND kp.StatusP = 'dostępny'
END

--Dodawanie nowych produktów
SELECT *
FROM Produkt
CREATE PROCEDURE DodajProdukt
@nazwa varchar (30),
@producent varchar (20),
@cena float,
@gwarancja varchar (3),
@vat float, 
@opis text,
@kategoria varchar (20),
@dlugosc float,
@szerokosc float,
@wysokosc float
AS 
BEGIN
	INSERT INTO Produkt(Nazwa, Producent, Cena, Gwarancja, VAT, Opis, Kategoria, Długość, Szerokość, Wysokość) 
	VALUES (@nazwa, @producent, @cena, @gwarancja, @vat, @opis, @kategoria, @dlugosc, @szerokosc, @wysokosc)
END

exec DodajProdukt 'RAM 8GB', 'Intel', 515.74, '18', 0.15, 'No no', 'Komponenty', 14.8, 0.1, 0.3
--Dodawanie nowych egzemplarzy produktów
CREATE PROCEDURE DodawanieEgzemplarza
@idproduktu int
AS
BEGIN
	INSERT INTO KonkretnyProdukt (StatusP, IdProduktu)
		VALUES ('dostępny', @idproduktu)
END

--Aktualizowanie statusu zamówienia
CREATE PROCEDURE AktualizacjaStatusu
@idzamowienia int,
@status varchar (20)
AS
BEGIN
	UPDATE Zamówienia
	SET StatusZamówienia = @status
	WHERE IdZamówienia = @idzamowienia
END
exec AktualizacjaStatusu 7, 'w trakcie realizacji'

--TESTY
exec RejestracjaKlienta 'root', 'root', 'root', NULL, 'root'
exec RejestracjaKlienta 'Stefna', 'Hula', 'stefekterminator@gmail.com', NULL, 'SkaczeDaleko'
exec DodawanieAdresu 'Warszawa', '01-100', 'Polska', '6', '17', 3
exec LogowanieKlienta 'daniel.reszelski@gmail.com', 'NieWA4TO'
exec SkladanieZamowienia 3, 6, 1, 'karta'
exec NastepnyProdukt 4,1

CREATE PROCEDURE SkladanieZamowienia
@idklienta int,
@idadres int,
@idproduktu int, 
@rodzajplatnosci varchar(20),
@ilosc int

exec SkladanieZamowienia 3, 1, 2, 'karta'

SELECT k.Imię, k.Nazwisko, a.Ulica, a.NrDomu, a.NrMieszkania, a.KodPocztowy 
FROM Klient k
	INNER JOIN KlientAdres ka
	ON k.IdKlienta = ka.IdKlient
	INNER JOIN Adresy a
	ON a.IdAdres = ka.IdAdres
WHERE a.IdAdres = 2

DELETE
FROM Adresy
WHERE IdAdres = 4
exec SkladanieZamowienia 2,6,2, 'karta'
exec NastepnyProdukt 4

UPDATE KonkretnyProdukt
SET StatusP = 'dostępny'
WHERE StatusP = 'niedostępny'
SELECT *
FROM Pracownicy
SELECT *
FROM Adresy
SELECT *
FROM Klient
SELECT * 
FROM Produkt
exec SprawdzIlosc 3
SELECT *
FROM KonkretnyProdukt
SELECT *
FROM Zamówienia
SELECT *
FROM ZamówieniaKonkretnyProdukt
INSERT INTO ZamówieniaKonkretnyProdukt (NumerSeryjny, IdZamówienia, Ilość)
	VALUES (20, 7, 1)

SELECT k.Imię, k.Nazwisko, z.Cena, z.TerminDostawy
FROM Klient k
	INNER JOIN KlientAdres ka
	ON k.IdKlienta = ka.IdKlient
	INNER JOIN Zamówienia z
	ON ka.IdKlientAdres = z.IdKlientAdres
WHERE k.IdKlienta = 3

exec DodawanieEgzemplarza 1
exec DodawanieEgzemplarza 2
exec DodawanieEgzemplarza 3
exec DodawanieEgzemplarza 4
exec DodawanieEgzemplarza 5
exec DodawanieEgzemplarza 6
exec DodawanieEgzemplarza 7
exec DodawanieEgzemplarza 8
exec DodawanieEgzemplarza 9
exec DodawanieEgzemplarza 10
exec DodawanieEgzemplarza 11
exec DodawanieEgzemplarza 12
exec DodawanieEgzemplarza 13
exec DodawanieEgzemplarza 14
exec DodawanieEgzemplarza 15
exec DodawanieEgzemplarza 16

CREATE PROCEDURE PokazAdresy
@idklient int
AS 
BEGIN
    SELECT *
    FROM Klient k
        INNER JOIN KlientAdres ka
        ON k.IdKlienta = ka.IdKlient
        INNER JOIN Adresy a
        ON a.IdAdres = ka.IdAdres
    WHERE k.IdKlienta = @idklient
END


exec PokazAdresy 1

ALTER PROCEDURE DodawanieAdresu
@miasto varchar (30),
@kod char (6),
@ulica varchar (30),
@nrdomu varchar (4),
@nrmieszkania varchar (3) = NULL,
@email varchar (30)
AS 
BEGIN
    IF ((SELECT IdAdres
        FROM Adresy
        WHERE (Miejscowość = @miasto
        AND KodPocztowy = @kod 
        AND Ulica = @ulica 
        AND NrDomu = @nrdomu 
        AND ( NrMieszkania = @nrmieszkania OR Nrmieszkania IS NULL )))) IS NULL 
            BEGIN
                INSERT INTO Adresy (Miejscowość, KodPocztowy, Ulica, NrDomu, NrMieszkania)
                VALUES (@miasto, @kod, @ulica, @nrdomu, @nrmieszkania)
            END
        IF (SELECT ka.IdKlientAdres
            FROM KlientAdres ka
                INNER JOIN Adresy a
                ON a.IdAdres = ka.IdAdres
                INNER JOIN Klient k
                ON k.IdKlienta = ka.IdKlient
            WHERE (k.Email = @email AND (a.Miejscowość = @miasto AND a.KodPocztowy = @kod AND a.Ulica = @ulica 
            AND a.NrDomu = @nrdomu AND (a.NrMieszkania = @nrmieszkania OR a.NrMieszkania IS NULL)))) IS NULL
            BEGIN
                INSERT INTO KlientAdres (IdKlient, IdAdres)
                    VALUES ((SELECT IdKlienta
                    FROM Klient
                    WHERE Email = @email),
                    (SELECT IdAdres
                    FROM Adresy
                    WHERE (Miejscowość = @miasto
                    AND KodPocztowy = @kod 
                    AND Ulica = @ulica 
                    AND NrDomu = @nrdomu 
                    AND ( NrMieszkania = @nrmieszkania OR Nrmieszkania IS NULL ))))
            END
END

ALTER PROCEDURE SkladanieZamowienia
@idadres int,
@email varchar (30),
@idproduktu int, 
@rodzajplatnosci varchar(20)
AS
BEGIN
	DECLARE @idklientadres int = (
							SELECT IdKlientAdres
							FROM Klient k
							INNER JOIN KlientAdres ka
							ON k.IdKlienta = ka.IdKlient
							INNER JOIN Adresy a
							ON a.IdAdres = ka.IdAdres
							WHERE k.Email = @email AND a.IdAdres = @idadres)
	
	INSERT INTO Zamówienia (Cena, RodzajPłatności, TerminDostawy, IdKlientAdres, StatusZamówienia)
		VALUES(	(SELECT Cena
				FROM Produkt
				WHERE IdProduktu = @idproduktu ),
				@rodzajplatnosci,
				DATEADD(DAY, 14, CURRENT_TIMESTAMP),
				@idklientadres,
				'przyjęte')
	INSERT INTO ZamówieniaKonkretnyProdukt (NumerSeryjny, IdZamówienia)
		VALUES ( (SELECT TOP 1 NumerSeryjny
				FROM Produkt p
					INNER JOIN KonkretnyProdukt kp
					ON kp.IdProduktu = p.IdProduktu
				WHERE p.IdProduktu = @idproduktu AND kp.StatusP = 'dostępny'),
				(SELECT TOP 1 IdZamówienia
				FROM Zamówienia
				ORDER BY IdZamówienia DESC))
	UPDATE KonkretnyProdukt
	SET StatusP = 'Niedostępny'
	WHERE NumerSeryjny =
		(SELECT TOP 1 NumerSeryjny
		FROM Produkt p
		INNER JOIN KonkretnyProdukt kp
		ON kp.IdProduktu = p.IdProduktu
		WHERE p.IdProduktu = @idproduktu AND kp.StatusP = 'dostępny')
END


CREATE PROCEDURE AdresyZMaila
@email varchar (30)
AS
BEGIN 
	SELECT a.IdAdres, a.Miejscowość, a.KodPocztowy, a.Ulica, a.NrDomu, a.NrMieszkania
	FROM Adresy a
	INNER JOIN KlientAdres ka
	ON a.IdAdres = ka.IdAdres
	INNER JOIN Klient k
	ON k.IdKlienta = ka.IdKlient
	WHERE k.Email = @email
END



CREATE PROCEDURE ZamówieniaZMaila
@email varchar (30)
AS
BEGIN 
	SELECT z.RodzajPłatności, z.TerminDostawy, z.StatusZamówienia
	FROM Zamówienia z
	INNER JOIN KlientAdres ka
	ON ka.IdKlientAdres=z.IdKlientAdres
	INNER JOIN Klient k
	ON k.IdKlienta = ka.IdKlient
	WHERE k.Email = @email
END



exec ZamówieniaZMaila 'root'

ALTER PROCEDURE PobierzProdukty
@kategoria varchar (30) = NULL,
@sort int = NULL
AS 
BEGIN
	IF @sort = 1 
		BEGIN
			SELECT DISTINCT p.IdProduktu, p.Nazwa, p.Producent, p.Cena
			FROM Produkt p
				INNER JOIN KonkretnyProdukt kp
				ON kp.IdProduktu = p.IdProduktu
			WHERE (Kategoria = @kategoria OR @kategoria IS NULL) AND kp.StatusP = 'dostępny'
			ORDER BY Cena
		END
	IF @sort = 2 
		BEGIN
			SELECT DISTINCT p.IdProduktu, p.Nazwa, p.Producent, p.Cena
			FROM Produkt p
				INNER JOIN KonkretnyProdukt kp
				ON kp.IdProduktu = p.IdProduktu
			WHERE (Kategoria = @kategoria OR @kategoria IS NULL) AND kp.StatusP = 'dostępny'
			ORDER BY Cena DESC
		END
	IF @sort = 0 
		BEGIN
			SELECT DISTINCT p.IdProduktu, p.Nazwa, p.Producent, p.Cena
			FROM Produkt p
				INNER JOIN KonkretnyProdukt kp
				ON kp.IdProduktu = p.IdProduktu
			WHERE (Kategoria = @kategoria OR @kategoria IS NULL) AND kp.StatusP = 'dostępny'
			ORDER BY Nazwa
		END
END



CREATE TABLE Produkt (IdProduktu INTEGER PRIMARY KEY IDENTITY , 
    Nazwa varchar(30) NOT NULL, 
    Producent varchar(20) NOT NULL, 
    Cena float NOT NULL, 
    Gwarancja varchar(3) NOT NULL, 
    VAT float NOT NULL, 
    Opis text NOT NULL, 
    Kategoria varchar(20) NOT NULL,
    Długość float NOT NULL,
    Szerokość float NOT NULL, 
    Wysokość float NOT NULL)
INSERT INTO Produkt(Nazwa, Producent, Cena, Gwarancja, VAT, Opis, Kategoria, Długość, Szerokość, Wysokość) 
    VALUES ('Klawiatura', 'Modecom', 299.99, 18, 0.23, 'Mechaniczna RGB', 'I/O', 52.6, 13.2, 3.5)
INSERT INTO Produkt(Nazwa, Producent, Cena, Gwarancja, VAT, Opis, Kategoria, Długość, Szerokość, Wysokość) 
    VALUES ('Myszka', 'Catzv1', 149.99, 12, 0.23, 'RGB, przewodowa', 'I/O', 10, 10, 10)
INSERT INTO Produkt(Nazwa, Producent, Cena, Gwarancja, VAT, Opis, Kategoria, Długość, Szerokość, Wysokość) 
    VALUES ('Mysz', 'NATEC', 99.99, 24, 0.23, 'Bezprzewodowa, lekka', 'I/O', 10, 10, 12)
INSERT INTO Produkt(Nazwa, Producent, Cena, Gwarancja, VAT, Opis, Kategoria, Długość, Szerokość, Wysokość) 
    VALUES ('Pamiec RAM', 'HYPERX Fury', 200.00, 18, 0.23, 'Polecam gorąco, 8GB', 'Komponenty', 12.6, 13.2, 14.5)
INSERT INTO Produkt(Nazwa, Producent, Cena, Gwarancja, VAT, Opis, Kategoria, Długość, Szerokość, Wysokość) 
    VALUES ('Słuchawki', 'JBL', 169.89, 18, 0.23, 'Bezprzewodowe, nauszne, BT 5.0, redukcja szumów', 'I/O', 22.6, 13.2, 4.5)
	
	INSERT INTO Produkt(Nazwa, Producent, Cena, Gwarancja, VAT, Opis, Kategoria, Długość, Szerokość, Wysokość) 
    VALUES ('Karta Pamięci 2GB', 'Samsung', 29.99, 18, 0.23, 'Polecam gorąco, 2GB', 'Komponenty', 2.6, 3.2, 4.5)
INSERT INTO Produkt(Nazwa, Producent, Cena, Gwarancja, VAT, Opis, Kategoria, Długość, Szerokość, Wysokość) 
    VALUES ('Drukarka', 'HP', 329.99, 12, 0.23, 'Polecam gorąco', 'I/O', 10, 10, 10)
INSERT INTO Produkt(Nazwa, Producent, Cena, Gwarancja, VAT, Opis, Kategoria, Długość, Szerokość, Wysokość) 
    VALUES ('Procesor IntelCorei8', 'NVIDIA', 2001.99, 24, 0.23, 'Polecam gorąco', 'Komponenty', 10, 15, 15)
INSERT INTO Produkt(Nazwa, Producent, Cena, Gwarancja, VAT, Opis, Kategoria, Długość, Szerokość, Wysokość) 
    VALUES ('Klawiatura mechaniczna', 'RAZER', 478.85, 18, 0.23, 'Mechaniczna, przewodowa, RGB', 'I/O', 32.6, 13.2, 2.5)
INSERT INTO Produkt(Nazwa, Producent, Cena, Gwarancja, VAT, Opis, Kategoria, Długość, Szerokość, Wysokość) 
    VALUES ('Głośnik', 'JBL', 309.45, 18, 0.23, 'Polecam gorąco', 'I/O', 12.6, 13.2, 14.5)


SELECT * FROM Produkt

DELETE
FROM Zamówienia
WHERE IdZamówienia IS NOT NULL

DELETE 
FROM ZamówieniaKonkretnyProdukt
WHERE IdZamówieniaKonkretnyProdukt IS NOT NULL

DELETE 
FROM KonkretnyProdukt
WHERE NumerSeryjny IS NOT NULL

exec DodawanieEgzemplarza 1
exec DodawanieEgzemplarza 2
exec DodawanieEgzemplarza 3
exec DodawanieEgzemplarza 4
exec DodawanieEgzemplarza 5
exec DodawanieEgzemplarza 6
exec DodawanieEgzemplarza 7
exec DodawanieEgzemplarza 8
exec DodawanieEgzemplarza 9
exec DodawanieEgzemplarza 10
exec DodawanieEgzemplarza 11
exec DodawanieEgzemplarza 12
exec DodawanieEgzemplarza 13
exec DodawanieEgzemplarza 14
exec DodawanieEgzemplarza 15
exec DodawanieEgzemplarza 16
exec DodawanieEgzemplarza 17