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
    ViewData["Title"] = "Create";
}

<h1>Create ]]></xsl:text>
    <xsl:value-of select="EntityClassName"/>
    <xsl:text disable-output-escaping="yes"><![CDATA[</h1>
<hr />
<form asp-action="Create">
    <div asp-validation-summary="ModelOnly" class="text-danger"></div>
    <div class="table-responsive borderless">
        <table class="table">]]></xsl:text>
    <xsl:apply-templates select="ChildData[IsKey=1][1]">
      <xsl:sort select="OrdinalPosition" data-type="number"/>
    </xsl:apply-templates>
    <xsl:apply-templates select="ChildData[IsKey=0]">
      <xsl:sort select="OrdinalPosition" data-type="number"/>
    </xsl:apply-templates>
    <xsl:text disable-output-escaping="yes"><![CDATA[
        </table>
    </div>
    @*@{//UnRemark add line enties here
            await Html.RenderPartialAsync("..\\LineTable\\Lines", new List<LinesType>());
        }*@
    <div class="form-group">
        <input type="submit" value="Create" class="btn btn-primary" />
    </div>
</form>
<div>
    <a asp-action="Index">Back to List</a>
</div>

@section Scripts {
    @{await Html.RenderPartialAsync("_ValidationScriptsPartial");}
}]]></xsl:text>
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
                    <div class="input-group">]]></xsl:text>
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
                        <div class="input-group-append">
                            <div class="input-group-text">
                                <i class="fa fa-search"></i>
                            </div>
                        </div>
                    </div>
                </td>
            </tr>]]></xsl:text>
  </xsl:template>
</xsl:stylesheet>
