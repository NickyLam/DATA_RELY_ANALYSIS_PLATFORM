: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_vtms_a01_dsout_cbss_tran_detail_tmp_i
CreateDate: 20180529
FileName:   ${iel_data_path}/vtms_a01_dsout_cbss_tran_detail_tmp.i.${batch_date}.dat
IF_mark:    i
Logs:
   zjj 2018-07-27 create template
' \
        query="select 
replace(replace(t1.trandate,chr(13),''),chr(10),'') as trandate 
,replace(replace(t1.transq,chr(13),''),chr(10),'') as transq 
,replace(replace(t1.innersq,chr(13),''),chr(10),'') as innersq 
,t1.transq_xz as transq_xz 
,replace(replace(t1.err_trandate,chr(13),''),chr(10),'') as err_trandate 
,replace(replace(t1.err_transq,chr(13),''),chr(10),'') as err_transq 
,replace(replace(t1.acctbrno,chr(13),''),chr(10),'') as acctbrno 
,replace(replace(t1.brno,chr(13),''),chr(10),'') as brno 
,replace(replace(t1.trancd,chr(13),''),chr(10),'') as trancd 
,replace(replace(t1.item,chr(13),''),chr(10),'') as item 
,replace(replace(t1.prcscd,chr(13),''),chr(10),'') as prcscd 
,replace(replace(t1.crcycd,chr(13),''),chr(10),'') as crcycd 
,t1.hs_amt as hs_amt 
,t1.nhs_amt as nhs_amt 
,t1.tax as tax 
,t1.tax_lv as tax_lv 
,replace(replace(t1.js_sign,chr(13),''),chr(10),'') as js_sign 
,replace(replace(t1.tran_sys,chr(13),''),chr(10),'') as tran_sys 
,replace(replace(t1.cusno,chr(13),''),chr(10),'') as cusno 
,replace(replace(t1.cusname,chr(13),''),chr(10),'') as cusname 
,replace(replace(t1.acctno,chr(13),''),chr(10),'') as acctno 
from ${iol_schema}.cbss_tran_detail_tmp t1 
where  trandate = '${batch_date}';" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/vtms_a01_dsout_cbss_tran_detail_tmp.i.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes
