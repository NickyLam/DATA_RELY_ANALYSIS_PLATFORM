: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_pirs_o_ibs_eaccount_f
CreateDate: 20180529
FileName:   ${iel_data_path}/pirs_o_ibs_eaccount_${batch_date}_f.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select acseq
,cifseq
,bankseq
,acno
,bankactype
,associfseq
,acname
,currency
,crflag
,acpermit
,opendate
,closedate
,deptseq
,acalias
,acstate
,acpausestate
,pauseremark
,chargeflag
,acctclasscode
,acctclasslcy
,signchannel
,isgroupcif
,groupcifno
,opentellerseq
,opendeptseq
 from idl.pirs_o_ibs_eaccount where 1=1;" \
        field="|#|" record="0x0a"  \
        file="${iel_data_path}/pirs_o_ibs_eaccount_${batch_date}_f.dat" \
        charset=zhs16gbk
        safe=yes