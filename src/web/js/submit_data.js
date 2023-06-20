const generateAppointmentObject = (fullName, officeToVisit, personToVisit, purpose, withVehicle, plateNum, timeOfVisit, emailAddress) => {
    const appointmentObject = {
        full_name: fullName,
        office_to_visit: officeToVisit,
        person_to_visit: personToVisit,
        purpose: purpose,
        with_vehicle: withVehicle,
        plate_num: withVehicle === "1" ? plateNum : "None",
        time_of_visit: formatTime(timeOfVisit),
        email_address: emailAddress
    };

    return appointmentObject;
};

const formatTime = (time) => {
    const [hours, minutes] = time.split(':');
    let hour = parseInt(hours);
    const suffix = hour >= 12 ? 'PM' : 'AM';

    if (hour === 0) {
        hour = 12;
    } else if (hour > 12) {
        hour -= 12;
    }

    const formattedTime = `${hour}:${minutes} ${suffix}`;
    return formattedTime;
};

async function post_data(url = "", data = {}) {
    try {
        const response = await fetch(url, {
            method: "POST",
            headers: {
                "Content-Type": "application/json"
            },
            body: JSON.stringify(data)
        });

        if (response.ok) {
            return response.json();
        } else if (response.status === 500) {
            const errorResponse = await response.json();
            throw new Error(errorResponse.error || 'Appointment creation failed.');
        } else {
            throw new Error('An error occurred. Try again later.');
        }
    } catch (error) {
        return error;
    }
}

const getSelectedRadioValue = () => {
    const selectedRadioButton = document.querySelector(".radio-group input[name='with_vehicle']:checked");
    return selectedRadioButton ? selectedRadioButton.value : null;
};

const checkEmptyFields = (appointmentObject = {}) => {
    for (const key in appointmentObject) {
        if (
            appointmentObject.hasOwnProperty(key) &&
            typeof appointmentObject[key] === "string" &&
            appointmentObject[key].trim() === ""
        ) {
            return true;
        }
    }

    return false;
};

const getCarNums = async () => {
    const response = await fetch("http://localhost:5000/api/appointments/car_num.php");

    if (response.ok) {
        const data = await response.json();
        let veh_count = data.vehicle_count;
        let max_car = 50;

        const carCountDiv = document.querySelector(".car_count");
        carCountDiv.innerHTML = `
        <label>Car count: <span>${veh_count}</span> / ${max_car}</label><br><br>
      `;

        const noCarBtn = document.getElementById("vec-no");
        const hasCarBtn = document.getElementById("vec-yes");

        if (veh_count === max_car) {
            noCarBtn.checked = true;
            hasCarBtn.disabled = true;
            const plate = document.getElementById("plateNum");
            plate.disabled = true;
        } else {
            const plate = document.getElementById("plateNum");
            plate.disabled = false;
        }
    }
}

document.addEventListener("DOMContentLoaded", () => {
    const form = document.getElementById("reg");
    getCarNums();
    const noCarBtn = document.getElementById("vec-no");
    const hasCarBtn = document.getElementById("vec-yes");

    hasCarBtn.addEventListener("change", (ev) => {
        ev.preventDefault();

        const plate = document.getElementById("plateNum");
        plate.disabled = false;
    });

    noCarBtn.addEventListener("change", (ev) => {
        ev.preventDefault();
        const plate = document.getElementById("plateNum");
        plate.disabled = true;
    });


    form.addEventListener("submit", (ev) => {
        ev.preventDefault();
        const appointmentEntry = generateAppointmentObject(
            document.getElementById("namedd").value,
            document.getElementById("office").value,
            document.getElementById("person").value,
            document.getElementById("purpose").value,
            getSelectedRadioValue(),
            document.getElementById("plateNum").value,
            document.getElementById("oras").value,
            document.getElementById("email").value
        );
        
        console.log(appointmentEntry);

        if (checkEmptyFields(appointmentEntry)) {
            alert("All fields must be filled up.")
            return;
        }

        post_data("http://localhost:5000/api/appointments/create.php", appointmentEntry)
            .then((data) => {
                alert(data.message);
                window.location.replace("/web/online.html");
            })
            .catch((error) => {
                alert(error.error);
            });

    });
});