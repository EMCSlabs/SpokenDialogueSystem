public class MakeHMMDefs
{
    private String aproto, output;
    private String[] monophones; 


    public MakeHMMDefs(String protofile, String monophones_file)
    {
	this(protofile ,monophones_file, "hmmdefs");
    }

    public MakeHMMDefs(String protofile, String monophones_file, String output)
    {
	this.output=output;
	this.monophones=(ReadWrite.readfile(monophones_file)).split("\n");
	this.aproto=ReadWrite.readfile(protofile);
    }

    public void create()
    {
	String hmmdefs="";

	aproto=aproto.substring((aproto.toLowerCase()).indexOf("<beginhmm>"));
	for (int i=0; i<monophones.length; i++)
	    hmmdefs+="~h \""+monophones[i]+"\"\n"+aproto.trim()+"\n";

	ReadWrite.writefile(output, hmmdefs);
    }

    
    public static void main(String[] args)
    {
	switch(args.length)
	{
	    case 2: new MakeHMMDefs(args[0], args[1]).create(); break;
	    case 3: new MakeHMMDefs(args[0],args[1], args[2]).create(); break;
	    default: System.out.println("MakeHMMDefs Usage: \n java prototype_file monophones_file \n java prototype_file monophones_file name_output_file");
	}
    }
}