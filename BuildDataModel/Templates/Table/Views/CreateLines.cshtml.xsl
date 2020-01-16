<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
  <xsl:strip-space elements="*"/>
  <xsl:output omit-xml-declaration="yes" indent="no"/>
  <xsl:template match="ParentData">
    <xsl:text disable-output-escaping="yes"><![CDATA[@model ]]></xsl:text>
    <xsl:value-of select="AppName"/>
    <xsl:text disable-output-escaping="yes"><![CDATA[.Models.]]></xsl:text>
    <xsl:value-of select="EntityClassName"/>
    <xsl:text disable-output-escaping="yes"><![CDATA[
<h4>]]></xsl:text>
    <xsl:value-of select="EntityClassName"/>
    <xsl:text disable-output-escaping="yes"><![CDATA[</h4>
<hr />
<div class="row">
    <div class="col-md-4">
        <form asp-action="CreateLines">
            <div asp-validation-summary="ModelOnly" class="text-danger"></div>]]></xsl:text>
    <xsl:apply-templates select="ChildData[IsKey = 0]">
      <xsl:sort select="OrdinalPosition" data-type="number"/>
    </xsl:apply-templates>
    <xsl:text disable-output-escaping="yes"><![CDATA[
            <div class="form-group">
                <input type="submit" value="Create" class="btn btn-primary" />
            </div>
        </form>
    </div>
</div>
<div>
    <a asp-action="Index">Back to List</a>
</div>]]></xsl:text>
  </xsl:template>
  <xsl:template match="ChildData">
    <xsl:text disable-output-escaping="yes"><![CDATA[
            <div class="form-group">
                <label asp-for="]]></xsl:text>
    <xsl:value-of select="EntityPropertyName"/>
    <xsl:text disable-output-escaping="yes"><![CDATA[" class="control-label"></label>
                <input asp-for="]]></xsl:text>
    <xsl:value-of select="EntityPropertyName"/>
    <xsl:text disable-output-escaping="yes"><![CDATA[" class="form-control" />
                <span asp-validation-for="]]></xsl:text>
    <xsl:value-of select="EntityPropertyName"/>
    <xsl:text disable-output-escaping="yes"><![CDATA[" class="text-danger"></span>
            </div>]]></xsl:text>
  </xsl:template>
</xsl:stylesheet>
