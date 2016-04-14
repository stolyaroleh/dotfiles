#!/usr/bin/python
import os
import subprocess
import sys


def resolve(path):
    path = os.path.expanduser(path)
    return os.path.abspath(path)


def exists(path):
    return os.path.exists(path)


def make_dir(path):
    path = resolve(path)
    print('Creating directory: {0}'.format(path))
    run('mkdir', ['-p'] + path)


class in_directory:
    def __init__(self, path):
        self.source_dir = os.getcwd()
        self.target_dir = resolve(path)
        if not exists(self.target_dir):
            print(self.target_dir + ' does not exist.')
            make_dir(self.target_dir)

    def __enter__(self):
        print('Entering ' + self.target_dir)
        os.chdir(self.target_dir)

    def __exit__(self, *args):
        print('Going back to ' + self.source_dir)
        os.chdir(self.source_dir)


def run(command, args=[]):
    return subprocess.call([command] + args)


def sudo_run(command, args):
    return run('sudo', [command] + args)


def install_packages(packages):
    print('Installing: ' + ', '.join(packages))
    sudo_run('apt-get', ['install'] + packages + ['--no-install-recommends'])


def install_python_packages(packages, python_executable='python', upgrade=True):
    args = ['-m', 'pip', 'install', '--user']
    if upgrade:
        args.append('--upgrade')

    print('Installing python packages: ' + ', '.join(packages))
    for package in packages:
        run(python_executable, args + [package])


def git_clone(repo, branch='master', single_branch=False, depth=None):
    args = ['clone', '--branch', branch]
    if single_branch:
        args.append('--single-branch')
    if depth:
        args += ['--depth', depth]

    print('Cloning {0}'.format(repo))
    return run('git', args + [repo])


if __name__ == '__main__':
    install_packages(['emacs',
                      'git',
                      'python-pip',
                      'python3-pip'])

    sudo_run('apt-get', ['autoremove'])

    # update pip
    install_python_packages(['pip'])
    install_python_packages(['pip'], python_executable='python3')

    install_python_packages(['anaconda-mode'])

    with in_directory('~/src/productivity'):
        git_clone('https://github.com/clvv/fasd.git')
        os.putenv('PREFIX', os.getenv('HOME'))
        run('make', ['install'])

    with in_directory('~/.fonts'):
        git_clone('https://github.com/adobe-fonts/source-code-pro.git', branch='release', single_branch=True)
        sudo_run('fc-cache', ['--force', '--verbose'])
