module AccountActivationsHelper

  def send_mail
    response = HTTP.post("https://api.emailjs.com/api/v1.0/email/send", :params => {service_id: "default_service",
    template_id: "template_5eqjt4j",
    user_id: "RLpsZfhP-QdAf11kA",
    template_params: {to_email: "neagoimihai@gmail.com"},
    accessToken: "8ZWXEhRPKr7yW6A0mA11i"
    })

  end

end
