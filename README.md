# Sistema de seguridad domótica automatizado

Este es un proyecto desarrollado en Verilog y C++ con el cual se busca implementar y controlar 
un sistema de seguridad domótica automatizado, el cual consiste en asegurar un recinto colocando 
sensores de ultra sonido en los puntos de acceso al mismo y notificar al usuario en caso de una 
irrupción, dándole así la opción de poder tomar acción de tal forma que remotamente el usuario
 pueda cerrar el recinto. Asimismo, se pueden definir diferentes niveles de emergencia en los 
cuales el sistema puede tomar acción por sí mismo, por ejemplo la activación del sensor de un punto 
de acceso específico asociado a un estado de emergencia que no representa un nivel muy alto de 
peligro solo activará la alarma, mientras que si otro sensor asociado a un nivel de emergencia más
 alto puede llegar a cerrar por completo el lugar, todo esto mostrado en una pantalla LCD en tiempo 
real notificando el estado en el que se encuentra el sistema. 