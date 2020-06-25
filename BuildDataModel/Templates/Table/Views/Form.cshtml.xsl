<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
  <xsl:strip-space elements="*"/>
  <xsl:output omit-xml-declaration="yes" indent="no"/>
  <xsl:template match="ParentData">
    @model <xsl:value-of select="AppName"/>.Models.<xsl:value-of select="EntityClassName"/>
    <xsl:text disable-output-escaping="yes"><![CDATA[
            <div class="table-responsive borderless">
              <table class="table-responsive borderless">]]></xsl:text>
    <xsl:apply-templates select="ChildData[IsKey=0]">
      <xsl:sort select="OrdinalPosition" data-type="number"/>
    </xsl:apply-templates>
    <xsl:text disable-output-escaping="yes"><![CDATA[
              </table>
            </div>
            @{]]></xsl:text>
    <xsl:apply-templates select="FKeys">
    </xsl:apply-templates>
    <xsl:text disable-output-escaping="yes"><![CDATA[
             }]]></xsl:text>
  </xsl:template>
  <xsl:template match="FKeys">
    <xsl:text disable-output-escaping="yes"><![CDATA[
               await Html.RenderPartialAsync("..\\]]></xsl:text>
    <xsl:value-of select="FKeyEntityName"/>
    <xsl:text disable-output-escaping="yes"><![CDATA[\\Lines", Model.]]></xsl:text>
    <xsl:value-of select="FKeyEntityName"/>
    <xsl:text disable-output-escaping="yes"><![CDATA[);]]></xsl:text>
  </xsl:template>
  <xsl:template match="ChildData">
    <xsl:text disable-output-escaping="yes"><![CDATA[
            <tr>
                <td>
                    <label class="control-label" asp-for="]]></xsl:text>
    <xsl:value-of select="EntityPropertyName"/>
    <xsl:text disable-output-escaping="yes"><![CDATA["></label>
                </td>
                <td>
                    <div class="input-group">
                        ]]></xsl:text>
    <xsl:choose>
      <xsl:when test="IsFKey = 1">
        <xsl:text disable-output-escaping="yes"><![CDATA[<select asp-for="]]></xsl:text>
        <xsl:value-of select="EntityPropertyName"/>
        <xsl:text disable-output-escaping="yes"><![CDATA[" class="form-control" asp-items="ViewBag.]]></xsl:text>
        <xsl:value-of select="EntityPropertyName"/>
        <xsl:text disable-output-escaping="yes"><![CDATA[" placeholder="@Html.DisplayNameFor(model => model.]]></xsl:text>
        <xsl:value-of select="EntityPropertyName"/>
        <xsl:text disable-output-escaping="yes"><![CDATA[)"></select>]]></xsl:text>
      </xsl:when>
      <xsl:when test="DataType = 'bool'">
	  		<xsl:text disable-output-escaping="yes"><![CDATA[@Html.CheckBox(Html.DisplayNameFor(model => model.]]></xsl:text>
			        <xsl:value-of select="EntityPropertyName"/>
        <xsl:text disable-output-escaping="yes"><![CDATA[), Model.]]></xsl:text>
		        <xsl:value-of select="EntityPropertyName"/>
        <xsl:text disable-output-escaping="yes"><![CDATA[ ?? false, new { Class = "" })]]></xsl:text>
      </xsl:when>
      <xsl:otherwise>
        <xsl:text disable-output-escaping="yes"><![CDATA[
                        <input asp-for="]]></xsl:text>
        <xsl:value-of select="EntityPropertyName"/>
        <xsl:text disable-output-escaping="yes"><![CDATA[" class="form-control" placeholder="@Html.DisplayNameFor(model => model.]]></xsl:text>
        <xsl:value-of select="EntityPropertyName"/>
        <xsl:text disable-output-escaping="yes"><![CDATA[)" />
                        <span asp-validation-for="]]></xsl:text>
        <xsl:value-of select="EntityPropertyName"/>
        <xsl:text disable-output-escaping="yes"><![CDATA[" class="text-danger"></span>]]></xsl:text>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:text disable-output-escaping="yes"><![CDATA[
                    </div>
                </td>
            </tr>]]></xsl:text>
  </xsl:template>
</xsl:stylesheet>
