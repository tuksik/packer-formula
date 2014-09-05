# vim: sts=2 ts=2 sw=2 et ai
{% set packer = pillar.get('packer', {}) %}
{% set packer_download = packer.get('download', {}) %}
{% set packer_download_url = packer_download.get('url', 
    'https://dl.bintray.com/mitchellh/packer/0.6.1_linux_amd64.zip') %}
# Use the SHA1 of the packer download to verify it's contents
{% set packer_download_hash = packer_download.get('hash', 
    '3a5ea4d5b8783b41e61737f3ca8b67e55ddacf9f') %}
{% set packer_version = packer.get('version', '0.6.1') %}

# Require the hash and the url to install packer
{% if packer_download_url and packer_download_hash and packer_version %}
# Extract packer into the directory
packer:
  archive:
    - extracted
    - name: /opt/packer-{{ packer_version }}
    - source: {{ packer_download_url }}
    - source_hash: {{ packer_download_hash }}
    - archive_format: zip

# Link to /usr/local/bin/packer
/usr/local/bin/packer:
  file.symlink:
    - target: /opt/packer-{{ packer_version }}
    - require:
      - archive: packer

# Ensure that packer is added to the environment
/etc/profile.d/packer-env.sh:
  file.managed:
    - contents: "export PATH=$PATH:/usr/local/bin/packer"
    - require:
      - archive: packer
{% endif %}
