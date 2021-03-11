/* Compound is a Lending & Borrowing Platform */

/* See what people borrowed on Compound in 2020 */
SELECT * FROM compound.view_borrow
WHERE block_time >= '2020-01-01 00:00' AND block_time < '2021-01-01 00:00'
LIMIT 20