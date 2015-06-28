This image provides a container that will download all your secure keys from one of your S3 buckets and then put it into a shared volume. The other containers then just map to that volume, then send the configuration to their applications using stdin (or whatever method suits) as a non-root user.

It also avoids you checking in environment variables containing keys to Github by accident.  Just deploy this as a stack manually with the Tutum button and let it get them from AWS instead.

1. Create an S3 bucket
2. Add a configuration file
3. Add the environment variables as follows: 
```yaml
    - AWS_ACCESS_KEY_ID=<your-key>
    - AWS_SECRET_ACCESS_KEY=<your-secret>
    - S3_BUCKET=<the-s3-bucket>
    - S3_CONF_SOURCE_FILE=<your-sourcefile-in-s3>
    - S3_CONF_DEST_FILE=<your-local-file>
```    
4. Map the volume `/conf` to a directory on the host    
5. Deploy this image to every host in your environment.
6. On other images  map the volume from (4) to `/conf` (read-only)
7. Use a line like the following, it must run as root and your app shouldn't.

   cat /conf/conf.yml | su -u appuser node myapp.js
        
8. Make sure your app reads from `stdin` like above so that we don't leak information.
        
If you're unsure take a look at `docker-compose.yml` it's all in there.

To deploy an example on Tutum (change the AWS credentials after clicking):

[![Deploy to Tutum](https://s.tutum.co/deploy-to-tutum.svg)](https://dashboard.tutum.co/stack/deploy/)
        
[![](https://badge.imagelayers.io/vizzbuzz/s3-conf.svg)](https://imagelayers.io/?images=vizzbuzz/s3-conf:latest 'Get your own badge on imagelayers.io')        