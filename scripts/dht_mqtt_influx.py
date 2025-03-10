import Adafruit_DHT
import paho.mqtt.client as mqtt
import ssl
import time
import os

# DHT sensor configuration
DHT_SENSOR = Adafruit_DHT.DHT22
DHT_PIN = 4  # GPIO pin where the sensor is connected

# MQTT configuration
MQTT_BROKER = "mqtt.akos-demo.com"
MQTT_PORT = 8883
MQTT_TOPIC = "home/raspberrypi/dht"
MQTT_CLIENT_ID = "raspberry_pi_dht_client"
MQTT_USERNAME = "akos_mqtt_user"
MQTT_PASSWORD = os.getenv('MQTT_PASSWORD')

# TLS configuration
TLS_CERT_PATH = "/etc/letsencrypt/live/mqtt.akos-demo.com/fullchain.pem"
TLS_KEY_PATH = "/etc/letsencrypt/live/mqtt.akos-demo.com/privkey.pem"
TLS_CA_CERTS = "/etc/letsencrypt/live/mqtt.akos-demo.com/chain.pem"

def read_dht_sensor():
    humidity, temperature = Adafruit_DHT.read_retry(DHT_SENSOR, DHT_PIN)
    if humidity is not None and temperature is not None:
        return humidity, temperature
    else:
        return None, None

def on_connect(client, userdata, flags, rc):
    if rc == 0:
        print("Connected to MQTT Broker!")
    else:
        print("Failed to connect, return code %d\n", rc)

def on_publish(client, userdata, mid):
    print("Message Published...")

def main():
    # Create MQTT client and configure TLS
    client = mqtt.Client(MQTT_CLIENT_ID)
    client.username_pw_set(MQTT_USERNAME, MQTT_PASSWORD)
    client.tls_set(ca_certs=TLS_CA_CERTS,
                   certfile=TLS_CERT_PATH,
                   keyfile=TLS_KEY_PATH,
                   cert_reqs=ssl.CERT_REQUIRED,
                   tls_version=ssl.PROTOCOL_TLS,
                   ciphers=None)
    client.tls_insecure_set(False)
    client.on_connect = on_connect
    client.on_publish = on_publish

    # Connect to MQTT broker
    client.connect(MQTT_BROKER, MQTT_PORT, 60)
    client.loop_start()

    try:
        while True:
            humidity, temperature = read_dht_sensor()
            if humidity is not None and temperature is not None:
                payload = f"Temperature: {temperature:.2f}C, Humidity: {humidity:.2f}%"
                result = client.publish(MQTT_TOPIC, payload)
                status = result[0]
                if status == 0:
                    print(f"Send `{payload}` to topic `{MQTT_TOPIC}`")
                else:
                    print(f"Failed to send message to topic {MQTT_TOPIC}")
            else:
                print("Failed to retrieve data from humidity sensor")

            time.sleep(10)  # Send data every 10 seconds
    except KeyboardInterrupt:
        print("Exiting...")
    finally:
        client.loop_stop()
        client.disconnect()

if __name__ == "__main__":
    main()