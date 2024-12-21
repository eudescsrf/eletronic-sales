SELECT *
FROM eletronic_sales;

-- 1. Qual é a média de idade dos clientes que compraram um produto específico, como "Smartphone", e realizaram a compra com pagamento via "Cartão de Crédito"?

SELECT AVG(age) AS avg_age
FROM eletronic_sales
WHERE producttype = 'Smartphone' AND paymentmethod = 'Credit Card';
-- Resposta: 49.142

-- 2. Quais são os 5 produtos mais comprados (em termos de quantidade total de unidades) no mês de janeiro de 2024?

SELECT producttype, SUM(quantity) AS top_orders
FROM eletronic_sales
WHERE orderstatus = 'Completed' AND purchasedate BETWEEN '2024-01-01' AND '2024-01-31'
GROUP BY producttype
ORDER BY top_orders DESC
LIMIT 5;

-- 3. Quais clientes cancelaram seus pedidos mais de uma vez e qual foi a média de preço total das transações para esses clientes?

SELECT customerid, AVG(unitprice) AS avg_unitprice
FROM eletronic_sales
WHERE orderstatus = 'Cancelled'
GROUP BY customerid
HAVING COUNT(orderstatus) > 1;

-- 4. Quais são os 3 produtos mais vendidos (em termos de total de unidades) durante o mês de fevereiro de 2024?
SELECT producttype, SUM(quantity) AS most_saled
FROM eletronic_sales
WHERE orderstatus = 'Completed' AND purchasedate BETWEEN '2024-02-01' AND '2024-02-29'
GROUP BY producttype
ORDER BY most_saled DESC
LIMIT 3;

-- 5. Qual é a média de preço total por pedido para clientes do gênero 'Feminino' que compraram produtos do tipo 'Tablet'?

SELECT ROUND(AVG(totalprice),2) AS avg_total_price, COUNT(*) AS num_orders -- Para ver quantos pedidos foram feitos para que eu chegasse nessa resposta
FROM eletronic_sales
WHERE gender = 'Female' AND producttype = 'Tablet';

-- 6. Quais clientes realizaram compras durante os dias 10 a 15 de janeiro de 2024, mas não compraram no mês de fevereiro?

SELECT customerid
FROM eletronic_sales
WHERE orderstatus = 'Completed' AND purchasedate BETWEEN '2024-01-10' AND '2024-01-15'
	AND customerid NOT IN (
	SELECT customerid
	FROM eletronic_sales
	WHERE purchasedate BETWEEN '2024-02-01' AND '2024-02-29'
	);

-- 7. Quais são os produtos mais caros (em termos de UnitPrice) comprados por clientes do tipo 'Loyalty Member'?

SELECT producttype, ROUND(MAX(unitprice),2) AS price
FROM eletronic_sales
WHERE orderstatus = 'Completed' AND loyaltymember = 'Yes'
GROUP BY producttype
ORDER BY price DESC;

-- 8. Qual é o total de vendas (em valor de TotalPrice) para cada tipo de envio, agrupado pelo método de pagamento?

SELECT shippingtype, paymentmethod, SUM(TotalPrice) AS totalprice
FROM eletronic_sales
WHERE orderstatus = 'Completed'
GROUP BY paymentmethod, shippingtype
ORDER BY shippingtype, totalprice DESC; -- Evidencia qual tipo de pagamento foi mais lucrativo para cada categoria de envio

-- 9. Quais clientes têm um total de compras superior a 5000 no ano de 2024?

SELECT customerid, ROUND(SUM(totalprice),2) AS totalprice
FROM eletronic_sales
WHERE purchasedate BETWEEN '2024-01-01' AND '2024-12-31'
GROUP BY customerid
HAVING SUM(totalprice) > 5000 -- Essa parte da query o ChatGPT que me ajudou. Eu havia filtrado no 'WHERE'.
ORDER BY totalprice ASC;

-- 10. Qual é a quantidade média de unidades vendidas por pedido para cada produto?

SELECT producttype, ROUND(AVG(quantity),2) AS avg_quantity
FROM eletronic_sales
WHERE orderstatus = 'Completed'
GROUP BY producttype
ORDER BY avg_quantity DESC;

-- 11. Qual é o total de vendas (em valor de TotalPrice) para cada tipo de envio, agrupado pelo método de pagamento?

SELECT paymentmethod, shippingtype, ROUND(SUM(totalprice),2) AS totalsales
FROM eletronic_sales
WHERE orderstatus = 'Completed'
GROUP BY paymentmethod, shippingtype
ORDER BY totalsales DESC;

-- 12. Quantos pedidos foram cancelados no dia 01 de março de 2024?

SELECT COUNT(*) AS canceledorders
FROM eletronic_sales
WHERE orderstatus = 'Cancelled' AND purchasedate = '2024-03-01';

-- 13. Qual é a média de rating dos produtos vendidos em janeiro de 2024?

SELECT producttype, ROUND(AVG(rating),2) AS avg_rating 
FROM eletronic_sales
WHERE orderstatus = 'Completed' AND purchasedate BETWEEN '2024-01-01' AND '2024-01-31'
GROUP BY producttype
ORDER BY avg_rating DESC;

-- 14. Quais são os clientes que compraram mais de uma vez e que também compraram algum produto adicional (add-ons)?

SELECT customerid
FROM eletronic_sales
WHERE orderstatus = 'Completed' AND addonspurchased IS NOT NULL
GROUP BY customerid
HAVING COUNT(customerid) > 1;


-- 15. Liste os clientes (CustomerID) e crie uma coluna chamada Loyalty_Status que indique:
-- "New": Se o cliente comprou pela primeira vez em 2024.
-- "Returning": Se o cliente já havia feito uma compra antes de 2024.

SELECT customerid, 
	CASE WHEN 
	MIN(purchasedate) >= '2024-01-01' THEN 'New'
	ELSE 'Returning' END AS loyalty_status
FROM eletronic_sales
WHERE loyaltymember = 'Yes' AND orderstatus = 'Completed'
GROUP BY customerid;

-- 16. Crie uma consulta que retorne o tipo de produto (ProductType) e uma classificação do desempenho do rating médio em:
-- "Excellent": Rating médio maior ou igual a 4.5
-- "Good": Rating médio entre 3.0 e 4.4
-- "Poor": Rating médio menor que 3.0

SELECT producttype,
	CASE 
	WHEN AVG(rating) > 4.5 THEN 'Excellent'
	WHEN AVG(rating) BETWEEN 3.0 AND 4.4 THEN 'Good'
	ELSE 'Poor' END AS ratingtype
FROM eletronic_sales
WHERE orderstatus = 'Completed'
GROUP BY producttype;