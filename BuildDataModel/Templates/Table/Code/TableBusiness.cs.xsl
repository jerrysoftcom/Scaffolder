<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
<xsl:strip-space elements="*"/>
<xsl:output omit-xml-declaration="yes" indent="no" encoding="UTF-8" method="xml"/>
<xsl:template match="ParentData"><xsl:text disable-output-escaping="yes"><![CDATA[using Microsoft.EntityFrameworkCore;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using ]]></xsl:text><xsl:value-of select="AppName"/><xsl:text disable-output-escaping="yes"><![CDATA[.Models;

namespace ]]></xsl:text><xsl:value-of select="AppName"/><xsl:text disable-output-escaping="yes"><![CDATA[.Code
{
    public class ]]></xsl:text><xsl:value-of select="EntityClassName"/><xsl:text disable-output-escaping="yes"><![CDATA[Business
    {
        private readonly ]]></xsl:text><xsl:value-of select="ContextName"/><xsl:text disable-output-escaping="yes"><![CDATA[Context _context;

        public ]]></xsl:text><xsl:value-of select="EntityClassName"/><xsl:text disable-output-escaping="yes"><![CDATA[Business(]]></xsl:text><xsl:value-of select="ContextName"/><xsl:text disable-output-escaping="yes"><![CDATA[Context context)
        {
            _context = context;
        }

        // List
        public List<]]></xsl:text><xsl:value-of select="EntityClassName"/><xsl:text disable-output-escaping="yes"><![CDATA[> List()
        {
            return _context.]]></xsl:text><xsl:value-of select="EntityClassName"/><xsl:text disable-output-escaping="yes"><![CDATA[.ToList();
        }
        public async Task<List<]]></xsl:text><xsl:value-of select="EntityClassName"/><xsl:text disable-output-escaping="yes"><![CDATA[>> ListAsync()
        {
            return await _context.]]></xsl:text><xsl:value-of select="EntityClassName"/><xsl:text disable-output-escaping="yes"><![CDATA[.ToListAsync();
        }
        // Create
        public ]]></xsl:text><xsl:value-of select="EntityClassName"/><xsl:text disable-output-escaping="yes"><![CDATA[ Create(]]></xsl:text><xsl:value-of select="EntityClassName"/><xsl:text disable-output-escaping="yes"><![CDATA[ record)
        {
            //record.Id = getRecordKey();

            _context.]]></xsl:text><xsl:value-of select="EntityClassName"/><xsl:text disable-output-escaping="yes"><![CDATA[.Add(record);
            _context.SaveChanges();
            return record;
        }
        public async Task<]]></xsl:text><xsl:value-of select="EntityClassName"/><xsl:text disable-output-escaping="yes"><![CDATA[> CreateAsync(]]></xsl:text><xsl:value-of select="EntityClassName"/><xsl:text disable-output-escaping="yes"><![CDATA[ record)
        {
            //record.Id = getRecordKey();

            _context.]]></xsl:text><xsl:value-of select="EntityClassName"/><xsl:text disable-output-escaping="yes"><![CDATA[.Add(record);
            await _context.SaveChangesAsync();
            return record;
        }
        // Read
        public async Task<]]></xsl:text><xsl:value-of select="EntityClassName"/><xsl:text disable-output-escaping="yes"><![CDATA[> ReadAsync(int id)
        {
            return await _context.]]></xsl:text><xsl:value-of select="EntityClassName"/><xsl:text disable-output-escaping="yes"><![CDATA[.FirstOrDefaultAsync(m => m.Id == id);
        }
        public ]]></xsl:text><xsl:value-of select="EntityClassName"/><xsl:text disable-output-escaping="yes"><![CDATA[ Read(int id)
        {
            return _context.]]></xsl:text><xsl:value-of select="EntityClassName"/><xsl:text disable-output-escaping="yes"><![CDATA[.FirstOrDefault(m => m.Id == id);
        }
        // Update
        public async void UpdateAsync(]]></xsl:text><xsl:value-of select="EntityClassName"/><xsl:text disable-output-escaping="yes"><![CDATA[ record)
        {
            _context.Update(record);
            await _context.SaveChangesAsync();
        }
        public void Update(]]></xsl:text><xsl:value-of select="EntityClassName"/><xsl:text disable-output-escaping="yes"><![CDATA[ record)
        {
            _context.Update(record);
            _context.SaveChanges();
        }
        // Delete
        public async void DeleteAsync(int id)
        {
            var record = await _context.]]></xsl:text><xsl:value-of select="EntityClassName"/><xsl:text disable-output-escaping="yes"><![CDATA[.FindAsync(id);
            _context.]]></xsl:text><xsl:value-of select="EntityClassName"/><xsl:text disable-output-escaping="yes"><![CDATA[.Remove(record);
            await _context.SaveChangesAsync();
        }
        public void Delete(int id)
        {
            var record =  _context.]]></xsl:text><xsl:value-of select="EntityClassName"/><xsl:text disable-output-escaping="yes"><![CDATA[.Find(id);
            _context.]]></xsl:text><xsl:value-of select="EntityClassName"/><xsl:text disable-output-escaping="yes"><![CDATA[.Remove(record);
            _context.SaveChanges();
        }

        private int getRecordKey()
        {
            return _context.]]></xsl:text><xsl:value-of select="EntityClassName"/><xsl:text disable-output-escaping="yes"><![CDATA[.ToList().Count() + 1;
        }
    }
}]]></xsl:text>
</xsl:template>
</xsl:stylesheet>