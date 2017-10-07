## Requirements
- Vagrant 1.9.x
- Hyper-V
- External Hyper-V vSwitch named "Vagrant" (or pass name to vagrant)

## Advice
- `vagrant up` takes roughly 5.3 minutes and results in 1 node as master/worker and schedulable.
  - Centos 7
  - Running through Hyper-V
  - Kubernetes 1.7
  - Docker 17.06.1.ce-1
  - Flannel Network (but not supported by Windows so gotta figure that problem out later)
  - Dashboard running (but not yet accessible)
  - Memory demand is 3GB
  - Requires about 2GB of space for vagrant VHD

## Usage
 - `$sw = New-Object -TypeName System.Diagnostics.Stopwatch`
 - `$sw.Reset(); $sw.start(); vagrant up; $sw.stop(); $sw.Elapsed;`
 - Then `vagrant ssh` to connect and inspect. `sudo su -` to resume the provisioning session and have kube config

## Expected output
```
Bringing machine 'master' up with 'hyperv' provider...
==> master: Verifying Hyper-V is enabled...
==> master: Configured Dynamic memory allocation, maxmemory is 3072
==> master: Configured startup memory is 1024
==> master: Configured cpus number is 4
==> master: Configured enable virtualization extensions is true
==> master: Configured differencing disk instead of cloning
==> master: Importing a Hyper-V instance
Looking for switch with name: Vagrant
Found switch: Vagrant
    master: Cloning virtual hard drive...
    master: Creating and registering the VM...
    master: Setting VM Integration Services
    master: Successfully imported a VM with name: centos-7-1-1.x86_64
==> master: Starting the machine...
==> master: Waiting for the machine to report its IP address...
    master: Timeout: 120 seconds
    master: IP: fe80::215:5dff:fecb:6141
==> master: Waiting for machine to boot. This may take a few minutes...
    master: SSH address: 10.4.128.219:22
    master: SSH username: vagrant
    master: SSH auth method: private key
    master:
    master: Vagrant insecure key detected. Vagrant will automatically replace
    master: this with a newly generated keypair for better security.
    master:
    master: Inserting generated public key within guest...
    master: Removing insecure key from the guest if it's present...
    master: Key inserted! Disconnecting and reconnecting using new SSH key...
==> master: Machine booted and ready!
==> master: Running provisioner: shell...
    master: Running: C:/Users/ROBERT~1.MOR/AppData/Local/Temp/vagrant-shell20170828-36652-1u10r0q.sh
==> master: Importing GPG key 0xA7317B0F:
==> master:  Userid     : "Google Cloud Packages Automatic Signing Key <gc-team@google.com>"
==> master:  Fingerprint: d0bc 747f d8ca f711 7500 d6fa 3746 c208 a731 7b0f
==> master:  From       : https://packages.cloud.google.com/yum/doc/yum-key.gpg
==> master: Package yum-utils-1.1.31-40.el7.noarch already installed and latest version
==> master: Package device-mapper-persistent-data-0.6.3-1.el7.x86_64 already installed and latest version
==> master: Package 7:lvm2-2.02.166-1.el7_3.5.x86_64 already installed and latest version
==> master: Loaded plugins: fastestmirror
==> master: adding repo from: https://download.docker.com/linux/centos/docker-ce.repo
==> master: grabbing file https://download.docker.com/linux/centos/docker-ce.repo to /etc/yum.repos.d/docker-ce.repo
==> master: repo saved to /etc/yum.repos.d/docker-ce.repo
==> master: Loaded plugins: fastestmirror
==> master: ============================= repo: docker-ce-edge =============================
==> master: [docker-ce-edge]
==> master: async = True
==> master: bandwidth = 0
==> master: base_persistdir = /var/lib/yum/repos/x86_64/7
==> master: baseurl = https://download.docker.com/linux/centos/7/x86_64/edge
==> master: cache = 0
==> master: cachedir = /var/cache/yum/x86_64/7/docker-ce-edge
==> master: check_config_file_age = True
==> master: compare_providers_priority = 80
==> master: cost = 1000
==> master: deltarpm_metadata_percentage = 100
==> master: deltarpm_percentage =
==> master: enabled = False
==> master: enablegroups = True
==> master: exclude =
==> master: failovermethod = priority
==> master: ftp_disable_epsv = False
==> master: gpgcadir = /var/lib/yum/repos/x86_64/7/docker-ce-edge/gpgcadir
==> master: gpgcakey =
==> master: gpgcheck = True
==> master: gpgdir = /var/lib/yum/repos/x86_64/7/docker-ce-edge/gpgdir
==> master: gpgkey = https://download.docker.com/linux/centos/gpg
==> master: hdrdir = /var/cache/yum/x86_64/7/docker-ce-edge/headers
==> master: http_caching = all
==> master: includepkgs =
==> master: ip_resolve =
==> master: keepalive = True
==> master: keepcache = False
==> master: mddownloadpolicy = sqlite
==> master: mdpolicy = group:small
==> master: mediaid =
==> master: metadata_expire = 21600
==> master: metadata_expire_filter = read-only:present
==> master: metalink =
==> master: minrate = 0
==> master: mirrorlist =
==> master: mirrorlist_expire = 86400
==> master: name = Docker CE Edge - x86_64
==> master: old_base_cache_dir =
==> master: password =
==> master: persistdir = /var/lib/yum/repos/x86_64/7/docker-ce-edge
==> master: pkgdir = /var/cache/yum/x86_64/7/docker-ce-edge/packages
==> master: proxy = False
==> master: proxy_dict =
==> master: proxy_password =
==> master: proxy_username =
==> master: repo_gpgcheck = False
==> master: retries = 10
==> master: skip_if_unavailable = False
==> master: ssl_check_cert_permissions = True
==> master: sslcacert =
==> master: sslclientcert =
==> master: sslclientkey =
==> master: sslverify = True
==> master: throttle = 0
==> master: timeout = 30.0
==> master: ui_id = docker-ce-edge/x86_64
==> master: ui_repoid_vars = releasever,
==> master:    basearch
==> master: username =
==> master: Loaded plugins: fastestmirror
==> master: Loading mirror speeds from cached hostfile
==> master:  * base: centos.eecs.wsu.edu
==> master:  * extras: ftpmirror.your.org
==> master:  * updates: centos-distro.cavecreek.net
==> master: Metadata Cache Created
==> master: warning: /var/cache/yum/x86_64/7/kubernetes/packages/f0a51fcde5e3b329050d7a6cf70f04a6cdf09eacfbad55f4324bfa2ea4312d0e-kubeadm-1.7.4-0.x86_64.rpm: Header V4 RSA/SHA1 Signature, key ID 3e1ba8d5: NOKEY
==> master: Public key for f0a51fcde5e3b329050d7a6cf70f04a6cdf09eacfbad55f4324bfa2ea4312d0e-kubeadm-1.7.4-0.x86_64.rpm is not installed
==> master: Public key for socat-1.7.2.2-5.el7.x86_64.rpm is not installed
==> master: warning: /var/cache/yum/x86_64/7/base/packages/socat-1.7.2.2-5.el7.x86_64.rpm: Header V3 RSA/SHA256 Signature, key ID f4a80eb5: NOKEY
==> master: Importing GPG key 0xA7317B0F:
==> master:  Userid     : "Google Cloud Packages Automatic Signing Key <gc-team@google.com>"
==> master:  Fingerprint: d0bc 747f d8ca f711 7500 d6fa 3746 c208 a731 7b0f
==> master:  From       : https://packages.cloud.google.com/yum/doc/yum-key.gpg
==> master: Importing GPG key 0x3E1BA8D5:
==> master:  Userid     : "Google Cloud Packages RPM Signing Key <gc-team@google.com>"
==> master:  Fingerprint: 3749 e1ba 95a8 6ce0 5454 6ed2 f09c 394c 3e1b a8d5
==> master:  From       : https://packages.cloud.google.com/yum/doc/rpm-package-key.gpg
==> master: Importing GPG key 0xF4A80EB5:
==> master:  Userid     : "CentOS-7 Key (CentOS 7 Official Signing Key) <security@centos.org>"
==> master:  Fingerprint: 6341 ab27 53d7 8a78 a7c2 7bb1 24c6 a8a7 f4a8 0eb5
==> master:  Package    : centos-release-7-3.1611.el7.centos.x86_64 (@anaconda)
==> master:  From       : /etc/pki/rpm-gpg/RPM-GPG-KEY-CentOS-7
==> master: Public key for docker-ce-17.06.1.ce-1.el7.centos.x86_64.rpm is not installed
==> master: warning: /var/cache/yum/x86_64/7/docker-ce-stable/packages/docker-ce-17.06.1.ce-1.el7.centos.x86_64.rpm: Header V4 RSA/SHA512 Signature, key ID 621e9f35: NOKEY
==> master: Importing GPG key 0x621E9F35:
==> master:  Userid     : "Docker Release (CE rpm) <docker@docker.com>"
==> master:  Fingerprint: 060a 61c5 1b55 8a7f 742b 77aa c52f eb6b 621e 9f35
==> master:  From       : https://download.docker.com/linux/centos/gpg
==> master: Created symlink from /etc/systemd/system/multi-user.target.wants/kubelet.service to /etc/systemd/system/kubelet.service.
==> master: Created symlink from /etc/systemd/system/multi-user.target.wants/docker.service to /usr/lib/systemd/system/docker.service.
==> master: [kubeadm] WARNING: kubeadm is in beta, please do not use it for production clusters.
==> master: [init] Using Kubernetes version: v1.7.4
==> master: [init] Using Authorization modes: [Node RBAC]
==> master: [preflight] Running pre-flight checks
==> master: [preflight] WARNING: docker version is greater than the most recently validated version. Docker version: 17.06.1-ce. Max validated version: 1.12
==> master: [kubeadm] WARNING: starting in 1.8, tokens expire after 24 hours by default (if you require a non-expiring token use --token-ttl 0)
==> master: [certificates] Generated CA certificate and key.
==> master: [certificates] Generated API server certificate and key.
==> master: [certificates] API Server serving cert is signed for DNS names [k8s-03 kubernetes kubernetes.default kubernetes.default.svc kubernetes.default.svc.cluster.local] and IPs [10.96.0.1 10.4.128.219]
==> master: [certificates] Generated API server kubelet client certificate and key.
==> master: [certificates] Generated service account token signing key and public key.
==> master: [certificates] Generated front-proxy CA certificate and key.
==> master: [certificates] Generated front-proxy client certificate and key.
==> master: [certificates] Valid certificates and keys now exist in "/etc/kubernetes/pki"
==> master: [kubeconfig] Wrote KubeConfig file to disk: "/etc/kubernetes/scheduler.conf"
==> master: [kubeconfig] Wrote KubeConfig file to disk: "/etc/kubernetes/admin.conf"
==> master: [kubeconfig] Wrote KubeConfig file to disk: "/etc/kubernetes/kubelet.conf"
==> master: [kubeconfig] Wrote KubeConfig file to disk: "/etc/kubernetes/controller-manager.conf"
==> master: [apiclient] Created API client, waiting for the control plane to become ready
==> master: [apiclient] All control plane components are healthy after 93.464838 seconds
==> master: [token] Using token: ceaf47.de3818a8722a28e5
==> master: [apiconfig] Created RBAC rules
==> master: [addons] Applied essential addon: kube-proxy
==> master: [addons] Applied essential addon: kube-dns
==> master:
==> master: Your Kubernetes master has initialized successfully!
==> master:
==> master: To start using your cluster, you need to run (as a regular user):
==> master:
==> master:   mkdir -p $HOME/.kube
==> master:   sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
==> master:   sudo chown $(id -u):$(id -g) $HOME/.kube/config
==> master:
==> master: You should now deploy a pod network to the cluster.
==> master: Run "kubectl apply -f [podnetwork].yaml" with one of the options listed at:
==> master:   http://kubernetes.io/docs/admin/addons/
==> master:
==> master: You can now join any number of machines by running the following on each node
==> master: as root:
==> master:
==> master:   kubeadm join --token ceaf47.de3818a8722a28e5 10.4.128.219:6443
==> master: node "k8s-03" untainted
==> master: serviceaccount "flannel" created
==> master: configmap "kube-flannel-cfg" created
==> master: daemonset "kube-flannel-ds" created
==> master: clusterrole "flannel" created
==> master: clusterrolebinding "flannel" created
==> master: serviceaccount "kubernetes-dashboard" created
==> master: clusterrolebinding "kubernetes-dashboard" created
==> master: deployment "kubernetes-dashboard" created
==> master: service "kubernetes-dashboard" created
==> master: No resources found.
The SSH command responded with a non-zero exit status. Vagrant
assumes that this means the command failed. The output for this command
should be in the log above. Please read the output to determine what
went wrong.


Days              : 0
Hours             : 0
Minutes           : 5
Seconds           : 19
Milliseconds      : 808
Ticks             : 3198084004
TotalDays         : 0.00370148611574074
TotalHours        : 0.0888356667777778
TotalMinutes      : 5.33014000666667
TotalSeconds      : 319.8084004
TotalMilliseconds : 319808.4004
```
