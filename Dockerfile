# Se establece la imagen y su versión
#FROM ubuntu:20.04
FROM ubuntu:22.04


# El siguiente comando establece una configuración para evitar que el sistema pida confirmaciones mientras instala programas.
# Esto hace que las instalaciones sean automáticas, sin necesidad de intervención del usuario.
ENV DEBIAN_FRONTEND=noninteractive

# apt-get update e install  actualiza la lista de paquetes y luego instala tres programas clave:
# - Apache: un servidor web que nos permite alojar y mostrar páginas web.
# - MySQL: un sistema de bases de datos para almacenar y gestionar información.
# - Supervisord: un programa que ayuda a controlar y mantener funcionando otros programas dentro del contenedor (en este caso, Apache y MySQL).
RUN apt-get update && \
    apt-get install -y apache2 && \
    apt-get install -y mysql-server && \
    apt-get install -y supervisor && \
    apt-get clean


# Copia el archivo de configuración: supervisord.conf, este va a contener las instrucciones para que supervisord sepa como controlar y gestionar
COPY supervisord.conf /etc/supervisor/conf.d/supervisord.conf

# Crea una página web sencilla en formato HTML con un saludo básico.
# Esta página se mostrará al visitar el servidor Apache.
RUN echo '<html><body><h1>¡Hola desde Apache en Docker :)!</h1></body></html>' > /var/www/html/index.html

# Aquí se le dice al docker que el contenedor necesita tener acceso a los puertos 80 para el servidor Apache y 3306 para MySQL
EXPOSE 80 3306

# Cuando el contenedor se ejecute, este comando hará que supervisord se inicie autómaticamente, donde supervisord se encarga de mantener Apache y MySQL en funcionamiento dentro del contenedor.
CMD ["/usr/bin/supervisord"]
