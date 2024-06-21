# TOTPService - README

## Overview

The `TOTPService` class allows for the verification of TOTP codes via invocable actions from Flows and other components or directly from Apex. This service provides an extra layer of security not only for records or any process. The repository includes a couple of fields and a triggered Flow for demonstration purposes.

## Installation

To deploy the `TOTPService`, you can either deploy the entire repository or just the necessary classes and labels if you prefer to implement your own examples.

### Deployment Steps:

1. Clone the repository or download the zip file.
2. Deploy the `TOTPService` class and associated labels.
3. Optionally, deploy the sample Flow and fields (`TOTP__c` and `VIP__c`) for testing.

## Usage

### Invocable Method

The `TOTPService` class provides an invocable method `verifyTOTP` that can be used in Salesforce Flows. This method verifies the provided TOTP code and returns the verification result.

#### Example Usage in Flow:

1. Add an action in your Triggered-Flow and select `TOTPService.verifyTOTP`.
2. Provide the necessary inputs (TOTP code).
3. Use the output of the action to handle the verification result in your Flow logic.

### Using Apex

You can also use the `TOTPService` class directly from Apex code. Here's an example of how to call the service from an anonymous Apex block:

```apex
TOTPService.VerificationRequest request = new TOTPService.VerificationRequest();
request.totpCode = '123456';

List<TOTPService.VerificationRequest> requests = new List<TOTPService.VerificationRequest> { request };
List<TOTPService.VerificationResult> results = TOTPService.verifyTOTP(requests);

for (TOTPService.VerificationResult result : results) {
    System.debug(result.message);
}
