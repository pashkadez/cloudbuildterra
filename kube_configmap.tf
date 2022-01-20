# resource "kubernetes_config_map" "credentials" {
#     metadata {
#     namespace = "jenkins"
#     name = "credentials"
#     }
#   data = {
#     "credentials.xml" = "${local.credentials}",
#     }
#     depends_on = [
#         local.credentials,
#         helm_release.jenkins
#     ]
# } 

# locals {
#     credentials = <<-EOF
# <?xml version='1.1' encoding='UTF-8'?>
# <com.cloudbees.plugins.credentials.SystemCredentialsProvider plugin="credentials@1074.v60e6c29b_b_44b_">
#   <domainCredentialsMap class="hudson.util.CopyOnWriteMap$Hash">
#     <entry>
#       <com.cloudbees.plugins.credentials.domains.Domain>
#         <specifications/>
#       </com.cloudbees.plugins.credentials.domains.Domain>
#       <java.util.concurrent.CopyOnWriteArrayList>
#         <com.google.jenkins.plugins.credentials.oauth.GoogleRobotMetadataCredentials plugin="google-oauth-plugin@1.0.6">
#           <module class="com.google.jenkins.plugins.credentials.oauth.GoogleRobotMetadataCredentialsModule"/>
#           <projectId>${var.project}</projectId>
#         </com.google.jenkins.plugins.credentials.oauth.GoogleRobotMetadataCredentials>
#       </java.util.concurrent.CopyOnWriteArrayList>
#     </entry>
#   </domainCredentialsMap>
# </com.cloudbees.plugins.credentials.SystemCredentialsProvider>jenkins@jenkins-0:~$
# EOF

# }