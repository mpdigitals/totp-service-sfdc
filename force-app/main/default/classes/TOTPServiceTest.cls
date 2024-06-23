@IsTest
public class TOTPServiceTest {
    private class MockVerificationHandlerSuccess implements TOTPService.VerificationHandler {
        public Boolean performVerification(String totpCode) { 
            return true;
        }
    }

    private class MockVerificationHandlerFailure implements TOTPService.VerificationHandler {
        public Boolean performVerification(String totpCode) {
            return false;
        }
    }

    private class MockVerificationHandlerError implements TOTPService.VerificationHandler {
        public Boolean performVerification(String totpCode) {
            throw new CustomException('Mock error');
        }
    }

    private class CustomException extends Exception {}

    /**
     * @description Test method for successful TOTP verification.
     */
    @IsTest
    static void testVerifyTOTP_Success() {
        TOTPService.VerificationHandler mockHandler = new MockVerificationHandlerSuccess();
        TOTPService service = new TOTPService(mockHandler);

        TOTPService.VerificationRequest request = new TOTPService.VerificationRequest();
        request.totpCode = '123456';

        Test.startTest();
        TOTPService.VerificationResult result = service.verify(request);
        Test.stopTest();

        Assert.isTrue(result.isSuccess, 'Successful');
        Assert.areEqual('TOTP verification successful.', 'Message matchs');
    }

    /**
     * @description Test method for failed TOTP verification.
     */
    @IsTest
    static void testVerifyTOTP_Failure() {
        TOTPService.VerificationHandler mockHandler = new MockVerificationHandlerFailure();
        TOTPService service = new TOTPService(mockHandler);

        TOTPService.VerificationRequest request = new TOTPService.VerificationRequest();
        request.totpCode = '123456';

        Test.startTest();
        TOTPService.VerificationResult result = service.verify(request);
        Test.stopTest();

        Assert.isFalse(result.isSuccess, 'Fail');
        Assert.areEqual('TOTP verification failed.', 'Message matchs');
    }

    /**
     * @description Test method for error during TOTP verification.
     */
    @IsTest
    static void testVerifyTOTP_Error() {
        TOTPService.VerificationHandler mockHandler = new MockVerificationHandlerError();
        TOTPService service = new TOTPService(mockHandler);

        TOTPService.VerificationRequest request = new TOTPService.VerificationRequest();
        request.totpCode = '123456';

        Test.startTest();
        TOTPService.VerificationResult result = service.verify(request);
        Test.stopTest();

        System.debug('Result: ' + result);

        // Using Assert class for more readable assertions
        Assert.isFalse(result.isSuccess, 'Fail');
        Assert.isTrue(result.message.startsWith('Error during TOTP verification:'));
    }

    /**
     * @description Test the static method using the default constructor.
     */
    @IsTest
    static void testVerifyTOTP_StaticMethod() {
        TOTPService.VerificationRequest request = new TOTPService.VerificationRequest();
        request.totpCode = '123456'; 

        List<TOTPService.VerificationRequest> requests = new List<TOTPService.VerificationRequest> { request };

        Test.startTest();
        List<TOTPService.VerificationResult> results = TOTPService.verifyTOTP(requests);
        Test.stopTest();

        Assert.isNotNull(results[0].isSuccess, 'Success');
        Assert.isNotNull(results[0].message, 'Message not null');
    }
}