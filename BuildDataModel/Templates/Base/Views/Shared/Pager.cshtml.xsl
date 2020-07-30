<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
<xsl:strip-space elements="*"/>
<xsl:output omit-xml-declaration="yes" indent="no" encoding="UTF-8" method="xml"/>
<xsl:template match="ParentData"><xsl:text disable-output-escaping="yes"><![CDATA[@model ]]></xsl:text>
<xsl:value-of select="AppName"/>
<xsl:text disable-output-escaping="yes"><![CDATA[.Code.ListPager
    <style>
        .pagination {
            display: inline-block;
        }

            .pagination a {
                color: black;
                float: left;
                padding: 8px 16px;
                text-decoration: none;
                border: 1px solid #ddd; /* Gray */
                font-size: 16px;
            }

                .pagination a.active {
                    background-color: #4CAF50;
                    color: white;
                }

                .pagination a:hover:not(.active) {
                    background-color: #ddd;
                }
    </style>
<input type="hidden" value="@Model.PageNumber" id="PageNumber" name="PageNumber" />
<input type="hidden" value="@Model.RecordsPerPage" id="RecordsPerPage" name="RecordsPerPage" />
<div>
    <table style="width:25%; min-width:100px; text-align:center;">
        <tr>
            <td>
                Results @Model.RecordCount
            </td>
            <td>
                <select style="width:70px;" asp-for="RecordsPerPage" name="RecordsPerPage" onchange="document.getElementById('RecordsPerPage').value = this.value; document.getElementById('Pager').submit();">
                    <option value="10">10</option>
                    <option value="20">20</option>
                    <option value="50">50</option>
                    <option value="100">100</option>
                </select>

            </td>
            <td>/ Page</td>
        </tr>
    </table>
</div>
<table style="width:100%; text-align:center">
    <tr>
        <td>
            <div class="pagination">
                <a href="#" onclick="document.getElementById('PageNumber').value = '1'; document.getElementById('Pager').submit();">&laquo;</a>
                @{ 
                    int startPage = Model.PageNumber - 3;
                    int endPage = Model.PageNumber + 3;
                    if(startPage < 1)
                    {
                        startPage = 1;
                    }
                    if(endPage > Model.PageCount)
                    {
                        endPage = Model.PageCount;
                    }
                }
                @for (int i = startPage; i <= endPage; i++)
                {
                    string stle = "white;";
                    if (i == Model.PageNumber) { stle = "darkgrey;"; }
                    <a href="#" style="background-color:@stle" onclick="document.getElementById('PageNumber').value = '@i'; document.getElementById('Pager').submit();">@i</a>
                }
                <a href="#" onclick="document.getElementById('PageNumber').value = '@Model.PageCount'; document.getElementById('Pager').submit();">&raquo;</a>
            </div>
        </td>
    </tr>
</table>]]></xsl:text>
</xsl:template>
</xsl:stylesheet>

