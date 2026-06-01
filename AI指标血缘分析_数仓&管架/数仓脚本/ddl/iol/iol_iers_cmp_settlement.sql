/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol iers_cmp_settlement
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.iers_cmp_settlement
whenever sqlerror continue none;
drop table ${iol_schema}.iers_cmp_settlement purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.iers_cmp_settlement(
    aduitstatus number(38,0) -- 业务单据审批状态
    ,approvedate varchar2(29) -- 审批日期
    ,approver varchar2(30) -- 审批人
    ,arithmetic number(38,0) -- 结算信息处理算法
    ,backreason varchar2(75) -- 自定义
    ,billcode varchar2(60) -- 业务单据编号
    ,busi_auditdate varchar2(29) -- 业务单据审核日期
    ,busi_billdate varchar2(29) -- 业务单据日期
    ,busistatus number(38,0) -- 业务单据状态
    ,code varchar2(1536) -- 数字签名
    ,commitdate varchar2(29) -- 提交日期
    ,commiter varchar2(30) -- 提交人
    ,commpaybegindate varchar2(29) -- 承付开始日期
    ,commpayenddate varchar2(29) -- 承付结束日期
    ,consignagreement varchar2(75) -- 托收协议号
    ,costcenter varchar2(30) -- 成本中心
    ,creationtime varchar2(29) -- 创建时间
    ,creator varchar2(30) -- 创建人
    ,creditorreference varchar2(300) -- 结构化贷方引用信息
    ,def1 varchar2(152) -- 自定义项1
    ,def10 varchar2(152) -- 自定义项10
    ,def11 varchar2(152) -- 自定义项11
    ,def12 varchar2(152) -- 自定义项12
    ,def13 varchar2(152) -- 自定义项13
    ,def14 varchar2(152) -- 自定义项14
    ,def15 varchar2(152) -- 自定义项15
    ,def16 varchar2(152) -- 自定义项16
    ,def17 varchar2(152) -- 自定义项17
    ,def18 varchar2(152) -- 自定义项18
    ,def19 varchar2(152) -- 自定义项19
    ,def2 varchar2(152) -- 自定义项2
    ,def20 varchar2(152) -- 自定义项20
    ,def3 varchar2(152) -- 自定义项3
    ,def4 varchar2(4000) -- 自定义项4
    ,def5 varchar2(152) -- 自定义项5
    ,def6 varchar2(152) -- 自定义项6
    ,def7 varchar2(152) -- 自定义项7
    ,def8 varchar2(152) -- 自定义项8
    ,def9 varchar2(152) -- 自定义项9
    ,direction number(38,0) -- 方向
    ,dr number(10,0) -- 删除标志
    ,effectstatus number(38,0) -- 业务单据生效状态
    ,expectdealdate varchar2(29) -- 期望处理日
    ,fts_billtype varchar2(30) -- 资金单据类型
    ,globaloacl number(28,8) -- 全局本币
    ,grouplocal number(28,8) -- 集团本币
    ,invoiceno varchar2(210) -- 非结构化贷方引用信息
    ,isautosign varchar2(2) -- 是否自动签字
    ,isback varchar2(2) -- 自定义
    ,isbusieffect varchar2(2) -- 业务单据是否已生效
    ,iscommpay varchar2(2) -- 是否需承付
    ,ishadbeenreturned varchar2(2) -- 是否曾经被退回
    ,isindependent varchar2(2) -- 是否独立生成
    ,isreset varchar2(2) -- 是否红冲单据
    ,isreturned varchar2(2) -- 是否退回标志
    ,issettleeffect varchar2(2) -- 结算单是否生效
    ,isverify varchar2(2) -- 是否进行上一环节验签
    ,lastupdatedate varchar2(29) -- 最新更新日期
    ,lastupdater varchar2(30) -- 最新更新人
    ,modifiedtime varchar2(29) -- 修改时间
    ,modifier varchar2(30) -- 修改人
    ,ntberrmsg varchar2(300) -- 自定义
    ,orglocal number(28,8) -- 本币金额
    ,payreason varchar2(272) -- 支付原因
    ,pk_auditor varchar2(30) -- 业务单据审核人
    ,pk_billoperator varchar2(30) -- 业务单据录入人
    ,pk_billtype varchar2(30) -- 业务单据类型
    ,pk_billtypeid varchar2(30) -- 业务单据类型id
    ,pk_busibill varchar2(30) -- 业务单据主键
    ,pk_busitype varchar2(75) -- 业务类型
    ,pk_executor varchar2(30) -- 结算人
    ,pk_ftsbill varchar2(30) -- 资金单据主键
    ,pk_ftsbilltype varchar2(30) -- 资金单据类型pk
    ,pk_group varchar2(30) -- 所属集团
    ,pk_operator varchar2(30) -- 录入人
    ,pk_org varchar2(30) -- 财务组织
    ,pk_org_v varchar2(30) -- 业务单元版本
    ,pk_pcorg varchar2(30) -- 利润中心
    ,pk_pcorg_v varchar2(30) -- 利润中心版本
    ,pk_settlement varchar2(30) -- 结算信息主键
    ,pk_signer varchar2(30) -- 签字确认人
    ,pk_tradetype varchar2(30) -- 业务单交易类型
    ,pk_tradetypeid varchar2(30) -- 交易类型
    ,primal number(28,8) -- 原币金额
    ,returnreason varchar2(408) -- 资金组织退回原因
    ,reversalreason varchar2(272) -- 退回原因
    ,saga_btxid varchar2(96) -- 自定义
    ,saga_frozen number(38,0) -- 自定义
    ,saga_gtxid varchar2(96) -- 自定义
    ,saga_status number(38,0) -- 自定义
    ,sddreversaldate varchar2(29) -- 直接借记退回日期
    ,sddreversaler varchar2(30) -- 直接借记退回人
    ,sddreversalflag varchar2(2) -- 直接借记退回标记
    ,settlebilltype varchar2(75) -- 结算单据类型
    ,settledate varchar2(29) -- 结算日期
    ,settlenum varchar2(45) -- 结算号
    ,settlestatus number(38,0) -- 结算状态
    ,settletype number(38,0) -- 完成结算方式
    ,signdate varchar2(29) -- 签字确认日期
    ,structuredstandard varchar2(75) -- 结构化信息标准
    ,systemcode varchar2(30) -- 归属系统
    ,tradertypecode varchar2(75) -- 交易类型编码
    ,ts varchar2(29) -- 时间戳
    ,vbillstatus number(38,0) -- 审批状态
    ,start_dt date -- 开始时间
    ,end_dt date -- 结束时间
    ,id_mark varchar2(10) -- 增删标志
    ,etl_timestamp timestamp -- ETL处理时间戳
)
partition by list(end_dt)(
     partition p_19000101 values (to_date('19000101','yyyymmdd')),
     partition p_20991231 values (to_date('20991231','yyyymmdd'))
)
storage (initial 1024k next 1024k)
compress ${option_switch} for query high
nologging
;

-- grant
grant select on ${iol_schema}.iers_cmp_settlement to ${iml_schema};
grant select on ${iol_schema}.iers_cmp_settlement to ${icl_schema};
grant select on ${iol_schema}.iers_cmp_settlement to ${idl_schema};
grant select on ${iol_schema}.iers_cmp_settlement to ${iel_schema};

-- comment
comment on table ${iol_schema}.iers_cmp_settlement is '结算情况表';
comment on column ${iol_schema}.iers_cmp_settlement.aduitstatus is '业务单据审批状态';
comment on column ${iol_schema}.iers_cmp_settlement.approvedate is '审批日期';
comment on column ${iol_schema}.iers_cmp_settlement.approver is '审批人';
comment on column ${iol_schema}.iers_cmp_settlement.arithmetic is '结算信息处理算法';
comment on column ${iol_schema}.iers_cmp_settlement.backreason is '自定义';
comment on column ${iol_schema}.iers_cmp_settlement.billcode is '业务单据编号';
comment on column ${iol_schema}.iers_cmp_settlement.busi_auditdate is '业务单据审核日期';
comment on column ${iol_schema}.iers_cmp_settlement.busi_billdate is '业务单据日期';
comment on column ${iol_schema}.iers_cmp_settlement.busistatus is '业务单据状态';
comment on column ${iol_schema}.iers_cmp_settlement.code is '数字签名';
comment on column ${iol_schema}.iers_cmp_settlement.commitdate is '提交日期';
comment on column ${iol_schema}.iers_cmp_settlement.commiter is '提交人';
comment on column ${iol_schema}.iers_cmp_settlement.commpaybegindate is '承付开始日期';
comment on column ${iol_schema}.iers_cmp_settlement.commpayenddate is '承付结束日期';
comment on column ${iol_schema}.iers_cmp_settlement.consignagreement is '托收协议号';
comment on column ${iol_schema}.iers_cmp_settlement.costcenter is '成本中心';
comment on column ${iol_schema}.iers_cmp_settlement.creationtime is '创建时间';
comment on column ${iol_schema}.iers_cmp_settlement.creator is '创建人';
comment on column ${iol_schema}.iers_cmp_settlement.creditorreference is '结构化贷方引用信息';
comment on column ${iol_schema}.iers_cmp_settlement.def1 is '自定义项1';
comment on column ${iol_schema}.iers_cmp_settlement.def10 is '自定义项10';
comment on column ${iol_schema}.iers_cmp_settlement.def11 is '自定义项11';
comment on column ${iol_schema}.iers_cmp_settlement.def12 is '自定义项12';
comment on column ${iol_schema}.iers_cmp_settlement.def13 is '自定义项13';
comment on column ${iol_schema}.iers_cmp_settlement.def14 is '自定义项14';
comment on column ${iol_schema}.iers_cmp_settlement.def15 is '自定义项15';
comment on column ${iol_schema}.iers_cmp_settlement.def16 is '自定义项16';
comment on column ${iol_schema}.iers_cmp_settlement.def17 is '自定义项17';
comment on column ${iol_schema}.iers_cmp_settlement.def18 is '自定义项18';
comment on column ${iol_schema}.iers_cmp_settlement.def19 is '自定义项19';
comment on column ${iol_schema}.iers_cmp_settlement.def2 is '自定义项2';
comment on column ${iol_schema}.iers_cmp_settlement.def20 is '自定义项20';
comment on column ${iol_schema}.iers_cmp_settlement.def3 is '自定义项3';
comment on column ${iol_schema}.iers_cmp_settlement.def4 is '自定义项4';
comment on column ${iol_schema}.iers_cmp_settlement.def5 is '自定义项5';
comment on column ${iol_schema}.iers_cmp_settlement.def6 is '自定义项6';
comment on column ${iol_schema}.iers_cmp_settlement.def7 is '自定义项7';
comment on column ${iol_schema}.iers_cmp_settlement.def8 is '自定义项8';
comment on column ${iol_schema}.iers_cmp_settlement.def9 is '自定义项9';
comment on column ${iol_schema}.iers_cmp_settlement.direction is '方向';
comment on column ${iol_schema}.iers_cmp_settlement.dr is '删除标志';
comment on column ${iol_schema}.iers_cmp_settlement.effectstatus is '业务单据生效状态';
comment on column ${iol_schema}.iers_cmp_settlement.expectdealdate is '期望处理日';
comment on column ${iol_schema}.iers_cmp_settlement.fts_billtype is '资金单据类型';
comment on column ${iol_schema}.iers_cmp_settlement.globaloacl is '全局本币';
comment on column ${iol_schema}.iers_cmp_settlement.grouplocal is '集团本币';
comment on column ${iol_schema}.iers_cmp_settlement.invoiceno is '非结构化贷方引用信息';
comment on column ${iol_schema}.iers_cmp_settlement.isautosign is '是否自动签字';
comment on column ${iol_schema}.iers_cmp_settlement.isback is '自定义';
comment on column ${iol_schema}.iers_cmp_settlement.isbusieffect is '业务单据是否已生效';
comment on column ${iol_schema}.iers_cmp_settlement.iscommpay is '是否需承付';
comment on column ${iol_schema}.iers_cmp_settlement.ishadbeenreturned is '是否曾经被退回';
comment on column ${iol_schema}.iers_cmp_settlement.isindependent is '是否独立生成';
comment on column ${iol_schema}.iers_cmp_settlement.isreset is '是否红冲单据';
comment on column ${iol_schema}.iers_cmp_settlement.isreturned is '是否退回标志';
comment on column ${iol_schema}.iers_cmp_settlement.issettleeffect is '结算单是否生效';
comment on column ${iol_schema}.iers_cmp_settlement.isverify is '是否进行上一环节验签';
comment on column ${iol_schema}.iers_cmp_settlement.lastupdatedate is '最新更新日期';
comment on column ${iol_schema}.iers_cmp_settlement.lastupdater is '最新更新人';
comment on column ${iol_schema}.iers_cmp_settlement.modifiedtime is '修改时间';
comment on column ${iol_schema}.iers_cmp_settlement.modifier is '修改人';
comment on column ${iol_schema}.iers_cmp_settlement.ntberrmsg is '自定义';
comment on column ${iol_schema}.iers_cmp_settlement.orglocal is '本币金额';
comment on column ${iol_schema}.iers_cmp_settlement.payreason is '支付原因';
comment on column ${iol_schema}.iers_cmp_settlement.pk_auditor is '业务单据审核人';
comment on column ${iol_schema}.iers_cmp_settlement.pk_billoperator is '业务单据录入人';
comment on column ${iol_schema}.iers_cmp_settlement.pk_billtype is '业务单据类型';
comment on column ${iol_schema}.iers_cmp_settlement.pk_billtypeid is '业务单据类型id';
comment on column ${iol_schema}.iers_cmp_settlement.pk_busibill is '业务单据主键';
comment on column ${iol_schema}.iers_cmp_settlement.pk_busitype is '业务类型';
comment on column ${iol_schema}.iers_cmp_settlement.pk_executor is '结算人';
comment on column ${iol_schema}.iers_cmp_settlement.pk_ftsbill is '资金单据主键';
comment on column ${iol_schema}.iers_cmp_settlement.pk_ftsbilltype is '资金单据类型pk';
comment on column ${iol_schema}.iers_cmp_settlement.pk_group is '所属集团';
comment on column ${iol_schema}.iers_cmp_settlement.pk_operator is '录入人';
comment on column ${iol_schema}.iers_cmp_settlement.pk_org is '财务组织';
comment on column ${iol_schema}.iers_cmp_settlement.pk_org_v is '业务单元版本';
comment on column ${iol_schema}.iers_cmp_settlement.pk_pcorg is '利润中心';
comment on column ${iol_schema}.iers_cmp_settlement.pk_pcorg_v is '利润中心版本';
comment on column ${iol_schema}.iers_cmp_settlement.pk_settlement is '结算信息主键';
comment on column ${iol_schema}.iers_cmp_settlement.pk_signer is '签字确认人';
comment on column ${iol_schema}.iers_cmp_settlement.pk_tradetype is '业务单交易类型';
comment on column ${iol_schema}.iers_cmp_settlement.pk_tradetypeid is '交易类型';
comment on column ${iol_schema}.iers_cmp_settlement.primal is '原币金额';
comment on column ${iol_schema}.iers_cmp_settlement.returnreason is '资金组织退回原因';
comment on column ${iol_schema}.iers_cmp_settlement.reversalreason is '退回原因';
comment on column ${iol_schema}.iers_cmp_settlement.saga_btxid is '自定义';
comment on column ${iol_schema}.iers_cmp_settlement.saga_frozen is '自定义';
comment on column ${iol_schema}.iers_cmp_settlement.saga_gtxid is '自定义';
comment on column ${iol_schema}.iers_cmp_settlement.saga_status is '自定义';
comment on column ${iol_schema}.iers_cmp_settlement.sddreversaldate is '直接借记退回日期';
comment on column ${iol_schema}.iers_cmp_settlement.sddreversaler is '直接借记退回人';
comment on column ${iol_schema}.iers_cmp_settlement.sddreversalflag is '直接借记退回标记';
comment on column ${iol_schema}.iers_cmp_settlement.settlebilltype is '结算单据类型';
comment on column ${iol_schema}.iers_cmp_settlement.settledate is '结算日期';
comment on column ${iol_schema}.iers_cmp_settlement.settlenum is '结算号';
comment on column ${iol_schema}.iers_cmp_settlement.settlestatus is '结算状态';
comment on column ${iol_schema}.iers_cmp_settlement.settletype is '完成结算方式';
comment on column ${iol_schema}.iers_cmp_settlement.signdate is '签字确认日期';
comment on column ${iol_schema}.iers_cmp_settlement.structuredstandard is '结构化信息标准';
comment on column ${iol_schema}.iers_cmp_settlement.systemcode is '归属系统';
comment on column ${iol_schema}.iers_cmp_settlement.tradertypecode is '交易类型编码';
comment on column ${iol_schema}.iers_cmp_settlement.ts is '时间戳';
comment on column ${iol_schema}.iers_cmp_settlement.vbillstatus is '审批状态';
comment on column ${iol_schema}.iers_cmp_settlement.start_dt is '开始时间';
comment on column ${iol_schema}.iers_cmp_settlement.end_dt is '结束时间';
comment on column ${iol_schema}.iers_cmp_settlement.id_mark is '增删标志';
comment on column ${iol_schema}.iers_cmp_settlement.etl_timestamp is 'ETL处理时间戳';
