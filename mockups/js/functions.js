function removeBanner() {
    let element = document.getElementById('banner')
    if (typeof element != "undefined") {
        element.parentNode.removeChild(element)
    }
}

function checkInput(element) {
    if (element.value.length > 0) {
        element.classList.add("has-value");
    } else {
        element.classList.remove("has-value");
    }
}

function resetInput() {
    for (const element of document.querySelectorAll(".input-group input")) {
        element.classList.remove("has-value");
    }
}

function openURL(url) {
    window.location.href = url;
}

window.onload = function () {
    /* Remove Snackbar */
    if (document.getElementById('snackbar') != null) {
        setTimeout(() => {
            let element = document.getElementById('snackbar')
            if (typeof element != "undefined" || element != null) {
                element.parentNode.removeChild(element)
            }
        }, 5000)
    }

    /* Event listener for Input Fields */
    let elements = document.querySelectorAll(".input-group input")
    for (const element of elements) {
        element.addEventListener('change', () => {
            checkInput(element)
        });
    }

    let element = document.getElementById('login');
    element.addEventListener('reset', resetInput);
}