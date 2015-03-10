class WeeklyStatusMailer < ActionMailer::Base
  helper :comments, :entries
  default :from => 'notifications@innoq.com'

  def weekly_status_email(recipient, host)
    @host = host.chomp('/')
    @week = Time.now.strftime('%V')
    @statuses = WeeklyStatus.by_week(@week).recent
    mail({:to => recipient, :subject => "innoQ Wochenstatus (KW #{@week})"})
  end
end
