/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol rcds_ir_indv_cr_card_ovdue_info
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.rcds_ir_indv_cr_card_ovdue_info
whenever sqlerror continue none;
drop table ${iol_schema}.rcds_ir_indv_cr_card_ovdue_info purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.rcds_ir_indv_cr_card_ovdue_info(
    key_id varchar2(60) -- 主键
    ,grade_key_id varchar2(60) -- 申请评分流水号
    ,data_time varchar2(20) -- 数据记录时间
    ,indvcr_card_info_seq_num varchar2(10) -- 个人贷记卡信息序号
    ,ovdue_rec_start_year_mon varchar2(30) -- 逾期记录开始年月
    ,ovdue_amt number(38,6) -- 逾期金额
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
grant select on ${iol_schema}.rcds_ir_indv_cr_card_ovdue_info to ${iml_schema};
grant select on ${iol_schema}.rcds_ir_indv_cr_card_ovdue_info to ${icl_schema};
grant select on ${iol_schema}.rcds_ir_indv_cr_card_ovdue_info to ${idl_schema};
grant select on ${iol_schema}.rcds_ir_indv_cr_card_ovdue_info to ${iel_schema};

-- comment
comment on table ${iol_schema}.rcds_ir_indv_cr_card_ovdue_info is '个人贷记卡逾期记录表';
comment on column ${iol_schema}.rcds_ir_indv_cr_card_ovdue_info.key_id is '主键';
comment on column ${iol_schema}.rcds_ir_indv_cr_card_ovdue_info.grade_key_id is '申请评分流水号';
comment on column ${iol_schema}.rcds_ir_indv_cr_card_ovdue_info.data_time is '数据记录时间';
comment on column ${iol_schema}.rcds_ir_indv_cr_card_ovdue_info.indvcr_card_info_seq_num is '个人贷记卡信息序号';
comment on column ${iol_schema}.rcds_ir_indv_cr_card_ovdue_info.ovdue_rec_start_year_mon is '逾期记录开始年月';
comment on column ${iol_schema}.rcds_ir_indv_cr_card_ovdue_info.ovdue_amt is '逾期金额';
comment on column ${iol_schema}.rcds_ir_indv_cr_card_ovdue_info.start_dt is '开始时间';
comment on column ${iol_schema}.rcds_ir_indv_cr_card_ovdue_info.end_dt is '结束时间';
comment on column ${iol_schema}.rcds_ir_indv_cr_card_ovdue_info.id_mark is '增删标志';
comment on column ${iol_schema}.rcds_ir_indv_cr_card_ovdue_info.etl_timestamp is 'ETL处理时间戳';
