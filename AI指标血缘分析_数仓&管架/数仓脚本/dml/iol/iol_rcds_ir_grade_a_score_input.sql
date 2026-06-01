/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_rcds_ir_grade_a_score_input
CreateDate: 20180515
Logs:
    zjj 2018-05-15 新建脚本
*/

set timing on

-- 1 alter parallel
alter session force parallel query parallel 8;
alter session force parallel dml parallel 8;
-- alter session force parallel ddl parallel 8;

-- 2.1 create backup table
-- if backup table is exists, mean script if failed on last time
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
create table ${iol_schema}.rcds_ir_grade_a_score_input_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.rcds_ir_grade_a_score_input;

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.rcds_ir_grade_a_score_input_op purge;
drop table ${iol_schema}.rcds_ir_grade_a_score_input_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.rcds_ir_grade_a_score_input_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.rcds_ir_grade_a_score_input where 0=1;

create table ${iol_schema}.rcds_ir_grade_a_score_input_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.rcds_ir_grade_a_score_input where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.rcds_ir_grade_a_score_input_cl(
            grade_key_id -- 申请评分流水号
            ,serialno -- 申请流水号
            ,data_time -- 数据记录时间
            ,a_ln_cm_cnt_npf_secure_p -- 未结清抵押贷款的账户数/所有未结清贷款的账户数
            ,bill_repayment -- 信用卡本月实还总金额/上一期账单最低应还款总额
            ,repayment -- 信用卡总已用额度/信用卡总授信共享额度
            ,a_cl_am_mob_nd_max -- 从未逾期信贷（信用卡+贷款）账户距今最长账龄
            ,a_cc_cm_cnt_urt100 -- 信用卡已用额度/授信额度超过100%的账户数
            ,a_cl_am_delqfmth_l3m_m1 -- 过去3个月信贷（信用卡+贷款）逾期的月份数
            ,a_cl_am_delqr_l24m_m1 -- 最近一次信贷（信用卡+贷款）逾期距今月份数
            ,a_freq_query_6m_ca -- 主申人查询过去6个月信贷审核查询次数
            ,a_cl_cm_cnt_l6m_df_p -- 过去6个月有过逾期的信贷帐户占比
            ,a_ln_cm_cnt_mana_ndf_l12_p -- 过去12个月从未逾期的经营类贷款账户数/总的经营类贷款帐户数
            ,a_ln_cm_cnt_house -- 房贷笔数
            ,a_cc_am_inm_max -- 信用卡开户日期距报告日期最长时间间隔
            ,marriage_sex -- 婚姻状态性别
            ,age -- 年龄
            ,industrytype -- 行业类型
            ,eduexperience -- 教育程度
            ,agv_utilization -- 使用率
            ,a_cl_am_delqfmth_l24m_m1 -- 过去24个月信贷（信用卡+贷款）逾期的月份数
            ,a_cl_am_delqm_l12m_max -- 过去12个月信贷（信用卡+贷款）最大逾期期数
            ,a_freq_query_12m_ca -- 主申人查询过去12个月信贷审核查询次数
            ,residence_type -- 现住房状况
            ,a_cc_cm_cnt_urt30_p -- 信用卡已用额度/授信额度超过30%的信用卡账户数/总信用卡账户数
            ,a_cc_am_delqf_l12m_m1 -- 信用卡过去12个月逾期1期及以上的次数
            ,a_cl_cm_cnt_tot -- 信贷总账户数
            ,final_risk_coef -- 最终的风险系数
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.rcds_ir_grade_a_score_input_op(
            grade_key_id -- 申请评分流水号
            ,serialno -- 申请流水号
            ,data_time -- 数据记录时间
            ,a_ln_cm_cnt_npf_secure_p -- 未结清抵押贷款的账户数/所有未结清贷款的账户数
            ,bill_repayment -- 信用卡本月实还总金额/上一期账单最低应还款总额
            ,repayment -- 信用卡总已用额度/信用卡总授信共享额度
            ,a_cl_am_mob_nd_max -- 从未逾期信贷（信用卡+贷款）账户距今最长账龄
            ,a_cc_cm_cnt_urt100 -- 信用卡已用额度/授信额度超过100%的账户数
            ,a_cl_am_delqfmth_l3m_m1 -- 过去3个月信贷（信用卡+贷款）逾期的月份数
            ,a_cl_am_delqr_l24m_m1 -- 最近一次信贷（信用卡+贷款）逾期距今月份数
            ,a_freq_query_6m_ca -- 主申人查询过去6个月信贷审核查询次数
            ,a_cl_cm_cnt_l6m_df_p -- 过去6个月有过逾期的信贷帐户占比
            ,a_ln_cm_cnt_mana_ndf_l12_p -- 过去12个月从未逾期的经营类贷款账户数/总的经营类贷款帐户数
            ,a_ln_cm_cnt_house -- 房贷笔数
            ,a_cc_am_inm_max -- 信用卡开户日期距报告日期最长时间间隔
            ,marriage_sex -- 婚姻状态性别
            ,age -- 年龄
            ,industrytype -- 行业类型
            ,eduexperience -- 教育程度
            ,agv_utilization -- 使用率
            ,a_cl_am_delqfmth_l24m_m1 -- 过去24个月信贷（信用卡+贷款）逾期的月份数
            ,a_cl_am_delqm_l12m_max -- 过去12个月信贷（信用卡+贷款）最大逾期期数
            ,a_freq_query_12m_ca -- 主申人查询过去12个月信贷审核查询次数
            ,residence_type -- 现住房状况
            ,a_cc_cm_cnt_urt30_p -- 信用卡已用额度/授信额度超过30%的信用卡账户数/总信用卡账户数
            ,a_cc_am_delqf_l12m_m1 -- 信用卡过去12个月逾期1期及以上的次数
            ,a_cl_cm_cnt_tot -- 信贷总账户数
            ,final_risk_coef -- 最终的风险系数
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.grade_key_id, o.grade_key_id) as grade_key_id -- 申请评分流水号
    ,nvl(n.serialno, o.serialno) as serialno -- 申请流水号
    ,nvl(n.data_time, o.data_time) as data_time -- 数据记录时间
    ,nvl(n.a_ln_cm_cnt_npf_secure_p, o.a_ln_cm_cnt_npf_secure_p) as a_ln_cm_cnt_npf_secure_p -- 未结清抵押贷款的账户数/所有未结清贷款的账户数
    ,nvl(n.bill_repayment, o.bill_repayment) as bill_repayment -- 信用卡本月实还总金额/上一期账单最低应还款总额
    ,nvl(n.repayment, o.repayment) as repayment -- 信用卡总已用额度/信用卡总授信共享额度
    ,nvl(n.a_cl_am_mob_nd_max, o.a_cl_am_mob_nd_max) as a_cl_am_mob_nd_max -- 从未逾期信贷（信用卡+贷款）账户距今最长账龄
    ,nvl(n.a_cc_cm_cnt_urt100, o.a_cc_cm_cnt_urt100) as a_cc_cm_cnt_urt100 -- 信用卡已用额度/授信额度超过100%的账户数
    ,nvl(n.a_cl_am_delqfmth_l3m_m1, o.a_cl_am_delqfmth_l3m_m1) as a_cl_am_delqfmth_l3m_m1 -- 过去3个月信贷（信用卡+贷款）逾期的月份数
    ,nvl(n.a_cl_am_delqr_l24m_m1, o.a_cl_am_delqr_l24m_m1) as a_cl_am_delqr_l24m_m1 -- 最近一次信贷（信用卡+贷款）逾期距今月份数
    ,nvl(n.a_freq_query_6m_ca, o.a_freq_query_6m_ca) as a_freq_query_6m_ca -- 主申人查询过去6个月信贷审核查询次数
    ,nvl(n.a_cl_cm_cnt_l6m_df_p, o.a_cl_cm_cnt_l6m_df_p) as a_cl_cm_cnt_l6m_df_p -- 过去6个月有过逾期的信贷帐户占比
    ,nvl(n.a_ln_cm_cnt_mana_ndf_l12_p, o.a_ln_cm_cnt_mana_ndf_l12_p) as a_ln_cm_cnt_mana_ndf_l12_p -- 过去12个月从未逾期的经营类贷款账户数/总的经营类贷款帐户数
    ,nvl(n.a_ln_cm_cnt_house, o.a_ln_cm_cnt_house) as a_ln_cm_cnt_house -- 房贷笔数
    ,nvl(n.a_cc_am_inm_max, o.a_cc_am_inm_max) as a_cc_am_inm_max -- 信用卡开户日期距报告日期最长时间间隔
    ,nvl(n.marriage_sex, o.marriage_sex) as marriage_sex -- 婚姻状态性别
    ,nvl(n.age, o.age) as age -- 年龄
    ,nvl(n.industrytype, o.industrytype) as industrytype -- 行业类型
    ,nvl(n.eduexperience, o.eduexperience) as eduexperience -- 教育程度
    ,nvl(n.agv_utilization, o.agv_utilization) as agv_utilization -- 使用率
    ,nvl(n.a_cl_am_delqfmth_l24m_m1, o.a_cl_am_delqfmth_l24m_m1) as a_cl_am_delqfmth_l24m_m1 -- 过去24个月信贷（信用卡+贷款）逾期的月份数
    ,nvl(n.a_cl_am_delqm_l12m_max, o.a_cl_am_delqm_l12m_max) as a_cl_am_delqm_l12m_max -- 过去12个月信贷（信用卡+贷款）最大逾期期数
    ,nvl(n.a_freq_query_12m_ca, o.a_freq_query_12m_ca) as a_freq_query_12m_ca -- 主申人查询过去12个月信贷审核查询次数
    ,nvl(n.residence_type, o.residence_type) as residence_type -- 现住房状况
    ,nvl(n.a_cc_cm_cnt_urt30_p, o.a_cc_cm_cnt_urt30_p) as a_cc_cm_cnt_urt30_p -- 信用卡已用额度/授信额度超过30%的信用卡账户数/总信用卡账户数
    ,nvl(n.a_cc_am_delqf_l12m_m1, o.a_cc_am_delqf_l12m_m1) as a_cc_am_delqf_l12m_m1 -- 信用卡过去12个月逾期1期及以上的次数
    ,nvl(n.a_cl_cm_cnt_tot, o.a_cl_cm_cnt_tot) as a_cl_cm_cnt_tot -- 信贷总账户数
    ,nvl(n.final_risk_coef, o.final_risk_coef) as final_risk_coef -- 最终的风险系数
    ,case when
            n.grade_key_id is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.grade_key_id is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.grade_key_id is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.rcds_ir_grade_a_score_input_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.rcds_ir_grade_a_score_input where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.grade_key_id = n.grade_key_id
where (
        o.grade_key_id is null
    )
    or (
        n.grade_key_id is null
    )
    or (
        o.serialno <> n.serialno
        or o.data_time <> n.data_time
        or o.a_ln_cm_cnt_npf_secure_p <> n.a_ln_cm_cnt_npf_secure_p
        or o.bill_repayment <> n.bill_repayment
        or o.repayment <> n.repayment
        or o.a_cl_am_mob_nd_max <> n.a_cl_am_mob_nd_max
        or o.a_cc_cm_cnt_urt100 <> n.a_cc_cm_cnt_urt100
        or o.a_cl_am_delqfmth_l3m_m1 <> n.a_cl_am_delqfmth_l3m_m1
        or o.a_cl_am_delqr_l24m_m1 <> n.a_cl_am_delqr_l24m_m1
        or o.a_freq_query_6m_ca <> n.a_freq_query_6m_ca
        or o.a_cl_cm_cnt_l6m_df_p <> n.a_cl_cm_cnt_l6m_df_p
        or o.a_ln_cm_cnt_mana_ndf_l12_p <> n.a_ln_cm_cnt_mana_ndf_l12_p
        or o.a_ln_cm_cnt_house <> n.a_ln_cm_cnt_house
        or o.a_cc_am_inm_max <> n.a_cc_am_inm_max
        or o.marriage_sex <> n.marriage_sex
        or o.age <> n.age
        or o.industrytype <> n.industrytype
        or o.eduexperience <> n.eduexperience
        or o.agv_utilization <> n.agv_utilization
        or o.a_cl_am_delqfmth_l24m_m1 <> n.a_cl_am_delqfmth_l24m_m1
        or o.a_cl_am_delqm_l12m_max <> n.a_cl_am_delqm_l12m_max
        or o.a_freq_query_12m_ca <> n.a_freq_query_12m_ca
        or o.residence_type <> n.residence_type
        or o.a_cc_cm_cnt_urt30_p <> n.a_cc_cm_cnt_urt30_p
        or o.a_cc_am_delqf_l12m_m1 <> n.a_cc_am_delqf_l12m_m1
        or o.a_cl_cm_cnt_tot <> n.a_cl_cm_cnt_tot
        or o.final_risk_coef <> n.final_risk_coef
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.rcds_ir_grade_a_score_input_cl(
            grade_key_id -- 申请评分流水号
            ,serialno -- 申请流水号
            ,data_time -- 数据记录时间
            ,a_ln_cm_cnt_npf_secure_p -- 未结清抵押贷款的账户数/所有未结清贷款的账户数
            ,bill_repayment -- 信用卡本月实还总金额/上一期账单最低应还款总额
            ,repayment -- 信用卡总已用额度/信用卡总授信共享额度
            ,a_cl_am_mob_nd_max -- 从未逾期信贷（信用卡+贷款）账户距今最长账龄
            ,a_cc_cm_cnt_urt100 -- 信用卡已用额度/授信额度超过100%的账户数
            ,a_cl_am_delqfmth_l3m_m1 -- 过去3个月信贷（信用卡+贷款）逾期的月份数
            ,a_cl_am_delqr_l24m_m1 -- 最近一次信贷（信用卡+贷款）逾期距今月份数
            ,a_freq_query_6m_ca -- 主申人查询过去6个月信贷审核查询次数
            ,a_cl_cm_cnt_l6m_df_p -- 过去6个月有过逾期的信贷帐户占比
            ,a_ln_cm_cnt_mana_ndf_l12_p -- 过去12个月从未逾期的经营类贷款账户数/总的经营类贷款帐户数
            ,a_ln_cm_cnt_house -- 房贷笔数
            ,a_cc_am_inm_max -- 信用卡开户日期距报告日期最长时间间隔
            ,marriage_sex -- 婚姻状态性别
            ,age -- 年龄
            ,industrytype -- 行业类型
            ,eduexperience -- 教育程度
            ,agv_utilization -- 使用率
            ,a_cl_am_delqfmth_l24m_m1 -- 过去24个月信贷（信用卡+贷款）逾期的月份数
            ,a_cl_am_delqm_l12m_max -- 过去12个月信贷（信用卡+贷款）最大逾期期数
            ,a_freq_query_12m_ca -- 主申人查询过去12个月信贷审核查询次数
            ,residence_type -- 现住房状况
            ,a_cc_cm_cnt_urt30_p -- 信用卡已用额度/授信额度超过30%的信用卡账户数/总信用卡账户数
            ,a_cc_am_delqf_l12m_m1 -- 信用卡过去12个月逾期1期及以上的次数
            ,a_cl_cm_cnt_tot -- 信贷总账户数
            ,final_risk_coef -- 最终的风险系数
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.rcds_ir_grade_a_score_input_op(
            grade_key_id -- 申请评分流水号
            ,serialno -- 申请流水号
            ,data_time -- 数据记录时间
            ,a_ln_cm_cnt_npf_secure_p -- 未结清抵押贷款的账户数/所有未结清贷款的账户数
            ,bill_repayment -- 信用卡本月实还总金额/上一期账单最低应还款总额
            ,repayment -- 信用卡总已用额度/信用卡总授信共享额度
            ,a_cl_am_mob_nd_max -- 从未逾期信贷（信用卡+贷款）账户距今最长账龄
            ,a_cc_cm_cnt_urt100 -- 信用卡已用额度/授信额度超过100%的账户数
            ,a_cl_am_delqfmth_l3m_m1 -- 过去3个月信贷（信用卡+贷款）逾期的月份数
            ,a_cl_am_delqr_l24m_m1 -- 最近一次信贷（信用卡+贷款）逾期距今月份数
            ,a_freq_query_6m_ca -- 主申人查询过去6个月信贷审核查询次数
            ,a_cl_cm_cnt_l6m_df_p -- 过去6个月有过逾期的信贷帐户占比
            ,a_ln_cm_cnt_mana_ndf_l12_p -- 过去12个月从未逾期的经营类贷款账户数/总的经营类贷款帐户数
            ,a_ln_cm_cnt_house -- 房贷笔数
            ,a_cc_am_inm_max -- 信用卡开户日期距报告日期最长时间间隔
            ,marriage_sex -- 婚姻状态性别
            ,age -- 年龄
            ,industrytype -- 行业类型
            ,eduexperience -- 教育程度
            ,agv_utilization -- 使用率
            ,a_cl_am_delqfmth_l24m_m1 -- 过去24个月信贷（信用卡+贷款）逾期的月份数
            ,a_cl_am_delqm_l12m_max -- 过去12个月信贷（信用卡+贷款）最大逾期期数
            ,a_freq_query_12m_ca -- 主申人查询过去12个月信贷审核查询次数
            ,residence_type -- 现住房状况
            ,a_cc_cm_cnt_urt30_p -- 信用卡已用额度/授信额度超过30%的信用卡账户数/总信用卡账户数
            ,a_cc_am_delqf_l12m_m1 -- 信用卡过去12个月逾期1期及以上的次数
            ,a_cl_cm_cnt_tot -- 信贷总账户数
            ,final_risk_coef -- 最终的风险系数
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.grade_key_id -- 申请评分流水号
    ,o.serialno -- 申请流水号
    ,o.data_time -- 数据记录时间
    ,o.a_ln_cm_cnt_npf_secure_p -- 未结清抵押贷款的账户数/所有未结清贷款的账户数
    ,o.bill_repayment -- 信用卡本月实还总金额/上一期账单最低应还款总额
    ,o.repayment -- 信用卡总已用额度/信用卡总授信共享额度
    ,o.a_cl_am_mob_nd_max -- 从未逾期信贷（信用卡+贷款）账户距今最长账龄
    ,o.a_cc_cm_cnt_urt100 -- 信用卡已用额度/授信额度超过100%的账户数
    ,o.a_cl_am_delqfmth_l3m_m1 -- 过去3个月信贷（信用卡+贷款）逾期的月份数
    ,o.a_cl_am_delqr_l24m_m1 -- 最近一次信贷（信用卡+贷款）逾期距今月份数
    ,o.a_freq_query_6m_ca -- 主申人查询过去6个月信贷审核查询次数
    ,o.a_cl_cm_cnt_l6m_df_p -- 过去6个月有过逾期的信贷帐户占比
    ,o.a_ln_cm_cnt_mana_ndf_l12_p -- 过去12个月从未逾期的经营类贷款账户数/总的经营类贷款帐户数
    ,o.a_ln_cm_cnt_house -- 房贷笔数
    ,o.a_cc_am_inm_max -- 信用卡开户日期距报告日期最长时间间隔
    ,o.marriage_sex -- 婚姻状态性别
    ,o.age -- 年龄
    ,o.industrytype -- 行业类型
    ,o.eduexperience -- 教育程度
    ,o.agv_utilization -- 使用率
    ,o.a_cl_am_delqfmth_l24m_m1 -- 过去24个月信贷（信用卡+贷款）逾期的月份数
    ,o.a_cl_am_delqm_l12m_max -- 过去12个月信贷（信用卡+贷款）最大逾期期数
    ,o.a_freq_query_12m_ca -- 主申人查询过去12个月信贷审核查询次数
    ,o.residence_type -- 现住房状况
    ,o.a_cc_cm_cnt_urt30_p -- 信用卡已用额度/授信额度超过30%的信用卡账户数/总信用卡账户数
    ,o.a_cc_am_delqf_l12m_m1 -- 信用卡过去12个月逾期1期及以上的次数
    ,o.a_cl_cm_cnt_tot -- 信贷总账户数
    ,o.final_risk_coef -- 最终的风险系数
    ,o.start_dt -- 开始时间
    ,case when n.start_dt is not null then to_date('${batch_date}', 'yyyymmdd')
          when o.end_dt >= to_date('${batch_date}','yyyymmdd') then to_date('20991231','yyyymmdd')
          else o.end_dt
     end as end_dt -- 结束时间
    ,o.id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from ${iol_schema}.rcds_ir_grade_a_score_input_bk o
    left join ${iol_schema}.rcds_ir_grade_a_score_input_op n
        on
            o.grade_key_id = n.grade_key_id
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.rcds_ir_grade_a_score_input_cl d
        on
            o.grade_key_id = d.grade_key_id
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
-- truncate table ${iol_schema}.rcds_ir_grade_a_score_input;

-- 4.2 exchange partition
alter table ${iol_schema}.rcds_ir_grade_a_score_input exchange partition p_19000101 with table ${iol_schema}.rcds_ir_grade_a_score_input_cl;
alter table ${iol_schema}.rcds_ir_grade_a_score_input exchange partition p_20991231 with table ${iol_schema}.rcds_ir_grade_a_score_input_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.rcds_ir_grade_a_score_input to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.rcds_ir_grade_a_score_input_op purge;
drop table ${iol_schema}.rcds_ir_grade_a_score_input_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.rcds_ir_grade_a_score_input_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'rcds_ir_grade_a_score_input',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
