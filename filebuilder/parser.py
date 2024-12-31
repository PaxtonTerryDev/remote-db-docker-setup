import os
import yaml
import logging
from structures import Database, Target, Schema, Source, Config

logging.basicConfig(level=logging.DEBUG)

class ConfigParser:
    def __init__(self, file_name='db-config.yaml'):
        self.file_name = file_name
        self.config = self._parse_config()

    def _get_config_file_path(self):
        parent_dir = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
        filepath = os.path.join(parent_dir, 'configs', self.file_name)
        return filepath

    def _parse_config(self) -> Config:
        filepath = self._get_config_file_path()
        with open(filepath, 'r') as file:
            raw_config = yaml.safe_load(file)
        return Config(**raw_config)

