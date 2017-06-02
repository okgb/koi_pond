
// void drawBlobsAndEdges(boolean drawBlobs, boolean drawEdges, int type)
// {
//   noFill();
//   Blob[] b=new Blob[3];
//   EdgeVertex eA, eB;
//   int blobSize=0;
//   int tolerence=20;

//   for (int n=0; n<theBlobDetection.getBlobNb(); n++)
//   {
//     b[type]=theBlobDetection.getBlob(n);

// switch(type) {
//   case 0:
//     blobSize=blobSize0;  // Chair
//     break;
//   case 1:
//     blobSize=blobSize1;  // Sitting
//     break;
//   case 2:
//     blobSize=blobSize2;   // Walking
//     break;
// }

//     if (b[type]!=null && (b[type].getEdgeNb()> blobSize))//+tolerence && b[type].getEdgeNb()> blobSize-tolerence))
//     {

//       //fill(75*type, 0, 0);
//       //ellipse((b[type].xMin+b[type].w/2)*width, (b[type].yMin+b[type].h/2)*height, 50, 50);
//       //println("blobsize"+type+"="+ b[type].getEdgeNb());

//       if (edit) {
//         strokeWeight(1);
//         stroke(100*type, 0, 0);
//         rect(
//           b[type].xMin*kinect.width, b[type].yMin*kinect.height,
//           b[type].w*kinect.width, b[type].h*kinect.height
//           );


//       }

//       float targetX = (b[type].xMin+b[type].w/2)*width;
//       float dx = targetX - x[type][n];
//       x[type][n] += dx * easing;
//       //println("n= "+n);
//       //println("x= "+x[type][n]);
//       //println("targetx= "+targetX);

//       float targetY = (b[type].yMin+b[type].h/2)*height;
//       float dy = targetY - y[type][n];
//       y[type][n] += dy * easing;


//      // fill(75*type, 0, 0);
//      // rect(x[type][n], y[type][n], 50, 50);
//      // println("blob");

//       if (type==0 || type==1) { //Just chair

//         // fish motion wander behavior
//         for (int w = 0; w < wanderers.size(); w++) {
//           Boid wanderBoid = (Boid)wanderers.get(w);
//           // if mouse is press pick objects inside the mouseAvoidScope
//           // and convert them in evaders
//           if (type==1) {
//             //imageMode(CENTER);
//             //image(lily2, x[type][n], y[type][n], r, lily.height*r/lily.width);

//             if (dist(x[type][n], y[type][n], wanderBoid.location.x, wanderBoid.location.y) < (mouseAvoidScope)) {
//               wanderBoid.timeCount = 0;
//               mouseAttractTarget = new PVector(x[type][n], y[type][n]);
//               wanderBoid.arrive(mouseAttractTarget);
//             }



//           } else if (type==0) {

//             //for (int c=0;c<2;c++){
//             int m=constrain(n,0,2);
//             imageMode(CENTER);
//             //if (dist(mx[c],x[type][n],my[c],y[type][n])<400){
//              mx[m]=targetX;
//              my[m]=targetY;
//             //}
//             fill(255,150,0);
//             ellipse(x[1][0],y[1][0],20,20);
//             text("DISCOVER!",x[1][0],y[1][0]);
//             //ellipse(mx[m],my[m],20,20);
//             //line(x[1][0],mx[m]/2, y[1][0],my[m]/2);

//             float a = atan2((x[1][0]-mx[m])/2, (y[1][0]-my[m])/2);

//             //println("angle="+a);
//             pushMatrix();
//             translate(mx[m], my[m]);
//             rotate(-a);
//             scale(-1);
//             //println("dist"+m+"="+dist(mx[m],x[1][0],my[m],y[1][0]));
//             if (dist(mx[m],x[1][0],my[m],y[1][0])<150){
//               image(lily2, 0, 0, r, lily[0].height*r/lily[0].width);
//             }
//             else{
//             image(lily[m], 0, 0, r, lily[m].height*r/lily[m].width);

//             }
//             popMatrix();
//             //}


//             if (dist(x[type][n], y[type][n], wanderBoid.location.x, wanderBoid.location.y) < (mouseAvoidScope/2)) {
//               wanderBoid.timeCount = 0;
//               //mouseAvoidTarget = new PVector(mouseX, mouseY);
//               float collisionPointX = ((wanderBoid.location.x * mouseAvoidScope) + (x[type][n] * 1)) / (mouseAvoidScope+1);
//               float collisionPointY = ((wanderBoid.location.y * mouseAvoidScope) + (y[type][n] * 1)) / (mouseAvoidScope+1);
//               mouseAvoidTarget = new PVector(collisionPointX, collisionPointY);
//               wanderBoid.evade(mouseAvoidTarget);
//             }
//           }
//           else {
//             wanderBoid.wander();
//           }
//         }
//       } else if (type==2) { //walking

//         //if (b[type]!=null && b[type].getEdgeNb()>blobSize[type])
//         //{
//           Drop drop = new Drop(color(255), x[type][n], y[type][n]);
//           if (!edit)drops.add(drop);
//           //println("drop");
//         //}
//       }
//     }
//   }
// }



