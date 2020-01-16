using System;
using System.Collections.Generic;

namespace EF7Test.Models
{
    public partial class destinations
    {
        public destinations()
        {
            advertiser = new HashSet<advertiser>();
        }

        public int pkey { get; set; }
        public string id { get; set; }
        public int? seq { get; set; }

        public virtual ICollection<advertiser> advertiser { get; set; }
    }
}
