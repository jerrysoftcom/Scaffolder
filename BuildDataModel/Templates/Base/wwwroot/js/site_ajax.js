//  JavaScript to support document insertion dynamically

AddAntiForgeryToken = function (data, formname) {
    data.__RequestVerificationToken = $('#' + formname + ' input[name=__RequestVerificationToken]').val();
    return data;
};

function AjaxSubmitForm(formname, appendElement) {
    var form = document.forms[formname];

    var formData = new FormData(form, formname);
    AddAntiForgeryToken(formData, formname);

    var request = new XMLHttpRequest();
    request.open(form.method, form.action, false);
    request.send(formData);

    var modal = document.getElementById("myModal");
    modal.style.display = "none";

    var appdElement = document.getElementById(appendElement);
    appdElement.innerHTML = request.response;

}

function AjaxRun(urlToRun) {
    var request = new XMLHttpRequest();
    request.open("GET", urlToRun, false);
    request.send();
}

function AjaxAddDoc(actionUrl) {
    var modal = document.getElementById("myModal");
    var span = document.getElementById("myModalClose");
    // alert('Got Here ' + actionUrl);
    span.onclick = function () {
        modal.style.display = "none";
    }

    window.onclick = function (event) {
        if (event.target == modal) {
            modal.style.display = "none";
        }
    }

    var xhttp = new XMLHttpRequest();
    xhttp.onreadystatechange = function () {
        if (this.readyState == 4 && this.status == 200) {
            $('#popDisplay').text("");
            $('#popDisplay').append(this.responseText);
            modal.style.display = "block";
        }
    };
    xhttp.open("GET", actionUrl, false);
    xhttp.send();
}

function AjaxRun(urlToRun, elementToWrite) {
    var request = new XMLHttpRequest();
    request.open("GET", urlToRun, true);
    request.onload = function (e) {
        if (request.readyState === 4) {
            if (request.status === 200) {
                WriteElementWithClear(elementToWrite, request.response);
            } else {
                WriteElementWithClear(elementToWrite, request.statusText);
            }
        }
    };
    request.send(null);
}

function AjaxRunPlus(urlToRun, elementToWrite, elementToIncrement) {
    var incElement = Number(document.getElementById(elementToIncrement).value) + 1;
    document.getElementById(elementToIncrement).value = incElement;
    var request = new XMLHttpRequest();
    request.open("GET", urlToRun + "/" + incElement, true);
    request.onload = function (e) {
        if (request.readyState === 4) {
            if (request.status === 200) {
                WriteElement(elementToWrite, request.response);
            } else {
                WriteElement(elementToWrite, request.statusText);
            }
        }
    };
    request.send(null);
}

function WriteElement(elementToWrite, data) {
    var appdElement = document.getElementById(elementToWrite);
    appdElement.insertAdjacentHTML("beforeend", data);
}

function WriteElementWithClear(elementToWrite, data) {
    var appdElement = document.getElementById(elementToWrite);
    appdElement.innerHTML = "";
    appdElement.insertAdjacentHTML("beforeend", data);
}