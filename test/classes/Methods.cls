/*
 * example class illustrating method definitions
 */
public class Methods
{
    public Methods()
    {
        System.debug('methods constructor');
    }

    void doIt(){}
    public override Integer doMore( Integer i, Integer j )
    {
        System.debug( i );
        System.debug( j );
        Methods myMethods = new Methods();
    }
}
