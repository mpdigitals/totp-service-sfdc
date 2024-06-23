/*
 * @author mpdigitals 
 * @date June 2024
 * 
 * This class provides methods to verify TOTP codes using 
 * Salesforce's User Management.
 */
public with sharing class TOTPService {
    static final String SUCCESS_MESSAGE = 'TOTP verification successful.';
    static final String FAILURE_MESSAGE = 'TOTP verification failed.';
    static final String ERROR_MESSAGE_PREFIX = 'Error during TOTP verification: ';

    private VerificationHandler verificationHandler;

    /**
     * @description Default constructor using the real VerificationHandler implementation.
     */
    public TOTPService() {
        this.verificationHandler = new VerificationHandlerImpl();
    }

    /**
     * @description Constructor for injecting custom VerificationHandler, exposed for testing.
     * @param handler Custom verification handler.
     */
    @TestVisible
    TOTPService(VerificationHandler handler) {
        this.verificationHandler = handler;
    }

    /**
     * @description Invocable method to verify TOTP code for TOTP.
     * @param requests List of VerificationRequest containing the TOTP code.
     * @return List of VerificationResult containing the verification status and message.
     */
    @InvocableMethod(label='Verify TOTP' description='Verify TOTP code')
    public static List<VerificationResult> verifyTOTP(List<VerificationRequest> requests) {
        TOTPService service = new TOTPService();
        VerificationResult result = service.verify(requests[0]);
        return new List<VerificationResult> { result };
    }

    /**
     * @description Method to verify TOTP code.
     * @param request VerificationRequest containing the TOTP code.
     * @return VerificationResult containing the verification status and message.
     */
    public VerificationResult verify(VerificationRequest request) {
        VerificationResult result = new VerificationResult();

        try {
            Boolean verificationSuccess = verificationHandler.performVerification(request.totpCode);
            if (verificationSuccess) {
                result.isSuccess = true;
                result.message = SUCCESS_MESSAGE;
            } else {
                result.isSuccess = false;
                result.message = FAILURE_MESSAGE;
            }
        } catch (Exception e) {
            result.isSuccess = false;
            result.message = ERROR_MESSAGE_PREFIX + e.getMessage();
        }

        return result;
    }

    /**
     * @description Interface for dependency injection to perform verification.
     */
    public interface VerificationHandler {
        Boolean performVerification(String totpCode); 
    }

    /**
     * @description Real implementation of the VerificationHandler.
     */
    private class VerificationHandlerImpl implements VerificationHandler {
        public Boolean performVerification(String totpCode) {
            Auth.VerificationResult verificationResult = System.UserManagement.verifyVerificationMethod(
                UserInfo.getUserId(), totpCode, Auth.VerificationMethod.TOTP
            );
            return verificationResult.success;
        }
    }

    /**
     * @description Wrapper class to encapsulate the request for TOTP verification.
     */
    public class VerificationRequest {
        @InvocableVariable(required=true)
        public String totpCode;
    }

    /**
     * @description Wrapper class to encapsulate the result of TOTP verification.
     */
    public class VerificationResult {
        @InvocableVariable
        public Boolean isSuccess;

        @InvocableVariable
        public String message;
    }
}