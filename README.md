# Jezyki skryptowe w grach wideo

## [Kółko i krzyżyk](https://github.com/mgarbula/skrypty/tree/main/proj1)
:white_check_mark: 3.0 działa w trybie gry turowej [commit](https://github.com/mgarbula/skrypty/commit/aecb60fbb97e2c74b2190a3966fa88d20f1dd9ac)

:x: 4.0 pozwala na zapis i odtwarzanie przerwanej gry (save game)

:x: 5.0 pozwala na grę z komputerem

## [Sklep](https://github.com/mgarbula/skrypty/tree/main/proj2)
:white_check_mark: 3.0 Aplikacja ma podstawowe endpointy w NodeJS (np. Express) do produktów i kategorii [commit](https://github.com/mgarbula/skrypty/commit/32a53d61f762a9b4aed4b6e8522376e2bf2951a1)

:white_check_mark: 3.5 Dane zapisywanie są w bazie danych po stronie NodeJS [commit](https://github.com/mgarbula/skrypty/commit/c96eecb3d7fd678c1dbfd69480007d0198354d0f)

:x: 4.0 Axios wykorzystany do wywołań

:x: 4.5 Opcja koszyka i płatności działa na React Hook

:x: 5.0 Konfiguracja CORS po stronie NodeJS + konfiguracja po stronie ReactJS

## [Crawler w Ruby](https://github.com/mgarbula/skrypty/tree/main/proj3)
:white_check_mark: 3.0 Należy pobrać podstawowe dane o produktach (tytuł, cena), dowolna kategoria [commit](https://github.com/mgarbula/skrypty/commit/d727e4c131cb10ef95a13ee931daa53298bf8924)

:white_check_mark: 3.5 Należy pobrać podstawowe dane o produktach wg słów kluczowych [commit](https://github.com/mgarbula/skrypty/commit/d727e4c131cb10ef95a13ee931daa53298bf8924)

:x: 4.0 Należy rozszerzyć dane o produktach o dane szczegółowe widoczne tylko na podstronie o produkcie

:x: 4.5 Należy zapisać linki do produktów

:x: 5.0 Dane należy zapisać w bazie danych np. SQLite via Sequel

## [Saper w Lua](https://github.com/mgarbula/skrypty/tree/main/proj4)
:white_check_mark: 3.0 Postawowa wersja dekstopowa z obsługą na klawiaturze - minimum 4 rodzaje klocków [commit](https://github.com/mgarbula/skrypty/commit/9d26584a68ee9217620686e6fd332e86cbb89638)

:x: 3.5 Zapis i odczyt gier

:x: 4.0 Dodanie efektów dźwiękowych przy akcjach

:x: 4.5 Dodanie animacji przy zbijaniu klocków

:x: 5.0 Wersja na iOS lub Android z implementacją touch zamiast klawiatury

## [Chatbot w Python](https://github.com/mgarbula/skrypty/tree/main/proj5)
:white_check_mark: 3.0 Czatbot z wytrenowaną umiejętnością (poprzez prompt) obsługi co najmniej 3 sposobów sformułowania intencji (powitanie, menu, zamówienie). [commit](https://github.com/mgarbula/skrypty/commit/c34a6beefb87843c60d38bc7d613c324d8626854)

:white_check_mark: 3.5 Informacje o godzinach otwarcia i pozycjach w menu powinny być pobierane z pliku konfiguracyjnego (JSON/YAML) i przekazywane do modelu. [commit](https://github.com/mgarbula/skrypty/commit/1dc515a7dc99afcf0e6cb2e7f0475617b31d327f)

:x: 4.0 Czatbot musi przetworzyć zamówienie i potwierdzić zakupione posiłki, a także obsłużyć dodatkowe prośby (np. alergie, modyfikacje dań). Dane o alergiach, składzie, daniach ładowy z api aplikacji webowej napisanej we Flasku (https://flask.palletsprojects.com/en/stable/).

:x: 4.5 Czatbot musi potwierdzić, kiedy posiłek będzie dostępny do odbioru w restauracji (estymacja czasu na podstawie zamówienia).

:x: 5.0 Czatbot powinien zapytać o adres dostawy i potwierdzić go, zamiast opcji odbioru osobistego, weryfikując kompletność danych adresowych. Zapisać zamówienie przez wywołanie api aplikacji we Flasku. We Flasku zapisujemy dane zamówienia w bazie.