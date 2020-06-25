<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
<xsl:strip-space elements="*"/>
<xsl:output omit-xml-declaration="yes" indent="no" encoding="UTF-8" method="xml"/>
<xsl:template match="ParentData"><xsl:text disable-output-escaping="yes"><![CDATA[using System;
using System.Collections.Generic;
using System.Diagnostics;
using System.Linq;
using System.Security.Claims;
using System.Threading.Tasks;
using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Authentication;
using Microsoft.AspNetCore.Authentication.Cookies;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc.RazorPages;
using Microsoft.EntityFrameworkCore;
using Microsoft.AspNetCore.Mvc.Routing;
using Microsoft.AspNetCore.Http;
using ]]></xsl:text>
<xsl:value-of select="AppName"/>
<xsl:text disable-output-escaping="yes"><![CDATA[.Code;
using ]]></xsl:text><xsl:value-of select="AppName"/><xsl:text disable-output-escaping="yes"><![CDATA[.Models;

namespace ]]></xsl:text><xsl:value-of select="AppName"/><xsl:text disable-output-escaping="yes"><![CDATA[.Controllers
{
    public class LoginController : Controller
    {
        private readonly ]]></xsl:text><xsl:value-of select="ContextName"/><xsl:text disable-output-escaping="yes"><![CDATA[Context _context;

        public LoginController(]]></xsl:text><xsl:value-of select="ContextName"/><xsl:text disable-output-escaping="yes"><![CDATA[Context context)
        {
            _context = context;
        }

        [Authorize]
        public IActionResult Index()
        {
            return View();
        }

        public IActionResult Build()
        {
            if (true)
            {
                var appBuild = new Tools();
                appBuild.BuildRolesAndUser(_context);
            }
            return View("Login");
        }

        public IActionResult Privacy()
        {
            return View();
        }

        [ResponseCache(Duration = 0, Location = ResponseCacheLocation.None, NoStore = true)]
        public IActionResult Error()
        {
            return View(new ErrorViewModel { RequestId = Activity.Current?.Id ?? HttpContext.TraceIdentifier });
        }

        public IActionResult Dashboard()
        {
            return View();
        }

        [HttpGet]
        public IActionResult PasswordReset()
        {
            return View();
        }

        [HttpPost]
        public IActionResult PasswordReset([FromForm]string inputResetPasswordEmail)
        {
            string htp = $"{Request.Scheme}://{Request.Host}";

            string url = Url.Action("PasswordRecovery", "Home");

            Tools app = new Tools();
            var user = _context.Cousers.Where(e => e.Email == inputResetPasswordEmail).FirstOrDefault();
            var passwordKeyText = Guid.NewGuid().ToString();
            user.PasswordResetTimeout = DateTime.Now.AddMinutes(30);
            user.PasswordResetKey = AppBase.GetPasswordHash(user.Email, passwordKeyText).Replace("+", "").Replace("=", "");
            _context.Update(user);
            _context.SaveChanges();

            app.PasswordRecovery(user.Email, user.PasswordResetKey, htp + url);
            return View("Login");
        }

        [HttpGet]
        public IActionResult PasswordRecovery(string resetEmail, string resetKey)
        {
            PasswordResetData passdata = new PasswordResetData();
            passdata.ResetEmail = resetEmail;
            passdata.ResetKey = resetKey;
            return View(passdata);
        }

        [HttpPost]
        public IActionResult PasswordRecovery(string resetEmail, string resetPassword, string resetKey)
        {
            var user = _context.Cousers.Where(e => e.Email == resetEmail
            && e.PasswordResetKey == resetKey
            && e.PasswordResetTimeout > DateTime.Now)
                .FirstOrDefault();
            if (user != null)
            {
                user.PasswordHash = AppBase.GetPasswordHash(user.Email, resetPassword);
                _context.Update(user);
                _context.SaveChanges();
            }

            return View("Login");

        }

        public async Task<IActionResult> LoginAsync(string email, string password, string returnUrl)
        {
            if (email == null || password == null)
            {
                //await HttpContext.SignOutAsync(CookieAuthenticationDefaults.AuthenticationScheme);

                return View("Login");
            }


            if (ModelState.IsValid)
            {
                var user = AuthenticateUser(email, password);

                if (user == null)
                {
                    ErrorViewModel evm = new ErrorViewModel();
                    evm.RequestId = "Invalid login attempt.";
                    return View("Error", evm);
                }

                var claims = new List<Claim>
                {
                    new Claim(ClaimTypes.Name, user.Email),
                    new Claim(ClaimTypes.NameIdentifier, user.Id),
                    new Claim("FullName", user.Description ?? "None"),
                   // new Claim(ClaimTypes.Role, "Administrator"),
                };

                foreach (var row in _context.CoUserRoles.Include(roles => roles.Role).Where(cr => cr.UserId == user.Id))
                {
                    claims.Add(new Claim(ClaimTypes.Role, row.Role.Name));
                }

                var claimsIdentity = new ClaimsIdentity(
                    claims, CookieAuthenticationDefaults.AuthenticationScheme); //, ClaimTypes.Name, ClaimTypes.Role);

                var authProperties = new AuthenticationProperties
                {
                    //AllowRefresh = <bool>,
                    // Refreshing the authentication session should be allowed.

                    //ExpiresUtc = DateTimeOffset.UtcNow.AddMinutes(10),
                    // The time at which the authentication ticket expires. A 
                    // value set here overrides the ExpireTimeSpan option of 
                    // CookieAuthenticationOptions set with AddCookie.

                    //IsPersistent = true,
                    // Whether the authentication session is persisted across 
                    // multiple requests. When used with cookies, controls
                    // whether the cookie's lifetime is absolute (matching the
                    // lifetime of the authentication ticket) or session-based.

                    //IssuedUtc = <DateTimeOffset>,
                    // The time at which the authentication ticket was issued.

                    //RedirectUri = <string>
                    // The full path or absolute URI to be used as an http 
                    // redirect response value.
                };

                await HttpContext.SignInAsync(
                    CookieAuthenticationDefaults.AuthenticationScheme,
                    new ClaimsPrincipal(claimsIdentity),
                    authProperties);

                if (returnUrl != null)
                {
                    return LocalRedirect(returnUrl);
                }
                else
                {
                    return LocalRedirect("/Home");
                }
            }

            // Something failed. Redisplay the form.
            return View();
        }

        private Cousers AuthenticateUser(string email, string password)
        {
            string passwordHash = AppBase.GetPasswordHash(email, password);
            Cousers coUser = _context.Cousers.FirstOrDefault(usr => usr.Email == email && usr.PasswordHash == passwordHash);

            if (coUser != null)
            {
                return coUser;
            }
            else
            {
                return null;
            }
        }

        public async Task<IActionResult> LogoutAsync()
        {
            await HttpContext.SignOutAsync(CookieAuthenticationDefaults.AuthenticationScheme);

            return View();
        }

        public IActionResult AccessDenied()
        {
            return View();
        }

    }

}]]></xsl:text>
</xsl:template>
</xsl:stylesheet>

