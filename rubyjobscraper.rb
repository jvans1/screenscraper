require 'nokogiri'
require 'rubygems'
require 'open-uri'
require 'sqlite3'

@db = SQLite3::Database.open("jobs.db")

def check_duplicates?(job_link)
	job_in_db = @db.execute("SELECT url FROM jobs WHERE url = ?", job_link)
	if job_link == job_in_db.flatten[0].to_s
		true
	else
		false
	end
end


url= "http://careers.stackoverflow.com"

def insert_job(title, description, url)
	@db.execute("INSERT INTO jobs(title, description, url)
			VALUES(?, ?, ?)", title, description, url)
end

def parse_jobs(links, url)
	links.each do |link|
		job_url = url + link
		if check_duplicates?(job_url)
			next
		else
			job_page = Nokogiri::HTML(open(url+link))
			job_title = job_page.css('h1#title').text
			job_description = job_page.css('div.description p').text
			insert_job(job_title, job_description, job_url)
		end
	end
end

puts "What type of job do you want to search for?"
job = gets.chomp.split.join('+')
search_page = "http://careers.stackoverflow.com/jobs?searchTerm=#{job}&location=new+york+city"

search_results = Nokogiri::HTML(open(search_page))

jobs_array = search_results.css('a.title').map { |n| n['href'] }

parse_jobs(jobs_array, url)


next_page_extension = search_results.css('div.pagination a.prev-next')
if next_page_extension.length > 0 
	next_page = Nokogiri::HTML(open(url+next_page_extension[0]['href']))
	next_page_links = search_results.css('a.title').map { |n| n['href'] }
	parse_jobs(next_page_links, url)
end


