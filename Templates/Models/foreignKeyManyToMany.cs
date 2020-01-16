using System;
using System.Collections.Generic;

namespace EF7Test.Models
{
    public partial class xref_catadv
    {
        public int pkey { get; set; }
        public int? advkey { get; set; }
        public int? catkey { get; set; }

        public virtual advertiser advkeyNavigation { get; set; }
        public virtual categories catkeyNavigation { get; set; }
    }
}
