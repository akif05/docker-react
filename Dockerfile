From node:alpine as builder
# Specify workin dir
Workdir '/app'

# Copy over package.json to app directory
COPY package.json .

# Run
Run npm install

# Copy over all of the source code
# This will be not dev but production
# We are not changing our code
# That's why we don't need to map volumes to see code cange live
COPY . .

# After copy our source over run npm run build to build the code
RUN npm run build

## End of builder step

# Our build folder will be create inside docker build directory
# Inside the container build directory will apear inside app dir
# like: /app/build
# This is the directory we care about
# In run phase we need to copy this dir to nginx

# Start of the Run phase
FROM nginx

# Copy here the build folder created from prewious Build
# Copy something from different phase (previous in our case)
COPY --from=builder /app/build /usr/share/nginx/html

# Default nginx container command is start, that's why we dont need to run


