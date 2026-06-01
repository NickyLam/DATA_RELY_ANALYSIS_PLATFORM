/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_iers_cmp_settlement
CreateDate: 20180515
Logs:
    zjj 2018-05-15 新建脚本
*/

set timing on

-- 1 alter parallel
alter session force parallel query parallel 8;
alter session force parallel dml parallel 8;
-- alter session force parallel ddl parallel 8;

-- 2.1 create backup table
-- if backup table is exists, mean script if failed on last time
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
create table ${iol_schema}.iers_cmp_settlement_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.iers_cmp_settlement
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.iers_cmp_settlement_op purge;
drop table ${iol_schema}.iers_cmp_settlement_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.iers_cmp_settlement_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.iers_cmp_settlement where 0=1;

create table ${iol_schema}.iers_cmp_settlement_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.iers_cmp_settlement where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.iers_cmp_settlement_cl(
            aduitstatus -- 业务单据审批状态
            ,approvedate -- 审批日期
            ,approver -- 审批人
            ,arithmetic -- 结算信息处理算法
            ,backreason -- 自定义
            ,billcode -- 业务单据编号
            ,busi_auditdate -- 业务单据审核日期
            ,busi_billdate -- 业务单据日期
            ,busistatus -- 业务单据状态
            ,code -- 数字签名
            ,commitdate -- 提交日期
            ,commiter -- 提交人
            ,commpaybegindate -- 承付开始日期
            ,commpayenddate -- 承付结束日期
            ,consignagreement -- 托收协议号
            ,costcenter -- 成本中心
            ,creationtime -- 创建时间
            ,creator -- 创建人
            ,creditorreference -- 结构化贷方引用信息
            ,def1 -- 自定义项1
            ,def10 -- 自定义项10
            ,def11 -- 自定义项11
            ,def12 -- 自定义项12
            ,def13 -- 自定义项13
            ,def14 -- 自定义项14
            ,def15 -- 自定义项15
            ,def16 -- 自定义项16
            ,def17 -- 自定义项17
            ,def18 -- 自定义项18
            ,def19 -- 自定义项19
            ,def2 -- 自定义项2
            ,def20 -- 自定义项20
            ,def3 -- 自定义项3
            ,def4 -- 自定义项4
            ,def5 -- 自定义项5
            ,def6 -- 自定义项6
            ,def7 -- 自定义项7
            ,def8 -- 自定义项8
            ,def9 -- 自定义项9
            ,direction -- 方向
            ,dr -- 删除标志
            ,effectstatus -- 业务单据生效状态
            ,expectdealdate -- 期望处理日
            ,fts_billtype -- 资金单据类型
            ,globaloacl -- 全局本币
            ,grouplocal -- 集团本币
            ,invoiceno -- 非结构化贷方引用信息
            ,isautosign -- 是否自动签字
            ,isback -- 自定义
            ,isbusieffect -- 业务单据是否已生效
            ,iscommpay -- 是否需承付
            ,ishadbeenreturned -- 是否曾经被退回
            ,isindependent -- 是否独立生成
            ,isreset -- 是否红冲单据
            ,isreturned -- 是否退回标志
            ,issettleeffect -- 结算单是否生效
            ,isverify -- 是否进行上一环节验签
            ,lastupdatedate -- 最新更新日期
            ,lastupdater -- 最新更新人
            ,modifiedtime -- 修改时间
            ,modifier -- 修改人
            ,ntberrmsg -- 自定义
            ,orglocal -- 本币金额
            ,payreason -- 支付原因
            ,pk_auditor -- 业务单据审核人
            ,pk_billoperator -- 业务单据录入人
            ,pk_billtype -- 业务单据类型
            ,pk_billtypeid -- 业务单据类型ID
            ,pk_busibill -- 业务单据主键
            ,pk_busitype -- 业务类型
            ,pk_executor -- 结算人
            ,pk_ftsbill -- 资金单据主键
            ,pk_ftsbilltype -- 资金单据类型PK
            ,pk_group -- 所属集团
            ,pk_operator -- 录入人
            ,pk_org -- 财务组织
            ,pk_org_v -- 业务单元版本
            ,pk_pcorg -- 利润中心
            ,pk_pcorg_v -- 利润中心版本
            ,pk_settlement -- 结算信息主键
            ,pk_signer -- 签字确认人
            ,pk_tradetype -- 业务单交易类型
            ,pk_tradetypeid -- 交易类型
            ,primal -- 原币金额
            ,returnreason -- 资金组织退回原因
            ,reversalreason -- 退回原因
            ,saga_btxid -- 自定义
            ,saga_frozen -- 自定义
            ,saga_gtxid -- 自定义
            ,saga_status -- 自定义
            ,sddreversaldate -- 直接借记退回日期
            ,sddreversaler -- 直接借记退回人
            ,sddreversalflag -- 直接借记退回标记
            ,settlebilltype -- 结算单据类型
            ,settledate -- 结算日期
            ,settlenum -- 结算号
            ,settlestatus -- 结算状态
            ,settletype -- 完成结算方式
            ,signdate -- 签字确认日期
            ,structuredstandard -- 结构化信息标准
            ,systemcode -- 归属系统
            ,tradertypecode -- 交易类型编码
            ,ts -- 时间戳
            ,vbillstatus -- 审批状态
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.iers_cmp_settlement_op(
            aduitstatus -- 业务单据审批状态
            ,approvedate -- 审批日期
            ,approver -- 审批人
            ,arithmetic -- 结算信息处理算法
            ,backreason -- 自定义
            ,billcode -- 业务单据编号
            ,busi_auditdate -- 业务单据审核日期
            ,busi_billdate -- 业务单据日期
            ,busistatus -- 业务单据状态
            ,code -- 数字签名
            ,commitdate -- 提交日期
            ,commiter -- 提交人
            ,commpaybegindate -- 承付开始日期
            ,commpayenddate -- 承付结束日期
            ,consignagreement -- 托收协议号
            ,costcenter -- 成本中心
            ,creationtime -- 创建时间
            ,creator -- 创建人
            ,creditorreference -- 结构化贷方引用信息
            ,def1 -- 自定义项1
            ,def10 -- 自定义项10
            ,def11 -- 自定义项11
            ,def12 -- 自定义项12
            ,def13 -- 自定义项13
            ,def14 -- 自定义项14
            ,def15 -- 自定义项15
            ,def16 -- 自定义项16
            ,def17 -- 自定义项17
            ,def18 -- 自定义项18
            ,def19 -- 自定义项19
            ,def2 -- 自定义项2
            ,def20 -- 自定义项20
            ,def3 -- 自定义项3
            ,def4 -- 自定义项4
            ,def5 -- 自定义项5
            ,def6 -- 自定义项6
            ,def7 -- 自定义项7
            ,def8 -- 自定义项8
            ,def9 -- 自定义项9
            ,direction -- 方向
            ,dr -- 删除标志
            ,effectstatus -- 业务单据生效状态
            ,expectdealdate -- 期望处理日
            ,fts_billtype -- 资金单据类型
            ,globaloacl -- 全局本币
            ,grouplocal -- 集团本币
            ,invoiceno -- 非结构化贷方引用信息
            ,isautosign -- 是否自动签字
            ,isback -- 自定义
            ,isbusieffect -- 业务单据是否已生效
            ,iscommpay -- 是否需承付
            ,ishadbeenreturned -- 是否曾经被退回
            ,isindependent -- 是否独立生成
            ,isreset -- 是否红冲单据
            ,isreturned -- 是否退回标志
            ,issettleeffect -- 结算单是否生效
            ,isverify -- 是否进行上一环节验签
            ,lastupdatedate -- 最新更新日期
            ,lastupdater -- 最新更新人
            ,modifiedtime -- 修改时间
            ,modifier -- 修改人
            ,ntberrmsg -- 自定义
            ,orglocal -- 本币金额
            ,payreason -- 支付原因
            ,pk_auditor -- 业务单据审核人
            ,pk_billoperator -- 业务单据录入人
            ,pk_billtype -- 业务单据类型
            ,pk_billtypeid -- 业务单据类型ID
            ,pk_busibill -- 业务单据主键
            ,pk_busitype -- 业务类型
            ,pk_executor -- 结算人
            ,pk_ftsbill -- 资金单据主键
            ,pk_ftsbilltype -- 资金单据类型PK
            ,pk_group -- 所属集团
            ,pk_operator -- 录入人
            ,pk_org -- 财务组织
            ,pk_org_v -- 业务单元版本
            ,pk_pcorg -- 利润中心
            ,pk_pcorg_v -- 利润中心版本
            ,pk_settlement -- 结算信息主键
            ,pk_signer -- 签字确认人
            ,pk_tradetype -- 业务单交易类型
            ,pk_tradetypeid -- 交易类型
            ,primal -- 原币金额
            ,returnreason -- 资金组织退回原因
            ,reversalreason -- 退回原因
            ,saga_btxid -- 自定义
            ,saga_frozen -- 自定义
            ,saga_gtxid -- 自定义
            ,saga_status -- 自定义
            ,sddreversaldate -- 直接借记退回日期
            ,sddreversaler -- 直接借记退回人
            ,sddreversalflag -- 直接借记退回标记
            ,settlebilltype -- 结算单据类型
            ,settledate -- 结算日期
            ,settlenum -- 结算号
            ,settlestatus -- 结算状态
            ,settletype -- 完成结算方式
            ,signdate -- 签字确认日期
            ,structuredstandard -- 结构化信息标准
            ,systemcode -- 归属系统
            ,tradertypecode -- 交易类型编码
            ,ts -- 时间戳
            ,vbillstatus -- 审批状态
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.aduitstatus, o.aduitstatus) as aduitstatus -- 业务单据审批状态
    ,nvl(n.approvedate, o.approvedate) as approvedate -- 审批日期
    ,nvl(n.approver, o.approver) as approver -- 审批人
    ,nvl(n.arithmetic, o.arithmetic) as arithmetic -- 结算信息处理算法
    ,nvl(n.backreason, o.backreason) as backreason -- 自定义
    ,nvl(n.billcode, o.billcode) as billcode -- 业务单据编号
    ,nvl(n.busi_auditdate, o.busi_auditdate) as busi_auditdate -- 业务单据审核日期
    ,nvl(n.busi_billdate, o.busi_billdate) as busi_billdate -- 业务单据日期
    ,nvl(n.busistatus, o.busistatus) as busistatus -- 业务单据状态
    ,nvl(n.code, o.code) as code -- 数字签名
    ,nvl(n.commitdate, o.commitdate) as commitdate -- 提交日期
    ,nvl(n.commiter, o.commiter) as commiter -- 提交人
    ,nvl(n.commpaybegindate, o.commpaybegindate) as commpaybegindate -- 承付开始日期
    ,nvl(n.commpayenddate, o.commpayenddate) as commpayenddate -- 承付结束日期
    ,nvl(n.consignagreement, o.consignagreement) as consignagreement -- 托收协议号
    ,nvl(n.costcenter, o.costcenter) as costcenter -- 成本中心
    ,nvl(n.creationtime, o.creationtime) as creationtime -- 创建时间
    ,nvl(n.creator, o.creator) as creator -- 创建人
    ,nvl(n.creditorreference, o.creditorreference) as creditorreference -- 结构化贷方引用信息
    ,nvl(n.def1, o.def1) as def1 -- 自定义项1
    ,nvl(n.def10, o.def10) as def10 -- 自定义项10
    ,nvl(n.def11, o.def11) as def11 -- 自定义项11
    ,nvl(n.def12, o.def12) as def12 -- 自定义项12
    ,nvl(n.def13, o.def13) as def13 -- 自定义项13
    ,nvl(n.def14, o.def14) as def14 -- 自定义项14
    ,nvl(n.def15, o.def15) as def15 -- 自定义项15
    ,nvl(n.def16, o.def16) as def16 -- 自定义项16
    ,nvl(n.def17, o.def17) as def17 -- 自定义项17
    ,nvl(n.def18, o.def18) as def18 -- 自定义项18
    ,nvl(n.def19, o.def19) as def19 -- 自定义项19
    ,nvl(n.def2, o.def2) as def2 -- 自定义项2
    ,nvl(n.def20, o.def20) as def20 -- 自定义项20
    ,nvl(n.def3, o.def3) as def3 -- 自定义项3
    ,nvl(n.def4, o.def4) as def4 -- 自定义项4
    ,nvl(n.def5, o.def5) as def5 -- 自定义项5
    ,nvl(n.def6, o.def6) as def6 -- 自定义项6
    ,nvl(n.def7, o.def7) as def7 -- 自定义项7
    ,nvl(n.def8, o.def8) as def8 -- 自定义项8
    ,nvl(n.def9, o.def9) as def9 -- 自定义项9
    ,nvl(n.direction, o.direction) as direction -- 方向
    ,nvl(n.dr, o.dr) as dr -- 删除标志
    ,nvl(n.effectstatus, o.effectstatus) as effectstatus -- 业务单据生效状态
    ,nvl(n.expectdealdate, o.expectdealdate) as expectdealdate -- 期望处理日
    ,nvl(n.fts_billtype, o.fts_billtype) as fts_billtype -- 资金单据类型
    ,nvl(n.globaloacl, o.globaloacl) as globaloacl -- 全局本币
    ,nvl(n.grouplocal, o.grouplocal) as grouplocal -- 集团本币
    ,nvl(n.invoiceno, o.invoiceno) as invoiceno -- 非结构化贷方引用信息
    ,nvl(n.isautosign, o.isautosign) as isautosign -- 是否自动签字
    ,nvl(n.isback, o.isback) as isback -- 自定义
    ,nvl(n.isbusieffect, o.isbusieffect) as isbusieffect -- 业务单据是否已生效
    ,nvl(n.iscommpay, o.iscommpay) as iscommpay -- 是否需承付
    ,nvl(n.ishadbeenreturned, o.ishadbeenreturned) as ishadbeenreturned -- 是否曾经被退回
    ,nvl(n.isindependent, o.isindependent) as isindependent -- 是否独立生成
    ,nvl(n.isreset, o.isreset) as isreset -- 是否红冲单据
    ,nvl(n.isreturned, o.isreturned) as isreturned -- 是否退回标志
    ,nvl(n.issettleeffect, o.issettleeffect) as issettleeffect -- 结算单是否生效
    ,nvl(n.isverify, o.isverify) as isverify -- 是否进行上一环节验签
    ,nvl(n.lastupdatedate, o.lastupdatedate) as lastupdatedate -- 最新更新日期
    ,nvl(n.lastupdater, o.lastupdater) as lastupdater -- 最新更新人
    ,nvl(n.modifiedtime, o.modifiedtime) as modifiedtime -- 修改时间
    ,nvl(n.modifier, o.modifier) as modifier -- 修改人
    ,nvl(n.ntberrmsg, o.ntberrmsg) as ntberrmsg -- 自定义
    ,nvl(n.orglocal, o.orglocal) as orglocal -- 本币金额
    ,nvl(n.payreason, o.payreason) as payreason -- 支付原因
    ,nvl(n.pk_auditor, o.pk_auditor) as pk_auditor -- 业务单据审核人
    ,nvl(n.pk_billoperator, o.pk_billoperator) as pk_billoperator -- 业务单据录入人
    ,nvl(n.pk_billtype, o.pk_billtype) as pk_billtype -- 业务单据类型
    ,nvl(n.pk_billtypeid, o.pk_billtypeid) as pk_billtypeid -- 业务单据类型ID
    ,nvl(n.pk_busibill, o.pk_busibill) as pk_busibill -- 业务单据主键
    ,nvl(n.pk_busitype, o.pk_busitype) as pk_busitype -- 业务类型
    ,nvl(n.pk_executor, o.pk_executor) as pk_executor -- 结算人
    ,nvl(n.pk_ftsbill, o.pk_ftsbill) as pk_ftsbill -- 资金单据主键
    ,nvl(n.pk_ftsbilltype, o.pk_ftsbilltype) as pk_ftsbilltype -- 资金单据类型PK
    ,nvl(n.pk_group, o.pk_group) as pk_group -- 所属集团
    ,nvl(n.pk_operator, o.pk_operator) as pk_operator -- 录入人
    ,nvl(n.pk_org, o.pk_org) as pk_org -- 财务组织
    ,nvl(n.pk_org_v, o.pk_org_v) as pk_org_v -- 业务单元版本
    ,nvl(n.pk_pcorg, o.pk_pcorg) as pk_pcorg -- 利润中心
    ,nvl(n.pk_pcorg_v, o.pk_pcorg_v) as pk_pcorg_v -- 利润中心版本
    ,nvl(n.pk_settlement, o.pk_settlement) as pk_settlement -- 结算信息主键
    ,nvl(n.pk_signer, o.pk_signer) as pk_signer -- 签字确认人
    ,nvl(n.pk_tradetype, o.pk_tradetype) as pk_tradetype -- 业务单交易类型
    ,nvl(n.pk_tradetypeid, o.pk_tradetypeid) as pk_tradetypeid -- 交易类型
    ,nvl(n.primal, o.primal) as primal -- 原币金额
    ,nvl(n.returnreason, o.returnreason) as returnreason -- 资金组织退回原因
    ,nvl(n.reversalreason, o.reversalreason) as reversalreason -- 退回原因
    ,nvl(n.saga_btxid, o.saga_btxid) as saga_btxid -- 自定义
    ,nvl(n.saga_frozen, o.saga_frozen) as saga_frozen -- 自定义
    ,nvl(n.saga_gtxid, o.saga_gtxid) as saga_gtxid -- 自定义
    ,nvl(n.saga_status, o.saga_status) as saga_status -- 自定义
    ,nvl(n.sddreversaldate, o.sddreversaldate) as sddreversaldate -- 直接借记退回日期
    ,nvl(n.sddreversaler, o.sddreversaler) as sddreversaler -- 直接借记退回人
    ,nvl(n.sddreversalflag, o.sddreversalflag) as sddreversalflag -- 直接借记退回标记
    ,nvl(n.settlebilltype, o.settlebilltype) as settlebilltype -- 结算单据类型
    ,nvl(n.settledate, o.settledate) as settledate -- 结算日期
    ,nvl(n.settlenum, o.settlenum) as settlenum -- 结算号
    ,nvl(n.settlestatus, o.settlestatus) as settlestatus -- 结算状态
    ,nvl(n.settletype, o.settletype) as settletype -- 完成结算方式
    ,nvl(n.signdate, o.signdate) as signdate -- 签字确认日期
    ,nvl(n.structuredstandard, o.structuredstandard) as structuredstandard -- 结构化信息标准
    ,nvl(n.systemcode, o.systemcode) as systemcode -- 归属系统
    ,nvl(n.tradertypecode, o.tradertypecode) as tradertypecode -- 交易类型编码
    ,nvl(n.ts, o.ts) as ts -- 时间戳
    ,nvl(n.vbillstatus, o.vbillstatus) as vbillstatus -- 审批状态
    ,case when
            n.pk_settlement is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.pk_settlement is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.pk_settlement is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.iers_cmp_settlement_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.iers_cmp_settlement where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.pk_settlement = n.pk_settlement
where (
        o.pk_settlement is null
    )
    or (
        n.pk_settlement is null
    )
    or (
        o.aduitstatus <> n.aduitstatus
        or o.approvedate <> n.approvedate
        or o.approver <> n.approver
        or o.arithmetic <> n.arithmetic
        or o.backreason <> n.backreason
        or o.billcode <> n.billcode
        or o.busi_auditdate <> n.busi_auditdate
        or o.busi_billdate <> n.busi_billdate
        or o.busistatus <> n.busistatus
        or o.code <> n.code
        or o.commitdate <> n.commitdate
        or o.commiter <> n.commiter
        or o.commpaybegindate <> n.commpaybegindate
        or o.commpayenddate <> n.commpayenddate
        or o.consignagreement <> n.consignagreement
        or o.costcenter <> n.costcenter
        or o.creationtime <> n.creationtime
        or o.creator <> n.creator
        or o.creditorreference <> n.creditorreference
        or o.def1 <> n.def1
        or o.def10 <> n.def10
        or o.def11 <> n.def11
        or o.def12 <> n.def12
        or o.def13 <> n.def13
        or o.def14 <> n.def14
        or o.def15 <> n.def15
        or o.def16 <> n.def16
        or o.def17 <> n.def17
        or o.def18 <> n.def18
        or o.def19 <> n.def19
        or o.def2 <> n.def2
        or o.def20 <> n.def20
        or o.def3 <> n.def3
        or o.def4 <> n.def4
        or o.def5 <> n.def5
        or o.def6 <> n.def6
        or o.def7 <> n.def7
        or o.def8 <> n.def8
        or o.def9 <> n.def9
        or o.direction <> n.direction
        or o.dr <> n.dr
        or o.effectstatus <> n.effectstatus
        or o.expectdealdate <> n.expectdealdate
        or o.fts_billtype <> n.fts_billtype
        or o.globaloacl <> n.globaloacl
        or o.grouplocal <> n.grouplocal
        or o.invoiceno <> n.invoiceno
        or o.isautosign <> n.isautosign
        or o.isback <> n.isback
        or o.isbusieffect <> n.isbusieffect
        or o.iscommpay <> n.iscommpay
        or o.ishadbeenreturned <> n.ishadbeenreturned
        or o.isindependent <> n.isindependent
        or o.isreset <> n.isreset
        or o.isreturned <> n.isreturned
        or o.issettleeffect <> n.issettleeffect
        or o.isverify <> n.isverify
        or o.lastupdatedate <> n.lastupdatedate
        or o.lastupdater <> n.lastupdater
        or o.modifiedtime <> n.modifiedtime
        or o.modifier <> n.modifier
        or o.ntberrmsg <> n.ntberrmsg
        or o.orglocal <> n.orglocal
        or o.payreason <> n.payreason
        or o.pk_auditor <> n.pk_auditor
        or o.pk_billoperator <> n.pk_billoperator
        or o.pk_billtype <> n.pk_billtype
        or o.pk_billtypeid <> n.pk_billtypeid
        or o.pk_busibill <> n.pk_busibill
        or o.pk_busitype <> n.pk_busitype
        or o.pk_executor <> n.pk_executor
        or o.pk_ftsbill <> n.pk_ftsbill
        or o.pk_ftsbilltype <> n.pk_ftsbilltype
        or o.pk_group <> n.pk_group
        or o.pk_operator <> n.pk_operator
        or o.pk_org <> n.pk_org
        or o.pk_org_v <> n.pk_org_v
        or o.pk_pcorg <> n.pk_pcorg
        or o.pk_pcorg_v <> n.pk_pcorg_v
        or o.pk_signer <> n.pk_signer
        or o.pk_tradetype <> n.pk_tradetype
        or o.pk_tradetypeid <> n.pk_tradetypeid
        or o.primal <> n.primal
        or o.returnreason <> n.returnreason
        or o.reversalreason <> n.reversalreason
        or o.saga_btxid <> n.saga_btxid
        or o.saga_frozen <> n.saga_frozen
        or o.saga_gtxid <> n.saga_gtxid
        or o.saga_status <> n.saga_status
        or o.sddreversaldate <> n.sddreversaldate
        or o.sddreversaler <> n.sddreversaler
        or o.sddreversalflag <> n.sddreversalflag
        or o.settlebilltype <> n.settlebilltype
        or o.settledate <> n.settledate
        or o.settlenum <> n.settlenum
        or o.settlestatus <> n.settlestatus
        or o.settletype <> n.settletype
        or o.signdate <> n.signdate
        or o.structuredstandard <> n.structuredstandard
        or o.systemcode <> n.systemcode
        or o.tradertypecode <> n.tradertypecode
        or o.ts <> n.ts
        or o.vbillstatus <> n.vbillstatus
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.iers_cmp_settlement_cl(
            aduitstatus -- 业务单据审批状态
            ,approvedate -- 审批日期
            ,approver -- 审批人
            ,arithmetic -- 结算信息处理算法
            ,backreason -- 自定义
            ,billcode -- 业务单据编号
            ,busi_auditdate -- 业务单据审核日期
            ,busi_billdate -- 业务单据日期
            ,busistatus -- 业务单据状态
            ,code -- 数字签名
            ,commitdate -- 提交日期
            ,commiter -- 提交人
            ,commpaybegindate -- 承付开始日期
            ,commpayenddate -- 承付结束日期
            ,consignagreement -- 托收协议号
            ,costcenter -- 成本中心
            ,creationtime -- 创建时间
            ,creator -- 创建人
            ,creditorreference -- 结构化贷方引用信息
            ,def1 -- 自定义项1
            ,def10 -- 自定义项10
            ,def11 -- 自定义项11
            ,def12 -- 自定义项12
            ,def13 -- 自定义项13
            ,def14 -- 自定义项14
            ,def15 -- 自定义项15
            ,def16 -- 自定义项16
            ,def17 -- 自定义项17
            ,def18 -- 自定义项18
            ,def19 -- 自定义项19
            ,def2 -- 自定义项2
            ,def20 -- 自定义项20
            ,def3 -- 自定义项3
            ,def4 -- 自定义项4
            ,def5 -- 自定义项5
            ,def6 -- 自定义项6
            ,def7 -- 自定义项7
            ,def8 -- 自定义项8
            ,def9 -- 自定义项9
            ,direction -- 方向
            ,dr -- 删除标志
            ,effectstatus -- 业务单据生效状态
            ,expectdealdate -- 期望处理日
            ,fts_billtype -- 资金单据类型
            ,globaloacl -- 全局本币
            ,grouplocal -- 集团本币
            ,invoiceno -- 非结构化贷方引用信息
            ,isautosign -- 是否自动签字
            ,isback -- 自定义
            ,isbusieffect -- 业务单据是否已生效
            ,iscommpay -- 是否需承付
            ,ishadbeenreturned -- 是否曾经被退回
            ,isindependent -- 是否独立生成
            ,isreset -- 是否红冲单据
            ,isreturned -- 是否退回标志
            ,issettleeffect -- 结算单是否生效
            ,isverify -- 是否进行上一环节验签
            ,lastupdatedate -- 最新更新日期
            ,lastupdater -- 最新更新人
            ,modifiedtime -- 修改时间
            ,modifier -- 修改人
            ,ntberrmsg -- 自定义
            ,orglocal -- 本币金额
            ,payreason -- 支付原因
            ,pk_auditor -- 业务单据审核人
            ,pk_billoperator -- 业务单据录入人
            ,pk_billtype -- 业务单据类型
            ,pk_billtypeid -- 业务单据类型ID
            ,pk_busibill -- 业务单据主键
            ,pk_busitype -- 业务类型
            ,pk_executor -- 结算人
            ,pk_ftsbill -- 资金单据主键
            ,pk_ftsbilltype -- 资金单据类型PK
            ,pk_group -- 所属集团
            ,pk_operator -- 录入人
            ,pk_org -- 财务组织
            ,pk_org_v -- 业务单元版本
            ,pk_pcorg -- 利润中心
            ,pk_pcorg_v -- 利润中心版本
            ,pk_settlement -- 结算信息主键
            ,pk_signer -- 签字确认人
            ,pk_tradetype -- 业务单交易类型
            ,pk_tradetypeid -- 交易类型
            ,primal -- 原币金额
            ,returnreason -- 资金组织退回原因
            ,reversalreason -- 退回原因
            ,saga_btxid -- 自定义
            ,saga_frozen -- 自定义
            ,saga_gtxid -- 自定义
            ,saga_status -- 自定义
            ,sddreversaldate -- 直接借记退回日期
            ,sddreversaler -- 直接借记退回人
            ,sddreversalflag -- 直接借记退回标记
            ,settlebilltype -- 结算单据类型
            ,settledate -- 结算日期
            ,settlenum -- 结算号
            ,settlestatus -- 结算状态
            ,settletype -- 完成结算方式
            ,signdate -- 签字确认日期
            ,structuredstandard -- 结构化信息标准
            ,systemcode -- 归属系统
            ,tradertypecode -- 交易类型编码
            ,ts -- 时间戳
            ,vbillstatus -- 审批状态
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.iers_cmp_settlement_op(
            aduitstatus -- 业务单据审批状态
            ,approvedate -- 审批日期
            ,approver -- 审批人
            ,arithmetic -- 结算信息处理算法
            ,backreason -- 自定义
            ,billcode -- 业务单据编号
            ,busi_auditdate -- 业务单据审核日期
            ,busi_billdate -- 业务单据日期
            ,busistatus -- 业务单据状态
            ,code -- 数字签名
            ,commitdate -- 提交日期
            ,commiter -- 提交人
            ,commpaybegindate -- 承付开始日期
            ,commpayenddate -- 承付结束日期
            ,consignagreement -- 托收协议号
            ,costcenter -- 成本中心
            ,creationtime -- 创建时间
            ,creator -- 创建人
            ,creditorreference -- 结构化贷方引用信息
            ,def1 -- 自定义项1
            ,def10 -- 自定义项10
            ,def11 -- 自定义项11
            ,def12 -- 自定义项12
            ,def13 -- 自定义项13
            ,def14 -- 自定义项14
            ,def15 -- 自定义项15
            ,def16 -- 自定义项16
            ,def17 -- 自定义项17
            ,def18 -- 自定义项18
            ,def19 -- 自定义项19
            ,def2 -- 自定义项2
            ,def20 -- 自定义项20
            ,def3 -- 自定义项3
            ,def4 -- 自定义项4
            ,def5 -- 自定义项5
            ,def6 -- 自定义项6
            ,def7 -- 自定义项7
            ,def8 -- 自定义项8
            ,def9 -- 自定义项9
            ,direction -- 方向
            ,dr -- 删除标志
            ,effectstatus -- 业务单据生效状态
            ,expectdealdate -- 期望处理日
            ,fts_billtype -- 资金单据类型
            ,globaloacl -- 全局本币
            ,grouplocal -- 集团本币
            ,invoiceno -- 非结构化贷方引用信息
            ,isautosign -- 是否自动签字
            ,isback -- 自定义
            ,isbusieffect -- 业务单据是否已生效
            ,iscommpay -- 是否需承付
            ,ishadbeenreturned -- 是否曾经被退回
            ,isindependent -- 是否独立生成
            ,isreset -- 是否红冲单据
            ,isreturned -- 是否退回标志
            ,issettleeffect -- 结算单是否生效
            ,isverify -- 是否进行上一环节验签
            ,lastupdatedate -- 最新更新日期
            ,lastupdater -- 最新更新人
            ,modifiedtime -- 修改时间
            ,modifier -- 修改人
            ,ntberrmsg -- 自定义
            ,orglocal -- 本币金额
            ,payreason -- 支付原因
            ,pk_auditor -- 业务单据审核人
            ,pk_billoperator -- 业务单据录入人
            ,pk_billtype -- 业务单据类型
            ,pk_billtypeid -- 业务单据类型ID
            ,pk_busibill -- 业务单据主键
            ,pk_busitype -- 业务类型
            ,pk_executor -- 结算人
            ,pk_ftsbill -- 资金单据主键
            ,pk_ftsbilltype -- 资金单据类型PK
            ,pk_group -- 所属集团
            ,pk_operator -- 录入人
            ,pk_org -- 财务组织
            ,pk_org_v -- 业务单元版本
            ,pk_pcorg -- 利润中心
            ,pk_pcorg_v -- 利润中心版本
            ,pk_settlement -- 结算信息主键
            ,pk_signer -- 签字确认人
            ,pk_tradetype -- 业务单交易类型
            ,pk_tradetypeid -- 交易类型
            ,primal -- 原币金额
            ,returnreason -- 资金组织退回原因
            ,reversalreason -- 退回原因
            ,saga_btxid -- 自定义
            ,saga_frozen -- 自定义
            ,saga_gtxid -- 自定义
            ,saga_status -- 自定义
            ,sddreversaldate -- 直接借记退回日期
            ,sddreversaler -- 直接借记退回人
            ,sddreversalflag -- 直接借记退回标记
            ,settlebilltype -- 结算单据类型
            ,settledate -- 结算日期
            ,settlenum -- 结算号
            ,settlestatus -- 结算状态
            ,settletype -- 完成结算方式
            ,signdate -- 签字确认日期
            ,structuredstandard -- 结构化信息标准
            ,systemcode -- 归属系统
            ,tradertypecode -- 交易类型编码
            ,ts -- 时间戳
            ,vbillstatus -- 审批状态
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.aduitstatus -- 业务单据审批状态
    ,o.approvedate -- 审批日期
    ,o.approver -- 审批人
    ,o.arithmetic -- 结算信息处理算法
    ,o.backreason -- 自定义
    ,o.billcode -- 业务单据编号
    ,o.busi_auditdate -- 业务单据审核日期
    ,o.busi_billdate -- 业务单据日期
    ,o.busistatus -- 业务单据状态
    ,o.code -- 数字签名
    ,o.commitdate -- 提交日期
    ,o.commiter -- 提交人
    ,o.commpaybegindate -- 承付开始日期
    ,o.commpayenddate -- 承付结束日期
    ,o.consignagreement -- 托收协议号
    ,o.costcenter -- 成本中心
    ,o.creationtime -- 创建时间
    ,o.creator -- 创建人
    ,o.creditorreference -- 结构化贷方引用信息
    ,o.def1 -- 自定义项1
    ,o.def10 -- 自定义项10
    ,o.def11 -- 自定义项11
    ,o.def12 -- 自定义项12
    ,o.def13 -- 自定义项13
    ,o.def14 -- 自定义项14
    ,o.def15 -- 自定义项15
    ,o.def16 -- 自定义项16
    ,o.def17 -- 自定义项17
    ,o.def18 -- 自定义项18
    ,o.def19 -- 自定义项19
    ,o.def2 -- 自定义项2
    ,o.def20 -- 自定义项20
    ,o.def3 -- 自定义项3
    ,o.def4 -- 自定义项4
    ,o.def5 -- 自定义项5
    ,o.def6 -- 自定义项6
    ,o.def7 -- 自定义项7
    ,o.def8 -- 自定义项8
    ,o.def9 -- 自定义项9
    ,o.direction -- 方向
    ,o.dr -- 删除标志
    ,o.effectstatus -- 业务单据生效状态
    ,o.expectdealdate -- 期望处理日
    ,o.fts_billtype -- 资金单据类型
    ,o.globaloacl -- 全局本币
    ,o.grouplocal -- 集团本币
    ,o.invoiceno -- 非结构化贷方引用信息
    ,o.isautosign -- 是否自动签字
    ,o.isback -- 自定义
    ,o.isbusieffect -- 业务单据是否已生效
    ,o.iscommpay -- 是否需承付
    ,o.ishadbeenreturned -- 是否曾经被退回
    ,o.isindependent -- 是否独立生成
    ,o.isreset -- 是否红冲单据
    ,o.isreturned -- 是否退回标志
    ,o.issettleeffect -- 结算单是否生效
    ,o.isverify -- 是否进行上一环节验签
    ,o.lastupdatedate -- 最新更新日期
    ,o.lastupdater -- 最新更新人
    ,o.modifiedtime -- 修改时间
    ,o.modifier -- 修改人
    ,o.ntberrmsg -- 自定义
    ,o.orglocal -- 本币金额
    ,o.payreason -- 支付原因
    ,o.pk_auditor -- 业务单据审核人
    ,o.pk_billoperator -- 业务单据录入人
    ,o.pk_billtype -- 业务单据类型
    ,o.pk_billtypeid -- 业务单据类型ID
    ,o.pk_busibill -- 业务单据主键
    ,o.pk_busitype -- 业务类型
    ,o.pk_executor -- 结算人
    ,o.pk_ftsbill -- 资金单据主键
    ,o.pk_ftsbilltype -- 资金单据类型PK
    ,o.pk_group -- 所属集团
    ,o.pk_operator -- 录入人
    ,o.pk_org -- 财务组织
    ,o.pk_org_v -- 业务单元版本
    ,o.pk_pcorg -- 利润中心
    ,o.pk_pcorg_v -- 利润中心版本
    ,o.pk_settlement -- 结算信息主键
    ,o.pk_signer -- 签字确认人
    ,o.pk_tradetype -- 业务单交易类型
    ,o.pk_tradetypeid -- 交易类型
    ,o.primal -- 原币金额
    ,o.returnreason -- 资金组织退回原因
    ,o.reversalreason -- 退回原因
    ,o.saga_btxid -- 自定义
    ,o.saga_frozen -- 自定义
    ,o.saga_gtxid -- 自定义
    ,o.saga_status -- 自定义
    ,o.sddreversaldate -- 直接借记退回日期
    ,o.sddreversaler -- 直接借记退回人
    ,o.sddreversalflag -- 直接借记退回标记
    ,o.settlebilltype -- 结算单据类型
    ,o.settledate -- 结算日期
    ,o.settlenum -- 结算号
    ,o.settlestatus -- 结算状态
    ,o.settletype -- 完成结算方式
    ,o.signdate -- 签字确认日期
    ,o.structuredstandard -- 结构化信息标准
    ,o.systemcode -- 归属系统
    ,o.tradertypecode -- 交易类型编码
    ,o.ts -- 时间戳
    ,o.vbillstatus -- 审批状态
    ,o.start_dt -- 开始时间
    ,case when n.start_dt is not null then to_date('${batch_date}', 'yyyymmdd')
          when o.end_dt >= to_date('${batch_date}','yyyymmdd') then to_date('20991231','yyyymmdd')
          else o.end_dt
     end as end_dt -- 结束时间
    ,case when n.start_dt is not null
          then 'I'
          when o.end_dt >= to_date('${batch_date}','yyyymmdd')
          then 'I'
          else o.id_mark
     end as id_mark  -- 增删标志 
    ,o.etl_timestamp -- ETL处理时间
from ${iol_schema}.iers_cmp_settlement_bk o
    left join ${iol_schema}.iers_cmp_settlement_op n
        on
            o.pk_settlement = n.pk_settlement
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.iers_cmp_settlement_cl d
        on
            o.pk_settlement = d.pk_settlement
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
--truncate table ${iol_schema}.iers_cmp_settlement;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('iers_cmp_settlement') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.iers_cmp_settlement drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.iers_cmp_settlement add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.iers_cmp_settlement exchange partition p_${batch_date} with table ${iol_schema}.iers_cmp_settlement_cl;
alter table ${iol_schema}.iers_cmp_settlement exchange partition p_20991231 with table ${iol_schema}.iers_cmp_settlement_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.iers_cmp_settlement to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.iers_cmp_settlement_op purge;
drop table ${iol_schema}.iers_cmp_settlement_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.iers_cmp_settlement_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'iers_cmp_settlement',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
