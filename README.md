# Présentation du projet :

### Contexte
LinkSphere est une application de messagerie permettant aux utilisateurs de communiquer les uns avec les autres. Grâce à une base de données SQL sous-jacente, l'application gère les utilisateurs et les messages de manière efficace.

### Fonctionnalités
Les fonctionnalités principales de l'application sont l'envoi de messages entre utilisateurs, la sympathisation entre utilisateurs, et le partage d'informations sur le mur de l'utilisateur.

## MCD

![pic/mcd.png](pic/mcd.png)

## MLD

Utilisateur (<ins>Login</ins>)<br>
Message (<ins>IdMessage</ins>, Message, DateM, <span style="color:blue">#IdMessageRéponse</span>, <span style="color:blue">#Destinataire</span>, <span style="color:blue">#Expediteur</span>)<br>
Sympathiser(<ins><span style="color:blue">#Login,#Ami</span></ins>)<br>
Session(<ins>idSession</ins>,<span style="color:blue">#Login</span>)<br>
IdGen(<ins>NewIDForMessage</ins>)<br>

## Road MAP

- [x] Envoyer des messages
- [x] Crée un compte
- [x] Symphatiser avec un utilisateur
- [ ] Test de conformité
- [ ] Mettre un mot de passe pour la connexion
- [ ] Faire une liste d'attente de sympathisation
- [ ] Gerer les identifiant pour les message par le SGBD
- [ ] Faire des groupes de discution