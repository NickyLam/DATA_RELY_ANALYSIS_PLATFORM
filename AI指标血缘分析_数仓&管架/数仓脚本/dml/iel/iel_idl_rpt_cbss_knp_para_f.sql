: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_rpt_cbss_knp_para_f
CreateDate: 20180529
FileName:   ${iel_data_path}/rpt_cbss_knp_para.f.${batch_date}.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select
 replace(replace(t1.parmcd,chr(13),''),chr(10),'') as parmcd
,replace(replace(t1.pmkey1,chr(13),''),chr(10),'') as pmkey1
,replace(replace(t1.pmkey2,chr(13),''),chr(10),'') as pmkey2
,replace(replace(t1.pmkey3,chr(13),''),chr(10),'') as pmkey3
,replace(replace(t1.pmval1,chr(13),''),chr(10),'') as pmval1
,replace(replace(t1.pmval2,chr(13),''),chr(10),'') as pmval2
,replace(replace(t1.pmval3,chr(13),''),chr(10),'') as pmval3
,replace(replace(t1.pmval4,chr(13),''),chr(10),'') as pmval4
,replace(replace(t1.pmval5,chr(13),''),chr(10),'') as pmval5
,replace(replace(t1.vermod,chr(13),''),chr(10),'') as vermod
,replace(replace(t1.module,chr(13),''),chr(10),'') as module
,replace(replace(t1.projcd,chr(13),''),chr(10),'') as projcd
 from iol.cbss_knp_para T1
where start_dt <= to_date('${batch_date}','yyyymmdd') and end_dt > to_date('${batch_date}','yyyymmdd');" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/rpt_cbss_knp_para.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes