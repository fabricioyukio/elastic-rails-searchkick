# Rails and Elasticsearch with SearchKick

This project seeks to be a proof of concept and, maybe, a boilerplate for a Rails+Elasticsearch App Stack.
The idea is that it will learn better responses for searches into some *prompts* used to train a *Stable-Diffusion* App. The *raw data* may be acquired in the following URI: https://huggingface.co/datasets/Gustavosta/Stable-Diffusion-Prompts/blob/main/README.md

Those files contain prompts (what people asked for Stable Diffusion) for training and testing.

<br>

## Initial considerations
As I, to this moment, have no idea of what would be a "nice real case scenario" it's just indexing the *search* and the *prompt*.

On future, I think I could get into some tagging, or most "valuable" words (creating that in a prefix tree).

### As of this moment we do have...

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
- **NGINX**, right now, only providing routing use URL's to access relevant applications

## Prepare your machine

### 0 - Before you begin...
For smoothly running this project you must edit your _hosts_ file adding the following lines...
```C
127.0.0.1 app.local.test //Rails App
127.0.0.1 elasticsearch.local.test
127.0.0.1 queue.local.test
// 127.0.0.1 kibana.local.test //Kibana to be added soon
//Elasticsearch, also running at http://elastic:9200
```
As every _OS_ has its own specific locations for such file, it's up to you to find out where that file locates in your machine.

Anyway if you want to set other URL's just adjust accordingly into *./nginx/conf/reverse-proxy.conf* file


### 1 - Get Docker
If you already have both *Docker* and *Docker Compose*, jump to step 3
To execute this project you need to use either _Docker_ and _Docker Compose_.
Fist, get *Docker* for the approprieate _OS_:
- MacOS: https://docs.docker.com/desktop/install/mac-install/
- Windows: https://docs.docker.com/desktop/install/windows-install/
- Linux: https://docs.docker.com/desktop/install/linux-install/

### 2 - Get Docker Compose
Then get *Docker Compose* on this link: https://docs.docker.com/compose/install/

### 3 - Elasticsearch Images
Most of the times you do not need to pull each image for the project, I did not get those to download immediately so I had to do it the hard way.

#### Get Elasticsearch Image
```bash
docker pull docker.elastic.co/elasticsearch/elasticsearch:8.7.0
```

#### Get Kibana Image
```bash
docker pull docker.elastic.co/kibana/kibana:8.7.0
```

When you've got the above tools and requirements, you just may begin...

### 4 - Downloading the project

Just **clone** this repo!

### 5 - Raising the Stack

Through your terminal App, navigate to the folder where you cloned this repo.

For the very first run, set the **.env** file:
```Bash
cp .env-example .env
```
You must check the file and place some required data.

Otherwise, you also need to add some Hash data to *./cg-rails/config/master.key* file

Start building, enter the command:
```Bash
docker-compose build
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
In order to properly use Javascripts and CSS, you will need to precompile the Assets.
After the stack rises, just access the container's terminal, navigate to rails App folder and run the following commands:

```bash
docker exec $APP bash -c
# $APP is the docker container for rails APP (app, by this project default)
# once the container's terminal is up, just do
bundle exec rails dartsass:build
bundle exec rails assets:precompile
# this will transform SCSS to CSS for the APP to use.
```


### 6 - Setting data

Before you start, you must start the DB.
Access the *Rails App* by using a terminal:
```bash
docker compose exec app sh
```
Then set the DB...
```bash
rails db:setup
```
...and run migrations
```bash
rails db:migrate
```
...and seed additional data, if needed
```bash
rails db:seed
```
If, by any reason, you need to restart all anew...
```bash
rails db:migrate:reset
```


### 7 - Add the Seeding data for training

Get the PARQUET files from: https://huggingface.co/datasets/Gustavosta/Stable-Diffusion-Prompts/blob/main/README.md

- Download one of the files (train.parquet or eval.parquet).
- Put the desired file into ```./app/storage/batch```, converted to CSV.

#### Convert file
For making things easier I've put a python script to make that conversion (converts a *parquet* file to "*.csv*"):
```bash
pip install -r requirements.txt
python parquet-to-csv.py $from_name $to_name
```
- **$from_name**: name of the parquet file, without extension (train.parquet: train)
- **$to_name**: name of the csv file, without extension (prompts.csv: prompts). Choose from: prompts, ...(maybe more to come)

Example of use:
```bash
python parquet-to-csv.py eval prompts
# this will transform eval.parquet into prompts.csv
```

Have in mind that once the files are used they will be **deleted**. So if one must *seed* it again, one will have to put a new *parquet* file in the same directory.

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

## Tips + Utilities

### Generate a secure random rash

```bash
rails c
```
it will open IRB, 16 character is enough for local development. Anyways, you should use a size of 32 or 64, for staging and production environments.
```irb
irb> SecureRandom.urlsafe_base64(16)
```
