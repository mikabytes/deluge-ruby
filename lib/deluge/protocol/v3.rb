require 'rencode'
require 'zlib'
require 'socket'
require 'thread'
require 'openssl'

class Deluge
  class Protocol::V3
    # Data messages are transfered using very a simple protocol.
    # Data messages are transfered with a header containing
    # the length of the data to be transfered (payload).

    def initialize host, port
      @buffer = []
      @message_length = 0
      @messages = []
      @mutex = Mutex.new
      @host = host
      @port = port
      @counter = 0

      connection = TCPSocket.new(host, port)
      ctx = OpenSSL::SSL::SSLContext.new
      ctx.set_params(verify_mode: OpenSSL::SSL::VERIFY_NONE)
      ctx.ssl_version = :TLSv1_2

      @con = OpenSSL::SSL::SSLSocket.new(connection, ctx)
      @con.connect

      Thread.new do
        loop do
          begin
            data = @con.readpartial(1024)

            if data.length == 0
              puts "We lost the connection!"
              break
            end

            handle_new_data(data.bytes)
          rescue Exception => e
            puts e.message
            p e.backtrace
            sleep 1
          end
        end
      end
    end

    def call method, *args
      kwargs = if args.last.is_a?(Hash)
                 args.delete_at(-1)
               else
                 {}
               end

      request_id = @counter+=1

      send([request_id, method, args, kwargs])

      response = nil

      sleep 0.01 until response = @messages.find{|m| m[1] == request_id}
      @messages.delete(response)

      if response[0] == 1
        return response[2]
      else
        raise response.inspect
      end
    end

    # Transfer the data.

    # The data will be serialized and compressed before being sent.
    # First a header is sent - containing the length of the compressed payload
    # to come as a signed integer. After the header, the payload is transfered.
    # :param msg: data to be transfered in a data structure serializable by rencode.
    def send msg
      rencoded = REncode.dump([msg]).pack('C*')
      #rencoded = [193, 196, 1, 139, 100, 97, 101, 109, 111, 110, 46, 105, 110, 102, 111, 192, 102].pack('C*')
      compressed = Zlib::Deflate.deflate(rencoded)
      raw = compressed.bytes

      # all commented out stuff is for version 4, which we do not yet support
      # Store length as a signed integer (using 4 bytes), network byte order
  #    header = [raw.length].pack('N').bytes

      #every message begins with an ASCII 'D'
  #    header.insert(0, 'D'.ord)

  #    header_str = header.pack('C*')
      message_str = raw.pack('C*')

  #    puts "Writing header:"
  #    p header_str.bytes
  #    puts
  #    puts "Writing message:"
  #    p rencoded.bytes
  #    puts


  #    @con.write(header_str)
      @con.write(message_str)
      @con.flush

      nil
    end

    def read
      @mutex.synchronize do
        @messages.shift
      end
    end

    def count
      @mutex.synchronize do
        @messages.count
      end
    end

    private

    def handle_new_data data
      @buffer.push(*data)

      begin
        handle_complete_message(@buffer)
        @buffer = []
      rescue Exception
        # Do nothing -- @buffer stays the same implicitly
      end
    end

  #  def handle_new_message
  #    header = @buffer.shift(5)
  #    verify_d = header.shift(1)
  #
  #    unless verify_d == 'D'.ord
  #      raise "Invalid header format, First byte is #{verify_d}"
  #    else
  #      @message_length = header.pack('C*').unpack('N')[0]
  #      raise "Message length is negative: #{@message_length}" if @message_length < 0
  #    end
  #  end

    def handle_complete_message data
      decompressed = Zlib::Inflate.inflate(data.pack('C*'))
      derencoded = REncode.parse(decompressed)

      @mutex.synchronize do
        @messages << derencoded
      end
    end

  end
end
