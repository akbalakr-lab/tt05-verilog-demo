import cocotb
from cocotb.clock import Clock
from cocotb.triggers import RisingEdge, FallingEdge, Timer, ClockCycles

@cocotb.test()
async def test_my_design(dut):

    CONSTANT_CURRENT = 200
    dut._log.info("start")

    clock = Clock(dut.clk, 1, units="ns") # Create a 1ns period clock on port clk
    cocotb.start_soon(clock.start()) # Start the clock

    dut.rst_n.value = 0 # low to reset
    await ClockCycles(dut.clk, 10)
    dut.rst_n.value = 1 # assert reset

    dut.ui_in.value = CONSTANT_CURRENT
    dut.ena.value = 1 # enable design

    # await ClockCycles(dut.clk, 100)
    for _ in range(100):
        await RisingEdge(dut.clk)
        # dut._log.info(f"ui_in: {dut.ui_in.value}, ui_out: {dut.ui_out.value}")
                      
    dut._log.info("Finished Test")
    
    dut.ena.value = 0 # disable design