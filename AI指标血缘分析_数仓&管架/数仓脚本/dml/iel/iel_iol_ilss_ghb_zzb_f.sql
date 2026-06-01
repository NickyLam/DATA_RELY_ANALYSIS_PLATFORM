: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_ilss_ghb_zzb_f
CreateDate: 20180529
FileName:   ${iel_data_path}/ilss_ghb_zzb.f.${batch_date}.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,t.id as id
,t.jcxx_id as jcxx_id
,replace(replace(t.zbjs_date,chr(13),''),chr(10),'') as zbjs_date
,replace(replace(t.nsrsbh,chr(13),''),chr(10),'') as nsrsbh
,replace(replace(t.zxsj_date,chr(13),''),chr(10),'') as zxsj_date
,t.rk_zzl as rk_zzl
,t.rk_m_12 as rk_m_12
,t.rk_cv as rk_cv
,t.rk_zs_sds_1_12 as rk_zs_sds_1_12
,t.zs_znj_1_12 as zs_znj_1_12
,t.rk_jybl_ch_sy as rk_jybl_ch_sy
,t.rk_jybl_five as rk_jybl_five
,t.jybl_chkh as jybl_chkh
,t.rk_glfy_bnzc as rk_glfy_bnzc
,t.rk_sszb_bnss as rk_sszb_bnss
,t.rk_jljzjcz_bnzc as rk_jljzjcz_bnzc
,t.rk_wfplrcz_bnzc as rk_wfplrcz_bnzc
,t.rk_yszk_bnss as rk_yszk_bnss
,replace(replace(t.ylzd1,chr(13),''),chr(10),'') as ylzd1
,replace(replace(t.ylzd2,chr(13),''),chr(10),'') as ylzd2
,replace(replace(t.ylzd3,chr(13),''),chr(10),'') as ylzd3
,replace(replace(t.ylzd4,chr(13),''),chr(10),'') as ylzd4
,replace(replace(t.ylzd5,chr(13),''),chr(10),'') as ylzd5
from iol.ilss_ghb_zzb t
where t.etl_dt = to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/ilss_ghb_zzb.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes