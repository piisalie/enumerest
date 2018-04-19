# install erlang/elixir/deps
sudo apt-get update
sudo apt-get dist-upgrade -y
sudo apt-get install build-essential -y

wget https://packages.erlang-solutions.com/erlang-solutions_1.0_all.deb && sudo dpkg -i erlang-solutions_1.0_all.deb
sudo apt-get update
sudo apt-get install esl-erlang -y
sudo apt-get install elixir -y

mix local.hex --force
mix local.rebar --force
