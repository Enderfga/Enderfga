from queue import Queue
from struct import pack, unpack, pack_into, unpack_from
from enum import Enum

from QueueSignal import QueueSignal


class CmdType(Enum):
    MULTI_SETTINGS=1
    SINGLE_SETTINGS=2
    SINGLE_CONTROL=3
    READ_SETTINGS=4

class CommandConstructorCore:
    """
    this class impl core read functions
    """

    """
    last order was generate
    """
    order_last=0
    """

    """
    q_write: Queue=None

    def _order_count(self):
        """
        the order_count generator, it generate new order number
        """
        self.order_last=(self.order_last+1)%127
        return self.order_last

    def _check_sum(self, header: bytearray, params: bytearray):
        """
        impl checksum algorithm
        """
        return bytearray([sum(header+params) & 0xFF])

    def sendCommand(self, data: bytearray):
        """
        direct do the command bytearray send task
        """
        self.q_write.put((QueueSignal.CMD, data), block=True)

    def __init__(self, q_write: Queue):
        self.q_write=q_write

    def join_cmd(self, type: CmdType, params: bytearray):
        """
        this function concat header+params+checksum to a bytearray for ready to send
        """
        header=bytearray(b'\xBB\x00\x00')
        if type==CmdType.MULTI_SETTINGS:  # 编队设置 0xBB, 0x08, 0x04
            pack_into("!B", header, 1, 0x08)
            pack_into("!B", header, 2, 0x04)
            checksum=self._check_sum(header, params)
            return header+params+checksum
        elif type==CmdType.SINGLE_SETTINGS:  # 单机设置 0xBB, 0x07, 0x05
            pack_into("!B", header, 1, 0x07)
            pack_into("!B", header, 2, 0x05)
            checksum=self._check_sum(header, params)
            return header+params+checksum
        elif type==CmdType.READ_SETTINGS:  # 读设置 0xBB, 0x02, 0x02
            pack_into("!B", header, 1, 0x02)
            pack_into("!B", header, 2, 0x02)
            checksum=self._check_sum(header, params)
            return header+params+checksum
        elif type==CmdType.SINGLE_CONTROL:  # 串口控制 0xBB, 0x0B, 0xF3
            pack_into("!B", header, 1, 0x0B)
            pack_into("!B", header, 2, 0xF3)
            pack_into("!B", params, 9, self._order_count())
            checksum=self._check_sum(header, params)
            return header+params+checksum


class CommandConstructor(CommandConstructorCore):
    """
    this class extends CommandConstructorCore,
    it impl all functions that direct construct command .
    TODO Implement All Command Methods On This Class
    """

    def __init__(self, q_write: Queue):
        super().__init__(q_write)

    def led(self, mode: int, r: int, g: int, b: int):
        # TODO impl it
        if mode < 0 or mode > 2:
            raise ValueError("mode illegal", mode)
        else:
            params = bytearray(10)
            pack_into("!B", params, 0, 0x08)
            pack_into("!B", params, 1, mode)
            pack_into("!B", params, 1, r)
            pack_into("!B", params, 1, g)
            pack_into("!B", params, 1, b)
            cmd = self.join_cmd(CmdType.SINGLE_CONTROL, params)
            print("led", cmd.hex(' '))
            self.sendCommand(cmd)



    def takeoff(self, high: int, ):
        params=bytearray(10)
        pack_into("!B", params, 0, 0x01)
        pack_into("!h", params, 1, high)
        cmd=self.join_cmd(CmdType.SINGLE_CONTROL, params)
        print("takeoff", cmd.hex(' '))
        self.sendCommand(cmd)


    def land(self, ):
        params=bytearray(10)
        pack_into("!B", params, 0, 0x00)
        cmd=self.join_cmd(CmdType.SINGLE_CONTROL, params)
        print("land", cmd.hex(' '))
        self.sendCommand(cmd)


    def move(self, direction: int, distance: int):
        # TODO impl it
        if direction < 0 or direction > 6:
            raise ValueError("direction illegal", direction)
        else:
            params = bytearray(10)
            pack_into("!B", params, 0, 0x02)
            pack_into("!B", params, 1, direction)
            pack_into("!h", params, 2, distance)
            cmd = self.join_cmd(CmdType.SINGLE_CONTROL, params)
            print("move", cmd.hex(' '))
            self.sendCommand(cmd)

    def up(self, distance: int):
        # TODO impl it
        self.move(1, distance)

    def down(self, distance: int):
        # TODO impl it
        self.move(2, distance)

    def forward(self, distance: int):
        # TODO impl it
        self.move(3, distance)

    def back(self, distance: int):
        # TODO impl it
        self.move(4, distance)

    def left(self, distance: int):
        # TODO impl it
        self.move(5, distance)

    def right(self, distance: int):
        # TODO impl it
        self.move(6, distance)

    def flip(self, direction: int, circle: int):
        # TODO impl it
        if direction < 0 or direction > 4:
            raise ValueError("direction illegal", direction)
        if circle!=1 and circle!=2:
            raise ValueError("circle illegal", circle)
        else:
            params = bytearray(10)
            pack_into("!B", params, 0, 0x04)
            pack_into("!B", params, 1, direction)
            pack_into("!B", params, 2, circle)
            cmd = self.join_cmd(CmdType.SINGLE_CONTROL, params)
            print("flip", cmd.hex(' '))
            self.sendCommand(cmd)


    def flip_forward(self, circle: int):
        # TODO impl it
        self.flip(1, circle)

    def flip_back(self, circle: int):
        # TODO impl it
        self.flip(2, circle)

    def flip_left(self, circle: int):
        # TODO impl it
        self.flip(3, circle)

    def flip_right(self, circle: int):
        # TODO impl it
        self.flip(4, circle)

    def arrive(self, x: int, y: int, z: int):
        # TODO impl it
        params = bytearray(10)
        pack_into("!B", params, 0, 0x03)
        pack_into("!h", params, 1, x)
        pack_into("!h", params, 2, y)
        pack_into("!h", params, 3, z)
        cmd = self.join_cmd(CmdType.SINGLE_CONTROL, params)
        print("arrive", cmd.hex(' '))
        self.sendCommand(cmd)

    def rotate(self, degree: int):
        # TODO impl it
        params = bytearray(10)
        pack_into("!B", params, 0, 0x05)
        pack_into("!h", params, 1, degree)
        cmd = self.join_cmd(CmdType.SINGLE_CONTROL, params)
        print("rotate", cmd.hex(' '))
        self.sendCommand(cmd)

    def speed(self, speed: int):
        if speed < 0 or speed > 200:
            raise ValueError("speed illegal", speed)
        # TODO impl it
        else:
            params = bytearray(10)
            pack_into("!B", params, 0, 0x06)
            pack_into("!h", params, 1, speed)
            cmd = self.join_cmd(CmdType.SINGLE_CONTROL, params)
            print("speed", cmd.hex(' '))
            self.sendCommand(cmd)

    def high(self, high: int):
        # TODO impl it
        params = bytearray(10)
        pack_into("!B", params, 0, 0x07)
        pack_into("!h", params, 1, high)
        cmd = self.join_cmd(CmdType.SINGLE_CONTROL, params)
        print("high", cmd.hex(' '))
        self.sendCommand(cmd)

    def airplane_mode(self, mode: int):
        if mode < 0 or mode > 4:
            raise ValueError("mode illegal", mode)
        # TODO impl it
        else:
            params = bytearray(10)
            pack_into("!B", params, 0, 0x08)
            pack_into("!h", params, 1, mode)
            cmd = self.join_cmd(CmdType.SINGLE_CONTROL, params)
            print("airplane_mode", cmd.hex(' '))
            self.sendCommand(cmd)

    def hovering(self, ):
        # TODO impl it
        params = bytearray(10)
        pack_into("!B", params, 0, 0xFE)
        cmd = self.join_cmd(CmdType.SINGLE_CONTROL, params)
        print("hovering", cmd.hex(' '))
        self.sendCommand(cmd)

    def read_setting(self, mode: int):
        params=bytearray(1)
        pack_into("!B", params, 0, mode)
        cmd=self.join_cmd(CmdType.READ_SETTINGS, params)
        print("cmd", cmd.hex(' '))
        self.sendCommand(cmd)

    def read_multi_setting(self):
        return self.read_setting(0x02)

    def read_single_setting(self):
        return self.read_setting(0x04)

    def read_hardware_setting(self):
        return self.read_setting(0xA0)

    def vision_mode(self, mode: int):
        if mode < 0 or mode > 5:
            raise ValueError("mode illegal", mode)

        params = bytearray(10)
        pack_into("!B", params, 0, 0x10)
        pack_into("!B", params, 1, mode)
        cmd = self.join_cmd(CmdType.SINGLE_CONTROL, params)
        print("vision_mode", cmd.hex(' '))
        self.sendCommand(cmd)

        pass
