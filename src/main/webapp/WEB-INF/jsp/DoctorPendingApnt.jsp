<%--
  Created by IntelliJ IDEA.
  User: I520345
  Date: 6/8/2020
  Time: 5:27 PM
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <script src="${pageContext.request.contextPath}/resources/js/jquery-3.5.1.min.js"></script>

    <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/PatientHomepageStyle.css">
    <title>Doctor Pending Appointment</title>
    <style>

        #pendingTable {
            font-family: "Trebuchet MS", Arial, Helvetica, sans-serif;
            border-collapse: collapse;
            width: 78%;
            margin-left: 21%;
        }

        #pendingTable td, #pendingTable th {
            border: 1px solid #ddd;
            padding: 8px;
        }

        #pendingTable tr:nth-child(even) {
            background-color: #f2f2f2;
        }

        #pendingTable tr:hover {
            background-color: #ddd;
        }

        #pendingTable th {
            padding-top: 12px;
            padding-bottom: 12px;
            text-align: left;
            background-color: #4CAF50;
            color: white;
        }

        /* Button used to open the contact form - fixed at the bottom of the page */
        .open-button {
            background-color: #555;
            color: white;
            padding: 16px 20px;
            border: none;
            cursor: pointer;
            opacity: 0.8;
            position: fixed;
            bottom: 23px;
            right: 28px;
            width: 280px;
        }

        /* The popup form - hidden by default */
        .form-popup {
            display: none;
            position: fixed;
            bottom: 0;
            right: 15px;
            border: 3px solid #f1f1f1;
            z-index: 9;
        }

        /* Add styles to the form container */
        .form-container {
            max-width: 100%;
            padding: 10px;
            background-color: white;
        }

        /* Full-width input fields */
        .form-container input[type=text], .form-container input[type=password] .form-container textarea {
            width: 100%;
            padding: 15px;
            margin: 5px 0 22px 0;
            border: none;
            background: #f1f1f1;
        }

        /* When the inputs get focus, do something */
        .form-container input[type=text]:focus, .form-container input[type=password]:focus, .form-container textarea {
            background-color: #ddd;
            outline: none;
            width: 100%;
            margin: 10 8px 10 0;
        }

        /* Set a style for the submit/login button */
        .form-container .btn {
            background-color: #4CAF50;
            color: white;
            padding: 16px 20px;
            border: none;
            cursor: pointer;
            width: 100%;
            margin: 10 10 10 0;
            opacity: 0.8;
        }

        /* Add a red background color to the cancel button */
        .form-container .cancel {
            background-color: red;
        }

        /* Add some hover effects to buttons */
        .form-container .btn:hover, .open-button:hover {
            opacity: 1;
        }
    </style>
</head>
<body>
<div  style="padding: 20;
    background: #a8ccaa;"><h2> Pending Appointments</h2>
    <button onclick="onBack()" style="margin-left: 90%;
    padding: 10 20;
    color: white;
    background: #264426;
    margin-top: -60;">back</button></div>

<div id="overlay" onclick="off()"></div>
<div class="form-popup" id="myForm" style="top: 15%;
    width: 325px;left: 35%;height: 75%;"></div>
<script>
    var result;
    $.ajax({
        method: "GET",
        url: "doctorAppointmentsPending",
        dataType: 'json',
        async: false,
        success: function (response) {
            result = response.result;
            setData(response.result);
        }
    });
function onBack(){
window.location.replace("Doctorhomepage")
}
    function setData(result) {
        document.write("<table id=pendingTable cellpadding='10' style='text-align: center;margin: 5%;'>\n" +
            "    <tr>\n" +
            "        <th>Patient Name</th>\n" +
            "        <th>Appointment Date</th>\n" +
            "        <th>illness</th>\n" +
            "        <th>Prescription</th>\n" +
            "    </tr>\n");
        if(Object.keys(result).length) {
            Object.keys(result).forEach(function (i) {
                document.write("    <tr>\n" +
                    "        <td>" + result[i].patient.name + "</td>\n" +
                    "        <td>" + appointmentdate(result[i].appointment.time) + "</td>\n" +
                    "        <td><button id=" + i + " onclick=showIllness()>Show</button></td>\n" +
                    "        <td><button id=" + i + " onclick=provide()>Provide</button></td>\n" +
                    "    </tr>\n");
            })
        }
        else {
            document.write("<tr>" +
                "<td colspan=4 style='text-align: center;'> No Data</td></tr>");
        }

        document.write("</table>");
    }
var aid;
    function provide() {
    aid=event.target.id;
        document.getElementById("myForm").innerHTML = "  <div action=\"/action_page.php\" class=\"form-container\">\n" +
            "    <button type=\"button\" style='width: 10%;margin-left: 90%;\n" +
            "    padding: 10 20 10 10;' class=\"btn cancel\" onclick=\"closeForm()\">X</button>\n" +
            "    <h1 style='margin-top: 0;'>Fill Prescription</h1>\n" +
            "\n" +
            "    <label for=\"Advice\"><b>Advice :</b><br></label>\n" +
            "    <textarea id=Advice placeholder=\"Enter Advice\" name=\"Advice\" rows=6 cols=30 autofocus=autofocus maxlength=200 required></textarea>\n" +
            "\n" +
            "    <label for=\"Duration\"><b>Duration :</b><br></label>\n" +
            "    <Input type='text' id=Duration placeholder=\"Enter Duration\" name=\"Duration\" autofocus=autofocus maxlength=20 required>\n" +
            "\n" +
            "    <button onclick='onSendPres()' class=\"btn\">Send</button>\n" +
            "  </div>\n";
        document.getElementById("myForm").style.display = "block";
    }

    function onSendPres() {
        var ad=document.getElementById("Advice").value;
        var du=document.getElementById("Duration").value;
        if(ad==="" || du ===""){
            alert("PLease fill out all the fields");
        }
        else{
            $.ajax({
                method: "POST",
                url: "givePrescription",
                data: {appointmentId: result[aid].appointment.id,
                    description: ad,
                    duration: du
                },
                dataType: 'json',
                async: false,
                success: function (response) {
                    alert("Prescription Successfully given.")
                    window.location.reload();
                }
            });
        }
    }

    function closeForm() {
        document.getElementById("myForm").style.display = "none";
    }

    function showIllness() {

        document.getElementById("overlay").innerHTML = "    <div id=\"text\">\n" +
            "<h3 style='text-align: center;'> Patient Illness Description</h3>" +
            "        <TABLE border=\"0\" style=\"color: white;\" cellpadding=\"5px\">\n" +
            "            <tr>\n" +
            "                <td>Patient Name: " + result[event.target.id].patient.name + "</td>\n" +
            "                <td></td>\n" +
            "            </tr>\n" +
            "            <tr>\n" +
            "                <td>Center: Virtual Medical Home</td>\n" +
            "                <td></td>\n" +
            "            </tr>\n" +
            "            <tr>\n" +
            "                <td>Appointment No. " + result[event.target.id].appointment.id + "</td>\n" +
            "                <td></td>\n" +
            "            </tr>\n" +
            "            <tr>\n" +
            "                <td></td>\n" +
            "                <td></td>\n" +
            "            </tr>\n" +
            "            <tr>\n" +
            "                <td></td>\n" +
            "                <td></td>\n" +
            "            </tr>\n" +
            "            <tr>\n" +
            "                <th>Illness Reason: " + result[event.target.id].illness.title + "</th><td></td>\n" +
            "            </tr>\n" +
            "        </TABLE>\n" +
            "        <br>\n" +
            "        \n" +
            "<p style='margin: 0 0 0 9; font-size: 18; font-weight: bold;'>Illness Description:</p><p color=white style='font-size: 15px;text-align: left; margin: 10 10 10 10;'>" +
            result[event.target.id].illness.description + "</p>"
        "    </div>\n";
        document.getElementById("overlay").style.display = "block";
    }

    function appointmentdate(odate) {

        var date = odate.toString();
        var year = date.substring(0, 4);
        var month = date.substring(5, 7);
        var day = parseInt(date.substring(8, 10));
        day = day + 1;
        day = day.toString();
        return day + "/" + month + "/" + year;

    }

    function off() {
        document.getElementById("overlay").style.display = "none";
    }

</script>
</body>
</html>
