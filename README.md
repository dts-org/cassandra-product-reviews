# Cassandra Cluster Setup
 
This `docker-compose.yml` sets up a Cassandra database as a multi-node cluster with a single datacenter, consisting of 3 nodes, used for tracking user interactions (web activity data) in 
the **[web application](https://github.com/dts-org/stationery-store)**.
 
## Cluster topology
 
| Service | Port (host → container) |
|---|---|
| `cassandra-node1` | `9042 → 9042` |
| `cassandra-node2` | `9043 → 9042` |
| `cassandra-node3` | `9044 → 9042` |
 
- **Cluster name:** `WebAppCluster`
- **Datacenter:** `datacenter1`
- **CASSANDRA_SEEDS:** `cassandra-node1`
---
 
## `setup.cql`
 
### Keyspace
 
```sql
CREATE KEYSPACE IF NOT EXISTS ecommerce_reviews
WITH replication = {
  'class': 'SimpleStrategy',
  'replication_factor': 2
};
```
 
Keyspace `ecommerce_reviews`, replication factor `2`.
 
### Table — `reviews_by_rating`
 
Designed for the main query: *get all reviews for a given rating*.
 
```sql
CREATE TABLE IF NOT EXISTS reviews_by_rating (
    rating INT,
    product_id TEXT,
    user_id TEXT,
    title TEXT,
    description TEXT,
    PRIMARY KEY ((rating), product_id, user_id)
);
```
 
- **Partition key:** `rating`
- **Clustering columns:** `product_id`, `user_id`
### Data and queries in the file
 
The `INSERT` statements are sample data only, used for initial verification. 
 
In normal operation, this table is populated by the Kafka Connect Cassandra sink connector, which writes review events from the `reviews` Kafka topic.
 
---
 
## Kafka Connect — Cassandra sink connector
 
Defined in a **[separate repository](https://github.com/dts-org/kafka-streaming-platform/blob/main/instConn.http)**.
 
Relevant parameters, in relation to this Cassandra setup:
 
| Parameter | Value | Relevance |
|---|---|---|
| `topics` | `reviews` | Kafka topic the connector reads from |
| `cassandra.contact.points` | `cassandra-node1` | node used to connect to the cluster |
| `cassandra.port` | `9042` | Cassandra's native CQL port |
| `cassandra.local.datacenter` | `datacenter1` | must match the cluster's datacenter |
| `cassandra.keyspace` | `ecommerce_reviews` | must match the keyspace created in `setup.cql` |
| `cassandra.table` | `reviews_by_rating` | must match the table created in `setup.cql` |
| `cassandra.topic.key.field.mapping` | `rating=rating,product_id=product_id,user_id=user_id` | maps Kafka key fields to the table's partition/clustering columns |
| `cassandra.topic.value.field.mapping` | `rating=rating,product_id=product_id,user_id=user_id,title=title,description=description` | maps Kafka value fields to all table columns |
 
---
 
## Avro schemas (used for serialization on the producer side)
 
Defined in the web application repository: **[Avro schemas (review-schemas.ts)](https://github.com/dts-org/stationery-store/blob/main/lib/actions/kafka/schemas/review-schemas.ts)**.
 
> The Avro schemas use `productId`/`userId` (camelCase); the Cassandra table and the connector's field mappings use `product_id`/`user_id`. The `cassandra.topic.key.field.mapping` and `cassandra.topic.value.field.mapping` parameters (within the body of the
connector config) handle this mapping between the Avro field names and the Cassandra column names.
