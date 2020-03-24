Mat filtro_camsobel(Mat gris){
  
  //Gradiente
  int scale = 1;
  int delta = 0;
  int ddepth = CvType.CV_16S;
  Mat grad_x = new Mat();
  Mat grad_y = new Mat();
  Mat abs_grad_x = new Mat();
  Mat abs_grad_y = new Mat();
  
  // Gradiente X
  Imgproc.Sobel(gris, grad_x, ddepth, 1, 0);
  Core.convertScaleAbs(grad_x, abs_grad_x);
  
  //Gradiente Y
  Imgproc.Sobel(gris, grad_y, ddepth, 0, 1);
  Core.convertScaleAbs(grad_y, abs_grad_y);
  
  // Gradiente total aproximado
  Core.addWeighted(abs_grad_x, 0.5, abs_grad_y, 0.5, 0, gris);
  
  return gris;
}
