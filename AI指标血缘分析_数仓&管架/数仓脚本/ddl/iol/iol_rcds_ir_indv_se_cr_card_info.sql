/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol rcds_ir_indv_se_cr_card_info
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.rcds_ir_indv_se_cr_card_info
whenever sqlerror continue none;
drop table ${iol_schema}.rcds_ir_indv_se_cr_card_info purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.rcds_ir_indv_se_cr_card_info(
    key_id varchar2(60) -- 主键
    ,grade_key_id varchar2(60) -- 申请评分流水号
    ,data_time varchar2(20) -- 数据记录时间
    ,indv_se_cr_card_info_seq_num varchar2(10) -- 个人准贷记卡信息序号
    ,se_cr_card_desc varchar2(300) -- 准贷记卡描述
    ,acct_status_cd varchar2(10) -- 准贷记卡账户状态
    ,mon_repay_amt varchar2(38) -- 本月实还总金额
    ,od_bal varchar2(38) -- 已用额度（透支余额）
    ,shr_crdt_lmt varchar2(38) -- 授信共享额度
    ,se_cr_card_issue_dt varchar2(20) -- 准贷记卡发放日期
    ,last_two_year_repay_rec varchar2(100) -- 24期还款状态
    ,crdt_lmt varchar2(38) -- 授信额度
    ,last_two_year_repay_rec_align varchar2(50) -- 
    ,end_date varchar2(20) -- 
    ,od180_day_above_unpaid_bal varchar2(38) -- 透支180天以上未付余额
    ,mon_payable_amt varchar2(38) -- 本月应还款金额
    ,last_6_mon_avg_od_lmt varchar2(38) -- 最近6个月平均透支额度
    ,last_five_year_repay_rec varchar2(160) -- 60期还款状态
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
grant select on ${iol_schema}.rcds_ir_indv_se_cr_card_info to ${iml_schema};
grant select on ${iol_schema}.rcds_ir_indv_se_cr_card_info to ${icl_schema};
grant select on ${iol_schema}.rcds_ir_indv_se_cr_card_info to ${idl_schema};
grant select on ${iol_schema}.rcds_ir_indv_se_cr_card_info to ${iel_schema};

-- comment
comment on table ${iol_schema}.rcds_ir_indv_se_cr_card_info is '个人准贷记卡信息表';
comment on column ${iol_schema}.rcds_ir_indv_se_cr_card_info.key_id is '主键';
comment on column ${iol_schema}.rcds_ir_indv_se_cr_card_info.grade_key_id is '申请评分流水号';
comment on column ${iol_schema}.rcds_ir_indv_se_cr_card_info.data_time is '数据记录时间';
comment on column ${iol_schema}.rcds_ir_indv_se_cr_card_info.indv_se_cr_card_info_seq_num is '个人准贷记卡信息序号';
comment on column ${iol_schema}.rcds_ir_indv_se_cr_card_info.se_cr_card_desc is '准贷记卡描述';
comment on column ${iol_schema}.rcds_ir_indv_se_cr_card_info.acct_status_cd is '准贷记卡账户状态';
comment on column ${iol_schema}.rcds_ir_indv_se_cr_card_info.mon_repay_amt is '本月实还总金额';
comment on column ${iol_schema}.rcds_ir_indv_se_cr_card_info.od_bal is '已用额度（透支余额）';
comment on column ${iol_schema}.rcds_ir_indv_se_cr_card_info.shr_crdt_lmt is '授信共享额度';
comment on column ${iol_schema}.rcds_ir_indv_se_cr_card_info.se_cr_card_issue_dt is '准贷记卡发放日期';
comment on column ${iol_schema}.rcds_ir_indv_se_cr_card_info.last_two_year_repay_rec is '24期还款状态';
comment on column ${iol_schema}.rcds_ir_indv_se_cr_card_info.crdt_lmt is '授信额度';
comment on column ${iol_schema}.rcds_ir_indv_se_cr_card_info.last_two_year_repay_rec_align is '';
comment on column ${iol_schema}.rcds_ir_indv_se_cr_card_info.end_date is '';
comment on column ${iol_schema}.rcds_ir_indv_se_cr_card_info.od180_day_above_unpaid_bal is '透支180天以上未付余额';
comment on column ${iol_schema}.rcds_ir_indv_se_cr_card_info.mon_payable_amt is '本月应还款金额';
comment on column ${iol_schema}.rcds_ir_indv_se_cr_card_info.last_6_mon_avg_od_lmt is '最近6个月平均透支额度';
comment on column ${iol_schema}.rcds_ir_indv_se_cr_card_info.last_five_year_repay_rec is '60期还款状态';
comment on column ${iol_schema}.rcds_ir_indv_se_cr_card_info.start_dt is '开始时间';
comment on column ${iol_schema}.rcds_ir_indv_se_cr_card_info.end_dt is '结束时间';
comment on column ${iol_schema}.rcds_ir_indv_se_cr_card_info.id_mark is '增删标志';
comment on column ${iol_schema}.rcds_ir_indv_se_cr_card_info.etl_timestamp is 'ETL处理时间戳';
