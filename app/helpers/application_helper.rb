module ApplicationHelper
    def format_date(date)
        parsed_date = Date.parse(date) if date.present?
        parsed_date.strftime("%A, %d %B %Y") if parsed_date
    end
end
