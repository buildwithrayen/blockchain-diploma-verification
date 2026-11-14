# 🎓 CertifChain – Système de Certification & Vérification de Diplômes sur Blockchain

## 📌 Présentation du Projet

CertifChain est une application décentralisée (dApp) permettant l'émission, la vérification et la révocation de diplômes académiques à l'aide de la blockchain Ethereum et du stockage décentralisé IPFS.

Le système vise à lutter contre la falsification des diplômes et à faciliter leur vérification par les recruteurs.

### Fonctionnalités principales

1. **Émission des diplômes :** L'université sélectionne un diplôme au format PDF. Le système calcule son empreinte numérique SHA-256, stocke le fichier sur IPFS via Pinata et enregistre les informations nécessaires sur la blockchain.

2. **Vérification des diplômes :** Le recruteur sélectionne un fichier PDF. Le système calcule son empreinte SHA-256 et la compare aux données enregistrées sur la blockchain. La vérification utilise un appel en lecture seule, sans frais de gaz à payer par le recruteur.

3. **Révocation des diplômes :** L'administrateur autorisé peut invalider un diplôme précédemment émis en cas de fraude ou d'erreur.

---






## 🏗️ Architecture du Projet

```mermaid
%%{init: {"flowchart": {"nodeSpacing": 65, "rankSpacing": 100, "curve": "basis", "htmlLabels": true}}}%%

flowchart TD

    subgraph Client_Side ["1. Client Browser"]
        A["User / Admin"] -->|Selects PDF| B["Local JS: Web Crypto API"]
        B -->|Computes locally| C["SHA-256 Hash"]
    end

    subgraph Storage ["2. Decentralized Storage"]
        B -->|Uploads PDF file| D["Pinata / IPFS"]
        D -->|Returns| E["IPFS CID"]
    end

    subgraph Blockchain ["3. Ethereum Sepolia Blockchain"]
        A -->|Signs Tx with MetaMask| F["DiplomaVerification Smart Contract"]
        C -->|pdfHash| F
        E -->|ipfsCID| F
        F -->|Stored in| G[("Mapping: bytes32 => Diploma")]
    end

    subgraph Verification ["4. Recruiter Verification - 0 Gas"]
        R["Recruiter"] -->|Drops PDF| B2["Local JS SHA-256"]
        B2 -->|Calls view function| F
        F -->|Returns Status: Valid / Revoked / Fake| R
    end
```







## 🛠️ Technologies Utilisées

Solidity – Développement du smart contract

Ethereum Sepolia Testnet – Réseau blockchain de test

Remix IDE – Compilation, tests unitaires et déploiement du smart contract

MetaMask – Portefeuille Web3 pour la signature des transactions

Ethers.js v6 – Interaction entre le frontend et la blockchain

HTML5, Tailwind CSS, JavaScript (ES6) – Interface utilisateur moderne

Pinata API – Gestion de l'hébergement IPFS

IPFS – Stockage décentralisé et immuable des fichiers PDF

SHA-256 – Empreinte cryptographique calculée localement par le navigateur


## 📋 Informations du Smart Contract

Fichier : DiplomaVerification.sol

Réseau : Ethereum Sepolia Testnet

Chain ID : 11155111

Adresse du contrat déployé : 0x21F35365a6547Db760910D4d788f2Dd511a7753A

Fonctions principales

issueDiploma(bytes32 _pdfHash, string _studentName, string _major, string _ipfsCID) : Enregistre le diplôme sur la blockchain (réservé à l'administrateur).

verifyDiploma(bytes32 _pdfHash) : Vérifie l'existence et la validité d'un diplôme (fonction publique gratuite, 0 gas).

revokeDiploma(bytes32 _pdfHash) : Révoque un diplôme précédemment enregistré (réservé à l'administrateur).


## 🧪 Tests du Smart Contract

Les tests unitaires automatisés ont été exécutés avec succès dans Remix IDE.

Scénarios de test validés :

Vérification de l'attribution correcte de l'adresse administrateur (universityAdmin).

Enregistrement conforme et persistance des métadonnées d'un diplôme.

Vérification avec succès d'un diplôme authentique (exists = true, isValid = true).

Détection et rejet immédiat d'un diplôme falsifié ou altéré (exists = false).

Blocage strict lors d'une tentative d'enregistrement d'un diplôme en double.

Révocation effective d'un diplôme et validation de son statut révoqué (isValid = false).
