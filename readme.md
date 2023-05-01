# Rails and Elasticsearch with SearchKick

<br>

## Prepare your machine

### 0 - Before you begin...
For smoothly running this project you must edit your _hosts_ file adding the following lines...
```
127.0.0.1 app.local.test
127.0.0.1 elasticsearch.local.test
127.0.0.1 kibana.local.test
```
As every _OS_ has its own specific locations for such file, it's up to you to find out where that file locates in your machine.


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

Through your terminal app navigate to the folder where you cloned this repo.

For the very first run, enter the command:
```Bash
docker-compose build
```
Have in mind that everytime you use the above command you rebuild the project.

Then, from now on, just use:
```Bash
docker-compose up -d
```
And, when you want to stop the stack:
```Bash
docker-compose down
```

### 6 - Setting databases

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


___
</br>

## Acessing the App
Just accedd the following URL:
http://app.local.test
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
