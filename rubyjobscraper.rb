#search for jobs
	#open individual jobs on page
	#parse jobs_page for 
		##Job Title
		##Job_description
		##Responsiblities
		##Skill& Requirements
		##About the Company

		##REPEAT



require 'nokogiri'
require 'rubygems'
require 'open-uri'


url = "http://careers.stackoverflow.com"
# Open individual jobs' pages


def parse_jobs(links, url = "http://careers.stackoverflow.com")
	links.each do |link|
		job_page = Nokogiri::HTML(open(url+link))
	#Parse the page for contents
		job_title = job_page.css('h1#title').text
		job_url = url + link
		puts job_title
		end
end
#select all tabs
#open a different page


#puts "What do you want to search"
#Open Job search page
search_page = "http://careers.stackoverflow.com/jobs?searchTerm=ruby&location=new+york+city"
search_results = Nokogiri::HTML(open(search_page))

#Put links to job pages into an Array
first_page = search_results.css('a.title').map { |n| n['href'] }

parse_jobs(first_page)

# Open the next page from index page and assign it to current page 

next_page_extension = search_results.css('div.pagination a.prev-next')[0]['href']
next_page = Nokogiri::HTML(open(url+next_page_extension))
next_page_links = search_results.css('a.title').map { |n| n['href'] }
parse_jobs(next_page_links)

