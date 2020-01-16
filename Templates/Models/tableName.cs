using System;
using System.Collections.Generic;

namespace <AppName>.Models
{
    public partial class <TableName>
    {
        //public <TableName>()
        //{
        //    xref_catadv = new HashSet<xref_catadv>();
        //}

        public int <ColumnName> { get; set; }
        public string <ColumnName> { get; set; }
        public DateTime? <ColumnName> { get; set; }
        public int? <ColumnName> { get; set; }
        public decimal? <ColumnName> { get; set; }
        
        //public virtual ICollection<xref_catadv> xref_catadv { get; set; }
        //public virtual destinations destinationkeyNavigation { get; set; }
    }
}
