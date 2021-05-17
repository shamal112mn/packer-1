@Library('CommonLib@master') _
def common = new com.lib.JenkinsCommonDeployPipeline()
common.runPipeline()

// this is the build job 