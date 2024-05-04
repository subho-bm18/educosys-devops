package com.subhodeep.circuitbreaker;
import java.util.Random;

public class ECommercePlatform {

    public static void main(String[] args) {
        PaymentService paymentService = new PaymentService();
        CircuitBreaker circuitBreaker = new CircuitBreaker(3, 10000); // 3 failures, 10-second timeout

        // Simulate multiple order requests
        for (int i = 0; i < 20; i++) {
            try {
                // Wrap the payment processing call with the circuit breaker
                String paymentResponse = circuitBreaker.attemptPayment(() -> paymentService.processPayment());
                System.out.println(paymentResponse);
            } catch (Exception e) {
                System.out.println("Order Service: " + e.getMessage());
            }

            // Simulate a short delay between requests
            try {
                Thread.sleep(500);
            } catch (InterruptedException e) {
                Thread.currentThread().interrupt();
            }
        }
    }

    // A mock PaymentService that randomly fails to simulate an unstable service
    static class PaymentService {
        Random random = new Random();

        String processPayment() {
            if (random.nextInt(100) < 70) { // 70% chance of failure
                throw new RuntimeException("Payment processing failed");
            }
            return "Payment processed successfully";
        }
    }

    // A simplified Circuit Breaker implementation
    static class CircuitBreaker {
        private int failureThreshold;
        private int failureCount;
        private long lastFailureTime;
        private long timeout;
        private CircuitBreakerState state;

        public CircuitBreaker(int failureThreshold, long timeout) {
            this.failureThreshold = failureThreshold;
            this.timeout = timeout;
            this.state = CircuitBreakerState.CLOSED;
        }

        public String attemptPayment(Supplier<String> paymentCall) throws Exception {
            if (state == CircuitBreakerState.OPEN) {
                if (System.currentTimeMillis() - lastFailureTime > timeout) {
                    state = CircuitBreakerState.HALF_OPEN;
                    System.out.println("Circuit Breaker is Half-Open. Allowing a test payment call.");
                } else {
                    throw new Exception("Circuit Breaker is Open. Payment Service is not available.");
                }
            }

            try {
                String response = paymentCall.get();
                if (state == CircuitBreakerState.HALF_OPEN) {
                    System.out.println("Test payment call succeeded. Circuit Breaker is closing.");
                }
                reset();
                return response;
            } catch (Exception e) {
                if (state == CircuitBreakerState.HALF_OPEN) {
                    System.out.println("Test payment call failed. Circuit Breaker is opening again.");
                    state = CircuitBreakerState.OPEN; // Reopen the circuit
                    lastFailureTime = System.currentTimeMillis(); // Reset the timer
                }
                recordFailure(e);
                throw new Exception("Payment Service failed. Please try again later.");
            }
        }

        private void reset() {
            failureCount = 0;
            state = CircuitBreakerState.CLOSED;
        }

        private void recordFailure(Exception exception) {
            failureCount++;
            lastFailureTime = System.currentTimeMillis();
            if (failureCount >= failureThreshold) {
                state = CircuitBreakerState.OPEN;
            }
        }

        enum CircuitBreakerState {
            CLOSED,
            OPEN,
            HALF_OPEN
        }
    }
    
    @FunctionalInterface
    interface Supplier<T> {
        T get() throws Exception;
    }
}
