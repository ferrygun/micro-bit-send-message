let data = ""
serial.onDataReceived(serial.delimiters(Delimiters.NewLine), () => {
    data = serial.readLine()
    basic.showString(data)
})
