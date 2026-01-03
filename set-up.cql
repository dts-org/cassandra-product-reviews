CREATE KEYSPACE IF NOT EXISTS ecommerce_reviews
WITH replication = {
  'class': 'SimpleStrategy',
  'replication_factor': 2
};

USE ecommerce_reviews;

CREATE TABLE IF NOT EXISTS reviews_by_rating (
    rating INT,
    product_id TEXT,
    user_id TEXT,
    title TEXT,
    description TEXT,
    PRIMARY KEY ((rating), product_id, user_id)
);

-- Review 1 (rating 3)
INSERT INTO reviews_by_rating (rating, product_id, user_id, title, description)
VALUES (3, '2f8cb24b-8cd8-472f-b5e9-4c7a8f3d1e2a', 'ace38c71-bf82-4762-a7d3-123456789abc', 'Initial1', 'brzo se potrosila! Oc...');

-- Review 2 (rating 4)
INSERT INTO reviews_by_rating (rating, product_id, user_id, title, description)
VALUES (4, '7974cf92-84e2-40b5-99a1-8e7f6d5c4b3a', '2b01d3d0-1438-4d2b-be89-fedcba987654', 'Initial2', 'posluzila je, ali ni...');

-- Review 3 (rating 3)
INSERT INTO reviews_by_rating (rating, product_id, user_id, title, description)
VALUES (3, '2f8cb24b-8cd8-472f-b5e9-4c7a8f3d1e2a', '2b01d3d0-1438-4d2b-be89-fedcba987654', 'Initial3', 'stvorila mi je cak i ...');

-- Review 4 (rating 5)
INSERT INTO reviews_by_rating (rating, product_id, user_id, title, description)
VALUES (4, 'fe2cad5b-171e-477e-bb3a-9c8d7e6f5a4b', '2b01d3d0-1438-4d2b-be89-fedcba987654', 'Initial4', 'Bas sam zadovoljnaaa');

-- Review 5 (rating 5)
INSERT INTO reviews_by_rating (rating, product_id, user_id, title, description)
VALUES (5, 'fe2cad5b-171e-477e-bb3a-9c8d7e6f5a4b', '8b591aa4-b80d-4696-91e2-e5f6a7b8c9d0', 'Initial5', 'Zao mi je sto je out ...');

-- Review 6 (rating 2)
INSERT INTO reviews_by_rating (rating, product_id, user_id, title, description)
VALUES (2, '2f8cb24b-8cd8-472f-b5e9-4c7a8f3d1e2a', '8b591aa4-b80d-4696-91e2-e5f6a7b8c9d0', 'NE VRIJEDI OVIH NOVACA', 'razocaranaaa');

-- Review 7 (rating 5)
INSERT INTO reviews_by_rating (rating, product_id, user_id, title, description)
VALUES (5, '181cc843-0f53-44dc-b1e2-a3b4c5d6e7f8', '8b591aa4-b80d-4696-91e2-e5f6a7b8c9d0', 'Divnaaa', '<3 <3 <3');

-- Review 8 (rating 4)
INSERT INTO reviews_by_rating (rating, product_id, user_id, title, description)
VALUES (4, '181cc843-0f53-44dc-b1e2-a3b4c5d6e7f8', '2b01d3d0-1438-4d2b-be89-fedcba987654', 'SKUPA', 'ali je prekrasnaaa');
-- Daj mi sve recenzije sa ocjenom 5
SELECT * FROM reviews_by_rating WHERE rating = 5;

SELECT * FROM reviews_by_rating
WHERE rating = 3 AND product_id = 2f8cb24b-8cd8-472f-b5e9-4c7a8f3d1e2a;

