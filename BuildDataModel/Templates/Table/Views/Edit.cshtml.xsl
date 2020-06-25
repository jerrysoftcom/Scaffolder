<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
  <xsl:strip-space elements="*"/>
  <xsl:output omit-xml-declaration="yes" indent="no"/>
  <xsl:template match="ParentData">@model <xsl:value-of select="AppName"/>.Models.<xsl:value-of select="EntityClassName"/>
    <xsl:text disable-output-escaping="yes"><![CDATA[

@{
    ViewData["Title"] = "Edit ]]></xsl:text>
    <xsl:value-of select="EntityClassName"/>
    <xsl:text disable-output-escaping="yes"><![CDATA[";
} 

<h4>@ViewData["Title"]</h4>
<form asp-action="Edit">
    <div asp-validation-summary="ModelOnly" class="text-danger"></div>
            ]]></xsl:text>
    <xsl:for-each select="ChildData[IsKey =1]">
      <xsl:sort select="OrdinalPosition" data-type="number"/>
      <xsl:text disable-output-escaping="yes"><![CDATA[<input type="hidden" asp-for="]]></xsl:text>
      <xsl:value-of select="EntityPropertyName"/>
      <xsl:text disable-output-escaping="yes"><![CDATA[" />]]></xsl:text>
    </xsl:for-each>
    <xsl:text disable-output-escaping="yes"><![CDATA[
    @{
        await Html.RenderPartialAsync("Form", Model);
    }
    <div class="float-button">
        <ul>
            <li><button type="submit" class="btn btn-primary"><i class="fas fa-save"></i></button></li>
            <li><button asp-action="Index" class="btn btn-primary"><i class="fas fa-list"></i></button></li>
        </ul>
    </div>
</form>

@section Scripts {
    @{await Html.RenderPartialAsync("_ValidationScriptsPartial");}
}
]]></xsl:text>
  </xsl:template>
</xsl:stylesheet>
