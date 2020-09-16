# README

git clone https://github.com/dfairweather0205/Assessment.git

cd Assessment

docker-compose build

docker-compose up

docker-compose run web rake db:create

Open new terminal tab and run:
docker-compose run web rails db:migrate RAILS_ENV=development 


Test:

http://localhost:3000/health_check

http://localhost:3000/trails/search?lat=40.1108&lon=-105.7463


Known Issues: 

No test
Hardcoded envars & urls
Controllers needs to be refactored
