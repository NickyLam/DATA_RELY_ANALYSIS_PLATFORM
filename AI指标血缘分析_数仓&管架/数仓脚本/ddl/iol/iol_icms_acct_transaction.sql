/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol icms_acct_transaction
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.icms_acct_transaction
whenever sqlerror continue none;
drop table ${iol_schema}.icms_acct_transaction purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.icms_acct_transaction(
    serialno varchar2(40) -- 交易流水号
    ,parenttransserialno varchar2(40) -- 关联交易流水号
    ,transcode varchar2(10) -- 交易代码
    ,relativeobjecttype varchar2(40) -- 关联对象类型
    ,relativeobjectno varchar2(40) -- 关联对象编号
    ,documenttype varchar2(40) -- 单据类型
    ,documentno varchar2(40) -- 单据流水号
    ,channelid varchar2(40) -- 交易渠道
    ,occurdate varchar2(10) -- 交易操作日期
    ,occurtime varchar2(20) -- 交易时间
    ,transdate varchar2(10) -- 交易日期
    ,transstatus varchar2(10) -- 交易状态(CodeNo:TransStatus)
    ,inputorgid varchar2(40) -- 录入机构
    ,inputuserid varchar2(40) -- 录入用户
    ,inputtime varchar2(20) -- 录入日期
    ,remark varchar2(4000) -- 备注
    ,log varchar2(4000) -- 其他日志
    ,fallbacktransserialno varchar2(40) -- 回退交易流水
    ,tellerserialno varchar2(48) -- 柜员流水号
    ,transsum number(24,6) -- 交易金额
    ,cnsmrsrlno varchar2(50) -- 消费方流水号(调用还款交易接口时的消费方流水号)
    ,accountingserialno varchar2(40) -- 唯一核心记账流水号
    ,transtype varchar2(8) -- 转让类型(福费廷转让使用)
    ,transoccurtype varchar2(10) -- 交易发生类型
    ,completeflag varchar2(1) -- 数据录入完整性标识
    ,migtflag varchar2(80) -- 迁移标志：crs rcr ilc upl
    ,graceinterestflag varchar2(10) -- 是否宽限利息
    ,graceprincipalflag varchar2(10) -- 是否宽限本金
    ,repayreason varchar2(200) -- 提前还款说明
    ,repaysource varchar2(200) -- 提前还款资金来源
    ,whethertorestructuretheloan varchar2(2) -- 是否重组贷款
    ,updatedate date -- 更新时间
    ,repayreasontype varchar2(10) -- 提前还款原因
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
grant select on ${iol_schema}.icms_acct_transaction to ${iml_schema};
grant select on ${iol_schema}.icms_acct_transaction to ${icl_schema};
grant select on ${iol_schema}.icms_acct_transaction to ${idl_schema};
grant select on ${iol_schema}.icms_acct_transaction to ${iel_schema};

-- comment
comment on table ${iol_schema}.icms_acct_transaction is '帐务-交易信息';
comment on column ${iol_schema}.icms_acct_transaction.serialno is '交易流水号';
comment on column ${iol_schema}.icms_acct_transaction.parenttransserialno is '关联交易流水号';
comment on column ${iol_schema}.icms_acct_transaction.transcode is '交易代码';
comment on column ${iol_schema}.icms_acct_transaction.relativeobjecttype is '关联对象类型';
comment on column ${iol_schema}.icms_acct_transaction.relativeobjectno is '关联对象编号';
comment on column ${iol_schema}.icms_acct_transaction.documenttype is '单据类型';
comment on column ${iol_schema}.icms_acct_transaction.documentno is '单据流水号';
comment on column ${iol_schema}.icms_acct_transaction.channelid is '交易渠道';
comment on column ${iol_schema}.icms_acct_transaction.occurdate is '交易操作日期';
comment on column ${iol_schema}.icms_acct_transaction.occurtime is '交易时间';
comment on column ${iol_schema}.icms_acct_transaction.transdate is '交易日期';
comment on column ${iol_schema}.icms_acct_transaction.transstatus is '交易状态(CodeNo:TransStatus)';
comment on column ${iol_schema}.icms_acct_transaction.inputorgid is '录入机构';
comment on column ${iol_schema}.icms_acct_transaction.inputuserid is '录入用户';
comment on column ${iol_schema}.icms_acct_transaction.inputtime is '录入日期';
comment on column ${iol_schema}.icms_acct_transaction.remark is '备注';
comment on column ${iol_schema}.icms_acct_transaction.log is '其他日志';
comment on column ${iol_schema}.icms_acct_transaction.fallbacktransserialno is '回退交易流水';
comment on column ${iol_schema}.icms_acct_transaction.tellerserialno is '柜员流水号';
comment on column ${iol_schema}.icms_acct_transaction.transsum is '交易金额';
comment on column ${iol_schema}.icms_acct_transaction.cnsmrsrlno is '消费方流水号(调用还款交易接口时的消费方流水号)';
comment on column ${iol_schema}.icms_acct_transaction.accountingserialno is '唯一核心记账流水号';
comment on column ${iol_schema}.icms_acct_transaction.transtype is '转让类型(福费廷转让使用)';
comment on column ${iol_schema}.icms_acct_transaction.transoccurtype is '交易发生类型';
comment on column ${iol_schema}.icms_acct_transaction.completeflag is '数据录入完整性标识';
comment on column ${iol_schema}.icms_acct_transaction.migtflag is '迁移标志：CRS RCR ILC UPL';
comment on column ${iol_schema}.icms_acct_transaction.graceinterestflag is '是否宽限利息';
comment on column ${iol_schema}.icms_acct_transaction.graceprincipalflag is '是否宽限本金';
comment on column ${iol_schema}.icms_acct_transaction.repayreason is '提前还款说明';
comment on column ${iol_schema}.icms_acct_transaction.repaysource is '提前还款资金来源';
comment on column ${iol_schema}.icms_acct_transaction.whethertorestructuretheloan is '是否重组贷款';
comment on column ${iol_schema}.icms_acct_transaction.updatedate is '更新时间';
comment on column ${iol_schema}.icms_acct_transaction.repayreasontype is '提前还款原因';
comment on column ${iol_schema}.icms_acct_transaction.start_dt is '开始时间';
comment on column ${iol_schema}.icms_acct_transaction.end_dt is '结束时间';
comment on column ${iol_schema}.icms_acct_transaction.id_mark is '增删标志';
comment on column ${iol_schema}.icms_acct_transaction.etl_timestamp is 'ETL处理时间戳';
