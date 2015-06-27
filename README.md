1. Create an S3 bucket
2. Add files for each environment and call them <deploy-env>-env.sh
3. Add the keys 
```yaml
    - AWS_ACCESS_KEY_ID=<your-key>
    - AWS_SECRET_ACCESS_KEY=<your-secret>
    - S3_BUCKET=<the-s3-bucket>
    - DEPLOY_ENV=<deployment-env e.g. prod|dev>
    - S3_CONF_KEY=<any-value>
```    
4. Map the volume /conf to a directory on the host    
5. Deploy this image to every host in $DEPLOY_ENV
6. On other images add the environment variable S3_CONF_KEY and map the volume from (4) to /conf (read-only)
7. Add the following line to use the shell variables from your env.sh script, it must run as root.

   . /conf/env.sh
        
8. ** Run your app as any non-root user **
        
If you're unsure take a look at docker-compose.yml it's all in there.

To deploy an example on Tutum (change the AWS credentials after clicking):

[![Deploy to Tutum](https://s.tutum.co/deploy-to-tutum.svg)](https://dashboard.tutum.co/stack/deploy/)
        
[![](https://badge.imagelayers.io/vizzbuzz/s3-conf.svg)](https://imagelayers.io/?images=vizzbuzz/s3-conf:latest 'Get your own badge on imagelayers.io')        