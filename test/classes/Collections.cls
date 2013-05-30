// Examples of collections support.
public class Collections
{
    /* this is a comment
    this.would(cause + a + parse + )()()()() erororor *&*&*%
    */
    public static List<String> goodNames = new List<String>{ 'Jeff', 'Bill', 'Tom' };

    public static Set<Integer> goodNumbers = new Set<Integer>{ 1, 2, 3, 4, 5, 6 };
    public static Set<Integer> badNumbers = new Set<Integer>{ 9, 8, 7, 0 };
    List<Set<Integer>> allNumbers = new List<Set<Integer>>{ goodNumbers, badNumbers };

    public static Integer[] arrayList;

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

        for ( Set<Integer> numbers : allNumbers )
        {
            System.debug( 'this set' );

            for ( Integer i : numbers )
            {
                System.debug( i );
            }
        }
    }
}
