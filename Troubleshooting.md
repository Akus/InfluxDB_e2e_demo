
## Error:

Waiting for a volume to be created either by the external provisioner 'efs.csi.aws.com' or manually by the system administrator. If volume creation is delayed, please verify that the provisioner is running and correctly registered.

### Solution:
helm install aws-efs-csi-driver aws-efs-csi-driver/aws-efs-csi-driver -n kube-system

## Error:

failed to provision volume with StorageClass "efs-sc": rpc error: code = Internal desc = Failed to create Access point in File System fs-0263715a9518b3f0c : Failed to create access point: operation error EFS: CreateAccessPoint, https response error StatusCode: 400, RequestID: 95c38f55-f08e-4734-abf8-f7ce6d0e019b, api error ValidationException: 2 validation errors detected: Value '' at 'rootDirectory.creationInfo.permissions' failed to satisfy constraint: Member must have length greater than or equal to 3; Value '' at 'rootDirectory.creationInfo.permissions' failed to satisfy constraint: Member must satisfy regular expression pattern: ^[0-7]{3,4}$

### Solution