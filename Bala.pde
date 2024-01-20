// Objeto Bala
//
class Bala {
  float x, y;
  float velocidad = 5;
  float tamaño;
  PImage image = loadImage("images/bala.png");
  boolean detenida = false;
  
  // contructor que recibe las posiciones y tamaño
  Bala(float x, float y, float tamaño) {
    this.x = x;
    this.y = y;
    this.tamaño = tamaño;
  }
  
  // función para mover la Bala
  void mover() {
    if(detenida) return; // 
    y -= velocidad;
  }

  void mostrar() { // función para mostrar la Bala   
    image(image, x, y, tamaño, tamaño);
  }

  boolean colision(Burbuja burbuja) { // función para comprobar si la Bala colisiona con una burbuja
    float d = dist(x, y, burbuja.x, burbuja.y);
    return d < tamaño/2 + burbuja.diametro / 2;
  }
  
  boolean colision(Pajaro pajaro) { // función para comprobar si la Bala colisiona con el pajaro
    float d = dist(x, y, pajaro.x, pajaro.y);
    return d < tamaño/2 + pajaro.imagen.height / 2;
  }
  
  void destruir() { // función para reactivar la Bala  
    //println("Destruir Bala");
  }
  
  void detener() { // función para parar la Bala
    detenida = true;
  }
  
  void reactivar() { // función para reactivar la Bala   
    detenida = false;
  }
}
