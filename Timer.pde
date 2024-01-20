// Objeto Temporizador
// 
class Timer {
  int duracion;
  int tiempoInicial;
  boolean enMarcha;

  // contructor que recibe la duración en segundos
  Timer(int duracion) { 
    this.duracion = duracion;
    enMarcha = false;
  }

  void start() { // inicia el temporizador
    tiempoInicial = millis(); 
    enMarcha = true; // flag a true
  }

  void stop() {// para el temporizador
    enMarcha = false; // flag a flase
  }

  void restart() { // reinicia el temporizador 
    tiempoInicial = millis();
    enMarcha = true;
  }

  // funcion que calcula y devuelve los segundos restantes del temporizador
  int getSecondsRemaining() {
    if (enMarcha) {
      int tiempoTranscurrido = millis() - tiempoInicial;
      int tiempoRestante = duracion - tiempoTranscurrido;
      return tiempoRestante / 1000;
    } else {
      return 0; // si el temporizador no esta iniciado devolvemos 0
    }
  }

  // funcion que devuelve el estado del temporizador
  boolean isFinished() {
    if (enMarcha) {
      return millis() - tiempoInicial >= duracion; // Devolvemos si el tiempo transcurrido es mayor a  la duración del temporizador
    } else  return false;
  }
}
