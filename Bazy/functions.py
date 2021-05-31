import os
import pyodbc

server_name = "MILOSHBOOK"
db_name = "Test"
server = "Server="+str(server_name)
db = "Database="+str(db_name)
key = "Driver={SQL Server Native Client 11.0};"+server+";"+db+";"+"Trusted_Connection=yes;"
cnxn = pyodbc.connect(key)
cursor = cnxn.cursor()


def Wyszukaj(mail=str, haslo=str):
     os.system("cls")
     print("Czego szukamy?:")
     szukaj=input()
     cursor.execute("exec Szukaj '"+str(szukaj)+"'")
     for row in cursor:
        print(row)

def PobierzProdukty(kategoria=str, sortowanie=str,mail=str, haslo=str):
    os.system("cls")
    print("\n Produkty z kategorii "+kategoria+"\n")
    cursor.execute("exec PobierzProdukty " + kategoria +", "+sortowanie)
    for row in cursor:
        print(row)


def WybierzSorotwanie(kategoria=str,mail=str, haslo=str):
      ans=True
      while ans:        
        print ("""
        1.Alfabetycznie
        2.Po cenie rosnąco
        3.Po cenie malejąco
        4.Powrot
        """)
        ans=input("Czego szukasz? ") 
        if ans=="1":
         PobierzProdukty(kategoria,"0",mail, haslo)
        elif ans=="2":
         PobierzProdukty(kategoria,"1",mail, haslo)
        elif ans=="3":
         PobierzProdukty(kategoria,"2",mail, haslo)
        elif ans=="4":
         KlientZalogowany(mail, haslo)
        elif ans !="":
         print("\n Not Valid Choice Try again") 

def NastepnyProdukt(mail=str, haslo=str):
        os.system("cls")
        print ("""
        1.Chcesz cos jeszcze zamowic?
        2.Konczymy zamowienie
        """)
        opcja=input()
        if opcja == '1':
            cursor.execute("SELECT * FROM Produkt")
            for row in cursor:
                print(row)
            print("Podaj ID wybranego produktu")
            id2=input()
            cursor.execute("exec NastepnyProdukt '"+id2+"'")
            cursor.commit()
            NastepnyProdukt(mail,haslo)
        elif opcja == '2':
            KlientZalogowany(mail,haslo)

def Zamowienie(mail=str, haslo=str):
    os.system("cls")
    print("Dostepne produkty:")
    cursor.execute("exec PobierzProdukty NULL, 1")
    for row in cursor:
        print(row)
    print("Podaj ID wybranego produktu")
    id=input()
    cursor.execute("exec AdresyZMaila '"+mail+"'")
    for row in cursor:
        print(row)
    print("Podaj ID wybranego adresu lub 0 by dodac nowy")
    ad=input()
    if ad == "0":
        DodajAdres(mail, haslo)
    else:
        print("Podaj rodzaj platnosci:")
        platnosc=input()
        cursor.execute("exec SkladanieZamowienia '"+ad+"', '"+mail+"', '"+id+"','"+platnosc+"'")
        cursor.commit()
        NastepnyProdukt(mail,haslo)
        
def Zarejestruj():
    os.system("cls")
    print("Podaj imie:")
    imie=input()
    print("Podaj nazwisko:")
    nazwisko=input()
    print("Podaj email:")
    email=input()
    print("Podaj NIP lub pomin:")
    nip=input()
    print("Podaj haslo:")
    haslo=input()
    cursor.execute("exec RejestracjaKlienta '"+imie+"', '"+nazwisko+"','"+email+"','"+nip+"', '"+haslo+"'")
    cursor.commit()
    
def Zaloguj():
    os.system("cls")
    print("Podaj mail: \n")
    mail=input()
    print("Podaj haslo: \n")
    haslo=input()
    cursor.execute("exec LogowanieKlienta '"+mail+"', '"+haslo+"'")
    for row in cursor:
        KlientZalogowany(mail,haslo)

def DodajAdres(mail=str, haslo=str):
    os.system("cls")
    print("Podaj miasto:")
    miasto=input()
    print("Podaj kod pocztowy (XX-XXX):")
    kod=input()
    print("Podaj ulice:")
    ulica=input()
    print("Podaj nr budynku:")
    nrdomu=input()
    print("Podaj nr mieszkania lub pomin:")
    nrmieszkania=input()
    cursor.execute("exec DodawanieAdresu '"+miasto+"', '"+kod+"','"+ulica+"','"+nrdomu+"', '"+nrmieszkania+"', '"+mail+"'")
    cursor.commit()
       

def Klient():
    os.system("cls")
    ans=True
    while ans:        
        print ("""
        1.Zaloguj sie
        2.Zarejestruj sie
        3.Wyjscie
        """)
        ans=input("Czego szukasz? ") 
        if ans=="1":
         Zaloguj()
        elif ans=="2":
         Zarejestruj()
        elif ans=="3":
          Menu() 
        elif ans !="":
          print("\n Not Valid Choice Try again")  

def KlientZalogowany(mail=str, haslo=str):
    os.system("cls")
    ans=True
    while ans:        
        print ("""
        1.Produkty
        2.Zloz zamowienie
        3.Moje zamowienia
        4.Wyszukaj
        5.Wyjscie
        """)
        ans=input("Czego szukasz? ") 
        if ans=="1":
         Produkty(mail, haslo)
        elif ans=="2":
         Zamowienie(mail, haslo)
        elif ans=="3":
            print("Twoje zamowienia: \n")
            cursor.execute("exec ZamówieniaZMaila '"+str(mail)+"'")
            for row in cursor:
               print(row)
        elif ans=="4":
            Wyszukaj(mail,haslo)
        elif ans=="5":
            Menu()
        elif ans !="":
          print("\n Not Valid Choice Try again")  

def Produkty(mail=str, haslo=str):
    os.system("cls")
    ans=True
    while ans:        
        print ("""
        1.I/O
        2.Komponenty
        3.Audio
        4.Wszystkie
        5.Wyjscie
        """)
        ans=input("Czego szukasz? ") 
        if ans=="1":
         WybierzSorotwanie("'I/O'")
        elif ans=="2":
         WybierzSorotwanie("'Komponenty'")
        elif ans=="3":
         WybierzSorotwanie("'Audio'")
        elif ans=="4":
         WybierzSorotwanie("NULL") 
        elif ans=="5":
            KlientZalogowany(mail, haslo) 
        elif ans !="":
          print("\n Not Valid Choice Try again") 

def NowyEgzemplarz():
    os.system("cls")
    cursor.execute("SELECT * FROM Produkt")
    for row in cursor:
       print(row)
    print("Podaj ID produktu, którego dodamy egzemplarz:")
    id=input()
    cursor.execute("exec DodawanieEgzemplarza '"+id+"'")
    cursor.commit()

def NowyProdukt():
    os.system("cls")
    print("Podaj nazwe nowego produktu:")
    nazwa=input()
    print("Podaj producenta:")
    producent=input()
    print("Podaj cene produktu:")
    cena=input()
    print("Podaj gwarancje produktu:")
    gwarancja=input()
    print("Podaj VAT:")
    vat=input()
    print("Podaj krotki opis produktu:")
    opis=input()
    print("Podaj kategorie produktu:")
    kategoria=input()
    print("Czas na wymiary :)")
    print("Podaj dlugosc produktu:")
    dlugosc=input()
    print("Podaj szerokosc produktu:")
    szerokosc=input()
    print("Podaj wysokosc produktu:")
    wysokosc=input()
    cursor.execute("exec DodajProdukt '"+nazwa+"', '"+producent+"', '"+cena+"', '"+gwarancja+"', '"+vat+"', '"+opis+"', '"+kategoria+"', '"+dlugosc+"', '"+szerokosc+"', '"+wysokosc+"'")
    cursor.commit()
    
    

def Magazyn():
    os.system("cls")
    ans=True
    while ans:        
        print ("""
        1.Dostepne produkty
        2.Dodaj nowy egzemplarz 
        3.Dodaj nowy produkt
        4.Wyjscie
        """)
        ans=input("Czego szukasz? ") 
        if ans=="1": 
          Dostepnosc()
        elif ans=="2":
          NowyEgzemplarz()
        elif ans=="3":
          NowyProdukt()
        elif ans=="4":
          Pracownik()
        elif ans !="":
          print("\n Not Valid Choice Try again") 

def Dostepnosc():
    os.system("cls")
    print("Dostepne produkty:")
    cursor.execute("SELECT * FROM Produkt")
    for row in cursor:
        print(row)
    print("Podaj ID wybranego produktu, a my podamy jego stan magazynowy")
    id=input()
    cursor.execute("exec SprawdzIlosc "+id)
    for row in cursor:
        print(row)

def AktualizujZam():
    os.system("cls")
    cursor.execute("SELECT * FROM Zamówienia")
    for row in cursor:
        print(row)
    print("Podaj ID wybranego zamowienia")
    id=input()
    print("Podaj aktualny status wybranego zamowienia")
    status=input()
    cursor.execute("exec AktualizacjaStatusu '"+id+"', '"+status+"'")
    cursor.commit()
   

def Zamowienia():
    os.system("cls")
    ans=True
    while ans:        
        print ("""
        1.Wszystkie zamowienia
        2.Aktualizuj status zamowienia
        3.Wyjscie
        """)
        ans=input("Czego szukasz? ") 
        if ans=="1": 
          cursor.execute("SELECT * FROM Zamówienia")
          for row in cursor:
                print(row)
        elif ans=="2":
          print("\n Aktualizacja statusu zamowienia:")
          AktualizujZam()
        elif ans=="3":
          Pracownik()
        elif ans !="":
          print("\n Not Valid Choice Try again") 


def Pracownik(login=str, haslo=str):
    os.system("cls")
    ans=True
    while ans:        
        print ("""
        1.Zamowienia
        2.Magazyn
        3.Wyjscie
        """)
        ans=input("Czego szukasz? ") 
        if ans=="1": 
          Zamowienia()
        elif ans=="2":
          Magazyn()
        elif ans=="3":
          Menu()
        elif ans !="":
          print("\n Not Valid Choice Try again") 

def ZalogujPracownik():
    os.system("cls")
    print("Podaj login: \n")
    login=input()
    print("Podaj haslo: \n")
    haslo=input()
    cursor.execute("exec LogowaniePracownika '"+login+"', '"+haslo+"'")
    for row in cursor:
        Pracownik(login,haslo)
    print("Blad! Sprobuj jeszcze raz! \n")

def Menu():
      os.system("cls")
      ans=True
      while ans:
        print("""
        1.Pracownik
        2.Klient
        3.Wyjscie
        """)
        ans=input("Witaj, wybierz uzytkownika? ") 
        if ans=="1": 
          ZalogujPracownik()
        elif ans=="2":
          Klient()
        elif ans=="3":
          print("\n Goodbye") 
          os._exit(1)
        else:
          print("Blad! Sprobuj jeszcze raz! \n")
