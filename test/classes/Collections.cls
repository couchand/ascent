// Examples of collections support.
public class Collections
{
    public static List<String> goodNames = new List<String>{ 'Jeff', 'Bill', 'Tom' };

    public static Set<Integer> goodNumbers = new Set<Integer>{ 1, 2, 3, 4, 5, 6 };

    public static void printAll( Integer numTimes )
    {
        for ( Integer i = 0; i < numTimes; i++ )
        {
            for ( String name : goodNames )
            {
                System.debug( 'My name is ' + name );
            }

            for ( Integer j : goodNumbers )
            {
                System.debug( 'i + j = ' + ( i + j ) );
            }
        }
    }
}
