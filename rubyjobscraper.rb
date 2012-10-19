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
require 'sqlite3'

@db = SQLite3::Database.new("jobs.db")
@db.execute("CREATE TABLE jobs (
	id INTEGER PRIMARY KEY,
	title TEXT,
	description TEXT,	
	url TEXT
);")
url= "http://careers.stackoverflow.com"
#handle inserts
def insert_job(title, description, url)
	@db.execute("INSERT INTO jobs(title, description, url)
			VALUES(?, ?, ?)", title, description, url)
end
# Open individual jobs' pages
def parse_jobs(links, url)
	links.each do |link|
		job_page = Nokogiri::HTML(open(url+link))
	#Parse the page for contents
		job_title = job_page.css('h1#title').text
		job_description = job_page.css('div.description p').text
		job_url = url + link
		# puts job_title, job_url
		insert_job(job_title, job_description, job_url)
		end
end

puts "What type of job do you want to search for?"
job = gets.chomp
search_page = "http://careers.stackoverflow.com/jobs?searchTerm=#{job}&location=new+york+city"

search_results = Nokogiri::HTML(open(search_page))

#Put links to job pages into an Array
jobs_array = search_results.css('a.title').map { |n| n['href'] }

parse_jobs(jobs_array, url)

# Open the next page from index page and assign it to current page 

next_page_extension = search_results.css('div.pagination a.prev-next')[0]['href']
next_page = Nokogiri::HTML(open(url+next_page_extension))
next_page_links = search_results.css('a.title').map { |n| n['href'] }
parse_jobs(next_page_links, url)

