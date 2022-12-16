
create database clist;
USE clist;

CREATE TABLE clinicas(
id INT AUTO_INCREMENT NOT NULL,
ubicacion VARCHAR(50) NOT NULL,
nombre varchar(50) NOT NULL,
PRIMARY KEY (id)
);

CREATE TABLE consultorios(
id INT AUTO_INCREMENT NOT NULL,
id_horario INT NOT NULL,
id_empleado INT NOT NULL,
id_clinica INT NOT NULL,
PRIMARY KEY (id),
FOREIGN KEY (id_horario) REFERENCES horario(id),
FOREIGN KEY (id_empleado) REFERENCES empleados(id),
FOREIGN KEY (id_clinica) REFERENCES clinicas(id)
);


CREATE TABLE servicio(
id INT AUTO_INCREMENT NOT NULL,
tipo_servicio VARCHAR(50) NOT NULL,
costo DECIMAL NOT NULL,
duracion varchar(10) NOT NULL,
PRIMARY KEY (id)
);

CREATE TABLE horario(
id INT AUTO_INCREMENT NOT NULL,
tipo_horario VARCHAR(50) NOT NULL,
hora_inicio VARCHAR(10) NOT NULL,
hora_fin VARCHAR(10) NOT NULL,
PRIMARY KEY (id)
);

CREATE TABLE citas(
id INT AUTO_INCREMENT NOT NULL,
id_clinica INT NOT NULL,
id_consultorio INT NOT NULL,
id_empleado INT NOT NULL,
fecha_y_hora DATETIME,
nombre_paciente varchar(30),
telefono varchar(20) NOT NULL,
tipo_servicio varchar(20),
estado_servicio varchar(20),
PRIMARY KEY (id),
FOREIGN KEY (id_clinica) REFERENCES clinicas(id),
FOREIGN KEY (id_consultorio) REFERENCES consultorios(id),
FOREIGN KEY (id_empleado) REFERENCES empleados(id)
);

CREATE TABLE empleados(
id INT AUTO_INCREMENT NOT NULL,
id_rol INT NOT NULL,
nombre_empleado VARCHAR(30) NOT NULL,
telefono VARCHAR(20) NOT NULL,
usuario VARCHAR(20) NOT NULL,
contrasenia VARCHAR(50) NOT NULL,
PRIMARY KEY (id),
FOREIGN KEY (id_rol) REFERENCES roles(id)
);

CREATE TABLE roles(
id INT AUTO_INCREMENT NOT NULL,
tipo_rol VARCHAR(15) NOT NULL,
PRIMARY KEY (id)
);

#Clinicas:

INSERT INTO `clist`.`clinicas` (`ubicacion`, `nombre`) VALUES ('MANUEL AVILA CAMACHO NO. 46', 'Clinica2');

INSERT INTO `clist`.`clinicas` (`ubicacion`, `nombre`) VALUES ('TLAXCALA 1701, JALISCO, 83447', 'Clinica3');

#Consultorios:

INSERT INTO `clist`.`consultorios` (`id_horario`, `id_empleado`, `id_clinica`) VALUES ('2', '6', '2');

#Empleados:

INSERT INTO `clist`.`empleados` (`id_rol`, `nombre_empleado`, `telefono`, `usuario`, `contrasenia`) VALUES ('1', 'Noel Jimenez', '7779090878', 'noeljimenez', 'noeljimenez');

INSERT INTO `clist`.`empleados` (`id_rol`, `nombre_empleado`, `telefono`, `usuario`, `contrasenia`) VALUES ('2', 'Esperanza Vela', '7771188990', 'esperanzavela', 'esperanzavela');

INSERT INTO `clist`.`empleados` (`id_rol`, `nombre_empleado`, `telefono`, `usuario`, `contrasenia`) VALUES ('3', 'Leandro Chaves', '7772233890', 'leandrochaves', 'leandrochaves');









