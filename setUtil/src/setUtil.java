import java.io.BufferedReader;
import java.io.FileReader;

public class setUtil {
    public static void main(String[] args) throws Exception{
        BufferedReader br = new BufferedReader(new FileReader("setUtil/info.txt"));
        String temp = null;
        while ((temp = br.readLine()) != null){
            System.out.println("th.set" + temp.substring(0,1).toUpperCase() + temp.substring(1) +"("+temp+");");
        }
        br.close();
    }
}
