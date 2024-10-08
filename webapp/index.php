<?php
if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    $headers = getallheaders();

    if (isset($headers['NotBad']) && $headers['NotBad'] === 'true') {
        echo "ReallyNotBad";
    } 
    elseif (isset($headers['World']) && $headers['World'] === 'true') {
        echo "Hello World";
    }
    else {
        http_response_code(400);
        echo "Bad Request: 'NotBad' header is missing or incorrect.";
    }
} else {
    http_response_code(405);
    echo "Method Not Allowed: Only POST requests are supported.";
}
