class VagrantHelper

  def initialize(verbose)
    @verbose = verbose
  end

  def prepare
    vagrant_is_running = `vagrant status`.match(/running/)
    vagrant_has_snapshot = system('vagrant snapshot list 2>/dev/null | grep -q "Name: default "')

    actions = []
    unless vagrant_has_snapshot
      actions.push('destroy -f')
      actions.push('up')
      actions.push('snapshot take default')
    end
    unless vagrant_is_running
      actions.push('up')
    end
    actions.push('snapshot go default')
    actions.each do |action|
      puts 'Vagrant: ' + action if @verbose
      `vagrant #{action}`
    end
  end

  def connect
    user = Etc.getlogin
    options = {}
    host = ''
    config = `vagrant ssh-config`
    config.each_line do |line|
      if match = /HostName (.*)/.match(line)
        host = match[1]
        options = Net::SSH::Config.for(host)
      elsif  match = /User (.*)/.match(line)
        user = match[1]
      elsif match = /IdentityFile (.*)/.match(line)
        options[:keys] = [match[1].gsub(/"/, '')]
      elsif match = /Port (.*)/.match(line)
        options[:port] = match[1]
      end
    end
    @connection = Net::SSH.start(host, user, options)
  end

  def exec(command)
    channel = @connection.open_channel do |channel|
      channel.exec(command) do |ch, success|
        raise "could not execute command: #{command.inspect}" unless success
        ch[:output] = ''
        ch[:success] = true

        channel.on_data do |ch2, data|
          puts data if @verbose
          ch[:output] << data
        end

        channel.on_extended_data do |ch2, type, data|
          puts data if @verbose
          if data.match(/Error: /)
            ch[:success] = false
          end
          ch[:output] << data
        end
      end
    end
    channel.wait
    unless channel[:success]
      raise channel[:output]
    end
  end
end