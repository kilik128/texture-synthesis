class WangColorSample {
  PVector ul, ur, lr, ll;
  int size;
  String colorname;
  Sample imageSample;

  WangColorSample(PVector _origin, int _size, String _colorname) {
    colorname = _colorname;
    size      = _size;
    ul        = _origin;
    ur        = new PVector(ul.x + _size, ul.y);
    lr        = new PVector(ur.x, ur.y + _size);
    ll        = new PVector(ul.x, ul.y + _size);
  }

  boolean allowed(ArrayList<Triangle> triangleList) {
    for (Triangle t : triangleList) {
      if (t.contains((double)ul.x, (double)ul.y) || 
          t.contains((double)ur.x, (double)ur.y) ||
          t.contains((double)lr.x, (double)lr.y) ||
          t.contains((double)ll.x, (double)ll.y)) {
        return false;
      }
    }
    return true;
  }
  
  void createSample(){
    imageSample = new Sample((int)ul.x, (int)ul.y, size);
  }
}

