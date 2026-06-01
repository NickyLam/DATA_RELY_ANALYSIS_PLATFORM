: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_wind_asharecapitalization_f
CreateDate: 20180529
FileName:   ${iel_data_path}/wind_asharecapitalization.f.${batch_date}.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select
    to_date('${batch_date}','yyyymmdd') as etl_dt
    ,replace(replace(t.object_id,chr(13),''),chr(10),'') as object_id
    ,replace(replace(t.wind_code,chr(13),''),chr(10),'') as wind_code
    ,replace(replace(t.s_info_windcode,chr(13),''),chr(10),'') as s_info_windcode
    ,replace(replace(t.change_dt,chr(13),''),chr(10),'') as change_dt
    ,t.tot_shr as tot_shr
    ,t.float_shr as float_shr
    ,t.float_a_shr as float_a_shr
    ,t.float_b_shr as float_b_shr
    ,t.float_h_shr as float_h_shr
    ,t.float_overseas_shr as float_overseas_shr
    ,t.restricted_a_shr as restricted_a_shr
    ,t.s_share_rtd_state as s_share_rtd_state
    ,t.s_share_rtd_statejur as s_share_rtd_statejur
    ,t.s_share_rtd_subotherdomes as s_share_rtd_subotherdomes
    ,t.s_share_rtd_domesjur as s_share_rtd_domesjur
    ,t.s_share_rtd_inst as s_share_rtd_inst
    ,t.s_share_rtd_domesnp as s_share_rtd_domesnp
    ,t.s_share_rtd_senmanager as s_share_rtd_senmanager
    ,t.s_share_rtd_subfrgn as s_share_rtd_subfrgn
    ,t.s_share_rtd_frgnjur as s_share_rtd_frgnjur
    ,t.s_share_rtd_frgnnp as s_share_rtd_frgnnp
    ,t.restricted_b_shr as restricted_b_shr
    ,t.other_restricted_shr as other_restricted_shr
    ,t.non_tradable_shr as non_tradable_shr
    ,t.s_share_ntrd_state_pct as s_share_ntrd_state_pct
    ,t.s_share_ntrd_state as s_share_ntrd_state
    ,t.s_share_ntrd_statjur as s_share_ntrd_statjur
    ,t.s_share_ntrd_subdomesjur as s_share_ntrd_subdomesjur
    ,t.s_share_ntrd_domesinitor as s_share_ntrd_domesinitor
    ,t.s_share_ntrd_ipojuris as s_share_ntrd_ipojuris
    ,t.s_share_ntrd_genjuris as s_share_ntrd_genjuris
    ,t.s_share_ntrd_strtinvestor as s_share_ntrd_strtinvestor
    ,t.s_share_ntrd_fundbal as s_share_ntrd_fundbal
    ,t.s_share_ntrd_ipoinip as s_share_ntrd_ipoinip
    ,t.s_share_ntrd_trfnshare as s_share_ntrd_trfnshare
    ,t.s_share_ntrd_snormnger as s_share_ntrd_snormnger
    ,t.s_share_ntrd_insderemp as s_share_ntrd_insderemp
    ,t.s_share_ntrd_prfshare as s_share_ntrd_prfshare
    ,t.s_share_ntrd_nonlstfrgn as s_share_ntrd_nonlstfrgn
    ,t.s_share_ntrd_staq as s_share_ntrd_staq
    ,t.s_share_ntrd_net as s_share_ntrd_net
    ,replace(replace(t.s_share_changereason,chr(13),''),chr(10),'') as s_share_changereason
    ,replace(replace(t.ann_dt,chr(13),''),chr(10),'') as ann_dt
    ,replace(replace(t.change_dt1,chr(13),''),chr(10),'') as change_dt1
    ,t.cur_sign as cur_sign
    ,t.opdate as opdate
    ,replace(replace(t.opmode,chr(13),''),chr(10),'') as opmode
    ,t.start_dt as start_dt
    ,t.end_dt as end_dt
    ,replace(replace(t.id_mark,chr(13),''),chr(10),'') as id_mark
from iol.wind_asharecapitalization t
  where t.start_dt <= to_date('${batch_date}','yyyymmdd') and t.end_dt > to_date('${batch_date}','yyyymmdd') " \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/wind_asharecapitalization.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes