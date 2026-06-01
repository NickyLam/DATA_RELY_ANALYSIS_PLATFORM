: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_aml_isbs_wfe_f
CreateDate: 20180529
FileName:   ${iel_data_path}/aml_isbs_wfe.f.${batch_date}.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select etl_dt
,wfsinr
,wfssub
,srv
,sta
,rtycnt
,tardattim
,ssninr
,dattim
,txt
,manflg
,opndur
,waidur
,retdur
,hdldur
,bchkeyinr
,txt2
,itfinr
,coreinr
,czinr
,itfdate from idl.aml_isbs_wfe where etl_dt = to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/aml_isbs_wfe.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes