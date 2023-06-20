const fetchData = async (username, password) => {
    const data = {
        username: username,
        password: password,
    };

    try {
        const response = await fetch("http://localhost:5000/api/login_details.php", {
            method: "POST",
            headers: {
                "Content-Type": "application/json; charset=UTF-8",
                "Access-Control-Allow-Origin": "*",
                "Access-Control-Allow-Methods": "POST",
                "Access-Control-Max-Age": "3600",
                "Access-Control-Allow-Headers": "Content-Type, Access-Control-Allow-Headers, Authorization, X-Requested-With",
            },
            body: JSON.stringify(data),
        });

        if (!response.ok) {
            throw new Error("Cannot login!");
        }

        const login = await response.json();

        localStorage.setItem("id", JSON.stringify(login.body[0]));
        localStorage.setItem("auth", JSON.stringify(login.auth));
        window.location.replace("/web/admin/list.html");
    } catch (error) {
        alert(error.message);
    }
};

document.addEventListener("DOMContentLoaded", () => {
    const form = document.querySelector("#login-form");
    const username = document.querySelector("#user");
    const password = document.querySelector("#pass");
    const goBackBtn = document.querySelector("#go-back");

    form.addEventListener("submit", (ev) => {
        ev.preventDefault();
        console.log(`Username: ${username.value}`);
        console.log(`Password: ${password.value}`);
        fetchData(username.value, password.value);
    });

    goBackBtn.addEventListener("click", () => {
        window.location.replace("/web/");
    })
});

const auth = localStorage.getItem("auth");
if (auth && auth === "1") {
    window.location.replace("/web/admin/list.html");
}