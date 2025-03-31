-- Schéma de base de données pour Liv'In Paris

-- Table des utilisateurs (peuvent être clients et/ou cuisiniers)
CREATE TABLE Utilisateurs (
    IdUtilisateur INT PRIMARY KEY AUTO_INCREMENT,
    Prenom VARCHAR(50) NOT NULL,
    Nom VARCHAR(50) NOT NULL,
    Email VARCHAR(100) UNIQUE NOT NULL,
    MotDePasse VARCHAR(100) NOT NULL,
    Adresse VARCHAR(200) NOT NULL,
    Telephone VARCHAR(20) NOT NULL,
    EstCuisinier BOOLEAN DEFAULT FALSE,
    EstEntreprise BOOLEAN DEFAULT FALSE,
    NomEntreprise VARCHAR(100),
    DateInscription DATETIME DEFAULT CURRENT_TIMESTAMP
)ENGINE=InnoDB;

-- Table des plats
CREATE TABLE Plats (
    IdPlat INT PRIMARY KEY AUTO_INCREMENT,
    IdCuisinier INT NOT NULL,
    Nom VARCHAR(100) NOT NULL,
    Description TEXT,
    Categorie ENUM('Entrée', 'Plat principal', 'Dessert') NOT NULL,
    Prix DECIMAL(10, 2) NOT NULL,
    Portions INT NOT NULL,
    NationaliteCuisine VARCHAR(50),
    TypeRegime VARCHAR(50), -- Végétarien, Halal, etc.
    Ingredients TEXT,
    DatePreparation DATETIME NOT NULL,
    DatePeremption DATETIME NOT NULL,
    CheminPhoto VARCHAR(255),
    FOREIGN KEY (IdCuisinier) REFERENCES Utilisateurs(IdUtilisateur)
)ENGINE=InnoDB;

-- Table des commandes
CREATE TABLE Commandes (
    IdCommande INT PRIMARY KEY AUTO_INCREMENT,
    IdClient INT NOT NULL,
    DateCommande DATETIME DEFAULT CURRENT_TIMESTAMP,
    MontantTotal DECIMAL(10, 2) NOT NULL,
    Statut ENUM('En attente', 'Confirmée', 'Livrée', 'Annulée') DEFAULT 'En attente',
    FOREIGN KEY (IdClient) REFERENCES Utilisateurs(IdUtilisateur)
)ENGINE=InnoDB;

-- Table des éléments de commande
CREATE TABLE ElementsCommande (
    IdElementCommande INT PRIMARY KEY AUTO_INCREMENT,
    IdCommande INT NOT NULL,
    IdPlat INT NOT NULL,
    Quantite INT NOT NULL,
    PrixUnitaire DECIMAL(10, 2) NOT NULL,
    DateLivraison DATETIME NOT NULL,
    AdresseLivraison VARCHAR(200) NOT NULL,
    Statut ENUM('En attente', 'En préparation', 'Prête', 'Livrée') DEFAULT 'En attente',
    FOREIGN KEY (IdCommande) REFERENCES Commandes(IdCommande),
    FOREIGN KEY (IdPlat) REFERENCES Plats(IdPlat)
)ENGINE=InnoDB;

-- Table des livreurs
CREATE TABLE Livreurs (
    IdLivreur INT PRIMARY KEY AUTO_INCREMENT,
    Prenom VARCHAR(50) NOT NULL,
    Nom VARCHAR(50) NOT NULL,
    Telephone VARCHAR(20) NOT NULL,
    Statut ENUM('Disponible', 'En livraison', 'Indisponible') DEFAULT 'Disponible'
)ENGINE=InnoDB;


-- Table des trajets de livraison
CREATE TABLE TrajetsLivraison (
    IdTrajet INT PRIMARY KEY AUTO_INCREMENT,
    IdElementCommande INT NOT NULL,
    IdLivreur INT,
    IdStationDepart INT,
    IdStationArrivee INT,
    DescriptionTrajet TEXT,
    TempsEstime INT,
    FOREIGN KEY (IdElementCommande) REFERENCES ElementsCommande(IdElementCommande),
    FOREIGN KEY (IdLivreur) REFERENCES Livreurs(IdLivreur),
    FOREIGN KEY (IdStationDepart) REFERENCES Stations(IdStation),
    FOREIGN KEY (IdStationArrivee) REFERENCES Stations(IdStation)
)ENGINE=InnoDB;

-- Table des Stations
CREATE TABLE Stations (
    IdStation INT PRIMARY KEY AUTO_INCREMENT,
    Nom VARCHAR(100) NOT NULL,
    CoordonneesGPS VARCHAR(50),
    Ligne VARCHAR(10),
    Commune VARCHAR(50)
)ENGINE=InnoDB;

-- Table des avis
CREATE TABLE Avis (
    IdAvis INT PRIMARY KEY AUTO_INCREMENT,
    IdElementCommande INT NOT NULL,
    Note INT NOT NULL CHECK (Note BETWEEN 1 AND 5),
    Commentaire TEXT,
    DateAvis DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (IdElementCommande) REFERENCES ElementsCommande(IdElementCommande)
)ENGINE=InnoDB;

-- Insert into Utilisateurs Table
INSERT INTO Utilisateurs (Prenom, Nom, Email, MotDePasse, Adresse, Telephone, EstCuisinier, EstEntreprise, NomEntreprise)
VALUES
('Jean', 'Dupont', 'jean.dupont@email.com', 'password123', '10 rue de Paris, 75001 Paris', '0123456789', FALSE, FALSE, NULL),
('Marie', 'Durand', 'marie.durand@email.com', 'password456', '15 avenue de la République, 75011 Paris', '0987654321', TRUE, FALSE, NULL),
('Société B', 'SAS', 'contact@societe-b.com', 'password789', '25 boulevard Saint-Germain, 75005 Paris', '0112233445', FALSE, TRUE, 'Société B');
-- Insert into Plats Table
INSERT INTO Plats (IdCuisinier, Nom, Description, Categorie, Prix, Portions, NationaliteCuisine, TypeRegime, Ingredients, DatePreparation, DatePeremption, CheminPhoto)
VALUES
(2, 'Boeuf Bourguignon', 'Un classique de la cuisine française, avec du boeuf cuit lentement dans une sauce au vin rouge.', 'Plat principal', 19.99, 4, 'Française', 'Normal', 'Boeuf, Vin, Légumes, Herbes', '2025-03-30 18:00:00', '2025-04-05 18:00:00', 'photos/boeuf_bourguignon.jpg'),
(3, 'Salade César', 'Salade fraîche avec laitue, poulet grillé, croûtons et sauce César maison.', 'Entrée', 9.50, 2, 'Italienne', 'Végétarien', 'Laitue, Poulet, Croutons, Sauce César', '2025-03-29 12:00:00', '2025-03-31 12:00:00', 'photos/salade_cesar.jpg');

-- Insert into Commandes Table
INSERT INTO Commandes (IdClient, MontantTotal, Statut)
VALUES
(1, 39.99, 'Confirmée'),
(2, 25.50, 'En attente');

-- Insert into TrajetsLivraison Table
INSERT INTO TrajetsLivraison (IdElementCommande, IdStationDepart, IdStationArrivee, DescriptionTrajet, TempsEstime)
VALUES
(1, 101, 102, 'Départ de la station 101 à 10 rue de Paris, arrivée à la station 102 près de 15 avenue de la République', 30),
(2, 103, 104, 'Départ de la station 103 à 25 boulevard Saint-Germain, arrivée à la station 104 à 10 rue de Paris', 25);

-- Insert into ElementsCommande Table
INSERT INTO ElementsCommande (IdCommande, IdPlat, Quantite, PrixUnitaire, DateLivraison, AdresseLivraison, Statut)
VALUES
(1, 1, 2, 19.99, '2025-04-01 12:30:00', '10 rue de Paris, 75001 Paris', 'En préparation'),
(2, 2, 1, 9.50, '2025-04-02 18:00:00', '15 avenue de la République, 75011 Paris', 'En attente');

-- Insert into Avis Table
INSERT INTO Avis (IdElementCommande, Note, Commentaire, DateAvis)
VALUES
(1, 5, 'Plat délicieux et très bien préparé, je recommande !', '2025-03-31 14:00:00'),
(2, 4, 'Bon, mais la livraison a pris un peu de temps.', '2025-03-31 15:30:00');


