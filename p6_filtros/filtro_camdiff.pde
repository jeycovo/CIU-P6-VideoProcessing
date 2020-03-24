Mat filtro_camdiff(Mat gris){
  Mat pgris = pimg.getGrey();
  
  //Calcula diferencias entre fotograma actual y el previo
  Core.absdiff(gris, pgris, gris);
  
  pimg.copy(img, 0, 0, img.width, img.height, 0, 0, img.width, img.height);
  pimg.copyTo();
  return gris;
}
