function grid = initNoiseLearning(grid, expt)

seed = input('Input random seed: ');
initNoiseTokens(20, seed, 100, 200, 200, 200);
makeScreeningNoiseSequence;