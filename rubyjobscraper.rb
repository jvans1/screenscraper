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
###Select all job names. If the strings match exactly, skip the database insertion.
# def look for duplicate
@db = SQLite3::Database.open("jobs.db")



# def found_duplicates?(url)
# 	jobs_in_db = @db.execute("SELECT url FROM jobs ")
# 	jobs_in_db.each do |job|
# 		if url == job
# 			true
# 		else
# 			false
# 		end
# 	end
# end


# @db.execute("CREATE TABLE jobs (
# 	id INTEGER PRIMARY KEY,
# 	title TEXT,
# 	description TEXT,	
# 	url TEXT
# );")
url= "http://careers.stackoverflow.com"
#handle inserts
def insert_job(title, description, url)
	@db.execute("INSERT INTO jobs(title, description, url)
			VALUES(?, ?, ?)", title, description, url)
end
# Open individual jobs' pages
def parse_jobs(links, url)
	links.each do |link|
		# if found_duplicates?(link)
		# 	next
		# else
			job_page = Nokogiri::HTML(open(url+link))
			job_url = url + link
			job_title = job_page.css('h1#title').text
			job_description = job_page.css('div.description p').text
			insert_job(job_title, job_description, job_url)
		# end
	end
end

puts "What type of job do you want to search for?"
job = gets.chomp.split.join('+')
search_page = "http://careers.stackoverflow.com/jobs?searchTerm=#{job}&location=new+york+city"

search_results = Nokogiri::HTML(open(search_page))

#Put links to job pages into an Array
jobs_array = search_results.css('a.title').map { |n| n['href'] }

parse_jobs(jobs_array, url)

# Open the next page from index page and assign it to current page 

next_page_extension = search_results.css('div.pagination a.prev-next')
if next_page_extension.length > 0 
	next_page = Nokogiri::HTML(open(url+next_page_extension[0]['href']))
	next_page_links = search_results.css('a.title').map { |n| n['href'] }
	parse_jobs(next_page_links, url)
end


