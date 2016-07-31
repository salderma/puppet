#!/usr/bin/env bash
# Continuous Integration / Continuous Deployment tasks

# CI Install
ci_install(){
  echo 'Install VGS library'
  git clone https://github.com/vghn/vgs.git ~/vgs

  echo 'Install AWS-CLI'
  pip install --user --upgrade awscli

  echo 'Update Bundler'
  gem update bundler

  echo 'Install gems'
  set_bundle_directory "$APPDIR"
  bundle install --path vendor

  echo 'Install profile testing gems'
  set_bundle_directory "${APPDIR}/dist/profile"
  bundle install --without development system_tests --path vendor
}

# CI Test
ci_test(){
  e_info 'Get private data'
  download_private_data

  e_info 'Run profile tests'
  set_bundle_directory "${APPDIR}/dist/profile"
  bundle exec rake test

  e_info 'Build docker images'
  set_bundle_directory "$APPDIR"
  bundle exec rake docker:build
}

# CI Deploy
ci_deploy(){
  if [[ "$ENVTYPE" == 'production' ]]; then
    e_info 'Login to Docker Registry'
    docker login -e="$DOCKER_EMAIL" -u="$DOCKER_USERNAME" -p="$DOCKER_PASSWORD";

    e_info 'Publish docker images'
    set_bundle_directory "$APPDIR"
    bundle exec rake docker:publish
  fi

  publish_artifact

  e_info 'Deploy command'
  aws_ec2_send_run_command 'rhea' 'Start VPM' '/opt/vpm/bin/start --update-repo --update-docker-images'
}
