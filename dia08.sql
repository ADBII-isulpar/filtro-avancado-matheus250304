DROP DATABASE IF EXISTS empresa_db;

CREATE DATABASE empresa_db CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

USE empresa_db;


CREATE TABLE departamentos (
  id_departamento INT PRIMARY KEY AUTO_INCREMENT,
  nome_departamento VARCHAR(100) NOT NULL UNIQUE
);


CREATE TABLE projetos (
  id_projeto INT PRIMARY KEY AUTO_INCREMENT,
  nome_projeto VARCHAR(100) NOT NULL UNIQUE
);

CREATE TABLE funcionarios (
  id_funcionario INT PRIMARY KEY AUTO_INCREMENT,
  nome_funcionario VARCHAR(150) NOT NULL,
  salario DECIMAL(10, 2) NOT NULL,
  id_departamento INT,
  id_gerente INT,
  FOREIGN KEY (id_departamento) REFERENCES departamentos(id_departamento) ON DELETE SET NULL,
  FOREIGN KEY (id_gerente) REFERENCES funcionarios(id_funcionario) ON DELETE SET NULL
);

CREATE TABLE funcionarios_projetos (
  id_funcionario INT,
  id_projeto INT,
  PRIMARY KEY (id_funcionario, id_projeto),
  FOREIGN KEY (id_funcionario) REFERENCES funcionarios(id_funcionario) ON DELETE CASCADE,
  FOREIGN KEY (id_projeto) REFERENCES projetos(id_projeto) ON DELETE CASCADE
);



INSERT INTO departamentos (nome_departamento) VALUES
('Vendas'),
('TI'),
('Recursos Humanos'),
('Marketing');


INSERT INTO projetos (nome_projeto) VALUES
('Sistema de CRM'),
('Migração para Nuvem'),
('Campanha de Final de Ano'),
('Avaliação de Desempenho 360'),
('Projeto Alpha'),
('Website Institucional');


INSERT INTO funcionarios (nome_funcionario, salario, id_departamento, id_gerente) VALUES

('Carlos Alberto', 8500.00, 2, NULL),     
('Sofia Mendes', 9200.00, 1, NULL),       
('Mariana Costa', 7800.00, 4, NULL),       

('Ana Pereira', 6000.00, 2, 1),             
('Bruno Rocha', 4800.00, 2, 1),           

('Juliana Lima', 3200.00, 1, 2),            
('Marcos Souza', 2400.00, 1, 2),            
('Fernando Oliveira', 4100.00, 1, 2),        

('Cláudia Dias', 4500.00, 3, NULL),        

('Rafael Martins', 5100.00, 4, 3);          



INSERT INTO funcionarios_projetos (id_funcionario, id_projeto) VALUES
(4, 1), 
(4, 2), 
(5, 2),
(6, 1),
(8, 1), 
(8, 3), 
(9, 4), 
(10, 3), 
(1, 1), 
(1, 2); 


SELECT f.nome_funcionario, f.salario FROM funcionarios f JOIN departamentos d ON f.id_departamento = d.id_departamento WHERE d.nome_departamento = 'Vendas' AND f.salario > 2500;

SELECT f.nome_funcionario, d.nome_departamento, p.nome_projeto FROM funcionarios f JOIN departamentos d ON f.id_departamento = d.id_departamento JOIN funcionarios_projetos fp ON f.id_funcionario = fp.id_funcionario JOIN projetos p ON fp.id_projeto = p.id_projeto ORDER BY f.nome_funcionario;

SELECT d.nome_departamento, AVG(f.salario) AS salario_medio FROM funcionarios f JOIN departamentos d ON f.id_departamento = d.id_departamento GROUP BY d.nome_departamento;

SELECT d.nome_departamento, AVG(f.salario) AS salario_medio FROM funcionarios f JOIN departamentos d ON f.id_departamento = d.id_departamento GROUP BY d.nome_departamento HAVING AVG(f.salario) > 5000;

SELECT p.nome_projeto, COUNT(fp.id_funcionario) AS quantidade_funcionarios FROM projetos p LEFT JOIN funcionarios_projetos fp ON p.id_projeto = fp.id_projeto GROUP BY p.nome_projeto;

SELECT f.nome_funcionario, g.nome_funcionario AS nome_gerente, d.nome_departamento FROM funcionarios f LEFT JOIN funcionarios g ON f.id_gerente = g.id_funcionario JOIN departamentos d ON f.id_departamento = d.id_departamento;

SELECT f.nome_funcionario, p.nome_projeto FROM funcionarios f JOIN funcionarios_projetos fp ON f.id_funcionario = fp.id_funcionario JOIN projetos p ON fp.id_projeto = p.id_projeto WHERE f.id_funcionario IN (SELECT id_funcionario FROM funcionarios_projetos GROUP BY id_funcionario HAVING COUNT(id_projeto) > 1) ORDER BY f.nome_funcionario, p.nome_projeto;

SELECT p.nome_projeto FROM projetos p LEFT JOIN funcionarios_projetos fp ON p.id_projeto = fp.id_projeto WHERE fp.id_funcionario IS NULL;

SELECT d.nome_departamento, SUM(f.salario) AS soma_salarios FROM departamentos d JOIN funcionarios f ON d.id_departamento = f.id_departamento GROUP BY d.nome_departamento;

SELECT f.nome_funcionario, COUNT(fp.id_projeto) AS quantidade_projetos FROM funcionarios f LEFT JOIN funcionarios_projetos fp ON f.id_funcionario = fp.id_funcionario GROUP BY f.nome_funcionario ORDER BY f.nome_funcionario;
