class Keys2
{
  private boolean wDown = false;
  private boolean aDown = false;
  private boolean sDown = false;
  private boolean dDown = false;

  public Keys2() {
  }

  public boolean wDown()
  {
    return wDown;
  }

  public boolean aDown()
  {
    return aDown;
  }

  public boolean sDown()
  {
    return sDown;
  }

  public boolean dDown()
  {
    return dDown;
  }



  void onKeyPressed(int code)
  {
    if (code == UP)
    {
      wDown = true;
    } else if (code == LEFT)
    {
      aDown = true;
    } else if (code == DOWN)
    {
      sDown = true;
    } else if (code == RIGHT)
    {
      dDown = true;
    }
  }

  void onKeyReleased(int code)
  {
    if (code == UP)
    {
      wDown = false;
    } else if (code == LEFT)
    {
      aDown = false;
    } else if (code == DOWN)
    {
      sDown = false;
    } else if (code == RIGHT)
    {
      dDown = false;
    }
  }
}
