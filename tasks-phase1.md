1. Authors:

   ***your group nr***

   ***link to forked repo***
   
2. Follow all steps in README.md.

3. Analyze terraform code. Play with terraform plan, terraform graph to investigate different modules.

    ***describe one selected module and put the output of terraform graph for this module here***
   
5. Reach YARN UI - on what port?
   
   ***add your answer here***
   
6. Draw an architecture diagram (e.g. in draw.io) that includes:
    1. VPC topology with service assignment to subnets
    2. Description of the components of service accounts
    3. List of buckets for disposal
    4. Description of network communication (ports, why it is necessary to specify the host for the driver) of Apache Spark running from Vertex AI Workbech
  
    ***place diagram here***

7. Add costs by entering the expected consumption into Infracost

   ***place the expected consuption you entered here***

   ***place the screenshot from infracost output here***

8. Create a BigQuery dataset and an external table
    
    
    ***place the code and output here***
   
    ***why does ORC not require a table schema?***
  
9. Start an interactive session from Vertex AI workbench:

    ***place the screenshot of notebook here***
   
10. Find and correct the error in spark-job.py

    ***describe the cause and how to find the error***

11. Additional tasks using Terraform:

    1. Add support for arbitrary machine types and worker nodes for a Dataproc cluster and JupyterLab instance

    ***place link to the modified file and inserted terraform code***
    
    3. Add support for preemptible/spot instances in a Dataproc cluster

    ***place link to the modified file and inserted terraform code***
    
    3. Perform additional hardening of Jupyterlab environment, i.e. disable sudo access and enable secure boot
    
    ***place link to the modified file and inserted terraform code***

    4. (Optional) Get access to Apache Spark WebUI

    ***place link to the modified file and inserted terraform code***
