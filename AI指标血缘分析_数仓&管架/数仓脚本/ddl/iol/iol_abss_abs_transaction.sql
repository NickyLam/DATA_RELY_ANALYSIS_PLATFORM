/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol abss_abs_transaction
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.abss_abs_transaction
whenever sqlerror continue none;
drop table ${iol_schema}.abss_abs_transaction purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.abss_abs_transaction(
    serialno varchar2(60) -- 交易流水号
    ,parenttransserialno varchar2(60) -- 关联交易流水号
    ,transcode varchar2(15) -- 交易代码(Transaction-abs-Config.xml
    ,relativeobjecttype varchar2(60) -- 关联对象类型
    ,relativeobjectno varchar2(60) -- 关联对象编号
    ,documenttype varchar2(60) -- 单据类型
    ,documentno varchar2(60) -- 单据流水号
    ,channelid varchar2(30) -- 交易渠道
    ,occurdate varchar2(15) -- 交易操作日期
    ,occurtime varchar2(30) -- 交易时间
    ,transdate varchar2(15) -- 交易日期
    ,transstatus varchar2(15) -- 交易状态
    ,inputorgid varchar2(60) -- 录入机构
    ,inputuserid varchar2(60) -- 录入人
    ,inputtime varchar2(30) -- 录入时间
    ,remark varchar2(600) -- 描述
    ,log varchar2(600) -- 其他日志
    ,fallbacktransserialno varchar2(60) -- 回退交易流水号
    ,sceneid varchar2(60) -- 情景编号
    ,trancherate1 varchar2(60) -- 分档利率A
    ,trancherate2 varchar2(60) -- 分档利率B
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
grant select on ${iol_schema}.abss_abs_transaction to ${iml_schema};
grant select on ${iol_schema}.abss_abs_transaction to ${icl_schema};
grant select on ${iol_schema}.abss_abs_transaction to ${idl_schema};
grant select on ${iol_schema}.abss_abs_transaction to ${iel_schema};

-- comment
comment on table ${iol_schema}.abss_abs_transaction is '交易表';
comment on column ${iol_schema}.abss_abs_transaction.serialno is '交易流水号';
comment on column ${iol_schema}.abss_abs_transaction.parenttransserialno is '关联交易流水号';
comment on column ${iol_schema}.abss_abs_transaction.transcode is '交易代码(Transaction-abs-Config.xml';
comment on column ${iol_schema}.abss_abs_transaction.relativeobjecttype is '关联对象类型';
comment on column ${iol_schema}.abss_abs_transaction.relativeobjectno is '关联对象编号';
comment on column ${iol_schema}.abss_abs_transaction.documenttype is '单据类型';
comment on column ${iol_schema}.abss_abs_transaction.documentno is '单据流水号';
comment on column ${iol_schema}.abss_abs_transaction.channelid is '交易渠道';
comment on column ${iol_schema}.abss_abs_transaction.occurdate is '交易操作日期';
comment on column ${iol_schema}.abss_abs_transaction.occurtime is '交易时间';
comment on column ${iol_schema}.abss_abs_transaction.transdate is '交易日期';
comment on column ${iol_schema}.abss_abs_transaction.transstatus is '交易状态';
comment on column ${iol_schema}.abss_abs_transaction.inputorgid is '录入机构';
comment on column ${iol_schema}.abss_abs_transaction.inputuserid is '录入人';
comment on column ${iol_schema}.abss_abs_transaction.inputtime is '录入时间';
comment on column ${iol_schema}.abss_abs_transaction.remark is '描述';
comment on column ${iol_schema}.abss_abs_transaction.log is '其他日志';
comment on column ${iol_schema}.abss_abs_transaction.fallbacktransserialno is '回退交易流水号';
comment on column ${iol_schema}.abss_abs_transaction.sceneid is '情景编号';
comment on column ${iol_schema}.abss_abs_transaction.trancherate1 is '分档利率A';
comment on column ${iol_schema}.abss_abs_transaction.trancherate2 is '分档利率B';
comment on column ${iol_schema}.abss_abs_transaction.start_dt is '开始时间';
comment on column ${iol_schema}.abss_abs_transaction.end_dt is '结束时间';
comment on column ${iol_schema}.abss_abs_transaction.id_mark is '增删标志';
comment on column ${iol_schema}.abss_abs_transaction.etl_timestamp is 'ETL处理时间戳';
