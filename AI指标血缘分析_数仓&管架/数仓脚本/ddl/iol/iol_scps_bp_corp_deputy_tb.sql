/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol scps_bp_corp_deputy_tb
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.scps_bp_corp_deputy_tb
whenever sqlerror continue none;
drop table ${iol_schema}.scps_bp_corp_deputy_tb purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.scps_bp_corp_deputy_tb(
    id varchar2(50) -- 
    ,task_id varchar2(50) -- 任务号（esc的订单号）
    ,tr_date date -- 交易日期
    ,pre_reason varchar2(1024) -- 落地流程银行原因
    ,double_notlocal varchar2(2) -- 是否双异地（1-是，0-否）
    ,video_check_result varchar2(2) -- 双录视频审核结果（1-通过，0-不通过）
    ,ot_frozsq varchar2(50) -- 止付流水号
    ,ot_trandt varchar2(12) -- 止付日期
    ,frozen_flag varchar2(2) -- 止付状态（1-止付，01-止付失败，2-解止付，02-解止付失败）
    ,video_nopass_reason varchar2(150) -- 双录视频审核不通过原因
    ,pad_return_result varchar2(800) -- 退件原因
    ,pad_flag varchar2(1) -- 流程标记：1-pad1.0,2-pad2.0
    ,ori_content_id varchar2(60) -- 原始图片批次号
    ,order_num varchar2(32) -- 渠道订单号
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
grant select on ${iol_schema}.scps_bp_corp_deputy_tb to ${iml_schema};
grant select on ${iol_schema}.scps_bp_corp_deputy_tb to ${icl_schema};
grant select on ${iol_schema}.scps_bp_corp_deputy_tb to ${idl_schema};
grant select on ${iol_schema}.scps_bp_corp_deputy_tb to ${iel_schema};

-- comment
comment on table ${iol_schema}.scps_bp_corp_deputy_tb is 'pad对公辅表';
comment on column ${iol_schema}.scps_bp_corp_deputy_tb.id is '';
comment on column ${iol_schema}.scps_bp_corp_deputy_tb.task_id is '任务号（esc的订单号）';
comment on column ${iol_schema}.scps_bp_corp_deputy_tb.tr_date is '交易日期';
comment on column ${iol_schema}.scps_bp_corp_deputy_tb.pre_reason is '落地流程银行原因';
comment on column ${iol_schema}.scps_bp_corp_deputy_tb.double_notlocal is '是否双异地（1-是，0-否）';
comment on column ${iol_schema}.scps_bp_corp_deputy_tb.video_check_result is '双录视频审核结果（1-通过，0-不通过）';
comment on column ${iol_schema}.scps_bp_corp_deputy_tb.ot_frozsq is '止付流水号';
comment on column ${iol_schema}.scps_bp_corp_deputy_tb.ot_trandt is '止付日期';
comment on column ${iol_schema}.scps_bp_corp_deputy_tb.frozen_flag is '止付状态（1-止付，01-止付失败，2-解止付，02-解止付失败）';
comment on column ${iol_schema}.scps_bp_corp_deputy_tb.video_nopass_reason is '双录视频审核不通过原因';
comment on column ${iol_schema}.scps_bp_corp_deputy_tb.pad_return_result is '退件原因';
comment on column ${iol_schema}.scps_bp_corp_deputy_tb.pad_flag is '流程标记：1-pad1.0,2-pad2.0';
comment on column ${iol_schema}.scps_bp_corp_deputy_tb.ori_content_id is '原始图片批次号';
comment on column ${iol_schema}.scps_bp_corp_deputy_tb.order_num is '渠道订单号';
comment on column ${iol_schema}.scps_bp_corp_deputy_tb.start_dt is '开始时间';
comment on column ${iol_schema}.scps_bp_corp_deputy_tb.end_dt is '结束时间';
comment on column ${iol_schema}.scps_bp_corp_deputy_tb.id_mark is '增删标志';
comment on column ${iol_schema}.scps_bp_corp_deputy_tb.etl_timestamp is 'ETL处理时间戳';
