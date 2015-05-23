## Docker-Atom
 
Docker images for [Atom](https://atom.io/) (because, why the hell not?) 

        docker build -t atom .
        docker run -v /tmp/.X11-unix:/tmp/.X11-unix -e DISPLAY=$DISPLAY atom

Inspired by [Jessie Frazelle](https://github.com/jfrazelle/dockerfiles/blob/master/atom/Dockerfile)
