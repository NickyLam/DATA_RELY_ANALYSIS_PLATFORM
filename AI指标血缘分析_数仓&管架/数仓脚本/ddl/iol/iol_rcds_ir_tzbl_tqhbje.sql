/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol rcds_ir_tzbl_tqhbje
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.rcds_ir_tzbl_tqhbje
whenever sqlerror continue none;
drop table ${iol_schema}.rcds_ir_tzbl_tqhbje purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.rcds_ir_tzbl_tqhbje(
    key_id varchar2(60) -- 主键
    ,loan_no varchar2(60) -- 借据号
    ,data_dt varchar2(10) -- 数据日期
    ,loan_biz_type_cd varchar2(30) -- 业务品种代码
    ,var0601 number(18,2) -- 当前月提前还本金额
    ,var0602 number(11,7) -- 当前月提前还本金额占贷款金额的百分比
    ,var0603 number(18,2) -- 过去3个月提前还款金额的平均值
    ,var0604 number(18,2) -- 过去6个月提前还款金额的平均值
    ,var0605 number(18,2) -- 过去12个月提前还款金额的平均值
    ,var0606 number(18,2) -- 过去3个月提前还款金额的总和
    ,var0607 number(18,2) -- 过去6个月提前还款金额的总和
    ,var0608 number(18,2) -- 过去12个月提前还款金额的总和
    ,var0609 number(22) -- 过去3个月提前还款的月份数
    ,var0610 number(22) -- 过去6个月提前还款的月份数
    ,var0611 number(22) -- 过去12个月提前还款的月份数
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
grant select on ${iol_schema}.rcds_ir_tzbl_tqhbje to ${iml_schema};
grant select on ${iol_schema}.rcds_ir_tzbl_tqhbje to ${icl_schema};
grant select on ${iol_schema}.rcds_ir_tzbl_tqhbje to ${idl_schema};
grant select on ${iol_schema}.rcds_ir_tzbl_tqhbje to ${iel_schema};

-- comment
comment on table ${iol_schema}.rcds_ir_tzbl_tqhbje is '特征变量表_提前还本金额';
comment on column ${iol_schema}.rcds_ir_tzbl_tqhbje.key_id is '主键';
comment on column ${iol_schema}.rcds_ir_tzbl_tqhbje.loan_no is '借据号';
comment on column ${iol_schema}.rcds_ir_tzbl_tqhbje.data_dt is '数据日期';
comment on column ${iol_schema}.rcds_ir_tzbl_tqhbje.loan_biz_type_cd is '业务品种代码';
comment on column ${iol_schema}.rcds_ir_tzbl_tqhbje.var0601 is '当前月提前还本金额';
comment on column ${iol_schema}.rcds_ir_tzbl_tqhbje.var0602 is '当前月提前还本金额占贷款金额的百分比';
comment on column ${iol_schema}.rcds_ir_tzbl_tqhbje.var0603 is '过去3个月提前还款金额的平均值';
comment on column ${iol_schema}.rcds_ir_tzbl_tqhbje.var0604 is '过去6个月提前还款金额的平均值';
comment on column ${iol_schema}.rcds_ir_tzbl_tqhbje.var0605 is '过去12个月提前还款金额的平均值';
comment on column ${iol_schema}.rcds_ir_tzbl_tqhbje.var0606 is '过去3个月提前还款金额的总和';
comment on column ${iol_schema}.rcds_ir_tzbl_tqhbje.var0607 is '过去6个月提前还款金额的总和';
comment on column ${iol_schema}.rcds_ir_tzbl_tqhbje.var0608 is '过去12个月提前还款金额的总和';
comment on column ${iol_schema}.rcds_ir_tzbl_tqhbje.var0609 is '过去3个月提前还款的月份数';
comment on column ${iol_schema}.rcds_ir_tzbl_tqhbje.var0610 is '过去6个月提前还款的月份数';
comment on column ${iol_schema}.rcds_ir_tzbl_tqhbje.var0611 is '过去12个月提前还款的月份数';
comment on column ${iol_schema}.rcds_ir_tzbl_tqhbje.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.rcds_ir_tzbl_tqhbje.etl_timestamp is 'ETL处理时间戳';
