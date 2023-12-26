// 
class Timer {
  int duracion;
  int tiempoInicial;
  boolean enMarcha;

  Timer(int duracion) {
    this.duracion = duracion;
    enMarcha = false;
  }

  void start() {
    tiempoInicial = millis();
    enMarcha = true;
  }

  void stop() {
    enMarcha = false;
  }

  void restart() {
    tiempoInicial = millis();
    enMarcha = true;
  }

  int getSecondsRemaining() {
    if (enMarcha) {
      int tiempoTranscurrido = millis() - tiempoInicial;
      int tiempoRestante = duracion - tiempoTranscurrido;
      return tiempoRestante / 1000;
    } else {
      return 0;
    }
  }

  boolean isFinished() {
    if (enMarcha) {
      return millis() - tiempoInicial >= duracion;
    } else {
      return false;
    }
  }
}
