require 'deluge/protocol'

class Deluge

  def initialize host='localhost', port='58846', protocol=3
    @protocol = protocol

    if protocol == 3
      @con = Protocol::V3.new(host, port)
    else
      raise "Unsupported protocol #{protocol}"
    end
  end

  def login username, password
    @con.call 'daemon.login', username, password
  end

  # Available options:
  # max_connections max_upload_slots max_upload_speed max_download_speed prioritize_first_last_pieces file_priorities compact_allocation download_location auto_managed stop_at_ratio stop_ratio remove_at_ratio move_completed move_completed_path add_paused
  def add_torrent_url url, options={}
    @con.call 'core.add_torrent_url', url, options, {}
  end
end
