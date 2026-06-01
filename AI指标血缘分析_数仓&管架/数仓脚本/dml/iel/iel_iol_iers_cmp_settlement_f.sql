: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_iers_cmp_settlement_f
CreateDate: 20240207
FileName:   ${iel_data_path}/iers_cmp_settlement.f.${batch_date}.dat
IF_mark:    f
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,aduitstatus
,replace(replace(t1.approvedate,chr(13),''),chr(10),'') as approvedate
,replace(replace(t1.approver,chr(13),''),chr(10),'') as approver
,arithmetic
,replace(replace(t1.backreason,chr(13),''),chr(10),'') as backreason
,replace(replace(t1.billcode,chr(13),''),chr(10),'') as billcode
,replace(replace(t1.busi_auditdate,chr(13),''),chr(10),'') as busi_auditdate
,replace(replace(t1.busi_billdate,chr(13),''),chr(10),'') as busi_billdate
,busistatus
,replace(replace(t1.code,chr(13),''),chr(10),'') as code
,replace(replace(t1.commitdate,chr(13),''),chr(10),'') as commitdate
,replace(replace(t1.commiter,chr(13),''),chr(10),'') as commiter
,replace(replace(t1.commpaybegindate,chr(13),''),chr(10),'') as commpaybegindate
,replace(replace(t1.commpayenddate,chr(13),''),chr(10),'') as commpayenddate
,replace(replace(t1.consignagreement,chr(13),''),chr(10),'') as consignagreement
,replace(replace(t1.costcenter,chr(13),''),chr(10),'') as costcenter
,replace(replace(t1.creationtime,chr(13),''),chr(10),'') as creationtime
,replace(replace(t1.creator,chr(13),''),chr(10),'') as creator
,replace(replace(t1.creditorreference,chr(13),''),chr(10),'') as creditorreference
,replace(replace(t1.def1,chr(13),''),chr(10),'') as def1
,replace(replace(t1.def10,chr(13),''),chr(10),'') as def10
,replace(replace(t1.def11,chr(13),''),chr(10),'') as def11
,replace(replace(t1.def12,chr(13),''),chr(10),'') as def12
,replace(replace(t1.def13,chr(13),''),chr(10),'') as def13
,replace(replace(t1.def14,chr(13),''),chr(10),'') as def14
,replace(replace(t1.def15,chr(13),''),chr(10),'') as def15
,replace(replace(t1.def16,chr(13),''),chr(10),'') as def16
,replace(replace(t1.def17,chr(13),''),chr(10),'') as def17
,replace(replace(t1.def18,chr(13),''),chr(10),'') as def18
,replace(replace(t1.def19,chr(13),''),chr(10),'') as def19
,replace(replace(t1.def2,chr(13),''),chr(10),'') as def2
,replace(replace(t1.def20,chr(13),''),chr(10),'') as def20
,replace(replace(t1.def3,chr(13),''),chr(10),'') as def3
,replace(replace(t1.def4,chr(13),''),chr(10),'') as def4
,replace(replace(t1.def5,chr(13),''),chr(10),'') as def5
,replace(replace(t1.def6,chr(13),''),chr(10),'') as def6
,replace(replace(t1.def7,chr(13),''),chr(10),'') as def7
,replace(replace(t1.def8,chr(13),''),chr(10),'') as def8
,replace(replace(t1.def9,chr(13),''),chr(10),'') as def9
,direction
,dr
,effectstatus
,replace(replace(t1.expectdealdate,chr(13),''),chr(10),'') as expectdealdate
,replace(replace(t1.fts_billtype,chr(13),''),chr(10),'') as fts_billtype
,globaloacl
,grouplocal
,replace(replace(t1.invoiceno,chr(13),''),chr(10),'') as invoiceno
,replace(replace(t1.isautosign,chr(13),''),chr(10),'') as isautosign
,replace(replace(t1.isback,chr(13),''),chr(10),'') as isback
,replace(replace(t1.isbusieffect,chr(13),''),chr(10),'') as isbusieffect
,replace(replace(t1.iscommpay,chr(13),''),chr(10),'') as iscommpay
,replace(replace(t1.ishadbeenreturned,chr(13),''),chr(10),'') as ishadbeenreturned
,replace(replace(t1.isindependent,chr(13),''),chr(10),'') as isindependent
,replace(replace(t1.isreset,chr(13),''),chr(10),'') as isreset
,replace(replace(t1.isreturned,chr(13),''),chr(10),'') as isreturned
,replace(replace(t1.issettleeffect,chr(13),''),chr(10),'') as issettleeffect
,replace(replace(t1.isverify,chr(13),''),chr(10),'') as isverify
,replace(replace(t1.lastupdatedate,chr(13),''),chr(10),'') as lastupdatedate
,replace(replace(t1.lastupdater,chr(13),''),chr(10),'') as lastupdater
,replace(replace(t1.modifiedtime,chr(13),''),chr(10),'') as modifiedtime
,replace(replace(t1.modifier,chr(13),''),chr(10),'') as modifier
,replace(replace(t1.ntberrmsg,chr(13),''),chr(10),'') as ntberrmsg
,orglocal
,replace(replace(t1.payreason,chr(13),''),chr(10),'') as payreason
,replace(replace(t1.pk_auditor,chr(13),''),chr(10),'') as pk_auditor
,replace(replace(t1.pk_billoperator,chr(13),''),chr(10),'') as pk_billoperator
,replace(replace(t1.pk_billtype,chr(13),''),chr(10),'') as pk_billtype
,replace(replace(t1.pk_billtypeid,chr(13),''),chr(10),'') as pk_billtypeid
,replace(replace(t1.pk_busibill,chr(13),''),chr(10),'') as pk_busibill
,replace(replace(t1.pk_busitype,chr(13),''),chr(10),'') as pk_busitype
,replace(replace(t1.pk_executor,chr(13),''),chr(10),'') as pk_executor
,replace(replace(t1.pk_ftsbill,chr(13),''),chr(10),'') as pk_ftsbill
,replace(replace(t1.pk_ftsbilltype,chr(13),''),chr(10),'') as pk_ftsbilltype
,replace(replace(t1.pk_group,chr(13),''),chr(10),'') as pk_group
,replace(replace(t1.pk_operator,chr(13),''),chr(10),'') as pk_operator
,replace(replace(t1.pk_org,chr(13),''),chr(10),'') as pk_org
,replace(replace(t1.pk_org_v,chr(13),''),chr(10),'') as pk_org_v
,replace(replace(t1.pk_pcorg,chr(13),''),chr(10),'') as pk_pcorg
,replace(replace(t1.pk_pcorg_v,chr(13),''),chr(10),'') as pk_pcorg_v
,replace(replace(t1.pk_settlement,chr(13),''),chr(10),'') as pk_settlement
,replace(replace(t1.pk_signer,chr(13),''),chr(10),'') as pk_signer
,replace(replace(t1.pk_tradetype,chr(13),''),chr(10),'') as pk_tradetype
,replace(replace(t1.pk_tradetypeid,chr(13),''),chr(10),'') as pk_tradetypeid
,primal
,replace(replace(t1.returnreason,chr(13),''),chr(10),'') as returnreason
,replace(replace(t1.reversalreason,chr(13),''),chr(10),'') as reversalreason
,replace(replace(t1.saga_btxid,chr(13),''),chr(10),'') as saga_btxid
,saga_frozen
,replace(replace(t1.saga_gtxid,chr(13),''),chr(10),'') as saga_gtxid
,saga_status
,replace(replace(t1.sddreversaldate,chr(13),''),chr(10),'') as sddreversaldate
,replace(replace(t1.sddreversaler,chr(13),''),chr(10),'') as sddreversaler
,replace(replace(t1.sddreversalflag,chr(13),''),chr(10),'') as sddreversalflag
,replace(replace(t1.settlebilltype,chr(13),''),chr(10),'') as settlebilltype
,replace(replace(t1.settledate,chr(13),''),chr(10),'') as settledate
,replace(replace(t1.settlenum,chr(13),''),chr(10),'') as settlenum
,settlestatus
,settletype
,replace(replace(t1.signdate,chr(13),''),chr(10),'') as signdate
,replace(replace(t1.structuredstandard,chr(13),''),chr(10),'') as structuredstandard
,replace(replace(t1.systemcode,chr(13),''),chr(10),'') as systemcode
,replace(replace(t1.tradertypecode,chr(13),''),chr(10),'') as tradertypecode
,replace(replace(t1.ts,chr(13),''),chr(10),'') as ts
,vbillstatus

from ${iol_schema}.iers_cmp_settlement t1
where start_dt <= to_date('${batch_date}','yyyymmdd') and end_dt > to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/iers_cmp_settlement.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes
