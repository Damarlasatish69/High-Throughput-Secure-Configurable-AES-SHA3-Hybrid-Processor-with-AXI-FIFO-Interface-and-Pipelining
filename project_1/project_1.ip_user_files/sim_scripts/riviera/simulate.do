transcript off
onbreak {quit -force}
onerror {quit -force}
transcript on

asim +access +r +m+tb_hybrid  -L xil_defaultlib -L xpm -L unisims_ver -L unimacro_ver -L secureip -O5 xil_defaultlib.tb_hybrid xil_defaultlib.glbl

do {tb_hybrid.udo}

run 1000ns

endsim

quit -force
