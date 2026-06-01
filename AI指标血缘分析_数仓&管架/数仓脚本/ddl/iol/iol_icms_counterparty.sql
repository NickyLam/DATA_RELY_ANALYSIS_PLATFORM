/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol icms_counterparty
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.icms_counterparty
whenever sqlerror continue none;
drop table ${iol_schema}.icms_counterparty purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.icms_counterparty(
    serialno varchar2(40) -- 流水号
    ,relativeid varchar2(32) -- 关联客户编号
    ,relationship varchar2(18) -- 关联关系
    ,settlementtype varchar2(100) -- 与受信人的结算方式
    ,certid varchar2(60) -- 证件号码
    ,output number(24,6) -- 上年实际产量
    ,customername varchar2(200) -- 客户名称
    ,income number(24,6) -- 上年销售收入（万元）
    ,isrelationship varchar2(4) -- 与受信人有无关联关系
    ,businessvalue number(24,6) -- 与受信人的年交易量
    ,businesstime varchar2(32) -- 与受信人合作时间
    ,inputuserid varchar2(32) -- 登记人ID
    ,situation varchar2(400) -- 在我行授信情况
    ,inputtime varchar2(20) -- 登记时间
    ,position varchar2(400) -- 行业地位
    ,migtflag varchar2(80) -- 
    ,updatetime varchar2(20) -- 更新时间
    ,customerid varchar2(32) -- 客户编号
    ,certtype varchar2(18) -- 证件类型
    ,inputuser varchar2(32) -- 登记人
    ,updateuser varchar2(32) -- 更新人
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
grant select on ${iol_schema}.icms_counterparty to ${iml_schema};
grant select on ${iol_schema}.icms_counterparty to ${icl_schema};
grant select on ${iol_schema}.icms_counterparty to ${idl_schema};
grant select on ${iol_schema}.icms_counterparty to ${iel_schema};

-- comment
comment on table ${iol_schema}.icms_counterparty is '交易对手信息';
comment on column ${iol_schema}.icms_counterparty.serialno is '流水号';
comment on column ${iol_schema}.icms_counterparty.relativeid is '关联客户编号';
comment on column ${iol_schema}.icms_counterparty.relationship is '关联关系';
comment on column ${iol_schema}.icms_counterparty.settlementtype is '与受信人的结算方式';
comment on column ${iol_schema}.icms_counterparty.certid is '证件号码';
comment on column ${iol_schema}.icms_counterparty.output is '上年实际产量';
comment on column ${iol_schema}.icms_counterparty.customername is '客户名称';
comment on column ${iol_schema}.icms_counterparty.income is '上年销售收入（万元）';
comment on column ${iol_schema}.icms_counterparty.isrelationship is '与受信人有无关联关系';
comment on column ${iol_schema}.icms_counterparty.businessvalue is '与受信人的年交易量';
comment on column ${iol_schema}.icms_counterparty.businesstime is '与受信人合作时间';
comment on column ${iol_schema}.icms_counterparty.inputuserid is '登记人ID';
comment on column ${iol_schema}.icms_counterparty.situation is '在我行授信情况';
comment on column ${iol_schema}.icms_counterparty.inputtime is '登记时间';
comment on column ${iol_schema}.icms_counterparty.position is '行业地位';
comment on column ${iol_schema}.icms_counterparty.migtflag is '';
comment on column ${iol_schema}.icms_counterparty.updatetime is '更新时间';
comment on column ${iol_schema}.icms_counterparty.customerid is '客户编号';
comment on column ${iol_schema}.icms_counterparty.certtype is '证件类型';
comment on column ${iol_schema}.icms_counterparty.inputuser is '登记人';
comment on column ${iol_schema}.icms_counterparty.updateuser is '更新人';
comment on column ${iol_schema}.icms_counterparty.start_dt is '开始时间';
comment on column ${iol_schema}.icms_counterparty.end_dt is '结束时间';
comment on column ${iol_schema}.icms_counterparty.id_mark is '增删标志';
comment on column ${iol_schema}.icms_counterparty.etl_timestamp is 'ETL处理时间戳';
