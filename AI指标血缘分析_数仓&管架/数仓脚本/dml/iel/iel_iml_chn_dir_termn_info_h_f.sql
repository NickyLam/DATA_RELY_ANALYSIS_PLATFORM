: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iml_chn_dir_termn_info_h_f
CreateDate: 20230512
FileName:   ${iel_data_path}/chn_dir_termn_info_h.f.${batch_date}.dat
IF_mark:    f
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t1.chn_id,chr(13),''),chr(10),'') as chn_id
,replace(replace(t1.seq_num,chr(13),''),chr(10),'') as seq_num
,replace(replace(t1.lp_id,chr(13),''),chr(10),'') as lp_id
,replace(replace(t1.termn_id,chr(13),''),chr(10),'') as termn_id
,replace(replace(t1.termnl_id,chr(13),''),chr(10),'') as termnl_id
,replace(replace(t1.mercht_id,chr(13),''),chr(10),'') as mercht_id
,replace(replace(t1.mercht_seq_num,chr(13),''),chr(10),'') as mercht_seq_num
,replace(replace(t1.termn_type_cd,chr(13),''),chr(10),'') as termn_type_cd
,replace(replace(t1.termn_usage_cd,chr(13),''),chr(10),'') as termn_usage_cd
,replace(replace(t1.remark,chr(13),''),chr(10),'') as remark
,iss_dt
,install_dt
,replace(replace(t1.oper_type_cd,chr(13),''),chr(10),'') as oper_type_cd
,replace(replace(t1.termn_install_addr,chr(13),''),chr(10),'') as termn_install_addr
,replace(replace(t1.termn_name,chr(13),''),chr(10),'') as termn_name
,replace(replace(t1.inst_tel,chr(13),''),chr(10),'') as inst_tel
,replace(replace(t1.termn_status_cd,chr(13),''),chr(10),'') as termn_status_cd
,replace(replace(t1.status_cd,chr(13),''),chr(10),'') as status_cd

from ${iml_schema}.chn_dir_termn_info_h t1
where start_dt <= to_date('${batch_date}','yyyymmdd') and end_dt > to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/chn_dir_termn_info_h.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes
