 //La app es un selector de filtros
 //1º Elegir 4 filtros distintos que se muestran a la derecha de la pantalla
 // Filtro gris
 //2º Mostrar filtros en la parte inferior de la pantalla, poder cambiar entre ellos con las flechas
 //Introducir try/catch para la busqueda y carga de la camara.
 //3º Cambiar colores
 //4º Poder cambiar filtros tocando el filtro con la mano
 
 import java.lang.*;
 import processing.video.*;
 import cvimage.*;
 import org.opencv.core.*;
 import org.opencv.imgproc.Imgproc;
 
 //número de elementos de los vectores e indices
 int n2 = 5;
 int n = 3;
 int filtroN = 0;
 int colorN = 0;
 
 color[] colorV = new color[n2];
 PShape[] formas = new PShape[n2];
 Capture cam;
 CVImage img, imgF, pimg;
 PGraphics mascara;
 void setup(){
    size(1280,480);
    
    //colores
    colorV[0] = color(255,255,255);
    colorV[1] = color(0,242,0);
    colorV[2] = color(0,242,230);
    colorV[3] = color(255, 85, 137);
    colorV[4] = color(203, 102, 253);

    //circulos colores
    formas[0] = createShape(ELLIPSE,width/2,50,20,20);
    formas[1] = createShape(ELLIPSE,width/2,100,20,20);
    formas[2] = createShape(ELLIPSE,width/2,150,20,20);
    formas[3] = createShape(ELLIPSE,width/2,200,20,20);
    formas[4] = createShape(ELLIPSE,width/2,250,20,20);
    formas[0].setFill(colorV[0]);
    formas[1].setFill(colorV[1]);
    formas[2].setFill(colorV[2]);
    formas[3].setFill(colorV[3]);
    formas[4].setFill(colorV[4]);

    formas[0].setStroke(color(255,0,0));
    
    //camara
    cam = new Capture(this,width/2, height);
    cam.start();
    
    //Mascaras
    mascara = createGraphics(cam.width, cam.height);
    mascara.beginDraw();
    mascara.ellipse(cam.width/2,cam.height/2,450,450);
    mascara.endDraw();
    
    //OpenCV, cargar biblioteca Core
    System.loadLibrary(Core.NATIVE_LIBRARY_NAME);
    
    //Crea imagenes, img -> original, imgF -> filtro aplicado
    img = new CVImage(cam.width, cam.height);
    imgF = new CVImage(cam.width, cam.height);
    //camdiff
    pimg = new CVImage(cam.width, cam.height);
    
    //Texto centrado
    textAlign(CENTER);
 }
 
 void draw(){
   if (cam.available()){
     background(0);
     cam.read();
     
     //Obtiene la imagen de la cámara
     img.copy(cam, 0, 0, cam.width, cam.height, 0, 0, img.width, img.height);
     img.copyTo();
     
     
     //Copia de Mat a CVImage
     Mat gris = img.getGrey();
      
     //Aplicamos el filtro adecuado
     switch(filtroN){
      case 0: 
      //Caso gris
        break;
      case 1:
        filtro_camdiff(gris);
        break;
      case 2:
        filtro_camsobel(gris);
        break;
      default:
        println("Error!");
        break;
     }
     
     cpMat2CVImage(gris, imgF);
     
     //Visualiza la imagen y el filtro
     noTint();
     image(img,0,0);
     
     //Coloreado
     if(colorN == 0){
       noTint();
     }else{
       tint(colorV[colorN]); 
     }
     
     image(imgF,width/2,0);

     //mascara
     imgF.mask(mascara);
     image(imgF,0,0);
     img.mask(mascara);
     image(img,width/2,0);
     
     //Figuras, colores
     for(int i=0 ; i<n2 ; i++){
       shape(formas[i]);
     }
     gris.release();
     
     //Texto
    
    text("Arriba/Abajo -> Cambiar filtro de color",width/2,height-20);
    text("Izquierda/Derecha -> Cambiar efecto visual",width/2,height-40);
   }
 }
 
 
//Copia unsigned byte Mat a color CVImage
void cpMat2CVImage(Mat in_mat, CVImage out_img)
{
  byte[] data8 = new byte[cam.width*cam.height];
  out_img.loadPixels();
  in_mat.get(0, 0, data8);
  
  // Cada columna
  for (int x = 0; x < cam.width; x++){
    //Cada fila
    for (int y = 0; y < cam.height; y++){
      //Posición en el vector 1D
      int loc = x + y *cam.width;
      //Conversión del valor a unsigned
      int val = data8[loc] & 0xFF;
      //Copia a CVImage
      out_img.pixels[loc] = color(val);
    }
  }
  out_img.updatePixels();    
}
