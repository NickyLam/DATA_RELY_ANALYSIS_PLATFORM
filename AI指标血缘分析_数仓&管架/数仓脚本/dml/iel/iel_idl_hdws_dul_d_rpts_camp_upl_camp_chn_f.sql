: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_hdws_dul_d_rpts_camp_upl_camp_chn_f
CreateDate: 20180529
FileName:   ${iel_data_path}/hdws_dul_d_rpts_camp_upl_camp_chn.f.${batch_date}.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select
etl_dt
,camp_chan_id
,camp_chn_name
,camp_chn_typ_cd
,co_start_dt
,co_trmi_dt
,legal_repsent_name
,loc_indus_typ_cd
,corp_addr
,corp_zip_code
,fst_lnkm_name
,fst_lnkm_tel
,sec_lnkm_name
,sec_lnkm_tel
,data_src_cd
from ${idl_schema}.hdws_dul_d_rpts_camp_upl_camp_chn
where etl_dt = to_date('${batch_date}','yyyymmdd');" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/hdws_dul_d_rpts_camp_upl_camp_chn.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes