ACCESS KEY = AKIA6GBMFOOO2JXF3B7R
SECRET KEY = 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

Steps :

1. git rm *.git
2. git init
3. git remote add origin git@github.com:subho-bm18/educosys-devops.git
4. git remote -v
origin  git@github.com:subho-bm18/educosys-devops.git (fetch)
origin  git@github.com:subho-bm18/educosys-devops.git (push)

5. ssh -T -ai ~/.ssh/id_ed25519_subho_bm git@github.com
Hi subho-bm18! You've successfully authenticated, but GitHub does not provide shell access.
4. git remote set-url origin git@github.com-subho-bm18:subho-bm18/educosys-devops.git
5. git push origin terraform-networking
