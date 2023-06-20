const removeEntry = async (id) => {
    const ok = confirm("Do you really want to delete?");

    if (!ok) {
        return;
    }

    const toDelete = { id: id };

    try {
        const response = await fetch("http://localhost:5000/api/appointments/delete.php", {
            method: 'DELETE',
            headers: {
                'Content-Type': 'application/json',
            },
            body: JSON.stringify(toDelete),
        });

        const result = await response.json();

        if (response.ok) {
            alert(result.message);
            window.location.replace("/web/admin/list.html");
        } else {
            alert(result.message);
        }
    } catch (error) {
        console.error('Error:', error);
    } 
};

async function getData() {
    const data = await fetch("http://localhost:5000/api/appointments/read.php");
    const records = await data.json();
    let tableBody = document.querySelector("#visitors tbody");

    records.body.forEach((record) => {
        let row = document.createElement("tr");
        row.setAttribute("data-id", record.id);

        let fullNameCell = document.createElement("td");
        fullNameCell.textContent = record.full_name;
        row.appendChild(fullNameCell);

        let officeCell = document.createElement("td");
        officeCell.textContent = record.office_to_visit;
        row.appendChild(officeCell);

        let personCell = document.createElement("td");
        personCell.textContent = record.person_to_visit;
        row.appendChild(personCell);

        let purposeCell = document.createElement("td");
        purposeCell.textContent = record.purpose;
        row.appendChild(purposeCell);

        let vehicleCell = document.createElement("td");
        vehicleCell.textContent = record.with_vehicle ? "Yes" : "No";
        row.appendChild(vehicleCell);

        let plateCell = document.createElement("td");
        plateCell.textContent = record.plate_num;
        row.appendChild(plateCell);

        let timeCell = document.createElement("td");
        timeCell.textContent = record.time_of_visit;
        row.appendChild(timeCell);

        let emailCell = document.createElement("td");
        emailCell.textContent = record.email_address;
        row.appendChild(emailCell);

        let actionCell = document.createElement("td");
        let removeButton = document.createElement("button");
        removeButton.textContent = "Remove";
        removeButton.addEventListener("click", () => {
            const id = row.getAttribute("data-id");
            removeEntry(id);

        });
        actionCell.appendChild(removeButton);

        let actionButtonsDiv = document.createElement("div");
        actionButtonsDiv.classList.add("action-buttons");
        actionButtonsDiv.appendChild(removeButton);
        actionCell.appendChild(actionButtonsDiv);

        row.appendChild(actionCell);

        tableBody.appendChild(row);
    });
}

document.addEventListener("DOMContentLoaded", () => {
    getData();
});