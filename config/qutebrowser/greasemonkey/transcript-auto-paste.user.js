// ==UserScript==
// @name         Transcript Auto-Paste
// @namespace    qutebrowser-transcript
// @version      1.0
// @description  Auto-paste clipboard content into AI chat inputs
// @match        https://grok.com/*
// @match        https://claude.ai/*
// @match        https://chatgpt.com/*
// @match        https://gemini.google.com/*
// @grant        none
// @run-at       document-idle
// ==/UserScript==

(function() {
    "use strict";

    var PASTE_FLAG = "transcript_auto_pasted";

    if (sessionStorage.getItem(PASTE_FLAG)) return;

    var SELECTORS = {
        "grok.com": "textarea",
        "claude.ai": "[contenteditable=\"true\"]",
        "chatgpt.com": "#prompt-textarea",
        "gemini.google.com": ".ql-editor, [contenteditable=\"true\"]"
    };

    function getSiteKey() {
        var host = window.location.hostname;
        var keys = Object.keys(SELECTORS);
        for (var i = 0; i < keys.length; i++) {
            if (host.includes(keys[i])) return keys[i];
        }
        return null;
    }

    function setInputValue(el, text) {
        if (el.getAttribute("contenteditable") === "true") {
            el.focus();
            var p = document.createElement("p");
            p.textContent = text;
            el.innerHTML = "";
            el.appendChild(p);
            el.dispatchEvent(new Event("input", { bubbles: true }));
        } else {
            el.focus();
            var nativeSetter = Object.getOwnPropertyDescriptor(
                window.HTMLTextAreaElement.prototype, "value"
            ).set;
            nativeSetter.call(el, text);
            el.dispatchEvent(new Event("input", { bubbles: true }));
        }
    }

    function tryPaste() {
        var siteKey = getSiteKey();
        if (!siteKey) return;

        var selector = SELECTORS[siteKey];

        navigator.clipboard.readText().then(function(text) {
            if (!text || text.length < 50) return;

            var attempts = 0;
            var maxAttempts = 30;

            var interval = setInterval(function() {
                var el = document.querySelector(selector);
                attempts++;

                if (el) {
                    clearInterval(interval);
                    setInputValue(el, text);
                    sessionStorage.setItem(PASTE_FLAG, "true");
                } else if (attempts >= maxAttempts) {
                    clearInterval(interval);
                }
            }, 500);
        }).catch(function(err) {
            console.log("Transcript auto-paste: clipboard read failed", err);
        });
    }

    setTimeout(tryPaste, 1000);
})();
