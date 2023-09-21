-------------------------------Banco Sql Lite
----------------------1.1 Campeonato
--criação da tabelas
CREATE TABLE times (
	time_id INTEGER PRIMARY KEY,
	time_nome TEXT
);

CREATE TABLE jogos (
    jogo_id INTEGER PRIMARY KEY NOT NULL,
    mandante_time INTEGER NOT NULL,
    visitante_time INTEGER NOT NULL,
    mandante_gols INTEGER NOT NULL,
    visitante_gols INTEGER NOT NULL
);


--Faz os insert na tabela times
INSERT INTO times ( time_id,time_nome)
VALUES 
(10, 'Financeiro'),
(20, 'Marketing'),
(30, 'Logística'),
(40, 'TI'),
(50, 'Dados');

--Faz os insert na tabela jogos
INSERT INTO jogos (jogo_id, mandante_time, visitante_time, mandante_gols, visitante_gols) VALUES
(1, 30, 20, 1, 0),
(2, 10, 20, 1, 2),
(3, 20, 50, 2, 2),
(4, 10, 30, 1, 0),
(5, 30, 50, 0, 1);

--query da questao
WITH Pontos AS (
    --Pontos como mandante
    SELECT 
        mandante_time AS time_id,
        CASE 
            WHEN mandante_gols > visitante_gols THEN 3
            WHEN mandante_gols = visitante_gols THEN 1
            ELSE 0
        END AS pontos
    FROM jogos

    UNION ALL

    --Pontos como visitante
    SELECT 
        visitante_time AS time_id,
        CASE 
            WHEN visitante_gols > mandante_gols THEN 3
            WHEN visitante_gols = mandante_gols THEN 1
            ELSE 0
        END AS pontos
    FROM jogos
)

SELECT 
    t.time_id,
    t.time_nome,
    COALESCE(SUM(p.pontos), 0) AS num_pontos
FROM times t
LEFT JOIN Pontos p ON t.time_id = p.time_id
GROUP BY t.time_id, t.time_nome
ORDER BY num_pontos DESC, t.time_id;

----------------------1.2 Comissões
--criando tabela
CREATE TABLE comissoes (
    comprador VARCHAR NOT NULL,
    vendedor VARCHAR NOT NULL,
    dataPgto DATE NOT NULL,
    valor FLOAT NOT NULL
);

--Fazendo insert na tabela comissoes
INSERT INTO comissoes (comprador, vendedor, dataPgto, valor) VALUES
('Leonardo', 'Bruno', '2000-01-01', 200.00),
('Leonardo', 'Matheus', '2003-09-27', 1024.00),
('Leonardo', 'Lucas', '2006-06-26', 512.00),
('Marcos', 'Lucas', '2020-12-17', 100.00),
('Marcos', 'Lucas', '2002-03-22', 10.00),
('Cinthia', 'Lucas', '2021-03-20', 500.00),
('Mateus', 'Bruno', '2007-06-02', 400.00),
('Mateus', 'Bruno', '2006-06-26', 400.00),
('Mateus', 'Bruno', '2015-06-26', 200.00);

--query da questao
SELECT DISTINCT v1.vendedor
FROM comissoes v1
LEFT JOIN comissoes v2 ON v1.vendedor = v2.vendedor AND v1.dataPgto < v2.dataPgto
LEFT JOIN comissoes v3 ON v1.vendedor = v3.vendedor AND v2.dataPgto < v3.dataPgto
WHERE (v1.valor + COALESCE(v2.valor, 0) + COALESCE(v3.valor, 0)) >= 1024
ORDER BY v1.vendedor;

----------------------1.3 Organização Empresarial
--criação da tabela
CREATE TABLE colaboradores (
    id INTEGER PRIMARY KEY,
    nome VARCHAR NOT NULL,
    salario INTEGER NOT NULL,
    lider_id INTEGER REFERENCES colaboradores(id)
);

--Fazendo o INSERT 
INSERT INTO colaboradores (id, nome, salario, lider_id) VALUES
(40, 'Helen', 1500, 50),
(50, 'Bruno', 3000, 10),
(10, 'Leonardo', 4500, 20),
(20, 'Marcos', 10000, NULL),
(70, 'Mateus', 1500, 10),
(60, 'Cinthia', 2000, 70),
(30, 'Wilian', 1501, 50);

--query da questao
SELECT 
    c1.id AS "colaborador",
    CASE 
        WHEN c2.salario >= 2 * c1.salario THEN c2.id
        WHEN c3.salario >= 2 * c1.salario THEN c3.id
        WHEN c4.salario >= 2 * c1.salario THEN c4.id
       ELSE NULL
    END AS "Líder"
FROM colaboradores c1
LEFT JOIN colaboradores c2 ON c1.lider_id = c2.id
LEFT JOIN colaboradores c3 ON c2.lider_id = c3.id
LEFT JOIN colaboradores c4 ON c3.lider_id = c4.id
ORDER BY c1.id;
































