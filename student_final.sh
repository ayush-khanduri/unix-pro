#STUDENT DATABASE MANAGEMENT PROJECT
#Project by Ayush Khanduri
k=0
valid_name()
{
case $1 in 
  ""|*[0-9]*)
        echo "Please enter student's name correctly."
        k=0
        ;;
  *)    k=1
        ;;
esac 
}
###############################################################
valid_batch()
{
pat="^[E-F][1-8]$"
if [[ ! $1 =~ $pat ]]
then
echo "Enter Batch like F5 or E2"
k=0
else
k=1
fi
}
###############################################################
add_rec()
{
clear
tput cup 8 50
echo "Enter enroll number of the student"
tput cup 9 50
read enum
pat="^[9][9][1][1-5][1][0][0-9]{4}$"
while [[ ! $enum =~ $pat ]]
do
tput cup 8 50
echo "Please enter enrollment number of the form 991[1-5]10XXXX"
tput el
tput cup 9 50
read enum
done

grep $enum st.lst
if [ $? -eq 0 ]
then 
clear
tput cup 38 60 
echo "Record for $enum already exits"
sleep 3
add_rec
return
fi 
enum+="|"

tput cup 11 50
echo "Enter First Name of the student"
tput cup 12 50
read sname
while true 
do
case $sname in 
  ""|*[0-9]*) tput cup 11 50
        echo "Please enter student's first name correctly."
        tput el
        tput cup 12 50
        read sname
        ;;
  *)
        break
        ;;
esac
done
sname+="|"

tput cup 13 50
echo "Enter Last Name of the student"
tput cup 14 50
read lname
while true
do
case $lname in 
  ""|*[0-9]*) tput cup 13 50
        echo "Please enter student's last name correctly."
        tput el
        tput cup 14 50
        read lname
        ;;
  *)
        break
        ;;
esac
done
lname+="|"

tput cup 16 50
echo "Enter Father's name"
tput cup 17 50
read fname
while true 
do
case $fname in 
  ""|*[0-9]*) 
  	tput cup 16 50
        echo "Please enter father's name correctly."
        tput el
        tput cup 17 50
        read fname
        ;;
  *)
        break
        ;;
esac
done
fname+="|"

tput cup 19 50
echo "Enter Date of Birth"
dob=`zenity --calendar`
tput cup 20 50 
echo $dob
#read dob
#awk -F "-" '$1<=31 && $2<=12 && $3>=1990 && $3<=2000' dob
#pat="^[1-3][0-9]-[0-1][0-9]-[1][9][9][0-9]$"
#while [[ ! $dob =~ $pat ]]
#do
#echo "Please enter dob in dd-mm-yyyy format"
#read dob
#done
dob+="|"

tput cup 22 50
echo "Enter Batch"
tput cup 23 50
read batch
pat="^[E-F][1-8]$"
while [[ ! $batch =~ $pat ]]
do
tput el
tput cup 22 50
echo "Enter Batch like F5 or E2"
tput el
tput cup 23 50
read batch
done
insert $enum $sname $lname $fname $dob $batch 
printf "New record entered into database" 
sleep 2
tput clear
tput cup 12 55
printf "Add more records?{y/n}"
read op
case "$op" in 
y|Y)   add_rec  ;;
*)     return  ;;
esac      
}
##############################################################
insert()
{
echo $* >> st.lst
touch st.lst

tput clear 
tput cup 12 55
sort -n st.lst > $$
cp $$ st.lst
rm $$
}
#################################################################
edit_rec()
{
clear
tput cup 4 40
echo "Enter the Enrollment number of the student to edit info"
tput cup 5 40
read enum
pat="^[9][9][1][[1-5][1][0][0-9]{4}$"
while [[ ! $enum =~ $pat ]]
do
tput cup 4 40
echo "Please enter enrollment number of the form 991[1-5]10XXXX"
tput el
tput cup 5 40
read enum
done
grep $enum st.lst>>temp.txt
if [ $? -eq 0 ]
then
printf "\n\n"
awk -F "|" -v var="$enum" ' $1~var { kount = kount +1
 printf "\t\t\t   | %10s | %-10s | %-10s | %-18s | %30s | %2s |\n",$1,$2,$3,$4,$5,$6  } ' st.lst 

tput cup 10 50 
echo "Choose Field to be edited"
tput cup 11 50 
printf "1.Student's First Name"
tput cup 12 50 
printf "2.Student's Last Name"
tput cup 13 50 
printf "3.Father's Name"
tput cup 14 50
printf "4.Date of Birth"
tput cup 15 50 
printf "5.Batch"
tput cup 16 50 
printf "6.Return to main menu"
tput cup 18 45
printf "P.S. enroll number cannot be edited\n"
tput cup 20 65
read op
tput cup 22 65
case "$op" in
1)    echo "New name:" 
      while true
      do
      tput el
      tput cup 23 65
      read nname
      k=0
      valid_name $nname
      if [ $k -eq 1 ]
      then
      break
      fi
      done
      t3=`grep $enum st.lst | cut -d "|" -f 3`
      t3+="|"
      t4=`grep $enum st.lst | cut -d "|" -f 4`
      t4+="|"
      t5=`grep $enum st.lst | cut -d "|" -f 5`
      t5+="|"
      t6=`grep $enum st.lst | cut -d "|" -f 6`
      grep -v "$enum" st.lst > $$
      cp $$ st.lst
      rm $$
      enum+="|"
      nname+="|"
      insert $enum $nname $t3 $t4 $t5 $t6
       
	clear
	tput cup 12 60
      printf "Your changes have been saved.." 
      sleep 3
      clear
      tput cup 14 60
      printf "Edit more records?{y/n}"
      read op
      case "$op" in 
      y|Y)   edit_rec  ;;
      *)     return  ;;
      esac      
 ;;
2)  echo "New Last name:" 
      while true
      do
      tput el
      tput cup 23 65
      read nname
      k=0
      valid_name $nname
      if [ $k -eq 1 ]
      then
      break
      fi
      done
      t2=`grep $enum st.lst | cut -d "|" -f 2`
      t2+="|"
      t4=`grep $enum st.lst | cut -d "|" -f 4`
      t4+="|"
      t5=`grep $enum st.lst | cut -d "|" -f 5`
      t5+="|"
      t6=`grep $enum st.lst | cut -d "|" -f 6`
      grep -v "$enum" st.lst > $$
      cp $$ st.lst
      rm $$
      enum+="|"
      nname+="|"
      insert $enum $t2 $nname $t4 $t5 $t6
      clear
      printf "\t\t\nYour changes have been saved.." 
      sleep 3
      clear
      printf "\n\n\n\t\t\tEdit more records?{y/n}"
      read op
      case "$op" in 
      y|Y)   edit_rec  ;;
      *)     return  ;;
      esac      
 ;;
3)    echo "New name:" 
      while true
      do
      tput cup 23 65
      read nname
      k=0
      valid_name $nname
      if [ $k -eq 1 ]
      then
      break
      fi
      done
      t3=`grep $enum st.lst | cut -d "|" -f 3`
      t3+="|"
      t2=`grep $enum st.lst | cut -d "|" -f 2`
      t2+="|"
      t5=`grep $enum st.lst | cut -d "|" -f 5`
      t5+="|"
      t6=`grep $enum st.lst | cut -d "|" -f 6`
      grep -v "$enum" st.lst > $$
      cp $$ st.lst
      rm $$
      enum+="|"
      nname+="|"
      insert $enum $t2 $t3 $nname $t5 $t6
      clear
      printf "\t\t\nYour changes have been saved.."
      sleep 3
      clear
      printf "\n\n\n\t\t\tEdit more records?{y/n}"
      read op
      case "$op" in 
      y|Y)   edit_rec  ;;
      *)     return  ;;
      esac      
;;
4)    echo "Enter dob dd-mm-yyyy"
      bir=`zenity --calendar`
      echo $bir
      #pat="^[1-3][0-9]-[0-1][0-9]-[1][9][9][0-9]$"
      #while [[ ! $bir =~ $pat ]]
      #do
      #echo "Please enter dob in yyyy<2000"
      #read bir
      #done
      t3=`grep $enum st.lst | cut -d "|" -f 3`
      t3+="|"
      t4=`grep $enum st.lst | cut -d "|" -f 4`
      t4+="|"
      t6=`grep $enum st.lst | cut -d "|" -f 6`
      t2=`grep $enum st.lst | cut -d "|" -f 2`
      t2+="|"
      grep -v "$enum" st.lst > $$
      cp $$ st.lst
      rm $$
      enum+="|"
      bir+="|"
      insert $enum $t2 $t3 $t4 $bir $t6
      clear
      printf "\t\t\nYour changes have been saved.."
      sleep 3
      clear
      printf "\n\n\n\t\t\tEdit more records?{y/n}"
      read op
      case "$op" in 
      y|Y)   edit_rec  ;;
      *)     return  ;;
      esac      
 ;;
5)    echo "Enter Batch"
      while true
      do
      tput cup 23 65
      read batch
      k=0
      valid_batch $batch
      if [ $k -eq 1 ]
      then
      break
      fi
      done
      t3=`grep $enum st.lst | cut -d "|" -f 3`
      t3+="|"
      t4=`grep $enum st.lst | cut -d "|" -f 4`
      t4+="|"
      t5=`grep $enum st.lst | cut -d "|" -f 5`
      t5+="|"
      t2=`grep $enum st.lst | cut -d "|" -f 2`
      t2+="|"
      grep -v "$enum" st.lst > $$
      cp $$ st.lst
      rm $$
      enum+="|"
      insert $enum $t2 $t3 $t4 $t5 $batch
      clear
      printf "\t\t\nYour changes have been saved.." 
      sleep 3  
      clear
      printf "\n\n\n\t\t\tEdit more records?{y/n}"
      read op
      case "$op" in 
      y|Y)   edit_rec  ;;
      *)     return  ;;
      esac      
 ;;
6)    clear ;;
*)    clear
printf "\n\n\n\t\t\tInvalid Option"
edit_rec
sleep 2 ;;
esac
else
echo "No record found for this enrollment number..."
sleep 3
clear
printf "\n\n\n\t\t\tTry again?{y/n}"
read op
case "$op" in 
y|Y)   edit_rec  ;;
*)     return  ;;
esac
fi
}
##############################################################
dlt_rec()
{
tput clear
tput cup 12 40
echo "Enter the Enrollment number of the student to delete info"
tput cup 13 40
read enum
pat="^[9][9][1][1-5][1][0][0-9]{4}$"
while [[ ! $enum =~ $pat ]]
do
tput cup 12 40
echo "Please enter enrollment number of the form 991[1-5]10XXXX"
tput el
tput cup 13 40
read enum
done
tput cup 15 40
grep $enum st.lst
if [ $? -eq 0 ]
then
grep -v "$enum" st.lst > $$
cp $$ st.lst
rm $$
touch st.lst
sleep 1
clear
tput cup 12 65
printf "Record successfully deleted"
sleep 3
clear
tput cup 12 65
printf "Delete more records?{y/n}"
read op
case "$op" in 
y|Y)   dlt_rec  ;;
*)   return  ;;
esac
else
tput cup 14 60
echo "No record found for this enrollment number..."
sleep 3
clear
tput cup 15 70
printf "Try again?{y/n}"
read op
case "$op" in 
y|Y)   dlt_rec  ;;
*)   return  ;;
esac
fi
}
############################################################
view_rec()
{
tput clear
tput cup 2 65
tput bold
tput rev
printf " 1  View all records "
tput cup 4 70
printf " 2  Search "
tput sgr0
tput cup 5 70

read op
tput cup 8 0
if [ $op -eq 1 ]
then 
    awk -F "|"  '{ printf "\t\t\t   | %2d|%10s |%10s%-10s |%-18s |%-30s |%2s |\n",NR,$1,$2,$3,$4,$5,$6 } ' st.lst
else
    search
fi
tput rev
tput cup 38 60
#printf "\n\n\n\t\t"
echo "Want to view more(y/n)?"
tput sgr0
read op
case "$op" in 
y|Y)   view_rec ;;
*)     return  ;;
esac
}
search()
{
tput clear
tput bold
tput rev
tput cup 2 65
printf " SEARCH "
tput cup 4 30
printf " 1  BY STUDENT'S NAME "
tput cup 4 60
printf " 2  BY ENROLLMENT NUMBER "
tput cup 4 90
printf " 3  BY BATCH "
tput cup 6 65
printf " 4  QUIT "
tput sgr0
tput cup 8 65
read op
case "$op" in
1)    echo "Enter the Name of the student"
    tput cup 10 65
    read name
   #printf "\n\n\n"
   tput cup 12 0
   awk -F "|" -v var="$name" ' $2~var { kount = kount +1
 printf "\t\t\t   | %2d|%10s |%-10s %-10s |%-18s |%-30s |%2s |\n",kount,$1,$2,$3,$4,$5,$6 } ' st.lst || echo "RECORD NOT FOUND!! "
 ;;
    #grep "$name" st.lst || echo "Record not found" ;;
2)    echo "Enter the Enrollment number of the student"
	tput cup 10 65
    read enum
#printf "\n\n\n"
 tput cup 12 0
   awk -F "|" -v var="$enum" ' $1~var { kount = kount +1
 printf "\t\t\t   | %2d|%10s |%-10s %-10s |%-18s |%-30s |%2s |\n",kount,$1,$2,$3,$4,$5,$6  } ' st.lst || echo "RECORD NOT FOUND!! ";;
    #grep "$enum" st.lst || echo "Record not found" ;;
3)    echo "Enter the Batch of the student"
    tput cup 10 65
    read batch
    
pat="[E-F][1-8]"
while [[ ! $batch =~ $pat ]]
do
echo "Enter Batch like F5 or E2"
tput cup 12 65
read batch
done
printf "\n\n\n"
	tput cup 12 0
   awk -F "|" -v var="$batch" ' $6~var { kount = kount +1
 printf "\t\t\t   | %2d|%10s |%-10s %-10s |%-18s |%-30s |%2s |\n",kount,$1,$2,$3,$4,$5,$6 }' st.lst || echo "RECORD NOT FOUND!! ";;
  #  grep "$name" st.lst || echo "Record not found"  ;;
4)    return ;;
*)    clear 
printf "\n\n\n\t\t\tInvalid Option" 
sleep 2 ;;
esac
}
############################################################
#main
while true
do
tput clear
tput cup 3 0
toilet -tf smmono9 -F gay -F border "  STUDENT DATABASE MANAGEMENT SYSTEM "

tput cup 13 68
tput bold
tput rev
tput setf 3
printf " 1  ADD RECORD "
#echo -e "\e[1;31m 1  ADD RECORD \e [ 0m"

tput cup 15 63
printf " 2 " 
#tput sgr0 
printf " EDIT STUDENT DETAILS "

tput cup 17 67
printf " 3 " 
#tput sgr0 
printf "DELETE RECORD "

tput cup 19 63
printf " 4 " 
#tput sgr0 
printf " VIEW STUDENT DETAILS "

tput cup 21 71	
printf " 5 " 
#tput sgr0 
printf " QUIT "
tput sgr0

#120196
tput civis
tput cup 23 75
#printf "enter your choice: "
read op 

case "$op" in
1)    add_rec ;;
2)    edit_rec ;;
3)    dlt_rec ;;
4)    view_rec ;;
5)    exit ;;
*)    tput cup 27 68
      printf "Invalid Option!" 
      sleep 1 ;;
      
esac
tput cnorm
done
