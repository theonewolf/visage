#!/usr/bin/env ruby

require 'rubygems'
Gem.clear_paths
__DIR__ = File.expand_path(File.dirname(__FILE__))
Gem.path << File.join(__DIR__, 'gems')
require 'sinatra'
require 'RRDtool'
require 'yajl'
require 'haml'
require 'lib/collectd-json'
require 'lib/collectd-profile'

set :public, __DIR__ + '/public'
set :views,  __DIR__ + '/views'

configure do 
  @config_filename = File.expand_path(File.join(__DIR__, 'config.yaml'))
  CONFIG_FILENAME = @config_filename
  RRDDIR = YAML::load(File.read(@config_filename))['rrddir']

  CollectdJSON.basedir = RRDDIR
  CollectdProfile.config_filename = @config_filename
end

template :layout do 
  File.read('views/layout.haml')
end

# user facing
get '/' do 
  @hosts = CollectdJSON.hosts
  haml :index
end

get '/:host' do 
  @hosts = CollectdJSON.hosts
  @profiles = CollectdProfile.all

  haml :index
end

get '/:host/:profile' do 
  @hosts = CollectdJSON.hosts
  @profiles = CollectdProfile.all
  @profile = CollectdProfile.get(params[:profile])
  
  haml :index
end

# JSON data backend

# /data/:host/:plugin/:optional_plugin_instance
get %r{/data/([^/]+)/([^/]+)(/([^/]+))*} do 
  host = params[:captures][0]
  plugin = params[:captures][1]
  plugin_instance = params[:captures][3]

  config = YAML::load(File.read(CONFIG_FILENAME))

  collectd = CollectdJSON.new(:basedir => RRDDIR)
  json = collectd.json(:host => host, 
                       :plugin => plugin,
                       :plugin_instance => plugin_instance,
                       :start => params[:start],
                       :end => params[:end],
                       :colors => config['colors'])
  # if the request is cross-domain, we need to serve JSONP
  maybe_wrap_with_callback(json)
end

def maybe_wrap_with_callback(json)
  if params[:callback]
    params[:callback] + '(' + json + ')'
  else
    json
  end
end
