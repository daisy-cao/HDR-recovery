function newlE = rad_map(g,w, Z,B)
%printf('==== Recover HDR Image =====');


    [numRows_Z, numCols_Z, num] = size(Z);
    newlE = zeros(numRows_Z, numCols_Z); % Num of rows in Z is the number of pixels per image


    for i = 1 : numRows_Z
        for j = 1 : numCols_Z
            numerator = 0;
            denominator = 0;
            for n = 1 : num
            
                pixelVal = Z(i, j, n);
                weightedVal = w(pixelVal + 1);
        
                numerator = numerator + (weightedVal * (g(pixelVal+1) - B(n)));   
                denominator = denominator + weightedVal;
            end
            tmp = numerator/denominator;
            newlE(i, j) = exp(tmp);
        end   
    end   
    
end