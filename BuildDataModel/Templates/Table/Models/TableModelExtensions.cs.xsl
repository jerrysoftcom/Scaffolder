<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
  <xsl:strip-space elements="*"/>
  <xsl:output omit-xml-declaration="yes" indent="no" encoding="UTF-8" method="xml"/>
  <xsl:template match="ParentData">
    <xsl:text disable-output-escaping="yes"><![CDATA[using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace ]]></xsl:text>
    <xsl:value-of select="AppName"/>
    <xsl:text disable-output-escaping="yes"><![CDATA[.Models
{]]></xsl:text>
    <xsl:text disable-output-escaping="yes"><![CDATA[
    public partial class ]]></xsl:text>
    <xsl:value-of select="EntityClassName"/>
    <xsl:text disable-output-escaping="yes"><![CDATA[
    {
        [NotMapped]
        public bool ShouldAdd { get; set; }
    }
]]></xsl:text>
    <xsl:text disable-output-escaping="yes"><![CDATA[
}]]></xsl:text>
  </xsl:template>
</xsl:stylesheet>