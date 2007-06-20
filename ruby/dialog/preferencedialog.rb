# Created by Satoshi Nakagawa.
# You can redistribute it and/or modify it under the Ruby's license or the GPL2.

require 'dialoghelper'

class PreferenceDialog < OSX::NSObject
  include OSX
  include DialogHelper
  
  attr_accessor :delegate
  attr_reader :m
  ib_outlet :window
  ib_mapped_outlet :key_words
  ib_mapped_int_outlet :dcc_first_port, :dcc_last_port
  
  def initialize
    @prefix = 'preferenceDialog'
  end
  
  def start(pref)
    @m = pref
    NSBundle.loadNibNamed_owner('PreferenceDialog', self)
    load
    show
  end
  
  def show
    @window.makeKeyAndOrderFront(self)
  end
  
  def close
    @delegate = nil
    @window.close
  end
  
  def windowWillClose(sender)
    fire_event('onClose')
  end
  
  def onOk(sender)
    save
    fire_event('onOk', m)
    @window.close
  end
  
  def onCancel(sender)
    @window.close
  end
  
  def load
    load_mapped_outlets(m, true)
  end
  
  def save
    save_mapped_outlets(m, true)
    m.key.words.delete_if {|i| i.empty?}
    m.key.words.sort! {|a,b| a.downcase <=> b.downcase}
  end
end
