ARG PYTHON_VERSION=3.12 
ARG ALPINE_VERSION=3.22
# ARG is used while building Docker Image, docker build --build-arg, PASSING ARGUMENT


# python:3.12-alpine3.22 is used as base image for the application 
FROM python:${PYTHON_VERSION}-alpine${ALPINE_VERSION}

#1. __pycache__ == only helps to start Python faster by reusing compiled bytecode
# with container, we start python only once
# So we dont need __pycache__ in docker container case 
# 2. __pycache__ = will have .pyc files (Image Sizer)
# 3. Docker images are immutable = we need to build a new docker image  every time when there is app updates 
# - __pycache__= impact repeatable docker image builds


# ENV is used inside the running container, SHELL VARIABLE

# Prevents Python from writting PYC (__pycache__) files
# we should discuss with devolopers does app need PYC or Buffering
ENV PYTHONDONTWRITEBYTECODE=1


# Buffering in Python 
# Buffering = instead of sending outputs piece by piece, the buffering sends a single output = output is a log 
# we should discuss with devolopers does app need PYC or Buffering

ENV PYTHONUNBUFFERED=1 

WORKDIR /app 

# How can we prevent from running as root user? nobody/sbin/nologin 
# nobody can't execute anything
# USER nobody   --> pretty common

# creating a new user 
RUN adduser \ 
    --disable-password \
    --home "/nonexistent"\
    --shell "sbin/nologin" \
    --no-create-home \
    --uid "10001"\
    pythonuser

USER pythonuser

#copy from current directory into WORKDIR. source -> destination
COPY . .

EXPOSE 8000

CMD [ "python3", "-m", "uvicorn", "app:app", "host=0.0.0.0", "port=8000" ]