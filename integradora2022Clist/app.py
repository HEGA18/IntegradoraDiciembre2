from flask import Flask, render_template, request, url_for, redirect, flash, session
from flask_mysqldb import MySQL, MySQLdb
#import mysql.connector
from os import path
#from notifypy import Notify
import MySQLdb.cursors 

app = Flask(__name__)


#conexion MySQL
app.config['MYSQL_HOST'] = 'db-integradora.cxjb8wcjkm4q.us-east-1.rds.amazonaws.com'
app.config['MYSQL_USER'] = 'admin'
app.config['MYSQL_PASSWORD'] = 'admin123'
app.config['MYSQL_DB'] = "b'clist'"
mysql = MySQL(app)

# Settings
app.secret_key = 'mysecretkey'

#VISTAS PUBLICO
@app.route('/')
def index():
    return render_template('index.html')

@app.route('/clinicas')
def clinicas():
    cur = mysql.connection.cursor()
    cur.execute('SELECT * FROM clinicas')
    datos = cur.fetchall()
    return render_template('clinicas.html', clinicas=datos)

@app.route('/serviciosYcostos')
def serviciosYcostos():
    cur = mysql.connection.cursor()
    cur.execute('SELECT * FROM servicio')
    datos = cur.fetchall()
    return render_template('serviciosYcostos.html', servicios=datos)

@app.route('/horarios')
def horarios():
    cur = mysql.connection.cursor()
    cur.execute('SELECT * FROM horario')
    datos = cur.fetchall()
    return render_template('horarios.html', horarios=datos)

@app.route('/RegistrarCita')
def RegistrarCita():
        cur = mysql.connection.cursor()
        cur.execute('SELECT id, telefono FROM citas where id=(SELECT MAX(id) FROM citas);')
        folio = cur.fetchall()
        print(folio)
        return render_template('registrarcita.html', folio=folio)
    

@app.route('/FuncionRegistrarCita', methods=['POST'])
def FuncionRegistrarCita():

    if request.method == 'POST':
        idClinica = request.form['IdClinica']
        idConsultorio = request.form['IdConsultorio']
        nomPaciente = request.form['NombrePaciente']
        telPaciente = request.form['TelefonoPaciente']
        fechaHora = request.form['fechayhora']
        tipoServicio = request.form['TipoServicio']
        idEmpleado = request.form['IdEmpleado']

        cur = mysql.connection.cursor()
        cur.execute('INSERT INTO citas (id_clinica, id_consultorio, nombre_paciente, telefono, fecha_y_hora, tipo_servicio, id_empleado) VALUES (%s, %s, %s, %s, %s, %s, %s)',(idClinica, idConsultorio, nomPaciente, telPaciente, fechaHora, tipoServicio, idEmpleado))
        mysql.connection.commit()
        flash('Cita agendada correctamente')
        return redirect(url_for('RegistrarCita'))


@app.route('/cancelarCita')
def cancelarCita():
    return render_template('cancelarCita.html')

@app.route('/FuncioncancelarCita', methods =['GET', 'POST'])
def FuncioncancelarCita():

    if request.method == 'POST' and 'IdCita' in request.form:
        IdCita = request.form['IdCita']
        #TelefonoPaciente = request.form['TelefonoPaciente']

        cur = mysql.connection.cursor(MySQLdb.cursors.DictCursor) 
        cur.execute("SELECT * FROM citas WHERE id = %s",[IdCita]) 
        cita = cur.fetchone()
        print(cita)
        if cita: 
            cur = mysql.connection.cursor()
            cur.execute("DELETE FROM citas WHERE id = %s",[IdCita])
            mysql.connection.commit()
            flash('Cita cancelada correctamente')
            return redirect(url_for('cancelarCita'))
        else:
            flash('La cita no existe')  
            
    elif request.method == 'POST': 
        flash('Llena los datos')
    return render_template('cancelarCita.html') 

@app.route('/login', methods =['GET', 'POST'])
def login(): 
    msg = '' 
    if request.method == 'POST' and 'usuario' in request.form and 'contrasenia' in request.form: 
        usuario = request.form['usuario'] 
        contrasenia = request.form['contrasenia'] 
        cursor = mysql.connection.cursor(MySQLdb.cursors.DictCursor) 
        cursor.execute('SELECT * FROM empleados WHERE usuario = % s AND contrasenia = % s',(usuario, contrasenia)) 
        account = cursor.fetchone() 
        print(account)
        if account: 
            session['loggedin'] = True
            session['id'] = account['id'] 
            session['usuario'] = account['usuario']
            session['contrasenia'] = account['contrasenia']
            session['id_rol']=account['id_rol']

            if session['id_rol'] == 1:
                    return render_template('home-admin.html')
            elif session['id_rol'] == 2:
                    return render_template('home-medicos.html')
            elif session['id_rol'] == 3:
                    return render_template('home-asistente.html')

            #return render_template('home-admin.html') 
        else: 
            flash('Usuario o contraseña incorrecta')
    return render_template('login.html')

@app.route('/salir')
def salir():
    session.pop('loggedin', None) 
    session.pop('id', None) 
    session.pop('username', None) 
    return redirect(url_for('login'))

#VISTAS ADMINISTRADORES
@app.route('/homeAdmin')
def home_admin():
    if 'loggedin' in session:
        return render_template('home-admin.html')
    return redirect(url_for('login')) 

@app.route('/Empleados')
def Empleados():
    if 'loggedin' in session:

        cur = mysql.connection.cursor()
        cur.execute('SELECT * FROM empleados')
        datos = cur.fetchall()
        return render_template('Empleados.html', empleados = datos)

    return redirect(url_for('login'))

@app.route('/FuncionEmpleados', methods = ['GET', 'POST'])
def FuncionEmpleados():
    if 'loggedin' in session:
        if request.method == 'POST':
            IdRol = request.form['IdRol']
            NombreEmpleado = request.form['NombreEmpleado']
            Tel = request.form['Tel']
            Usuario = request.form['Usuario']
            Contrasenia = request.form['Contrasenia']

            cur = mysql.connection.cursor()
            cur.execute('INSERT INTO empleados (id_rol, nombre_empleado, telefono, usuario, contrasenia) VALUES (%s, %s, %s, %s, %s)',(IdRol, NombreEmpleado, Tel, Usuario, Contrasenia))
            mysql.connection.commit()
            flash('Empleado registrado correctamente')
            return redirect(url_for('Empleados'))

    return redirect(url_for('login'))

@app.route('/EditarEmpleados/<id>', methods = ['GET', 'POST'])
def EditarEmpleados(id):
    if 'loggedin' in session:
        cur = mysql.connection.cursor()
        cur.execute('SELECT * FROM empleados WHERE id = %s', (id))
        datos = cur.fetchall()
        cur.close()
        return render_template('EditarEmpleado.html', empleado = datos[0])
    return redirect(url_for('login'))
    

@app.route('/ActualizarEmpleados/<id>', methods = ['POST'])
def ActualizarEmpleados(id):
    if 'loggedin' in session:
        if request.method == 'POST':

            IdRol = request.form['IdRol']
            NombreEmpleado = request.form['NombreEmpleado']
            Tel = request.form['Tel']
            Usuario = request.form['Usuario']
            Contrasenia = request.form['Contrasenia']


            cur = mysql.connection.cursor()
            cur.execute("""
            UPDATE empleados 
            SET id_rol = %s,
            nombre_empleado = %s,
            telefono = %s,
            usuario = %s,
            contrasenia = %s 
            WHERE id = %s
            """, (IdRol, NombreEmpleado, Tel, Usuario, Contrasenia, id))
            mysql.connection.commit()
            flash('Empleado actualizado correctamente')
            return redirect(url_for('Empleados'))
    
    return redirect(url_for('login'))

@app.route('/ConsultarCitasAdmin')
def ConsultarCitasAdmin():
    if 'loggedin' in session:
        cur = mysql.connection.cursor()
        cur.execute('SELECT * FROM citas')
        datos = cur.fetchall()
        return render_template('consultarCitasAdmin.html', citas=datos)
    return redirect(url_for('login'))


#VISTAS MEDICOS
@app.route('/home-medicos')
def home_medicos():
    if 'loggedin' in session:  
        return render_template('home-medicos.html')
    return redirect(url_for('login')) 

@app.route('/consultarCitasMedico')
def consultarCitasMedico():
    if 'loggedin' in session:

        cursor = mysql.connection.cursor(MySQLdb.cursors.DictCursor) 
        cursor.execute("SELECT * FROM citas WHERE id_empleado = %s",(session['id'], )) 
        datos = cursor.fetchall()   
        print(datos)
        return render_template('consultarCitasMedico.html', citas=datos)
    return redirect(url_for('login'))

@app.route('/EditarCitasMedico/<id>', methods = ['GET', 'POST'])
def EditarCitasMedico(id):
    if 'loggedin' in session:
        cur = mysql.connection.cursor()
        cur.execute("SELECT * FROM citas WHERE id = %s", [id])
        datos = cur.fetchall()
        cur.close()
        return render_template('EditarCitasMedico.html', cita = datos[0])
    return redirect(url_for('login'))

@app.route('/ActualizarCitasMedico/<id>', methods = ['POST'])
def ActualizarCitasMedico(id):
    if 'loggedin' in session:
        if request.method == 'POST':

            idClinica = request.form['IdClinica']
            idConsultorio = request.form['IdConsultorio']
            nomPaciente = request.form['NombrePaciente']
            telPaciente = request.form['TelefonoPaciente']
            fechaHora = request.form['fechayhora']
            tipoServicio = request.form['TipoServicio']
            idEmpleado = request.form['IdEmpleado']
            Estado = request.form['Estado']


            cur = mysql.connection.cursor()
            cur.execute("""
            UPDATE citas 
            SET id_clinica = %s,
            id_consultorio = %s,
            id_empleado = %s,
            fecha_y_hora = %s,
            nombre_paciente = %s,
            telefono = %s,
            tipo_servicio = %s,
            estado_servicio = %s
            WHERE id = %s
            """, (idClinica, idConsultorio, idEmpleado, fechaHora, nomPaciente, telPaciente, tipoServicio, Estado, id))
            mysql.connection.commit()
            flash('cita actualizada correctamente')
            return redirect(url_for('consultarCitasMedico'))
    return redirect(url_for('login'))

@app.route('/citasAceptadasMedico')
def citasAceptadasMedico():
    if 'loggedin' in session:  
        estado="aceptada"
        cursor = mysql.connection.cursor(MySQLdb.cursors.DictCursor) 
        cursor.execute('SELECT * FROM citas WHERE id_empleado = %s AND estado_servicio = %s',(session['id'], estado)) 
        datos = cursor.fetchall()   
        print(datos)
        return render_template('citasAceptadasMedico.html', citas = datos)
    return redirect(url_for('login')) 

@app.route('/citasRechazadasMedico')
def citasRechazadasMedico():
    if 'loggedin' in session: 
        estado="rechazada"
        cursor = mysql.connection.cursor(MySQLdb.cursors.DictCursor) 
        cursor.execute('SELECT * FROM citas WHERE id_empleado = %s AND estado_servicio = %s',(session['id'], estado)) 
        datos = cursor.fetchall()   
        print(datos) 
        return render_template('citasRechazadasMedico.html', citas = datos)
    return redirect(url_for('login')) 

#VISTAS ASISTENTES

@app.route('/homeAsistente')
def home_asistentes():
    if 'loggedin' in session:
        return render_template('home-asistente.html')
    return redirect(url_for('login')) 

@app.route('/CitasAsistente')
def CitasAsistente():
    if 'loggedin' in session:
        cur = mysql.connection.cursor()
        cur.execute('SELECT * FROM citas')
        datos = cur.fetchall()

        cur = mysql.connection.cursor()
        cur.execute('SELECT id, telefono FROM citas where id=(SELECT MAX(id) FROM citas);')
        folio = cur.fetchall()
        print(folio)

        return render_template('CitasAsistente.html', citas=datos, folio=folio)
    return redirect(url_for('login'))

@app.route('/FuncionCitasAsistente', methods=['POST'])
def FuncionCitasAsistente():
    if 'loggedin' in session:

        if request.method == 'POST':
            idClinica = request.form['IdClinica']
            idConsultorio = request.form['IdConsultorio']
            nomPaciente = request.form['NombrePaciente']
            telPaciente = request.form['TelefonoPaciente']
            fechaHora = request.form['fechayhora']
            tipoServicio = request.form['TipoServicio']
            idEmpleado = request.form['IdEmpleado']

            cur = mysql.connection.cursor()
            cur.execute('INSERT INTO citas (id_clinica, id_consultorio, nombre_paciente, telefono, fecha_y_hora, tipo_servicio, id_empleado) VALUES (%s, %s, %s, %s, %s, %s, %s)',(idClinica, idConsultorio, nomPaciente, telPaciente, fechaHora, tipoServicio, idEmpleado))
            mysql.connection.commit()
            flash('Cita agendada correctamente')
            return redirect(url_for('CitasAsistente'))
    return redirect(url_for('login'))

@app.route('/EditarCitasAsistente/<id>', methods = ['GET', 'POST'])
def EditarCitasAsistente(id):
        if 'loggedin' in session:
            cur = mysql.connection.cursor()
            cur.execute('SELECT * FROM citas WHERE id = %s', [id])
            datos = cur.fetchall()
            cur.close()
            return render_template('EditarCitasAsistente.html', cita = datos[0])
        return redirect(url_for('login'))

@app.route('/ActualizarCitasAsistente/<id>', methods = ['POST'])
def ActualizarCitasAsistente(id):
    if 'loggedin' in session:
        if request.method == 'POST':

            idClinica = request.form['IdClinica']
            idConsultorio = request.form['IdConsultorio']
            nomPaciente = request.form['NombrePaciente']
            telPaciente = request.form['TelefonoPaciente']
            fechaHora = request.form['fechayhora']
            tipoServicio = request.form['TipoServicio']
            idEmpleado = request.form['IdEmpleado']
            Estado = request.form['Estado']


            cur = mysql.connection.cursor()
            cur.execute("""
            UPDATE citas 
            SET id_clinica = %s,
            id_consultorio = %s,
            id_empleado = %s,
            fecha_y_hora = %s,
            nombre_paciente = %s,
            telefono = %s,
            tipo_servicio = %s,
            estado_servicio = %s
            WHERE id = %s
            """, (idClinica, idConsultorio, idEmpleado, fechaHora, nomPaciente, telPaciente, tipoServicio, Estado, id))
            mysql.connection.commit()
            flash('cita actualizada correctamente')
            return redirect(url_for('CitasAsistente'))
    return redirect(url_for('login'))

@app.route('/cancelarCitasAsistente')
def cancelarCitasAsistente():
    if 'loggedin' in session:
        return render_template('cancelarCitaAsistente.html')
    return redirect(url_for('login'))

@app.route('/FuncioncancelarCitasAsistente', methods = ['POST'])
def FuncioncancelarCitaAsistente():
    if 'loggedin' in session:

        if request.method == 'POST' and 'IdCita' in request.form:
            IdCita = request.form['IdCita']
            #TelefonoPaciente = request.form['TelefonoPaciente']

            cur = mysql.connection.cursor(MySQLdb.cursors.DictCursor) 
            cur.execute("SELECT * FROM citas WHERE id = %s",[IdCita]) 
            cita = cur.fetchone()
            print(cita)
            if cita: 
                cur = mysql.connection.cursor()
                cur.execute("DELETE FROM citas WHERE id = %s",[IdCita])
                mysql.connection.commit()
                flash('Cita cancelada correctamente')
                return redirect(url_for('cancelarCitasAsistente'))
            else:
                flash('La cita no existe')  
                
        elif request.method == 'POST': 
            flash('Llena los datos')
        return render_template('cancelarCitaAsistente.html') 
    return redirect(url_for('login'))



def pagina_no_encontrada(error):
    return render_template('404.html'), 404


if __name__ == '__main__':
    app.register_error_handler(404, pagina_no_encontrada)
    app.run(host='3.234.171.119', debug=True)