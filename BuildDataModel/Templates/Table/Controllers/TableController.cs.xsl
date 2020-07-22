<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
  <xsl:strip-space elements="*"/>
  <xsl:output omit-xml-declaration="yes" indent="no" encoding="UTF-8" method="xml"/>
  <xsl:key name="propertyName" match="ChildData" use="@EntityPropertyName" />
  <xsl:template match="ParentData">
    <xsl:variable name="keydatatype">
      <xsl:for-each select="ChildData[IsKey = 1][1]">
        <xsl:sort select="OrdinalPosition" data-type="number"/>
        <xsl:value-of select="DataType"/>
      </xsl:for-each>
    </xsl:variable>
    <xsl:variable name="keyfields">
      <xsl:for-each select="ChildData[IsKey = 1][1]">
        <xsl:sort select="OrdinalPosition" data-type="number"/>
        <xsl:value-of select="EntityPropertyName"/>
      </xsl:for-each>
    </xsl:variable>
    <xsl:variable name="keyfieldswhere">
      <xsl:for-each select="ChildData[IsKey = 1][1]">
        <xsl:sort select="OrdinalPosition" data-type="number"/>
        <xsl:value-of select="EntityPropertyName"/>
        <xsl:text disable-output-escaping="yes"><![CDATA[ == id]]></xsl:text>
      </xsl:for-each>
    </xsl:variable>
    <xsl:variable name="fields">
      <xsl:text disable-output-escaping="yes"><![CDATA["]]></xsl:text>
      <xsl:for-each select="ChildData[IsKey = 1][1]">
        <xsl:sort select="OrdinalPosition" data-type="number"/>
        <xsl:value-of select="EntityPropertyName"/>
      </xsl:for-each>
      <xsl:for-each select="ChildData[IsKey = 0]">
        <xsl:sort select="OrdinalPosition" data-type="number"/>
        <xsl:text disable-output-escaping="yes"><![CDATA[,]]></xsl:text>
        <xsl:value-of select="EntityPropertyName"/>
      </xsl:for-each>
      <xsl:text disable-output-escaping="yes"><![CDATA["]]></xsl:text>
    </xsl:variable>
    <xsl:text disable-output-escaping="yes"><![CDATA[using System;
using System.Collections.Generic;
using System.Linq;
using System.Security.Claims;
using System.Threading.Tasks;
using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Mvc.Rendering;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Http;
using Microsoft.EntityFrameworkCore;
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
    //[Authorize(Roles = AppBase.RoleAdmin)]
    [Authorize]
    public class ]]></xsl:text>
    <xsl:value-of select="EntityClassName"/>
    <xsl:text disable-output-escaping="yes"><![CDATA[Controller : Controller
    {
        private readonly ]]></xsl:text>
    <xsl:value-of select="ContextName"/>
    <xsl:text disable-output-escaping="yes"><![CDATA[Context _context;
        private readonly ]]></xsl:text>
    <xsl:value-of select="EntityClassName"/>
    <xsl:text disable-output-escaping="yes"><![CDATA[Business _business;

        public ]]></xsl:text>
    <xsl:value-of select="EntityClassName"/>
    <xsl:text disable-output-escaping="yes"><![CDATA[Controller(]]></xsl:text>
    <xsl:value-of select="ContextName"/>
    <xsl:text disable-output-escaping="yes"><![CDATA[Context context)
        {
            _context = context;
            _business = new ]]></xsl:text>
    <xsl:value-of select="EntityClassName"/>
    <xsl:text disable-output-escaping="yes"><![CDATA[Business(_context);
        }

       // GET: ]]></xsl:text>
    <xsl:value-of select="EntityClassName"/>
    <xsl:text disable-output-escaping="yes"><![CDATA[
        public async Task<IActionResult> Index()
        {
            int pg = Convert.ToInt32(CookieRead("]]></xsl:text>
        <xsl:value-of select="EntityClassName"/>
        <xsl:text disable-output-escaping="yes"><![CDATA[Page") ?? "1");
            ]]></xsl:text>
    <xsl:value-of select="EntityClassName"/>
    <xsl:text disable-output-escaping="yes"><![CDATA[Pager pgr = new ]]></xsl:text>
    <xsl:value-of select="EntityClassName"/>
    <xsl:text disable-output-escaping="yes"><![CDATA[Pager
            {
                ObjList = await _business.ListAsync(),
                PageNumber = pg
            };

            return View(pgr);
        }

        [HttpPost]
        public async Task<IActionResult> Index(]]></xsl:text>
    <xsl:value-of select="EntityClassName"/>
    <xsl:text disable-output-escaping="yes"><![CDATA[Pager pgr)
        {
            CookieWrite("]]></xsl:text>
        <xsl:value-of select="EntityClassName"/>
        <xsl:text disable-output-escaping="yes"><![CDATA[Page", pgr.PageNumber.ToString(), 10);
            pgr.ObjList = await _business.ListAsync();
            return View(pgr);
        }

        // GET: ]]></xsl:text>
    <xsl:value-of select="EntityClassName"/>
    <xsl:text disable-output-escaping="yes"><![CDATA[/Details/5
        public async Task<IActionResult> Details(]]></xsl:text>
    <xsl:copy-of select="$keydatatype" />
    <xsl:choose>
      <xsl:when test="$keydatatype = 'int'">
        <xsl:text disable-output-escaping="yes"><![CDATA[?]]></xsl:text>
      </xsl:when>
    </xsl:choose>
    <xsl:text disable-output-escaping="yes"><![CDATA[ id)
        {
            if (id == null)
            {
                return NotFound();
            }

            var record = await _business.ReadAsync((]]></xsl:text>
    <xsl:copy-of select="$keydatatype" />
    <xsl:text disable-output-escaping="yes"><![CDATA[)id);
            if (record == null)
            {
                return NotFound();
            }

            return View(record);
        }

        // GET: ]]></xsl:text>
    <xsl:value-of select="EntityClassName"/>
    <xsl:text disable-output-escaping="yes"><![CDATA[/Line/0
        public IActionResult Line(int id)
        {
            BuildSelectData(null);
            ViewData["]]></xsl:text>
    <xsl:value-of select="EntityClassName"/>
    <xsl:text disable-output-escaping="yes"><![CDATA[Recnum"] = id;
            return View(new ]]></xsl:text>
    <xsl:value-of select="EntityClassName"/>
    <xsl:text disable-output-escaping="yes"><![CDATA[());
        }

        // GET: ]]></xsl:text>
    <xsl:value-of select="EntityClassName"/>
    <xsl:text disable-output-escaping="yes"><![CDATA[/Create
        public IActionResult Create()
        {
            BuildSelectData(null);
            return View(new ]]></xsl:text>
            <xsl:value-of select="EntityClassName"/>
            <xsl:text disable-output-escaping="yes"><![CDATA[());
        }

        // POST: ]]></xsl:text>
    <xsl:value-of select="EntityClassName"/>
    <xsl:text disable-output-escaping="yes"><![CDATA[/Create
        // To protect from overposting attacks, please enable the specific properties you want to bind to, for 
        // more details see http://go.microsoft.com/fwlink/?LinkId=317598.
        [HttpPost]
        [ValidateAntiForgeryToken]
        public async Task<IActionResult> Create(]]></xsl:text>
    <xsl:value-of select="EntityClassName"/>
    <xsl:text disable-output-escaping="yes"><![CDATA[ record)
        {
            if (ModelState.IsValid)
            {
                await _business.CreateAsync(record);
                return RedirectToAction(nameof(Index));
            }

            BuildSelectData(record);
            return View(record);
        }

        // GET: ]]></xsl:text>
    <xsl:value-of select="EntityClassName"/>
    <xsl:text disable-output-escaping="yes"><![CDATA[/Edit/5
        public async Task<IActionResult> Edit(]]></xsl:text>
    <xsl:copy-of select="$keydatatype" />
    <xsl:choose>
      <xsl:when test="$keydatatype = 'int'">
        <xsl:text disable-output-escaping="yes"><![CDATA[?]]></xsl:text>
      </xsl:when>
    </xsl:choose>
    <xsl:text disable-output-escaping="yes"><![CDATA[ id)
        {
            if (id == null)
            {
                return NotFound();
            }

            var record = await _business.ReadAsync((]]></xsl:text>
    <xsl:copy-of select="$keydatatype" />
    <xsl:text disable-output-escaping="yes"><![CDATA[)id);
            if (record == null)
            {
                return NotFound();
            }

            BuildSelectData(record);
            return View(record);
        }

        // POST: records/Edit/5
        // To protect from overposting attacks, please enable the specific properties you want to bind to, for 
        // more details see http://go.microsoft.com/fwlink/?LinkId=317598.
        [HttpPost]
        [ValidateAntiForgeryToken]
        public async Task<IActionResult> Edit(]]></xsl:text>
    <xsl:copy-of select="$keydatatype" />
    <xsl:text disable-output-escaping="yes"><![CDATA[ id, ]]></xsl:text>
    <xsl:value-of select="EntityClassName"/>
    <xsl:text disable-output-escaping="yes"><![CDATA[ record)
        {
            if (id != record.]]></xsl:text>
    <xsl:copy-of select="$keyfields" />
    <xsl:text disable-output-escaping="yes"><![CDATA[)
            {
                return NotFound();
            }

            if (ModelState.IsValid)
            {
                try
                {
                    await _business.UpdateAsync(record);
                }
                catch (DbUpdateConcurrencyException)
                {
                    if (!_business.RecordExsist(record.]]></xsl:text>
    <xsl:copy-of select="$keyfields" />
    <xsl:text disable-output-escaping="yes"><![CDATA[))
                    {
                        return NotFound();
                    }
                    else
                    {
                        throw;
                    }
                }
                return RedirectToAction(nameof(Index));
            }
        
            BuildSelectData(record);
            return View(record);
        }

        // GET: ]]></xsl:text>
    <xsl:value-of select="EntityClassName"/>
    <xsl:text disable-output-escaping="yes"><![CDATA[/Delete/5
        public async Task<IActionResult> Delete(]]></xsl:text>
    <xsl:copy-of select="$keydatatype" />
    <xsl:choose>
      <xsl:when test="$keydatatype = 'int'">
        <xsl:text disable-output-escaping="yes"><![CDATA[?]]></xsl:text>
      </xsl:when>
    </xsl:choose>
    <xsl:text disable-output-escaping="yes"><![CDATA[ id)
        {
            if (id == null)
            {
                return NotFound();
            }

            var record = await _business.ReadAsync((]]></xsl:text>
    <xsl:copy-of select="$keydatatype" />
    <xsl:text disable-output-escaping="yes"><![CDATA[)id);
            if (record == null)
            {
                return NotFound();
            }

            return View(record);
        }

        // POST: ]]></xsl:text>
    <xsl:value-of select="EntityClassName"/>
    <xsl:text disable-output-escaping="yes"><![CDATA[/Delete/5
        [HttpPost, ActionName("Delete")]
        [ValidateAntiForgeryToken]
        public async Task<IActionResult> DeleteConfirmed(]]></xsl:text>
    <xsl:copy-of select="$keydatatype" />
    <xsl:text disable-output-escaping="yes"><![CDATA[ id)
        {
            await _business.DeleteAsync((]]></xsl:text>
    <xsl:copy-of select="$keydatatype" />
    <xsl:text disable-output-escaping="yes"><![CDATA[)id);
            return RedirectToAction(nameof(Index));
        }

        private void BuildSelectData(]]></xsl:text>
    <xsl:value-of select="EntityClassName"/>
    <xsl:text disable-output-escaping="yes"><![CDATA[ record)
        {
            foreach(var rec in _business.BuildSelectData(record))
            {
                ViewData.Add(rec);
            }
]]></xsl:text>
            <xsl:for-each select="FKeys">
              <xsl:sort select="OrdinalPosition" data-type="number"/>
                  <xsl:text disable-output-escaping="yes"><![CDATA[
            foreach (var rec in (new ]]></xsl:text>
                  <xsl:value-of select="FKeyEntityName"/>
                  <xsl:text disable-output-escaping="yes"><![CDATA[Business(_context)).BuildSelectData(null))
            {
                if (!ViewData.ContainsKey(rec.Key))
                {
                    ViewData.Add(rec);
                }
            }
]]></xsl:text>
            </xsl:for-each>
            <xsl:text disable-output-escaping="yes"><![CDATA[
        }

        private void CookieWrite(string Key, string Value, int? ExpiresIn)
        {
            CookieOptions options = new CookieOptions();
            if (ExpiresIn.HasValue)
            {
                options.Expires = DateTime.Now.AddMinutes(ExpiresIn.Value);
            }
            else
            {
                options.Expires = DateTime.Now.AddMilliseconds(10);
            }
            HttpContext.Response.Cookies.Append(Key, Value, options);
        }

        private string CookieRead(string Key) 
        {
            return HttpContext.Request.Cookies[Key];
        }
    }
}]]></xsl:text>
  </xsl:template>
</xsl:stylesheet>
