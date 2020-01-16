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
      <xsl:for-each select="ChildData[IsKey = 1][2]">
        <xsl:sort select="OrdinalPosition" data-type="number"/>,<xsl:value-of select="EntityPropertyName"/>
      </xsl:for-each>
    </xsl:variable>
    <xsl:variable name="keyfieldswhere">
      <xsl:for-each select="ChildData[IsKey = 1][1]">
        <xsl:sort select="OrdinalPosition" data-type="number"/>
        <xsl:value-of select="EntityPropertyName"/>
        <xsl:text disable-output-escaping="yes"><![CDATA[ == id && ]]></xsl:text>
      </xsl:for-each>
      <xsl:for-each select="ChildData[IsKey = 1][2]">
        <xsl:sort select="OrdinalPosition" data-type="number"/>
        <xsl:text disable-output-escaping="yes"><![CDATA[m.]]></xsl:text>
        <xsl:value-of select="EntityPropertyName"/>
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
using System.Threading.Tasks;
using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Mvc.Rendering;
using Microsoft.EntityFrameworkCore;
using ]]></xsl:text>
    <xsl:value-of select="AppName"/>
    <xsl:text disable-output-escaping="yes"><![CDATA[.Models;

namespace ]]></xsl:text>
    <xsl:value-of select="AppName"/>
    <xsl:text disable-output-escaping="yes"><![CDATA[.Controllers
{
    public class ]]></xsl:text>
    <xsl:value-of select="EntityClassName"/>
    <xsl:text disable-output-escaping="yes"><![CDATA[Controller : Controller
    {
        private readonly ]]></xsl:text>
    <xsl:value-of select="ContextName"/>
    <xsl:text disable-output-escaping="yes"><![CDATA[Context _context;

        public ]]></xsl:text>
    <xsl:value-of select="EntityClassName"/>
    <xsl:text disable-output-escaping="yes"><![CDATA[Controller(]]></xsl:text>
    <xsl:value-of select="ContextName"/>
    <xsl:text disable-output-escaping="yes"><![CDATA[Context context)
        {
            _context = context;
        }

        // GET: ]]></xsl:text>
    <xsl:value-of select="EntityClassName"/>
    <xsl:text disable-output-escaping="yes"><![CDATA[
        public async Task<IActionResult> Index()
        {
            return View(await _context.]]></xsl:text>
    <xsl:value-of select="EntityClassName"/>
    <xsl:text disable-output-escaping="yes"><![CDATA[.ToListAsync());
        }

        // GET: ]]></xsl:text>
    <xsl:value-of select="EntityClassName"/>
    <xsl:text disable-output-escaping="yes"><![CDATA[/Details/5
        public async Task<IActionResult> Details(]]></xsl:text>
    <xsl:copy-of select="$keydatatype" />
    <xsl:text disable-output-escaping="yes"><![CDATA[? id)
        {
            if (id == null)
            {
                return NotFound();
            }

            var record = await _context.]]></xsl:text>
    <xsl:value-of select="EntityClassName"/>
    <xsl:text disable-output-escaping="yes"><![CDATA[
                .FirstOrDefaultAsync(m => m.]]></xsl:text>
    <xsl:copy-of select="$keyfieldswhere" />
    <xsl:text disable-output-escaping="yes"><![CDATA[ == id);
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
        {]]></xsl:text>
        <xsl:for-each select="ChildData">
          <xsl:sort select="OrdinalPosition" data-type="number"/>
          <xsl:choose>
            <xsl:when test="IsFKey = 1">
              <xsl:text disable-output-escaping="yes"><![CDATA[
            ViewData["]]></xsl:text>
              <xsl:value-of select="EntityPropertyName"/>
              <xsl:text disable-output-escaping="yes"><![CDATA["] = new SelectList(_context.]]></xsl:text>
              <xsl:value-of select="ReferenceTableName"/>
              <xsl:text disable-output-escaping="yes"><![CDATA[, "]]></xsl:text>
              <xsl:value-of select="ReferenceColumnName"/>
              <xsl:text disable-output-escaping="yes"><![CDATA[", "]]></xsl:text>
              <xsl:value-of select="ReferenceColumnName"/>
              <xsl:text disable-output-escaping="yes"><![CDATA[");]]></xsl:text>
            </xsl:when>
            <xsl:otherwise>
            </xsl:otherwise>
          </xsl:choose>
        </xsl:for-each>
        <xsl:text disable-output-escaping="yes"><![CDATA[
            ViewData["detail]]></xsl:text>
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
        {]]></xsl:text>
        <xsl:for-each select="ChildData">
          <xsl:sort select="OrdinalPosition" data-type="number"/>
          <xsl:choose>
            <xsl:when test="IsFKey = 1">
              <xsl:text disable-output-escaping="yes"><![CDATA[
            ViewData["]]></xsl:text>
              <xsl:value-of select="EntityPropertyName"/>
              <xsl:text disable-output-escaping="yes"><![CDATA["] = new SelectList(_context.]]></xsl:text>
              <xsl:value-of select="ReferenceTableName"/>
              <xsl:text disable-output-escaping="yes"><![CDATA[, "]]></xsl:text>
              <xsl:value-of select="ReferenceColumnName"/>
              <xsl:text disable-output-escaping="yes"><![CDATA[", "]]></xsl:text>
              <xsl:value-of select="ReferenceColumnName"/>
              <xsl:text disable-output-escaping="yes"><![CDATA[");]]></xsl:text>
            </xsl:when>
            <xsl:otherwise>
            </xsl:otherwise>
          </xsl:choose>
        </xsl:for-each>
        <xsl:text disable-output-escaping="yes"><![CDATA[
            return View();
        }

        // POST: ]]></xsl:text>
    <xsl:value-of select="EntityClassName"/>
    <xsl:text disable-output-escaping="yes"><![CDATA[/Create
        // To protect from overposting attacks, please enable the specific properties you want to bind to, for 
        // more details see http://go.microsoft.com/fwlink/?LinkId=317598.
        [HttpPost]
        [ValidateAntiForgeryToken]
        public async Task<IActionResult> Create([Bind(]]></xsl:text>
    <xsl:copy-of select="$fields" />
    <xsl:text disable-output-escaping="yes"><![CDATA[)] ]]></xsl:text>
    <xsl:value-of select="EntityClassName"/>
    <xsl:text disable-output-escaping="yes"><![CDATA[ record)
        {
            if (ModelState.IsValid)
            {
                _context.Add(record);
                await _context.SaveChangesAsync();
                return RedirectToAction(nameof(Index));
            }
]]></xsl:text>
            <xsl:for-each select="ChildData">
              <xsl:sort select="OrdinalPosition" data-type="number"/>
              <xsl:choose>
                <xsl:when test="IsFKey = 1">
                  <xsl:text disable-output-escaping="yes"><![CDATA[
            ViewData["]]></xsl:text>
                  <xsl:value-of select="EntityPropertyName"/>
                  <xsl:text disable-output-escaping="yes"><![CDATA["] = new SelectList(_context.]]></xsl:text>
                  <xsl:value-of select="ReferenceTableName"/>
                  <xsl:text disable-output-escaping="yes"><![CDATA[, "]]></xsl:text>
                  <xsl:value-of select="ReferenceColumnName"/>
                  <xsl:text disable-output-escaping="yes"><![CDATA[", "]]></xsl:text>
                  <xsl:value-of select="ReferenceColumnName"/>
                  <xsl:text disable-output-escaping="yes"><![CDATA[");]]></xsl:text>
                </xsl:when>
                <xsl:otherwise>
                </xsl:otherwise>
              </xsl:choose>
            </xsl:for-each>
            <xsl:text disable-output-escaping="yes"><![CDATA[
            return View(record);
        }

        // GET: ]]></xsl:text>
    <xsl:value-of select="EntityClassName"/>
    <xsl:text disable-output-escaping="yes"><![CDATA[/Edit/5
        public async Task<IActionResult> Edit(]]></xsl:text>
    <xsl:copy-of select="$keydatatype" />
    <xsl:text disable-output-escaping="yes"><![CDATA[? id)
        {
            if (id == null)
            {
                return NotFound();
            }

            var record = await _context.]]></xsl:text>
    <xsl:value-of select="EntityClassName"/>
    <xsl:text disable-output-escaping="yes"><![CDATA[.FindAsync(id);
            if (record == null)
            {
                return NotFound();
            }
            //Remove [ChangeToForeignTable] to Foreign Table value for Lines
            //ViewData["detail[ChangeToForeignTable]Recnum"] = 0;

]]></xsl:text>
    <xsl:for-each select="ChildData">
      <xsl:sort select="OrdinalPosition" data-type="number"/>
      <xsl:choose>
        <xsl:when test="IsFKey = 1">
          <xsl:text disable-output-escaping="yes"><![CDATA[
            ViewData["]]></xsl:text>
          <xsl:value-of select="EntityPropertyName"/>
          <xsl:text disable-output-escaping="yes"><![CDATA["] = new SelectList(_context.]]></xsl:text>
          <xsl:value-of select="ReferenceTableName"/>
          <xsl:text disable-output-escaping="yes"><![CDATA[, "]]></xsl:text>
          <xsl:value-of select="ReferenceColumnName"/>
          <xsl:text disable-output-escaping="yes"><![CDATA[", "]]></xsl:text>
          <xsl:value-of select="ReferenceColumnName"/>
          <xsl:text disable-output-escaping="yes"><![CDATA[", record.]]></xsl:text>
          <xsl:value-of select="EntityPropertyName"/>
          <xsl:text disable-output-escaping="yes"><![CDATA[);]]></xsl:text>
        </xsl:when>
        <xsl:otherwise>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:for-each>
    <xsl:text disable-output-escaping="yes"><![CDATA[
            return View(record);
        }

        // POST: records/Edit/5
        // To protect from overposting attacks, please enable the specific properties you want to bind to, for 
        // more details see http://go.microsoft.com/fwlink/?LinkId=317598.
        [HttpPost]
        [ValidateAntiForgeryToken]
        public async Task<IActionResult> Edit(]]></xsl:text>
    <xsl:copy-of select="$keydatatype" />
    <xsl:text disable-output-escaping="yes"><![CDATA[ id, [Bind(]]></xsl:text>
    <xsl:copy-of select="$fields" />
    <xsl:text disable-output-escaping="yes"><![CDATA[)] ]]></xsl:text>
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
                    _context.Update(record);
                    await _context.SaveChangesAsync();
                }
                catch (DbUpdateConcurrencyException)
                {
                    if (!]]></xsl:text>
    <xsl:value-of select="EntityClassName"/>
    <xsl:text disable-output-escaping="yes"><![CDATA[Exists(record.Id))
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
        
]]></xsl:text>
            <xsl:for-each select="ChildData">
              <xsl:sort select="OrdinalPosition" data-type="number"/>
              <xsl:choose>
                <xsl:when test="IsFKey = 1">
                  <xsl:text disable-output-escaping="yes"><![CDATA[
            ViewData["]]></xsl:text>
                  <xsl:value-of select="EntityPropertyName"/>
                  <xsl:text disable-output-escaping="yes"><![CDATA["] = new SelectList(_context.]]></xsl:text>
                  <xsl:value-of select="ReferenceTableName"/>
                  <xsl:text disable-output-escaping="yes"><![CDATA[, "]]></xsl:text>
                  <xsl:value-of select="ReferenceColumnName"/>
                  <xsl:text disable-output-escaping="yes"><![CDATA[", "]]></xsl:text>
                  <xsl:value-of select="ReferenceColumnName"/>
                  <xsl:text disable-output-escaping="yes"><![CDATA[", record.]]></xsl:text>
                  <xsl:value-of select="EntityPropertyName"/>
                  <xsl:text disable-output-escaping="yes"><![CDATA[);]]></xsl:text>
                </xsl:when>
                <xsl:otherwise>
                </xsl:otherwise>
              </xsl:choose>
            </xsl:for-each>
            <xsl:text disable-output-escaping="yes"><![CDATA[
            return View(record);
        }

        // GET: ]]></xsl:text>
    <xsl:value-of select="EntityClassName"/>
    <xsl:text disable-output-escaping="yes"><![CDATA[/Delete/5
        public async Task<IActionResult> Delete(]]></xsl:text>
    <xsl:copy-of select="$keydatatype" />
    <xsl:text disable-output-escaping="yes"><![CDATA[? id)
        {
            if (id == null)
            {
                return NotFound();
            }

            var record = await _context.]]></xsl:text>
    <xsl:value-of select="EntityClassName"/>
    <xsl:text disable-output-escaping="yes"><![CDATA[
                .FirstOrDefaultAsync(m => m.]]></xsl:text>
    <xsl:copy-of select="$keyfieldswhere" />
    <xsl:text disable-output-escaping="yes"><![CDATA[ == id);
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
            var record = await _context.]]></xsl:text>
    <xsl:value-of select="EntityClassName"/>
    <xsl:text disable-output-escaping="yes"><![CDATA[.FindAsync(id);
            _context.]]></xsl:text>
    <xsl:value-of select="EntityClassName"/>
    <xsl:text disable-output-escaping="yes"><![CDATA[.Remove(record);
            await _context.SaveChangesAsync();
            return RedirectToAction(nameof(Index));
        }

        private bool ]]></xsl:text>
    <xsl:value-of select="EntityClassName"/>
    <xsl:text disable-output-escaping="yes"><![CDATA[Exists(]]></xsl:text>
    <xsl:copy-of select="$keydatatype" />
    <xsl:text disable-output-escaping="yes"><![CDATA[ id)
        {
            return _context.]]></xsl:text>
    <xsl:value-of select="EntityClassName"/>
    <xsl:text disable-output-escaping="yes"><![CDATA[.Any(m => m.]]></xsl:text>
    <xsl:copy-of select="$keyfieldswhere" />
    <xsl:text disable-output-escaping="yes"><![CDATA[ == id);
        }
    }
}]]></xsl:text>
  </xsl:template>
</xsl:stylesheet>
