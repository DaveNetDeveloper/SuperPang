// 
class Pelota {
  float x, y; // Posición del enemigo
  float velocidadX; // Velocidad horizontal del enemigo
  float velocidadY; // Velocidad vertical del enemigo
  float gravedad; // Gravedad simulada
  PImage imagen = loadImage("images/pelota.png"); // 
  float tamaño; // 
  boolean detenida = false; // 

  // 
  Pelota(float x, float y, float velocidadX, float velocidadY, float gravedad, float tamaño) {
    this.x = x;
    this.y = y;
    this.velocidadX = velocidadX;
    this.velocidadY = velocidadY;
    this.gravedad = gravedad;
    this.tamaño = tamaño;
  }

  void actualizar() {
    if(detenida) return;
    
    // Actualiza la posición del enemigo
    x += velocidadX;
    y += velocidadY;
  
    // Aplica gravedad
    velocidadY += gravedad;
  
    // Verifica si el enemigo alcanza el suelo
    if (y > height) {
      // Reinicia la posición y velocidad vertical
      y = height;
      velocidadY *= -0.8;  // Rebote con pérdida de energía
    }
  }
  
  void dibujar() { // Dibuja el enemigo 
    image(imagen, x, y, tamaño, tamaño);
  }
  
  boolean colisionConJugador() { //
    float distancia = dist(x, y, jugadorX, height - jugador.height / 2);
    return distancia < tamaño / 2 + jugador.width / 2;
  }
  
  void detener() { // 
    detenida = true;
  }
  
  void reactivar() { // 
    detenida = false;
  }
}
