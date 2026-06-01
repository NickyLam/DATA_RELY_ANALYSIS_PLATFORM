/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol rcds_ir_grade_a_score_input
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.rcds_ir_grade_a_score_input
whenever sqlerror continue none;
drop table ${iol_schema}.rcds_ir_grade_a_score_input purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.rcds_ir_grade_a_score_input(
    grade_key_id varchar2(60) -- 申请评分流水号
    ,serialno varchar2(40) -- 申请流水号
    ,data_time varchar2(20) -- 数据记录时间
    ,a_ln_cm_cnt_npf_secure_p number(24,6) -- 未结清抵押贷款的账户数/所有未结清贷款的账户数
    ,bill_repayment number(24,6) -- 信用卡本月实还总金额/上一期账单最低应还款总额
    ,repayment number(24,6) -- 信用卡总已用额度/信用卡总授信共享额度
    ,a_cl_am_mob_nd_max number(22) -- 从未逾期信贷（信用卡+贷款）账户距今最长账龄
    ,a_cc_cm_cnt_urt100 number(22) -- 信用卡已用额度/授信额度超过100%的账户数
    ,a_cl_am_delqfmth_l3m_m1 number(22) -- 过去3个月信贷（信用卡+贷款）逾期的月份数
    ,a_cl_am_delqr_l24m_m1 number(22) -- 最近一次信贷（信用卡+贷款）逾期距今月份数
    ,a_freq_query_6m_ca number(22) -- 主申人查询过去6个月信贷审核查询次数
    ,a_cl_cm_cnt_l6m_df_p number(24,6) -- 过去6个月有过逾期的信贷帐户占比
    ,a_ln_cm_cnt_mana_ndf_l12_p number(24,6) -- 过去12个月从未逾期的经营类贷款账户数/总的经营类贷款帐户数
    ,a_ln_cm_cnt_house number(22) -- 房贷笔数
    ,a_cc_am_inm_max number(22) -- 信用卡开户日期距报告日期最长时间间隔
    ,marriage_sex varchar2(10) -- 婚姻状态性别
    ,age number(22) -- 年龄
    ,industrytype varchar2(10) -- 行业类型
    ,eduexperience varchar2(10) -- 教育程度
    ,agv_utilization number(24,6) -- 使用率
    ,a_cl_am_delqfmth_l24m_m1 number(17,2) -- 过去24个月信贷（信用卡+贷款）逾期的月份数
    ,a_cl_am_delqm_l12m_max number(17,2) -- 过去12个月信贷（信用卡+贷款）最大逾期期数
    ,a_freq_query_12m_ca number(17,2) -- 主申人查询过去12个月信贷审核查询次数
    ,residence_type varchar2(10) -- 现住房状况
    ,a_cc_cm_cnt_urt30_p number(17,2) -- 信用卡已用额度/授信额度超过30%的信用卡账户数/总信用卡账户数
    ,a_cc_am_delqf_l12m_m1 number(17,2) -- 信用卡过去12个月逾期1期及以上的次数
    ,a_cl_cm_cnt_tot number(17,2) -- 信贷总账户数
    ,final_risk_coef number(17,2) -- 最终的风险系数
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
grant select on ${iol_schema}.rcds_ir_grade_a_score_input to ${iml_schema};
grant select on ${iol_schema}.rcds_ir_grade_a_score_input to ${icl_schema};
grant select on ${iol_schema}.rcds_ir_grade_a_score_input to ${idl_schema};
grant select on ${iol_schema}.rcds_ir_grade_a_score_input to ${iel_schema};

-- comment
comment on table ${iol_schema}.rcds_ir_grade_a_score_input is '评分入参表';
comment on column ${iol_schema}.rcds_ir_grade_a_score_input.grade_key_id is '申请评分流水号';
comment on column ${iol_schema}.rcds_ir_grade_a_score_input.serialno is '申请流水号';
comment on column ${iol_schema}.rcds_ir_grade_a_score_input.data_time is '数据记录时间';
comment on column ${iol_schema}.rcds_ir_grade_a_score_input.a_ln_cm_cnt_npf_secure_p is '未结清抵押贷款的账户数/所有未结清贷款的账户数';
comment on column ${iol_schema}.rcds_ir_grade_a_score_input.bill_repayment is '信用卡本月实还总金额/上一期账单最低应还款总额';
comment on column ${iol_schema}.rcds_ir_grade_a_score_input.repayment is '信用卡总已用额度/信用卡总授信共享额度';
comment on column ${iol_schema}.rcds_ir_grade_a_score_input.a_cl_am_mob_nd_max is '从未逾期信贷（信用卡+贷款）账户距今最长账龄';
comment on column ${iol_schema}.rcds_ir_grade_a_score_input.a_cc_cm_cnt_urt100 is '信用卡已用额度/授信额度超过100%的账户数';
comment on column ${iol_schema}.rcds_ir_grade_a_score_input.a_cl_am_delqfmth_l3m_m1 is '过去3个月信贷（信用卡+贷款）逾期的月份数';
comment on column ${iol_schema}.rcds_ir_grade_a_score_input.a_cl_am_delqr_l24m_m1 is '最近一次信贷（信用卡+贷款）逾期距今月份数';
comment on column ${iol_schema}.rcds_ir_grade_a_score_input.a_freq_query_6m_ca is '主申人查询过去6个月信贷审核查询次数';
comment on column ${iol_schema}.rcds_ir_grade_a_score_input.a_cl_cm_cnt_l6m_df_p is '过去6个月有过逾期的信贷帐户占比';
comment on column ${iol_schema}.rcds_ir_grade_a_score_input.a_ln_cm_cnt_mana_ndf_l12_p is '过去12个月从未逾期的经营类贷款账户数/总的经营类贷款帐户数';
comment on column ${iol_schema}.rcds_ir_grade_a_score_input.a_ln_cm_cnt_house is '房贷笔数';
comment on column ${iol_schema}.rcds_ir_grade_a_score_input.a_cc_am_inm_max is '信用卡开户日期距报告日期最长时间间隔';
comment on column ${iol_schema}.rcds_ir_grade_a_score_input.marriage_sex is '婚姻状态性别';
comment on column ${iol_schema}.rcds_ir_grade_a_score_input.age is '年龄';
comment on column ${iol_schema}.rcds_ir_grade_a_score_input.industrytype is '行业类型';
comment on column ${iol_schema}.rcds_ir_grade_a_score_input.eduexperience is '教育程度';
comment on column ${iol_schema}.rcds_ir_grade_a_score_input.agv_utilization is '使用率';
comment on column ${iol_schema}.rcds_ir_grade_a_score_input.a_cl_am_delqfmth_l24m_m1 is '过去24个月信贷（信用卡+贷款）逾期的月份数';
comment on column ${iol_schema}.rcds_ir_grade_a_score_input.a_cl_am_delqm_l12m_max is '过去12个月信贷（信用卡+贷款）最大逾期期数';
comment on column ${iol_schema}.rcds_ir_grade_a_score_input.a_freq_query_12m_ca is '主申人查询过去12个月信贷审核查询次数';
comment on column ${iol_schema}.rcds_ir_grade_a_score_input.residence_type is '现住房状况';
comment on column ${iol_schema}.rcds_ir_grade_a_score_input.a_cc_cm_cnt_urt30_p is '信用卡已用额度/授信额度超过30%的信用卡账户数/总信用卡账户数';
comment on column ${iol_schema}.rcds_ir_grade_a_score_input.a_cc_am_delqf_l12m_m1 is '信用卡过去12个月逾期1期及以上的次数';
comment on column ${iol_schema}.rcds_ir_grade_a_score_input.a_cl_cm_cnt_tot is '信贷总账户数';
comment on column ${iol_schema}.rcds_ir_grade_a_score_input.final_risk_coef is '最终的风险系数';
comment on column ${iol_schema}.rcds_ir_grade_a_score_input.start_dt is '开始时间';
comment on column ${iol_schema}.rcds_ir_grade_a_score_input.end_dt is '结束时间';
comment on column ${iol_schema}.rcds_ir_grade_a_score_input.id_mark is '增删标志';
comment on column ${iol_schema}.rcds_ir_grade_a_score_input.etl_timestamp is 'ETL处理时间戳';
