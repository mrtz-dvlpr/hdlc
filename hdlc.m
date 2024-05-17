clc;
clear ;
close all;

binstre='011111100111010111011101010100110110110110101011101001010010010000101101010010010101111101010010100100101010100101000101001011111100111111001010010100011011101011101110101010101001100100100100011010110100101011010100101010100100111101010111101100001010010111111001111110011011010101110100100101101101000010010100111101011101110100110010010101010010100001111010100101110101001001010100101111110';

%paternt-->0x7E
pattern ='01111110';

%splite frame by 0x7E
indices = strfind(binstre, pattern);

num_frames = length(indices);
data=[];
counter=1;
faildframe =[];

for i = 1:2:num_frames 
   
    frame = binstre(indices(i) + 8:indices(i + 1) - 1);
    
    count = 0;
    
    j = 1; 
    
    while j <= length(frame) 
       
        if frame(j) == '1' 
            count = count + 1; 
        
        else
            if count >= 5
                frame(j) = [];
                j = j - 1;
            end

            count = 0;           
         end
        j = j + 1;
    end

    if strcmp(crc32(frame(1:end-31)),frame(end-31:end))
          data{counter}=frame(1:end-31);
    else 
          faildframe=[faildframe counter];
    end 
      counter=counter+1;
      
end

function crc = crc32(data) 

data=char(bin2dec(reshape(pad(data,ceil(length(data)/8)*8,'left','0'),8,[]).')).';

polynomial = uint32(hex2dec('EDB88320'));
 
     crc = uint32(hex2dec('FFFFFFFF'));
 
     for i = 1:length(data)
         crc = bitxor(crc, uint32(data(i)));
         for j = 1:8
             if bitand(crc, 1)
                 crc = bitxor(bitshift(crc, -1), polynomial);
             else
                 crc = bitshift(crc, -1);
             end
         end
     end
 
     crc = bitcmp(crc);
crc=dec2bin(crc);

end
