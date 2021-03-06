scrapy-packages:
  pkg.installed:
    - names:
      - libffi-dev
    - require:
      - pkg: build-packages

crawler-repo:
  git.latest:
    - name: {{ pillar['crawler']['repo_url'] }}
    - rev: master
    - target: {{ pillar['crawler']['path'] }}
    - runas: {{ pillar['system']['user'] }}

crawler-requirements:
  pip.installed:
    - bin_env: {{ pillar['project']['virtualenv_path'] }}
    - requirements: {{ pillar['crawler']['path'] }}/requirements.txt
    - user: {{ pillar['system']['user'] }}
    - require:
      - git: crawler-repo
      - pkg: python-packages

crawler-settings:
  file.managed:
    - template: jinja
    - name: {{ pillar['crawler']['path'] }}/{{ pillar['crawler']['name'] }}/settings_prod.py
    - source: salt://scrapy/settings_prod.py
    - user: {{ pillar['system']['user'] }}
    - group: {{ pillar['system']['user'] }}
    - require:
      - git: crawler-repo
      - pip: crawler-requirements
