: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idf_aml_isbs_gle_f
CreateDate: 20180529
FileName:   ${iel_data_path}/aml_isbs_gle.f.${batch_date}.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select etl_dt
,inr
,objtyp
,objinr
,trninr
,act
,dbtcdt
,cur
,amt
,syscur
,sysamt
,valdat
,bucdat
,txt1
,txt2
,txt3
,prn
,expses
,expflg
,acttrncod
,branchinr
,dbtdft
,peeact
,rat
,trdtyp
,cliextkey
,whmtyp
,gleord
,newactcod
,trmtyp
,trnman
,midrat
,xrttim
,income
,sumtyp
,acttyp
,cshflg
,tracode
,ctycode
,apvnum
,othfin
,selrat
,buyrat from idl.aml_isbs_gle where etl_dt = to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/aml_isbs_gle.f.${batch_date}.dat" \
        charset=utf8
        safe=yes