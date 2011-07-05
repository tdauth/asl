Ebenen (engl. Layers) dienen dazu, Regionen auf einer Karte auf unterschiedlichen Höhen begehbar zu machen.
Realisiert wird dies mittels der Struktur ALayer des Weltsystems der ASL.
Eine Ebene kann unterschiedliche Eingangs-, Ausgangs- und Grenzgebiete enthalten. Intern
werden dazu drei unterschiedliche Regionen gespeichert, die um Gebiete erweitert werden können,
da der Warcraft-3-Welteditor einem die Platzierung von Regionen nicht ermöglicht. Ebenen können
bei Schluchtübergängen sehr nützlich sein, da sie es einem, im Gegensatz zu Brücken mit einer festen
Verlauftextur, erlauben, Einheiten unter der Brücke und über die Brücke zu schicken.
Einheiten die eines der Eingangsgebiete betreten, erhalten automatisch die Höhe der Ebene und können
sich nur noch innerhalb der Grenzgebiete bewegen. Betreten sie ein Ausgangsgebiet, so wird ihre Höhe
zurückgesetzt und sie können sich wieder frei bewegen.
Am besten kann man die Möglichkeiten von Ebenenregionen bei einem Brückenübergang nutzen,
indem man die Ausgangsgebiete ein wenig näher am Rand der Grenzgebiete platziert und die
Eingangsgebiete ein wenig weiter weg.
A E               G                E A
| | |||||||||||||||||||||||||||||| | |

A = Ausgangsgebiet(e)
E = Eingangsgebiet(e)
G = Grenzgebiet(e)