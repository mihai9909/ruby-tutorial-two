module UsersHelper
    def gravatar_for(user, size: 80)
        gravatar_id = Digest::MD5::hexdigest(user.email.downcase)
        gravatar_url = "https://secure.gravatar.com/avatar/#{gravatar_id}?s=#{size}"
        image_tag(gravatar_url, alt: user.name, class: "gravatar")
    end
    
    def send_mail
        response = HTTP.post("https://api.emailjs.com/api/v1.0/email/send", :params => {service_id: "default_service",
        template_id: "template_5eqjt4j",
        user_id: "RLpsZfhP-QdAf11kA",
        template_params: {to_email: "neagoimihai@gmail.com"},
        accessToken: "8ZWXEhRPKr7yW6A0mA11i"
        })
    end
end
