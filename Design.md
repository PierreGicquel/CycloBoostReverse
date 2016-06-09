# Architecture du projet

Le projet est divisé en plusieurs parties :
1. Une application qui sert d’interface avec l’utilisateur.
2. Une base de donnée permettant de stocker les données des utilisateurs.
3. La roue motorisée, muni de son contrôleur.

* L’application, développée sous Android, envoie via Bluetooth 4.0 à un arduino, les commandes permettant de modifier l’assistance du moteur et également de recevoir les informations telles que : la vitesse, le niveau de batterie ou encore le niveau d’assistance. L’application permet donc le contrôle du vélo, l’affichage des informations et met à disposition des utilisateurs un forum leur permettant de discuter de divers sujets concernant le vélo.

* Sur un serveur se trouve une base de données MySQL permettant de stocker les informations sur les comptes utilisateurs, mais aussi leur vitesse enregistrée et l’historique de leur trajets précédents.

* La roue possède en son sein un moteur capable de la faire tourner à une vitesse maximale d’environ 33 km/h. La roue est alimentée par une batterie Cycloboost de 36V (11.6Ah). Cette roue est reliée à un contrôleur “S06PW Torque Simulation controller” communiquant à une fréquence de 100 nano-secondes selon le protocole défini plus tard. Le contrôleur permet de modifier l’assistance en envoyant une commande au moteur et de récupérer les informations telles que la vitesse, le niveau de batterie ou encore le niveau d’assistance. Le contrôleur est lui aussi alimenté par la batterie et est relié à une carte Arduino. La carte Arduino a pour objectif de remplacer les périphériques tel que le potentiomètre et le LCD. Elle va recevoir et envoyer les commandes au contrôleur. Cette carte est connectée à un module Bluetooth qui permet de recevoir les commandes envoyées par l’application Android et de lui transmettre, toujours via bluetooth, les réponses provenant du contrôleur.

***

__Protocole__

_Envoyé par le contrôleur pour retourner les informations (en hexadécimal) :_

`0x41 0x(battery) 0x24 0x(wheeltime high) 0x(wheeltime low) 0x(error) 0x(checksum)`

_À envoyer au contrôleur (en hexadécimal) :_

`0x0C 0x(valeur niveau d’assistance) 0xF2 0xD6 0x29 0x(clé niveau d’assistance) 0x0E`

> Map <Clé niveau d’assistance,Valeur niveau d’assistance> =
[0,0x0D],[1,0x0C],[2,0x0F],[3,0x0E],[4,0x9],[5,0x08],[6,0x0B]

Exemple assistance 0 :
`0x0C 0x00 0xF2 0xD6 0x29 0x0D 0x0E `

_Code d’erreur renvoyé :_

* 0x00 no error;
* 0x01 error Throttle Signal Abnormality;
* 0x03 error Motor Hall Signal Abnormality;
* 0x04 error Torque Sensor Signal Abnormality;
* 0x05 error Speed Sensor Signal Abnormality (Suitable for torque system);
* 0x06 error Motor or Controller Short Circuit Abnormality;

---
__Conception__

Pour connaître le protocole du contrôleur, il nous a fallu faire du ‘reverse’ puisque aucune documentation n’a été trouvée sur internet. Nous avons donc branché un  analyseur logique entre le contrôleur et les périphériques qui nous étaient fournis, soit un potentiomètre pour modifier la vitesse et un écran LCD permettant d’afficher la vitesse et modifier le niveau d’assistance. Une fois le protocole décodé, nous avons remplacé les périphériques par l’Arduino.




--- 

**Évolution**

Pour faire évoluer le projet, il est possible de :
* Modifier l’application Android
* Modifier le code du programme utilisé par l’Arduino
* Rajouter du matériel et des composants électroniques sur la carte.

Le dernier point risque d’être plus compliqué puisque la carte qui a été réalisé avait pour but de miniaturiser le montage des différents composants. Il faudra sans doute construire une nouvelle carte de montage.
