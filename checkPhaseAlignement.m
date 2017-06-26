% % % FIGURE visualizing phase alignement % % %
figure
firstSamples = floor( Fe/110 );
plot(v2.sig([ 1:firstSamples ] + 20000));
hold on
plot(v1.sig([1:firstSamples] + 20000));
grid on
title('Visualizing phase alignement')
xlabel('Samples')
ylabel('Amplitude')
legend('vowel a','vowel i')


