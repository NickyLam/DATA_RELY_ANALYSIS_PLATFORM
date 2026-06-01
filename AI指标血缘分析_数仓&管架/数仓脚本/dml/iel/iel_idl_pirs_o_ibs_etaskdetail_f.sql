: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_pirs_o_ibs_etaskdetail_f
CreateDate: 20180529
FileName:   ${iel_data_path}/pirs_o_ibs_etaskdetail_${batch_date}_f.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select jnlno
,transcode
,payeracno
,payeracname
,payerdeptid
,payerbankactype
,currency
,payeeacno
,payeeacname
,payeebankactype
,amount
,remark
,fee
,executeday
,isnormal
,hold_fund_id
,txn_narrative
,release_ref_nbr
,valuedate
,intrate
,crflag
,payeecurrency
,payeebankid
,payeebankname
,provincecode
,provincename
,citycode
,cityname
,bankcode
,lname
,dreccode
,payeemobile
,payeesms
,notecode
,finalfee
,discount
,trspassword
,notifypayeeflag
,savepayeeflag
,payeeciftype
,groundflag
,validatemsg
,discountrate
,parentfee
 from idl.pirs_o_ibs_etaskdetail where 1=1;" \
        field="|#|" record="0x0a"  \
        file="${iel_data_path}/pirs_o_ibs_etaskdetail_${batch_date}_f.dat" \
        charset=zhs16gbk
        safe=yes