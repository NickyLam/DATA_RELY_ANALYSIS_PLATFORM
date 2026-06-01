: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_hdws_dul_d_pcrs_agt_guarantor_info_f
CreateDate: 20180529
FileName:   ${iel_data_path}/hdws_dul_d_pcrs_agt_guarantor_info.f.${batch_date}.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select 
replace(replace(t1.guar_contr_id,chr(13),''),chr(10),'') as guar_contr_id
,replace(replace(t1.guart_pty_id,chr(13),''),chr(10),'') as guart_pty_id
,replace(replace(t1.guart_iden_typ_cd,chr(13),''),chr(10),'') as guart_iden_typ_cd
,t1.etl_dt as etl_dt
,replace(replace(t1.guart_iden_num,chr(13),''),chr(10),'') as guart_iden_num
,replace(replace(t1.guart_name,chr(13),''),chr(10),'') as guart_name
,replace(replace(t1.guart_typ_cd,chr(13),''),chr(10),'') as guart_typ_cd
,replace(replace(t1.warr_memo,chr(13),''),chr(10),'') as warr_memo
,t1.guar_ratio as guar_ratio
,replace(replace(t1.data_src_cd,chr(13),''),chr(10),'') as data_src_cd
,replace(replace(t1.del_flg,chr(13),''),chr(10),'') as del_flg
from ${idl_schema}.hdws_dul_d_pcrs_agt_guarantor_info t1
where etl_dt = to_date('${batch_date}','yyyymmdd');" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/hdws_dul_d_pcrs_agt_guarantor_info.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes