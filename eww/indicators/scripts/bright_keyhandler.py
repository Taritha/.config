from pynput.keyboard import Events
from subprocess import run
import time
import pidfile


# Checks for key changes to trigger eww stuff
def handle_keys(brightlevel):
    # Run until the brightness keys have not been touched for 3s
    with Events() as events:
        while True:
            # Block at most 1s
            event = events.get(1.0)

            # If nothing relevant is pressed for 1.0s, stop
            if event is None or (str(event.key) != '<269025026>' and str(event.key) != '<269025027>'):
                eww_close = 'eww -c ~/.config/eww/indicators close brightness-indicator'
                update_brightness = f'python ~/.config/eww/control_center/scripts/change_brightness.py -set {brightlevel}'
                run(update_brightness, shell=True)
                time.sleep(0.1)
                run(eww_close, shell=True)
                break

            # Brightness up key == '<269025026>'
            elif str(event.key) == '<269025026>':
                if isinstance(event, Events.Release): continue # Ignore release events
                if brightlevel + 5 > 100: brightlevel = 100
                else: brightlevel += 5

            #Brightness down key == '<269025027>'
            elif str(event.key) == '<269025027>':
                if isinstance(event, Events.Release): continue # Ignore release events
                if brightlevel - 5 < 0: brightlevel = 0
                else: brightlevel -= 5
                
            # Update shown brightness level
            eww_update_cmd = f'eww -c $HOME/.config/eww/indicators/ update brightness-level={brightlevel}'
            run(eww_update_cmd, shell=True)
    return


if __name__ == '__main__':
    # Ensures only one instance of this script runs at a time
    with pidfile.PIDFile():
        query_brightness = 'python eww/control_center/scripts/get_brightnesslevel.py'
        cmd_output = run(query_brightness.split(), capture_output=True)
        curr_brightness = int(float(str(cmd_output.stdout.strip())[2:-1]))

        # Open brightness indicator and update shown brightness level
        eww_update_cmd = f'eww -c ~/.config/eww/indicators/ update brightness-level={curr_brightness}'
        run(eww_update_cmd, shell=True)
        eww_open_cmd = 'eww -c ~/.config/eww/indicators/ open brightness-indicator'
        run(eww_open_cmd, shell=True)
        
        # Tracks brightness levels to elminiate need for re-querying
        handle_keys(curr_brightness)