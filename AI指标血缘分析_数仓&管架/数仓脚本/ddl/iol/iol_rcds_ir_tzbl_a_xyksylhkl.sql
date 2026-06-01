/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol rcds_ir_tzbl_a_xyksylhkl
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.rcds_ir_tzbl_a_xyksylhkl
whenever sqlerror continue none;
drop table ${iol_schema}.rcds_ir_tzbl_a_xyksylhkl purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.rcds_ir_tzbl_a_xyksylhkl(
    grade_key_id varchar2(60) -- 申请评分流水号
    ,data_time varchar2(20) -- 数据记录时间
    ,serialno varchar2(40) -- 申请流水号
    ,create_time varchar2(20) -- 创建时间
    ,repayment number(24,6) -- 信用卡本月实还总金额/总已用额度
    ,bill_repayment number(24,6) -- 信用卡本月实还总金额/上一期账单最低应还款总额
    ,agv_utilization number(24,6) -- 信用卡已用额度/信用卡授信共享额度
    ,start_dt date -- 开始时间
    ,end_dt date -- 结束时间
    ,id_mark varchar2(10) -- 增删标志
    ,etl_timestamp timestamp -- ETL处理时间戳
)
partition by range(end_dt)(
    partition p_19000101 values less than (to_date('20991231','yyyymmdd'))
    ,partition p_20991231 values less than (maxvalue)
)
storage (initial 1024k next 1024k)
compress ${option_switch} for query high
nologging
;

-- grant
grant select on ${iol_schema}.rcds_ir_tzbl_a_xyksylhkl to ${iml_schema};
grant select on ${iol_schema}.rcds_ir_tzbl_a_xyksylhkl to ${icl_schema};
grant select on ${iol_schema}.rcds_ir_tzbl_a_xyksylhkl to ${idl_schema};
grant select on ${iol_schema}.rcds_ir_tzbl_a_xyksylhkl to ${iel_schema};

-- comment
comment on table ${iol_schema}.rcds_ir_tzbl_a_xyksylhkl is '信用卡使用率/还款率';
comment on column ${iol_schema}.rcds_ir_tzbl_a_xyksylhkl.grade_key_id is '申请评分流水号';
comment on column ${iol_schema}.rcds_ir_tzbl_a_xyksylhkl.data_time is '数据记录时间';
comment on column ${iol_schema}.rcds_ir_tzbl_a_xyksylhkl.serialno is '申请流水号';
comment on column ${iol_schema}.rcds_ir_tzbl_a_xyksylhkl.create_time is '创建时间';
comment on column ${iol_schema}.rcds_ir_tzbl_a_xyksylhkl.repayment is '信用卡本月实还总金额/总已用额度';
comment on column ${iol_schema}.rcds_ir_tzbl_a_xyksylhkl.bill_repayment is '信用卡本月实还总金额/上一期账单最低应还款总额';
comment on column ${iol_schema}.rcds_ir_tzbl_a_xyksylhkl.agv_utilization is '信用卡已用额度/信用卡授信共享额度';
comment on column ${iol_schema}.rcds_ir_tzbl_a_xyksylhkl.start_dt is '开始时间';
comment on column ${iol_schema}.rcds_ir_tzbl_a_xyksylhkl.end_dt is '结束时间';
comment on column ${iol_schema}.rcds_ir_tzbl_a_xyksylhkl.id_mark is '增删标志';
comment on column ${iol_schema}.rcds_ir_tzbl_a_xyksylhkl.etl_timestamp is 'ETL处理时间戳';
