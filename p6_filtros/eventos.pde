//Numero de filtros


void keyPressed(){
  switch(keyCode){
    case LEFT:
      filtroN = (filtroN+1)%n;
      break;
    case RIGHT:
      filtroN = (filtroN-1+n)%n;
      break;
    case DOWN:
      formas[colorN].setStroke(0);
      colorN = (colorN+1)%n2;
      formas[colorN].setStroke(color(255,0,0));
      break;
    case UP:
      formas[colorN].setStroke(0);
      colorN = (colorN-1+n2)%n2;
      formas[colorN].setStroke(color(255,0,0));
      break;
    default:
      break;
  }
}
