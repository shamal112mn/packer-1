$(document).ready(function() {var formatter = new CucumberHTML.DOMFormatter($('.cucumber-report'));formatter.uri("src/test/resources/features/delete.feature");
formatter.feature({
  "name": "",
  "description": "",
  "keyword": "Feature"
});
formatter.scenarioOutline({
  "name": "Deleting student End to End scenario",
  "description": "",
  "keyword": "Scenario Outline",
  "tags": [
    {
      "name": "@createStudent"
    }
  ]
});
formatter.step({
  "name": "user deletes student with \"\u003cresource\u003e\"",
  "keyword": "Given "
});
formatter.step({
  "name": "user goes to cybertek training application",
  "keyword": "And "
});
formatter.step({
  "name": "user searches for student with student ID \"\u003cstudentID\u003e\"",
  "keyword": "Then "
});
formatter.step({
  "name": "user verifies that no result should show",
  "keyword": "And "
});
formatter.examples({
  "name": "",
  "description": "",
  "keyword": "Examples",
  "rows": [
    {
      "cells": [
        "resource",
        "studentID"
      ]
    },
    {
      "cells": [
        "/student/delete/7651",
        "7651"
      ]
    }
  ]
});
formatter.scenario({
  "name": "Deleting student End to End scenario",
  "description": "",
  "keyword": "Scenario Outline",
  "tags": [
    {
      "name": "@createStudent"
    }
  ]
});
formatter.step({
  "name": "user deletes student with \"/student/delete/7651\"",
  "keyword": "Given "
});
formatter.match({});
formatter.result({
  "status": "undefined"
});
formatter.step({
  "name": "user goes to cybertek training application",
  "keyword": "And "
});
formatter.match({});
formatter.result({
  "status": "undefined"
});
formatter.step({
  "name": "user searches for student with student ID \"7651\"",
  "keyword": "Then "
});
formatter.match({});
formatter.result({
  "status": "undefined"
});
formatter.step({
  "name": "user verifies that no result should show",
  "keyword": "And "
});
formatter.match({});
formatter.result({
  "status": "undefined"
});
});