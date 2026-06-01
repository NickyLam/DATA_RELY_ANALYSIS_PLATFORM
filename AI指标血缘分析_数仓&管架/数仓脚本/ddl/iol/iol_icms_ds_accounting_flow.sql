/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol icms_ds_accounting_flow
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.icms_ds_accounting_flow
whenever sqlerror continue none;
drop table ${iol_schema}.icms_ds_accounting_flow purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.icms_ds_accounting_flow(
    org varchar2(12) -- 内部机构号
    ,cpstxnseq varchar2(36) -- 核心交易流水
    ,cardno varchar2(19) -- 卡号
    ,currcd varchar2(3) -- 币种
    ,txncode varchar2(4) -- 交易码
    ,txndesc varchar2(80) -- 交易描述
    ,dbcrind varchar2(1) -- 借贷标记
    ,postamt number(15,2) -- 入账金额
    ,postglind varchar2(1) -- 入账方式
    ,owningbranch varchar2(9) -- 支行
    ,subject varchar2(40) -- 科目
    ,redflag varchar2(1) -- 红蓝字标识
    ,queue number(20) -- 排序
    ,productcd varchar2(12) -- 产品号
    ,refnbr varchar2(23) -- 借据号
    ,agegroup varchar2(1) -- 账龄组
    ,plannbr varchar2(6) -- 信用计划号
    ,bnpgroup varchar2(2) -- 余额成分组
    ,bankgroupid varchar2(5) -- 参贷方案代码
    ,bankno varchar2(10) -- 银行代码
    ,term number(38) -- 期数
    ,batchdate date -- 批量
    ,etl_dt date -- ETL处理日期
    ,etl_timestamp timestamp -- ETL处理时间戳
)
partition by list(etl_dt)(
    partition p_19000101 values (to_date('19000101','yyyymmdd'))
)
storage (initial 64k next 64k)
compress ${option_switch} for query high
nologging
;

-- grant
grant select on ${iol_schema}.icms_ds_accounting_flow to ${iml_schema};
grant select on ${iol_schema}.icms_ds_accounting_flow to ${icl_schema};
grant select on ${iol_schema}.icms_ds_accounting_flow to ${idl_schema};
grant select on ${iol_schema}.icms_ds_accounting_flow to ${iel_schema};

-- comment
comment on table ${iol_schema}.icms_ds_accounting_flow is '微粒贷会计分录日报表';
comment on column ${iol_schema}.icms_ds_accounting_flow.org is '内部机构号';
comment on column ${iol_schema}.icms_ds_accounting_flow.cpstxnseq is '核心交易流水';
comment on column ${iol_schema}.icms_ds_accounting_flow.cardno is '卡号';
comment on column ${iol_schema}.icms_ds_accounting_flow.currcd is '币种';
comment on column ${iol_schema}.icms_ds_accounting_flow.txncode is '交易码';
comment on column ${iol_schema}.icms_ds_accounting_flow.txndesc is '交易描述';
comment on column ${iol_schema}.icms_ds_accounting_flow.dbcrind is '借贷标记';
comment on column ${iol_schema}.icms_ds_accounting_flow.postamt is '入账金额';
comment on column ${iol_schema}.icms_ds_accounting_flow.postglind is '入账方式';
comment on column ${iol_schema}.icms_ds_accounting_flow.owningbranch is '支行';
comment on column ${iol_schema}.icms_ds_accounting_flow.subject is '科目';
comment on column ${iol_schema}.icms_ds_accounting_flow.redflag is '红蓝字标识';
comment on column ${iol_schema}.icms_ds_accounting_flow.queue is '排序';
comment on column ${iol_schema}.icms_ds_accounting_flow.productcd is '产品号';
comment on column ${iol_schema}.icms_ds_accounting_flow.refnbr is '借据号';
comment on column ${iol_schema}.icms_ds_accounting_flow.agegroup is '账龄组';
comment on column ${iol_schema}.icms_ds_accounting_flow.plannbr is '信用计划号';
comment on column ${iol_schema}.icms_ds_accounting_flow.bnpgroup is '余额成分组';
comment on column ${iol_schema}.icms_ds_accounting_flow.bankgroupid is '参贷方案代码';
comment on column ${iol_schema}.icms_ds_accounting_flow.bankno is '银行代码';
comment on column ${iol_schema}.icms_ds_accounting_flow.term is '期数';
comment on column ${iol_schema}.icms_ds_accounting_flow.batchdate is '批量';
comment on column ${iol_schema}.icms_ds_accounting_flow.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.icms_ds_accounting_flow.etl_timestamp is 'ETL处理时间戳';
