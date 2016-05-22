import os
from setuptools import setup, find_packages
from codecs import open
from os import path

location = path.abspath(path.dirname('SDS_project'))

# Get the long description from the README file
with open(path.join(location, 'README.md'), encoding='utf-8') as f:
    long_description = f.read()

setup(
      name='SDS_project',
      version='1.0.0',
      description='Python Spoken Dialogue System Project + Interpreter',
      long_description=long_description,
      url='https://github.com/hyung8758/SDS_project.git',
      author='Hyungwon Yang',
      author_email='hyung8758@gmail.com',
      license='EMCS labs',
      classifiers=[
                   'Development Status :: 3',
                   'Intended Audience :: Research and Study',
                   'Programming Language :: Python :: 3.5',
                   ],
      keywords=['Spoken Dialogue System','Automatic Speech Recognition',
               'Interpreting system'],
      packages=['main_process','sub_process'],
      install_requires=['SpeechRecognition','nltk','beautifulsoup4','langid',
                        'pyaudio','wave'],
      )

# Install megam for optimization
os.system('brew install megam')
# Erase directories.
os.system('rm -rf build dist SDS_project.egg-info')

# Notion
os.system('echo Please read README file before you test the scripts.')