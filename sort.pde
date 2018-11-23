import java.util.Comparator;
import java.util.Collections;

public void sortCCW(ArrayList<PVector> pointList, PVector first) {
  PVector origin = calculateOrigin(pointList);
  Collections.sort( pointList, new PointComparator(origin, 0));
  
    
  int index = pointList.indexOf(first);
  Collections.rotate(pointList, -index - 1);
}

public PVector calculateOrigin(ArrayList<PVector> pointList) {
  PVector origin = new PVector();
  
  for(PVector p : pointList) {
    origin.add(p);
  }
  
  return origin.div(pointList.size());
}

public class PointComparator implements Comparator<PVector>  {
    private PVector M; 
    private double offsetAngle;
    public PointComparator(PVector origin, double _offsetAngle) {
        M = origin;
        offsetAngle = _offsetAngle;
    }

    public int compare(PVector o1, PVector o2) {
        double angle1 = Math.atan2(o1.y - M.y, o1.x - M.x);
        double angle2 = Math.atan2(o2.y - M.y, o2.x - M.x);

        //counter clock wise
        if(angle1 < angle2) return 1;
        else if (angle2 < angle1) return -1;
        return 0;
    }
}
