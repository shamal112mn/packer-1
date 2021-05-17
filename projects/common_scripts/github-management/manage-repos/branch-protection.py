from github import Github
import os 

if os.environ.get('GIT_ADMIN_TOKEN'):
        
    g = Github(os.environ.get('GIT_ADMIN_TOKEN'))
else:
    print("Can not find the <GIT_TOKEN> as environment variable")
    exit(1)


def change_protected_branch_settings():
    # Loops through all the repos and changes the /settings/branch_protection_rules/
    # CAREFUL with this!
    for repo in g.get_user().get_repos():
        if 'fuchicorp' in str(repo.owner):
            master_branch = repo.get_branch("master")
            master_branch.edit_protection(required_approving_review_count=2)

            # dev_branch = repo.get_branch("dev-feature/*")
            # dev_branch.edit_protection(required_approving_review_count=1)

            # qa_branch = repo.get_branch("qa-feature/*")
            # qa_branch.edit_protection(required_approving_review_count=2)

            # stage_branch = repo.get_branch("stage-feature/*")
            # stage_branch.edit_protection(required_approving_review_count=2)

            print("Edited the branch protection rules for: " + repo.name)

def change_protected_branch_settings_test():
    repo = g.get_repo("org/repo_name")
    branch = g.get_repo("org/repo_name").get_branch("master")
    branch.edit_protection(required_approving_review_count=2, enforce_admins=True)

# Uncomment out one of these lines. Test to test a single repo/branch.
change_protected_branch_settings()
#change_protected_branch_settings_test()