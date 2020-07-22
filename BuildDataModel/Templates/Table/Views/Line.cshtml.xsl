<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
  <xsl:strip-space elements="*"/>
  <xsl:output omit-xml-declaration="yes" indent="no"/>
  <xsl:template match="ParentData">
    <xsl:text disable-output-escaping="yes"><![CDATA[@model ]]></xsl:text>
    <xsl:value-of select="AppName"/>
    <xsl:text disable-output-escaping="yes"><![CDATA[.Models.]]></xsl:text>
    <xsl:value-of select="EntityClassName"/>
    <xsl:text disable-output-escaping="yes"><![CDATA[
@{
    Layout = null;
    int rec = (int)(ViewBag.]]></xsl:text>
    <xsl:value-of select="EntityClassName"/>
    <xsl:text disable-output-escaping="yes"><![CDATA[Recnum ?? 0);
]]></xsl:text>
    <xsl:for-each select="ChildData[IsFKey = 1]">
      <xsl:text disable-output-escaping="yes"><![CDATA[
    ViewBag.]]></xsl:text>
      <xsl:value-of select="EntityPropertyName"/>
      <xsl:text disable-output-escaping="yes"><![CDATA[ = new SelectList(ViewBag.]]></xsl:text>
      <xsl:value-of select="EntityPropertyName"/>
      <xsl:text disable-output-escaping="yes"><![CDATA[, "Value", "Text", Model.]]></xsl:text>
      <xsl:value-of select="EntityPropertyName"/>
      <xsl:text disable-output-escaping="yes"><![CDATA[).ToList();
]]></xsl:text>
    </xsl:for-each>
      <xsl:text disable-output-escaping="yes"><![CDATA[
}
<tr>
	<td>
		<input type="hidden" value="true" id="]]></xsl:text>
    <xsl:value-of select="EntityClassName"/>
    <xsl:text disable-output-escaping="yes"><![CDATA[[@rec].shouldadd" name="]]></xsl:text>
    <xsl:value-of select="EntityClassName"/>
    <xsl:text disable-output-escaping="yes"><![CDATA[[@rec].shouldadd" />
		<button id="delete" type="button" onclick="this.parentElement.parentElement.style.display = 'none'; document.getElementById(']]></xsl:text>
    <xsl:value-of select="EntityClassName"/>
    <xsl:text disable-output-escaping="yes"><![CDATA[[@rec].shouldadd').value = 'false';" class="btn btn-sm btn-danger"><i class="fas fa-remove"></i></button>
	</td>
]]></xsl:text>
    <xsl:apply-templates select="ChildData">
      <xsl:sort select="OrdinalPosition" data-type="number"/>
    </xsl:apply-templates>
    <xsl:text disable-output-escaping="yes"><![CDATA[
</tr>]]></xsl:text>
  </xsl:template>
  <xsl:template match="ChildData">
    <xsl:text disable-output-escaping="yes"><![CDATA[<td>]]></xsl:text>
    <xsl:choose>
      <xsl:when test="IsFKey = 1">
        <xsl:text disable-output-escaping="yes"><![CDATA[
		<select id="]]></xsl:text>
        <xsl:value-of select="EntityClassName"/>
        <xsl:text disable-output-escaping="yes"><![CDATA[[@rec].]]></xsl:text>
        <xsl:value-of select="EntityPropertyName"/>
        <xsl:text disable-output-escaping="yes"><![CDATA[" name="]]></xsl:text>
        <xsl:value-of select="EntityClassName"/>
        <xsl:text disable-output-escaping="yes"><![CDATA[[@rec].]]></xsl:text>
        <xsl:value-of select="EntityPropertyName"/>
        <xsl:text disable-output-escaping="yes"><![CDATA[" class="form-control" asp-items="ViewBag.]]></xsl:text>
        <xsl:value-of select="EntityPropertyName"/>
        <xsl:text disable-output-escaping="yes"><![CDATA[" placeholder="@Html.DisplayNameFor(model => model.]]></xsl:text>
        <xsl:value-of select="EntityPropertyName"/>
        <xsl:text disable-output-escaping="yes"><![CDATA[)"></select>
]]></xsl:text>
      </xsl:when>
      <xsl:otherwise>
        <xsl:choose>
          <xsl:when test="DataType = 'bool'">
            <xsl:text disable-output-escaping="yes"><![CDATA[@Html.CheckBox(Html.DisplayNameFor(model => model.]]></xsl:text>
            <xsl:value-of select="EntityPropertyName"/>
            <xsl:text disable-output-escaping="yes"><![CDATA[), Model.]]></xsl:text>
            <xsl:value-of select="EntityPropertyName"/>
            <xsl:text disable-output-escaping="yes"><![CDATA[ ?? false, new { Class = "form-control" })]]></xsl:text>
          </xsl:when>
          <xsl:otherwise>
            <xsl:text disable-output-escaping="yes"><![CDATA[
		<input id="]]></xsl:text>
            <xsl:value-of select="EntityClassName"/>
            <xsl:text disable-output-escaping="yes"><![CDATA[[@rec].]]></xsl:text>
            <xsl:value-of select="EntityPropertyName"/>
            <xsl:text disable-output-escaping="yes"><![CDATA[" name="]]></xsl:text>
            <xsl:value-of select="EntityClassName"/>
            <xsl:text disable-output-escaping="yes"><![CDATA[[@rec].]]></xsl:text>
            <xsl:value-of select="EntityPropertyName"/>
            <xsl:text disable-output-escaping="yes"><![CDATA[" ]]></xsl:text>
            <xsl:choose>
              <xsl:when test="IsKey = 1">
                <xsl:text disable-output-escaping="yes"><![CDATA[type="hidden" ]]></xsl:text>
              </xsl:when>
            </xsl:choose>
            <xsl:text disable-output-escaping="yes"><![CDATA[value="@Model.]]></xsl:text>
            <xsl:value-of select="EntityPropertyName"/>
            <xsl:text disable-output-escaping="yes"><![CDATA[" class="form-control" />]]></xsl:text>
          </xsl:otherwise>
        </xsl:choose>
        <xsl:text disable-output-escaping="yes"><![CDATA[
        <span asp-validation-for="]]></xsl:text>
        <xsl:value-of select="EntityClassName"/>
        <xsl:text disable-output-escaping="yes"><![CDATA[[@rec].]]></xsl:text>
        <xsl:value-of select="EntityPropertyName"/>
        <xsl:text disable-output-escaping="yes"><![CDATA[" class="text-danger"></span>
]]></xsl:text>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:text disable-output-escaping="yes"><![CDATA[</td>
]]></xsl:text>
  </xsl:template>
</xsl:stylesheet>

