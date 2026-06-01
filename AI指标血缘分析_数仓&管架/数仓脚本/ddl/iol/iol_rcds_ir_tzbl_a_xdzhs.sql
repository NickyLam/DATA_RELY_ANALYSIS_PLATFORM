/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol rcds_ir_tzbl_a_xdzhs
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.rcds_ir_tzbl_a_xdzhs
whenever sqlerror continue none;
drop table ${iol_schema}.rcds_ir_tzbl_a_xdzhs purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.rcds_ir_tzbl_a_xdzhs(
    grade_key_id varchar2(60) -- 申请评分流水号
    ,data_time varchar2(20) -- 数据记录时间
    ,serialno varchar2(40) -- 申请流水号
    ,create_time varchar2(20) -- 创建时间
    ,a_cl_cm_cnt_active number(10,0) -- 未关户信贷账户数
    ,a_cl_cm_cnt_delqclose_l24m number(10,0) -- 已经清且过去24个月内曾逾期的账户数
    ,a_cl_cm_cnt_nd number(10,0) -- 信贷从未逾期账户数
    ,a_cl_cm_cnt_tot number(10,0) -- 信贷总账户数
    ,a_cl_cm_cnt_l6m_df_p number(24,6) -- 过去6个月有过逾期的信贷（信用卡+贷款）账户数/信贷账户总数
    ,a_cl_cm_cnt_new_l12m number(10,0) -- 过去12个月新开信贷账户数
    ,a_cl_cm_cnt_new_l3m number(10,0) -- 过去3个月新开信贷账户数
    ,a_cl_cm_cnt_new_l6m number(10,0) -- 过去6个月新开信贷账户数
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
grant select on ${iol_schema}.rcds_ir_tzbl_a_xdzhs to ${iml_schema};
grant select on ${iol_schema}.rcds_ir_tzbl_a_xdzhs to ${icl_schema};
grant select on ${iol_schema}.rcds_ir_tzbl_a_xdzhs to ${idl_schema};
grant select on ${iol_schema}.rcds_ir_tzbl_a_xdzhs to ${iel_schema};

-- comment
comment on table ${iol_schema}.rcds_ir_tzbl_a_xdzhs is '信贷账户数/账户占比';
comment on column ${iol_schema}.rcds_ir_tzbl_a_xdzhs.grade_key_id is '申请评分流水号';
comment on column ${iol_schema}.rcds_ir_tzbl_a_xdzhs.data_time is '数据记录时间';
comment on column ${iol_schema}.rcds_ir_tzbl_a_xdzhs.serialno is '申请流水号';
comment on column ${iol_schema}.rcds_ir_tzbl_a_xdzhs.create_time is '创建时间';
comment on column ${iol_schema}.rcds_ir_tzbl_a_xdzhs.a_cl_cm_cnt_active is '未关户信贷账户数';
comment on column ${iol_schema}.rcds_ir_tzbl_a_xdzhs.a_cl_cm_cnt_delqclose_l24m is '已经清且过去24个月内曾逾期的账户数';
comment on column ${iol_schema}.rcds_ir_tzbl_a_xdzhs.a_cl_cm_cnt_nd is '信贷从未逾期账户数';
comment on column ${iol_schema}.rcds_ir_tzbl_a_xdzhs.a_cl_cm_cnt_tot is '信贷总账户数';
comment on column ${iol_schema}.rcds_ir_tzbl_a_xdzhs.a_cl_cm_cnt_l6m_df_p is '过去6个月有过逾期的信贷（信用卡+贷款）账户数/信贷账户总数';
comment on column ${iol_schema}.rcds_ir_tzbl_a_xdzhs.a_cl_cm_cnt_new_l12m is '过去12个月新开信贷账户数';
comment on column ${iol_schema}.rcds_ir_tzbl_a_xdzhs.a_cl_cm_cnt_new_l3m is '过去3个月新开信贷账户数';
comment on column ${iol_schema}.rcds_ir_tzbl_a_xdzhs.a_cl_cm_cnt_new_l6m is '过去6个月新开信贷账户数';
comment on column ${iol_schema}.rcds_ir_tzbl_a_xdzhs.start_dt is '开始时间';
comment on column ${iol_schema}.rcds_ir_tzbl_a_xdzhs.end_dt is '结束时间';
comment on column ${iol_schema}.rcds_ir_tzbl_a_xdzhs.id_mark is '增删标志';
comment on column ${iol_schema}.rcds_ir_tzbl_a_xdzhs.etl_timestamp is 'ETL处理时间戳';
