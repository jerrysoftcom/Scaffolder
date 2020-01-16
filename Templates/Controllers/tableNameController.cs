using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using Microsoft.AspNet.Mvc;
using Microsoft.Data.Entity;
using <AppName>.Models;

namespace <AppName>.Controllers
{
    public class <TableName>Controller : Controller
    {
        private <DatabaseName>Context db;

        public <TableName>Controller(<DatabaseName>Context context)
        {
            db = context;
        }

        public IActionResult Index(int? pageNumber)
        {
            if (pageNumber == null)
            {
                pageNumber = 1;
            }

            int numberOfObjectsPerPage = 5;
            ViewBag.PageNumber = pageNumber;
            var pages = Math.Ceiling((Convert.ToDecimal(db.<TableName>.Count()) / numberOfObjectsPerPage));
            ViewBag.PageCount = pages;

            var queryResultPage = db.<TableName>
              .OrderBy(<TableName> => <TableName>.id)
              .Skip(numberOfObjectsPerPage * Convert.ToInt32(pageNumber - 1))
              .Take(numberOfObjectsPerPage);

            return View(queryResultPage);
        }

        public IActionResult Create()
        {
            return View();
        }

        [HttpPost]
        [ValidateAntiForgeryToken]
        public IActionResult Create(<TableName> <TableNameModel>)
        {
            if (ModelState.IsValid)
            {
                db.<TableName>.Add(<TableNameModel>);
                db.SaveChanges();
                return RedirectToAction("Index");
            }
            return View(<TableNameModel>);
        }

        public IActionResult Edit(int? pkey)
        {
            if (pkey == null)
            {
                return new HttpStatusCodeResult(404);
            }
            <TableName> <TableNameModel> = db.<TableName>.Single(b => b.pkey == pkey);
            if (<TableNameModel> == null)
            {
                return HttpNotFound();
            }
            return View(<TableNameModel>);

        }

        [HttpPost]
        [ValidateAntiForgeryToken]
        public IActionResult Edit(<TableName> <TableNameModel>)
        {
            if (ModelState.IsValid)
            {
                db.Entry(<TableNameModel>).State = EntityState.Modified;
                db.SaveChanges();
                return RedirectToAction("Index");
            }
            return View(<TableNameModel>);

        }

        public IActionResult Details(int? pkey)
        {
            if (pkey == null)
            {
                return new HttpStatusCodeResult(404);
            }
            <TableName> <TableNameModel> = db.<TableName>.Single(b => b.pkey == pkey);
            if (<TableNameModel> == null)
            {
                return HttpNotFound();
            }
            return View(<TableNameModel>);

        }

        public IActionResult Delete(int? pkey, int? pageNumber)
        {
            if (pkey == null)
            {
                return new HttpStatusCodeResult(404);
            }
            <TableName> <TableNameModel> = db.<TableName>.Single(b => b.pkey == pkey);
            db.<TableName>.Remove(<TableNameModel>);
            db.SaveChanges();
            if (<TableNameModel> == null)
            {
                return HttpNotFound();
            }
            if (pageNumber != null)
            { 
            return RedirectToAction("Index?pageNumber=" + pageNumber);
            }
            return RedirectToAction("Index");
        }
    }

}
