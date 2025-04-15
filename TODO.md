# Senior SRE Work Sample

This work sample evaluates your ability to identify gaps in instrumentation, detect performance bottlenecks, and provide actionable recommendations to improve system reliability and performance.

## Scenario

At TEST, automation is a cornerstone of ensuring quality and reliability in our payment orchestration platform. Your task is to assess a sample application, implement changes in support of observability (assume distributed tracing is supported and the host agent is properly configured), and highlight issues with moving this application to production. The application given to you is a Ruby on Rails web app that accepts an API request at http://localhost:3000/api/v1/payment_methods/tokenize with a payment method body. It then makes an API request to TEST to attempt to tokenize the payment method information and returns a response indicating its status. 

## Your Task

1. Set up the application

  &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; a. Download and unzip this application work-sample-main.zip (attached to original email)

  &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; b. Initialize git in your application and save the current changes as the first commit on the default branch.
  
  &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;(git init, git add ., git commit -m "my commit message")

  &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; c. Check out a new branch locally (git checkout -b work-sample)

2. Update the application!

  &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; a. Implement APM configurations, you can choose Datadog or OpenTelemetry

  &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; b. Add any additional metrics where needed

  &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; c. Update the ReadMe with information on how you would implement automated observability for this application
  
  &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;and what data you would build into automated alerts.

  &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; d. Add any tests, health checks, or status codes as needed.

  &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; e. You are welcome to use/import any gems that may be helpful

  &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; f. You are welcome to refactor any code. 

## Evaluation Criteria

Instrumentation Insight: Ability to identify gaps in monitoring and provide actionable solutions.

Analytical Skills: Depth of analysis in identifying performance bottlenecks and root causes.

Practical Solutions: Feasibility and clarity of recommendations for improving reliability and observability.

Communication: Clear, structured documentation and reporting.

## Submission

When you are done please capture your work in a patchfile. Making sure you're still in your work-sample working branch, and all files are committed, do the following: git format-patch main --stdout > yourname.patch 

You can test that the patch file will apply cleanly by checking back out the main branch and running: git am -3 yourname.patch\