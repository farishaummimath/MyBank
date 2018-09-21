WickedPdf.config = {
  :wkhtmltopdf => '/opt/wkhtmltopdf',
  :layout => "pdf.html",
  #:exe_path => '/usr/local/bin/wkhtmltopdf'
  :footer => {:html => { :template=> 'layouts/pdf_footer.html.erb'}}
}
