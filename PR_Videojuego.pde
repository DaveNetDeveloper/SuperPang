/*
  TÍTULO: PR - Programación Creativa
  AUTOR: David Gómez Martínez
  DESCRIPCIÓN: Este programa es una pequeña versión del videojuego arcade "Super Pang" que consiste en la 
  eliminación de todas las burbujas a cambio de ganar puntos sin perder la vida. En pantalla vemos los siguientes elementos con las 
  siguientes intereacciones:
    
    * Jugador: Es un avatar que puede desplazarse horizontalmente en el eje X (con las teclas de dirección '←' y '→') para seguir a las 
      burbujas con el objetivo de disparar balas hacia ellas para eliminarlas. El jugador pierde la única vida cuando es tocado por una burbuja,
      cuando es impctado por una pelota de un enemigo o cuando se agota el tiempo. 
      
    * Burbujas: Existe un número aleatorio de burbujas que rebotan en los limites, superior, inferior y laterales de la ventana.
      Al explotar se crean dos nuevas burbujas con un tamaño menor. Cada burbuja eliminada por el jugador suma puntos al marcador.
      Además, al explotar una burbuja, según una probabilidad random, se crea un tipo de bonificación para el jugador.  
                
    * Balas: Las balas son disparadas hacia arriba por el jugador(con la tecla 'SPACE') desde el arma que lleva incorporada.
      Las balas se destruyen al impactar con una burbuja o desaparecen por el limite superior de la ventana.
             
    * Bonificación: La recompensa es un objeto que aparece a veces cuando una burbuja es eliminada. Las bonificaciones 
      suman puntos al marcador. El tipo de recompensa se genera de manera aleatoria. Cada bonificación incorpora un temporizador 
      que controla el tiempo que ha de permanecer en patalla antes de ser eliminado. 
    
    * Pajaro: Es un enemigo que sobre-vuela la pantalla con un vuelvo oscilatorio. No se puede eliminar aunque si se puede impactar 
      con una bala para obtener puntos y además una recompensa. Una vez recogida la recompensa se podrá genenear otra con nuevos disparos.
      Al transcurrir un tiempo random este enemigo dispara una pelota con un movimiento parabolico que puede impactar y dañar al jugador. 
      Cuando la pelota es disparada, su trayectoria sigue una forma parabólica debido a la influencia de la gravedad. Cuando la pelota 
      golpea el suelo simula una colisión elástica que tiene en cuenta la velocidad y el ángulo para el calculo de la dirección. Debido a la 
      la fricción en los rebotes, la pelota sufre la pérdida de fuerza. 
       
    * Gráficos textuales: En pantalla también vemos varios panales textuales, como por ejemplo:
        ** Puntuación: Total de puntos acumulados en la partida.
        ** Tiempo restante: segundos restantes de partida.
        ** 10 últimos segundos de partida: cuenta atrás.
        ** Nivel completado o fallado. 
           
    * Efectos de sonido: Se cargan y utilizan varios sonidos en algunos momentos de acción  como por ejemplo, 
      cuando se recoge una bonificación, se destruye una burbuja o una recompensa o se pierde/gana la partida. 
      Además se oye en todo momento una música de fondo.
                         
    * Pausa/Reanudar: El juego se puede pausar y reanudar al pulsar la tecla 'P'.
*/

// importamos las librerias necesarias
import ddf.minim.*;
import ddf.minim.analysis.*;
import ddf.minim.effects.*;
import ddf.minim.signals.*;
import ddf.minim.spi.*;
import ddf.minim.ugens.*;
import java.util.Iterator;

// variables y objetos globales
ArrayList<Burbuja> burbujas = new ArrayList<Burbuja>();
ArrayList<Bala> balas = new ArrayList<Bala>();
ArrayList<Bala> balasAEliminar = new ArrayList<Bala>();

boolean pararJuego = false;
boolean blackScreenExit = false;
float jugadorX;
int puntuacion = 0; // Variable para la puntuación
int maxBurbujas = 1; // indice en base 0 
int tiempoVisible = 60; // Número de fotogramas 
int frameInicial; // 
int frameInicialPuntuacion = 0; // 

PImage jugador;
PImage jugadorIzquierdaImg;
PImage jugadorDerechaImg;
PImage fondo;
PImage bonificacionImg;
PImage bonificacionTiempoImg;
PImage bonificacionTntImg;
PImage bonificacionDulceImg;
PImage armaImg;

ArrayList<Bonificacion> bonificaciones = new ArrayList<Bonificacion>();
ArrayList<Bonificacion> bonificacionesAEliminar = new ArrayList<Bonificacion>();
Pajaro[] pajaros = new Pajaro[1]; // Array de objetos Pajaro

int tiempoTotal; // Duración total del temporizador en segundos
int tiempoRestante; // Tiempo restante en milisegundos
int tiempoRestanteEnSegundos; //  // Tiempo restante en segundos
int tiempoInicio; // Tiempo en que se inició el temporizador
int tiempoEnPausa; // Tiempo acumulado en pausa

boolean bonificacionPajaroEnCurso = false; // 

Minim minim; // objeto Minim para gestión de audios
AudioPlayer[] players = new AudioPlayer[10]; // Puedes ajustar el tamaño según la cantidad de archivos de audio que tienes

PFont font;

// definición de Enums
//
// enumeración para facilitar la elección de los elementos de sonido
enum FX {
  Recompensa,
  Win,
  Wrong,
  Burbuja,
  Fail,
  Fail2,
  Ko,
  Theme,
  Bird,
  StartClick
}
// enumeración para facilitar la gestión de los estados de la partida
enum LevelState {
  Start,
  Complete,
  Fail,
  CountDown
}

//
// función ppal. de inicilización del programa
void setup() {
  
  size(701, 404); // tamaño de la ventana
  background(0);  // Fondo negro
  
  // carga la tipografía elegida
  font = createFont("fonts/ARCADE_I.TTF", 32);
  textFont(font);
  
  textAlign(CENTER, CENTER);
  textSize(15);
  fill(255);  // texto blanco
  text("Presiona cualquier tecla para empezar", width/2, height/2);
  
  frameInicial = frameCount; // Guarda el número de fotograma actual
  jugadorX = width/2; // posicionamos al jugador en medio del eje X
  cargarImagenes(); //
  crearBurbujas(); // 
  cargarFXs(); //
  establecerTemporizador(); //
  crearPajaro(); // 
}

// función ppal. de renderización del programa 
void draw() {
  
  if(blackScreenExit) {
    background(fondo);// Establece la imagen como fondo
    
    calcularYMostrarTemporizador(); // 
    
    mostrarMensajesTemporales(); // 
    moverYDibujarJugador(); // Mover y dibujar jugador
    moverYMostrarBalas(); // 
    comprobarBalasAEliminar();// Eliminar balas que colisionaron
    moverYMostrarBurbujas();// 
    comprobarColosionEntreBurbujaYJugador(); // 
    moverYMostrarBonificaciones(); // Mover y mostrar bonificaciones
    mostrarPuntuacion(); // Muestra la puntuación en la pantalla
    mostrarYActualizarPajaro(); //
    
    if(burbujas.size() <= 0) setWinState(); // win
    if(pararJuego) detenerJuego(); // 
  } 
}

// Inicializa los pájaro en una posición inicial y con una amplitud y frecuencia 
void crearPajaro() {
  //for (int i = 0; i < pajaros.length; i++) {
      float inicioX = -100;
      float inicioY = 50;
      float amplitudY = 100;
      float frecuenciaY = 0.3;
      float velocidadX = 1;
      pajaros[0] = new Pajaro(inicioX, inicioY, amplitudY, frecuenciaY, velocidadX);
  //}
}

// Dibuja y actualiza el pájaro en el array 
void mostrarYActualizarPajaro() {
  for(Pajaro pajaro : pajaros) { // 
    pajaro.actualizar();  // 
    pajaro.dibujar(); // 
    
    boolean hayPelota = false;
    //println("pelotas.length: " + pelotas.length);
    for(Pelota pelota : pajaro.pelotas) { //  
      if(pelota != null) { // 
        hayPelota = true; // 
        pelota.actualizar(); // 
        pelota.dibujar(); // 
        if(pelota.colisionConJugador()) { // 
          setFailState(); // 
        }
      }
    }
    if(!hayPelota && pajaro.disparar) { // 
      pajaro.disparar(); // 
    }
  }
}

// 
void establecerTemporizador() {
  tiempoTotal = 60 ; // Configura la duración del temporizador de la partida en segundos
  reiniciarTemporizador(); // Reinicia el temporizador
}

// Reinicia el temporizador
void reiniciarTemporizador() {
  tiempoInicio = millis();
  tiempoEnPausa = 0; // Reinicia el tiempo en pausa
}

//
void crearBurbujas() {  
  // Crear burbujas
  for (int i = 0; i < random(2, maxBurbujas); i++) {
    burbujas.add(new Burbuja(random(width), random(50), random(20, 50)));
  }
}

// 
void cargarFXs() { 
  minim = new Minim(this); // crea el objeto gestor de audios
  
  // Carga los archivos de audio
  players[0] = minim.loadFile("sounds/mario-coin.mp3");
  players[1] = minim.loadFile("sounds/win.mp3");
  players[2] = minim.loadFile("sounds/wrong.mp3");
  players[3] = minim.loadFile("sounds/pinchazo-globo.mp3");
  players[4] = minim.loadFile("sounds/fail.mp3");
  players[5] = minim.loadFile("sounds/fail-2.mp3");
  players[6] = minim.loadFile("sounds/ko.mp3");
  players[7] = minim.loadFile("sounds/theme.mp3");
  players[8] = minim.loadFile("sounds/gritoPajaro.mp3");
  players[9] = minim.loadFile("sounds/game-click.wav");
}

// 
void reproducirSonido(FX fx) {
    switch (fx) { // 
      case Recompensa:
        players[0].rewind(); // Reinicia la reproducción
        players[0].play(); // Inicia la reproducción
        break;
      case Win:
        //players[1].rewind(); // Reinicia la reproducción
        players[1].play(); // Inicia la reproducción
        break;
      case Wrong:
        players[2].rewind(); // Reinicia la reproducción
        players[2].play(); // Inicia la reproducción
        break;
      case Burbuja:
        players[3].rewind(); // Reinicia la reproducción
        players[3].play(); // Inicia la reproducción
        break;
      case Fail:
        players[4].rewind(); // Reinicia la reproducción
        players[4].play(); // Inicia la reproducción
        break;
      case Fail2:
        //players[5].rewind(); // Reinicia la reproducción
        players[5].play(); // Inicia la reproducción
        break;
      case Ko:
        players[6].rewind(); // Reinicia la reproducción
        players[6].play(); // Inicia la reproducción
        break;
      case Theme:
        players[7].rewind(); // Reinicia la reproducción
        players[7].loop(); // Inicia la reproducción
        break;
      case Bird:
        players[8].rewind(); // Reinicia la reproducción
        players[8].play(); // Inicia la reproducción
        break; 
      case StartClick:
        players[9].rewind(); // Reinicia la reproducción
        players[9].play(); // Inicia la reproducción
        break;
     } 
}

// función para parar un sonido según parametro Enum
void pararSonido(FX fx) {
  switch (fx) { // 
    case Recompensa:
      players[0].close(); // para la reproducción
      break;
    case Win:
      players[1].close(); // para la reproducción
      break;
    case Wrong:
      players[2].close(); // para la reproducción
      break;
    case Burbuja:
      players[3].close(); // para la reproducción
      break;
    case Fail:
      players[4].close(); // para la reproducción
      break;
    case Fail2:
      players[5].close(); // para la reproducción
      break;
    case Ko:
      players[6].close(); // para la reproducción
      break;
    case Theme:
      players[7].pause(); // para la reproducción
      break; 
    case Bird:
      players[8].close(); // para la reproducción
      break; 
    case StartClick:
      players[9].close(); // para la reproducción
      break;
  } 
}

// 
void cargarImagenes() {
  fondo = loadImage("images/fondo.png"); // carga imagen 
  jugador = loadImage("images/jugador.png"); // carga imagen
  jugadorIzquierdaImg = loadImage("images/jugadorIzquierda.png");
  jugadorDerechaImg = loadImage("images/jugadorDerecha.png");
  armaImg = loadImage("images/arma.png");
  bonificacionImg = loadImage("images/bonificacion.png"); // Cargar la imagen de bonificación
  bonificacionTiempoImg = loadImage("images/bonificacionTiempo.png"); // Cargar la imagen de bonificación
  bonificacionTntImg = loadImage("images/bonificacionTnt.png"); // Cargar la imagen de bonificación
  bonificacionDulceImg = loadImage("images/bonificacionDulce.png"); // Cargar la imagen de bonificación
}

// 
void mostrarMensajesTemporales() { 
  if (frameCount - frameInicial < tiempoVisible) { // 
    mostrarLevelState(LevelState.Start); //
  }
  // 
  if (frameInicialPuntuacion != 0 && frameCount - frameInicialPuntuacion < tiempoVisible) {
     textSize(10); //
     fill(0); // 
     text("100 puntos", jugadorX+20, height-jugador.height);// texto con la puntuación de la recompensa
  }
}

// 
void mostrarLevelState(LevelState levelState) {
  fill(0, 150); // Color negro con opacidad
  noStroke(); // 
  rect( width/2-200/2, height/2-45, 200, 75, 10, 10, 10,10); //  

  fill(255); // Color blanco para el texto
  textSize(13); // tamaño del texto
  textAlign(CENTER); // 

  String screenMessage = ""; // variable para el mensaje por pantalla
  switch (levelState) { // según la enum LevelState
      case Complete:
          screenMessage = "Level Complete";
        break;
      case Fail:
          screenMessage = "Level Failed";
        break;
      case Start:
          screenMessage = "Start"; 
        break;
      case CountDown:
          screenMessage = str(tiempoRestanteEnSegundos); // cuenta atras
        break;
  } 
  text(screenMessage, width/2, height/2); // mostramos el texto con la puntuación
}

// 
void mostrarPuntuacion() { 
  fill(0, 150); // Color negro con opacidad
  noStroke();
  rect(width - 125, 10, 115, 40, 10, 10, 10,10); // Rectángulo en la esquina superior derecha

  fill(255); // Color blanco para el texto
  textSize(10); // tamaño del texto
  textAlign(LEFT); // alineamiento del texo a la izquierda
  text("Score:  ", width - 110, 35); // mostramos el texto
  textAlign(RIGHT);  // alineamiento del texo a la derecha
  text(puntuacion, width - 20, 35); // mostramos la puntuación
}

// 
void mostrarTiempo(int tiempoRestante) { 
  fill(0, 150); // Color negro con opacidad
  noStroke(); // sin borde
  rect(10, 10, 105, 40, 10, 10, 10, 10); // Rectángulo en la esquina superior izquierda

  fill(255); // Color blanco para el texto
  textSize(12); // tamaño del texto
  textAlign(LEFT);
  text("Time:", 25, 35); // mostramos el texto con el tiempo
  textAlign(RIGHT);
  text(nf(tiempoRestante / 1000, 2), 105, 35); // mostramos el texto con el tiempo
}

//
void calcularYMostrarTemporizador() {
  
  //println("blackScreenExit: " + blackScreenExit);
  //println("pararJuego: " + pararJuego);
  
  if(!pararJuego && blackScreenExit) {
     //println("pararJuego: " + pararJuego);
     tiempoRestante = tiempoTotal * 1000 - (millis() - tiempoInicio - tiempoEnPausa); // Actualiza el tiempo restante
      
     float tiempoEnPausaEnSegundos = int(nf(tiempoEnPausa / 1000, 2)); // 
     println("tiempoEnPausaEnSegundos: " + tiempoEnPausaEnSegundos);
     
     tiempoRestanteEnSegundos = int(nf(tiempoRestante / 1000, 2)); // 
     if (tiempoRestanteEnSegundos > 0 && tiempoRestanteEnSegundos <= 10) {
       mostrarLevelState(LevelState.CountDown);
     }
  
     // Comprueba si el tiempo es inferior o igual a 10 segundos
     tiempoRestanteEnSegundos = int(nf(tiempoRestante / 1000, 2)); // 
     if (tiempoRestanteEnSegundos > 0 && tiempoRestanteEnSegundos <= 10 && !pararJuego) {
       mostrarLevelState(LevelState.CountDown);
     }
    
     // Comprueba si el tiempo ha llegado a cero y la partida ha terminado
     if (tiempoRestante <= 0) setFailState();
  } 
  mostrarTiempo(tiempoRestante); //  mostramos el tiempo restante en segundos por pantalla
}

//
void setWinState() {
  pararJuego = true;
  jugador = loadImage("images/jugadorWin.png"); // a imagen de jugador ganador
  pararSonido(FX.Theme); // 
  reproducirSonido(FX.Win); // reproducimos fx
  mostrarLevelState(LevelState.Complete); //  
}

//
void setFailState() {
  pararJuego = true;
  jugador = loadImage("images/jugadorKO.png"); // a imagen de jugador ganador
  pararSonido(FX.Theme); // función para parar un sonido según parametro Enum
  reproducirSonido(FX.Fail2); // reproducimos fx
  mostrarLevelState(LevelState.Fail); //
}

// 
void reactivarJuego() {
  for(Burbuja burbuja : burbujas) { // 
    burbuja.reactivar();
  } 
  
  for(Bala bala : balas) { // 
    bala.reactivar();
  }
  
  for(Bonificacion bonificacion : bonificaciones) { // 
    bonificacion.reactivar();
  }
  
  for(Pajaro pajaro : pajaros) { //  
    pajaro.reactivar();
    for (Pelota pelota : pajaro.pelotas) { // 
      if(pelota != null) pelota.reactivar();
    } 
  } 
}

// 
void detenerJuego() {
  for(Burbuja burbuja : burbujas) { // 
    burbuja.detener();
  } 
  
  for(Bala bala : balas) { // 
    bala.detener();
  }
  
  for(Bonificacion bonificacion : bonificaciones) { // 
    bonificacion.detener();
  }
  
  for(Pajaro pajaro : pajaros) { //  
    pajaro.detener();
    for (Pelota pelota : pajaro.pelotas) { // 
      if(pelota != null) pelota.detener();
    } 
  } 
}

// Mover y dibujar jugador
void moverYDibujarJugador() {
  jugadorX = constrain(jugadorX, 0+jugador.width/2, width-jugador.width/2);
  imageMode(CENTER);
  image(armaImg, jugadorX+5, height-jugador.height/2-30, 20, 30);
  image(jugador, jugadorX, height-jugador.height/2);
}

// Mover y mostrar burbujas
void moverYMostrarBurbujas() {
  for (Burbuja burbuja : burbujas) {
    burbuja.mover();
    burbuja.mostrar();
  }
}

// Eliminar balas que colisionaron
void comprobarBalasAEliminar() {
  for (Bala bala : balasAEliminar) {
    bala.destruir();
  }
  balas.removeAll(balasAEliminar);
  balasAEliminar.clear();
}

// Verificar colisiones enmtre burbujas y el jugador
void comprobarColosionEntreBurbujaYJugador(){  
  for (Burbuja burbuja : burbujas) { // para cada burbuja
    if (colisionConJugador(burbuja)) { // fail
      setFailState();
    }
  } 
}  

//
void moverYMostrarBalas() {
  if(!pararJuego) {
    
  // Mover y dibujar balas
  for (int i = balas.size() - 1; i >= 0; i--) {
    Bala bala = balas.get(i);
    bala.mover();
    bala.mostrar();

    // comprobamos si la bala ha alcanzado al pajaro
    for(Pajaro pajaro : pajaros) { //  

      if (bala.colision(pajaro)) {
        //println("La bala ha colisionado con el pajaro!");
        pajaro.colisionado = true;
        reproducirSonido(FX.Bird); // reproducimos fx
        balasAEliminar.add(bala);     
        puntuacion += 50;
      } 
    }

    // Verificar colisiones con burbujas
    for (int j = burbujas.size() - 1; j >= 0; j--) {
      Burbuja burbuja = burbujas.get(j);
      if (bala.colision(burbuja)) {
        
       // Solo agregar puntos la primera vez que se detecta la colisión
        if (!burbuja.haColisionado()) {
          // Incrementar la puntuación al eliminar una burbuja
          puntuacion += 10;
          burbuja.marcarColision(); // Marcar la burbuja como colisionada para evitar sumar puntos múltiples veces
        }
        // Almacenar bala para eliminar
        balasAEliminar.add(bala);

        // Crear dos burbujas más pequeñas
        for (int k = 0; k < 2; k++) {
          //
          float newXPosition;
          if(k == 0) { 
           newXPosition = burbuja.x + random(30, 60);
          }
          else { 
           newXPosition = burbuja.x - random(30, 60); 
          }
          
          Burbuja nuevaBurbuja = new Burbuja(newXPosition, burbuja.y , burbuja.diametro / 2);
          nuevaBurbuja.marcarNoColisionada(); // Marcar la nueva burbuja como no colisionada inicialmente
          
          if(burbuja.diametro/2 >= 5) {
            burbujas.add(nuevaBurbuja); 
          }
        }
        
        reproducirSonido(FX.Burbuja); // reproducimos fx
        // eliminar la burbuja        
        burbuja.destruir();
        burbujas.remove(j);
      }
    } 
  }
 }
}

// 
void CrearBonificacion(float x, float y, boolean pajaro) {
  if(pajaro && !bonificacionPajaroEnCurso) {
      PImage img = null;
      switch(int(random(1, 5))) {
          case 1:
            img = bonificacionImg; 
          break;
          case 2:
             img = bonificacionTiempoImg; 
          break;
          case 3:
             img = bonificacionTntImg; 
          break;  
          case 4:
             img = bonificacionDulceImg; 
          break;  
      }  
      bonificaciones.add(new Bonificacion(x, y, 30, img));
  }
  else if(!pajaro) { 
     
    if(random(0, 10) > 7) { // % de probabilidad de generar bonificación
        PImage img = null;
        switch(int(random(1, 5))) {
          case 1:
            img = bonificacionImg; 
          break;
          case 2:
             img = bonificacionTiempoImg; 
          break;
          case 3:
             img = bonificacionTntImg; 
          break;  
          case 4:
             img = bonificacionDulceImg; 
          break;  
      }  
      bonificaciones.add(new Bonificacion(x, y, 30, img));
     }  
  } 
 }

// Mover y mostrar bonificaciones
void moverYMostrarBonificaciones() {
  
  Iterator<Bonificacion> iterBonificacion = bonificaciones.iterator();
  while (iterBonificacion.hasNext()) {
    
    Bonificacion bonificacion = iterBonificacion.next();
    bonificacion.mover();
    bonificacion.mostrar();

    // Verificar colisión con el jugador
    if (dist(jugadorX, height - jugador.height / 2, bonificacion.x, bonificacion.y) < 20) {
       
      reproducirSonido(FX.Recompensa); // reproducimos fx
      frameInicialPuntuacion = frameCount; // Guarda el número de fotograma actual
       
      // Incrementar la puntuación u aplicar bonificación al jugador
      puntuacion += 50; // sumar puntos al recoger la bonificación
      iterBonificacion.remove();// Eliminar la bonificación

      bonificacionPajaroEnCurso = false;
    }
    
    if(bonificacion.toDelete) {
      iterBonificacion.remove();// Eliminar la bonificación
    }
  }
}

//  
boolean colisionConJugador(Burbuja burbuja) {
  float distancia = dist(burbuja.x, burbuja.y, jugadorX, height - jugador.height / 2);
  return distancia < burbuja.diametro / 2 + jugador.width / 2;
}

// evento que recoge las pulsaciones del teclado
void keyPressed() {
  
  if(!blackScreenExit) { // 
    reproducirSonido(FX.StartClick); // reproducimos el fx
    blackScreenExit = true; // Marcamos que hemos salido de la pantalla inicial
    background(0);  // Limpiar la pantalla
    reproducirSonido(FX.Theme); // reproducimos fx
  } 
  
  if (keyCode == 'P') { // parar el juego o salir del modo de pausa 
  
       reproducirSonido(FX.Wrong); // reproducimos efecto de sonido del modo de pausa
       if(pararJuego) {  // si estamos en modo pausa
          pararJuego = false; // lo desactivamos
          reactivarJuego(); // rectivamos el juego 
          reproducirSonido(FX.Theme); // reproducimos el tema de audio
          
          tiempoInicio = millis() - tiempoEnPausa; // restamos el tiempo en pausa para no descontarlo del timer ppal.
          tiempoEnPausa = 0; // reiniciamos el contador de tiempo en pausa
       }
       else if (pararJuego == false) { // si no estamos en modo pausa
         tiempoEnPausa = millis() - tiempoInicio; // Acumula el tiempo en pausa
         pararJuego = true; // lo activamos
         pararSonido(FX.Theme);  // paramos el tema de audio 
       }
  }
    
  if(!pararJuego) {
    if (keyCode == LEFT) {
      jugadorX -= 10; // TODO: jugador.move()
      jugador = jugadorIzquierdaImg; // a imagen de jugador izquierda
    }
    else if (keyCode == RIGHT) {
      jugadorX += 10; // TODO: jugador.move()
      jugador = jugadorDerechaImg; // a imagen de jugador derecha
    }
    else if (key == ' ') { // tecla espaciadora
      jugador = loadImage("images/jugador.png"); // a imagen de jugador arriba
      // Crear una nueva bala
      Bala bala = new Bala(jugadorX +5, height - jugador.height - 15, 10);
      balas.add(bala);
    }
  }
}
