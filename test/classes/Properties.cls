/*
 * An example of some of the property features.
 */
public class Properties
{
    Integer i = 42;
    public static final Integer PI = 3;

    public Person jane
    {
        get;
        private set;
    }

    private Person martha
    {
        get
        {
            Integer i = 42;
        }
    }
}
