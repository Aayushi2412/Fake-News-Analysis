---
title: "EDA J COMPONENT by AAYUSHI 20BCE1791"
author: "AAYUSHI 20BCE1791"
date: "24/02/2023"
output: html_notebook
---

```{r}
## Importing packages
library(tidyverse) # metapackage with lots of helpful functions
library(tidytext) # tidy implimentation of NLP methods
library(syuzhet)
# read in our data
news <- read_csv('C:\\Users\\meaay\\Desktop\\Sem6\\EDA_Lab\\fake.csv')

```
Counting the types of news to check how many are fake and how many are real

```{r}
news %>% group_by(type) %>% summarise(count=n())
```


```{r}
dim(news)
```

```{r}
#bs and conspiracy news are also fake
news$type<-gsub("bs","fake",news$type)                 
news$type<-gsub("conspiracy","fake",news$type)          
#while others are real
news$type<-gsub("bias","real",news$type)              
news$type<-gsub("satire","real",news$type)
news$type<-gsub("hate","real",news$type)
news$type<-gsub("junksci","real",news$type)
news$type<-gsub("state","real",news$type)

```

```{r}
#Count of type of news that how many are fake and real
news %>% group_by(type) %>% summarise(count=n())
```
```{r}
#apply function for finding question marks and exclamations and adding into our dataframe
news$exc <- sapply(news$text, function(x) length(unlist(strsplit(as.character(x), "\\!+")))) #count exclamation
news$que <- sapply(news$text, function(x) length(unlist(strsplit(as.character(x), "\\?+")))) #count question marks
```

```{r}
##Count of exclamations in fake and real news
news %>% group_by(type) %>% summarise(exclamations=sum(exc))
```
```{r}
#Count of question marks in fake and real news
news %>% group_by(type) %>% summarise(QuestionMarks=sum(que))
```
```{r}
#boxplot for exclamations in fake and real news
boxplot(exc ~ type,news,ylim=c(0,20),ylab="",col=c("red","orange"))
#we can observe that fake news have more exclamations than real news
```
```{r}
#boxplot for question marks in fake and real news
boxplot(que ~ type,news,ylim=c(0,20),col=c("red","orange")) 
#we can observe that fake news have more question marks than real
```
```{r}
#function for finding words in each text
terms<- function(fake, text_column, group_column){

  group_column <- enquo(group_column)
  text_column <- enquo(text_column)

  # get the count of each word in each review
  words <- news %>%
    unnest_tokens(word, !!text_column) %>%
    count(!!group_column, word) %>%
    ungroup()

  # get the number of words per text
  #total_words <- words %>%
    #group_by(!!group_column) %>%
    #summarize(total = sum(n))

  # combine the two dataframes we just made
  
  return (words)
}
```

```{r}
#store all words per text in different data frame
df<-terms(news,text,type)
```
```{r}
#create boxplot for number of words of each type
boxplot(n ~ type,df,log="y",xlab="type",ylab="number of words",col=c("green","pink"))
```


```{r}
#create sentiment table for text column
sentiment<-get_nrc_sentiment(news$text)
sentiment
```

```{r}
#taking only last two columns negative and positive for the analysis
df1<-sentiment[c(9,10)]
```

```{r}
#function for normalization
normalize <- function(x) {
    return ((x - min(x)) / (max(x) - min(x)))
  }
```

```{r}
#normalize negative and positive column for better analysis means the values will lie between 0 and 1
df1$negative<-normalize(df1$negative)
df1$positive<-normalize(df1$positive)
```

```{r}
#Combine this with the news dataset
news<-cbind(news,df1)
```


```{r}
#finding standard deviations and median of negative and positive columns for each type of news 
neg_sd<-news %>% group_by(type) %>% summarise(neg_sd=sd(negative))
pos_sd<-news %>% group_by(type) %>% summarise(pos_sd=sd(positive))
neg_med<-news %>% group_by(type) %>% summarise(neg_med=median(negative))
pos_med<-news %>% group_by(type) %>% summarise(pos_med=median(positive))
```

```{r}
#create dataframes for negative and positive standard deviations and median
dfr2<-data.frame(neg_sd)
dfr1<-data.frame(pos_sd)
dfr3<-data.frame(neg_med)
dfr4<-data.frame(pos_med)
```

```{r}
#merging dataframes and taking transpose of t1 we get t2
t1<-merge(dfr1,dfr2)
t2<-t(t1)
t2

```

```{r}
#merging dataframes and taking transpose of t4 we get t3
t3<-merge(dfr4,dfr3)
t4<-t(t3)
t4
```

