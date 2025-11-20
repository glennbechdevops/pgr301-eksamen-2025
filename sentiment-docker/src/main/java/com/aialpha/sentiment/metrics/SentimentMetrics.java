package com.aialpha.sentiment.metrics;

import io.micrometer.core.instrument.MeterRegistry;
import io.micrometer.core.instrument.Counter;
import io.micrometer.core.instrument.Timer;
import io.micrometer.core.instrument.DistributionSummary;
import org.springframework.stereotype.Component;

import java.util.concurrent.TimeUnit;
import java.util.concurrent.atomic.AtomicInteger;

@Component
public class SentimentMetrics {

    private final MeterRegistry meterRegistry;
    private final AtomicInteger lastCompanyCount;

    // Constructor injection of MeterRegistry
    public SentimentMetrics(MeterRegistry meterRegistry) {
        this.meterRegistry = meterRegistry;
        this.lastCompanyCount = new AtomicInteger(0);
        
        // Register the Gauge for companies detected
        // A Gauge is suitable here because this value can go up or down with each request
        meterRegistry.gauge("sentiment.companies.detected", 
            lastCompanyCount,
            AtomicInteger::get);
    }

    /**
     * Example implementation: Counter for sentiment analysis requests
     * This counter tracks the total number of sentiment analyses by sentiment type and company
     */
    public void recordAnalysis(String sentiment, String company) {
        Counter.builder("sentiment.analysis.total")
                .tag("sentiment", sentiment)
                .tag("company", company)
                .description("Total number of sentiment analysis requests")
                .register(meterRegistry)
                .increment();
    }

    /**
     * Timer implementation: Tracks the duration of sentiment analysis operations
     * Timer is ideal for measuring time-based operations as it provides:
     * - Count of operations
     * - Total time spent
     * - Maximum duration
     * - Percentiles (p50, p95, p99)
     */
    public void recordDuration(long milliseconds, String company, String model) {
        Timer.builder("sentiment.analysis.duration")
                .tag("company", company)
                .tag("model", model)
                .description("Duration of sentiment analysis operations in milliseconds")
                .register(meterRegistry)
                .record(milliseconds, TimeUnit.MILLISECONDS);
    }

    /**
     * Gauge implementation: Tracks the number of companies detected in the last analysis
     * Gauge is appropriate here because this value can increase or decrease with each request,
     * representing a "current state" rather than a cumulative count.
     * Unlike Counter (which only increases), Gauge can fluctuate both ways.
     */
    public void recordCompaniesDetected(int count) {
        lastCompanyCount.set(count);
    }

    /**
     * DistributionSummary implementation: Tracks the distribution of confidence scores
     * DistributionSummary is perfect for analyzing value distributions because it provides:
     * - Count of observations
     * - Total sum
     * - Maximum value
     * - Percentiles (useful for understanding confidence score distribution)
     * This helps identify if the model is consistently confident or uncertain.
     */
    public void recordConfidence(double confidence, String sentiment, String company) {
        DistributionSummary.builder("sentiment.confidence.score")
                .tag("sentiment", sentiment)
                .tag("company", company)
                .description("Distribution of confidence scores for sentiment analysis")
                .scale(100) // Scale to 0-100 range for better readability
                .register(meterRegistry)
                .record(confidence * 100); // Convert 0.0-1.0 to 0-100
    }
}
