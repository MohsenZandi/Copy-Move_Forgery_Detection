function norms=NormRow(matrix,dimension)
norms = sqrt(sum(matrix.^2,dimension));