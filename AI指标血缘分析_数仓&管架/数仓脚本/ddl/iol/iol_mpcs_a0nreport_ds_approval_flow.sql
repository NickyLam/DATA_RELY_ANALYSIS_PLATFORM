/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol mpcs_a0nreport_ds_approval_flow
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.mpcs_a0nreport_ds_approval_flow
whenever sqlerror continue none;
drop table ${iol_schema}.mpcs_a0nreport_ds_approval_flow purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.mpcs_a0nreport_ds_approval_flow(
    partition_date varchar2(15) -- 分区日期
    ,biz_no varchar2(60) -- 流水号
    ,bank_no varchar2(30) -- 银行号
    ,final_ret varchar2(30) -- 最终审批结果
    ,ours_approval_ret varchar2(60) -- 合作行审批结果
    ,code_block varchar2(300) -- 拒绝码
    ,is_first varchar2(3) -- 是否首借
    ,outer_ret varchar2(60) -- 合作行机房审批结果
    ,psz_ret varchar2(60) -- psz区审批结果
    ,batchfilename varchar2(90) -- 批量文件名
    ,seqno varchar2(30) -- 序列号
    ,cust_score varchar2(300) -- 客户评分
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
grant select on ${iol_schema}.mpcs_a0nreport_ds_approval_flow to ${iml_schema};
grant select on ${iol_schema}.mpcs_a0nreport_ds_approval_flow to ${icl_schema};
grant select on ${iol_schema}.mpcs_a0nreport_ds_approval_flow to ${idl_schema};
grant select on ${iol_schema}.mpcs_a0nreport_ds_approval_flow to ${iel_schema};

-- comment
comment on table ${iol_schema}.mpcs_a0nreport_ds_approval_flow is '审批结果流水表';
comment on column ${iol_schema}.mpcs_a0nreport_ds_approval_flow.partition_date is '分区日期';
comment on column ${iol_schema}.mpcs_a0nreport_ds_approval_flow.biz_no is '流水号';
comment on column ${iol_schema}.mpcs_a0nreport_ds_approval_flow.bank_no is '银行号';
comment on column ${iol_schema}.mpcs_a0nreport_ds_approval_flow.final_ret is '最终审批结果';
comment on column ${iol_schema}.mpcs_a0nreport_ds_approval_flow.ours_approval_ret is '合作行审批结果';
comment on column ${iol_schema}.mpcs_a0nreport_ds_approval_flow.code_block is '拒绝码';
comment on column ${iol_schema}.mpcs_a0nreport_ds_approval_flow.is_first is '是否首借';
comment on column ${iol_schema}.mpcs_a0nreport_ds_approval_flow.outer_ret is '合作行机房审批结果';
comment on column ${iol_schema}.mpcs_a0nreport_ds_approval_flow.psz_ret is 'psz区审批结果';
comment on column ${iol_schema}.mpcs_a0nreport_ds_approval_flow.batchfilename is '批量文件名';
comment on column ${iol_schema}.mpcs_a0nreport_ds_approval_flow.seqno is '序列号';
comment on column ${iol_schema}.mpcs_a0nreport_ds_approval_flow.cust_score is '客户评分';
comment on column ${iol_schema}.mpcs_a0nreport_ds_approval_flow.start_dt is '开始时间';
comment on column ${iol_schema}.mpcs_a0nreport_ds_approval_flow.end_dt is '结束时间';
comment on column ${iol_schema}.mpcs_a0nreport_ds_approval_flow.id_mark is '增删标志';
comment on column ${iol_schema}.mpcs_a0nreport_ds_approval_flow.etl_timestamp is 'ETL处理时间戳';
