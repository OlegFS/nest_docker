Ubuntu based docker imaged with conda,NEST, and jupyter lab
Ispired by https://github.com/steffengraber/nest-docker
Example usage: 

docker run -d --user nest  -p 6087:8888 \
 -v ~ovinogradov/Documents:/home/nest/data \
 u_nest jupyter lab --allow-root --ip=0.0.0.0
