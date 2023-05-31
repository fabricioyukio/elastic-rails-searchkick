# Rails and Elasticsearch with SearchKick

This project seeks to be a proof of concept and, maybe, a boilerplate for a Rails+Elasticsearch App Stack.

It started as a *coding challenge* from CGTrader for the position of Rails Developer. It seemed a very interesting proposition, be it for comparison against Python or Javascript similar implementations, or just for the fun of learning and doing.

Then I repurposed this project as a proof of concept for a lecture about Rails and queueing.

The idea is that it will learn better responses for searches into some *prompts* used to train a *Stable-Diffusion* App. The *raw data* may be acquired in the following URI: https://huggingface.co/datasets/Gustavosta/Stable-Diffusion-Prompts/blob/main/README.md

Those files contain prompts (what people asked for Stable Diffusion) for training and testing.

<br>

## Initial considerations
As I, to this moment, have no idea of what would be a "*nice real case scenario*" it's just indexing "the *search* for the *prompt*".
In the future, I think I could get into some tagging, or most "valuable" words (creating that in a prefix tree).

Prior to this project, I'd always used Elastic Search with Python or Javascript/Typescript (NodeJS). Sidekiq works better with Ruby on Rails, and using Elastic Search with Sidekiq seemed a nice challenge and an interesting path to explore.

#### My Future Plans for this project
- Add more pages to this app, maybe showcasing more Hotwire widgets logic.
- Revamp Prompts data to have more complex indexing so we could do more things with ES.
- Add Kibana to the Stack so we could observe better what's going on.
- Also store search, for some cross operations.
- Use other test data for a more complex and interesting engineering.

### What is new

I'll try to document as I improve this project, with personal insights or just small tidbits.
#### 2023-05-24
- Updated documentation
- Made this "*./readme.md*" file better, correcting some typos I found, and adjusted some instructions to be clearer.
- Gave more clarification, as someone pointed out that there should be performed a compulsory reindex via Rails Console. (You might need if you loaded the DB data through any other way, that is not specified here, and there are lots of ways to do so.)

#### 2023-05-21
- Made the Specs for requests to work in both NGRok and Docker.
- Added some relevant Test Specs for Workers
- Added a dismiss for alerts in layout.
- Some minor adjustments on *readme.md* file.

#### 2023-05-10
- Some minor adjustments on *readme.md* file.


#### 2023-05-08
- Some minor adjustments on queueing

I decided to keep this repo and add more things to It to use it for teaching the use of ES in the future.

#### 2023-05-07
- Added Foreman
- Enabled Redis and SideKick
- Elasticsearch indexing in Background (async)

#### 2023-05-03 - night
- Added interface improvements with (Dart)**Sass** and CDN Bootstrap

#### 2023-05-03
- **Rails APP** that indexes the *prompts* from a DB into ES.
- **Elastic search** indexing the *prompts*
- **Postgres DB** storing *prompts*
- **NGINX**, right now, only provides routing use URLs to access relevant applications

## Prepare your machine

### 0 - Before you begin...

To smoothly run this project you must edit your _hosts_ file by adding the following lines...
```Bash
127.0.0.1 app.local.test //Rails App
127.0.0.1 elasticsearch.local.test
127.0.0.1 queue.local.test
// 127.0.0.1 kibana.local.test //Kibana to be added soon
//Elasticsearch, also running at http://elastic:9200
```

As every _OS_ has its specific locations for such files, it's up to you to find out where that file locates in your machine. Anyway, there follow the ones I remember where it is located:
- Mac OSX: ```/private/etc/hosts```
- Archlinux/Ubuntu/Fedora/Elementary: ```/etc/hosts```
- Windows 10: ```c:\Windows\System32\Drivers\etc\hosts.```

If you want to set other URLs just adjust accordingly into *./nginx/conf/reverse-proxy.conf* file


### 1 - Get Docker
If you already have both *Docker* and *Docker Compose*, jump to step 3
To execute this project you need to use either _Docker_ or _Docker Compose_.
First, get *Docker* for the appropriate _OS_:
- MacOS: https://docs.docker.com/desktop/install/mac-install/
- Windows: https://docs.docker.com/desktop/install/windows-install/
- Linux: https://docs.docker.com/desktop/install/linux-install/

### 2 - Get Docker Compose
Then get *Docker Compose* on this link: https://docs.docker.com/compose/install/

### 3 - Elasticsearch Images
Most of the time you do not need to pull each image for the project, I did not get those to download immediately so I had to do it the hard way.

#### Get Elasticsearch Image
```Bash
docker pull docker.elastic.co/elasticsearch/elasticsearch:8.7.0
```

<!--
#### Get Kibana Image
```Bash
docker pull docker.elastic.co/kibana/kibana:8.7.0
```
-->

When you've got the above tools and requirements, you just may begin...

### 4 - Downloading the project
Just **clone** this repo! :)

### 5 - Raising the Stack
Through your terminal App, navigate to the folder where you cloned this repo.

For the very first run, set the **.env** file:
```Bash
cp .env-example .env
```
You must check the file and place some required data.

Otherwise, you also need to add some Hash data to *./app/config/master.key* file

Access the folder for this project (```./```), where **docker-compose.yml** is located, and run the following commands.

To start building, enter the command:
```Bash
docker-compose build
# do this every time you alter any dockerfile
```

Have in mind that every time you use the above command, you rebuild the project.

Then, from now on, just use:
```Bash
docker-compose up -d
```

And, when you want to stop the stack:
```Bash
docker-compose down
```

#### Precompile assets
To properly use Javascript and CSS, you will need to precompile the Assets.
After the stack rises, just access the container's terminal, navigate to the root folder and run the following commands:

```Bash
docker exec $APP bash -c
# $APP is the docker container for rails APP (app, by this project default)
# once the container's terminal is up, just do
bundle exec rails dartsass:build
bundle exec rails assets:precompile
# this will transform SCSS to CSS for the APP to use.
```

### 6 - Get the data for training
The initial premise of the challenge that was proposed to me, is that I should use some Stable Diffusion prompts curated by **Gustavo Santana** and create a search app to find such content.

So, to do what we must, we need first acquire those prompts.
Get the PARQUET files from:
> https://huggingface.co/datasets/Gustavosta/Stable-Diffusion-Prompts/blob/main/README.md

The prompts are stored in PARQUET files.

According to Wikipedia...
> "Apache Parquet is a free and open-source column-oriented data storage format in the Apache Hadoop ecosystem. It is similar to RCFile and ORC, the other columnar-storage file formats in Hadoop, and is compatible with most of the data processing frameworks around Hadoop."

So there it is: to get some sweet data, we must first gnaw some not-so-commonly used files when coding with Rails.

Some ways to get into it:

> **TLDR**
> If you already have some Hadoop running, or have some better data-science tools, it might be best if you just use it and do it your way.
> I think, if you are already into data-something career, you are quite familiar with this and have better tools and options.

Then, returning to the developers standing point...

#### Alternative 1 - Read the Parquet file with Ruby/Ruby on Rails
You could use an ODBC Connection to read parquet data, kinda akin to accessing data from an SQLite db file.
I don't like that option, but it's an option no matter what.
Just check the link below, and follow the instructions:
> https://www.cdata.com/kb/tech/parquet-odbc-ruby.rst

#### Alternative 2 - Convert the file
My preferred solution for the scope "*having it coded*", as it is simple, and a little less painful.

##### Parquet files data extraction utility
For making things easier I've put a Python script to make that conversion (converts a *parquet*
file to "*.csv*"):
- Download one of the files (train.parquet or eval.parquet).
- Put the desired file into ```./app/storage/batch``` folder to be converted to CSV.
```Bash
# Once running the terminal,
# navigate to ```./app/storage/batch``` folder
cd ./app/storage/batch
# intalling python dependencies
pip install -r requirements.txt
# executing the script
python parquet-to-csv.py $from_name $to_name
#  $from_name: name of the parquet file, without extension (train.parquet: train)
#  $to_name: name of the csv file, without extension (prompts.csv: prompts). Choose from: prompts,
# ...(maybe more to come)
```
I did it that way, so if I would maybe add more data like this, I could reuse the already implemented code.

##### Example of use:
```Bash
python parquet-to-csv.py eval prompts
# this will transform eval.parquet into prompts.csv
```

Have in mind that once the *Parquet* files are used, they will be **deleted**. So if one must *seed* it again, one will have to put a new *Parquet* file in the same directory. I did so to not have to deal with unrelated files polluting our app. If you do not it like that way, just edit the Python file to suit your needs/liking. It is located at "```./app/storage/batch```".

There you have it! Just go to the next step, as the data are ready to be seeded.

##### Reset the data
If you for some reason have to purge the data, and you are at the latest migration, you'll need to re-seed.
If you did the above procedure, you must run the db seeding again:
```Bash
# just re-seed
rails db:seed
# purge them all, and start anew
rails db:migrate:reset
```
I took some extra precautions to not permit an entity that is seeded that way, to be seeded twice. But I recommend you to do it consciously and with careful thought.
For starting, take a peek at the seeds file at ```./app/db/seeds.tb``` and take your measures if you feel like it.

### 7 - Setting data

Before you start, you must start the DB.
Access the *Rails App* by using a terminal:
```Bash
docker compose exec app sh
```
Then set the DB...
```Bash
rails db:setup
```
...and run migrations
```Bash
rails db:migrate
```
...and seed additional data, if needed
```Bash
rails db:seed
```

#### Reindexing Prompts.
Someone pointed out that there is a need to reindex the Prompt data after seeding it.
If you pre-seeded Prompt having done procedures from the previous step, there is no need. After seeding from the *csv* file, a command to Reindex the Prompt data is done.

Anyway, if for some reason you still need to force that command...
```Bash
# acess dockerized Rails App
docker exec $APP bash -c
# $APP is the docker container for rails APP (app, by this project default)
# once the container's terminal is up, just do
rails c
# accessing the Rails Console
Prompt.reindex
# Performed reindexing for the prompts
# If there are any other similar Models, you must do it
# for every one of those
exit!
# exit
```

If, for any reason, you need to restart all anew...
```Bash
rails db:migrate:reset
```


___
</br>

## Acessing the App
Just accedd the following URLs:
### Rails App
http://app.local.test
### Sidekiq Queue
http://app.local.test/sidekiq/queue
### Elastic search instance
http://elastic.local.test
___
</br>


## Testing

Initialize tests
```Bash
rails generate rspec:install
rails db:migrate db:test:prepare
```

## Tips + Utilities

### Generate a new *master.key* for the Rails App

Delete config/master.key and *config/credentials.yml.enc*. Then run the command below and it will make a new key and encrypted credentials file.

```Bash
docker exec $APP bash -c
# $APP is the docker container for rails APP (app, by this project default)
# once the container's terminal is up, just do
rails credentials:edit
```

### Generate a secure random rash

```Bash
rails c
```
it will open IRB, 16 character is enough for local development. Anyways, you should use a size of 32 or 64, for staging and production environments.
```irb
irb> SecureRandom.urlsafe_base64(16)
```


<!--

TODO


Pros
* App works and does what it is supposed to do.
* Dockerized not only the database and ES part, but also the app itself. And dockerized very well.
* Latest ruby and gem versions.
* Lovely, well-detailed readme.
* Clean git commits, nice history.
* Nice front-end code.

Cons
* Could use a few specs.
* The Prompt model calls reindexing twice in a row - in after_save and in after_commit. I don't think it's necessary to duplicate them.
* Additionally, by default anytime a record is inserted, updated, or deleted, reindexing happens anyway. So the callbacks are wholly unnecessary (https://github.com/ankane/searchkick#strategies).
* I might be misunderstanding something, but before_validation :original_index isn't doing anything useful? Why is it there?

Nitpicks
* The readme is missing the step where [Prompt.reindex] needs to be run. I needed to open rails console and execute it there.
* Did not use rubocop or other tools for cody styling.
# default_scope is quite dangerous and one would need to think twice before using it. But in such a small test app it is fine. Although, ordering by ID might make more sense to take advantage of the DB index.
* about and contact actions in PageController do nothing.
* A lot of unused actions in PromptsController.
* about in routes.rb does nothing.
* A lot of unused code and files in general.




-->