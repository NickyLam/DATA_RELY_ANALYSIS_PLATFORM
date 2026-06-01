: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idf_aml_mpcs_a60cfidcheck_i
CreateDate: 20180529
FileName:   ${iel_data_path}/aml_mpcs_a60cfidcheck.i.${batch_date}.dat
IF_mark:    i
Logs:
   zjj 2018-07-27 create template
' \
        query="select etl_dt
,trannbr
,trandate
,trantime
,trancode
,linkid
,bnakcode
,identype
,idennbr
,nationality
,cltname
,issueoffice
,photoname
,chkresult
,status
,srcseqno
,srcsysid
,tlrno
,brcno
,trndt
,chkrtp
,hostnbr
,hostdt
,mutrcd
,trnname
,tmip
,tmmac
,mobile
,tmtype
,formername
,gender
,birthday
,birthplace
,nativeplace
,edulevel
,marriage
,job
,engageaddr
,address
,checkchnl
,recordstat
,checkdept from idl.aml_mpcs_a60cfidcheck where etl_dt = to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/aml_mpcs_a60cfidcheck.i.${batch_date}.dat" \
        charset=utf8
        safe=yes