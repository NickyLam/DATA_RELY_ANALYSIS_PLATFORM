: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idf_aml_mpcs_cpmtinst_f
CreateDate: 20180529
FileName:   ${iel_data_path}/aml_mpcs_cpmtinst.f.${batch_date}.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select etl_dt
,instno
,upinstno
,instlvl
,instname
,instabrname
,instaddr
,instenname
,instenabrname
,instenaddr
,insttel
,instemail
,insttype
,centflag
,seqnoprefix
,acctinstlvl
,upacctinst
,bankno
,citycd
,isleaf
,rowstat
,upddt
,updtm from idl.aml_mpcs_cpmtinst where etl_dt = to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/aml_mpcs_cpmtinst.f.${batch_date}.dat" \
        charset=utf8
        safe=yes