
task :backup_production do
  dbconfig = YAML::load(File.read('config/database.yml'))
  productionconfig = dbconfig['production']

  if productionconfig.nil?
    raise "Production database config not found"
  end
  if productionconfig['adapter'] != 'mysql2'
    raise "Production database not mysql2 - cannot backup."
  end

  username = productionconfig['username']
  password = productionconfig['password']
  socket = productionconfig['socket']
  database = productionconfig['database']

  if username.nil? or password.nil? or socket.nil? or database.nil? 
    raise "Production configuration incomplete - cannot backup."
  end

  t = Time.now.strftime "%Y-%m-%dT%H%M%S"
  filename = "../#{database}-backup-#{t}-sql.bz2"

  puts "#{database} backup to #{filename}"

  # Fire up a bzip2 into the background
  # (monitor its success later)
  rd, wr = IO.pipe
  bzip2_pid = fork
  if bzip2_pid.nil?
    # I am the bzip2 child
    wr.close
    $stdin.reopen(rd)
    rd.close
    $stdout.reopen(filename)
    exec "bzip2", "-z", "-c"
    raise "This should never happen: Cannot exec bzip2, $!"
  end
  rd.close

  # Fire up the mysqldump.
  # We purposefully do this ourselves,
  # as opposed to the combined
  #    mysqldump | bzip2
  # so we can check the return value of each of the two
  # individually.
  wr << <<HINT
-- Um das Datenbankbackup wieder einzuspielen,
-- macht man in etwa so was:
--
-- ( echo 'create database if not exists #{database};';
--   echo 'use #{database};';
--   bzip2 -dc < #{filename}
-- ) | mysql --user=#{username} --password 
--
HINT

  m_pid = fork
  if m_pid.nil?
    args = []
    $stdin.close
    $stdout.reopen(wr)
    wr.close
    exec "mysqldump", "--user=#{username}", "--password=#{password}", "--socket=#{socket}", database
    raise "Could not start mysqldump: $!";
  end
  wr.close

  Process.wait(m_pid)
  if 0 != $?.exitstatus
    raise "mysqldump did not complete successfully"
  end

  Process.wait(bzip2_pid)
  if 0 != $?.exitstatus
    raise "Backup compression not successful"
  end

  # Clean up in a few weeks,
  # lest the backup files keep piling up
  rd_at, wr_at = IO.pipe
  at_pid = fork
  if at_pid.nil?
    wr_at.close
    $stdin.reopen(rd_at)
    exec "at", "now", "+", "4", "weeks"
    raise "Cannot schedule cleanup via at: $!";
  end

  wr_at << "rm -f #{filename}"
  wr_at.close

  Process.wait(at_pid)
  if 0 != $?.exitstatus
    raise "scheduling cleanup job did not work"
  end
end
