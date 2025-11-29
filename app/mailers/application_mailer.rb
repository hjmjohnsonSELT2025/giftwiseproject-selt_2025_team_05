class ApplicationMailer < ActionMailer::Base
  default from: ENV['GMAIL_USERNAME']
  layout 'mailer'

  # ============ DEVISE EMAILS ============
  # Tell Rails to look for templates in devise/mailer folder
  self.default template_path: 'devise/mailer'

  def reset_password_instructions(record, token, opts = {})
    @resource = record
    @token = token
    @reset_url = edit_user_password_url(reset_password_token: @token)
    mail(to: record.email, subject: 'Reset Your Password Instructions')
  end

  # ============ CUSTOMIZED EMAIL FUNCTIONALITIES============

end