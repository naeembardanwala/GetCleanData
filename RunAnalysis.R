library("reshape2")
dsTestTrain <- rbind(read.table("./data/test/X_test.txt",header=F),read.table("./data/train/X_train.txt",header=F))
dsFeaturs <- read.table("./data/features.txt")
names(dsTestTrain) <- dsFeaturs[,2]
allColNames <- colnames(dsTestTrain)
selectedDS <- dsTestTrain[,allColNames[grepl(".*mean\\(\\)|.*std\\(\\)", allColNames)]]
colnm <- colnames(selectedDS)
colnm <- gsub('\\(|\\)',"", colnm)
colnm <- gsub('mean', colnm, replacement="Mean")
colnm <- gsub('std', colnm, replacement="STD")
colnames(selectedDS) <- colnm
x <- rbind(read.table("./data/test/y_test.txt", header=F),read.table("./data/train/y_train.txt", header=F)) 
selectedDS$Activity <- x$V1
activityNames <-  read.table("./data/activity_labels.txt", header=FALSE, col.names=c("Activity", "ActivityName"))
selectedDS <- merge(selectedDS,activityNames)
x <- rbind(read.table("./data/test/subject_test.txt", header=F),read.table("./data/train/subject_train.txt", header=F))
selectedDS$Subject <- x$V1
grps  <- c("Activity", "Subject")
dataMelt  <- melt(selectedDS, id=grps, measure.var=setdiff(colnames(selectedDS), grps))
final_data <- dcast(dataMelt, Activity + Subject ~ variable, mean)
write.table(final_data, "finalActivity.txt")
