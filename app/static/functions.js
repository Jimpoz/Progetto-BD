function goBack() {
    window.history.back();
}

function enableEdit(formId, fieldId) {
    var form = document.getElementById(formId);
    var field = form.elements[fieldId];

    if (form.enable_edit.checked) {
        field.removeAttribute("readonly");
    } else {
        field.setAttribute("readonly", "readonly");
    }
}