Puppet::Type.newtype(:mongodb_collection) do
  @doc = "Manage MongoDB databases."

  ensurable

  newparam(:name, :namevar=>true) do
    desc "The name of the database."
    newvalues(/^\w+\.?\w+$/)
  end

  newparam(:database) do
    desc "The database where collection belongs to"
  end

  newparam(:shard_enabled) do
    desc "Enabled sharding for collection(s) in database"
    defaultto false
  end

  newparam(:shard_key) do
    desc "The collection sharding key"
    defaultto '_id'
  end

  newparam(:router) do
    desc "The cluster mongos/router instance"

    validate do |value|
      parts = value.split(':')
      host = parts[0]
      port = parts[1]

      host.split('.').each do |hostpart|
        unless hostpart =~ /^([\d\w]+|[\d\w][\d\w\-]+[\d\w])$/
          raise Puppet::Error, "Invalid host name for router"
        end
      end

      if port.nil?
        raise Puppet::Error, "Invalid port number for router"
      end
    end

    defaultto do
      if @resources[:shard_enabled]
        fail("Property 'router' must be set to enable and setup sharding for collections")
      end
      'localhost:27017'
    end
  end

end
