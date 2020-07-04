
docker_build('frontend-angular', '.')
k8s_yaml('serve.yaml')
k8s_resource('frontend-angular', port_forwards=4200)