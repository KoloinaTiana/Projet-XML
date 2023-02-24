import java.io.File;
import java.io.FileOutputStream;
import java.io.IOException;
import javax.xml.transform.Transformer;
import javax.xml.transform.TransformerException;
import javax.xml.transform.TransformerFactory;
import javax.xml.transform.stream.StreamResult;
import javax.xml.transform.stream.StreamSource;

public class menurestaurant {
    
    public static void main(String[] args) {
        String xmlInput = "restaurantCatalogue.xml";
        String xsltInput = "restaurantCatalogue.xslt";
        String htmlOutput = "restaurantmenu.html";
        
        TransformerFactory factory = TransformerFactory.newInstance();
        try {
            Transformer transformer = factory.newTransformer(new StreamSource(new File(xsltInput)));
            //transformer.setParameter("search-xpath", "//restaurant:plat[restaurant:ingredients[contains(.,'Fromage')]]");
            //transformer.setParameter("search-xquery", "fn:matches(restaurant:description, '.*Oeufs.*')");
            transformer.transform(new StreamSource(new File(xmlInput)), new StreamResult(new FileOutputStream(htmlOutput)));
            System.out.println("Transformation réussie !");
        } catch (TransformerException | IOException e) {
            System.err.println("Erreur de transformation : " + e.getMessage());
        }
    }
}
