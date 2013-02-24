// Example of expression parsing
public class Expressions
{
    public Integer getTheAnswer( String life, String theUniverse, String everything )
    {
        return life == 'meaningless' ? ( 6 * 7 - 1 ) * 2 :
            theUniverse == 'big' ? 6 - 7 * ( 1 + 2 ) :
                everything == 'a lot' ? 5 > 4 == 4 > 5 :
                  false;
    }
}
