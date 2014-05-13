require 'deluge/protocol'
require 'base64'

class Deluge

  def initialize host='localhost', port='58846', protocol=3
    @protocol = protocol

    if protocol == 3
      @con = Protocol::V3.new(host, port)
    else
      raise "Unsupported protocol #{protocol}"
    end
  end

  def call args, kwargs
    @con.call *args, kwargs
  end

  def login username, password
    @con.call 'daemon.login', username, password
  end

  def shutdown args, kwargs={}
    args = [args] unless args.is_a?(Array)
    @con.call 'daemon.shutdown', args, kwargs
  end

  def info
    @con.call 'daemon.info'
  end

  def get_method_list
    @con.call 'daemon.get_method_list'
  end

  # Available options:
  # max_connections max_upload_slots max_upload_speed max_download_speed prioritize_first_last_pieces file_priorities compact_allocation download_location auto_managed stop_at_ratio stop_ratio remove_at_ratio move_completed move_completed_path add_paused
  def add_torrent_file filename, filedump, options={}
    filedump_enc = Base64.encode64(filedump)
    @con.call 'core.add_torrent_file', filename, filedump_enc, options, {}
  end

  # Available options:
  # max_connections max_upload_slots max_upload_speed max_download_speed prioritize_first_last_pieces file_priorities compact_allocation download_location auto_managed stop_at_ratio stop_ratio remove_at_ratio move_completed move_completed_path add_paused
  def add_torrent_url url, options={}
    @con.call 'core.add_torrent_url', url, options, {}
  end

  # Available options:
  # max_connections max_upload_slots max_upload_speed max_download_speed prioritize_first_last_pieces file_priorities compact_allocation download_location auto_managed stop_at_ratio stop_ratio remove_at_ratio move_completed move_completed_path add_paused
  def add_torrent_magnet uri, options={}
    @con.call 'core.add_torrent_magnet', uri, options, {}
  end

  def remove_torrent torrent_id, remove_data: false
    @con.call 'core.remove_torrent', torrent_id, remove_data
  end

  
  # Gets the session status values for 'keys', these keys are taking
  # from libtorrent's session status.

  # See: http://www.rasterbar.com/products/libtorrent/manual.html#status
  def get_session_status keys
    @con.call 'core.get_session_status', keys, {}
  end

  def get_cache_status
    @con.call 'core.get_cache_status', {}
  end

  def force_reannounce *torrent_ids
    @con.call 'core.force_reannounce', torrent_ids, {}
  end

  def pause_torrent *torrent_ids
    @con.call 'core.pause_torrent', torrent_ids, {}
  end

  def connect_peer torrent_id, ip, port
    @con.call 'core.connect_peer', torrent_id, ip, port, {}
  end

  def move_storage *torrent_ids, dest
    @con.call 'core.move_storage', torrent_ids, dest, {}
  end

  def pause_all_torrents
    @con.call 'core.pause_all_torrents', {}
  end

  def resume_all_torrents
    @con.call 'core.resume_all_torrents', {}
  end

  def resume_torrent *torrent_ids
    @con.call 'core.resume_torrent', torrent_ids, {}
  end

  def get_torrent_status torrent_id, keys, diff=false
    @con.call 'core.get_torrent_status', torrent_id, keys, diff, {}
  end

  def get_filter_tree show_zero_hits=true, hide_cat=nil
    @con.call 'core.get_filter_tree', show_zero_hits, hide_cat, {}
  end

  def get_session_state
    @con.call 'core.get_session_state', {}
  end

  def get_config
    @con.call 'core.get_config', {}
  end

  def get_config_values *keys
    @con.call 'core.get_config_values', keys, {}
  end

  def set_config config
    @con.call 'core.set_config', config, {}
  end

  def get_listen_port
    @con.call 'core.get_listen_port', {}
  end

  def get_num_connections
    @con.call 'core.get_num_connections', {}
  end

  def get_available_plugins
    @con.call 'core.get_available_plugins', {}
  end

  def get_enabled_plugins
    @con.call 'core.get_enabled_plugins', {}
  end

  def enable_plugin plugin
    @con.call 'core.enable_plugin', plugin, {}
  end

  def disable_plugin plugin
    @con.call 'core.disable_plugin', plugin, {}
  end

  def force_recheck *torrent_ids
    @con.call 'core.force_recheck', torrent_ids, {}
  end

  def set_torrent_options torrent_ids, options={}
    torrent_ids = [torrent_ids] unless torrent_ids.kind_of?(Array)
    @con.call 'core.set_torrent_options',torrent_ids, options, {}
  end

  def set_torrent_trackers torrent_id, *trackers
    @con.call 'core.set_torrent_trackers', torrent_id, trackers, {}
  end

  def set_torrent_max_connections torrent_id, value
    @con.call 'core.set_torrent_max_connections', torrent_id, value, {}
  end

  def set_torrent_max_upload_slots torrent_id, value
    @con.call 'core.set_torrent_max_upload_stats', torrent_id, value, {}
  end

  def set_torrent_max_upload_speed torrent_id, value
    @con.call 'core.set_torrent_max_upload_speed', torrent_id, value, {}
  end
  
  def set_torrent_max_download_speed torrent_id, value
    @con.call 'core.set_torrent_max_download_speed', torrent_id, value, {}
  end

  def set_torrent_file_priorities torrent_id, priorities
    @con.call 'core.set_torrent_file_priorities', torrent_id, priorities, {}
  end

  def set_torrent_prioritize_first_last torrent_id, value
    @con.call 'core.set_torrent_prioritize_first_last', torrent_id, value, {}
  end

  def set_torrent_auto_managed torrent_id, value
    @con.call 'core.set_torrent_auto_managed', torrent_id, value, {}
  end

  def set_torrent_stop_at_ratio torrent_id, value
    @con.call 'core.set_torrent_stop_at_ratio', torrent_id, value, {}
  end

  def set_torrent_stop_ratio torrent_id, value
    @con.call 'core.set_torrent_stop_ratio', torrent_id, value, {}
  end

  def set_torrent_remove_at_ratio torrent_id, value
    @con.call 'core.set_torrent_remove_at_ratio', torrent_id, value, {}
  end

  def set_torrent_move_completed torrent_id, value
    @con.call 'core.set_torrent_move_completed', torrent_id, value, {}
  end

  def set_torrent_move_completed_path torrent_id, value
    @con.call 'core.set_torrent_move_completed_path', torrent_id, value, {}
  end

  def get_path_size path
    @con.call 'core.get_path_size', path, {}
  end

  def create_torrent path, tracker, piece_length, comment, target, webseeds, privat, created_by, trackers, add_to_session
    @con.call 'core.create_torrent', path, tracker, piece_length, comment, target, webseeds, privat, created_by, trackers, add_to_session, {}
  end

  def upload_plugin filename, filedump
    @con.call 'core.upload_plugin', filename, filedump, {}
  end

  def rescan_plugins
    @con.call 'core.rescan_plugins', {}
  end

  def rename_files torrent_id, filenames
    @con.call 'core.rename_files', torrent_id, filenames, {}
  end

  def rename_folder torrent_id, folder, new_folder
    @con.call 'core.rename_folder', torrent_id, folder, new_folder, {}
  end

  def queue_top *torrent_ids
    @con.call 'core.queue_top', torrent_ids, {}
  end

  def queue_up *torrent_ids
    @con.call 'core.queue_up', torrent_ids, {}
  end

  def queue_down *torrent_ids
    @con.call 'core.queue_down', torrent_ids, {}
  end

  def queue_bottom *torrent_ids
    @con.call 'core.queue_bottom', torrent_ids, {}
  end

  def glob path
    @con.call 'core.glob', path, {}
  end

  def test_listen_port
    @con.call 'core.test_listen_port', {}
  end

  def get_free_space path=nil
    @con.call 'core.get_free_space', path, {}
  end

  def get_libtorrent_version
    @con.call 'core.get_libtorrent_version'
  end
end
