namespace :weeklymail do
  desc "Sends out weekly status report"
  task :deliver, [:recipient] => [:environment] do |t, args|
    WeeklyStatusMailer.weekly_status_email(args.recipient).deliver
  end
end
