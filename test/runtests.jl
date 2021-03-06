using MultiQuad, Test, Unitful

@testset "quad" begin
    rtol = 1e-10

    xmin = 0
    xmax = 4
    func1(x) = x^2 * exp(-x)
    res = 2 - 26 / exp(4)
    int, err = quad(func1, xmin, xmax, rtol = rtol)
    @test isapprox(int, res, atol = err)
    @test typeof(quad(
        func1,
        xmin,
        xmax,
        rtol = rtol,
        method = :vegas,
    )[1]) == Float64
    @test typeof(quad(
        func1,
        xmin,
        xmax,
        rtol = rtol,
        method = :suave,
    )[1]) == Float64

    xmin2 = 0 * u"m"
    xmax2 = 4 * u"m"
    func2(x) = x^2
    res2 = 64 / 3
    int2, err2 = quad(func2, xmin2, xmax2, rtol = rtol)
    @test isapprox(int2, res2 * u"m^3", atol = err2)
    @test typeof(quad(
        func2,
        xmin2,
        xmax2,
        rtol = rtol,
        method = :vegas,
    )[1]) == typeof(1.0 * u"m^3")
    @test typeof(quad(
        func2,
        xmin2,
        xmax2,
        rtol = rtol,
        method = :suave,
    )[1]) == typeof(1.0 * u"m^3")

    @test_throws ErrorException quad(func1, 0, 4, method = :none)
end

@testset "dblquad" begin
    rtol = 1e-10

    xmin = 0
    xmax = 4
    ymin(x) = x^2
    ymax(x) = x^3

    func1(y, x) = y * x^3
    res1 = 241664 / 5
    int1, err1 = dblquad(func1, xmin, xmax, ymin, ymax, rtol = rtol)
    @test isapprox(int1, res1, atol = err1)
    @test typeof(dblquad(
        func1,
        xmin,
        xmax,
        ymin,
        ymax,
        rtol = rtol,
        method = :vegas,
    )[1]) == Float64
    @test typeof(dblquad(
        func1,
        xmin,
        xmax,
        ymin,
        ymax,
        rtol = rtol,
        method = :suave,
    )[1]) == Float64
    @test typeof(dblquad(
        func1,
        xmin,
        xmax,
        ymin,
        ymax,
        rtol = rtol,
        method = :divonne,
    )[1]) == Float64

    xmin2 = 0 * u"m"
    xmax2 = 4 * u"m"
    ymin2(x) = x^2 * u"m"
    ymax2(x) = x^3
    func2(y, x) = y * x^3

    int2, err2 = dblquad(func2, xmin2, xmax2, ymin2, ymax2, rtol = rtol)

    @test isapprox(int2, res1 * u"m^10", atol = err2)
    @test typeof(dblquad(
        func2,
        xmin2,
        xmax2,
        ymin2,
        ymax2,
        rtol = rtol,
        method = :vegas,
    )[1]) == typeof(1.0 * u"m^10")
    @test typeof(dblquad(
        func2,
        xmin2,
        xmax2,
        ymin2,
        ymax2,
        rtol = rtol,
        method = :suave,
    )[1]) == typeof(1.0 * u"m^10")
    @test typeof(dblquad(
        func2,
        xmin2,
        xmax2,
        ymin2,
        ymax2,
        rtol = rtol,
        method = :divonne,
    )[1]) == typeof(1.0 * u"m^10")

    @test_throws ErrorException dblquad(
        func1,
        xmin,
        xmax,
        ymin,
        ymax,
        rtol = rtol,
        method = :none,
    )
end

@testset "tblquad" begin
    rtol = 1e-10

    xmin = 0
    xmax = 4
    ymin(x) = x^2
    ymax(x) = x^3
    zmin(x, y) = 3
    zmax(x, y) = 4

    func1(z, y, x) = y * x^3 * sin(z)
    res = 241664 / 5 * (cos(3) - cos(4))
    int1, err1 = tplquad(func1, xmin, xmax, ymin, ymax, zmin, zmax, rtol = rtol)
    @test isapprox(int1, res, atol = err1)
    @test typeof(tplquad(
        func1,
        xmin,
        xmax,
        ymin,
        ymax,
        zmin,
        zmax,
        rtol = rtol,
        method = :vegas,
    )[1]) == Float64
    @test typeof(tplquad(
        func1,
        xmin,
        xmax,
        ymin,
        ymax,
        zmin,
        zmax,
        rtol = rtol,
        method = :suave,
    )[1]) == Float64
    @test typeof(tplquad(
        func1,
        xmin,
        xmax,
        ymin,
        ymax,
        zmin,
        zmax,
        rtol = rtol,
        method = :divonne,
    )[1]) == Float64

    xmin2 = 0 * u"m"
    xmax2 = 4 * u"m"
    ymin2(x) = x^2 * u"m"
    ymax2(x) = x^3
    zmin2(x, y) = 3
    zmax2(x, y) = 4

    func2(z, y, x) = y * x^3 * sin(z)
    int2, err2 = tplquad(
        func2,
        xmin2,
        xmax2,
        ymin2,
        ymax2,
        zmin2,
        zmax2,
        rtol = rtol,
    )
    @test isapprox(int2, res * u"m^10", atol = err2)
    @test typeof(tplquad(
        func2,
        xmin2,
        xmax2,
        ymin2,
        ymax2,
        zmin2,
        zmax2,
        rtol = rtol,
        method = :vegas,
    )[1]) == typeof(1.0 * u"m^10")
    @test typeof(tplquad(
        func2,
        xmin2,
        xmax2,
        ymin2,
        ymax2,
        zmin2,
        zmax2,
        rtol = rtol,
        method = :suave,
    )[1]) == typeof(1.0 * u"m^10")
    @test typeof(tplquad(
        func2,
        xmin2,
        xmax2,
        ymin2,
        ymax2,
        zmin2,
        zmax2,
        rtol = rtol,
        method = :divonne,
    )[1]) == typeof(1.0 * u"m^10")

    @test_throws ErrorException tplquad(
        func2,
        xmin2,
        xmax2,
        ymin2,
        ymax2,
        zmin2,
        zmax2,
        rtol = rtol,
        method = :none,
    )[1]
end
