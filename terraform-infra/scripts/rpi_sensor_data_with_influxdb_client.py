#!/usr/bin/python

import Adafruit_DHT
import influxdb_client
import os
import time
from influxdb_client import InfluxDBClient, Point, WritePrecision
from influxdb_client.client.write_api import SYNCHRONOUS
from influxdb_client.rest import ApiException
import urllib3

# Disable SSL warnings
urllib3.disable_warnings(urllib3.exceptions.InsecureRequestWarning)

def get_sensor_data():
    humidity, temperature = Adafruit_DHT.read_retry(sensor, pin)
    if humidity is None or temperature is None:
        raise ValueError("Failed to read from the sensor")
    return humidity, temperature

def write_to_influxdb(temperature, humidity):
    point1 = (
        Point("temperature")
        .tag("sensor_id", "1")
        .tag("location", "living_room")
        .field("value", temperature)
    )
    point2 = (
        Point("humidity")
        .tag("sensor_id", "1")
        .tag("location", "living_room")
        .field("value", humidity)
    )
    write_api.write(bucket=bucket, org=org, record=point1)
    write_api.write(bucket=bucket, org=org, record=point2)

sensor = Adafruit_DHT.DHT22
pin = 23

token = os.environ.get("INFLUXDB_TOKEN")
if not token:
    raise ValueError("INFLUXDB_TOKEN environment variable not set")

org = "influxdata"
url = "https://influxdb.akos-demo.com"

# Create an InfluxDB client with SSL verification disabled
write_client = influxdb_client.InfluxDBClient(url=url, token=token, org=org, verify_ssl=False)
bucket = "rpi-temperature-and-humidity"
write_api = write_client.write_api(write_options=SYNCHRONOUS)

while True:
    try:
        humidity, temperature = get_sensor_data()
        write_to_influxdb(temperature, humidity)
        print(f"Temperature: {temperature}°C, Humidity: {humidity}%")
    except ApiException as e:
        print(f"InfluxDB API Error: {e}")
    except Exception as e:
        print(f"Error: {e}")
    time.sleep(10)