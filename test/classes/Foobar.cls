/*
 * Foobar
 *
 * This is a class illustrating come of the capabilities
 * of the parsing engine.
 */
public             // could also be private or global
virtual            // could also be abstract
with sharing       // could also be without sharing
class Foobar
  implements Baz, Bo // interfaces implemented
  extends Bar        // base class extended
{
    // pi is exactly three.
    public static final Integer PI = 3;
    public static Integer theInformation;

    public String myName = 'Dr. Bashir'; // said 'hi'

    public String myFavoriteBook = '\'Crime and Punishment\'';
    {
        // no content for now
        //myName = 6;
    }

    static
    {
        // no content yet
        //theInformation = 4;
    }

    // oh the humanity.
    public transient Noodles.WithTofu myLunch = 4;

    // we can have accesors...
    public Integer myReadable
    {
        get;
        private set;
    }

    // and we can customize them
    public Integer radius
    {
        get
        {
            // though they can't have content yet
        }
    }

    // let's define a method
    public Integer calculate()
    {
        // again, no body
    }

    virtual private override void helpCalculate( Integer i, Integer j, Integer k )
    {
        // it would be nice to do something here
    }

    // now inner classes are supported
    private class MyInnerClass
      extends Bo
    {
    }

    public class BadThingException extends Exception {}
}
