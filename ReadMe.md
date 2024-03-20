
### Setup This CI CD In Ubuntu

```
cd /opt
sudo git clone git@github.com:abhishek-clovertex/ast-poc-ci.git
cp config.ini.example config.ini
```

### Jenkins Pipeline
> Add following Inside Jenkins Pipeline
```
sudo -H /bin/bash /opt/ast-poc-ci/scan_project.sh $JOB_NAME
```
