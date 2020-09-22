#!/bin/bash

set -o errexit -o errtrace -o nounset -o pipefail -o xtrace

if [ "${FORCE_FAILURE:-}" == '1' ]; then
  docker-compose --project-name canvas-lms0 exec -T -e FORCE_FAILURE=1 canvas bundle exec flakey_spec_catcher \
      --repeat=$FSC_REPEAT_FACTOR \
      --output=/usr/src/app/tmp/fsc.out \
      --test=spec/force_failure_spec.rb
elif [ "${IS_PLUGIN}" == "1" ]; then
   docker-compose --project-name canvas-lms0 exec -T canvas \
         bash -c "cd $DOCKER_WORKDIR && BUNDLE_GEMFILE=../../../Gemfile bundle exec flakey_spec_catcher \
         --repeat=$FSC_REPEAT_FACTOR \
         --output=/usr/src/app/tmp/fsc.out \
         --use-parent \
         --test=$FSC_TESTS \
         --rspec-options '-I spec_canvas'"
else
  docker-compose --project-name canvas-lms0 exec -T canvas \
      bash -c "cd $DOCKER_WORKDIR && bundle exec flakey_spec_catcher \
      --repeat=$FSC_REPEAT_FACTOR \
      --output=/usr/src/app/tmp/fsc.out \
      --test=$FSC_TESTS \
      --use-parent"
fi
