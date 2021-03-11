/* Compare Dune Analytics with Google BigQuery */
/* cross-check by querying Ethereum Block from both platforms */

/* Big Query - Ethereum Blocks  */
SELECT * FROM `bigquery-public-data.ethereum_blockchain.blocks` 
WHERE DATE(timestamp) = "2015-07-30" AND number < 11
LIMIT 10


/* Dune Analytics - Ethereum Blocks */
SELECT * FROM ethereum."blocks" 
LIMIT 10


/* sample query 1 */

select * from ethereum."transactions" order by block_time desc limit 15

/* sample query 2 */

/* NOTE: ETH has 18 decimals precision, divide number by 1e18 to get values in ETH not in Wei */
/* Summarizing total value ETH sent in the last 10 days (also change to 30 days) */

SELECT date_trunc('day', block_time) AS "Date", sum(value/1e18) AS "Value" 
FROM ethereum."transactions" 
WHERE block_time > now() - interval '10 days' 
GROUP BY 1 
ORDER BY 1

/* sample query 3 */
select * from prices."usd" order by price desc limit 5


/* Easy query */
SELECT * FROM aave."LendingPool_call_flashLoan" 
LIMIT 5


/* Select first five rows of Contract Addresses column in AAVE Lending */

SELECT contract_address FROM aave."LendingPool_call_flashLoan" 
LIMIT 5

/* Count total number of contract addresses in AAVE Lending pool */

SELECT COUNT(contract_address) FROM aave."LendingPool_call_flashLoan" 
LIMIT 5

/* ERC Query */
SELECT * FROM erc20."ERC20_evt_Transfer"
LIMIT 5



/* More Advanced Queries */
/* Join data from multiple tables */

with txs as (select block_time, value, price
from ethereum."transactions" e
join prices."layer1_usd" p
on p.minute = date_trunc('minute', e.block_time)
where block_time > now() - interval '10 days'
and symbol = 'ETH'
)

select date_trunc('day', block_time) as "Date", sum(value * price / 1e18) as "Value" from txs
group by 1 order by 1

/* ETH sent by VB past in USD per month */
WITH txs AS (SELECT block_time, value, price 
FROM ethereum."transactions" e 
JOIN prices.'layer1_usd' p 
ON p.minute = date_trunc('minute', e.block_time)
AND ("from"='\x1Db3439a222C519ab44bb1144fC28167b4Fa6EE6'
    OR "from"='\xAb5801a7D398351b8bE11C439e05C5B3259aeC9B')
AND p.symbol = 'ETH'  
)


with txs as (select block_time, value, price
from ethereum."transactions" e
join prices."layer1_usd" p
on p.minute = date_trunc('minute', e.block_time)
and ("from"='\x1Db3439a222C519ab44bb1144fC28167b4Fa6EE6'
     or "from"='\xAb5801a7D398351b8bE11C439e05C5B3259aeC9B')
and p.symbol = 'ETH'
)

select date_trunc('month', block_time) as "Date", sum(value * price / 1e18) as "Value" from txs
group by 1 order by 1


/* EatTheBlocks tutorial */
/* Maker DAI Event Transfer */


SELECT date_trunc('day', evt_block_time), src, dst, (wad / 10 ^ 18) * p.price AS amount FROM makermcd."DAI_evt_Transfer"
LEFT JOIN prices.usd p ON p.minute = date_trunc('minute', evt_block_time)
WHERE src != '\x0000000000000000000000000000000000000000' AND dst != '\x0000000000000000000000000000000000000000' AND evt_block_time > now() - interval '7 days' AND p.symbol = 'DAI'
ORDER BY wad DESC
LIMIT 10

/* Visit Abstractions file in Dune Analytics GitHub */
/* Uniswap Trading Volume  */

SELECT
date_trunc('day', block_time),
SUM(usd_value_of_eth)
FROM (
SELECT block_time, usd_value_of_eth FROM uniswap."view_eth_purchase"
UNION ALL
SELECT block_time, usd_value_of_eth FROM uniswap."view_token_purchase"
) AS eth_usd
WHERE block_time > now() - interval '7 days'
GROUP BY 1
ORDER BY 1

