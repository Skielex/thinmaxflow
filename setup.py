from setuptools import Extension, setup

with open("README.md", "r") as fh:
    long_description = fh.read()


class LazyCythonize(list):
    def __init__(self, callback):
        self._list, self.callback = None, callback

    def c_list(self):
        if self._list is None:
            self._list = self.callback()
        return self._list

    def __iter__(self):
        for e in self.c_list():
            yield e

    def __getitem__(self, ii):
        return self.c_list()[ii]

    def __len__(self):
        return len(self.c_list())


def extensions():
    from Cython.Build import cythonize

    maxflow_module = Extension(
        "thinmaxflow._maxflow",
        [
            "thinmaxflow/src/_maxflow.pyx",
            "thinmaxflow/src/core/maxflow.cpp",
            "thinmaxflow/src/core/graph.cpp",
        ],
        language="c++",
    )
    return cythonize([maxflow_module])


setup(
    name="thinmaxflow",
    version="0.1.6",
    author="Niels Jeppesen",
    author_email="niejep@dtu.dk",
    description="A thin Maxflow wrapper for Python",
    long_description=long_description,
    long_description_content_type="text/markdown",
    url="https://github.com/Skielex/thinmaxflow",
    packages=["thinmaxflow"],
    classifiers=[
        "Development Status :: 3 - Alpha",
        "Environment :: Console",
        "Intended Audience :: Developers",
        "Intended Audience :: Science/Research",
        "License :: OSI Approved :: GNU General Public License v3 (GPLv3)",
        "Natural Language :: English",
        "Operating System :: OS Independent",
        "Programming Language :: C++",
        "Programming Language :: Python",
        "Topic :: Scientific/Engineering :: Image Recognition",
        "Topic :: Scientific/Engineering :: Artificial Intelligence",
        "Topic :: Scientific/Engineering :: Mathematics",
    ],
    ext_modules=LazyCythonize(extensions),
    setup_requires=["Cython"],
)
