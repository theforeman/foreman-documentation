module.exports = async ({github, context, core, fs, artifact_name}) => {
  let allArtifacts = await github.rest.actions.listWorkflowRunArtifacts({
     owner: context.repo.owner,
     repo: context.repo.repo,
     run_id: context.payload.workflow_run.id,
  });
  let matchArtifact = allArtifacts.data.artifacts.filter((artifact) => {
    return artifact.name == artifact_name
  })[0];
  let download = await github.rest.actions.downloadArtifact({
     owner: context.repo.owner,
     repo: context.repo.repo,
     artifact_id: matchArtifact.id,
     archive_format: 'zip',
  });
  fs.writeFileSync(`${process.env.GITHUB_WORKSPACE}/${artifact_name}.zip`, Buffer.from(download.data));
};
