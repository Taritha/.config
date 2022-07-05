#!/usr/bin/env python3
import dbus

bus = dbus.SessionBus()
prop = bus.get_object('org.clight.clight','/org/clight/clight')
currVal = prop.Get('org.clight.clight','BlPct',dbus_interface='org.freedesktop.DBus.Properties')
print('{:.2f}'.format(currVal * 100))