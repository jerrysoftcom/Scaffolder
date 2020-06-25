<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
  <xsl:strip-space elements="*"/>
  <xsl:output omit-xml-declaration="yes" indent="no" encoding="UTF-8" method="xml"/>
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
    <xsl:text disable-output-escaping="yes"><![CDATA[using Microsoft.EntityFrameworkCore;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using ]]></xsl:text>
    <xsl:value-of select="AppName"/>
    <xsl:text disable-output-escaping="yes"><![CDATA[.Models;

namespace ]]></xsl:text>
    <xsl:value-of select="AppName"/>
    <xsl:text disable-output-escaping="yes"><![CDATA[.Code
{
    public class ]]></xsl:text>
    <xsl:value-of select="EntityClassName"/>
    <xsl:text disable-output-escaping="yes"><![CDATA[Business
    {
        private readonly ]]></xsl:text>
    <xsl:value-of select="ContextName"/>
    <xsl:text disable-output-escaping="yes"><![CDATA[Context _context;

        public ]]></xsl:text>
    <xsl:value-of select="EntityClassName"/>
    <xsl:text disable-output-escaping="yes"><![CDATA[Business(]]></xsl:text>
    <xsl:value-of select="ContextName"/>
    <xsl:text disable-output-escaping="yes"><![CDATA[Context context)
        {
            _context = context;
        }

        // List
        public List<]]></xsl:text>
    <xsl:value-of select="EntityClassName"/>
    <xsl:text disable-output-escaping="yes"><![CDATA[> List()
        {
            var records = _context.]]></xsl:text>
    <xsl:value-of select="EntityClassName"/>
    <xsl:apply-templates select="FKeys">
    </xsl:apply-templates>
    <xsl:text disable-output-escaping="yes"><![CDATA[.ToList();
            return records;
        }
        public async Task<List<]]></xsl:text>
    <xsl:value-of select="EntityClassName"/>
    <xsl:text disable-output-escaping="yes"><![CDATA[>> ListAsync()
        {
            var records = await _context.]]></xsl:text>
    <xsl:value-of select="EntityClassName"/>
    <xsl:apply-templates select="FKeys">
    </xsl:apply-templates>
    <xsl:text disable-output-escaping="yes"><![CDATA[.ToListAsync();
            return records;
        }
        // Create
        public ]]></xsl:text>
    <xsl:value-of select="EntityClassName"/>
    <xsl:text disable-output-escaping="yes"><![CDATA[ Create(]]></xsl:text>
    <xsl:value-of select="EntityClassName"/>
    <xsl:text disable-output-escaping="yes"><![CDATA[ record)
        {
            //record.Id = getRecordKey();

            _context.]]></xsl:text>
    <xsl:value-of select="EntityClassName"/>
    <xsl:text disable-output-escaping="yes"><![CDATA[.Add(record);
            _context.SaveChanges();
            return record;
        }
        public async Task<]]></xsl:text>
    <xsl:value-of select="EntityClassName"/>
    <xsl:text disable-output-escaping="yes"><![CDATA[> CreateAsync(]]></xsl:text>
    <xsl:value-of select="EntityClassName"/>
    <xsl:text disable-output-escaping="yes"><![CDATA[ record)
        {
            //record.Id = getRecordKey();

            _context.]]></xsl:text>
    <xsl:value-of select="EntityClassName"/>
    <xsl:text disable-output-escaping="yes"><![CDATA[.Add(record);
            await _context.SaveChangesAsync();
            return record;
        }
        // Read
        public ]]></xsl:text>
    <xsl:value-of select="EntityClassName"/>
    <xsl:text disable-output-escaping="yes"><![CDATA[ Read(]]></xsl:text>
    <xsl:copy-of select="$keydatatype" />
    <xsl:text disable-output-escaping="yes"><![CDATA[ id)
        {
            var record = _context.]]></xsl:text>
    <xsl:value-of select="EntityClassName"/>
    <xsl:apply-templates select="FKeys">
    </xsl:apply-templates>
    <xsl:text disable-output-escaping="yes"><![CDATA[.FirstOrDefault(m => m.]]></xsl:text>
    <xsl:copy-of select="$keyfields" />
    <xsl:text disable-output-escaping="yes"><![CDATA[ == id);
            return record;
        }
        public async Task<]]></xsl:text>
    <xsl:value-of select="EntityClassName"/>
    <xsl:text disable-output-escaping="yes"><![CDATA[> ReadAsync(]]></xsl:text>
    <xsl:copy-of select="$keydatatype" />
    <xsl:text disable-output-escaping="yes"><![CDATA[ id)
        {
            var record = await _context.]]></xsl:text>
    <xsl:value-of select="EntityClassName"/>
    <xsl:apply-templates select="FKeys">
    </xsl:apply-templates>
    <xsl:text disable-output-escaping="yes"><![CDATA[.FirstOrDefaultAsync(m => m.]]></xsl:text>
    <xsl:copy-of select="$keyfields" />
    <xsl:text disable-output-escaping="yes"><![CDATA[ == id);
            return record;
        }
        // Update
        public void Update(]]></xsl:text>
    <xsl:value-of select="EntityClassName"/>
    <xsl:text disable-output-escaping="yes"><![CDATA[ record)
        {
            _context.Update(record);
            _context.SaveChanges();
        }
        public async Task UpdateAsync(]]></xsl:text>
    <xsl:value-of select="EntityClassName"/>
    <xsl:text disable-output-escaping="yes"><![CDATA[ record)
        {
            _context.Update(record);
            await _context.SaveChangesAsync();
        }
        // Delete
        public void Delete(]]></xsl:text>
    <xsl:copy-of select="$keydatatype" />
    <xsl:text disable-output-escaping="yes"><![CDATA[ id)
        {
            var record =  _context.]]></xsl:text>
    <xsl:value-of select="EntityClassName"/>
    <xsl:text disable-output-escaping="yes"><![CDATA[.Find(id);
            _context.]]></xsl:text>
    <xsl:value-of select="EntityClassName"/>
    <xsl:text disable-output-escaping="yes"><![CDATA[.Remove(record);
            _context.SaveChanges();
        }
        public async Task DeleteAsync(]]></xsl:text>
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
        }

        public bool RecordExsist(]]></xsl:text>
    <xsl:copy-of select="$keydatatype" />
    <xsl:text disable-output-escaping="yes"><![CDATA[ id)
        {
            return _context.]]></xsl:text>
    <xsl:value-of select="EntityClassName"/>
    <xsl:text disable-output-escaping="yes"><![CDATA[.Any(m => m.]]></xsl:text>
    <xsl:copy-of select="$keyfields" />
    <xsl:text disable-output-escaping="yes"><![CDATA[ == id);
        }

        private int GetRecordKey()
        {
            return _context.]]></xsl:text>
    <xsl:value-of select="EntityClassName"/>
    <xsl:text disable-output-escaping="yes"><![CDATA[.ToList().Count() + 1;
        }
    }

    public class ]]></xsl:text>
    <xsl:value-of select="EntityClassName"/>
    <xsl:text disable-output-escaping="yes"><![CDATA[Pager : ListPager
    {
        private IEnumerable<]]></xsl:text>
    <xsl:value-of select="EntityClassName"/>
    <xsl:text disable-output-escaping="yes"><![CDATA[> _objList; 

        public IEnumerable<]]></xsl:text>
    <xsl:value-of select="EntityClassName"/>
    <xsl:text disable-output-escaping="yes"><![CDATA[> ObjList 
        {
            get
            {
                if (_objList != null)
                {
                    return _objList.Skip((PageNumber - 1) * RecordsPerPage).Take(RecordsPerPage).ToList();
                }
                return null;
            }
            set { _objList = value; RecordCount = value.Count(); }
        }
    }
}]]></xsl:text>
  </xsl:template>
  <xsl:template match="FKeys">
    <xsl:text disable-output-escaping="yes"><![CDATA[.Include(e => e.]]></xsl:text>
    <xsl:value-of select="FKeyEntityName"/>
    <xsl:text disable-output-escaping="yes"><![CDATA[)]]></xsl:text>
  </xsl:template>
</xsl:stylesheet>