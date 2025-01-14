module TestDigitalCurrency
using AlphaVantage
using Test

TEST_SLEEP_TIME =  parse(Float64, get(ENV, "TEST_SLEEP_TIME", "15"))
MAX_TESTS = parse(Int64, get(ENV, "MAX_TESTS", "1"))

@testset "Digital Currencies" begin
    for f in (:digital_currency_daily, :digital_currency_weekly, :digital_currency_monthly, :digital_currency_intraday)
        @eval begin
            testname = string($f)
            @testset "$testname" begin
                @testset "AlphaVantageResponse" begin
                    data = $f("MSFT")
                    @test isa(data, AlphaVantageResponse)
                end
                sleep(TEST_SLEEP_TIME + 2*rand())
                @testset "JSON" begin
                    data = $f("BTC", datatype = "json")
                    @test typeof(data) === Dict{String,Any}
                    @test length(data) === 2
                end
                sleep(TEST_SLEEP_TIME + 2*rand())
                @testset "CSV" begin
                    data = $f("BTC", datatype = "csv")
                    @test typeof(data) === Tuple{Array{Any, 2}, Array{AbstractString, 2}}
                    @test length(data) === 2
                end
            end
        end
        sleep(TEST_SLEEP_TIME + 2*rand()) #as to not overload the API
    end

    @testset "crypto_rating" begin
        data = crypto_rating("BTC")
        @test typeof(data) === Dict{String, Any}
        @test length(data) === 1
        @test data["Crypto Rating (FCAS)"]["1. symbol"] === "BTC"
        sleep(TEST_SLEEP_TIME + 2*rand()) #as to not overload the API
    end

end

end # module
