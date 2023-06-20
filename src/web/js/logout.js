function logoutUser() {
    localStorage.removeItem("id");
    localStorage.removeItem("auth");
    window.location.replace("/web/admin");
}