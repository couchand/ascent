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
    // now inner classes are supported
    private class MyInnerClass
      extends Bo
    {
    }

    public class BadThingException extends Exception {}
}
