: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_ibms_ttrd_pledgebond_f
CreateDate: 20221105
FileName:   ${iel_data_path}/ibms_ttrd_pledgebond.f.${batch_date}.dat
IF_mark:    f
Logs:
   sundexin
' \
        query="select
    to_date('${batch_date}','yyyymmdd') as etl_dt
    ,replace(replace(t.i_code,chr(13),''),chr(10),'') as i_code
    ,replace(replace(t.a_type,chr(13),''),chr(10),'') as a_type
    ,replace(replace(t.m_type,chr(13),''),chr(10),'') as m_type
    ,replace(replace(t.p_i_code,chr(13),''),chr(10),'') as p_i_code
    ,replace(replace(t.p_m_type,chr(13),''),chr(10),'') as p_m_type
    ,replace(replace(t.p_a_type,chr(13),''),chr(10),'') as p_a_type
    ,t.amount as amount
    ,t.discount as discount
    ,t.disamount as disamount
    ,replace(replace(t.partytype,chr(13),''),chr(10),'') as partytype
    ,replace(replace(t.resertype,chr(13),''),chr(10),'') as resertype
    ,t.evalfullprice as evalfullprice
    ,t.volume as volume
    ,replace(replace(t.secu_acct_id,chr(13),''),chr(10),'') as secu_acct_id
    ,replace(replace(t.ext_secu_acct_id,chr(13),''),chr(10),'') as ext_secu_acct_id
    ,replace(replace(t.trade_grp_id,chr(13),''),chr(10),'') as trade_grp_id
    ,t.sort as sort
    ,t.si_id as si_id
    ,t.sysordid as sysordid
    ,replace(replace(t.demo,chr(13),''),chr(10),'') as demo
    ,replace(replace(t.trd_alt_mark,chr(13),''),chr(10),'') as trd_alt_mark
from iol.ibms_ttrd_pledgebond t
where etl_dt = to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/ibms_ttrd_pledgebond.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes