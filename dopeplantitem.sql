CREATE TABLE IF NOT EXISTS `dopeplants` (
  `owner` varchar(50) NOT NULL,
  `plant` longtext NOT NULL,
  `plantid` bigint(20) NOT NULL
);


INSERT INTO `items`(`name`, `label`, `weight`, `rare`, `can_remove`, `desc`) VALUES 
	('highgradefemaleseed', '(HG) Semilla femenina', 0, 0 ,1 , NULL),
	('lowgradefemaleseed', '(LG) Semilla femenina', 0, 0 ,1 , NULL),
	('highgrademaleseed', '(HG) Semilla masculina', 0, 0 ,1 , NULL),
	('lowgrademaleseed', '(LG) Semilla masculina', 0, 0 ,1 , NULL),
	('highgradefert', 'Fertilizante de alto grado', 1, 0 ,1 , NULL),
	('lowgradefert', 'Fertilizante de bajo grado', 1, 0 ,1 , NULL),
	('purifiedwater', 'Agua purificada', 1, 0 ,1 , NULL),
	('wateringcan', 'Regadera', 1, 0 ,1 , NULL),
	('plantpot', 'Maceta', 1, 0 ,1 , NULL),
	('trimmedweed', 'Cogollos', 0, 0 ,1 , NULL),
	('dopebag', 'Bolsa ziplock', 0, 0 ,1 , NULL),
	('bagofdope', 'Bolsa De Cogollos Cortados', 0, 0 ,1 , NULL),
	('drugscales', 'Gramera', 1, 0 ,1 , NULL);
