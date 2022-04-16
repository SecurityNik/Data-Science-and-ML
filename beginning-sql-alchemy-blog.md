```python
'''
In this post, I am learning more about sqlalachemy
'''

# First up, import the sqlalchemy modules I will need need to use
from sqlalchemy import create_engine, MetaData, Table, Column, Integer, String, Text, text, select, or_, and_, desc, func, case, cast, Float, DECIMAL, Boolean, insert, update, delete, Date, DateTime, ARRAY, ForeignKey

# Import datetime
from datetime import datetime

# import pandas as I will use this to importand view data
import pandas as pd
```


```python
# Delete the database file if it previous existed
!del /f securitynik-db.sqlite
```


```python
'''
Create a SQLite database and interface to it via create_engine.
As this database does not exist as yet, it will be created on the disk
using the relative path. Hence the  ///
This engine does not actually connect to the database at this time.
A connection will be made once a request has been made to perform a task
'''
securitynik_db_engine = create_engine('sqlite:///securitynik-db.sqlite', echo=True)
print(securitynik_db_engine)

''' 
Setup the metadata
Quoting from the sqlalchemy manual: "The MetaData is a registry which includes the ability to emit a limited set of schema generation commands to
the database"
'''
metadata = MetaData()
print(metadata)
```

    Engine(sqlite:///securitynik-db.sqlite)
    MetaData()
    


```python
'''
With the engine created. Time to make a connection to the database
Since the database securitynik-db.sqlite does not exist,
the file will be created on the file system
'''
securitynik_db_connection = securitynik_db_engine.connect()
securitynik_db_connection
```




    <sqlalchemy.engine.base.Connection at 0x16f79457910>




```python
'''
Verifying the securitynik-db.sqlite file has been created on the file system
and that it is currently empty, as no data has been written to it
'''
!dir securitynik-db.sqlite
```

     Volume in drive D is Tools
     Volume Serial Number is F617-3FDD
    
     Directory of d:\ML
    
    2022-04-13  10:50 PM                 0 securitynik-db.sqlite
                   1 File(s)              0 bytes
                   0 Dir(s)  65,612,201,984 bytes free
    


```python
# With the file now created. Time to create some tables

# Create an employee Table
employee_table = Table('employees', metadata,
            Column('EmployeeID', Integer(), primary_key=True, nullable=False, unique=True, autoincrement=True),
            Column('FName', String(255), nullable=True),
            Column('LName', String(255), nullable=True),
            Column('Active', Boolean(), default=True, nullable=False),
            Column('Comments', String(255), default='securitynik.com employee')
            )
```


```python
'''
Create a blogs table
Setup the blogger_id field to link back to the EmployeeID field in the employees table
Note, could have also used foreign_key(employee_table.columns.EmployeeID to setup the foreign key
'''

blogs_table = Table('blogs', metadata,
            Column('BlogID', Integer(), primary_key=True, nullable=False, unique=True, autoincrement=True),
            Column('blogger_id', Integer(), ForeignKey('employees.EmployeeID'), nullable=False),
            Column('BlogTitle', String(255), nullable=True),
            Column('Blogger', String(255), default='Nik Alleyne', nullable=False),
            Column('Date', DateTime(), nullable=datetime.now),
            Column('URL', String(255), nullable=True),
            Column('Comments', Text(), default='Blog post created by Nik Alleyne')
            )
```


```python
# Create a table other
other_table = Table('other', metadata,
            Column('ID', Integer(), primary_key=True, nullable=False, unique=True, autoincrement=True),
            Column('Comments', String(255),  nullable=True)
            )
```


```python
# Create all the above defined tables
metadata.create_all(securitynik_db_connection)
```

    2022-04-13 22:50:07,622 INFO sqlalchemy.engine.Engine PRAGMA main.table_info("employees")
    2022-04-13 22:50:07,629 INFO sqlalchemy.engine.Engine [raw sql] ()
    2022-04-13 22:50:07,630 INFO sqlalchemy.engine.Engine PRAGMA temp.table_info("employees")
    2022-04-13 22:50:07,630 INFO sqlalchemy.engine.Engine [raw sql] ()
    2022-04-13 22:50:07,630 INFO sqlalchemy.engine.Engine PRAGMA main.table_info("blogs")
    2022-04-13 22:50:07,630 INFO sqlalchemy.engine.Engine [raw sql] ()
    2022-04-13 22:50:07,630 INFO sqlalchemy.engine.Engine PRAGMA temp.table_info("blogs")
    2022-04-13 22:50:07,639 INFO sqlalchemy.engine.Engine [raw sql] ()
    2022-04-13 22:50:07,641 INFO sqlalchemy.engine.Engine PRAGMA main.table_info("other")
    2022-04-13 22:50:07,643 INFO sqlalchemy.engine.Engine [raw sql] ()
    2022-04-13 22:50:07,647 INFO sqlalchemy.engine.Engine PRAGMA temp.table_info("other")
    2022-04-13 22:50:07,647 INFO sqlalchemy.engine.Engine [raw sql] ()
    2022-04-13 22:50:07,656 INFO sqlalchemy.engine.Engine 
    CREATE TABLE employees (
    	"EmployeeID" INTEGER NOT NULL, 
    	"FName" VARCHAR(255), 
    	"LName" VARCHAR(255), 
    	"Active" BOOLEAN NOT NULL, 
    	"Comments" VARCHAR(255), 
    	PRIMARY KEY ("EmployeeID"), 
    	UNIQUE ("EmployeeID")
    )
    
    
    2022-04-13 22:50:07,657 INFO sqlalchemy.engine.Engine [no key 0.00249s] ()
    2022-04-13 22:50:07,687 INFO sqlalchemy.engine.Engine COMMIT
    2022-04-13 22:50:07,689 INFO sqlalchemy.engine.Engine 
    CREATE TABLE other (
    	"ID" INTEGER NOT NULL, 
    	"Comments" VARCHAR(255), 
    	PRIMARY KEY ("ID"), 
    	UNIQUE ("ID")
    )
    
    
    2022-04-13 22:50:07,689 INFO sqlalchemy.engine.Engine [no key 0.00136s] ()
    2022-04-13 22:50:07,711 INFO sqlalchemy.engine.Engine COMMIT
    2022-04-13 22:50:07,713 INFO sqlalchemy.engine.Engine 
    CREATE TABLE blogs (
    	"BlogID" INTEGER NOT NULL, 
    	blogger_id INTEGER NOT NULL, 
    	"BlogTitle" VARCHAR(255), 
    	"Blogger" VARCHAR(255) NOT NULL, 
    	"Date" DATETIME, 
    	"URL" VARCHAR(255), 
    	"Comments" TEXT, 
    	PRIMARY KEY ("BlogID"), 
    	UNIQUE ("BlogID"), 
    	FOREIGN KEY(blogger_id) REFERENCES employees ("EmployeeID")
    )
    
    
    2022-04-13 22:50:07,713 INFO sqlalchemy.engine.Engine [no key 0.00097s] ()
    2022-04-13 22:50:07,734 INFO sqlalchemy.engine.Engine COMMIT
    


```python
# Verifying the tables were successfully created by viewing the metadata object
metadata.tables
```




    FacadeDict({'employees': Table('employees', MetaData(), Column('EmployeeID', Integer(), table=<employees>, primary_key=True, nullable=False), Column('FName', String(length=255), table=<employees>), Column('LName', String(length=255), table=<employees>), Column('Active', Boolean(), table=<employees>, nullable=False, default=ColumnDefault(True)), Column('Comments', String(length=255), table=<employees>, default=ColumnDefault('securitynik.com employee')), schema=None), 'blogs': Table('blogs', MetaData(), Column('BlogID', Integer(), table=<blogs>, primary_key=True, nullable=False), Column('blogger_id', Integer(), ForeignKey('employees.EmployeeID'), table=<blogs>, nullable=False), Column('BlogTitle', String(length=255), table=<blogs>), Column('Blogger', String(length=255), table=<blogs>, nullable=False, default=ColumnDefault('Nik Alleyne')), Column('Date', DateTime(), table=<blogs>), Column('URL', String(length=255), table=<blogs>), Column('Comments', Text(), table=<blogs>, default=ColumnDefault('Blog post created by Nik Alleyne')), schema=None), 'other': Table('other', MetaData(), Column('ID', Integer(), table=<other>, primary_key=True, nullable=False), Column('Comments', String(length=255), table=<other>), schema=None)})




```python
# Taking a different view of the tables via metadata
metadata.sorted_tables
```




    [Table('employees', MetaData(), Column('EmployeeID', Integer(), table=<employees>, primary_key=True, nullable=False), Column('FName', String(length=255), table=<employees>), Column('LName', String(length=255), table=<employees>), Column('Active', Boolean(), table=<employees>, nullable=False, default=ColumnDefault(True)), Column('Comments', String(length=255), table=<employees>, default=ColumnDefault('securitynik.com employee')), schema=None),
     Table('other', MetaData(), Column('ID', Integer(), table=<other>, primary_key=True, nullable=False), Column('Comments', String(length=255), table=<other>), schema=None),
     Table('blogs', MetaData(), Column('BlogID', Integer(), table=<blogs>, primary_key=True, nullable=False), Column('blogger_id', Integer(), ForeignKey('employees.EmployeeID'), table=<blogs>, nullable=False), Column('BlogTitle', String(length=255), table=<blogs>), Column('Blogger', String(length=255), table=<blogs>, nullable=False, default=ColumnDefault('Nik Alleyne')), Column('Date', DateTime(), table=<blogs>), Column('URL', String(length=255), table=<blogs>), Column('Comments', Text(), table=<blogs>, default=ColumnDefault('Blog post created by Nik Alleyne')), schema=None)]




```python
'''
With the tables created time to insert data
first into the employees table.
I will first insert 1 record
At the same time, return the number of rows impacted via the rowcount
'''
securitynik_db_connection.execute(insert(employee_table).values(FName='Nik', LName='Alleyne', Active=True, Comments='Blog Author')).rowcount
```

    2022-04-13 22:50:08,231 INFO sqlalchemy.engine.Engine INSERT INTO employees ("FName", "LName", "Active", "Comments") VALUES (?, ?, ?, ?)
    2022-04-13 22:50:08,235 INFO sqlalchemy.engine.Engine [generated in 0.00366s] ('Nik', 'Alleyne', 1, 'Blog Author')
    2022-04-13 22:50:08,239 INFO sqlalchemy.engine.Engine COMMIT
    




    1




```python
'''
Add an entry to the blog table
'''
securitynik_db_connection.execute(insert(blogs_table).values(blogger_id=1, BlogTitle='Beginning SQLAlchemy', URL='http://www.securitynik.com/beginning-sql-alchemy.html')).rowcount
```

    2022-04-13 22:50:08,483 INFO sqlalchemy.engine.Engine INSERT INTO blogs (blogger_id, "BlogTitle", "Blogger", "URL", "Comments") VALUES (?, ?, ?, ?, ?)
    2022-04-13 22:50:08,486 INFO sqlalchemy.engine.Engine [generated in 0.00336s] (1, 'Beginning SQLAlchemy', 'Nik Alleyne', 'http://www.securitynik.com/beginning-sql-alchemy.html', 'Blog post created by Nik Alleyne')
    2022-04-13 22:50:08,490 INFO sqlalchemy.engine.Engine COMMIT
    




    1




```python
# Insert some data into the other table
securitynik_db_connection.execute(insert(other_table).values(Comments='Nothing Exciting')).rowcount
```

    2022-04-13 22:50:08,638 INFO sqlalchemy.engine.Engine INSERT INTO other ("Comments") VALUES (?)
    2022-04-13 22:50:08,642 INFO sqlalchemy.engine.Engine [generated in 0.00422s] ('Nothing Exciting',)
    2022-04-13 22:50:08,646 INFO sqlalchemy.engine.Engine COMMIT
    




    1




```python
'''
Now that I can assign 1 value at a time
time to insert multiple values via a list of 
dictionaries
'''
add_multiple_employees = [
        { 'FName':'S', 'LName':'Alleyne',  'Active':True, 'Comments':'Blog Author' }, 
        { 'FName':'P', 'LName':'Khan',  'Active':False, 'Comments':'Blog Admin'},
        { 'FName':'TQ', 'LName':'G', 'Active':True, 'Comments':'Blog Manager'},
        { 'FName':'T', 'LName':'A', 'Active':False, 'Comments':'Blog Author' },
        { 'FName':'D', 'LName':'P', 'Active':True, 'Comments':'Blog Maintainer' },
        { 'FName':'J', 'LName':'S', 'Active':False, 'Comments':'Blog Contributor' },
        { 'FName':'C', 'LName':'P',  'Active':True, 'Comments':'Blog Comments Admin' },
        { 'FName':'A', 'LName':'W', 'Active':False, 'Comments':'Blog Author' },
]

# With the list of dictionaries built, time to submit to the database
# At the same time, get the number of rows impacted
securitynik_db_connection.execute(insert(employee_table, add_multiple_employees)).rowcount
```

    2022-04-13 22:50:08,883 INFO sqlalchemy.engine.Engine INSERT INTO employees ("FName", "LName", "Active", "Comments") VALUES (?, ?, ?, ?), (?, ?, ?, ?), (?, ?, ?, ?), (?, ?, ?, ?), (?, ?, ?, ?), (?, ?, ?, ?), (?, ?, ?, ?), (?, ?, ?, ?)
    2022-04-13 22:50:08,884 INFO sqlalchemy.engine.Engine [no key 0.00410s] ('S', 'Alleyne', 1, 'Blog Author', 'P', 'Khan', 0, 'Blog Admin', 'TQ', 'G', 1, 'Blog Manager', 'T', 'A', 0, 'Blog Author', 'D', 'P', 1, 'Blog Maintainer', 'J', 'S', 0, 'Blog Contributor', 'C', 'P', 1, 'Blog Comments Admin', 'A', 'W', 0, 'Blog Author')
    2022-04-13 22:50:08,893 INFO sqlalchemy.engine.Engine COMMIT
    




    8




```python
'''
Trying another strategy to get users into the database
In this case, read data from a CSV file and push int into the datbase
First read the csv file with pandas and print the first 5 records
'''
df_employees = pd.read_csv('employees.csv', header=0, sep=',')
df_employees.head(5)
```




<div>
<style scoped>
    .dataframe tbody tr th:only-of-type {
        vertical-align: middle;
    }

    .dataframe tbody tr th {
        vertical-align: top;
    }

    .dataframe thead th {
        text-align: right;
    }
</style>
<table border="1" class="dataframe">
  <thead>
    <tr style="text-align: right;">
      <th></th>
      <th>FName</th>
      <th>LName</th>
      <th>Active</th>
      <th>Comments</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>0</th>
      <td>User1</td>
      <td>User1-last</td>
      <td>True</td>
      <td>user 1</td>
    </tr>
    <tr>
      <th>1</th>
      <td>User2</td>
      <td>User2-last</td>
      <td>False</td>
      <td>user 2</td>
    </tr>
    <tr>
      <th>2</th>
      <td>User3</td>
      <td>User3-last</td>
      <td>True</td>
      <td>user 3</td>
    </tr>
    <tr>
      <th>3</th>
      <td>User4</td>
      <td>User4-last</td>
      <td>True</td>
      <td>user 4</td>
    </tr>
    <tr>
      <th>4</th>
      <td>User5</td>
      <td>User5-last</td>
      <td>False</td>
      <td>user 5</td>
    </tr>
  </tbody>
</table>
</div>




```python
'''
With the dataframe now containing the CSV data
time to take the dataframe data and push it into the SQLite database
'''
df_employees.to_sql(name='employees', con=securitynik_db_connection, if_exists='append', index=False)
```

    2022-04-13 22:50:09,176 INFO sqlalchemy.engine.Engine PRAGMA main.table_info("employees")
    2022-04-13 22:50:09,176 INFO sqlalchemy.engine.Engine [raw sql] ()
    2022-04-13 22:50:09,187 INFO sqlalchemy.engine.Engine BEGIN (implicit)
    2022-04-13 22:50:09,192 INFO sqlalchemy.engine.Engine INSERT INTO employees ("FName", "LName", "Active", "Comments") VALUES (?, ?, ?, ?)
    2022-04-13 22:50:09,192 INFO sqlalchemy.engine.Engine [generated in 0.00267s] (('User1', 'User1-last', 1, 'user 1'), ('User2', 'User2-last', 0, 'user 2'), ('User3', 'User3-last', 1, 'user 3'), ('User4', 'User4-last', 1, 'user 4'), ('User5', 'User5-last', 0, 'user 5'), ('User6', 'User6-last', 1, 'user 6'))
    2022-04-13 22:50:09,200 INFO sqlalchemy.engine.Engine COMMIT
    


```python
'''
With no errors above, it looks like all is well
Using the same strategy to add new blog entries
'''
df_blogs = pd.read_csv('blogs.csv', header=0, sep=',')
df_blogs.head(5)

```




<div>
<style scoped>
    .dataframe tbody tr th:only-of-type {
        vertical-align: middle;
    }

    .dataframe tbody tr th {
        vertical-align: top;
    }

    .dataframe thead th {
        text-align: right;
    }
</style>
<table border="1" class="dataframe">
  <thead>
    <tr style="text-align: right;">
      <th></th>
      <th>blogger_id</th>
      <th>BlogTitle</th>
      <th>Blogger</th>
      <th>Date</th>
      <th>URL</th>
      <th>Comments</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>0</th>
      <td>2</td>
      <td>Installing &amp; configuring Elasticsearch 8 and K...</td>
      <td>Nik Alleyne</td>
      <td>NaN</td>
      <td>https://www.securitynik.com/2022/04/installing...</td>
      <td>NaN</td>
    </tr>
    <tr>
      <th>1</th>
      <td>3</td>
      <td>Beginning Volatility3 Memory Forensics</td>
      <td>Nik Alleyne</td>
      <td>NaN</td>
      <td>https://www.securitynik.com/2022/03/beginning-...</td>
      <td>NaN</td>
    </tr>
    <tr>
      <th>2</th>
      <td>4</td>
      <td>Beginning DC Sync - Attack</td>
      <td>Nik Alleyne</td>
      <td>NaN</td>
      <td>https://www.securitynik.com/2022/01/beginning-...</td>
      <td>NaN</td>
    </tr>
    <tr>
      <th>3</th>
      <td>2</td>
      <td>Beginning Kerberoasting</td>
      <td>Nik Alleyne</td>
      <td>NaN</td>
      <td>https://www.securitynik.com/2022/01/beginning-...</td>
      <td>NaN</td>
    </tr>
    <tr>
      <th>4</th>
      <td>5</td>
      <td>Beginning AS-REP Roasting with Impacket and Ru...</td>
      <td>Nik Alleyne</td>
      <td>NaN</td>
      <td>https://www.securitynik.com/2022/01/beginning-...</td>
      <td>NaN</td>
    </tr>
  </tbody>
</table>
</div>




```python
'''
With the dataframe now containing the CSV data
time to take the dataframe data and push it into the SQLite database
'''
df_blogs.to_sql(name='blogs', con=securitynik_db_connection, if_exists='append', index=False)
```

    2022-04-13 22:50:09,448 INFO sqlalchemy.engine.Engine PRAGMA main.table_info("blogs")
    2022-04-13 22:50:09,455 INFO sqlalchemy.engine.Engine [raw sql] ()
    2022-04-13 22:50:09,460 INFO sqlalchemy.engine.Engine BEGIN (implicit)
    2022-04-13 22:50:09,463 INFO sqlalchemy.engine.Engine INSERT INTO blogs (blogger_id, "BlogTitle", "Blogger", "Date", "URL", "Comments") VALUES (?, ?, ?, ?, ?, ?)
    2022-04-13 22:50:09,463 INFO sqlalchemy.engine.Engine [generated in 0.00174s] ((2, 'Installing & configuring Elasticsearch 8 and Kibana 8 on Ubuntu', 'Nik Alleyne', None, 'https://www.securitynik.com/2022/04/installing-configuring-elasticsearch-8.html', None), (3, 'Beginning Volatility3 Memory Forensics', 'Nik Alleyne', None, 'https://www.securitynik.com/2022/03/beginning-volatility3-memory-forensics.html', None), (4, 'Beginning DC Sync - Attack', 'Nik Alleyne', None, 'https://www.securitynik.com/2022/01/beginning-dc-sync-attack.html', None), (2, 'Beginning Kerberoasting', 'Nik Alleyne', None, 'https://www.securitynik.com/2022/01/beginning-kerberoasting.html', None), (5, 'Beginning AS-REP Roasting with Impacket and Rubeus', 'Nik Alleyne', None, 'https://www.securitynik.com/2022/01/beginning-as-rep-roasting-with-impacket.html', None), (6, 'Beginning AS-REP Roasting with Impacket and Rubeus', 'Nik Alleyne', None, 'https://www.securitynik.com/2022/01/beginning-as-rep-roasting-with-impacket.html', None))
    2022-04-13 22:50:09,469 INFO sqlalchemy.engine.Engine COMMIT
    


```python
'''
 With the data added to the various coluimns
 Time to now query the various tables
 Select the first 5 records from the employees table
'''
result_proxy = securitynik_db_connection.execute(select(employee_table)).fetchall()
result_proxy
```

    2022-04-13 22:50:09,563 INFO sqlalchemy.engine.Engine SELECT employees."EmployeeID", employees."FName", employees."LName", employees."Active", employees."Comments" 
    FROM employees
    2022-04-13 22:50:09,566 INFO sqlalchemy.engine.Engine [generated in 0.00228s] ()
    




    [(1, 'Nik', 'Alleyne', True, 'Blog Author'),
     (2, 'S', 'Alleyne', True, 'Blog Author'),
     (3, 'P', 'Khan', False, 'Blog Admin'),
     (4, 'TQ', 'G', True, 'Blog Manager'),
     (5, 'T', 'A', False, 'Blog Author'),
     (6, 'D', 'P', True, 'Blog Maintainer'),
     (7, 'J', 'S', False, 'Blog Contributor'),
     (8, 'C', 'P', True, 'Blog Comments Admin'),
     (9, 'A', 'W', False, 'Blog Author'),
     (10, 'User1', 'User1-last', True, 'user 1'),
     (11, 'User2', 'User2-last', False, 'user 2'),
     (12, 'User3', 'User3-last', True, 'user 3'),
     (13, 'User4', 'User4-last', True, 'user 4'),
     (14, 'User5', 'User5-last', False, 'user 5'),
     (15, 'User6', 'User6-last', True, 'user 6')]




```python
# How many records are there in the Employees table
len(result_proxy)
```




    15




```python
# Get a sample result Key
result_proxy[0].keys()

```




    RMKeyView(['EmployeeID', 'FName', 'LName', 'Active', 'Comments'])




```python
# With the result key, iterate through the results
print('EmployeeID | FName     |    LName  |     Active     |  Comments      ')
for result in result_proxy:
    print(f'{result.EmployeeID} |    {result.FName}   | {result.LName}  | { result.Active }  | {result.Comments}')
```

    EmployeeID | FName     |    LName  |     Active     |  Comments      
    1 |    Nik   | Alleyne  | True  | Blog Author
    2 |    S   | Alleyne  | True  | Blog Author
    3 |    P   | Khan  | False  | Blog Admin
    4 |    TQ   | G  | True  | Blog Manager
    5 |    T   | A  | False  | Blog Author
    6 |    D   | P  | True  | Blog Maintainer
    7 |    J   | S  | False  | Blog Contributor
    8 |    C   | P  | True  | Blog Comments Admin
    9 |    A   | W  | False  | Blog Author
    10 |    User1   | User1-last  | True  | user 1
    11 |    User2   | User2-last  | False  | user 2
    12 |    User3   | User3-last  | True  | user 3
    13 |    User4   | User4-last  | True  | user 4
    14 |    User5   | User5-last  | False  | user 5
    15 |    User6   | User6-last  | True  | user 6
    


```python
'''
Building on the query, adding a where clause
'''
securitynik_db_connection.execute(select(employee_table).where(employee_table.columns.LName=='Alleyne')).fetchmany(size=5)
```

    2022-04-13 22:50:09,930 INFO sqlalchemy.engine.Engine SELECT employees."EmployeeID", employees."FName", employees."LName", employees."Active", employees."Comments" 
    FROM employees 
    WHERE employees."LName" = ?
    2022-04-13 22:50:09,930 INFO sqlalchemy.engine.Engine [generated in 0.00245s] ('Alleyne',)
    




    [(1, 'Nik', 'Alleyne', True, 'Blog Author'),
     (2, 'S', 'Alleyne', True, 'Blog Author')]




```python
'''
Building on the above query, taking advantage of 'and_'
to compound the query.
Leveraging both .columns and .c 
'''
securitynik_db_connection.execute(select(employee_table).where(and_(
                                                    employee_table.columns.LName=='Alleyne',
                                                    employee_table.c.FName=='Nik',
                                                    employee_table.c.Active==True))).fetchone()
```

    2022-04-13 22:50:10,015 INFO sqlalchemy.engine.Engine SELECT employees."EmployeeID", employees."FName", employees."LName", employees."Active", employees."Comments" 
    FROM employees 
    WHERE employees."LName" = ? AND employees."FName" = ? AND employees."Active" = 1
    2022-04-13 22:50:10,016 INFO sqlalchemy.engine.Engine [generated in 0.00204s] ('Alleyne', 'Nik')
    




    (1, 'Nik', 'Alleyne', True, 'Blog Author')




```python
'''
Taking advantage of 'or_'
to compound the query.
Leveraging both .columns and .c 
'''
securitynik_db_connection.execute(select(employee_table).where(or_(
                                                    employee_table.columns.LName=='Alleyne',
                                                    employee_table.c.FName=='Nik',
                                                    employee_table.c.Active==False))).fetchmany(size=5)
```

    2022-04-13 22:50:10,114 INFO sqlalchemy.engine.Engine SELECT employees."EmployeeID", employees."FName", employees."LName", employees."Active", employees."Comments" 
    FROM employees 
    WHERE employees."LName" = ? OR employees."FName" = ? OR employees."Active" = 0
    2022-04-13 22:50:10,120 INFO sqlalchemy.engine.Engine [generated in 0.00237s] ('Alleyne', 'Nik')
    




    [(1, 'Nik', 'Alleyne', True, 'Blog Author'),
     (2, 'S', 'Alleyne', True, 'Blog Author'),
     (3, 'P', 'Khan', False, 'Blog Admin'),
     (5, 'T', 'A', False, 'Blog Author'),
     (7, 'J', 'S', False, 'Blog Contributor')]




```python
'''
Looking at columns in the blog table 
identif all records where the URL field is null
'''
securitynik_db_connection.execute(select(blogs_table).where(blogs_table.columns.URL==None)).fetchmany(size=5)
```

    2022-04-13 22:50:10,218 INFO sqlalchemy.engine.Engine SELECT blogs."BlogID", blogs.blogger_id, blogs."BlogTitle", blogs."Blogger", blogs."Date", blogs."URL", blogs."Comments" 
    FROM blogs 
    WHERE blogs."URL" IS NULL
    2022-04-13 22:50:10,224 INFO sqlalchemy.engine.Engine [generated in 0.00276s] ()
    




    []




```python
'''
Looking for all records where the URL is not NULL in the blogs table 
'''
securitynik_db_connection.execute(select(blogs_table).where(blogs_table.columns.URL!=None)).fetchmany(size=5)
```

    2022-04-13 22:52:07,991 INFO sqlalchemy.engine.Engine SELECT blogs."BlogID", blogs.blogger_id, blogs."BlogTitle", blogs."Blogger", blogs."Date", blogs."URL", blogs."Comments" 
    FROM blogs 
    WHERE blogs."URL" IS NOT NULL
    2022-04-13 22:52:07,999 INFO sqlalchemy.engine.Engine [generated in 0.00263s] ()
    




    [(1, 1, 'Beginning SQLAlchemy', 'Nik Alleyne', None, 'http://www.securitynik.com/beginning-sql-alchemy.html', 'Blog post created by Nik Alleyne'),
     (2, 2, 'Installing & configuring Elasticsearch 8 and Kibana 8 on Ubuntu', 'Nik Alleyne', None, 'https://www.securitynik.com/2022/04/installing-configuring-elasticsearch-8.html', None),
     (3, 3, 'Beginning Volatility3 Memory Forensics', 'Nik Alleyne', None, 'https://www.securitynik.com/2022/03/beginning-volatility3-memory-forensics.html', None),
     (4, 4, 'Beginning DC Sync - Attack', 'Nik Alleyne', None, 'https://www.securitynik.com/2022/01/beginning-dc-sync-attack.html', None),
     (5, 2, 'Beginning Kerberoasting', 'Nik Alleyne', None, 'https://www.securitynik.com/2022/01/beginning-kerberoasting.html', None)]




```python
'''
Finding records using Like
Looking specifically for records where the name is like kibana
Note I am ignorning the case by using iLike
'''
securitynik_db_connection.execute(select(blogs_table).where(blogs_table.columns.BlogTitle.ilike('%Kibana%'))).fetchmany(size=5)
```

    2022-04-13 22:55:20,398 INFO sqlalchemy.engine.Engine SELECT blogs."BlogID", blogs.blogger_id, blogs."BlogTitle", blogs."Blogger", blogs."Date", blogs."URL", blogs."Comments" 
    FROM blogs 
    WHERE lower(blogs."BlogTitle") LIKE lower(?)
    2022-04-13 22:55:20,407 INFO sqlalchemy.engine.Engine [generated in 0.00286s] ('%Kibana%',)
    




    [(2, 2, 'Installing & configuring Elasticsearch 8 and Kibana 8 on Ubuntu', 'Nik Alleyne', None, 'https://www.securitynik.com/2022/04/installing-configuring-elasticsearch-8.html', None)]




```python
'''
Revisiting the employee table 
ordering by Employee FName
Do it descending, as in going from Z to A rather than A to Z
Limit the results to 5 records
Only return the employee first and last name
'''
securitynik_db_connection.execute(select(employee_table.columns.FName, employee_table.c.LName).order_by(desc(employee_table.columns.FName)).limit(5)).fetchall()

```

    2022-04-13 23:05:59,563 INFO sqlalchemy.engine.Engine SELECT employees."FName", employees."LName" 
    FROM employees ORDER BY employees."FName" DESC
     LIMIT ? OFFSET ?
    2022-04-13 23:05:59,566 INFO sqlalchemy.engine.Engine [cached since 221.1s ago] (5, 0)
    




    [('User6', 'User6-last'),
     ('User5', 'User5-last'),
     ('User4', 'User4-last'),
     ('User3', 'User3-last'),
     ('User2', 'User2-last')]




```python
'''
Updating records where comments is empty in the blog table
'''

securitynik_db_connection.execute(update(blogs_table).where(blogs_table.c.Comments == None).values(Comments='SecurityNik is the blogger')).rowcount
```

    2022-04-13 23:12:41,303 INFO sqlalchemy.engine.Engine UPDATE blogs SET "Comments"=? WHERE blogs."Comments" IS NULL
    2022-04-13 23:12:41,303 INFO sqlalchemy.engine.Engine [generated in 0.00325s] ('SecurityNik is the blogger',)
    2022-04-13 23:12:41,312 INFO sqlalchemy.engine.Engine COMMIT
    




    6




```python
# Verifying the change was made on the blog table
securitynik_db_connection.execute(select(blogs_table.columns.Comments)).fetchall()
```

    2022-04-13 23:14:21,038 INFO sqlalchemy.engine.Engine SELECT blogs."Comments" 
    FROM blogs
    2022-04-13 23:14:21,038 INFO sqlalchemy.engine.Engine [cached since 11.3s ago] ()
    




    [('Blog post created by Nik Alleyne',),
     ('SecurityNik is the blogger',),
     ('SecurityNik is the blogger',),
     ('SecurityNik is the blogger',),
     ('SecurityNik is the blogger',),
     ('SecurityNik is the blogger',),
     ('SecurityNik is the blogger',)]




```python
# Delete the records we just created above
securitynik_db_connection.execute(delete(blogs_table).where(blogs_table.c.Comments =='SecurityNik is the blogger')).rowcount
```

    2022-04-13 23:15:51,942 INFO sqlalchemy.engine.Engine DELETE FROM blogs WHERE blogs."Comments" = ?
    2022-04-13 23:15:51,952 INFO sqlalchemy.engine.Engine [generated in 0.00454s] ('SecurityNik is the blogger',)
    2022-04-13 23:15:51,957 INFO sqlalchemy.engine.Engine COMMIT
    




    6




```python
'''
Drop the other table
'''
#other_table.drop(securitynik_db_engine)
```




    '\nDrop the other table\n'




```python
# Drop all tables
metadata.drop_all(securitynik_db_engine)
```


```python
'''
References:
https://campus.datacamp.com/courses/introduction-to-relational-databases-in-python
https://www.sqlalchemy.org/library.html
https://buildmedia.readthedocs.org/media/pdf/sqlalchemy/rel_1_0/sqlalchemy.pdf
https://www.tutorialspoint.com/sqlalchemy/sqlalchemy_quick_guide.htm
https://www.topcoder.com/thrive/articles/sqlalchemy-1-4-and-2-0-transitional-introduction
https://overiq.com/sqlalchemy-101/installing-sqlalchemy-and-connecting-to-database/


'''
```




    '\nReferences:\nhttps://campus.datacamp.com/courses/introduction-to-relational-databases-in-python\nhttps://www.sqlalchemy.org/library.html\nhttps://buildmedia.readthedocs.org/media/pdf/sqlalchemy/rel_1_0/sqlalchemy.pdf\nhttps://www.tutorialspoint.com/sqlalchemy/sqlalchemy_quick_guide.htm\nhttps://www.topcoder.com/thrive/articles/sqlalchemy-1-4-and-2-0-transitional-introduction\nhttps://overiq.com/sqlalchemy-101/installing-sqlalchemy-and-connecting-to-database/\n\n\n'


