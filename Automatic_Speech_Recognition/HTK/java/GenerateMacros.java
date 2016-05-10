public class GenerateMacros
{
    private String vFl, destination;


    public GenerateMacros(String vFloors)
    {
	this(vFloors, "macros");
    }

    public GenerateMacros(String vFloors, String destination)
    {
	this.destination=destination;
	this.vFl=ReadWrite.readfile(vFloors);
    }

    public void create()
    {
	ReadWrite.writefile(destination, "~o <MFCC_0_D_A> <VecSize> 39\n" + vFl);
    }

    public static void main(String[] args)
    {
	switch(args.length)
	{
	    case 1: new GenerateMacros(args[0]).create(); break;
	    case 2: new GenerateMacros(args[0], args[1]).create(); break;
	    default: System.out.println("GenerateMacros Usage: \n java vFloors \n java vFloors name_of_output");
	}

    }
}