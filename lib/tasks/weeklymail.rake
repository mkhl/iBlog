namespace :weeklymail do
  desc "Sends out weekly status report"
  task :deliver, [:recipient, :host] => [:environment] do |t, args|
    WeeklyStatusMailer.weekly_status_email(args.recipient, args.host).deliver
  end
end
