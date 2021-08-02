import pandas as pd
import numpy as np
from scipy import io
from sklearn.model_selection import train_test_split
from sklearn.preprocessing import StandardScaler
from sklearn.svm import LinearSVC
from sklearn.metrics import classification_report
from sklearn.metrics import confusion_matrix
import seaborn as sns
import matplotlib.pyplot as plt

allCsp_EOGno_EEG_MI_10s = np.load(r'Your DataDir')
allCspLabel_EOGno_EEG_MI_10s = np.load(r'Your LabelDir')
allCsp_EOGno_EEG_MI_10s = np.transpose(allCsp_EOGno_EEG_MI_10s, (1, 0))
allCspLabel_EOGno_EEG_MI_10s = np.transpose(allCspLabel_EOGno_EEG_MI_10s, (1, 0))

x_train, x_test, y_train, y_test = train_test_split(
    allCsp_EOGno_EEG_MI_10s, allCspLabel_EOGno_EEG_MI_10s, test_size=0.25, random_state=5)

ss = StandardScaler()
x_train = ss.fit_transform(x_train)
x_test = ss.fit_transform(x_test)
linSvc = LinearSVC()

linSvc.fit(x_train, y_train)
y_predict = linSvc.predict(x_test)
print('The Accuracy of Linear SVC is', linSvc.score(x_test, y_test))
print('precision&recall&f1-score of Linear SVC:', '\n',
      classification_report(y_test, y_predict,
                            target_names=['左', '右']))

cmSVC = pd.DataFrame(confusion_matrix(y_test, y_predict),
                     index=['左', '右'],
                     columns=['左', '右'])
print('SVM混淆矩阵：', '\n', cmSVC)
sns.set()
plt.figure(1)
sns.heatmap(cmSVC, annot=True, fmt="d",
            xticklabels=['left', 'right'],
            yticklabels=['left', 'right'])
plt.xlabel('predict'), plt.ylabel('true'), plt.title('LinearSVC Model')
plt.show()