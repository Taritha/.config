import os
import time
import argparse

if __name__ == "__main__":
    parser = argparse.ArgumentParser(description = "Simple script to display the current song's progress in spotify")
    parser.add_argument('-p', "--position", action='store_true')
    parser.add_argument('-c', "--percentage", action='store_true')
    parser.add_argument('-l', "--length", action='store_true')
    args = parser.parse_args()


    # Checks to see if spotify is open
    stream = os.popen('playerctl --player="spotify" status 2>/dev/null')
    output = stream.read()

    # This happens when there are no players found
    if output == '':
        print("00:00")
    else:
        # Gets song length
        stream = os.popen('playerctl --player="spotify" metadata | grep "length" | cut -d " " -f16')
        output = stream.read()



        length = int(output.rstrip())

        # Gets current position in song
        stream = os.popen('playerctl --player="spotify" metadata --format "{{position}}"')
        output = stream.read()
        pos = int(output.rstrip())

        if args.percentage:
            print(int((pos / length) * 100))
        elif args.position:
            print(time.strftime('%M:%S', time.gmtime(int(pos * 1e-6))))
        elif args.length:
            print(time.strftime('%M:%S', time.gmtime(int(length * 1e-6))))
            

    