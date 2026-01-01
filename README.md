Each project folder has a description.

To assemble each project I used AVRA with the command
```
avra -o out.hex [name].s
```

To program the ATmega328P I used an Arduino as ISP and AVRDUDE with the command
```
avrdude -c stk500v1 -p m328p -P /dev/ttyACM0 -U flash:w:out.hex
```
where "/dev/ttyACM0" is the port where my Arduino as ISP is connected. (the arduino running the Arduino as ISP sketch from the Arduino IDE)
