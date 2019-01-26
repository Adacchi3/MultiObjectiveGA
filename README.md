# Multi-Objective Genetic Algorithm for the Dating Simulation Game
## Overview 
Multi-objective optimization is an area of multiple criteria decision making that is concerned with mathematical optimization problems involving more than one objective function to be optimized simultaneously[[ref](https://en.wikipedia.org/wiki/Multi-objective_optimization)]. Also, genetic algorithms are used to generate high-quality solutions to optimization and search problems by relying on bio-inspired operators[[ref](https://en.wikipedia.org/wiki/Genetic_algorithm)].

This project uses the dating simulation game like [the famous games](https://www.konami.com/games/tokimeki/4/). My implementing game has some characters and players try to increase love meters of each character. Love meters would be calculated based on the players' parameters such as health, humanity, science, sport and art. The player allows the parameters to increase by doing some action in the day. It is different for each character to evaulate the love meter.

In this project, the player's actions represent genes, that size is 30 as one month. Although the player would like to increase love meters of each character, we want to find various actions to maximum the love meter of the specific character. This project addresses this problem using multi-objective genetic algorithm[[ref](https://ieeexplore.ieee.org/document/996017)].

### Running
` $ruby main.rb `

## Memo (in Japanese)
[rubocop](https://docs.rubocop.org/en/latest/)を導入し，実装を行った．
ymlファイルに設定を記述することで，それに合わせてフォーマットをチェックをしてくれるようだ．
今回は何も指定せずにフォーマットをチェックしてもらい，auto-correctで自動修正してもらった．自動修正で2箇所ほどバグが発生したが，なんとか解決した．コードを記述する際には，どのようなフォーマットで記述することが望ましいのか(チェックされる事柄)を把握することが大切なのだと思った．
