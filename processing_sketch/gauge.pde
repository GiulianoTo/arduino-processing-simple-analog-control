class Gauge
{
    PVector gsize;   //width & height  gauge
    PVector gscale;  //start & end value scale
    PVector gneedle; //length  & angle needle
    int gsteps;
    float gline;
    String gname;

    Gauge(float tempx, float templow, float temphigh, float templine, String tempname)
    {
        float gwidth = tempx;
        float gheight = 26 * tempx / 35;
        float glow = templow;
        float ghigh = temphigh;
        gline = templine;
        gname = tempname;
        gsteps = int(temphigh - templow) + 1;
        gsize = new PVector(gwidth, gheight);
        gscale = new PVector(glow, ghigh);
        gneedle = new PVector(5 * gsize.y / 8, map(second(), 0, 59, radians(35), radians(145)));
    }

    void display()
    {
        noStroke();
        //backcover
        fill(50);
        rect(0, 0, gsize.x, gsize.y);
        fill(255);
        textAlign(CENTER);
        textSize(14);
        text(gname, gsize.x / 2, 15);
        //scale
        stroke(255, 200);
        //strokeWeight(2);
        for (int i = 0; i < gsteps; i++) {
            pushMatrix();
            translate(gsize.x / 2, 11 * gsize.y / 12);
            rotate(PI + map(i, gscale.x, gscale.y, radians(35), radians(145)));
            if (i % gline == 0) {
                line(gneedle.x - 5, 0, gneedle.x + 5, 0);
                translate(gneedle.x + 10, 0);
                rotate(HALF_PI);
                textSize(9);
                text(i, 0, 0);
            } else {
                point(gneedle.x, 0);
            }
            popMatrix();
        }
        noStroke();
        //needle
        stroke(255, 0, 0);
        //strokeWeight(3);
        pushMatrix();
        translate(gsize.x / 2, 11 * gsize.y / 12);
        rotate(PI + gneedle.y);
        line(0, 0, gneedle.x, 0);
        popMatrix();
        noStroke();
        //frontcover
        fill(150, 180);
        rect(0, 4.5 * gsize.y / 6, gsize.x, 1.5 * gsize.y / 6);
        fill(255, 0, 0);
        ellipseMode(CENTER);
        ellipse(gsize.x / 2, 11 * gsize.y / 12, 10, 10);
    }

    void update(float tempgval)
    {
        float gvalue = tempgval;
        gneedle.y = map(gvalue, gscale.x, gscale.y, radians(35), radians(145));
    }
}
