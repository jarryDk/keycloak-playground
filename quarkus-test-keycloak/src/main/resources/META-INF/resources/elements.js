
class TokenElement extends HTMLElement {

    connectedCallback() {
        console.log("connected - Token");
        this.innerHTML = `
            <div>
            Token HR: <pre class="preJsonTxt">' + tokenObject + '</pre>
            </div>
        `;
    }

};