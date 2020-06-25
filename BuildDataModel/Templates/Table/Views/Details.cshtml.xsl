<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
  <xsl:strip-space elements="*"/>
  <xsl:output omit-xml-declaration="yes" indent="no"/>
  <xsl:template match="ParentData">
    <xsl:text disable-output-escaping="yes"><![CDATA[
@model ]]></xsl:text>
    <xsl:value-of select="AppName"/>
    <xsl:text disable-output-escaping="yes"><![CDATA[.Models.]]></xsl:text>
    <xsl:value-of select="EntityClassName"/>
    <xsl:text disable-output-escaping="yes"><![CDATA[

@{
    ViewData["Title"] = "Details ]]></xsl:text>
<xsl:value-of select="EntityClassName"/>
<xsl:text disable-output-escaping="yes"><![CDATA[";
} 

<h1>@ViewData["Title"]</h1>

<div>
    <h4>]]></xsl:text>
    <xsl:value-of select="EntityClassName"/>
    <xsl:text disable-output-escaping="yes"><![CDATA[</h4>
    <hr />
    <dl class="row">]]></xsl:text>
    <xsl:for-each select="ChildData">
      <xsl:sort select="OrdinalPosition" data-type="number"/>
      <xsl:choose>
        <xsl:when test="IsKey &lt; 1">
          <xsl:text disable-output-escaping="yes"><![CDATA[
        <dt class = "col-sm-2">
            @Html.DisplayNameFor(model => model.]]></xsl:text>
          <xsl:value-of select="EntityPropertyName"/>
          <xsl:text disable-output-escaping="yes"><![CDATA[)
        </dt>
        <dd class = "col-sm-10">
            @Html.DisplayFor(model => model.]]></xsl:text>
          <xsl:value-of select="EntityPropertyName"/>
          <xsl:text disable-output-escaping="yes"><![CDATA[)
        </dd>]]></xsl:text>
        </xsl:when>
        <xsl:otherwise>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:for-each>
    <xsl:text disable-output-escaping="yes"><![CDATA[
    </dl>]]></xsl:text>
    <xsl:for-each select="ChildData">
      <xsl:choose>
        <xsl:when test="IsKey &gt; 0">
          <xsl:text disable-output-escaping="yes"><![CDATA[
</div>
<div>
    <a asp-action="Edit" asp-route-id="@Model.]]></xsl:text>
          <xsl:value-of select="EntityPropertyName"/>
          <xsl:text disable-output-escaping="yes"><![CDATA[" class="btn btn-primary btn-sm"><i class="fas fa-edit"></i></a> 
    <a asp-action="Index" class="btn btn-primary btn-sm"><i class="fas fa-list"></i></a>
</div>]]></xsl:text>
        </xsl:when>
        <xsl:otherwise>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:for-each>
  </xsl:template>
</xsl:stylesheet>
