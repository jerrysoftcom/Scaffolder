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

namespace JS.Code

{
   public class Pager
    {
        public void SetPages()
        {
            MaxPage = (int)Math.Ceiling((decimal)(ItemCount / 10)) + 1;

            if (CurrentPage == 0)
            {
                CurrentPage = 1;
            }

            PrevPage = CurrentPage - 1;
            NextPage = CurrentPage + 1;

            MaxSelect = CurrentPage + PagerRange;
            MinSelect = CurrentPage - PagerRange;

            for (int i = MinSelect; i < MaxSelect; i++)
            {
                if (i >= 1 && i <= MaxPage)
                {
                    Pages.Add(i);
                }
            }

            if (CurrentPage == 1)
            {
                PrevPage = 1;
                PreviousDisabled = "disabled";
            }

            if (CurrentPage == MaxPage)
            {
                MaxSelect = MaxPage;
                NextPage = MaxPage;
                NextDisabled = "disabled";
            }

            if (CurrentPage > MaxPage)
            {
                CurrentPage = MaxPage;
            }
        }

        public int MaxSelect = 0;
        public int MinSelect = 0;

        public int CurrentPage;
        public int MaxPage;
        public int ItemsPerPage = 10;
        public int PagerRange = 3;
        public List<int> Pages = new List<int>();
        public int PrevPage;
        public int NextPage;
        public string PreviousDisabled = "";
        public string NextDisabled = "";
        public int ItemCount;
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

    public class MainMenu : ControllerBase
    {
        private readonly ]]></xsl:text><xsl:value-of select="ContextName"/><xsl:text disable-output-escaping="yes"><![CDATA[Context _context;
        private MenuModelData _pvmd;
        private bool _isAdmin;
        private List<int> showList = new List<int>();

        public MainMenu(]]></xsl:text><xsl:value-of select="ContextName"/><xsl:text disable-output-escaping="yes"><![CDATA[Context context, MenuModelData pvmd)
        {
            pvmd.PagePath = normalizePath(pvmd.PagePath);
            _context = context;
            _pvmd = pvmd;
        }

        private string normalizePath(string path)
        {
            if (path.ToLower().Contains("/edit/"))
            {
                path = path.Split("/Edit/")[0];
            }
            ///Details/
            if (path.ToLower().Contains("/details/"))
            {
                path = path.Split("/Details/")[0];
            }
            return path;
        }

        private List<Menus> MenuItems(int parent)
        {
            var menus = _context.Menus
                .Where(menu => menu.ParentMenuKey == parent && menu.Active == true && (menu.IsAdmin == false || menu.IsAdmin == _isAdmin))
                .OrderBy(menu => menu.MenuLevel)
                .ToList();
            return menus;
        }

        private List<Menus> MainMenuItems()
        {
            //CableSubContext context = new CableSubContext();
            var menus = _context.Menus
                .Where(menu => menu.ParentMenuKey == null && menu.Active == true && (menu.IsAdmin == false || menu.IsAdmin == _isAdmin))
                .OrderBy(menu => menu.MenuLevel)
                .ToList();
            return menus;
        }

        private string BuildMenuItem(string label, string url, string icon)
        {
            StringBuilder menuItem = new StringBuilder();
            string adHref = "";
            if (url.Length > 0)
            {
                adHref = $" href=\"{url}\"";
            }
            menuItem.AppendLine("<li>");
            menuItem.AppendLine($"<a {adHref}>");
            menuItem.AppendLine($"<i class=\"fa {icon}\"></i>");
            menuItem.AppendLine($"{label}");
            menuItem.AppendLine("</a>");
            menuItem.AppendLine("</li>");

            return menuItem.ToString();
        }

        private string GetSubMenus(int parentKey)
        {
            StringBuilder subMenu = new StringBuilder();
            foreach (var row in MenuItems(parentKey))
            {
                if (MenuItems(row.MenuKey).Count() > 0)
                {
                    subMenu.AppendLine(MakeParentMenu(row.MenuKey, row.MenuId, row.MenuIcon));
                }
                else
                {
                    var url = row.MenuUrl;
                    if (url == null) { url = ""; }
                    subMenu.AppendLine(BuildMenuItem(row.MenuId, url, row.MenuIcon));
                }
            }

            return subMenu.ToString();
        }

        private string MakeParentMenu(int parentKey, string label, string icon)
        {
            StringBuilder menuItem = new StringBuilder();
            string hideClass = "collapse ";
            string expanded = "false";
            //if (_context.Menus.Where(e => e.MenuUrl == _pvmd.PagePath && e.ParentMenuKey == parentKey).Count() > 0)
            foreach (int x in showList)
            {
                if (x == parentKey)
                {
                    hideClass = "";
                    expanded = "true";
                }
            }

            menuItem.AppendLine("<li>");
            menuItem.AppendLine($"<a href=\"#Menu{parentKey}\" data-toggle=\"collapse\" aria-expanded=\"{expanded}\" class=\"dropdown-toggle\">");
            menuItem.AppendLine($"<i class=\"fa {icon}\"></i>");
            menuItem.AppendLine($"{label}");
            menuItem.AppendLine("</a>");
            menuItem.AppendLine($"<ul class=\"{hideClass}list-unstyled\" id=\"Menu{parentKey}\">");
            // menuItem.AppendLine($"<ul class=\"collapse list-unstyled\" id=\"Menu{parentKey}\">");
            menuItem.AppendLine(GetSubMenus(parentKey));
            menuItem.AppendLine("</ul>");
            menuItem.AppendLine("</li>");

            return menuItem.ToString();
        }

        public string CreateMainMenu()
        {
            StringBuilder menu = new StringBuilder();
            LoadShowList();

            var usr = _pvmd.User;
            if (usr != null)
            {
                _isAdmin = usr.IsInRole("Administrator");
                //_isAdmin = true; //IsAdmin;
                // menu.AppendLine(usr.Identity.Name);
            }
            menu.AppendLine("<ul class=\"list-unstyled components\">");
            foreach (var row in MainMenuItems())
            {
                if (row.MenuUrl == null || row.MenuUrl.Length == 0)
                {
                    menu.AppendLine(MakeParentMenu(row.MenuKey, row.MenuId, row.MenuIcon));
                }
                else
                {
                    menu.AppendLine(BuildMenuItem(row.MenuId, row.MenuUrl, row.MenuIcon));
                }
            }
            menu.AppendLine("</ul>");
            return menu.ToString();
        }

        private void LoadShowList()
        {
            Menus menus = _context.Menus.Where(e => e.MenuUrl == _pvmd.PagePath).FirstOrDefault();
            if (menus != null)
            {
                AddToShowList(menus.MenuKey);
            }
        }

        private void AddToShowList(int menuKey)
        {
            showList.Add(menuKey);
            Menus menus = _context.Menus.Where(e => e.MenuKey == menuKey).FirstOrDefault();
            if (menus.ParentMenuKey != null)
            {
                AddToShowList((int)menus.ParentMenuKey);
            }
            else
            {
                showList.Add(menus.MenuKey);
            }
        }
    }

    public class Tools
    {
        public void PasswordRecovery(string email, string resetKey, string url)
        {
            //System.Net.Mail
            MailAddress to = new MailAddress(email);
            MailAddress from = new MailAddress("jeremiah@natisp.net.com");
            MailMessage message = new MailMessage(from, to);
            message.Subject = "Password Reset";
            message.Body = @"Click the link to reset your password <a href='" + url + "?resetEmail=" + email + "&resetKey=" + resetKey + "'>Click Here</a>";
            // Use the application or machine configuration to get the 
            // host, port, and credentials.
            SmtpClient client = new SmtpClient();
            message.IsBodyHtml = true;
            client.Host = "smtp.gmail.com"; //"mail.jerrysoft.com";
            client.Port = 587;
            client.Credentials = new System.Net.NetworkCredential("jeremiah@natisp.net", "cnsfl1061");
            client.EnableSsl = true;
            
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
