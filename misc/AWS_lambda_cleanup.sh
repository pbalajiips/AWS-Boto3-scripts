#!/bin/bash
while read lambda_name
do 
   lambda_info=$(aws lambda get-function --function-name $lambda_name  2>/dev/null)
   if [ $? == 0 ]
   then 
      cloudformation_stack_name=$(echo $lambda_info | jq '.Tags."aws:cloudformation:stack-name"'|cut -d'"' -f 2)
   else
      echo "Function $lambda_name Not found"
      continue
   fi

   if [ $cloudformation_stack_name == null ]
   then
       lambda_arn=$(echo $lambda_info | jq  '.Configuration.FunctionArn' | cut -d'"' -f 2);
       echo "Deleting lambda $lambda_name directly";
       aws lambda   delete-function --function-name $lambda_arn;
       if [ $? == 0 ]
       then 
           echo "Successfully deleted Lambda: $lambda_name"
       else
           echo "Error on deleting Lambda: $lambda_name"
       fi
    else
       echo "Deleting lambda $lambda_name via $cloudformation_stack_name stack";
       aws cloudformation delete-stack --stack-name $cloudformation_stack_name;
       if [ $? == 0 ]
       then 
           echo "Successfully deleted  Stack: $cloudformation_stack_name"
       else
           echo "Error on deleting Stack:  $cloudformation_stack_name"
       fi
    fi
done < lambda_name.txt