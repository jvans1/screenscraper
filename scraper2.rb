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
# @db = SQLite3::Database.open("jobs2.db")


# @db.execute("CREATE TABLE jobs2 ()
# 	id INTEGER PRIMARY KEY,
# 	title TEXT,
# 	description TEXT,	
# 	url TEXT
# );")
# url= "http://jobs.rubynow.com/"
# #handle inserts
# def insert_job(title, description, url)
# 	@db.execute("INSERT INTO jobs(title, description, url)
# 			VALUES(?, ?, ?)", title, description, url)
# end
# # Open individual jobs' pages
# # def parse_jobs(links, url)
# # 	links.each do |link|
# # 		job_url = url + link
# # 		if found_duplicates(job_url)
# # 			next
# # 		else
# # 			job_page = Nokogiri::HTML(open(url+link))
# # 			job_title = job_page.css('h1#title').text
# # 			job_description = job_page.css('div.description p').text
# # 			insert_job(job_title, job_description, job_url)
# # 		end
# # 	end
# # end

search_page = "http://jobs.rubynow.com/"
search_results = Nokogiri::HTML(open(search_page))
puts search_results

jobs_array = search_results.css('#jobs-list a:nth-child(1)').map { |n| n['href'] }
# parse_jobs(jobs_array, url)


