<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
<xsl:strip-space elements="*"/>
<xsl:output omit-xml-declaration="yes" indent="no" encoding="UTF-8" method="xml"/>
<xsl:template match="ParentData"><xsl:text disable-output-escaping="yes"><![CDATA[@*
    For more information on enabling MVC for empty projects, visit http://go.microsoft.com/fwlink/?LinkID=397860
*@
@model MenuModelData 
@inject ]]></xsl:text><xsl:value-of select="ContextName"/><xsl:text disable-output-escaping="yes"><![CDATA[Context context
@{
]]></xsl:text>
<xsl:value-of select="AppName"/>
<xsl:text disable-output-escaping="yes"><![CDATA[.Code.MainMenu mm = new ]]></xsl:text>
<xsl:value-of select="AppName"/>
<xsl:text disable-output-escaping="yes"><![CDATA[.Code.MainMenu(context, Model);
var mainmenu = mm.CreateMainMenu();
}
<header>
    <!-- Sidebar  -->
    <nav id="sidebar">
        <div class="sidebar-header">
            <img alt="Logo" style="width:200px; " src="~/images/Logo.png" />
        </div>
        @Html.Raw(mainmenu)
    </nav>
</header>]]></xsl:text>
</xsl:template>
</xsl:stylesheet>
