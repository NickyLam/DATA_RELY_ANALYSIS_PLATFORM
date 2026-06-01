: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_cbrc_business_applicant_f
CreateDate: 20180529
FileName:   ${iel_data_path}/cbrc_business_applicant_${batch_date}_f.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select objecttype
,objectno
,serialno
,applicantid
,applicantname
,rightprop
,debtprop
,inputorgid
,inputuserid
,inputdate
,updatedate
,remark
,applicanttype
,status
,otherrelationship
,incomedebtflag
,relationship from idl.cbrc_business_applicant where etl_dt =to_date('${batch_date}','yyyymmdd');" \
        field="|#|" record="0x0a"  \
        file="${iel_data_path}/cbrc_business_applicant_${batch_date}_f.dat" \
        charset=zhs16gbk
        safe=yes