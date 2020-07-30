$(function () {
    var links = $('.sidebar-links > div');
    //var links = $('.fa > div');
    //var sel = window.localStorage.getItem("menuSelected");
    //$(document.getElementById(sel)).addClass('selected');
    //alert(sel);

    links.on('click', function () {
        //window.localStorage.setItem("menuSelected", this);
        //alert(this);
        links.removeClass('selected');
        $(this).addClass('selected');
    });
});
