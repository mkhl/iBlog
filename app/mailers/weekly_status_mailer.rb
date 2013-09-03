class WeeklyStatusMailer < ActionMailer::Base
  helper :comments, :entries
  default from: 'notifications@innoq.com'
 
  def weekly_status_email(recipient)
  	@week = Time.now.strftime('%W')
    @statuses = WeeklyStatus.by_week(@week).recent
    mail(to: recipient, subject: 'Wochenstatus')
  end
end
