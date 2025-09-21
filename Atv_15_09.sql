--Parte A: Fundamentos e consultas básicas
--1. DDL/DML


DDL (Data Definition Language): Refere-se aos comandos usados para definir e gerenciar a estrutura dos objetos do banco de dados, como tabelas. 

Exemplo: CREATE TABLE Clientes (...)


Uso: Utilizado para construir ou modificar a arquitetura do banco de dados. 


DML (Data Manipulation Language): São os comandos para manipular os dados armazenados dentro das tabelas, como inserir, atualizar ou consultar registros. 

Exemplo: INSERT INTO Clientes (nome, email) VALUES ('Ana Souza', 'ana@email.com')


Uso: Empregado nas operações rotineiras de um sistema que interage com o banco de dados. 

--2. WHERE vs HAVING

A cláusula 

WHERE é utilizada para filtrar linhas antes de qualquer operação de agrupamento (GROUP BY). Por outro lado, a cláusula 

HAVING é usada para filtrar os resultados depois que os dados já foram agrupados e as funções de agregação (como SUM() ou COUNT()) foram calculadas. 

Exemplo em que o uso de HAVING é obrigatório:
Para listar apenas os clientes cujo faturamento total ultrapasse 1500, é necessário primeiro agregar as vendas por cliente e, em seguida, aplicar o filtro sobre o resultado agregado.



SELECT
    c.nome,
    SUM(ip.quantidade * ip.preco_unitario) AS faturamento_total
FROM Clientes AS c
JOIN Pedidos AS p ON c.id = p.cliente_id
JOIN ItensPedido AS ip ON p.id = ip.pedido_id
GROUP BY c.id, c.nome
HAVING SUM(ip.quantidade * ip.preco_unitario) > 1500;

--3. Consulta com filtro e ordenação




-- Esta consulta é um exemplo teórico, pois a tabela Funcionarios não foi criada.
SELECT nome, salario
FROM Funcionarios
WHERE salario > 3000
ORDER BY salario DESC;
 

--4. Agregação e expressão



SELECT
    pr.nome AS produto,
    SUM(ip.quantidade * ip.preco_unitario) AS faturamento_total
FROM ItensPedido AS ip
JOIN Produtos AS pr ON ip.produto_id = pr.id
GROUP BY pr.nome
ORDER BY faturamento_total DESC;

--5. GROUP BY com HAVING

SELECT
    pr.nome AS produto,
    SUM(ip.quantidade * ip.preco_unitario) AS faturamento_total
FROM ItensPedido AS ip
JOIN Produtos AS pr ON ip.produto_id = pr.id
GROUP BY pr.nome
HAVING SUM(ip.quantidade * ip.preco_unitario) > 5000;
 
--6. INNER JOIN - básico

SELECT
    p.id AS pedido_id,
    p.data_pedido,
    c.nome AS nome_cliente
FROM Pedidos AS p
INNER JOIN Clientes AS c ON p.cliente_id = c.id;


--7. INNER JOIN - múltiplas tabelas

SELECT
    p.id AS pedido_id,
    p.data_pedido,
    c.nome AS nome_cliente,
    pr.nome AS nome_produto,
    ip.quantidade,
    (ip.quantidade * ip.preco_unitario) AS valor_total_linha
FROM Pedidos AS p
INNER JOIN Clientes AS c ON p.cliente_id = c.id
INNER JOIN ItensPedido AS ip ON p.id = ip.pedido_id
INNER JOIN Produtos AS pr ON ip.produto_id = pr.id;
 

--8. LEFT JOIN - encontrar não correspondentes

SELECT
    c.nome,
    p.id AS pedido_id
FROM Clientes AS c
LEFT JOIN Pedidos AS p ON c.id = p.cliente_id;


--9. RIGHT JOIN - conceito e equivalência

SELECT
    pr.nome,
    ip.pedido_id
FROM ItensPedido AS ip
RIGHT JOIN Produtos AS pr ON ip.produto_id = pr.id;
Consulta equivalente com LEFT JOIN:

SELECT
    pr.nome,
    ip.pedido_id
FROM Produtos AS pr
LEFT JOIN ItensPedido AS ip ON pr.id = ip.produto_id;

--10. FULL OUTER JOIN - comportamento e emulação

SELECT c.nome, p.id AS pedido_id
FROM Clientes AS c
LEFT JOIN Pedidos AS p ON c.id = p.cliente_id
UNION
SELECT c.nome, p.id AS pedido_id
FROM Clientes AS c
RIGHT JOIN Pedidos AS p ON c.id = p.cliente_id;

