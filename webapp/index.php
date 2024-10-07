<?php
// Check if the request is a POST request
if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    // Get all the headers from the request
    $headers = getallheaders();

    // Check if the 'NotBad' header exists and its value is 'true'
    if (isset($headers['NotBad']) && $headers['NotBad'] === 'true') {
        // Respond with "ReallyNotBad"
        echo "ReallyNotBad";
    } else {
        // Respond with an error message if the header is not set or incorrect
        http_response_code(400);
        echo "Bad Request: 'NotBad' header is missing or incorrect.";
    }
} else {
    // Respond with an error message if the request method is not POST
    http_response_code(405);
    echo "Method Not Allowed: Only POST requests are supported.";
}
