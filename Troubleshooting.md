
## Error: terraform state is locked

terraform force-unlock [lock-id]

## Error:

Waiting for a volume to be created either by the external provisioner 'efs.csi.aws.com' or manually by the system administrator. If volume creation is delayed, please verify that the provisioner is running and correctly registered.

### Solution:
helm install aws-efs-csi-driver aws-efs-csi-driver/aws-efs-csi-driver -n kube-system

## Error:

failed to provision volume with StorageClass "efs-sc": rpc error: code = Internal desc = Failed to create Access point in File System fs-0263715a9518b3f0c : Failed to create access point: operation error EFS: CreateAccessPoint, https response error StatusCode: 400, RequestID: 95c38f55-f08e-4734-abf8-f7ce6d0e019b, api error ValidationException: 2 validation errors detected: Value '' at 'rootDirectory.creationInfo.permissions' failed to satisfy constraint: Member must have length greater than or equal to 3; Value '' at 'rootDirectory.creationInfo.permissions' failed to satisfy constraint: Member must satisfy regular expression pattern: ^[0-7]{3,4}$

### Solution

IAM policy was missing for the Worker EC2 Node instance profile

## Error:

MountVolume.SetUp failed for volume "pvc-42aef935-5c0c-475f-a04f-07953f8cf82e" : rpc error: code = Internal desc = Could not mount "fs-0263715a9518b3f0c:/" at "/var/lib/kubelet/pods/a6668bcf-a30e-465a-a466-61f7375e934b/volumes/kubernetes.io~csi/pvc-42aef935-5c0c-475f-a04f-07953f8cf82e/mount": mount failed: exit status 1 Mounting command: mount Mounting arguments: -t efs -o accesspoint=fsap-0475afd30ec7e5ebb,tls fs-0263715a9518b3f0c:/ /var/lib/kubelet/pods/a6668bcf-a30e-465a-a466-61f7375e934b/volumes/kubernetes.io~csi/pvc-42aef935-5c0c-475f-a04f-07953f8cf82e/mount Output: Failed to resolve "fs-0263715a9518b3f0c.efs.eu-central-1.amazonaws.com". The file system mount target ip address cannot be found, please pass mount target ip address via mount options. No matching mount target in the az eu-central-1b. Please create one mount target in eu-central-1b, or try the mount target in another AZ by passing the availability zone name option. Available mount target(s) are in az ['eu-central-1a'] Warning: config file does not have fips_mode_enabled item in section mount.. You should be able to find a new config file in the same folder as current config file /etc/amazon/efs/efs-utils.conf. Consider update the new config file to latest config file. Use the default value [fips_mode_enabled = False].Warning: config file does not have fips_mode_enabled item in section mount.. You should be able to find a new config file in the same folder as current config file /etc/amazon/efs/efs-utils.conf. Consider update the new config file to latest config file. Use the default value [fips_mode_enabled = False].

### Solution
create mount target in the affected region too.

## Error in Pod

Warning  FailedMount  50s (x2 over 2m51s)  kubelet            MountVolume.SetUp failed for volume "pvc-42aef935-5c0c-475f-a04f-07953f8cf82e" : rpc error: code = DeadlineExceeded desc = context deadline exceeded

### Solution
the EC2 worker node wasn't allowd on the EFS

How to automatically assign security group to Worker node and EFS?


## Error in the container
Back-off restarting failed container influxdb2 in pod influxdb-influxdb2-0_influxdb(bb31e799-7897-4853-8a31-b1c3c3fd6b67)


  Type     Reason     Age                    From               Message
  ----     ------     ----                   ----               -------
  Normal   Scheduled  3m32s                  default-scheduler  Successfully assigned influxdb/influxdb-influxdb2-0 to ip-10-0-2-252.eu-central-1.compute.internal
  Normal   Pulling    3m30s                  kubelet            Pulling image "influxdb:2.7.4-alpine"
  Normal   Pulled     3m25s                  kubelet            Successfully pulled image "influxdb:2.7.4-alpine" in 5.09s (5.09s including waiting). Image size: 87570572 bytes.
  Normal   Created    2m33s (x4 over 3m25s)  kubelet            Created container influxdb2
  Normal   Started    2m32s (x4 over 3m25s)  kubelet            Started container influxdb2
  Warning  BackOff    2m7s (x11 over 3m23s)  kubelet            Back-off restarting failed container influxdb2 
in pod influxdb-influxdb2-0_influxdb(bb31e799-7897-4853-8a31-b1c3c3fd6b67)
  Normal   Pulled     112s (x4 over 3m24s)   kubelet            Container image "influxdb:2.7.4-alpine" already present on machine

  kubectl get events -n influxdb --field-selector involvedObject.name=influxdb-influxdb2-0

  LAST SEEN   TYPE      REASON             OBJECT                     MESSAGE
3m1s        Warning   FailedScheduling   pod/influxdb-influxdb2-0   0/1 nodes are available: pod has unbound immediate PersistentVolumeClaimmediate PersistentVolumeClaims. preemption: 0/1 nodes are available: 1 Preemption is not helpful for scheduling.                                                                                                              luxdb2-0 to ip-10-0-1-79.eu-c
2m59s       Normal    Scheduled          pod/influxdb-influxdb2-0   Successfully assigned influxdb/influxdb-influxdb2-0 to ip-10-0-1-79.eu-central-1.compute.internal                                                         d5a439-29eb-481c-b747-0c60ade
59s         Warning   FailedMount        pod/influxdb-influxdb2-0   MountVolume.SetUp failed for volume "pvc-b6d5a439-29eb-481c-b747-0c60ade6b9e4" : rpc error: code = DeadlineExceeded desc = context deadline exceeded  

kubectl logs influxdb-influxdb2-0 -n influxdb


## Error with helm install
PS E:\Akos\Development\repos\InfluxDB_e2e_demo\helm-charts\argo-cd> helm install argo-cd ./ -n argo-cd
Error: INSTALLATION FAILED: Unable to continue with install: CustomResourceDefinition "applicationsets.argoproj.io" in namespace "" exists and cannot be imported into the current release: invalid ownership metadata; annotation validation error: key "meta.helm.sh/release-namespace" must equal "argo-cd": current value is "default"

### Solution
kubectl delete crd applications.argoproj.io
kubectl delete crd applicationsets.argoproj.io
kubectl delete crd appprojects.argoproj.io

