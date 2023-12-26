//
class Bala {
  float x, y;
  float velocidad = 5;
  float tamaño;
  PImage image = loadImage("images/bala.png");
  boolean detenida = false;
   
  Bala(float x, float y, float tamaño) {
    this.x = x;
    this.y = y;
    this.tamaño = tamaño;
  }

  void mover() {
    if(detenida) return; // 
    y -= velocidad;
  }

  void mostrar() {
    image(image, x, y, tamaño, tamaño);
  }

  boolean colision(Burbuja burbuja) {
    float d = dist(x, y, burbuja.x, burbuja.y);
    return d < tamaño/2 + burbuja.diametro / 2;
  }

  void destruir() {
    //println("Destruir Bala");
  }
  
  void detener() { // 
    detenida = true;
  }
  
}
