IMPORTANT ❗ ❗ ❗ Please remember to destroy all the resources after each work session. You can recreate infrastructure by creating new PR and merging it to master.

![img.png](doc/figures/destroy.png)

1. Authors:
   17
   https://github.com/utlik/tbd-workshop-1
2. Follow all steps in README.md.
3. From avaialble Github Actions select and run destroy on main branch.
4. Create new git branch and:
    1. Modify tasks-phase1.md file.
    2. Create PR from this branch to **YOUR** master and merge it to make new release. 
    ***place the screenshot from GA after succesfull application of release***

5. Analyze terraform code. Play with terraform plan, terraform graph to investigate different modules.

Moduł VPC to gotowy do użycia blok kodu Terraform, który automatyzuje tworzenie i zarządzanie wirtualnymi chmurami prywatnymi (VPC). 
Moduł upraszcza proces tworzenia infrastruktury sieciowej, w tym podsieci, reguły firewalla, routing i td. 
Umożliwia ponowne wykorzystanie konfiguracji i zarządzanie całą siecią jako pojedynczym komponentem.

Moduł VPC w naszym projekcie to moduł lokalny ./modules/vpc. Odpowiada za tworzenie i konfigurowanie prywatnej sieci chmurowej (VPC) w Google Cloud Platform (GCP).

$ terraform graph | grep ">" | grep "vpc"
  "google_compute_firewall.allow-all-internal" -> "module.vpc.module.vpc.module.vpc.google_compute_shared_vpc_host_project.shared_vpc_host";
  "module.composer.google_compute_subnetwork.composer-subnet" -> "module.vpc.google_compute_firewall.default-internal-allow-all";
  "module.composer.google_compute_subnetwork.composer-subnet" -> "module.vpc.google_compute_firewall.fw-allow-ingress-from-iap";
  "module.composer.google_compute_subnetwork.composer-subnet" -> "module.vpc.module.cloud-router.google_compute_router_nat.nats";
  "module.composer.google_compute_subnetwork.composer-subnet" -> "module.vpc.module.vpc.module.firewall_rules.google_compute_firewall.rules";
  "module.composer.google_compute_subnetwork.composer-subnet" -> "module.vpc.module.vpc.module.firewall_rules.google_compute_firewall.rules_ingress_egress";
  "module.composer.google_compute_subnetwork.composer-subnet" -> "module.vpc.module.vpc.module.routes.google_compute_route.route";
  "module.composer.google_compute_subnetwork.composer-subnet" -> "module.vpc.module.vpc.module.vpc.google_compute_shared_vpc_host_project.shared_vpc_host";
  "module.composer.google_project_service.api" -> "module.vpc.google_compute_firewall.default-internal-allow-all";
  "module.composer.google_project_service.api" -> "module.vpc.google_compute_firewall.fw-allow-ingress-from-iap";
  "module.composer.google_project_service.api" -> "module.vpc.module.cloud-router.google_compute_router_nat.nats";
  "module.composer.google_project_service.api" -> "module.vpc.module.vpc.module.firewall_rules.google_compute_firewall.rules";
  "module.composer.google_project_service.api" -> "module.vpc.module.vpc.module.firewall_rules.google_compute_firewall.rules_ingress_egress";
  "module.composer.google_project_service.api" -> "module.vpc.module.vpc.module.routes.google_compute_route.route";
  "module.composer.google_project_service.api" -> "module.vpc.module.vpc.module.vpc.google_compute_shared_vpc_host_project.shared_vpc_host";
  "module.composer.google_service_account.tbd-composer-sa" -> "module.vpc.google_compute_firewall.default-internal-allow-all";
  "module.composer.google_service_account.tbd-composer-sa" -> "module.vpc.google_compute_firewall.fw-allow-ingress-from-iap";
  "module.composer.google_service_account.tbd-composer-sa" -> "module.vpc.module.cloud-router.google_compute_router_nat.nats";
  "module.composer.google_service_account.tbd-composer-sa" -> "module.vpc.module.vpc.module.firewall_rules.google_compute_firewall.rules";
  "module.composer.google_service_account.tbd-composer-sa" -> "module.vpc.module.vpc.module.firewall_rules.google_compute_firewall.rules_ingress_egress";
  "module.composer.google_service_account.tbd-composer-sa" -> "module.vpc.module.vpc.module.routes.google_compute_route.route";
  "module.composer.google_service_account.tbd-composer-sa" -> "module.vpc.module.vpc.module.vpc.google_compute_shared_vpc_host_project.shared_vpc_host";
  "module.dataproc.google_project_service.dataproc" -> "module.vpc.google_compute_firewall.default-internal-allow-all";
  "module.dataproc.google_project_service.dataproc" -> "module.vpc.google_compute_firewall.fw-allow-ingress-from-iap";
  "module.dataproc.google_project_service.dataproc" -> "module.vpc.module.cloud-router.google_compute_router_nat.nats";
  "module.dataproc.google_project_service.dataproc" -> "module.vpc.module.vpc.module.firewall_rules.google_compute_firewall.rules";
  "module.dataproc.google_project_service.dataproc" -> "module.vpc.module.vpc.module.firewall_rules.google_compute_firewall.rules_ingress_egress";
  "module.dataproc.google_project_service.dataproc" -> "module.vpc.module.vpc.module.routes.google_compute_route.route";
  "module.dataproc.google_project_service.dataproc" -> "module.vpc.module.vpc.module.vpc.google_compute_shared_vpc_host_project.shared_vpc_host";
  "module.dataproc.google_service_account.dataproc_sa" -> "module.vpc.google_compute_firewall.default-internal-allow-all";
  "module.dataproc.google_service_account.dataproc_sa" -> "module.vpc.google_compute_firewall.fw-allow-ingress-from-iap";
  "module.dataproc.google_service_account.dataproc_sa" -> "module.vpc.module.cloud-router.google_compute_router_nat.nats";
  "module.dataproc.google_service_account.dataproc_sa" -> "module.vpc.module.vpc.module.firewall_rules.google_compute_firewall.rules";
  "module.dataproc.google_service_account.dataproc_sa" -> "module.vpc.module.vpc.module.firewall_rules.google_compute_firewall.rules_ingress_egress";
  "module.dataproc.google_service_account.dataproc_sa" -> "module.vpc.module.vpc.module.routes.google_compute_route.route";
  "module.dataproc.google_service_account.dataproc_sa" -> "module.vpc.module.vpc.module.vpc.google_compute_shared_vpc_host_project.shared_vpc_host";
  "module.dataproc.google_storage_bucket.dataproc_staging" -> "module.vpc.google_compute_firewall.default-internal-allow-all";
  "module.dataproc.google_storage_bucket.dataproc_staging" -> "module.vpc.google_compute_firewall.fw-allow-ingress-from-iap";
  "module.dataproc.google_storage_bucket.dataproc_staging" -> "module.vpc.module.cloud-router.google_compute_router_nat.nats";
  "module.dataproc.google_storage_bucket.dataproc_staging" -> "module.vpc.module.vpc.module.firewall_rules.google_compute_firewall.rules";
  "module.dataproc.google_storage_bucket.dataproc_staging" -> "module.vpc.module.vpc.module.firewall_rules.google_compute_firewall.rules_ingress_egress";
  "module.dataproc.google_storage_bucket.dataproc_staging" -> "module.vpc.module.vpc.module.routes.google_compute_route.route";
  "module.dataproc.google_storage_bucket.dataproc_staging" -> "module.vpc.module.vpc.module.vpc.google_compute_shared_vpc_host_project.shared_vpc_host";
  "module.dataproc.google_storage_bucket.dataproc_temp" -> "module.vpc.google_compute_firewall.default-internal-allow-all";
  "module.dataproc.google_storage_bucket.dataproc_temp" -> "module.vpc.google_compute_firewall.fw-allow-ingress-from-iap";
  "module.dataproc.google_storage_bucket.dataproc_temp" -> "module.vpc.module.cloud-router.google_compute_router_nat.nats";
  "module.dataproc.google_storage_bucket.dataproc_temp" -> "module.vpc.module.vpc.module.firewall_rules.google_compute_firewall.rules";
  "module.dataproc.google_storage_bucket.dataproc_temp" -> "module.vpc.module.vpc.module.firewall_rules.google_compute_firewall.rules_ingress_egress";
  "module.dataproc.google_storage_bucket.dataproc_temp" -> "module.vpc.module.vpc.module.routes.google_compute_route.route";
  "module.dataproc.google_storage_bucket.dataproc_temp" -> "module.vpc.module.vpc.module.vpc.google_compute_shared_vpc_host_project.shared_vpc_host";
  "module.vpc.google_compute_firewall.default-internal-allow-all" -> "module.vpc.module.vpc.module.vpc.google_compute_network.network";
  "module.vpc.google_compute_firewall.fw-allow-ingress-from-iap" -> "module.vpc.module.vpc.module.vpc.google_compute_network.network";
  "module.vpc.module.cloud-router.google_compute_router.router" -> "module.vpc.module.vpc.module.vpc.google_compute_network.network";
  "module.vpc.module.cloud-router.google_compute_router_nat.nats" -> "module.vpc.module.cloud-router.google_compute_router.router";
  "module.vpc.module.vpc.module.firewall_rules.google_compute_firewall.rules" -> "module.vpc.module.vpc.module.vpc.google_compute_network.network";
  "module.vpc.module.vpc.module.firewall_rules.google_compute_firewall.rules_ingress_egress" -> "module.vpc.module.vpc.module.vpc.google_compute_network.network";
  "module.vpc.module.vpc.module.routes.google_compute_route.route" -> "module.vpc.module.vpc.module.subnets.google_compute_subnetwork.subnetwork";
  "module.vpc.module.vpc.module.subnets.google_compute_subnetwork.subnetwork" -> "module.vpc.module.vpc.module.vpc.google_compute_network.network";
  "module.vpc.module.vpc.module.vpc.google_compute_shared_vpc_host_project.shared_vpc_host" -> "module.vpc.module.vpc.module.vpc.google_compute_network.network";


	Powyższy graf zależności pokazuje kluczową rolę modułu VPC:

	1. Prawie wszystkie moduły infrastruktury wysokiego poziomu zależą od zasobów tworzonych przez moduł VPC. Oznacza to, że sieć VPC musi zostać najpierw utworzona i skonfigurowana, 
	zanim będzie można wdrożyć jakiekolwiek usługi.

	2.Moduły Composer i DataProc mają największą liczbę bezpośrednich zależności od sieci VPC. 

	Modułu module.composer i module.dataproc nie można skonfigurować, dopóki nie zostaną skonfigurowane:
	Reguły zapory sieciowej google_compute_firewall oraz routery module.cloud-router.google_compute_router_nat.nats oraz sieć google_compute_network.network.

	3. Na końcu widać, że komponenty samej sieci VPC są od siebie zależne (na przykład module.vpc.module.cloud-router.router zależy od module.vpc.module.vpc.module.vpc.google_compute_network.network). 
	Nie można utworzyć NAT, dopóki sieć nie zostanie utworzona.

	Moduł VPC stanowi warstwę bazową całej architektury, zapewniającą niezbędną izolację sieciową i łączność dla usług danych w chmurze.
	
	
6. Reach YARN UI
   
   ***place the command you used for setting up the tunnel, the port and the screenshot of YARN UI here***
   
7. Draw an architecture diagram (e.g. in draw.io) that includes:
    1. Description of the components of service accounts
    2. List of buckets for disposal
    
    ***place your diagram here***

8. Create a new PR and add costs by entering the expected consumption into Infracost
For all the resources of type: `google_artifact_registry`, `google_storage_bucket`, `google_service_networking_connection`
create a sample usage profiles and add it to the Infracost task in CI/CD pipeline. Usage file [example](https://github.com/infracost/infracost/blob/master/infracost-usage-example.yml) 

   ***place the expected consumption you entered here***

   ***place the screenshot from infracost output here***

9. Create a BigQuery dataset and an external table using SQL
    
    ***place the code and output here***
   
    ***why does ORC not require a table schema?***

10. Find and correct the error in spark-job.py

    ***describe the cause and how to find the error***

11. Add support for preemptible/spot instances in a Dataproc cluster

    ***place the link to the modified file and inserted terraform code***
    
12. Triggered Terraform Destroy on Schedule or After PR Merge. Goal: make sure we never forget to clean up resources and burn money.

Add a new GitHub Actions workflow that:
  1. runs terraform destroy -auto-approve
  2. triggers automatically:
   
   a) on a fixed schedule (e.g. every day at 20:00 UTC)
   
   b) when a PR is merged to main containing [CLEANUP] tag in title

Steps:
  1. Create file .github/workflows/auto-destroy.yml
  2. Configure it to authenticate and destroy Terraform resources
  3. Test the trigger (schedule or cleanup-tagged PR)
     
***paste workflow YAML here***

***paste screenshot/log snippet confirming the auto-destroy ran***

***write one sentence why scheduling cleanup helps in this workshop***
