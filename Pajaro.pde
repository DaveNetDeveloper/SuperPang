// Objeto que encapsula el comportamiento del objeto Pajaro
// 
class Pajaro {
  float x;
  float y;
  float velocidadX;
  float amplitudY;
  float frecuenciaY;
  float tiempo = 0;
  PImage imagen = loadImage("images/pajaro.png"); 
  PImage imagen2 = loadImage("images/boom.png"); 
  Pelota[] pelotas;
  Timer temporizador; 
  boolean disparar = false;
  boolean detenida = false;
  boolean colisionado = false; // Bandera para controlar si la burbuja ha colisionado
  //int numColisiones = 0; // Bandera para controlar si la burbuja ha colisionado
  int cambioFrames = 30;  // Número de frames durante los cuales se cambiará la imagen1 por la imagen2
  int frameActual = 0; // posicion inicial para el contador de frames
  
  // contructor que recibe las posiciones, amplitud, frecuencia y velocidad
  Pajaro(float x, float y, float amplitudY, float frecuenciaY, float velocidadX) {
    this.x = x;
    this.y = y;
    this.velocidadX = velocidadX;
    this.amplitudY = amplitudY;
    this.frecuenciaY = frecuenciaY;
    this.pelotas = new Pelota[1];
    this.temporizador = new Timer(int(random(2000, 4000))); // Duración del temporizador en milisegundos
    temporizador.start(); // Inicia el temporizador
  }

  void detener() { // función para detener el pajaro 
    detenida = true;
  }

  void reactivar() { // función para reactivar el pajaro
    detenida = false;
  }
  
  void actualizar() { // función para calcular y mover al pajaro
    if(detenida) return;
    
    // Actualiza la posición del pájaro
    x += velocidadX;

    // Calcula la posición vertical del pájaro con oscilaciones
    y = 100 + amplitudY * sin(frecuenciaY * tiempo);

    // Incrementa el parámetro de tiempo para las oscilaciones
    tiempo += 0.1;
    
    if(temporizador.isFinished()) {
        this.disparar = true;
      }
  }
 
  void dibujar() { // Función para dibujar el pajaro 
    
    if(!colisionado) { // si el pajaro no es colisionado por una bala
      image(imagen, x, y, 60, 60); //
    }
    else { // si el pajaro ha sido colisionado
      CrearBonificacion(x, y, true); //  
      bonificacionPajaroEnCurso = true;
      //println("bonificacionPajaroEnCurso: " + bonificacionPajaroEnCurso);
      
      if (frameActual < cambioFrames) { 
        // Cambiar la imagen del pajaro durante los frames indicados en 'cambioFrames'
        image(imagen2, x, y, 60, 60); //
        frameActual++;
      } else {
        // Volver al estado original de la imagen 
        frameActual = 0;
        colisionado = false;
      }
    }   
  }
  
  // función para disparar la  pelota
  void disparar() {
    float _velocidadX = 2; // Velocidad horizontal
    float _velocidadY = -5; // Velocidad vertical inicial (hacia arriba)
    float _gravedad = 0.2; // factor de fuerza de la gravedad

    pelotas[0] = new Pelota(x, y, _velocidadX, _velocidadY, _gravedad, 15);
  }
}
