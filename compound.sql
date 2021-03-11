/* Compound is a Lending & Borrowing Platform */

/* See what people borrowed on Compound in 2020 */
/* TIME RANGE */
SELECT * FROM compound.view_borrow
WHERE block_time >= '2020-01-01 00:00' AND block_time < '2021-01-01 00:00'
LIMIT 20


/* Count Number of Token Symbol */
SELECT COUNT(DISTINCT(token_symbol)) FROM compound.view_borrow
WHERE block_time >= '2020-01-01 00:00' AND block_time < '2021-01-01 00:00'
LIMIT 5

/* How much people borrowed Tokens on Compound in 2020 */
SELECT token_symbol, total_borrows_usd FROM compound.view_borrow
WHERE block_time >= '2020-01-01 00:00' AND block_time < '2021-01-01 00:00'
LIMIT 20

/* How to do GROUP BY */

/* Compound View Accrue Interest */

/* Filter by token: DAI - LIMIT can vary */
SELECT * FROM compound."view_accrue_interest"
WHERE block_time >= '2020-01-01 00:00' 
AND block_time < '2021-01-01 00:00' 
AND token_symbol = 'DAI'
LIMIT 18

/* Comp Unique Borrowers Per Day */
