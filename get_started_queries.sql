/* Initial query to view table */
SELECT *
FROM dex."trades"
LIMIT 5
;


/* DAI BOUGHT ON UNISWAP WITHIN 24 HOURS */
SELECT SUM(token_a_amount) AS dai_bought
FROM dex."trades"
WHERE block_time > now() - interval '24 hours'    /* time interval */
AND token_a_symbol = 'DAI'                        /* WHERE clause for filtering */
AND project = 'Uniswap'
;

/* ADD TIME DIMENSION TO DAI BOUGHT ON UNISWAP  */
/* Add date_trunc to SELECT clause */ 
/* Must add GROUP BY */

SELECT 
    date_trunc('hour', block_time) AS hour,
    SUM(token_a_amount) AS dai_bought
FROM dex."trades"
WHERE block_time > now() - interval '24 hours'    
AND token_a_symbol = 'DAI'                        
AND project = 'Uniswap'
GROUP BY 1;

/* WHAT TIME INTERVALS IS DATA AVAILABLE WITHIN 24 HRS */
/* Can GROUP BY without SUM or COUNT */
SELECT date_trunc('hour', block_time) AS hour FROM dex."trades"
WHERE block_time > now() - interval '24 hours'    
AND token_a_symbol = 'DAI'                        
AND project = 'Uniswap'
GROUP BY hour
ORDER BY hour DESC

/* WHERE ELSE (WHICH OTHER DEXES) WAS DAI BOUGHT - ASIDE FROM UNISWAP */
/* Expected Ans: 0x API 0x Native, 1inch, Balancer, Curve, Kyber, Sushiswap etc */
SELECT SUM(token_a_amount) AS dai_bought, project
FROM dex."trades"
WHERE block_time > now() - interval '24 hours'    
AND token_a_symbol = 'DAI'                        
GROUP BY project

/* ALL ASSETS (Including DAI) BOUGHT ON UNISWAP in last 24 HRS */

/* select relevant columns */
SELECT 
    block_time, 
    usd_amount, 
    project 
FROM dex."trades"
LIMIT 5

/* UNISWAP TOTAL USD TRADING VOLUME 24 HOURS */
SELECT 
    date_trunc('hour', block_time) AS hour, 
    SUM(usd_amount) AS usd_volume
FROM dex."trades" t
WHERE block_time >= now() - interval '24 hours'
AND project = 'Uniswap'
GROUP BY 1
;

/* CURVE TOTAL USD TRADING VOLUME 24 HOURS */
SELECT 
    date_trunc('hour', block_time) AS hour, 
    SUM(usd_amount) AS usd_volume
FROM dex."trades" t
WHERE block_time >= now() - interval '24 hours'
AND project = 'Curve'
GROUP BY 1
;

/* TOTAL USD TRADING VOLUME ACROSS PROJECTS - 24 HOURS */ 
/* NOTE: FROM dex."trades" t, then GROUP BY t.project */
SELECT 
    date_trunc('hour', block_time) AS hour, 
    SUM(usd_amount) AS usd_volume,
    project
FROM dex."trades" t
WHERE block_time >= now() - interval '24 hours'
GROUP BY t.block_time, t.project
;

