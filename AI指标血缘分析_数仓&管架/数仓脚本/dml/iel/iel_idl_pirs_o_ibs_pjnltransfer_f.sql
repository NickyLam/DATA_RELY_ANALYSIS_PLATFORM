: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_pirs_o_ibs_pjnltransfer_f
CreateDate: 20180529
FileName:   ${iel_data_path}/pirs_o_ibs_pjnltransfer_${batch_date}_f.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select jnlno
,transcode
,acseq
,payeracno
,payeracname
,payerdeptid
,currency
,crflag
,payeeciftype
,payeeacno
,payeeacname
,savepayeeflag
,notifypayeeflag
,payeemobile
,payeebankid
,provincecode
,citycode
,uniondeptid
,uniondeptname
,amount
,fee
,groundflag
,notecode
,remark
,priority
,bankcode
,ciftype
,innertransferflag
,isfast
,difcity
,exchangerate
,tocnybalance
,discountrate
,parentfee
,sysflag
 from idl.pirs_o_ibs_pjnltransfer where 1=1;" \
        field="|#|" record="0x0a"  \
        file="${iel_data_path}/pirs_o_ibs_pjnltransfer_${batch_date}_f.dat" \
        charset=zhs16gbk
        safe=yes