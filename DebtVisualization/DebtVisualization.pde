import java.util.*;

Table table;
int numRows;
int xStart;
int xEnd;
int yStart;
int yEnd;
PShape curve;
float maxDebt;
float minDebt;
float debtDiff;
PImage sb;
List<Integer> years;
List<Integer> debt;

void setup(){
  size(1047,700);
  table = loadTable("DebtPenny_20130916_20230915.csv");
  sb = loadImage("snowball.png");
  
  xStart = width/10;
  xEnd = width*9/10;
  yStart = height*9/10;
  yEnd = height/10;
  int xRange = xEnd-xStart;
  int yRange = yStart-yEnd;
  for(int i = 0; i < xRange; i++){
    table.removeRow(i);
    table.removeRow(i);
  }
  
  numRows = table.getRowCount();
  System.out.println(numRows);
  
  maxDebt = Float.MIN_VALUE;
  minDebt = Float.MAX_VALUE;
  for(int i = 0; i < numRows; i++){
    TableRow tr = table.getRow(i);
    float debt = tr.getFloat(3);
    if(maxDebt < debt) maxDebt = debt;
    if(minDebt > debt) minDebt = debt;
  }
  debtDiff = maxDebt - minDebt;
  
  years = new ArrayList<>();
  
  curve = createShape();
  curve.beginShape();
  curve.strokeWeight(5);
  int prevYear = 0;
  for(int i = 0; i < numRows; i++){
    TableRow tr = table.getRow(i);
    curve.vertex(xEnd-i, yEnd + (tr.getFloat(3)-minDebt)*yRange/(debtDiff));
    int temp = tr.getInt(7);
    if(temp != prevYear){
      years.add(i);
      prevYear = temp;
    }
  }
  //curve.strokeWeight(10);
  curve.curveVertex(xStart, yEnd);
  curve.curveVertex(xStart, yStart);
  curve.curveVertex(xEnd, yStart);
  //years.remove(years.size()-1);
  curve.fill(255);
  curve.endShape();
  years.remove(0);
  pushMatrix();
  int tDiff = (int)(debtDiff/pow(10,12));
  int tMin = (int)(ceil(minDebt/pow(10,12)));
  debt = new ArrayList<Integer>();
  for(int i = tMin; i < tMin+tDiff; i++){
    debt.add(i);
  }
  debt.remove(0);
}

void draw(){
  background(0);
  fill(255);
  
  shape(curve);
  
  textAlign(CENTER);
  textSize(20);
  text("US Total Public Debt Outstanding Accumulation over Time (10 Years ver.)", width/2, 40);
  textSize(20);
  for(int i = 0; i < years.size();i++){
    int row = years.get(i);
    text(table.getRow(row).getInt(7)+1, xEnd-row, yStart+30);
  }
  textAlign(RIGHT);
  for(int i = 0; i < debt.size(); i++){
    int row = debt.get(i);
    text(row + " ", xStart, (row*pow(10,12)-minDebt)*(yStart-yEnd)/debtDiff+yEnd);
  }
  rect(width*0.7,height*0.07, 300, 150);
  fill(0);
  textSize(15);
  textAlign(LEFT);
  text("Y-Axis: Debt Amount in Trillions of Dollars", width*0.72, height*0.13);
  text("X-Axis: Years", width*0.72, height*0.2);
  strokeWeight(2);
  fill(255);
  int yPos = 0;
  int row = 0;
  //popMatrix();
  int mX = mouseX;
  
  if(mX < xStart){
    row = 0;
    mX = xStart;
  }
  else if(mX >= xEnd-1){
    row = numRows-1;
    mX = xEnd;
  }
  else
    row = (mX-xStart);
  TableRow tr = table.getRow(numRows-1-row);
  float debtAmt = tr.getFloat(3);
  yPos = (int)(yEnd + (debtAmt-minDebt)*(yStart-yEnd)/(debtDiff));
  float size = 40+0.4*(debtAmt-minDebt)*(yStart-yEnd)/(debtDiff);
  translate(mX, yPos-size/3);
  
  if(mousePressed == true){
    textAlign(CENTER);
    fill(255);
    text("$"+round(debtAmt/pow(10,9))+"B " + tr.getString(0), 0, -size/2);
    fill(0);
    line(0,0,0,yStart-(yPos-size/3));
  }
  rotate(mX/50.0);
  image(sb, -size/2, -size/2, size, size);
}
