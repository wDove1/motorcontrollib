from setuptools import setup, find_packages
from Cython.Build import cythonize
setup(
    ext_modules = cythonize("motorcontrollib/Motors.pyx",annotate=True),
    name='motorcontrollib',
    version='0.1.7',
    license='Apache License 2.0',
    author='William Dove',
    author_email='williamtdove@gmail.com',
    description='A Motor Control Library for Python',
    long_description=open('README.md').read(),
    long_description_content_type="text/markdown",
    url='https://github.com/wDove1/motorcontrollib',
    packages=find_packages(include=['motorcontrollib']),
    #install_requires=['RPi.GPIO'],
    classifiers=["Programming Language :: Python :: 3",
                 "License :: OSI Approved :: Apache Software License",
                 "Operating System :: OS Independent"],
    python_requires='>=3.7'
    
        )
