from setuptools import setup, find_packages
setup(
    name='MotorControlLib',
    version='0.0.8',
    license='Apache License 2.0',
    author='William Dove',
    author_email='williamtdove@gmail.com',
    description='A Motor Control Library for Python',
    long_description=open('README.md').read(),
    long_description_content_type="text/markdown",
    url='https://github.com/wDove1/Motor-Control-Python',
    packages=find_packages(include=['MotorControl']),
    #install_requires=['RPi.GPIO'],
    classifiers=["Programming language :: Python :: 3",
                 "License :: OSI Approved :: Apache License 2.0",
                 "Operating System :: OS Independent"],
    python_requires='>=3.7'
    
        )
