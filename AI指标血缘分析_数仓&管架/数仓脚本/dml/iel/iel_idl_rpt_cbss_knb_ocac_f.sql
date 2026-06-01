: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_rpt_cbss_knb_ocac_f
CreateDate: 20180529
FileName:   ${iel_data_path}/rpt_cbss_knb_ocac.f.${batch_date}.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select
 replace(replace(t1.opendt,chr(13),''),chr(10),'') as opendt
,replace(replace(t1.opiasq,chr(13),''),chr(10),'') as opiasq
,replace(replace(t1.opensq,chr(13),''),chr(10),'') as opensq
,replace(replace(t1.opactp,chr(13),''),chr(10),'') as opactp
,replace(replace(t1.opbrno,chr(13),''),chr(10),'') as opbrno
,replace(replace(t1.acctno,chr(13),''),chr(10),'') as acctno
,replace(replace(t1.subsac,chr(13),''),chr(10),'') as subsac
,replace(replace(t1.acctna,chr(13),''),chr(10),'') as acctna
,replace(replace(t1.crcycd,chr(13),''),chr(10),'') as crcycd
,replace(replace(t1.closdt,chr(13),''),chr(10),'') as closdt
,replace(replace(t1.clossq,chr(13),''),chr(10),'') as clossq
,replace(replace(t1.clactp,chr(13),''),chr(10),'') as clactp
 from iol.cbss_knb_ocac T1
where 1=1;" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/rpt_cbss_knb_ocac.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes