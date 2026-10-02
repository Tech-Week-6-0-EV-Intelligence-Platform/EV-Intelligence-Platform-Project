import socket
import struct
import time

UDP_IP = "10.2.60.152"
UDP_PORT = 5000
sock = socket.socket(socket.AF_INET, socket.SOCK_DGRAM)

# Example Mixed Data
accelReq = 0.5         # Double (8 bytes)
                       
iginitionReq = True    # Boolean (1 byte)
brakeReq = 0.0         # Double (8 bytes)
driveMode = 0          # int32 (4 bytes)

# Total packet size = 8 + 4 + 1 + 4 = 17 bytes
# '<' ensures little-endian alignment (crucial for MATLAB)
packet_format = '<d?di'

print("Streaming mixed data types to MATLAB...")
try:
    while True:
        # Pack everything into a tight byte array
        packet = struct.pack(packet_format, accelReq, iginitionReq, brakeReq, driveMode)
        
        sock.sendto(packet, (UDP_IP, UDP_PORT))
        
        # Alter values slightly over time for testing
        accelReq += 0.1
        driveMode += 1
        iginitionReq = not iginitionReq
        
        time.sleep(0.1)
except KeyboardInterrupt:
    sock.close()