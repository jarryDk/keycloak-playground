
var keycloak = new Keycloak({
    "url": "https://keycloak.jarry.dk:8543/",
    "realm": "playground",
    "clientId": "todo-playground-service"
});

var url = window.location.href
var urlArr = url.split("/");
var urlResult = urlArr[0] + "//" + urlArr[2]
var serviceUrl = urlResult + '/api/'
console.info('serviceUrl', serviceUrl);

var requestedScopes = "openid email profile phone rl";

function notAuthenticated() {
    document.getElementById('not-authenticated').style.display = 'block';
    document.getElementById('authenticated').style.display = 'none';
}
keycloak.onAuthLogout = notAuthenticated;

function authenticated() {
    document.getElementById('not-authenticated').style.display = 'none';
    document.getElementById('authenticated').style.display = 'block';
    document.getElementById('user').value = keycloak.tokenParsed['preferred_username'];
    updateTokensDisplay();
}

function updateTokensDisplay(){
    if (keycloak.authenticated) {
        var idTokenObject = JSON.stringify(parseJwt(keycloak.idToken), null, 4);
        var tokenObject = JSON.stringify(parseJwt(keycloak.token), null, 4);

        document.getElementById('idToken').innerHTML =  '<pre class="preJsonTxt">' +idTokenObject + '</pre>';
        document.getElementById('idTokenBase64').innerHTML = '<code>' + keycloak.idToken + '</code>';

        document.getElementById('tokenBase64').innerHTML = '<code>' + keycloak.token + '</code>';
        document.getElementById('token').innerHTML = '<pre class="preJsonTxt">' + tokenObject + '</pre>';
    }
}

function request(endpoint) {
    var req = function() {
        var req = new XMLHttpRequest();
        var payload = document.getElementById('payload');
        req.open('GET', serviceUrl + endpoint + '/users/me' , true);

        if (keycloak.authenticated) {
            req.setRequestHeader('Authorization', 'Bearer ' + keycloak.token);
        }

        req.onreadystatechange = function () {
            if (req.readyState == 4) {
                if (req.status == 200) {
                    var payloadObject = JSON.stringify(JSON.parse(req.responseText+""), null, 4);
                    payload.innerHTML = '<pre class="preJsonTxt">' + payloadObject + '</pre>';
                } else if (req.status == 0) {
                    payload.innerHTML = '<span class="error">Request failed</span>';
                } else {
                    payload.innerHTML = '<span class="error">' + req.status + ' ' + req.statusText + '</span>';
                }
            }
        };

        req.send();
    };

    if (keycloak.authenticated) {
        keycloak.updateToken(30).then(req);
    } else {
        req();
    }
}

function initKeycloak(){
    console.info("requestedScopes", requestedScopes);
    keycloak.init({
        onLoad: 'check-sso',
        checkLoginIframeInterval: 1,
        scope : requestedScopes
    }).then(function () {
        if (keycloak.authenticated) {
            authenticated();
        } else {
            notAuthenticated();
        }
        document.body.style.display = 'block';
    });
}


window.onload = function () {

    var cookieScope = getCookie('scope');
    if (cookieScope != ''){
        requestedScopes = cookieScope;
    }
    document.getElementById('inputScope').value = requestedScopes;

    /**
     * Update tokens after scope have been updated
     */
    const scopeForm = document.getElementById("scopeForm");
    scopeForm.addEventListener("submit", (event) => {
        event.preventDefault();
        console.log("Scope updated....");
        requestedScopes = document.getElementById('inputScope').value;
        setCookie('scope', requestedScopes, 10);
        initKeycloak();
        keycloak.login();
    });

    initKeycloak();
}



function parseJwt(token) {
    var base64Url = token.split('.')[1];
    var base64 = base64Url.replace(/-/g, '+').replace(/_/g, '/');
    var jsonPayload = decodeURIComponent(window.atob(base64).split('').map(function(c) {
        return '%' + ('00' + c.charCodeAt(0).toString(16)).slice(-2);
    }).join(''));
    return JSON.parse(jsonPayload);
}

function setCookie(cname, cvalue, exdays) {
    const d = new Date();
    d.setTime(d.getTime() + (exdays*24*60*60*1000));
    let expires = "expires="+ d.toUTCString();
    document.cookie = cname + "=" + cvalue + ";" + expires + ";path=/";
}

function getCookie(cname) {
    let name = cname + "=";
    let decodedCookie = decodeURIComponent(document.cookie);
    let ca = decodedCookie.split(';');
    for(let i = 0; i <ca.length; i++) {
      let c = ca[i];
      while (c.charAt(0) == ' ') {
        c = c.substring(1);
      }
      if (c.indexOf(name) == 0) {
        return c.substring(name.length, c.length);
      }
    }
    return "";
}
