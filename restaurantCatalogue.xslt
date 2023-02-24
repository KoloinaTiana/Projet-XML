<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
xmlns:restaurant="http://www.example.com/restaurantCatalogue" 
xmlns:xpath="http://www.w3.org/2005/xpath-functions" 
xmlns:xs="http://www.w3.org/2001/XMLSchema" exclude-result-prefixes="xpath xs">
  
  <xsl:output method="html" encoding="UTF-8" indent="yes"/>

  <!-- paramètres d'entreés de recherche -->
  <xsl:param name="search-xpath" select="''"/>
  <xsl:param name="search-xquery" select="''"/>
  
  <xsl:template match="/">
    <html>
        <head>
            <title>Menu du restaurant</title>
            <style>
          table {
            font-family: arial, sans-serif;
            border-collapse: collapse;
            width: 100%;
          }
          
          td, th {
            border: 1px solid #dddddd;
            text-align: left;
            padding: 8px;
          }
          
          th {
            background-color: #EF6AA2;
            color: white;
          }
        </style>
        </head>
        <body>
            <h1>Menu du restaurant</h1>
            <form method="get">
              <label for="search-xpath">Rechercher par XPath:</label>
              <input type="text" name="search-xpath" value="{normalize-space($search-xpath)}"/>
              <br/>
              <label for="search-xquery">Rechercher par XQuery:</label>
              <input type="text" name="search-xquery" value="{normalize-space($search-xquery)}"/>
              <br/>
              <button type="submit">Rechercher</button>
            </form>
            <table border="1">
                <tr bgcolor="#EF6AA2">
                    <th>Nom</th>
                    <th>Catégorie</th>
                    <th>Description</th>
                    <th>Ingredients</th>
                    <th>Prix</th>
                </tr>
                <!-- Filtrer les éléments plat en fonction des paramètres de recherche -->
                <xsl:variable name="filtered-plats">
                    <xsl:choose>
                        <!-- Si les deux paramètres de recherche sont vides, sélectionner tous les éléments plat -->
                        <xsl:when test="not($search-xpath) and not($search-xquery)">
                            <xsl:copy-of select="//restaurant:plat"/>
                        </xsl:when>
                        <!-- Si seulement le paramètre de recherche XPath est présent, sélectionner les éléments plat qui correspondent à l'expression XPath -->
                        <xsl:when test="$search-xpath">
                            <xsl:copy-of select="//restaurant:plat[$search-xpath]"/>
                        </xsl:when>
                        <!-- Si seulement le paramètre de recherche XQuery est présent, sélectionner les éléments plat qui correspondent à l'expression XQuery -->
                        <xsl:when test="$search-xquery">
                            <xsl:copy-of select="//restaurant:plat[xpath:evaluate($search-xquery)]"/>
                        </xsl:when>
                        <!-- Si les deux paramètres de recherche sont présents, sélectionner les éléments plat qui correspondent à l'expression XPath et à l'expression XQuery -->
                        <xsl:otherwise>
                          <xsl:copy-of select="//restaurant:plat[$search-xpath][xpath:evaluate($search-xquery)]"/>
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:variable>
                <!-- Parcourir les éléments plat filtrés et les afficher dans le tableau -->
                <xsl:apply-templates select="$filtered-plats/restaurant:plat"/> 
            </table>
        </body>
    </html>
</xsl:template>

<xsl:template match="restaurant:plat">
    <tr>
        <td>
            <xsl:value-of select="restaurant:nom"/>
        </td>
        <td>
            <xsl:value-of select="restaurant:categorie"/>
        </td>
        <td>
            <xsl:value-of select="restaurant:description"/>
        </td>
        <td>
          <xsl:for-each select="restaurant:ingredients/restaurant:ingredient">
              <xsl:value-of select="concat('- ',.)"/><br/>
          </xsl:for-each>
        </td>
        <td>
            <xsl:value-of select="concat(restaurant:prix,'€')"/>
        </td>
    </tr>
</xsl:template>

  
</xsl:stylesheet>
