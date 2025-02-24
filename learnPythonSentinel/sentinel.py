#!/opt/anaconda2/bin/python
# SENTINEL
# A USB rocket launcher face-tracking solution
# For Linux and Windows
#
# Installation: see README.md
#
# Usage: sentinel.py [options]
#
# Options:
#   -h, --help            show this help message and exit
#   -l ID, --launcher=ID  specify VendorID of the missile launcher to use.
#                         Default: '2123' (dreamcheeky thunder)
#   -d, --disarm          track faces but do not fire any missiles
#   -r, --reset           reset the turret position and exit
#   --nd, --no-display    do not display captured images
#   -c NUM, --camera=NUM  specify the camera # to use. Default: 0
#   -s WIDTHxHEIGHT, --size=WIDTHxHEIGHT
#                         image dimensions (recommended: 320x240 or 640x480).
#                         Default: 320x240
#   -b SIZE, --buffer=SIZE
#                         size of camera buffer. Default: 2
#   -v, --verbose         detailed output, including timing information

import os
import sys
import time
import usb.core
import cv2
import subprocess
import shutil
import math
from optparse import OptionParser
from datetime import datetime

# globals
FNULL = open(os.devnull, 'w')


# http://stackoverflow.com/questions/4984647/accessing-dict-keys-like-an-attribute-in-python
class AttributeDict(dict):
    __getattr__ = dict.__getitem__
    __setattr__ = dict.__setitem__


# Launcher commands for USB Missile Launcher (VendorID:0x1130 ProductID:0x0202 Tenx Technology, Inc.)
class Launcher1130():
    # Commands and control messages are derived from
    # http://sourceforge.net/projects/usbmissile/ and http://code.google.com/p/pymissile/

    # 7 Bytes of Zeros to fill 64 Bit packet (8 Bit for direction/action + 56 Bit of Zeros to fill packet)
    cmdFill = [0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
               0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
               0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
               0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
               0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
               0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
               0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00]

    # Low level launcher driver commands
    # this code mostly taken from https://github.com/nmilford/stormLauncher
    # with bits from https://github.com/codedance/Retaliation
    def __init__(self):
        # HID detach for Linux systems...not tested with 0x1130 product
        self.dev = usb.core.find(idVendor=0x1130, idProduct=0x0202)
        if self.dev is None:
            raise ValueError('Missile launcher not found.')
        if sys.platform == "linux":
            try:
                if self.dev.is_kernel_driver_active(1) is True:
                    self.dev.detach_kernel_driver(1)
                else:
                    self.dev.detach_kernel_driver(0)
            except Exception as e:
                pass

        self.dev.set_configuration()

    def turretLeft(self):
        cmd = [0x00, 0x01, 0x00, 0x00, 0x00, 0x00, 0x08, 0x08] + self.cmdFill
        self.turretMove(cmd)

    def turretRight(self):
        cmd = [0x00, 0x00, 0x01, 0x00, 0x00, 0x00, 0x08, 0x08] + self.cmdFill
        self.turretMove(cmd)

    def turretUp(self):
        cmd = [0x00, 0x00, 0x00, 0x01, 0x00, 0x00, 0x08, 0x08] + self.cmdFill
        self.turretMove(cmd)

    def turretDown(self):
        cmd = [0x00, 0x00, 0x00, 0x00, 0x01, 0x00, 0x08, 0x08] + self.cmdFill
        self.turretMove(cmd)

    def turretFire(self):
        cmd = [0x00, 0x00, 0x00, 0x00, 0x00, 0x01, 0x08, 0x08] + self.cmdFill
        self.turretMove(cmd)

    def turretStop(self):
        cmd = [0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x08, 0x08] + self.cmdFill
        self.turretMove(cmd)

    def ledOn(self):
        # cannot turn on LED. Device has no LED.
        pass

    def ledOff(self):
        # cannot turn off LED. Device has no LED.
        pass

    # Missile launcher requires two init-packets before the actual command can be sent.
    # The init-packets consist of 8 Bit payload, the actual command is 64 Bit payload
    def turretMove(self, cmd):
        # Two init-packets plus actual command
        self.dev.ctrl_transfer(0x21, 0x09, 0x2, 0x01, [ord('U'), ord('S'), ord('B'), ord('C'), 0, 0, 4, 0])
        self.dev.ctrl_transfer(0x21, 0x09, 0x2, 0x01, [ord('U'), ord('S'), ord('B'), ord('C'), 0, 64, 2, 0])
        self.dev.ctrl_transfer(0x21, 0x09, 0x2, 0x00, cmd)

        # roughly centers the turret

    def center(self):

        self.turretLeft()
        time.sleep(5)

        self.turretRight()
        time.sleep(5)

        self.turretStop()

        self.turretUp()
        time.sleep(3)

        self.turretDown()
        time.sleep(0.5)

        self.turretStop()


# Launcher commands for DreamCheeky Thunder (VendorID:0x2123 ProductID:0x1010)
class Launcher2123():
    # Low level launcher driver commands
    # this code mostly taken from https://github.com/nmilford/stormLauncher
    # with bits from https://github.com/codedance/Retaliation
    def __init__(self):
        print("Launcher2123 init()  sys.platform=%s" % sys.platform)
        self.dev = usb.core.find(idVendor=0x2123, idProduct=0x1010)
        if self.dev is None:
            raise ValueError('Missile launcher not found.')
        if sys.platform == 'linux2' and self.dev.is_kernel_driver_active(0) is True:
            self.dev.detach_kernel_driver(0)
        self.dev.set_configuration()

    def turretUp(self):
        self.dev.ctrl_transfer(0x21, 0x09, 0, 0, [0x02, 0x02, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00])

    def turretDown(self):
        self.dev.ctrl_transfer(0x21, 0x09, 0, 0, [0x02, 0x01, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00])

    def turretLeft(self):
        self.dev.ctrl_transfer(0x21, 0x09, 0, 0, [0x02, 0x04, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00])

    def turretRight(self):
        self.dev.ctrl_transfer(0x21, 0x09, 0, 0, [0x02, 0x08, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00])

    def turretStop(self):
        self.dev.ctrl_transfer(0x21, 0x09, 0, 0, [0x02, 0x20, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00])

    def turretFire(self):
        self.dev.ctrl_transfer(0x21, 0x09, 0, 0, [0x02, 0x10, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00])

    def ledOn(self):
        self.dev.ctrl_transfer(0x21, 0x09, 0, 0, [0x03, 0x01, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00])

    def ledOff(self):
        self.dev.ctrl_transfer(0x21, 0x09, 0, 0, [0x03, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00])

    # roughly centers the turret
    def center(self):
        print('Centering camera started.')

        self.turretLeft()
        time.sleep(5)

        self.turretRight()
        time.sleep(3.25)

        self.turretUp()
        time.sleep(3)

        self.turretDown()
        time.sleep(1)

        self.turretStop()
        print('Centering camera finished.')


class Turret():
    def __init__(self, opts):
        self.opts = opts

        # Choose correct Launcher
        print("Turret()  opts.launcherID=%s" % opts.launcherID)
        if opts.launcherID == "1130":
            self.launcher = Launcher1130();
            self.missiles_remaining = 3
        else:
            self.launcher = Launcher2123();
            self.missiles_remaining = 4

        # initial setup
        self.center()
        self.launcher.ledOff()
        self.cooldown_time = 3
        self.killcam_count = 0

    # turn off turret properly
    def dispose(self):
        self.launcher.turretStop()
        turret.launcher.ledOff()

    # roughly centers the turret
    def center(self):
        self.launcher.center()

    ######################################################################
    # calculateDownSecondsWithDistance()
    #
    ######################################################################
    def calculateDownSecondsWithDistance(self, aY, aFaceSize):
        print("calculateDownSecondsWithDistance()  aY=", aY, " aFaceSize=", aFaceSize)

        down_secs = 0.0

        if (aY <= -.41):
            # the Y value is -.41 or lower  (6' tall)
            down_secs = -0.85

        elif (aY <= -.30):
            # the Y value is between -.30 and -.41   (5.5' tall)
            down_secs = -0.80

        elif (aY <= -.20):
            # the Y value is between -.35 and -.20  (5' tall)
            down_secs = -0.65

        elif (aY <= 0):
            # the Y value is between -.20 and zero  (4.5' tall)
            down_secs = -0.58

        elif (aY <= 0.1):
            # the Y value is between zero and .1   (4' tall)
            down_secs = -.50

        elif (aY <= 0.2):
            # the Y value is between .1 and .2   (3.5' tall)
            down_secs = -.45

        elif (aY <= 0.3):
            # the Y value is between .2 and .3   (3' tall)
            down_secs = -.35

        elif (aY <= 0.4):
            # the Y value is between .3 and .4   (2.5' tall)
            down_secs = -.25

        elif (aY <= 0.5):
            # the Y value is between .4 and .5   (2.25' tall)
            down_secs = 0

        else:
            # the Y value is between .5 higher
            down_secs = 0

        print("Return down_secs=", down_secs)
        return down_secs

    ######################################################################
    # calculateRightSecondsWithDistance()
    #
    ######################################################################
    def calculateRightSecondsWithDistance(self, aX, aFaceSize):
        print("calculateRightSecondsWithDistance()  aX=", aX, " aFaceSize=", aFaceSize)

        right_secs = 0

        if (aX <= -.45):
            # the X value is between -.45 and -.55  (Left 18")
            right_secs = -0.55

        elif (aX <= -.35):
            # the X value is between -.35 and -.45  (Left 18")
            right_secs = -0.45

        elif (aX <= -.25):
            # the X value is between -.25 and -.35  (Left 18")
            right_secs = -0.35

        elif (aX <= -.15):
            # the X value is between -.15 and -.25   (Left 12")
            right_secs = -0.23

        elif (aX <= -.1):
            # the X value is between -.10  and -.15  (Left 6")
            right_secs = -0.15

        elif (aX <= 0):
            # the X value is between -.1 and zero   (no change)
            right_secs = 0

        elif (aX <= .12):
            # the X value is between zero and .12   (Right 6")
            right_secs = 0.05

        elif (aX <= .2):
            # the X value is between .12 and .2  (Right 12")
            right_secs = 0.10

        elif (aX <= .3):
            # the X value is between .2 and .3  (Right 18")
            right_secs = 0.20

        elif (aX <= .4):
            # the X value is between .3 and .4  (Right 24")
            right_secs = 0.30

        elif (aX <= .5):
            # the X value is between .4 and .5  (Right 30")
            right_secs = 0.40


        else:
            # the X value is between .5 higher
            right_secs = 0

        print("Return right_secs=", right_secs)
        return right_secs

    ######################################################################
    # adjust()
    #
    # adjusts the turret's position (units are fairly arbitary but work ok)
    ######################################################################
    def adjust(self, aRightDistance, aDownDistance, aFaceSize):

        # Adjust the up/down
        down_seconds = self.calculateDownSecondsWithDistance(aDownDistance, aFaceSize)

        # Adjust the right/left
        right_seconds = self.calculateRightSecondsWithDistance(aRightDistance, aFaceSize)

        if right_seconds > 0:
            # Move Turret to the **Right**
            print("   Moving turret right for ", right_seconds, " seconds")
            self.launcher.turretRight()
            time.sleep(right_seconds)
            self.launcher.turretStop()

        elif right_seconds < 0:
            # Move Turret to the **Left**
            print("   Moving turret left for ", -1 * right_seconds, " seconds")
            self.launcher.turretLeft()
            time.sleep(- right_seconds)
            self.launcher.turretStop()

        if down_seconds > 0:
            # Move turret **Down**
            print("   Moving turret down for ", down_seconds, " seconds")
            self.launcher.turretDown()
            time.sleep(down_seconds)
            self.launcher.turretStop()

        elif down_seconds < 0:
            # Move turret **Up**
            print("   Moving turret up for ", -1 * down_seconds, " seconds")
            self.launcher.turretUp()
            time.sleep(- down_seconds)
            self.launcher.turretStop()

        # OpenCV takes pictures VERY quickly, so if we use it (Windows and OS X), we must
        # add an artificial delay to reduce camera wobble and improve clarity
        if sys.platform == 'win32' or sys.platform == 'darwin':
            time.sleep(.2)

    # stores images of the targets within the killcam folder
    def killcam(self, camera):
        # create killcam dir if none exists, then find first unused filename
        if not os.path.exists("killcam"):
            os.makedirs("killcam")
        filename_locked_on = os.path.join("killcam", "lockedon" + str(self.killcam_count) + ".jpg")
        while os.path.exists(filename_locked_on):
            self.killcam_count += 1
            filename_locked_on = os.path.join("killcam", "lockedon" + str(self.killcam_count) + ".jpg")

        # save the image with the target being locked on
        shutil.copyfile(self.opts.processed_img_file, filename_locked_on)

        # wait a little bit to attempt to catch the target's reaction.
        time.sleep(1)  # tweak this value for most hilarious action shots

        # take another picture of the target while it is being fired upon
        filename_firing = os.path.join("killcam", "firing" + str(self.killcam_count) + ".jpg")
        camera.capture()
        camera.face_detect(filename=filename_firing)

        self.killcam_count += 1

    ######################################################################
    # projectile_compensation()
    #
    # compensate vertically for distance to target
    ######################################################################
    def projectile_compensation(self, target_y_size):

        if target_y_size != 0:
            # objects further away will need a greater adjustment to hit target
            adjust_amount = 0.2 * math.log(target_y_size)
        else:
            # log 0 will throw an error, so handle this case even though unlikely to occur
            adjust_amount = 0

        # tilt the turret up to try to increase range
        self.adjust(0, adjust_amount)
        if opts.verbose:
            print("size of target: %.6f" % target_y_size)
            print("compensation up: %.6f millisec" % adjust_amount)

    ######################################################################
    # ready_aim_fire()
    # turn on LED if face detected in range, and fire missiles if armed
    ######################################################################
    def ready_aim_fire(self, x_adj, y_adj, target_y_size, camera=None):
        print("ready_aim_fire()  x_adj=", x_adj, " y_adj=", y_adj, "  target_y_size=", target_y_size)
        fired = False

        #        if face_detected and abs(x_adj) < .02 and abs(y_adj) < .02:
        if face_detected:

            if self.opts.armed:
                # aim a little higher if our target is in the distance
                # self.projectile_compensation(target_y_size)

                # Fire the missile
                print("F I R E")
                turret.launcher.turretFire()

                self.missiles_remaining -= 1
                fired = True

                if camera:
                    self.killcam(camera)  #a save a picture of the target

                print('Missile fired! Estimated ' + str(self.missiles_remaining) + ' missiles remaining.')

                # Give the turret a few seconds to fire
                time.sleep(2)

                if self.missiles_remaining < 1:
                    raw_input("No more ammo.  Awaiting order to continue assault. [ENTER]")
                    self.missiles_remaining = 4
            else:
                print('Turret trained but not firing because of the --disarm directive.')

        print("ready_aim_fire() finished.")
        return fired


class Camera():
    def __init__(self, opts):
        self.opts = opts
        self.current_image_viewer = None  # image viewer not yet launched

        self.webcam = cv2.VideoCapture(int(self.opts.camera))  # open a channel to our camera
        if (not self.webcam.isOpened()):  # return error if unable to connect to hardware
            raise ValueError('Error connecting to specified camera')
        self.clear_buffer()

        # initialize classifier with training set of faces
        self.face_filter = cv2.CascadeClassifier(self.opts.haar_file)

    # turn off camera properly
    def dispose(self):
        if sys.platform == 'linux2' or sys.platform == 'darwin':
            if self.current_image_viewer:
                subprocess.call(['killall', self.current_image_viewer], stdout=FNULL, stderr=FNULL)
        else:
            self.webcam.release()

    # grabs several images from buffer to attempt to clear out old images
    def clear_buffer(self):
        for _ in range(self.opts.buffer_size):
            if not self.webcam.retrieve():
                raise ValueError('no more images in buffer, mate')

    # captures a single frame
    def capture(self):
        if not self.webcam.grab():
            raise ValueError('frame grab failed')
        self.clear_buffer()

        retval, most_recent_frame = self.webcam.retrieve()
        if not retval:
            raise ValueError('frame capture failed')
        self.current_frame = most_recent_frame
        # delay of 2 ms for refreshing screen (time.sleep() doesn't work)
        cv2.waitKey(2)


    ######################################################################
    # face_detect()
    #
    # runs facial recognition on our previously captured image and returns
    # (x,y)-distance between target and center (as a fraction of image dimensions)
    ######################################################################
    def face_detect(self, filename=None):
        def draw_reticule(img, x, y, width, height, color, style="corners"):
            w, h = width, height
            if style == "corners":
                cv2.line(img, (x, y), (x + w / 3, y), color, 2)
                cv2.line(img, (x + 2 * w / 3, y), (x + w, y), color, 2)
                cv2.line(img, (x + w, y), (x + w, y + h / 3), color, 2)
                cv2.line(img, (x + w, y + 2 * h / 3), (x + w, y + h), color, 2)
                cv2.line(img, (x, y), (x, y + h / 3), color, 2)
                cv2.line(img, (x, y + 2 * h / 3), (x, y + h), color, 2)
                cv2.line(img, (x, y + h), (x + w / 3, y + h), color, 2)
                cv2.line(img, (x + 2 * w / 3, y + h), (x + w, y + h), color, 2)
            else:
                cv2.rectangle(img, (x, y), (x + w, y + h), color)

        if not filename:
            filename = self.opts.processed_img_file

        # load image, then resize it to specified size
        img = self.current_frame

        img_w, img_h = map(int, self.opts.image_dimensions.split('x'))
        img = cv2.resize(img, (img_w, img_h))

        # detect faces (might want to make the minNeighbors threshold adjustable)
        faces = self.face_filter.detectMultiScale(img, minNeighbors=4)

        # convert to grayscale then back, so that we can draw red targets over a grayscale
        # photo, for an especially ominous effect
        img = cv2.cvtColor(img, cv2.COLOR_RGB2GRAY)
        img = cv2.cvtColor(img, cv2.COLOR_GRAY2BGR)

        # a bit silly, but works correctly regardless of whether faces is an ndarray or empty tuple
        faces = map(lambda f: f.tolist(), faces)

        if self.opts.verbose:
            print('faces detected: ' + str(faces))

        # sort by size of face (we use the last face for computing x_adj, y_adj)
        faces.sort(key=lambda face: face[2] * face[3])

        x_adj, y_adj = (0, 0)  # (x,y)-distance from center, as a fraction of image dimensions
        face_y_size = 0  # height of the detected face, used to gauge distance to target
        if len(faces) > 0:
            face_detected = True

            # draw a rectangle around all faces except last face
            for (x, y, w, h) in faces[:-1]:
                draw_reticule(img, x, y, w, h, (0, 0, 60), "box")

            # get last face, draw target, and calculate distance from center
            (x, y, w, h) = faces[-1]
            draw_reticule(img, x, y, w, h, (0, 0, 170), "corners")
            x_adj = ((x + w / 2) - img_w / 2) / float(img_w)
            y_adj = ((y + h / 2) - img_h / 2) / float(img_h)
            face_y_size = h / float(img_h)
        else:
            face_detected = False

        cv2.imwrite(filename, img)

        # store modified image as class variable so that display() can access it
        self.frame_mod = img

        return face_detected, x_adj, y_adj, face_y_size

    ######################################################################
    # display()
    #
    # display the OpenCV-processed images
    ######################################################################
    def display(self):

        if sys.platform == 'linux2':
            # Linux: display with openCV
            cv2.imshow("Killcamera", self.frame_mod)

        elif sys.platform == 'darwin':
            # OS X: display with Preview
            subprocess.call('open -a Preview ' + self.opts.processed_img_file,
                            stdout=FNULL, stderr=FNULL, shell=True)
            self.current_image_viewer = 'Preview'

        else:
            # Windows: display with Windows Photo Viewer
            viewer = 'rundll32 "C:\Program Files\Windows Photo Viewer\PhotoViewer.dll" ImageView_Fullscreen'
            self.current_image_viewer = subprocess.Popen('%s %s\%s' % (viewer, os.getcwd(),
                                                                       self.opts.processed_img_file))


if __name__ == '__main__':
    if (sys.platform == 'linux2' or sys.platform == 'darwin') and not os.geteuid() == 0:
        sys.exit("Script must be run as root.")

    # command-line options
    parser = OptionParser()
    parser.add_option("-l", "--launcher", dest="launcherID", default="2123",
                      help="specify VendorID of the missile launcher to use. Default: '2123' (dreamcheeky thunder)",
                      metavar="LAUNCHER")
    parser.add_option("-d", "--disarm", action="store_false", dest="armed", default=True,
                      help="track faces but do not fire any missiles")
    parser.add_option("-r", "--reset", action="store_true", dest="reset_only", default=False,
                      help="reset the turret position and exit")
    parser.add_option("--nd", "--no-display", action="store_true", dest="no_display", default=False,
                      help="do not display captured images")
    parser.add_option("-c", "--camera", dest="camera", default='0',
                      help="specify the camera # to use. Default: 0", metavar="NUM")
    parser.add_option("-s", "--size", dest="image_dimensions", default='320x240',
                      help="image dimensions (recommended: 320x240 or 640x480). Default: 320x240",
                      metavar="WIDTHxHEIGHT")
    parser.add_option("-b", "--buffer", dest="buffer_size", type="int", default=2,
                      help="size of camera buffer. Default: 2", metavar="SIZE")
    parser.add_option("-v", "--verbose", action="store_true", dest="verbose", default=False,
                      help="detailed output, including timing information")
    opts, args = parser.parse_args()
    print(opts)

    # additional options
    opts = AttributeDict(vars(opts))  # converting opts to an AttributeDict so we can add extra options
    opts.haar_file = '/home/adam/intellijProjects/webClass/learnPythonSentinel/haarcascade_frontalface_default.xml'
    opts.processed_img_file = 'capture_faces.jpg'

    turret = Turret(opts)
    camera = Camera(opts)


    if not opts.reset_only:
        while True:
            try:
                start_time = time.time()

                camera.capture()
                capture_time = time.time()

                face_detected, x_adj, y_adj, face_y_size = camera.face_detect()
                detection_time = time.time()

                if not opts.no_display:
                    camera.display()

                if face_detected:
                    # I found a face in he picture
                    if opts.verbose:
                        print("adjusting turret: x=" + str(x_adj) + ", y=" + str(y_adj))
                    # A D J U S T        T U R R E T
                    turret.adjust(x_adj, y_adj, face_y_size)

                movement_time = time.time()

                #                if opts.verbose:
                #                    print("capture time: " + str(capture_time - start_time))
                #                    print("detection time: " + str(detection_time - capture_time))
                #                    print("movement time: " + str(movement_time - detection_time))

                turret.ready_aim_fire(x_adj, y_adj, face_y_size, camera)


            except KeyboardInterrupt:
                turret.dispose()
                camera.dispose()
                break


