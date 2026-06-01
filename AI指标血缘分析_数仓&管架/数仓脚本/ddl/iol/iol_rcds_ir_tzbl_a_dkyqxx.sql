/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol rcds_ir_tzbl_a_dkyqxx
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.rcds_ir_tzbl_a_dkyqxx
whenever sqlerror continue none;
drop table ${iol_schema}.rcds_ir_tzbl_a_dkyqxx purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.rcds_ir_tzbl_a_dkyqxx(
    grade_key_id varchar2(60) -- 申请评分流水号
    ,data_time varchar2(20) -- 数据记录时间
    ,serialno varchar2(40) -- 申请流水号
    ,create_time varchar2(20) -- 创建时间
    ,a_ln_am_delqfmth_l12m_m1 number(10,0) -- 贷款过去12个月M1+逾期的月数
    ,a_ln_am_delqfmth_l12m_m2 number(10,0) -- 贷款过去12个月M2+逾期的月数
    ,a_ln_am_delqfmth_l12m_m3 number(10,0) -- 贷款过去12个月M3+逾期的月数
    ,a_ln_am_delqfmth_l12m_m4 number(10,0) -- 贷款过去12个月M4+逾期的月数
    ,a_ln_am_delqfmth_l24m_m1 number(10,0) -- 贷款过去24个月M1+逾期的月数（过去24个月贷款逾期的月份数）
    ,a_ln_am_delqfmth_l24m_m2 number(10,0) -- 贷款过去24个月M2+逾期的月数
    ,a_ln_am_delqfmth_l24m_m3 number(10,0) -- 贷款过去24个月M3+逾期的月数
    ,a_ln_am_delqfmth_l24m_m4 number(10,0) -- 贷款过去24个月M4+逾期的月数
    ,a_ln_am_delqfmth_l3m_m1 number(10,0) -- 贷款过去3个月M1+逾期的月数
    ,a_ln_am_delqfmth_l3m_m2 number(10,0) -- 贷款过去3个月M2+逾期的月数
    ,a_ln_am_delqfmth_l3m_m3 number(10,0) -- 贷款过去3个月M3+逾期的月数
    ,a_ln_am_delqfmth_l3m_m4 number(10,0) -- 贷款过去3个月M4+逾期的月数
    ,a_ln_am_delqfmth_l6m_m1 number(10,0) -- 贷款过去6个月M1+逾期的月数
    ,a_ln_am_delqfmth_l6m_m2 number(10,0) -- 贷款过去6个月M2+逾期的月数
    ,a_ln_am_delqfmth_l6m_m3 number(10,0) -- 贷款过去6个月M3+逾期的月数
    ,a_ln_am_delqfmth_l6m_m4 number(10,0) -- 贷款过去6个月M4+逾期的月数
    ,a_ln_am_delqm_l3m_max number(10,0) -- 贷款过去3个月的最大逾期期数
    ,a_ln_am_delqm_l6m_max number(10,0) -- 贷款过去6个月的最大逾期期数
    ,a_ln_am_delqm_l12m_max number(10,0) -- 贷款过去12个月的最大逾期期数（过去12个月贷款最大逾期期数）
    ,a_ln_am_delqm_l24m_max number(10,0) -- 贷款过去24个月的最大逾期期数
    ,a_ln_am_delqr_l3m_m1 number(10,0) -- 贷款过去3个月最近一次逾期距今的月份数
    ,a_ln_am_delqr_l6m_m1 number(10,0) -- 贷款过去6个月最近一次逾期距今的月份数
    ,a_ln_am_delqr_l12m_m1 number(10,0) -- 贷款过去12个月最近一次逾期距今的月份数
    ,a_ln_am_delqr_l24m_m1 number(10,0) -- 贷款过去24个月最近一次逾期距今的月份数
    ,a_ln_am_delqr_l3m_m2 number(10,0) -- 贷款过去3个月最近一次M2逾期距今的月份数
    ,a_ln_am_delqr_l6m_m2 number(10,0) -- 贷款过去6个月最近一次M2逾期距今的月份数
    ,a_ln_am_delqr_l12m_m2 number(10,0) -- 贷款过去12个月最近一次M2逾期距今的月份数
    ,a_ln_am_delqr_l24m_m2 number(10,0) -- 贷款过去24个月最近一次M2逾期距今的月份数
    ,a_ln_am_delqr_l3m_m3 number(10,0) -- 贷款过去3个月最近一次M3逾期距今的月份数
    ,a_ln_am_delqr_l6m_m3 number(10,0) -- 贷款过去6个月最近一次M3逾期距今的月份数
    ,a_ln_am_delqr_l12m_m3 number(10,0) -- 贷款过去12个月最近一次M3逾期距今的月份数
    ,a_ln_am_delqr_l24m_m3 number(10,0) -- 贷款过去24个月最近一次M3逾期距今的月份数
    ,a_ln_am_delqf_l3m_m1 number(10,0) -- 贷款过去3个月逾期1期及以上的次数
    ,a_ln_am_delqf_l3m_m2 number(10,0) -- 贷款过去3个月逾期2期及以上的次数
    ,a_ln_am_delqf_l3m_m3 number(10,0) -- 贷款过去3个月逾期3期及以上的次数
    ,a_ln_am_delqf_l3m_m4_plus number(10,0) -- 贷款过去3个月逾期4期及以上的次数
    ,a_ln_am_delqf_l6m_m1 number(10,0) -- 贷款过去6个月逾期1期及以上的次数（过去6个月贷款逾期总次数）
    ,a_ln_am_delqf_l6m_m2 number(10,0) -- 贷款过去6个月逾期2期及以上的次数
    ,a_ln_am_delqf_l6m_m3 number(10,0) -- 贷款过去6个月逾期3期及以上的次数
    ,a_ln_am_delqf_l6m_m4_plus number(10,0) -- 贷款过去6个月逾期4期及以上的次数
    ,a_ln_am_delqf_l12m_m1 number(10,0) -- 贷款过去12个月逾期1期及以上的次数
    ,a_ln_am_delqf_l12m_m2 number(10,0) -- 贷款过去12个月逾期2期及以上的次数
    ,a_ln_am_delqf_l12m_m3 number(10,0) -- 贷款过去12个月逾期3期及以上的次数
    ,a_ln_am_delqf_l12m_m4_plus number(10,0) -- 贷款过去12个月逾期4期及以上的次数
    ,a_ln_am_delqf_l24m_m1 number(10,0) -- 贷款过去24个月逾期1期及以上的次数
    ,a_ln_am_delqf_l24m_m2 number(10,0) -- 贷款过去24个月逾期2期及以上的次数
    ,a_ln_am_delqf_l24m_m3 number(10,0) -- 贷款过去24个月逾期3期及以上的次数
    ,a_ln_am_delqf_l24m_m4_plus number(10,0) -- 贷款过去24个月逾期4期及以上的次数
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
grant select on ${iol_schema}.rcds_ir_tzbl_a_dkyqxx to ${iml_schema};
grant select on ${iol_schema}.rcds_ir_tzbl_a_dkyqxx to ${icl_schema};
grant select on ${iol_schema}.rcds_ir_tzbl_a_dkyqxx to ${idl_schema};
grant select on ${iol_schema}.rcds_ir_tzbl_a_dkyqxx to ${iel_schema};

-- comment
comment on table ${iol_schema}.rcds_ir_tzbl_a_dkyqxx is '贷款逾期信息';
comment on column ${iol_schema}.rcds_ir_tzbl_a_dkyqxx.grade_key_id is '申请评分流水号';
comment on column ${iol_schema}.rcds_ir_tzbl_a_dkyqxx.data_time is '数据记录时间';
comment on column ${iol_schema}.rcds_ir_tzbl_a_dkyqxx.serialno is '申请流水号';
comment on column ${iol_schema}.rcds_ir_tzbl_a_dkyqxx.create_time is '创建时间';
comment on column ${iol_schema}.rcds_ir_tzbl_a_dkyqxx.a_ln_am_delqfmth_l12m_m1 is '贷款过去12个月M1+逾期的月数';
comment on column ${iol_schema}.rcds_ir_tzbl_a_dkyqxx.a_ln_am_delqfmth_l12m_m2 is '贷款过去12个月M2+逾期的月数';
comment on column ${iol_schema}.rcds_ir_tzbl_a_dkyqxx.a_ln_am_delqfmth_l12m_m3 is '贷款过去12个月M3+逾期的月数';
comment on column ${iol_schema}.rcds_ir_tzbl_a_dkyqxx.a_ln_am_delqfmth_l12m_m4 is '贷款过去12个月M4+逾期的月数';
comment on column ${iol_schema}.rcds_ir_tzbl_a_dkyqxx.a_ln_am_delqfmth_l24m_m1 is '贷款过去24个月M1+逾期的月数（过去24个月贷款逾期的月份数）';
comment on column ${iol_schema}.rcds_ir_tzbl_a_dkyqxx.a_ln_am_delqfmth_l24m_m2 is '贷款过去24个月M2+逾期的月数';
comment on column ${iol_schema}.rcds_ir_tzbl_a_dkyqxx.a_ln_am_delqfmth_l24m_m3 is '贷款过去24个月M3+逾期的月数';
comment on column ${iol_schema}.rcds_ir_tzbl_a_dkyqxx.a_ln_am_delqfmth_l24m_m4 is '贷款过去24个月M4+逾期的月数';
comment on column ${iol_schema}.rcds_ir_tzbl_a_dkyqxx.a_ln_am_delqfmth_l3m_m1 is '贷款过去3个月M1+逾期的月数';
comment on column ${iol_schema}.rcds_ir_tzbl_a_dkyqxx.a_ln_am_delqfmth_l3m_m2 is '贷款过去3个月M2+逾期的月数';
comment on column ${iol_schema}.rcds_ir_tzbl_a_dkyqxx.a_ln_am_delqfmth_l3m_m3 is '贷款过去3个月M3+逾期的月数';
comment on column ${iol_schema}.rcds_ir_tzbl_a_dkyqxx.a_ln_am_delqfmth_l3m_m4 is '贷款过去3个月M4+逾期的月数';
comment on column ${iol_schema}.rcds_ir_tzbl_a_dkyqxx.a_ln_am_delqfmth_l6m_m1 is '贷款过去6个月M1+逾期的月数';
comment on column ${iol_schema}.rcds_ir_tzbl_a_dkyqxx.a_ln_am_delqfmth_l6m_m2 is '贷款过去6个月M2+逾期的月数';
comment on column ${iol_schema}.rcds_ir_tzbl_a_dkyqxx.a_ln_am_delqfmth_l6m_m3 is '贷款过去6个月M3+逾期的月数';
comment on column ${iol_schema}.rcds_ir_tzbl_a_dkyqxx.a_ln_am_delqfmth_l6m_m4 is '贷款过去6个月M4+逾期的月数';
comment on column ${iol_schema}.rcds_ir_tzbl_a_dkyqxx.a_ln_am_delqm_l3m_max is '贷款过去3个月的最大逾期期数';
comment on column ${iol_schema}.rcds_ir_tzbl_a_dkyqxx.a_ln_am_delqm_l6m_max is '贷款过去6个月的最大逾期期数';
comment on column ${iol_schema}.rcds_ir_tzbl_a_dkyqxx.a_ln_am_delqm_l12m_max is '贷款过去12个月的最大逾期期数（过去12个月贷款最大逾期期数）';
comment on column ${iol_schema}.rcds_ir_tzbl_a_dkyqxx.a_ln_am_delqm_l24m_max is '贷款过去24个月的最大逾期期数';
comment on column ${iol_schema}.rcds_ir_tzbl_a_dkyqxx.a_ln_am_delqr_l3m_m1 is '贷款过去3个月最近一次逾期距今的月份数';
comment on column ${iol_schema}.rcds_ir_tzbl_a_dkyqxx.a_ln_am_delqr_l6m_m1 is '贷款过去6个月最近一次逾期距今的月份数';
comment on column ${iol_schema}.rcds_ir_tzbl_a_dkyqxx.a_ln_am_delqr_l12m_m1 is '贷款过去12个月最近一次逾期距今的月份数';
comment on column ${iol_schema}.rcds_ir_tzbl_a_dkyqxx.a_ln_am_delqr_l24m_m1 is '贷款过去24个月最近一次逾期距今的月份数';
comment on column ${iol_schema}.rcds_ir_tzbl_a_dkyqxx.a_ln_am_delqr_l3m_m2 is '贷款过去3个月最近一次M2逾期距今的月份数';
comment on column ${iol_schema}.rcds_ir_tzbl_a_dkyqxx.a_ln_am_delqr_l6m_m2 is '贷款过去6个月最近一次M2逾期距今的月份数';
comment on column ${iol_schema}.rcds_ir_tzbl_a_dkyqxx.a_ln_am_delqr_l12m_m2 is '贷款过去12个月最近一次M2逾期距今的月份数';
comment on column ${iol_schema}.rcds_ir_tzbl_a_dkyqxx.a_ln_am_delqr_l24m_m2 is '贷款过去24个月最近一次M2逾期距今的月份数';
comment on column ${iol_schema}.rcds_ir_tzbl_a_dkyqxx.a_ln_am_delqr_l3m_m3 is '贷款过去3个月最近一次M3逾期距今的月份数';
comment on column ${iol_schema}.rcds_ir_tzbl_a_dkyqxx.a_ln_am_delqr_l6m_m3 is '贷款过去6个月最近一次M3逾期距今的月份数';
comment on column ${iol_schema}.rcds_ir_tzbl_a_dkyqxx.a_ln_am_delqr_l12m_m3 is '贷款过去12个月最近一次M3逾期距今的月份数';
comment on column ${iol_schema}.rcds_ir_tzbl_a_dkyqxx.a_ln_am_delqr_l24m_m3 is '贷款过去24个月最近一次M3逾期距今的月份数';
comment on column ${iol_schema}.rcds_ir_tzbl_a_dkyqxx.a_ln_am_delqf_l3m_m1 is '贷款过去3个月逾期1期及以上的次数';
comment on column ${iol_schema}.rcds_ir_tzbl_a_dkyqxx.a_ln_am_delqf_l3m_m2 is '贷款过去3个月逾期2期及以上的次数';
comment on column ${iol_schema}.rcds_ir_tzbl_a_dkyqxx.a_ln_am_delqf_l3m_m3 is '贷款过去3个月逾期3期及以上的次数';
comment on column ${iol_schema}.rcds_ir_tzbl_a_dkyqxx.a_ln_am_delqf_l3m_m4_plus is '贷款过去3个月逾期4期及以上的次数';
comment on column ${iol_schema}.rcds_ir_tzbl_a_dkyqxx.a_ln_am_delqf_l6m_m1 is '贷款过去6个月逾期1期及以上的次数（过去6个月贷款逾期总次数）';
comment on column ${iol_schema}.rcds_ir_tzbl_a_dkyqxx.a_ln_am_delqf_l6m_m2 is '贷款过去6个月逾期2期及以上的次数';
comment on column ${iol_schema}.rcds_ir_tzbl_a_dkyqxx.a_ln_am_delqf_l6m_m3 is '贷款过去6个月逾期3期及以上的次数';
comment on column ${iol_schema}.rcds_ir_tzbl_a_dkyqxx.a_ln_am_delqf_l6m_m4_plus is '贷款过去6个月逾期4期及以上的次数';
comment on column ${iol_schema}.rcds_ir_tzbl_a_dkyqxx.a_ln_am_delqf_l12m_m1 is '贷款过去12个月逾期1期及以上的次数';
comment on column ${iol_schema}.rcds_ir_tzbl_a_dkyqxx.a_ln_am_delqf_l12m_m2 is '贷款过去12个月逾期2期及以上的次数';
comment on column ${iol_schema}.rcds_ir_tzbl_a_dkyqxx.a_ln_am_delqf_l12m_m3 is '贷款过去12个月逾期3期及以上的次数';
comment on column ${iol_schema}.rcds_ir_tzbl_a_dkyqxx.a_ln_am_delqf_l12m_m4_plus is '贷款过去12个月逾期4期及以上的次数';
comment on column ${iol_schema}.rcds_ir_tzbl_a_dkyqxx.a_ln_am_delqf_l24m_m1 is '贷款过去24个月逾期1期及以上的次数';
comment on column ${iol_schema}.rcds_ir_tzbl_a_dkyqxx.a_ln_am_delqf_l24m_m2 is '贷款过去24个月逾期2期及以上的次数';
comment on column ${iol_schema}.rcds_ir_tzbl_a_dkyqxx.a_ln_am_delqf_l24m_m3 is '贷款过去24个月逾期3期及以上的次数';
comment on column ${iol_schema}.rcds_ir_tzbl_a_dkyqxx.a_ln_am_delqf_l24m_m4_plus is '贷款过去24个月逾期4期及以上的次数';
comment on column ${iol_schema}.rcds_ir_tzbl_a_dkyqxx.start_dt is '开始时间';
comment on column ${iol_schema}.rcds_ir_tzbl_a_dkyqxx.end_dt is '结束时间';
comment on column ${iol_schema}.rcds_ir_tzbl_a_dkyqxx.id_mark is '增删标志';
comment on column ${iol_schema}.rcds_ir_tzbl_a_dkyqxx.etl_timestamp is 'ETL处理时间戳';
