
# define the GCD function since Scilab prefers to use a different function as gcd
def gcdn(a, b):
    xdb = a
    ydb = b
    while ydb != 0:
        r = xdb % ydb
        xdb = ydb
        ydb = r
    return xdb

# define the GCD function since Scilab prefers to use a different function as gcd
def calc_baud_gen(clk_MHz=48, baud_rate=115200):
    clk_Hz       = clk_MHz * 1e6
    baud_rate_16 = baud_rate * 16
    D_BAUD_FREQ  = int(baud_rate_16 / gcdn(clk_Hz, baud_rate_16))
    D_BAUD_LIMIT = int((clk_Hz / gcdn(clk_Hz, baud_rate_16)) - D_BAUD_FREQ)
    print("\nCalculated core baud rate generator parameters:")
    print("  when clk={}MHz, baud_rate={} :".format(clk_MHz, baud_rate))
    print("       D_BAUD_FREQ  = 12'd{}".format(D_BAUD_FREQ))
    print("       D_BAUD_LIMIT = 16'd{}\n".format(D_BAUD_LIMIT))
    return D_BAUD_FREQ, D_BAUD_LIMIT

if __name__ == '__main__':
    calc_baud_gen(clk_MHz=5, baud_rate=115200)