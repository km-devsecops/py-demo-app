resource "aws_amplify_app" "demoenv" {
  name = "demoenv"
}

resource "aws_amplify_branch" "dev" {
  app_id      = aws_amplify_app.demoenv.id
  branch_name = "dev"

  framework = "React"
  stage     = "DEVELOPMENT"
}