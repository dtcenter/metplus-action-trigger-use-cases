#! /bin/sh

echo "GitHub repository: ${GITHUB_REPOSITORY}"
echo "GitHub ref: ${GITHUB_REF}"
echo "GitHub actor: ${GITHUB_ACTOR}"
echo "GitHub SHA: ${GITHUB_SHA}"

input_version=$(basename "${GITHUB_REF}")
input_component=$(basename "${GITHUB_REPOSITORY}")

# if workflow was triggered by branch other than develop,
# use METplus component versions script to determine METplus main_vX.Y branch
metplus_branch=develop
if [ "${input_version}" != "develop" ]; then
  git clone --single-branch --branch develop https://github.com/dtcenter/METplus
  cmd="./METplus/metplus/component_versions.py -i ${input_component} -v ${input_version} -o METplus -f main_v{X}.{Y}"
  echo "$cmd"
  metplus_branch=$($cmd)
fi

# if no branch can be determined, exit and error
if [ -z "${metplus_branch}" ]; then
  echo "ERROR: Could not get METplus branch"
  exit 1
fi

# if branch doesn't exist in remote, do not trigger METplus workflow
branch_exists=$(git -C ./METplus ls-remote origin "${metplus_branch}")
if [ -z "${branch_exists}" ]; then
  echo "WARNING: METplus branch ${metplus_branch} does not exist yet"
  exit 0
fi

# set env var to authenticate GitHub API
export GH_TOKEN="${INPUT_TOKEN}"

# trigger workflow using gh cli
json_inputs="{\"actor\": \"${GITHUB_ACTOR}\",\"ref\": \"${GITHUB_REF}\",\"repository\": \"${GITHUB_REPOSITORY}\",\"sha\": \"${GITHUB_SHA}\"}"
echo "Triggering METplus testing workflow on ${metplus_branch} branch using inputs: ${json_inputs}"
echo "${json_inputs}" | gh workflow run testing.yml --repo dtcenter/METplus --ref "${metplus_branch}" --json
