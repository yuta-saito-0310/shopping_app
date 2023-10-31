module ApplicationHelper
    def document_title
        if @title.present?
            "#{@title}-買出アプリ"
        else
            '買出アプリ'
        end
    end
end
