// Objeto Pelota
// 
class Pelota {
  float x, y; // Posición del enemigo
  float velocidadX; // Velocidad horizontal del enemigo
  float velocidadY; // Velocidad vertical del enemigo
  float gravedad; // Gravedad simulada
  PImage imagen = loadImage("images/pelota.png"); // imagen de la pelota
  float tamaño; // tamaño de la pelota
  boolean detenida = false; // flag a false

  // contructor que recibe las posiciones , velocidad, fuerza de gravedad y tamaño
  Pelota(float x, float y, float velocidadX, float velocidadY, float gravedad, float tamaño) {
    this.x = x;
    this.y = y;
    this.velocidadX = velocidadX;
    this.velocidadY = velocidadY;
    this.gravedad = gravedad;
    this.tamaño = tamaño;
  }

  void actualizar() { // funcion para actualizar la posición y propiedades de la pelota
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
  
  void dibujar() { // Función para dibujar la pelota 
    image(imagen, x, y, tamaño, tamaño);
  }
  
  boolean colisionConJugador() { // detecta si la pelota ha colisionado con el jugador
    float distancia = dist(x, y, jugadorX, height - jugador.height / 2);
    return distancia < tamaño / 2 + jugador.width / 2;
  }
  
  void detener() { // función para detener el pajaro
    detenida = true;
  }
  
  void reactivar() { // función para reativar el pajaro
    detenida = false;
  }
}
