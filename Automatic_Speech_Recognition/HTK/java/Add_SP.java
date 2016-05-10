public class Add_SP
{
    private String hmm,destination;


    public Add_SP(String hmmdef, String destination)
    {
	this.destination=destination;
	this.hmm=ReadWrite.readfile(hmmdef);
    }

    public void create()
    {
	String sil1=hmm.substring(hmm.indexOf("~h \"sil\""));
	String sil2=sil1.substring(0,sil1.indexOf("<STATE> 3"));

	sil2 += "<TRANSP> 3\n0.000000e+00 1.000000e+00 0.000000e+00\n0.000000e+00 5.000000e-01 5.000000e-01\n0.000000e+00 0.000000e+00 0.000000e+00\n<ENDHMM>";
	sil1 = sil2.substring(sil2.indexOf("<STATE> 2"));
	sil2 = "~h \"sp\"\n<BEGINHMM>\n<NUMSTATES> 3\n" + sil1;

	ReadWrite.writefile(destination, hmm+sil2);
    }

    public static void main(String[] args)
    {
	if (args.length==2)
		new Add_SP(args[0], args[1]).create();
	else
		System.out.println("Add_SP Usage: java Add_SP hmmdefs_file name_of_destination_file");

    }
}