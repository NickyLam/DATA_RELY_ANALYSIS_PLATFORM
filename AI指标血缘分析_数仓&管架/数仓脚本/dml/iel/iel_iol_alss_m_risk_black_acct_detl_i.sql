: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_alss_m_risk_black_acct_detl_i
CreateDate: 20180529
FileName:   ${iel_data_path}/alss_m_risk_black_acct_detl.i.${batch_date}.dat
IF_mark:    i
Logs:
   zjj 2018-07-27 create template
' \
        query="select    
    t.etl_dt_ora as etl_dt_ora
    ,t.legal_dt as legal_dt
    ,replace(replace(t.data_typ,chr(13),''),chr(10),'') as data_typ
    ,replace(replace(t.legal_acct,chr(13),''),chr(10),'') as legal_acct
    ,replace(replace(t.iden_typ,chr(13),''),chr(10),'') as iden_typ
    ,replace(replace(t.cert_num,chr(13),''),chr(10),'') as cert_num
    ,replace(replace(t.pty_id,chr(13),''),chr(10),'') as pty_id
    ,replace(replace(t.ceph_num,chr(13),''),chr(10),'') as ceph_num
    ,replace(replace(t.tel_num,chr(13),''),chr(10),'') as tel_num
    ,replace(replace(t.wthr_snd_short_lett,chr(13),''),chr(10),'') as wthr_snd_short_lett
    ,replace(replace(t.blkl_typ,chr(13),''),chr(10),'') as blkl_typ
    ,replace(replace(t.legal_comm,chr(13),''),chr(10),'') as legal_comm
    ,replace(replace(t.deal_flg,chr(13),''),chr(10),'') as deal_flg
    ,replace(replace(t.dat_src,chr(13),''),chr(10),'') as dat_src
    ,replace(replace(t.starti,chr(13),''),chr(10),'') as starti
    ,replace(replace(t.endti,chr(13),''),chr(10),'') as endti
    ,to_date('${batch_date}','yyyymmdd') as etl_dt
from iol.alss_m_risk_black_acct_detl t
where t.etl_dt = to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/alss_m_risk_black_acct_detl.i.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes