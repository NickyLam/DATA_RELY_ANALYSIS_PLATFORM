: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_cqss_i_r_creditagreement_i_w
CreateDate: 20180529
FileName:   ${iel_data_path}/cqss_i_r_creditagreement_w.i.${batch_date}.dat
IF_mark:    i_w
Logs:
   zjj 2018-07-27 create template
' \
        query="select 
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t.id,chr(13),''),chr(10),'') as id
,t.crg_agrm_id as crg_agrm_id
,replace(replace(t.msgidno,chr(13),''),chr(10),'') as msgidno
,replace(replace(t.inst_tp,chr(13),''),chr(10),'') as inst_tp
,replace(replace(t.mtit_ecd,chr(13),''),chr(10),'') as mtit_ecd
,replace(replace(t.crg_agrm_idr_cd,chr(13),''),chr(10),'') as crg_agrm_idr_cd
,replace(replace(t.crgln_use,chr(13),''),chr(10),'') as crgln_use
,t.crgln as crgln
,replace(replace(t.ccycd,chr(13),''),chr(10),'') as ccycd
,t.efdt as efdt
,t.exdat as exdat
,replace(replace(t.crg_agrm_st,chr(13),''),chr(10),'') as crg_agrm_st
,t.crg_qot as crg_qot
,replace(replace(t.crg_qot_id,chr(13),''),chr(10),'') as crg_qot_id
,t.usd_lmt as usd_lmt
,replace(replace(t.alrdyclsglnhostrtyrmo,chr(13),''),chr(10),'') as alrdyclsglnhostrtyrmo
,replace(replace(t.alrdyclsglnhtocofyrmo,chr(13),''),chr(10),'') as alrdyclsglnhtocofyrmo
,t.sptxn_num as sptxn_num
,t.annttn_and_sttmnt_num as annttn_and_sttmnt_num
,replace(replace(t.multi_tenancy_id,chr(13),''),chr(10),'') as multi_tenancy_id
,t.crt_dt_tm as crt_dt_tm
from ${iol_schema}.cqss_i_r_creditagreement t
where to_char(crt_dt_tm,'yyyymmdd') <= '${batch_date}' and to_char(crt_dt_tm,'yyyymmdd') >= '${batch_date}' -6  ;" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/cqss_i_r_creditagreement_w.i.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes