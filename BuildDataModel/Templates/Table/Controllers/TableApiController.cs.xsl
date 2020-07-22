<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
  <xsl:strip-space elements="*"/>
  <xsl:output omit-xml-declaration="yes" indent="no" encoding="UTF-8" method="xml"/>
  <xsl:template match="ParentData">
    <xsl:variable name="keyfield">
      <xsl:for-each select="ChildData[IsKey = 1][1]">
        <xsl:sort select="OrdinalPosition" data-type="number"/>
        <xsl:value-of select="EntityPropertyName"/>
      </xsl:for-each>
    </xsl:variable>
    <xsl:variable name="keydatatype">
      <xsl:for-each select="ChildData[IsKey = 1][1]">
        <xsl:sort select="OrdinalPosition" data-type="number"/>
        <xsl:value-of select="DataType"/>
      </xsl:for-each>
    </xsl:variable>
    <xsl:text disable-output-escaping="yes"><![CDATA[using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Mvc.Rendering;
using Microsoft.EntityFrameworkCore;
using Microsoft.AspNetCore.Authorization;
using ]]></xsl:text>
    <xsl:value-of select="AppName"/>
    <xsl:text disable-output-escaping="yes"><![CDATA[.Models;
using ]]></xsl:text>
    <xsl:value-of select="AppName"/>
    <xsl:text disable-output-escaping="yes"><![CDATA[.Code;

namespace ]]></xsl:text>
    <xsl:value-of select="AppName"/>
    <xsl:text disable-output-escaping="yes"><![CDATA[.Controllers
{
    [Authorize] //(Roles = AppBase.RoleAdmin)]
    [ApiController]
    public class ]]></xsl:text>
    <xsl:value-of select="EntityClassName"/>
    <xsl:text disable-output-escaping="yes"><![CDATA[ApiController : Controller
    {
        private readonly ]]></xsl:text>
    <xsl:value-of select="ContextName"/>
    <xsl:text disable-output-escaping="yes"><![CDATA[Context _context;
        private readonly ]]></xsl:text>
    <xsl:value-of select="EntityClassName"/>
    <xsl:text disable-output-escaping="yes"><![CDATA[Business _business;
        private readonly string SelectText = GlobalVariables.SelectString;

        public ]]></xsl:text>
    <xsl:value-of select="EntityClassName"/>
    <xsl:text disable-output-escaping="yes"><![CDATA[ApiController(]]></xsl:text>
    <xsl:value-of select="ContextName"/>
    <xsl:text disable-output-escaping="yes"><![CDATA[Context context)
        {
            _context = context;
            _business = new ]]></xsl:text>
    <xsl:value-of select="EntityClassName"/>
    <xsl:text disable-output-escaping="yes"><![CDATA[Business(_context);
        }

        [Route("api/Get]]></xsl:text>
<xsl:value-of select="EntityClassName"/>
<xsl:text disable-output-escaping="yes"><![CDATA[/{id?}")]
        public IActionResult Get]]></xsl:text>
<xsl:value-of select="EntityClassName"/>
<xsl:text disable-output-escaping="yes"><![CDATA[(string id)
        {
            var ddl = new SelectList(_context.]]></xsl:text>
        <xsl:value-of select="EntityClassName"/>
        <xsl:text disable-output-escaping="yes"><![CDATA[, "]]></xsl:text>
<xsl:copy-of select="$keyfield" />
<xsl:text disable-output-escaping="yes"><![CDATA[", "]]></xsl:text>
<xsl:copy-of select="$keyfield" />
<xsl:text disable-output-escaping="yes"><![CDATA[", id)
            .ToList();
            ddl.Insert(0, new SelectListItem { Value = "", Text = SelectText });
            return new JsonResult(ddl);
        }

        [Route("api/Get]]></xsl:text>
<xsl:value-of select="EntityClassName"/>
<xsl:text disable-output-escaping="yes"><![CDATA[Record/{id}")]
        public async Task<IActionResult> Get]]></xsl:text>
<xsl:value-of select="EntityClassName"/>
<xsl:text disable-output-escaping="yes"><![CDATA[Record(]]></xsl:text>
<xsl:copy-of select="$keydatatype" />
<xsl:text disable-output-escaping="yes"><![CDATA[ id)
        {
            var record = await _business.ReadAsync((]]></xsl:text>
        <xsl:copy-of select="$keydatatype" />
        <xsl:text disable-output-escaping="yes"><![CDATA[)id);
            return new JsonResult(record);
        }

    }
}
]]></xsl:text>
  </xsl:template>
</xsl:stylesheet>
