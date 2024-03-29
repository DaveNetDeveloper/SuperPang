// Objeto Burbuja
//
class Burbuja {
  float x, y, diametro; // variables para posición x, y y para el diametro
  float velocidadX; // Velocidad en el eje X
  float velocidadY; // Velocidad en el eje Y
  float rebote = 1;//0.8; // Factor de rebote
  boolean enSuelo = false; // Bandera para controlar si la burbuja está en el suelo
  boolean detenida = false; // Bandera para controlar si la burbuja está detenida
  boolean colisionada = false; // Bandera para controlar si la burbuja ha colisionado
  PImage imagen = loadImage("images/burbuja.png");
  
  // contructor que recibe las posiciones y diametro
  Burbuja(float x, float y, float diametro) {
    this.x = x;
    this.y = y;
    this.diametro = diametro;
    this.velocidadY = map(diametro, 10, 20, 2, 3); 
    //this.velocidadY = 4;
    this.velocidadX = random(-1, 1);
  }
  
  void destruir() { // función al destruirse una burbuja
    CrearBonificacion(this.x, this.y, false); // función para crear una bonificación aleatotoria 
  }
  
  boolean haColisionado() { // devuelve si la burbuja ha sido olisionada
    return colisionada;
  }
  
  void marcarColision() { // función para indicar la burbuja como colisionada
    colisionada = true;
  }
  
  // función para indicar la burbuja como no colisionada
  void marcarNoColisionada() {
    colisionada = false;
  }
  
  // función para mover la burbuja
  void mover() { 
    // Si la burbuja está detenida, no realizar movimientos
    if (detenida) return;

    // Simular movimiento horizontal
    x += velocidadX;
    // Rebotar en los bordes horizontales
    if (x-diametro/2 < 0 || x+diametro/2 > width) {
      velocidadX *= -1;
    }
    
    // Simular gravedad en el eje Y
    y += velocidadY;
    // Si la burbuja llega al suelo, invertir la dirección de la velocidad en Y y aplicar rebote
    if (y > height - diametro / 2) {
      velocidadY *= -1;//rebote;
      enSuelo = true;
    }
    
    // Limitar la posición Y para evitar que suban más allá de la coordenada Y 50 después del rebote
    if (enSuelo) {
      y = constrain(y, diametro / 2, height - diametro / 2);
    }

    // Reiniciar la bandera cuando la burbuja sale del suelo
    if (enSuelo && y <= diametro / 2) {
      velocidadY *= -rebote;
      enSuelo = true;
    }
  }

  void mostrar() { // función para mostrar la burbuja
    image(imagen, x, y, diametro+5, diametro); 
  }
  
  void detener() { // función para detener la burbuja
    detenida = true;
  }
  
  void reactivar() { // función para reactivar la burbuja 
    detenida = false;
  }
}
