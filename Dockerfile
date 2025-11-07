# ARG is used while building Docker Image, docker build --build-arg, PASSING ARGUMENT

ARG PYTHON_VERSION=3.12
ARG ALPINE_VERSION=3.22

# python:3.12-alpine3.22 is used as base image for the application
FROM python:${PYTHON_VERSION}-alpine${ALPINE_VERSION}

# 1. __pycache__ = only helps to start Python faster by resusing compiled bytecode 
# 2. __pycache__ = will have .pyc files (Image Sizer)
# 3. docker images are immutable = we need to build a new docker image every time when there is app updates
#  - __pycache__ = impact repeatable docker image builds

# ENV is used inside the running container, SHELL VARIABLE

# Prevents Python from writing PYC files
ENV PYTHONDONTWRITEBYTECODE=1

# Buffering in Python

# Buffering = instead of sending outputs piece by piece, the buffering sends a single output = output is a log

ENV PYTHONUNBUFFERED=1

WORKDIR /app

COPY . .

RUN python -m pip install -r requirements.txt

RUN adduser \
    --disabled-password \
    --home "/nonexistent" \
    --shell "/sbin/nologin" \ 
    --no-create-home \ 
    --uid "10001" \ 
    pythonuser

USER pythonuser

EXPOSE 8000

CMD [ "python3", "-m", "uvicorn", "app:app", "--host=0.0.0.0", "--port=8000" ]