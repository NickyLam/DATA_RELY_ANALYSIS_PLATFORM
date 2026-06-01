/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol scps_sm_rescan_tb
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.scps_sm_rescan_tb
whenever sqlerror continue none;
drop table ${iol_schema}.scps_sm_rescan_tb purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.scps_sm_rescan_tb(
    task_id varchar2(50) -- 任务号
    ,trade_code varchar2(18) -- 交易码
    ,task_start_date varchar2(14) -- 补件开始时间
    ,task_end_date varchar2(14) -- 补件结束时间
    ,tackct_use_time varchar2(10) -- 补件耗时
    ,tackct_status varchar2(1) -- 补件状态
    ,iau_organ varchar2(10) -- 发起补件柜员
    ,iau_teller_no varchar2(10) -- 发起机构
    ,sub_teller_no varchar2(10) -- 提交补件柜员
    ,sub_organ varchar2(10) -- 提交机构
    ,tackct_type varchar2(1) -- 补扫类型（1，事中 2，事后）
    ,tackct_count varchar2(15) -- 补扫次数
    ,tackct_task_id varchar2(22) -- 补扫任务号
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
grant select on ${iol_schema}.scps_sm_rescan_tb to ${iml_schema};
grant select on ${iol_schema}.scps_sm_rescan_tb to ${icl_schema};
grant select on ${iol_schema}.scps_sm_rescan_tb to ${idl_schema};
grant select on ${iol_schema}.scps_sm_rescan_tb to ${iel_schema};

-- comment
comment on table ${iol_schema}.scps_sm_rescan_tb is '远程授权补扫表';
comment on column ${iol_schema}.scps_sm_rescan_tb.task_id is '任务号';
comment on column ${iol_schema}.scps_sm_rescan_tb.trade_code is '交易码';
comment on column ${iol_schema}.scps_sm_rescan_tb.task_start_date is '补件开始时间';
comment on column ${iol_schema}.scps_sm_rescan_tb.task_end_date is '补件结束时间';
comment on column ${iol_schema}.scps_sm_rescan_tb.tackct_use_time is '补件耗时';
comment on column ${iol_schema}.scps_sm_rescan_tb.tackct_status is '补件状态';
comment on column ${iol_schema}.scps_sm_rescan_tb.iau_organ is '发起补件柜员';
comment on column ${iol_schema}.scps_sm_rescan_tb.iau_teller_no is '发起机构';
comment on column ${iol_schema}.scps_sm_rescan_tb.sub_teller_no is '提交补件柜员';
comment on column ${iol_schema}.scps_sm_rescan_tb.sub_organ is '提交机构';
comment on column ${iol_schema}.scps_sm_rescan_tb.tackct_type is '补扫类型（1，事中 2，事后）';
comment on column ${iol_schema}.scps_sm_rescan_tb.tackct_count is '补扫次数';
comment on column ${iol_schema}.scps_sm_rescan_tb.tackct_task_id is '补扫任务号';
comment on column ${iol_schema}.scps_sm_rescan_tb.start_dt is '开始时间';
comment on column ${iol_schema}.scps_sm_rescan_tb.end_dt is '结束时间';
comment on column ${iol_schema}.scps_sm_rescan_tb.id_mark is '增删标志';
comment on column ${iol_schema}.scps_sm_rescan_tb.etl_timestamp is 'ETL处理时间戳';
