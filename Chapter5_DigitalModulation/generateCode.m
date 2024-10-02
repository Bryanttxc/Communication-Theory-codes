function generateCode(codeLen)

% uniformly generate
while 1
    b = randi([0 1],1,codeLen);
    if length(find(b == 0)) == length(find(b == 1))
        break;
    end
end
save("binarySequence","b");

end