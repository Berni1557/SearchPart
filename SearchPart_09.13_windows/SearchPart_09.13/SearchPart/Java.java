import java.io.BufferedReader;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.io.OutputStreamWriter;
import java.net.HttpURLConnection;
import java.net.URL;
import java.net.URLEncoder;

public class Java
{
public static void main(String args[]) throws IOException
{
	int baLength;
	byte[] ba1 = new byte[1024];
	String body = "datasheet=" + URLEncoder.encode( args[1], "UTF-8" ) + "&" +
            "dir=" + URLEncoder.encode( args[2], "UTF-8" )  + "&" +
            "file=" + URLEncoder.encode( args[3], "UTF-8" )  + "&" +
			"database=" + URLEncoder.encode( args[4], "UTF-8" );

URL url = new URL( "http://www.datasheetarchive.com/pdf/download.php" );
HttpURLConnection connection = (HttpURLConnection) url.openConnection();
connection.setRequestMethod( "POST" );
connection.setDoInput( true );
connection.setDoOutput( true );
connection.setUseCaches( false );
connection.setRequestProperty( "Content-Type",
                             "application/x-www-form-urlencoded" );
connection.setRequestProperty( "Content-Length", String.valueOf(body.length()) );

OutputStreamWriter writer = new OutputStreamWriter( connection.getOutputStream() );
writer.write( body );
writer.flush();
//java.io.FileOutputStream fos=(FileOutputStream) connection.getOutputStream();

String ty=connection.getContentType();

BufferedReader reader = new BufferedReader(
                        new InputStreamReader(connection.getInputStream()) );

//FileOutputStream fos1 = new FileOutputStream("datasheets/IT8705F.pdf");
FileOutputStream fos1 = new FileOutputStream(args[0]);
InputStream is1 = connection.getInputStream();
while ((baLength = is1.read(ba1)) != -1) {
    fos1.write(ba1, 0, baLength);
}
fos1.flush();
fos1.close();
is1.close();
/*
for ( String line; (line = reader.readLine()) != null; )
{
System.out.println( line );
}
*/
writer.close();
reader.close();
}
}

