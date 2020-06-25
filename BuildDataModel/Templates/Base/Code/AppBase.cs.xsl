<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
<xsl:strip-space elements="*"/>
<xsl:output omit-xml-declaration="yes" indent="no" encoding="UTF-8" method="xml"/>
<xsl:template match="ParentData"><xsl:text disable-output-escaping="yes"><![CDATA[using Microsoft.AspNetCore.Cryptography.KeyDerivation;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore.Internal;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Security.Claims;
using System.Text;
using System.Threading.Tasks;
using System.Net.Mail;
using Microsoft.AspNetCore.Mvc.Routing;
using ]]></xsl:text><xsl:value-of select="AppName"/><xsl:text disable-output-escaping="yes"><![CDATA[.Models;

namespace ]]></xsl:text>
<xsl:value-of select="AppName"/>
<xsl:text disable-output-escaping="yes"><![CDATA[.Code

{
    public class GlobalVariables
    {
        public static string SelectString = "Select";
    }

    public class ListPager
    {
        public ListPager() 
        {
            if (RecordsPerPage == 0) { RecordsPerPage = 10; }
            if (PageNumber == 0) { PageNumber = 1; }
        }
       
        public int PageNumber { get; set; }
        public int RecordsPerPage { get; set; }
        public int RecordCount { get; set; }
        public int PageCount { get { return (int)Math.Ceiling((decimal)(RecordCount / (RecordsPerPage * 1.0))); } set { } }
       
    }

    public class PasswordResetData
    {
        public string ResetEmail { get; set; }
        public string ResetKey { get; set; }
    }

    public class AppBase : ControllerBase
    {
        public const string RoleAdmin = "Administrator";
        public const string RoleUser = "User";
        public const string RoleCustomer = "Customer";
        
        public static string GetPasswordHash(string email, string password)
        {
            // generate a 128-bit salt using a secure PRNG
            string saltString = password + email.ToLower();
            byte[] salt = Encoding.ASCII.GetBytes(saltString);

            // derive a 256-bit subkey (use HMACSHA1 with 10,000 iterations)
            string hashed = Convert.ToBase64String(KeyDerivation.Pbkdf2(
                password: password,
                salt: salt,
                prf: KeyDerivationPrf.HMACSHA1,
                iterationCount: 10000,
                numBytesRequested: 256 / 8));

            return hashed;
        }
    }

    public class Tools
    {
        public void PasswordRecovery(string email, string resetKey, string url)
        {
            //System.Net.Mail
            MailAddress to = new MailAddress(email);
            MailAddress from = new MailAddress("example@example.com");
            MailMessage message = new MailMessage(from, to);
            message.Subject = "Password Reset";
            message.Body = @"Click the link to reset your password <a href='" + url + "?resetEmail=" + email + "&resetKey=" + resetKey + "'>Click Here</a>";
            // Use the application or machine configuration to get the 
            // host, port, and credentials.
            SmtpClient client = new SmtpClient();
            message.IsBodyHtml = true;
            client.Host = "smtp.mailserver.com";
            client.Port = 25;
            client.Credentials = new System.Net.NetworkCredential("example@example.com", "password");
            client.EnableSsl = false;
            
            client.Send(message);
        }

		    public void BuildRolesAndUser(]]></xsl:text><xsl:value-of select="ContextName"/><xsl:text disable-output-escaping="yes"><![CDATA[Context context)
        {
            var curroles = context.Coroles.Where(e => e.Name == AppBase.RoleAdmin || e.Name == AppBase.RoleCustomer || e.Name == AppBase.RoleUser).ToList();
            if (curroles.Count == 0)
            {
                var roles = new List<Coroles>();
                roles.Add(new Coroles { Id = Guid.NewGuid().ToString(), Name = AppBase.RoleAdmin, NormalizedName = AppBase.RoleAdmin.ToUpper() });
                roles.Add(new Coroles { Id = Guid.NewGuid().ToString(), Name = AppBase.RoleUser, NormalizedName = AppBase.RoleUser.ToUpper() });
                roles.Add(new Coroles { Id = Guid.NewGuid().ToString(), Name = AppBase.RoleCustomer, NormalizedName = AppBase.RoleCustomer.ToUpper() });
                context.Coroles.AddRange(roles);
                context.SaveChanges();
            }
            var adminrole = context.Coroles.Where(e => e.Name == AppBase.RoleAdmin ).FirstOrDefault().Id;
            var curadmin = context.Couserroles.Where(e => e.RoleId == adminrole).ToList();
            if(curadmin.Count == 0)
            {
                var user = new Cousers();
                var urole = new Couserroles();
                user.Id = Guid.NewGuid().ToString();
                user.UserName = "admin";
                user.Email = user.UserName;
                user.NormalizedUserName = user.UserName.ToUpper();
                user.NormalizedEmail = user.Email.ToUpper();
                user.PasswordHash = AppBase.GetPasswordHash(user.UserName, "admin");
                urole.RoleId = adminrole;
                urole.UserId = user.Id;
                context.Cousers.Add(user);
                context.Couserroles.Add(urole);
                context.SaveChanges();
            }
        }
    }
}]]></xsl:text>
</xsl:template>
</xsl:stylesheet>
