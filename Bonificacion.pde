//
class Bonificacion {
  float x, y;
  float velocidadY; // Ajusta la velocidad de caída según sea necesario
  float tamaño;
  PImage bonificacionImg;
  boolean toDelete;
  Timer temporizador; // 
  boolean mostrarImagen;
  boolean detenida = false;
  
  Bonificacion(float x, float y, float tamaño, PImage pBonificacionImg) {
    this.x = x;
    this.y = y;
    this.velocidadY = 2;
    this.tamaño = tamaño;
    this.bonificacionImg = pBonificacionImg;
    temporizador = new Timer(10000); // Duración del temporizador en milisegundos (en este caso, 5 segundos)
    temporizador.start(); // Inicia el temporizador
    toDelete = false;
    mostrarImagen = true;
  }
  
  void mover() { // 
    if(detenida) return; // 
    
    if (y + this.tamaño/2 <= height) { // 
      y += this.velocidadY; 
    }
    
    // Si la bonificación llega al suelo la eliminaremos después de un tiempo (temporizador)
    if (y + this.tamaño/2 >= height) {
      //players[2].rewind(); // Reinicia la reproducción
      reproducirSonido(FX.Wrong); // reproducimos fx  
      
      //
      if(temporizador.isFinished()) {
        this.toDelete = true;
      }
    }
  }
  
  void mostrar() { //  
    if(temporizador.getSecondsRemaining() < 5 && !detenida) { 
      if (frameCount % 20 == 0) {  // según la frecuencia de parpadeo 
        mostrarImagen = !mostrarImagen;
      }
    }
    
    // Muestra la imagen si debe ser visible
    if (mostrarImagen) {
      image(this.bonificacionImg, x, y, tamaño, tamaño); //
    }
  }
  
  void detener() { // 
    detenida = true;
  }
  
  void reactivar() { // 
    detenida = false;
  }
}
