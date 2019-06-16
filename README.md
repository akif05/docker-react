This project was bootstrapped with [Create React App](https://github.com/facebook/create-react-app).

## Available Scripts

In the project directory, you can run:

### `npm start`

Runs the app in the development mode.<br>
Open [http://localhost:3000](http://localhost:3000) to view it in the browser.

The page will reload if you make edits.<br>
You will also see any lint errors in the console.

### `npm test`

Launches the test runner in the interactive watch mode.<br>
See the section about [running tests](https://facebook.github.io/create-react-app/docs/running-tests) for more information.

### `npm run build`

Builds the app for production to the `build` folder.<br>
It correctly bundles React in production mode and optimizes the build for the best performance.

The build is minified and the filenames include the hashes.<br>
Your app is ready to be deployed!

See the section about [deployment](https://facebook.github.io/create-react-app/docs/deployment) for more information.

### `npm run eject`

**Note: this is a one-way operation. Once you `eject`, you can’t go back!**

If you aren’t satisfied with the build tool and configuration choices, you can `eject` at any time. This command will remove the single build dependency from your project.

Instead, it will copy all the configuration files and the transitive dependencies (Webpack, Babel, ESLint, etc) right into your project so you have full control over them. All of the commands except `eject` will still work, but they will point to the copied scripts so you can tweak them. At this point you’re on your own.

You don’t have to ever use `eject`. The curated feature set is suitable for small and middle deployments, and you shouldn’t feel obligated to use this feature. However we understand that this tool wouldn’t be useful if you couldn’t customize it when you are ready for it.

## Learn More

You can learn more in the [Create React App documentation](https://facebook.github.io/create-react-app/docs/getting-started).

To learn React, check out the [React documentation](https://reactjs.org/).

### Code Splitting

This section has moved here: https://facebook.github.io/create-react-app/docs/code-splitting

### Analyzing the Bundle Size

This section has moved here: https://facebook.github.io/create-react-app/docs/analyzing-the-bundle-size

### Making a Progressive Web App

This section has moved here: https://facebook.github.io/create-react-app/docs/making-a-progressive-web-app

### Advanced Configuration

This section has moved here: https://facebook.github.io/create-react-app/docs/advanced-configuration

### Deployment

This section has moved here: https://facebook.github.io/create-react-app/docs/deployment

### `npm run build` fails to minify

This section has moved here: https://facebook.github.io/create-react-app/docs/troubleshooting#npm-run-build-fails-to-minify


## For production we need to add nginx 
Builds a docker file with multistep buils file
Build phase -> use node:alpine, copy the package.json file, 
    install dependecies, run 'npm run build
 
Run Phase -> Use nginx, copy over the result of 'npm run build'
    start nginx
  # Everithing prodused from 'Build phase' will be copyed to nginx container
    and used to be served from nginx
    This will be only directory
    Use node:alpine, Copy the package.json, Install dependencies, 
    Run 'npm run build' are droped and only the output of thise steps is used to be served from nginx!

Create Dockerfile
tee Dockerfile <<EOF
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

# End of creating nginx 
# history of commands
 docker build .

 docker run -p 8080:80 1118ce0a5176

 # Access from web bowser on http://localhost:8080 

## Travis CI == continues integration
# Create git repo
cd Docker/react
git init
git status
git add .
git commit -m "initial commit"
# Create github repo
curl -u 'akif05' https://api.github.com/user/repos -d '{"name":"docker-react"}'
# connect local git to github repo
git remote add origin https://github.com/akif05/docker-react.git
# Push the localcode to github
git push -u origin master


tee ./.travis.yml << EOF
# Tell Travis we need a copy of docker running
sudo: required
services:
  - docker

# Build our image using Dockerfile.dev
before_intall:
  - docker build -t akif05/docker-react -f Dockerfile.dev

# Tell Travis how to run our test suite
# script section defines all commands to run test
# our 'npm run test' will wait for input, that's why we
# need to add '-- --coverage'
# with this 'npm run test' will automaticaly exit
script:
  - docker run akif05/docker-react npm run test -- --coverage 
EOF

