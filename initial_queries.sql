
## sample query 1

select * from ethereum."transactions" order by block_time desc limit 15

## sample query 2
# NOTE: ETH has 18 decimals precision, divide number by 1e18 to get values in ETH not in Wei
# Summarizing total value ETH sent in the last 10 days (also change to 30 days)

SELECT date_trunc('day', block_time) AS "Date", sum(value/1e18) AS "Value" 
FROM ethereum."transactions" 
WHERE block_time > now() - interval '10 days' 
GROUP BY 1 
ORDER BY 1

## sample query 3
select * from prices."usd" order by price desc limit 5
