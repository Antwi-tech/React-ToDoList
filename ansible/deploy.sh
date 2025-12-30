---
- name: Deploy React ToDoList App
  hosts: my_servers
  become: yes
  tasks:
    - name: Update APT packages
      apt:
        update_cache: yes

    - name: Install Docker
      apt:
        name: docker.io
        state: present

    - name: Install Docker Compose
      apt:
        name: docker-compose
        state: present

    - name: Pull backend image
      docker_image:
        name: "{{ docker_username }}/ci_backend_full_pipeline"
        tag: v1
        source: pull

    - name: Pull frontend image
      docker_image:
        name: "{{ docker_username }}/ci_frontend_full_pipeline"
        tag: v1
        source: pull

    - name: Run backend container
      docker_container:
        name: backend
        image: "{{ docker_username }}/ci_backend_full_pipeline:v1"
        state: started
        restart_policy: always

    - name: Run frontend container
      docker_container:
        name: frontend
        image: "{{ docker_username }}/ci_frontend_full_pipeline:v1"
        state: started
        restart_policy: always
