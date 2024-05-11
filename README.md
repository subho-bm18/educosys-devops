# educosys-devops : Overview of Circuit Breaker Design Pattern
The Circuit Breaker pattern is particularly useful in a microservices architecture where multiple services communicate over the network. Network communication is prone to latency and failures, which can cascade and cause significant issues in a distributed system.

Consider an e-commerce platform composed of multiple microservices, each responsible for different aspects of the system such as:

    Product Service: Manages product information and inventory.
    Order Service: Handles customer orders and communicates with the Payment and Product services.
    Payment Service: Processes payments and transactions.
    Shipping Service: Manages the delivery of orders.
    Customer Service: Manages customer profiles and data.


Use Case Example: Payment Processing

One of the critical operations in an e-commerce platform is payment processing. When a customer places an order, the Order Service needs to call the Payment Service to process the transaction. If the Payment Service is experiencing delays or failures due to high load, network issues, or internal errors, the Order Service could become overwhelmed with pending payment requests, which can lead to increased response times and a poor user experience.

Implementing a Circuit Breaker pattern in the Order Service when it calls the Payment Service can help manage these issues.

How the Circuit Breaker Pattern Can Help

    Normal Operation (Closed State):
        The Circuit Breaker starts in a closed state, allowing requests to pass through to the Payment Service.
        If the Payment Service starts to slow down or fails to respond, the Circuit Breaker records these failures.

    Failure Threshold Reached (Open State):
        If the number of failures exceeds a predefined threshold within a certain period, the Circuit Breaker opens.
        Once open, it prevents calls to the Payment Service and can return an immediate error response or a fallback mechanism (e.g., queuing the payment requests for later processing or using a cached response).
        This prevents the Order Service from making futile calls and allows the Payment Service to recover, reducing the potential for a cascading failure.

    Recovery (Half-Open State):
        After a predefined timeout, the Circuit Breaker enters a half-open state, allowing a limited number of test requests through to the Payment Service.
        If these requests succeed, the Circuit Breaker closes again, resuming normal operation.
        If the test requests fail, the Circuit Breaker opens again, continuing to block requests and allowing more time for recovery.


Detailed Example Flow

    A customer places an order on the e-commerce platform.
    The Order Service sends a request to the Payment Service to charge the customer's credit card.
    The Payment Service starts to respond slowly due to a surge in traffic during a holiday sale.
    The Order Service's Circuit Breaker detects that response times have increased and that some requests are timing out, causing the failure rate to exceed the threshold.
    The Circuit Breaker opens, immediately returning a "Service Unavailable" response to the Order Service.
    The Order Service can then:
        Notify the customer of the delay and retry the payment later.
        Queue the payment request for later processing.
        Offer the customer alternative payment options if available.
    After the timeout period, the Circuit Breaker allows a few requests to test the Payment Service's health.
    If the Payment Service is healthy:
        The Circuit Breaker closes, and full traffic resumes.
        Queued or delayed payment requests are processed.
    If the Payment Service is still unhealthy:
        The Circuit Breaker opens again, and the Order Service continues with the fallback mechanism.
        This process repeats until the Payment Service recovers.


Benefits of Using the Circuit Breaker Pattern

    Resilience: The pattern improves the system's resilience by preventing a service from becoming a bottleneck, which could lead to a cascading failure.
    Fault Tolerance: By providing a fallback mechanism, the system can continue operating despite partial outages.
    Recovery Support: The Circuit Breaker helps in managing the recovery of services by controlling the load sent to a failing service.
    Feedback: The pattern provides feedback to the system operators about the health of services, which can trigger alerts or invoke recovery procedures.


**#######  Project Overview: ######      
**

The code simulates an e-commerce platform where a PaymentService is used to process payments. To handle potential service failures, a CircuitBreaker pattern is implemented. The goal of the circuit breaker is to prevent a cascade of failures when a remote service is down or is too slow to respond, which could cause resource exhaustion and further service degradation.


**Main Components:
**

1. ECommercePlatform: Contains the main method to simulate the order processing flow using PaymentService.
PaymentService: Simulates a remote payment processing service that may fail after a certain number of successful requests.
CircuitBreaker: Implements the circuit breaker pattern to handle failures in the PaymentService.
Supplier<T>: A functional interface representing a supplier of results, which can throw an exception.

ECommercePlatform Main Method:
The main method initializes the PaymentService and the CircuitBreaker with a failure threshold of 3 and a timeout of 10 seconds. It then simulates 20 order requests in a loop. Each order request attempts a payment through the CircuitBreaker. If an exception occurs, it's caught, and after 3 failed attempts, the PaymentService is set to recover using recoverService(). Additionally, after every 5 successful attempts post-recovery, the service is reset to fail again using resetService().


2. PaymentService Class:


requestCount: Tracks the number of payment requests made.
thresholdForFailure: After 5 successful requests, the service starts failing.
isServiceRecovered: Indicates whether the service has been manually recovered.
processPayment(): Attempts to process a payment and simulates failures after a certain number of requests.
recoverService(): Recovers the service, making future calls to processPayment() succeed.
resetService(): Resets the service to its initial state, allowing it to simulate failures again.

3. CircuitBreaker Class:


failureThreshold: The number of failures that cause the circuit breaker to open.
failureCount: Tracks the number of consecutive failures.
lastFailureTime: The timestamp of the last failure.
timeout: The time period after which a half-open state will allow a test payment call.
state: The current state of the circuit breaker (CLOSED, OPEN, HALF_OPEN).
attemptPayment(Supplier<String> paymentCall): This method is the core of the Circuit Breaker pattern. It wraps the payment processing call and changes the state of the circuit breaker based on success or failure.
reset(): Resets the circuit breaker to the CLOSED state.
recordFailure(Exception exception): Records a failure, increments the failureCount, and may open the circuit if the failureThreshold is reached.

4. CircuitBreakerState Enum:
Defines the possible states of the circuit breaker:


CLOSED: Normal operation state, where calls are allowed through.
OPEN: The circuit is open, and calls are not allowed through to prevent further failures.
HALF_OPEN: A state where the circuit breaker allows a limited number of test calls to see if the underlying service has recovered.

**Execution Flow:
**

The CircuitBreaker is initially in the CLOSED state, allowing all payment attempts to proceed.
If the PaymentService fails more times than the failureThreshold, the CircuitBreaker transitions to the OPEN state. Further calls are blocked, and an exception with a message indicating the service is not available is thrown.
After the timeout duration has passed, the CircuitBreaker transitions to the HALF_OPEN state, allowing one test call through.
If the test call in the HALF_OPEN state succeeds, the CircuitBreaker resets to the CLOSED state, indicating the service is operational again.
If the test call fails, the CircuitBreaker reopens, incrementing the failureCount and setting the lastFailureTime.


Considerations

    Fallback Strategies: Define appropriate fallback strategies that maintain a good user experience during outages.
    Monitoring: Implementing monitoring and alerting for the Circuit
