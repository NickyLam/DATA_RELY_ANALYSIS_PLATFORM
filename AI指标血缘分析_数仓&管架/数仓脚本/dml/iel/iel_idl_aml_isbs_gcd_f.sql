: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_aml_isbs_gcd_f
CreateDate: 20180529
FileName:   ${iel_data_path}/aml_isbs_gcd.f.${batch_date}.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select etl_dt
,inr
,ownref
,pntinr
,pnttyp
,nam
,credat
,clsdat
,opndat
,newexpdat
,ownusr
,ver
,clmtyp
,clmctl
,clmdat
,cannowflg
,msgdat
,payrol
,docprbrol
,etyextkey
,frepayflg
,bchkeyinr
,branchinr
,nraflg
,qsqdbh from idl.aml_isbs_gcd where etl_dt = to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/aml_isbs_gcd.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes