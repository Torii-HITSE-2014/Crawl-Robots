require 'mysql'
require 'json'
require 'open-uri'

class PBDBConn

	def initialize(conf_filepath = './db.json')
		if File.exist?conf_filepath
			@conf = JSON.parse(open(conf_filepath).read)
		else
			raise "[FATAL]: db config file not found"
		end
		raise "[FATAL]: db config file incorrect" if !check_config(@conf)
		@conn = Mysql.new(@conf["db_address"], @conf["db_username"], @conf["db_password"], @conf["db_database"])
		@conn.query("CREATE TABLE IF NOT EXISTS PDB(Time VARCHAR(200),Title NVARCHAR(200),FilePath NVARCHAR(300),Tag VARCHAR(15),URL VARCHAR(100),PRIMARY KEY(Tag,URL));")
		@conn.query("CREATE TABLE IF NOT EXISTS UserInfo(UserID VARCHAR(64),UserTags VARCHAR(30),PRIMARY KEY(UserID,UserTags));")
	end

	def save(hash)
		sql = "INSERT INTO PDB (Time,Title,FilePath,Tag,URL) VALUES (?, ?, ?, ?, ?)"
		st = @conn.prepare(sql)
		st.execute(hash["date"], hash["title"], hash["filePath"], hash["tag"], hash["URL"])
	end

	def getNewsListAll(m,n)
		sql = "SELECT * FROM PDB ORDER BY TIME DESC LIMIT ? ?"
		st = @conn.prepare(sql)
		st.execute(m, n)
    end

    def getNewsList(tags,m,n)
    	#generating where clause according to tags
    	#string to float.float to string??
    	tag=tags[0]
    	where_clause="Tag = #{tag}"
    	1.upto(tags.length-1){ |i|
    		tag=tags[i]
    		where_clause=where_clause+" or Tag = #{tag}"	
    	}
		@conn.query("SELECT * FROM PDB WHERE #{where_clause} ORDER BY TIME DESC LIMIT #{m},#{n};")
    end
    
    def updateID(ID,tags)
    	if ID.length == 64
    		tag = tags.join(',')
			sql = "INSERT INTO UserInfo (UserID, UserTags) VALUES (?, ?)"
			st = @conn.prepare(sql)
			st.execute(ID, tag)
		else
			raise "[FATAL]: UserID is not 64 bytes"
		end
    end

    def removeID(ID)
    	#protection
    	if ID.length == 64
    		sql = "DELETE FROM UserInfo WHERE UserID = ?"
			st = @conn.prepare(sql)
			st.execute(ID)
    	else
    		raise "[FATAL]: UserID is not 64 bytes"
    	end
    end
    
    def getUsersList
    	@conn.query("SELECT * FROM UserInfo")
    end

	def close
		@conn.close
	end

	def check_config(hash)
		return false if !hash.has_key?"db_address"
		return false if !hash.has_key?"db_username"
		return false if !hash.has_key?"db_password"
		return false if !hash.has_key?"db_database"
		true
	end

	private :check_config
end