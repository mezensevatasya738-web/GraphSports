
USE master;
GO

IF DB_ID(N'GraphSports') IS NOT NULL
BEGIN
    ALTER DATABASE GraphSports SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
    DROP DATABASE GraphSports;
END
GO

CREATE DATABASE GraphSports;
GO

USE GraphSports;
GO

CREATE TABLE dbo.Athlete (
    athlete_id   INT IDENTITY PRIMARY KEY,
    last_name    NVARCHAR(50) NOT NULL,
    first_name   NVARCHAR(50) NOT NULL,
    middle_name  NVARCHAR(50) NULL,
    birth_date   DATE NULL,
    gender       NCHAR(1) NULL,
    group_number NVARCHAR(10) NULL
) AS NODE;
GO

CREATE TABLE dbo.Coach (
    coach_id   INT IDENTITY PRIMARY KEY,
    last_name  NVARCHAR(50) NOT NULL,
    first_name NVARCHAR(50) NOT NULL,
    experience INT NULL      -- лет опыта
) AS NODE;
GO

CREATE TABLE dbo.Sport (
    sport_id    INT IDENTITY PRIMARY KEY,
    sport_name  NVARCHAR(100) NOT NULL UNIQUE,
    description NVARCHAR(MAX) NULL
) AS NODE;
GO

CREATE TABLE dbo.Competition (
    competition_id INT IDENTITY PRIMARY KEY,
    name           NVARCHAR(100) NOT NULL,
    date           DATE NOT NULL,
    location       NVARCHAR(100) NULL
) AS NODE;
GO

CREATE TABLE dbo.TRAINS AS EDGE;
GO

CREATE TABLE dbo.SPECIALIZES_IN AS EDGE;
GO

CREATE TABLE dbo.PARTICIPATES_IN (
    place INT NULL   -- 1,2,3...
) AS EDGE;
GO

CREATE TABLE dbo.COACHES_SPORT AS EDGE;
GO

CREATE TABLE dbo.FOLLOWS AS EDGE;
GO

ALTER TABLE dbo.TRAINS ADD CONSTRAINT EC_TRAINS CONNECTION (Athlete TO Coach);
ALTER TABLE dbo.SPECIALIZES_IN ADD CONSTRAINT EC_SPECIALIZES_IN CONNECTION (Athlete TO Sport);
ALTER TABLE dbo.PARTICIPATES_IN ADD CONSTRAINT EC_PARTICIPATES_IN CONNECTION (Athlete TO Competition);
ALTER TABLE dbo.COACHES_SPORT ADD CONSTRAINT EC_COACHES_SPORT CONNECTION (Coach TO Sport);
ALTER TABLE dbo.FOLLOWS ADD CONSTRAINT EC_FOLLOWS CONNECTION (Athlete TO Athlete);
GO

SELECT name, is_node, is_edge FROM sys.tables ORDER BY name;
GO
------------------------------------------------------------------------------------------------------------------------






USE GraphSports;
GO

INSERT INTO dbo.Athlete (last_name, first_name, middle_name, birth_date, gender, group_number) VALUES
(N'Бондарев', N'Виктор', N'Александрович', '2002-01-01', N'М', N'Г1'),
(N'Васильев', N'Артём', N'Александрович', '2002-02-01', N'М', N'Г1'),
(N'Жук', N'Данила', N'Петрович', '2002-03-01', N'М', N'Г2'),
(N'Захаров', N'Даниил', N'Евгеньевич', '2002-04-01', N'М', N'Г2'),
(N'Кривой', N'Артём', N'Владимирович', '2002-05-01', N'М', N'Г3'),
(N'Левданский', N'Виталий', N'Юрьевич', '2002-07-01', N'М', N'Г1'),
(N'Маркович', N'Иван', N'Евгеньевич', '2002-09-01', N'М', N'Г1'),
(N'Абрамова', N'Екатерина', N'Игоревна', '2001-05-12', N'Ж', N'Г6'),
(N'Борисов', N'Максим', N'Андреевич', '2000-08-23', N'М', N'Г6'),
(N'Ветров', N'Алексей', N'Сергеевич', '2002-11-03', N'М', N'Г7'),
(N'Лебедева', N'Анастасия', N'Дмитриевна', '2001-11-05', N'Ж', N'Г15'),
(N'Николаев', N'Станислав', N'Владимирович', '2000-10-18', N'М', N'Г16');

INSERT INTO dbo.Coach (last_name, first_name, experience) VALUES
(N'Петрович', N'Сергей', 15),
(N'Сергеевна', N'Ольга', 10),
(N'Игоревич', N'Александр', 8),
(N'Владимировна', N'Елена', 20),
(N'Николаевич', N'Дмитрий', 5),
(N'Кузнецова', N'Мария', 12),
(N'Соколов', N'Игорь', 7),
(N'Волкова', N'Татьяна', 9),
(N'Лебедев', N'Павел', 14),
(N'Михайловна', N'Наталья', 18);
GO

INSERT INTO dbo.Sport (sport_name, description) VALUES
(N'Легкая атлетика', N'Бег, прыжки, метания'),
(N'Тяжелая атлетика', NULL),
(N'Футбол', N'Командная игра с мячом'),
(N'Баскетбол', NULL),
(N'Волейбол', NULL),
(N'Теннис', NULL),
(N'Плавание', NULL),
(N'Бокс', NULL),
(N'Гимнастика', NULL),
(N'Дзюдо', NULL);


INSERT INTO dbo.Competition (name, date, location) VALUES
(N'Зимний кубок по легкой атлетике', '2025-01-15', N'Минск'),
(N'Богатырская сила (Тяж. атлетика)', '2025-01-20', N'Гомель'),
(N'Межвузовский турнир по футболу', '2025-02-01', N'Минск'),
(N'Кубок вызова по футболу', '2022-01-18', N'Гомель'),
(N'Мемориал пловца', '2022-01-20', N'Брест'),
(N'Открытый корт (Теннис)', '2025-03-01', N'Минск'),
(N'Заплыв "Золотая рыбка"', '2025-03-05', N'Брест'),
(N'Ринг надежды (Бокс)', '2025-03-15', N'Гродно'),
(N'Гибкий путь (Дзюдо)', '2025-04-10', N'Минск'),
(N'Сентябрьский турнир', '2022-09-16', N'Полоцк');

INSERT INTO dbo.SPECIALIZES_IN ($from_id, $to_id)
SELECT a.$node_id, s.$node_id
FROM dbo.Athlete a, dbo.Sport s
WHERE (a.last_name = N'Бондарев' AND s.sport_name = N'Легкая атлетика')
   OR (a.last_name = N'Васильев' AND s.sport_name = N'Футбол')
   OR (a.last_name = N'Жук' AND s.sport_name = N'Плавание')
   OR (a.last_name = N'Захаров' AND s.sport_name = N'Бокс')
   OR (a.last_name = N'Кривой' AND s.sport_name = N'Дзюдо')
   OR (a.last_name = N'Левданский' AND s.sport_name = N'Легкая атлетика')
   OR (a.last_name = N'Маркович' AND s.sport_name = N'Теннис')
   OR (a.last_name = N'Абрамова' AND s.sport_name = N'Легкая атлетика')
   OR (a.last_name = N'Борисов' AND s.sport_name = N'Футбол')
   OR (a.last_name = N'Ветров' AND s.sport_name = N'Плавание')
   OR (a.last_name = N'Лебедева' AND s.sport_name = N'Гимнастика')
   OR (a.last_name = N'Николаев' AND s.sport_name = N'Легкая атлетика');
GO

--Тренируется у тренера (TRAINS)
INSERT INTO dbo.TRAINS ($from_id, $to_id)
SELECT a.$node_id, c.$node_id
FROM dbo.Athlete a, dbo.Coach c
WHERE (a.last_name = N'Бондарев' AND c.last_name = N'Петрович')
   OR (a.last_name = N'Васильев' AND c.last_name = N'Петрович')
   OR (a.last_name = N'Жук' AND c.last_name = N'Сергеевна')
   OR (a.last_name = N'Захаров' AND c.last_name = N'Игоревич')
   OR (a.last_name = N'Кривой' AND c.last_name = N'Владимировна')
   OR (a.last_name = N'Левданский' AND c.last_name = N'Петрович')
   OR (a.last_name = N'Маркович' AND c.last_name = N'Кузнецова')
   OR (a.last_name = N'Абрамова' AND c.last_name = N'Владимировна')
   OR (a.last_name = N'Борисов' AND c.last_name = N'Николаевич')
   OR (a.last_name = N'Ветров' AND c.last_name = N'Сергеевна')
   OR (a.last_name = N'Лебедева' AND c.last_name = N'Кузнецова')
   OR (a.last_name = N'Николаев' AND c.last_name = N'Петрович');
GO

--  Тренер ведёт вид спорта (COACHES_SPORT)
INSERT INTO dbo.COACHES_SPORT ($from_id, $to_id)
SELECT c.$node_id, s.$node_id
FROM dbo.Coach c, dbo.Sport s
WHERE (c.last_name = N'Петрович' AND s.sport_name = N'Легкая атлетика')
   OR (c.last_name = N'Сергеевна' AND s.sport_name = N'Футбол')
   OR (c.last_name = N'Сергеевна' AND s.sport_name = N'Плавание')
   OR (c.last_name = N'Игоревич' AND s.sport_name = N'Бокс')
   OR (c.last_name = N'Владимировна' AND s.sport_name = N'Плавание')
   OR (c.last_name = N'Владимировна' AND s.sport_name = N'Гимнастика')
   OR (c.last_name = N'Николаевич' AND s.sport_name = N'Дзюдо')
   OR (c.last_name = N'Кузнецова' AND s.sport_name = N'Гимнастика')
   OR (c.last_name = N'Соколов' AND s.sport_name = N'Футбол')
   OR (c.last_name = N'Лебедев' AND s.sport_name = N'Теннис')
   OR (c.last_name = N'Михайловна' AND s.sport_name = N'Теннис');
GO

-- Участие в соревнованиях (PARTICIPATES_IN) с местом
INSERT INTO dbo.PARTICIPATES_IN ($from_id, $to_id, place)
SELECT a.$node_id, comp.$node_id,
    CASE 
        WHEN a.last_name = N'Бондарев' AND comp.name = N'Зимний кубок по легкой атлетике' THEN 1
        WHEN a.last_name = N'Васильев' AND comp.name = N'Межвузовский турнир по футболу' THEN 2
        WHEN a.last_name = N'Жук' AND comp.name = N'Мемориал пловца' THEN 1
        WHEN a.last_name = N'Захаров' AND comp.name = N'Ринг надежды (Бокс)' THEN 3
        WHEN a.last_name = N'Кривой' AND comp.name = N'Гибкий путь (Дзюдо)' THEN 1
        WHEN a.last_name = N'Абрамова' AND comp.name = N'Зимний кубок по легкой атлетике' THEN 3
        WHEN a.last_name = N'Борисов' AND comp.name = N'Кубок вызова по футболу' THEN 1
        WHEN a.last_name = N'Ветров' AND comp.name = N'Мемориал пловца' THEN 2
        WHEN a.last_name = N'Лебедева' AND comp.name = N'Сентябрьский турнир' THEN 1
        WHEN a.last_name = N'Николаев' AND comp.name = N'Зимний кубок по легкой атлетике' THEN 4
    END
FROM dbo.Athlete a, dbo.Competition comp
WHERE (a.last_name = N'Бондарев' AND comp.name = N'Зимний кубок по легкой атлетике')
   OR (a.last_name = N'Васильев' AND comp.name = N'Межвузовский турнир по футболу')
   OR (a.last_name = N'Жук' AND comp.name = N'Мемориал пловца')
   OR (a.last_name = N'Захаров' AND comp.name = N'Ринг надежды (Бокс)')
   OR (a.last_name = N'Кривой' AND comp.name = N'Гибкий путь (Дзюдо)')
   OR (a.last_name = N'Абрамова' AND comp.name = N'Зимний кубок по легкой атлетике')
   OR (a.last_name = N'Борисов' AND comp.name = N'Кубок вызова по футболу')
   OR (a.last_name = N'Ветров' AND comp.name = N'Мемориал пловца')
   OR (a.last_name = N'Лебедева' AND comp.name = N'Сентябрьский турнир')
   OR (a.last_name = N'Николаев' AND comp.name = N'Зимний кубок по легкой атлетике');
GO

-- Подписки (FOLLOWS) – социальный граф между спортсменами
INSERT INTO dbo.FOLLOWS ($from_id, $to_id)
SELECT a1.$node_id, a2.$node_id
FROM dbo.Athlete a1, dbo.Athlete a2
WHERE (a1.last_name = N'Бондарев' AND a2.last_name = N'Васильев')
   OR (a1.last_name = N'Бондарев' AND a2.last_name = N'Жук')
   OR (a1.last_name = N'Васильев' AND a2.last_name = N'Борисов')
   OR (a1.last_name = N'Жук' AND a2.last_name = N'Ветров')
   OR (a1.last_name = N'Кривой' AND a2.last_name = N'Левданский')
   OR (a1.last_name = N'Абрамова' AND a2.last_name = N'Лебедева')
   OR (a1.last_name = N'Борисов' AND a2.last_name = N'Бондарев')
   OR (a1.last_name = N'Ветров' AND a2.last_name = N'Николаев')
   OR (a1.last_name = N'Лебедева' AND a2.last_name = N'Абрамова')
   OR (a1.last_name = N'Николаев' AND a2.last_name = N'Бондарев');
GO

-- Проверка количества
SELECT 'Athlete' AS NodeType, COUNT(*) AS Cnt FROM Athlete
UNION ALL SELECT 'Coach', COUNT(*) FROM Coach
UNION ALL SELECT 'Sport', COUNT(*) FROM Sport
UNION ALL SELECT 'Competition', COUNT(*) FROM Competition;

----------------------------------------------------------------------------------------------------------------




USE GraphSports;
GO


-- (Кто подписан на спортсмена 'Виктор Бондарев')
SELECT a2.first_name, a2.last_name AS Follower
FROM dbo.Athlete a1, dbo.FOLLOWS f, dbo.Athlete a2
WHERE MATCH(a1<-(f)-a2)
  AND a1.last_name = N'Бондарев' 
  AND a1.first_name = N'Виктор';

-- (Какие виды спорта ведет тренер 'Сергей Петрович')
SELECT s.sport_name
FROM dbo.Coach c, dbo.COACHES_SPORT cs, dbo.Sport s
WHERE MATCH(c-(cs)->s)
  AND c.last_name = N'Петрович' 
  AND c.first_name = N'Сергей';

-- (Соревнования  Анастасии Лебедевой и места)
SELECT comp.name AS Competition, part.place
FROM dbo.Athlete a, dbo.PARTICIPATES_IN part, dbo.Competition comp
WHERE MATCH(a-(part)->comp)
  AND a.last_name = N'Лебедева' 
  AND a.first_name = N'Анастасия';

-- (Какие спортсмены и с какими специализациями тренируются у Ольги Сергеевны)
SELECT a.first_name, a.last_name, s.sport_name
FROM dbo.Athlete a, dbo.TRAINS t, dbo.Coach c, dbo.SPECIALIZES_IN spec, dbo.Sport s
WHERE MATCH(a-(t)->c AND a-(spec)->s)
  AND c.last_name = N'Сергеевна' 
  AND c.first_name = N'Ольга';

-- (Тренеры, которые ведут вид спорта Максиа Борисова)
SELECT DISTINCT c.first_name, c.last_name
FROM dbo.Athlete a, dbo.SPECIALIZES_IN spec, dbo.Sport s, dbo.COACHES_SPORT cs, dbo.Coach c
WHERE MATCH(a-(spec)->s AND s<-(cs)-c)
  AND a.last_name = N'Борисов' 
  AND a.first_name = N'Максим';

GO


SELECT 
    STRING_AGG(
        CAST(a2.first_name + N' ' + a2.last_name AS NVARCHAR(MAX)),
        N' -> '
    ) WITHIN GROUP (GRAPH PATH) AS FriendshipPath
FROM dbo.Athlete a1,
     dbo.FOLLOWS FOR PATH AS f,
     dbo.Athlete FOR PATH AS a2
WHERE MATCH(SHORTEST_PATH(a1(-(f)->a2)+))
  AND a1.last_name = N'Бондарев'
  AND a1.first_name = N'Виктор';

GO

SELECT 
    STRING_AGG(
        CAST(s.sport_name AS NVARCHAR(MAX)),
        N' -> '
    ) WITHIN GROUP (GRAPH PATH) AS sport_path
FROM dbo.Coach c_start,
     dbo.COACHES_SPORT FOR PATH AS cs,
     dbo.Sport FOR PATH AS s,
     dbo.SPECIALIZES_IN FOR PATH AS spec,
     dbo.Athlete FOR PATH AS a,
     dbo.PARTICIPATES_IN FOR PATH AS part,
     dbo.Competition FOR PATH AS comp
WHERE MATCH(
    SHORTEST_PATH(
        c_start(-(cs)->s<-(spec)-a-(part)->comp){1,4}
    )
)
  AND c_start.last_name = N'Петрович'
  AND c_start.first_name = N'Сергей';

GO