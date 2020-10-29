cd "$(dirname "$0")"

if [[ -e gentle ]]; then
    rm -rf gentle
fi

mkdir gentle
cp -R ../ext gentle/ext
cp -R ../www gentle/www
cp -R ../gentle gentle/gentle
cp ../align.py gentle/align.py
cp ../setup.py gentle/setup.py
cp ../serve.py gentle/serve.py
cp ../install_models.sh gentle/
cp ../install_language_model.sh gentle/

docker build --build-arg MAKE_NUM_THREADS --build-arg OPENBLAS_NUM_THREADS --build-arg OPENBLAS_COMMIT  -t gentle:latest .

