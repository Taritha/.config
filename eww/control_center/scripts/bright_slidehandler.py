from pynput.keyboard import Events
import pidfile
from subprocess import run
import argparse


# Checks for changes in the slider
def update_slideval():
    # Run until user stops using slider
    with Events() as events:
        while True:
            # Block at most 1s
            event = events.get(1.0)

            # If nothing is pressed for 1s, stop
            if event is None:
                # Query desired brightness level from slider position
                slider_cmd = "eww --config ~/.config/eww/control_center/ state | grep 'brightness: ' | sed 's/[[:alpha:]]//g' | sed 's/: //g'"
                cmd_output = run(slider_cmd, cwd='/', capture_output=True, shell=True)
                sliderval = int(float(str(cmd_output.stdout.strip())[2:-1]))

                # Shows sliderval (DEBUG)
                # run('dunstify "{}"'.format(sliderval), shell=True)

                # Alter brightness
                bright_cmd = f'python ~/.config/eww/control_center/scripts/change_brightness.py -set {sliderval}'
                run(bright_cmd, shell=True)
                break
            # Keep listener open with randy ass key I never use lol (and update brightness slider value)
            elif str(event.key) == 'Key.pause':
                continue
    return


if __name__ == '__main__':
    # Ensures only one instance of this script can run at a time
    with pidfile.PIDFile():
        # Tracks brightness changes from slider
        update_slideval()
