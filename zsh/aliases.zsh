alias reload!='. ~/.zshrc'
alias p="cd $PROJECTS"
alias h="cd ~"
alias d="cd ~/dotfiles"
alias g="git"

# ssh into vuw server
# for auto-password entry
# 1) ssh-keygen -t rsa -b 2048
#   a) specify file to save key to
#   b) use blank passphrase
# 2) ssh-copy-id id@server
alias ssh-vuw="ssh hardwiwill@barretts.ecs.vuw.ac.nz"
alias ssh-banana="ssh root@202.150.114.180"
alias ssh-rasp="ssh pi@202.150.114.180"
alias ssh-notes="ssh -i $LIGHTSAIL ec2-user@54.153.143.35"
alias ssh-notes-ci="ssh -i $HOME/.local/lib/aws/ec2.pem ec2user@ec2-13-211-188-99.ap-southeast-2.compute.amazonaws.com"


alias cls='clear' # Good 'ol Clear Screen command

