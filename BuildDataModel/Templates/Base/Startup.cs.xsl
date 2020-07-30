<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
<xsl:strip-space elements="*"/>
<xsl:output omit-xml-declaration="yes" indent="no" encoding="UTF-8" method="xml"/>
<xsl:template match="ParentData"><xsl:text disable-output-escaping="yes"><![CDATA[using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using Microsoft.AspNetCore.Builder;
using Microsoft.AspNetCore.Hosting;
using Microsoft.AspNetCore.HttpsPolicy;
using Microsoft.Extensions.Configuration;
using Microsoft.Extensions.DependencyInjection;
using Microsoft.Extensions.Hosting;
using Microsoft.EntityFrameworkCore;
using Microsoft.AspNetCore.Authentication.Cookies;
using ]]></xsl:text><xsl:value-of select="AppName"/><xsl:text disable-output-escaping="yes"><![CDATA[.Models;

namespace ]]></xsl:text>
<xsl:value-of select="AppName"/>
<xsl:text disable-output-escaping="yes"><![CDATA[
{
    public class Startup
    {
        public Startup(IConfiguration configuration)
        {
            Configuration = configuration;
        }

        public IConfiguration Configuration { get; }

        // This method gets called by the runtime. Use this method to add services to the container.
        public void ConfigureServices(IServiceCollection services)
        {
            services.Configure<CookiePolicyOptions>(options =>
            {
                // This lambda determines whether user consent for non-essential cookies is needed for a given request.
                options.CheckConsentNeeded = context => true;
            });

            // Enable cookie authentication
            services.AddAuthentication(CookieAuthenticationDefaults.AuthenticationScheme).AddCookie(options =>
            {
                options.LoginPath = "/Login/Login";
                options.LogoutPath = "/Login/Logout";
                options.AccessDeniedPath = "/Login/AccessDenied";
            });

            services.AddHttpContextAccessor();

            services.AddDbContext<]]></xsl:text><xsl:value-of select="ContextName"/><xsl:text disable-output-escaping="yes"><![CDATA[Context>(options => options.UseSqlServer(Configuration.GetConnectionString("DefaultConnection")));
            //services.AddDbContext<]]></xsl:text><xsl:value-of select="ContextName"/><xsl:text disable-output-escaping="yes"><![CDATA[Context>(options => options.UseMySQL(Configuration.GetConnectionString("MySqlConnection")));

            /*
             Add-Migration InitialCreate
             Update-Database
            */
            services.AddControllersWithViews();
            //services.AddRazorPages();
            //services.AddServerSideBlazor();
        }

        // This method gets called by the runtime. Use this method to configure the HTTP request pipeline.
        public void Configure(IApplicationBuilder app, IWebHostEnvironment env)
        {
            if (env.IsDevelopment())
            {
                app.UseDeveloperExceptionPage();
            }
            else
            {
                app.UseExceptionHandler("/Home/Error");
                // The default HSTS value is 30 days. You may want to change this for production scenarios, see https://aka.ms/aspnetcore-hsts.
                app.UseHsts();
            }
            app.UseHttpsRedirection();
            app.UseStaticFiles();

            app.UseRouting();
            app.UseAuthentication();
            app.UseAuthorization();

            app.UseEndpoints(endpoints =>
            {
                endpoints.MapControllerRoute(
                    name: "default",
                    pattern: "{controller=Home}/{action=Index}/{id?}");
           });
        }
    }
}
]]></xsl:text>
</xsl:template>
</xsl:stylesheet>
