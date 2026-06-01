: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_amls_t3a_tsdt_n_f
CreateDate: 20240802
FileName:   ${iel_data_path}/amls_t3a_tsdt_n.f.${batch_date}.dat
IF_mark:    f
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t1.rpt_id,chr(13),''),chr(10),'') as rpt_id
,stat_dt
,cbif_seq
,replace(replace(t1.crcd,chr(13),''),chr(10),'') as crcd
,tsdt_seq
,atif_seq
,htcr_seq
,replace(replace(t1.finc,chr(13),''),chr(10),'') as finc
,replace(replace(t1.rlfc,chr(13),''),chr(10),'') as rlfc
,replace(replace(t1.tbnm,chr(13),''),chr(10),'') as tbnm
,replace(replace(t1.tbit,chr(13),''),chr(10),'') as tbit
,replace(replace(t1.tb_oitp,chr(13),''),chr(10),'') as tb_oitp
,replace(replace(t1.tbid,chr(13),''),chr(10),'') as tbid
,replace(replace(t1.tbnt,chr(13),''),chr(10),'') as tbnt
,replace(replace(t1.tstm,chr(13),''),chr(10),'') as tstm
,replace(replace(t1.trcd,chr(13),''),chr(10),'') as trcd
,replace(replace(t1.ticd,chr(13),''),chr(10),'') as ticd
,replace(replace(t1.rpmt,chr(13),''),chr(10),'') as rpmt
,replace(replace(t1.rpmn,chr(13),''),chr(10),'') as rpmn
,replace(replace(t1.tstp,chr(13),''),chr(10),'') as tstp
,replace(replace(t1.octt,chr(13),''),chr(10),'') as octt
,replace(replace(t1.ooct,chr(13),''),chr(10),'') as ooct
,replace(replace(t1.ocec,chr(13),''),chr(10),'') as ocec
,replace(replace(t1.bptc,chr(13),''),chr(10),'') as bptc
,replace(replace(t1.tsct,chr(13),''),chr(10),'') as tsct
,replace(replace(t1.tsdr,chr(13),''),chr(10),'') as tsdr
,replace(replace(t1.crpp,chr(13),''),chr(10),'') as crpp
,replace(replace(t1.crtp,chr(13),''),chr(10),'') as crtp
,crat
,replace(replace(t1.cfin,chr(13),''),chr(10),'') as cfin
,replace(replace(t1.cfct,chr(13),''),chr(10),'') as cfct
,replace(replace(t1.cfic,chr(13),''),chr(10),'') as cfic
,replace(replace(t1.cfrc,chr(13),''),chr(10),'') as cfrc
,replace(replace(t1.tcnm,chr(13),''),chr(10),'') as tcnm
,replace(replace(t1.tcit,chr(13),''),chr(10),'') as tcit
,replace(replace(t1.tc_oitp,chr(13),''),chr(10),'') as tc_oitp
,replace(replace(t1.tcid,chr(13),''),chr(10),'') as tcid
,replace(replace(t1.tcat,chr(13),''),chr(10),'') as tcat
,replace(replace(t1.tcac,chr(13),''),chr(10),'') as tcac
,replace(replace(t1.rotf1,chr(13),''),chr(10),'') as rotf1
,replace(replace(t1.rotf2,chr(13),''),chr(10),'') as rotf2
,replace(replace(t1.bh_valid,chr(13),''),chr(10),'') as bh_valid
,replace(replace(t1.cust_id,chr(13),''),chr(10),'') as cust_id
,replace(replace(t1.cust_type,chr(13),''),chr(10),'') as cust_type
,tr_dt
,replace(replace(t1.tr_org_id,chr(13),''),chr(10),'') as tr_org_id
,replace(replace(t1.is_cash,chr(13),''),chr(10),'') as is_cash
,replace(replace(t1.is_local_curr,chr(13),''),chr(10),'') as is_local_curr
,tr_amt
,replace(replace(t1.debit_credit,chr(13),''),chr(10),'') as debit_credit
,replace(replace(t1.acct_id,chr(13),''),chr(10),'') as acct_id
,replace(replace(t1.main_acct_id,chr(13),''),chr(10),'') as main_acct_id
,replace(replace(t1.card_no,chr(13),''),chr(10),'') as card_no
,replace(replace(t1.rpdt,chr(13),''),chr(10),'') as rpdt
,replace(replace(t1.err_type,chr(13),''),chr(10),'') as err_type
,replace(replace(t1.pbc_rcpt_tm,chr(13),''),chr(10),'') as pbc_rcpt_tm
,crmb
,cusd
,ccif_seq

from ${iol_schema}.amls_t3a_tsdt_n t1
where start_dt <= to_date('${batch_date}','yyyymmdd') and end_dt > to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/amls_t3a_tsdt_n.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes
