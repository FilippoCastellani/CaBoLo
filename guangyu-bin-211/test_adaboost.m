
%%
tmptree = templateTree('MaxNumSplits',55,'MergeLeaves','on');
Mdl = fitensemble(FT',label,'AdaBoostM2',40,tmptree,'KFold',100);
genError = kfoldLoss(Mdl,'Mode','Cumulative');
figure;plot(genError);
%%
tmptree = templateTree('MaxNumSplits',55,'MergeLeaves','on');
tree_adaboost = fitensemble(FT',label,'AdaBoostM2',20,tmptree);
save('tree_adaboost.mat','tree_adaboost');
class1 = predict(tree_adaboost,FT');
confusion_matrix(label',class1,1); 