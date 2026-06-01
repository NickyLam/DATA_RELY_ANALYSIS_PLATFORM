/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_rcds_ir_tzbl_a_zfdkyqxx
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
create table ${iol_schema}.rcds_ir_tzbl_a_zfdkyqxx_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.rcds_ir_tzbl_a_zfdkyqxx;

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.rcds_ir_tzbl_a_zfdkyqxx_op purge;
drop table ${iol_schema}.rcds_ir_tzbl_a_zfdkyqxx_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.rcds_ir_tzbl_a_zfdkyqxx_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.rcds_ir_tzbl_a_zfdkyqxx where 0=1;

create table ${iol_schema}.rcds_ir_tzbl_a_zfdkyqxx_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.rcds_ir_tzbl_a_zfdkyqxx where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.rcds_ir_tzbl_a_zfdkyqxx_cl(
            grade_key_id -- 申请评分流水号
            ,data_time -- 数据记录时间
            ,serialno -- 申请流水号
            ,create_time -- 创建时间
            ,a_ln_mog_am_delqfmth_l12m_m1 -- 住房贷款过去12个月M1+逾期的月数
            ,a_ln_mog_am_delqfmth_l12m_m2 -- 住房贷款过去12个月M2+逾期的月数
            ,a_ln_mog_am_delqfmth_l12m_m3 -- 住房贷款过去12个月M3+逾期的月数
            ,a_ln_mog_am_delqfmth_l12m_m4 -- 住房贷款过去12个月M4+逾期的月数
            ,a_ln_mog_am_delqfmth_l24m_m1 -- 住房贷款过去24个月M1+逾期的月数
            ,a_ln_mog_am_delqfmth_l24m_m2 -- 住房贷款过去24个月M2+逾期的月数
            ,a_ln_mog_am_delqfmth_l24m_m3 -- 住房贷款过去24个月M3+逾期的月数
            ,a_ln_mog_am_delqfmth_l24m_m4 -- 住房贷款过去24个月M4+逾期的月数
            ,a_ln_mog_am_delqfmth_l3m_m1 -- 住房贷款过去3个月M1+逾期的月数
            ,a_ln_mog_am_delqfmth_l3m_m2 -- 住房贷款过去3个月M2+逾期的月数
            ,a_ln_mog_am_delqfmth_l3m_m3 -- 住房贷款过去3个月M3+逾期的月数
            ,a_ln_mog_am_delqfmth_l3m_m4 -- 住房贷款过去3个月M4+逾期的月数
            ,a_ln_mog_am_delqfmth_l6m_m1 -- 住房贷款过去6个月M1+逾期的月数
            ,a_ln_mog_am_delqfmth_l6m_m2 -- 住房贷款过去6个月M2+逾期的月数
            ,a_ln_mog_am_delqfmth_l6m_m3 -- 住房贷款过去6个月M3+逾期的月数
            ,a_ln_mog_am_delqfmth_l6m_m4 -- 住房贷款过去6个月M4+逾期的月数
            ,a_ln_mog_am_delqm_l3m_max -- 住房贷款过去3个月的最大逾期期数
            ,a_ln_mog_am_delqm_l6m_max -- 住房贷款过去6个月的最大逾期期数
            ,a_ln_mog_am_delqm_l12m_max -- 住房贷款过去12个月的最大逾期期数
            ,a_ln_mog_am_delqm_l24m_max -- 住房贷款过去24个月的最大逾期期数
            ,a_ln_mog_am_delqr_l3m_m1 -- 住房贷款过去3个月最近一次逾期距今的月份数
            ,a_ln_mog_am_delqr_l6m_m1 -- 住房贷款过去6个月最近一次逾期距今的月份数
            ,a_ln_mog_am_delqr_l12m_m1 -- 住房贷款过去12个月最近一次逾期距今的月份数
            ,a_ln_mog_am_delqr_l24m_m1 -- 住房贷款过去24个月最近一次逾期距今的月份数
            ,a_ln_mog_am_delqr_l3m_m2 -- 住房贷款过去3个月最近一次M2逾期距今的月份数
            ,a_ln_mog_am_delqr_l6m_m2 -- 住房贷款过去6个月最近一次M2逾期距今的月份数
            ,a_ln_mog_am_delqr_l12m_m2 -- 住房贷款过去12个月最近一次M2逾期距今的月份数
            ,a_ln_mog_am_delqr_l24m_m2 -- 住房贷款过去24个月最近一次M2逾期距今的月份数
            ,a_ln_mog_am_delqr_l3m_m3 -- 住房贷款过去3个月最近一次M3逾期距今的月份数
            ,a_ln_mog_am_delqr_l6m_m3 -- 住房贷款过去6个月最近一次M3逾期距今的月份数
            ,a_ln_mog_am_delqr_l12m_m3 -- 住房贷款过去12个月最近一次M3逾期距今的月份数
            ,a_ln_mog_am_delqr_l24m_m3 -- 住房贷款过去24个月最近一次M3逾期距今的月份数
            ,a_ln_mog_am_delqf_l3m_m1 -- 住房贷款过去3个月逾期1期的次数
            ,a_ln_mog_am_delqf_l3m_m2 -- 住房贷款过去3个月逾期2期的次数
            ,a_ln_mog_am_delqf_l3m_m3 -- 住房贷款过去3个月逾期3期的次数
            ,a_ln_mog_am_delqf_l3m_m4_plus -- 住房贷款过去3个月逾期4期或以上的次数
            ,a_ln_mog_am_delqf_l6m_m1 -- 住房贷款过去6个月逾期1期的次数
            ,a_ln_mog_am_delqf_l6m_m2 -- 住房贷款过去6个月逾期2期的次数
            ,a_ln_mog_am_delqf_l6m_m3 -- 住房贷款过去6个月逾期3期的次数
            ,a_ln_mog_am_delqf_l6m_m4_plus -- 住房贷款过去6个月逾期4期或以上的次数
            ,a_ln_mog_am_delqf_l12m_m1 -- 住房贷款过去12个月逾期1期的次数
            ,a_ln_mog_am_delqf_l12m_m2 -- 住房贷款过去12个月逾期2期的次数
            ,a_ln_mog_am_delqf_l12m_m3 -- 住房贷款过去12个月逾期3期的次数
            ,a_ln_mog_am_delqf_l12m_m4_plus -- 住房贷款过去12个月逾期4期或以上的次数
            ,a_ln_mog_am_delqf_l24m_m1 -- 住房贷款过去24个月逾期1期的次数
            ,a_ln_mog_am_delqf_l24m_m2 -- 住房贷款过去24个月逾期2期的次数
            ,a_ln_mog_am_delqf_l24m_m3 -- 住房贷款过去24个月逾期3期的次数
            ,a_ln_mog_am_delqf_l24m_m4_plus -- 住房贷款过去24个月逾期4期或以上的次数
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.rcds_ir_tzbl_a_zfdkyqxx_op(
            grade_key_id -- 申请评分流水号
            ,data_time -- 数据记录时间
            ,serialno -- 申请流水号
            ,create_time -- 创建时间
            ,a_ln_mog_am_delqfmth_l12m_m1 -- 住房贷款过去12个月M1+逾期的月数
            ,a_ln_mog_am_delqfmth_l12m_m2 -- 住房贷款过去12个月M2+逾期的月数
            ,a_ln_mog_am_delqfmth_l12m_m3 -- 住房贷款过去12个月M3+逾期的月数
            ,a_ln_mog_am_delqfmth_l12m_m4 -- 住房贷款过去12个月M4+逾期的月数
            ,a_ln_mog_am_delqfmth_l24m_m1 -- 住房贷款过去24个月M1+逾期的月数
            ,a_ln_mog_am_delqfmth_l24m_m2 -- 住房贷款过去24个月M2+逾期的月数
            ,a_ln_mog_am_delqfmth_l24m_m3 -- 住房贷款过去24个月M3+逾期的月数
            ,a_ln_mog_am_delqfmth_l24m_m4 -- 住房贷款过去24个月M4+逾期的月数
            ,a_ln_mog_am_delqfmth_l3m_m1 -- 住房贷款过去3个月M1+逾期的月数
            ,a_ln_mog_am_delqfmth_l3m_m2 -- 住房贷款过去3个月M2+逾期的月数
            ,a_ln_mog_am_delqfmth_l3m_m3 -- 住房贷款过去3个月M3+逾期的月数
            ,a_ln_mog_am_delqfmth_l3m_m4 -- 住房贷款过去3个月M4+逾期的月数
            ,a_ln_mog_am_delqfmth_l6m_m1 -- 住房贷款过去6个月M1+逾期的月数
            ,a_ln_mog_am_delqfmth_l6m_m2 -- 住房贷款过去6个月M2+逾期的月数
            ,a_ln_mog_am_delqfmth_l6m_m3 -- 住房贷款过去6个月M3+逾期的月数
            ,a_ln_mog_am_delqfmth_l6m_m4 -- 住房贷款过去6个月M4+逾期的月数
            ,a_ln_mog_am_delqm_l3m_max -- 住房贷款过去3个月的最大逾期期数
            ,a_ln_mog_am_delqm_l6m_max -- 住房贷款过去6个月的最大逾期期数
            ,a_ln_mog_am_delqm_l12m_max -- 住房贷款过去12个月的最大逾期期数
            ,a_ln_mog_am_delqm_l24m_max -- 住房贷款过去24个月的最大逾期期数
            ,a_ln_mog_am_delqr_l3m_m1 -- 住房贷款过去3个月最近一次逾期距今的月份数
            ,a_ln_mog_am_delqr_l6m_m1 -- 住房贷款过去6个月最近一次逾期距今的月份数
            ,a_ln_mog_am_delqr_l12m_m1 -- 住房贷款过去12个月最近一次逾期距今的月份数
            ,a_ln_mog_am_delqr_l24m_m1 -- 住房贷款过去24个月最近一次逾期距今的月份数
            ,a_ln_mog_am_delqr_l3m_m2 -- 住房贷款过去3个月最近一次M2逾期距今的月份数
            ,a_ln_mog_am_delqr_l6m_m2 -- 住房贷款过去6个月最近一次M2逾期距今的月份数
            ,a_ln_mog_am_delqr_l12m_m2 -- 住房贷款过去12个月最近一次M2逾期距今的月份数
            ,a_ln_mog_am_delqr_l24m_m2 -- 住房贷款过去24个月最近一次M2逾期距今的月份数
            ,a_ln_mog_am_delqr_l3m_m3 -- 住房贷款过去3个月最近一次M3逾期距今的月份数
            ,a_ln_mog_am_delqr_l6m_m3 -- 住房贷款过去6个月最近一次M3逾期距今的月份数
            ,a_ln_mog_am_delqr_l12m_m3 -- 住房贷款过去12个月最近一次M3逾期距今的月份数
            ,a_ln_mog_am_delqr_l24m_m3 -- 住房贷款过去24个月最近一次M3逾期距今的月份数
            ,a_ln_mog_am_delqf_l3m_m1 -- 住房贷款过去3个月逾期1期的次数
            ,a_ln_mog_am_delqf_l3m_m2 -- 住房贷款过去3个月逾期2期的次数
            ,a_ln_mog_am_delqf_l3m_m3 -- 住房贷款过去3个月逾期3期的次数
            ,a_ln_mog_am_delqf_l3m_m4_plus -- 住房贷款过去3个月逾期4期或以上的次数
            ,a_ln_mog_am_delqf_l6m_m1 -- 住房贷款过去6个月逾期1期的次数
            ,a_ln_mog_am_delqf_l6m_m2 -- 住房贷款过去6个月逾期2期的次数
            ,a_ln_mog_am_delqf_l6m_m3 -- 住房贷款过去6个月逾期3期的次数
            ,a_ln_mog_am_delqf_l6m_m4_plus -- 住房贷款过去6个月逾期4期或以上的次数
            ,a_ln_mog_am_delqf_l12m_m1 -- 住房贷款过去12个月逾期1期的次数
            ,a_ln_mog_am_delqf_l12m_m2 -- 住房贷款过去12个月逾期2期的次数
            ,a_ln_mog_am_delqf_l12m_m3 -- 住房贷款过去12个月逾期3期的次数
            ,a_ln_mog_am_delqf_l12m_m4_plus -- 住房贷款过去12个月逾期4期或以上的次数
            ,a_ln_mog_am_delqf_l24m_m1 -- 住房贷款过去24个月逾期1期的次数
            ,a_ln_mog_am_delqf_l24m_m2 -- 住房贷款过去24个月逾期2期的次数
            ,a_ln_mog_am_delqf_l24m_m3 -- 住房贷款过去24个月逾期3期的次数
            ,a_ln_mog_am_delqf_l24m_m4_plus -- 住房贷款过去24个月逾期4期或以上的次数
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.grade_key_id, o.grade_key_id) as grade_key_id -- 申请评分流水号
    ,nvl(n.data_time, o.data_time) as data_time -- 数据记录时间
    ,nvl(n.serialno, o.serialno) as serialno -- 申请流水号
    ,nvl(n.create_time, o.create_time) as create_time -- 创建时间
    ,nvl(n.a_ln_mog_am_delqfmth_l12m_m1, o.a_ln_mog_am_delqfmth_l12m_m1) as a_ln_mog_am_delqfmth_l12m_m1 -- 住房贷款过去12个月M1+逾期的月数
    ,nvl(n.a_ln_mog_am_delqfmth_l12m_m2, o.a_ln_mog_am_delqfmth_l12m_m2) as a_ln_mog_am_delqfmth_l12m_m2 -- 住房贷款过去12个月M2+逾期的月数
    ,nvl(n.a_ln_mog_am_delqfmth_l12m_m3, o.a_ln_mog_am_delqfmth_l12m_m3) as a_ln_mog_am_delqfmth_l12m_m3 -- 住房贷款过去12个月M3+逾期的月数
    ,nvl(n.a_ln_mog_am_delqfmth_l12m_m4, o.a_ln_mog_am_delqfmth_l12m_m4) as a_ln_mog_am_delqfmth_l12m_m4 -- 住房贷款过去12个月M4+逾期的月数
    ,nvl(n.a_ln_mog_am_delqfmth_l24m_m1, o.a_ln_mog_am_delqfmth_l24m_m1) as a_ln_mog_am_delqfmth_l24m_m1 -- 住房贷款过去24个月M1+逾期的月数
    ,nvl(n.a_ln_mog_am_delqfmth_l24m_m2, o.a_ln_mog_am_delqfmth_l24m_m2) as a_ln_mog_am_delqfmth_l24m_m2 -- 住房贷款过去24个月M2+逾期的月数
    ,nvl(n.a_ln_mog_am_delqfmth_l24m_m3, o.a_ln_mog_am_delqfmth_l24m_m3) as a_ln_mog_am_delqfmth_l24m_m3 -- 住房贷款过去24个月M3+逾期的月数
    ,nvl(n.a_ln_mog_am_delqfmth_l24m_m4, o.a_ln_mog_am_delqfmth_l24m_m4) as a_ln_mog_am_delqfmth_l24m_m4 -- 住房贷款过去24个月M4+逾期的月数
    ,nvl(n.a_ln_mog_am_delqfmth_l3m_m1, o.a_ln_mog_am_delqfmth_l3m_m1) as a_ln_mog_am_delqfmth_l3m_m1 -- 住房贷款过去3个月M1+逾期的月数
    ,nvl(n.a_ln_mog_am_delqfmth_l3m_m2, o.a_ln_mog_am_delqfmth_l3m_m2) as a_ln_mog_am_delqfmth_l3m_m2 -- 住房贷款过去3个月M2+逾期的月数
    ,nvl(n.a_ln_mog_am_delqfmth_l3m_m3, o.a_ln_mog_am_delqfmth_l3m_m3) as a_ln_mog_am_delqfmth_l3m_m3 -- 住房贷款过去3个月M3+逾期的月数
    ,nvl(n.a_ln_mog_am_delqfmth_l3m_m4, o.a_ln_mog_am_delqfmth_l3m_m4) as a_ln_mog_am_delqfmth_l3m_m4 -- 住房贷款过去3个月M4+逾期的月数
    ,nvl(n.a_ln_mog_am_delqfmth_l6m_m1, o.a_ln_mog_am_delqfmth_l6m_m1) as a_ln_mog_am_delqfmth_l6m_m1 -- 住房贷款过去6个月M1+逾期的月数
    ,nvl(n.a_ln_mog_am_delqfmth_l6m_m2, o.a_ln_mog_am_delqfmth_l6m_m2) as a_ln_mog_am_delqfmth_l6m_m2 -- 住房贷款过去6个月M2+逾期的月数
    ,nvl(n.a_ln_mog_am_delqfmth_l6m_m3, o.a_ln_mog_am_delqfmth_l6m_m3) as a_ln_mog_am_delqfmth_l6m_m3 -- 住房贷款过去6个月M3+逾期的月数
    ,nvl(n.a_ln_mog_am_delqfmth_l6m_m4, o.a_ln_mog_am_delqfmth_l6m_m4) as a_ln_mog_am_delqfmth_l6m_m4 -- 住房贷款过去6个月M4+逾期的月数
    ,nvl(n.a_ln_mog_am_delqm_l3m_max, o.a_ln_mog_am_delqm_l3m_max) as a_ln_mog_am_delqm_l3m_max -- 住房贷款过去3个月的最大逾期期数
    ,nvl(n.a_ln_mog_am_delqm_l6m_max, o.a_ln_mog_am_delqm_l6m_max) as a_ln_mog_am_delqm_l6m_max -- 住房贷款过去6个月的最大逾期期数
    ,nvl(n.a_ln_mog_am_delqm_l12m_max, o.a_ln_mog_am_delqm_l12m_max) as a_ln_mog_am_delqm_l12m_max -- 住房贷款过去12个月的最大逾期期数
    ,nvl(n.a_ln_mog_am_delqm_l24m_max, o.a_ln_mog_am_delqm_l24m_max) as a_ln_mog_am_delqm_l24m_max -- 住房贷款过去24个月的最大逾期期数
    ,nvl(n.a_ln_mog_am_delqr_l3m_m1, o.a_ln_mog_am_delqr_l3m_m1) as a_ln_mog_am_delqr_l3m_m1 -- 住房贷款过去3个月最近一次逾期距今的月份数
    ,nvl(n.a_ln_mog_am_delqr_l6m_m1, o.a_ln_mog_am_delqr_l6m_m1) as a_ln_mog_am_delqr_l6m_m1 -- 住房贷款过去6个月最近一次逾期距今的月份数
    ,nvl(n.a_ln_mog_am_delqr_l12m_m1, o.a_ln_mog_am_delqr_l12m_m1) as a_ln_mog_am_delqr_l12m_m1 -- 住房贷款过去12个月最近一次逾期距今的月份数
    ,nvl(n.a_ln_mog_am_delqr_l24m_m1, o.a_ln_mog_am_delqr_l24m_m1) as a_ln_mog_am_delqr_l24m_m1 -- 住房贷款过去24个月最近一次逾期距今的月份数
    ,nvl(n.a_ln_mog_am_delqr_l3m_m2, o.a_ln_mog_am_delqr_l3m_m2) as a_ln_mog_am_delqr_l3m_m2 -- 住房贷款过去3个月最近一次M2逾期距今的月份数
    ,nvl(n.a_ln_mog_am_delqr_l6m_m2, o.a_ln_mog_am_delqr_l6m_m2) as a_ln_mog_am_delqr_l6m_m2 -- 住房贷款过去6个月最近一次M2逾期距今的月份数
    ,nvl(n.a_ln_mog_am_delqr_l12m_m2, o.a_ln_mog_am_delqr_l12m_m2) as a_ln_mog_am_delqr_l12m_m2 -- 住房贷款过去12个月最近一次M2逾期距今的月份数
    ,nvl(n.a_ln_mog_am_delqr_l24m_m2, o.a_ln_mog_am_delqr_l24m_m2) as a_ln_mog_am_delqr_l24m_m2 -- 住房贷款过去24个月最近一次M2逾期距今的月份数
    ,nvl(n.a_ln_mog_am_delqr_l3m_m3, o.a_ln_mog_am_delqr_l3m_m3) as a_ln_mog_am_delqr_l3m_m3 -- 住房贷款过去3个月最近一次M3逾期距今的月份数
    ,nvl(n.a_ln_mog_am_delqr_l6m_m3, o.a_ln_mog_am_delqr_l6m_m3) as a_ln_mog_am_delqr_l6m_m3 -- 住房贷款过去6个月最近一次M3逾期距今的月份数
    ,nvl(n.a_ln_mog_am_delqr_l12m_m3, o.a_ln_mog_am_delqr_l12m_m3) as a_ln_mog_am_delqr_l12m_m3 -- 住房贷款过去12个月最近一次M3逾期距今的月份数
    ,nvl(n.a_ln_mog_am_delqr_l24m_m3, o.a_ln_mog_am_delqr_l24m_m3) as a_ln_mog_am_delqr_l24m_m3 -- 住房贷款过去24个月最近一次M3逾期距今的月份数
    ,nvl(n.a_ln_mog_am_delqf_l3m_m1, o.a_ln_mog_am_delqf_l3m_m1) as a_ln_mog_am_delqf_l3m_m1 -- 住房贷款过去3个月逾期1期的次数
    ,nvl(n.a_ln_mog_am_delqf_l3m_m2, o.a_ln_mog_am_delqf_l3m_m2) as a_ln_mog_am_delqf_l3m_m2 -- 住房贷款过去3个月逾期2期的次数
    ,nvl(n.a_ln_mog_am_delqf_l3m_m3, o.a_ln_mog_am_delqf_l3m_m3) as a_ln_mog_am_delqf_l3m_m3 -- 住房贷款过去3个月逾期3期的次数
    ,nvl(n.a_ln_mog_am_delqf_l3m_m4_plus, o.a_ln_mog_am_delqf_l3m_m4_plus) as a_ln_mog_am_delqf_l3m_m4_plus -- 住房贷款过去3个月逾期4期或以上的次数
    ,nvl(n.a_ln_mog_am_delqf_l6m_m1, o.a_ln_mog_am_delqf_l6m_m1) as a_ln_mog_am_delqf_l6m_m1 -- 住房贷款过去6个月逾期1期的次数
    ,nvl(n.a_ln_mog_am_delqf_l6m_m2, o.a_ln_mog_am_delqf_l6m_m2) as a_ln_mog_am_delqf_l6m_m2 -- 住房贷款过去6个月逾期2期的次数
    ,nvl(n.a_ln_mog_am_delqf_l6m_m3, o.a_ln_mog_am_delqf_l6m_m3) as a_ln_mog_am_delqf_l6m_m3 -- 住房贷款过去6个月逾期3期的次数
    ,nvl(n.a_ln_mog_am_delqf_l6m_m4_plus, o.a_ln_mog_am_delqf_l6m_m4_plus) as a_ln_mog_am_delqf_l6m_m4_plus -- 住房贷款过去6个月逾期4期或以上的次数
    ,nvl(n.a_ln_mog_am_delqf_l12m_m1, o.a_ln_mog_am_delqf_l12m_m1) as a_ln_mog_am_delqf_l12m_m1 -- 住房贷款过去12个月逾期1期的次数
    ,nvl(n.a_ln_mog_am_delqf_l12m_m2, o.a_ln_mog_am_delqf_l12m_m2) as a_ln_mog_am_delqf_l12m_m2 -- 住房贷款过去12个月逾期2期的次数
    ,nvl(n.a_ln_mog_am_delqf_l12m_m3, o.a_ln_mog_am_delqf_l12m_m3) as a_ln_mog_am_delqf_l12m_m3 -- 住房贷款过去12个月逾期3期的次数
    ,nvl(n.a_ln_mog_am_delqf_l12m_m4_plus, o.a_ln_mog_am_delqf_l12m_m4_plus) as a_ln_mog_am_delqf_l12m_m4_plus -- 住房贷款过去12个月逾期4期或以上的次数
    ,nvl(n.a_ln_mog_am_delqf_l24m_m1, o.a_ln_mog_am_delqf_l24m_m1) as a_ln_mog_am_delqf_l24m_m1 -- 住房贷款过去24个月逾期1期的次数
    ,nvl(n.a_ln_mog_am_delqf_l24m_m2, o.a_ln_mog_am_delqf_l24m_m2) as a_ln_mog_am_delqf_l24m_m2 -- 住房贷款过去24个月逾期2期的次数
    ,nvl(n.a_ln_mog_am_delqf_l24m_m3, o.a_ln_mog_am_delqf_l24m_m3) as a_ln_mog_am_delqf_l24m_m3 -- 住房贷款过去24个月逾期3期的次数
    ,nvl(n.a_ln_mog_am_delqf_l24m_m4_plus, o.a_ln_mog_am_delqf_l24m_m4_plus) as a_ln_mog_am_delqf_l24m_m4_plus -- 住房贷款过去24个月逾期4期或以上的次数
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
from (select * from ${iol_schema}.rcds_ir_tzbl_a_zfdkyqxx_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.rcds_ir_tzbl_a_zfdkyqxx where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.grade_key_id = n.grade_key_id
where (
        o.grade_key_id is null
    )
    or (
        n.grade_key_id is null
    )
    or (
        o.data_time <> n.data_time
        or o.serialno <> n.serialno
        or o.create_time <> n.create_time
        or o.a_ln_mog_am_delqfmth_l12m_m1 <> n.a_ln_mog_am_delqfmth_l12m_m1
        or o.a_ln_mog_am_delqfmth_l12m_m2 <> n.a_ln_mog_am_delqfmth_l12m_m2
        or o.a_ln_mog_am_delqfmth_l12m_m3 <> n.a_ln_mog_am_delqfmth_l12m_m3
        or o.a_ln_mog_am_delqfmth_l12m_m4 <> n.a_ln_mog_am_delqfmth_l12m_m4
        or o.a_ln_mog_am_delqfmth_l24m_m1 <> n.a_ln_mog_am_delqfmth_l24m_m1
        or o.a_ln_mog_am_delqfmth_l24m_m2 <> n.a_ln_mog_am_delqfmth_l24m_m2
        or o.a_ln_mog_am_delqfmth_l24m_m3 <> n.a_ln_mog_am_delqfmth_l24m_m3
        or o.a_ln_mog_am_delqfmth_l24m_m4 <> n.a_ln_mog_am_delqfmth_l24m_m4
        or o.a_ln_mog_am_delqfmth_l3m_m1 <> n.a_ln_mog_am_delqfmth_l3m_m1
        or o.a_ln_mog_am_delqfmth_l3m_m2 <> n.a_ln_mog_am_delqfmth_l3m_m2
        or o.a_ln_mog_am_delqfmth_l3m_m3 <> n.a_ln_mog_am_delqfmth_l3m_m3
        or o.a_ln_mog_am_delqfmth_l3m_m4 <> n.a_ln_mog_am_delqfmth_l3m_m4
        or o.a_ln_mog_am_delqfmth_l6m_m1 <> n.a_ln_mog_am_delqfmth_l6m_m1
        or o.a_ln_mog_am_delqfmth_l6m_m2 <> n.a_ln_mog_am_delqfmth_l6m_m2
        or o.a_ln_mog_am_delqfmth_l6m_m3 <> n.a_ln_mog_am_delqfmth_l6m_m3
        or o.a_ln_mog_am_delqfmth_l6m_m4 <> n.a_ln_mog_am_delqfmth_l6m_m4
        or o.a_ln_mog_am_delqm_l3m_max <> n.a_ln_mog_am_delqm_l3m_max
        or o.a_ln_mog_am_delqm_l6m_max <> n.a_ln_mog_am_delqm_l6m_max
        or o.a_ln_mog_am_delqm_l12m_max <> n.a_ln_mog_am_delqm_l12m_max
        or o.a_ln_mog_am_delqm_l24m_max <> n.a_ln_mog_am_delqm_l24m_max
        or o.a_ln_mog_am_delqr_l3m_m1 <> n.a_ln_mog_am_delqr_l3m_m1
        or o.a_ln_mog_am_delqr_l6m_m1 <> n.a_ln_mog_am_delqr_l6m_m1
        or o.a_ln_mog_am_delqr_l12m_m1 <> n.a_ln_mog_am_delqr_l12m_m1
        or o.a_ln_mog_am_delqr_l24m_m1 <> n.a_ln_mog_am_delqr_l24m_m1
        or o.a_ln_mog_am_delqr_l3m_m2 <> n.a_ln_mog_am_delqr_l3m_m2
        or o.a_ln_mog_am_delqr_l6m_m2 <> n.a_ln_mog_am_delqr_l6m_m2
        or o.a_ln_mog_am_delqr_l12m_m2 <> n.a_ln_mog_am_delqr_l12m_m2
        or o.a_ln_mog_am_delqr_l24m_m2 <> n.a_ln_mog_am_delqr_l24m_m2
        or o.a_ln_mog_am_delqr_l3m_m3 <> n.a_ln_mog_am_delqr_l3m_m3
        or o.a_ln_mog_am_delqr_l6m_m3 <> n.a_ln_mog_am_delqr_l6m_m3
        or o.a_ln_mog_am_delqr_l12m_m3 <> n.a_ln_mog_am_delqr_l12m_m3
        or o.a_ln_mog_am_delqr_l24m_m3 <> n.a_ln_mog_am_delqr_l24m_m3
        or o.a_ln_mog_am_delqf_l3m_m1 <> n.a_ln_mog_am_delqf_l3m_m1
        or o.a_ln_mog_am_delqf_l3m_m2 <> n.a_ln_mog_am_delqf_l3m_m2
        or o.a_ln_mog_am_delqf_l3m_m3 <> n.a_ln_mog_am_delqf_l3m_m3
        or o.a_ln_mog_am_delqf_l3m_m4_plus <> n.a_ln_mog_am_delqf_l3m_m4_plus
        or o.a_ln_mog_am_delqf_l6m_m1 <> n.a_ln_mog_am_delqf_l6m_m1
        or o.a_ln_mog_am_delqf_l6m_m2 <> n.a_ln_mog_am_delqf_l6m_m2
        or o.a_ln_mog_am_delqf_l6m_m3 <> n.a_ln_mog_am_delqf_l6m_m3
        or o.a_ln_mog_am_delqf_l6m_m4_plus <> n.a_ln_mog_am_delqf_l6m_m4_plus
        or o.a_ln_mog_am_delqf_l12m_m1 <> n.a_ln_mog_am_delqf_l12m_m1
        or o.a_ln_mog_am_delqf_l12m_m2 <> n.a_ln_mog_am_delqf_l12m_m2
        or o.a_ln_mog_am_delqf_l12m_m3 <> n.a_ln_mog_am_delqf_l12m_m3
        or o.a_ln_mog_am_delqf_l12m_m4_plus <> n.a_ln_mog_am_delqf_l12m_m4_plus
        or o.a_ln_mog_am_delqf_l24m_m1 <> n.a_ln_mog_am_delqf_l24m_m1
        or o.a_ln_mog_am_delqf_l24m_m2 <> n.a_ln_mog_am_delqf_l24m_m2
        or o.a_ln_mog_am_delqf_l24m_m3 <> n.a_ln_mog_am_delqf_l24m_m3
        or o.a_ln_mog_am_delqf_l24m_m4_plus <> n.a_ln_mog_am_delqf_l24m_m4_plus
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.rcds_ir_tzbl_a_zfdkyqxx_cl(
            grade_key_id -- 申请评分流水号
            ,data_time -- 数据记录时间
            ,serialno -- 申请流水号
            ,create_time -- 创建时间
            ,a_ln_mog_am_delqfmth_l12m_m1 -- 住房贷款过去12个月M1+逾期的月数
            ,a_ln_mog_am_delqfmth_l12m_m2 -- 住房贷款过去12个月M2+逾期的月数
            ,a_ln_mog_am_delqfmth_l12m_m3 -- 住房贷款过去12个月M3+逾期的月数
            ,a_ln_mog_am_delqfmth_l12m_m4 -- 住房贷款过去12个月M4+逾期的月数
            ,a_ln_mog_am_delqfmth_l24m_m1 -- 住房贷款过去24个月M1+逾期的月数
            ,a_ln_mog_am_delqfmth_l24m_m2 -- 住房贷款过去24个月M2+逾期的月数
            ,a_ln_mog_am_delqfmth_l24m_m3 -- 住房贷款过去24个月M3+逾期的月数
            ,a_ln_mog_am_delqfmth_l24m_m4 -- 住房贷款过去24个月M4+逾期的月数
            ,a_ln_mog_am_delqfmth_l3m_m1 -- 住房贷款过去3个月M1+逾期的月数
            ,a_ln_mog_am_delqfmth_l3m_m2 -- 住房贷款过去3个月M2+逾期的月数
            ,a_ln_mog_am_delqfmth_l3m_m3 -- 住房贷款过去3个月M3+逾期的月数
            ,a_ln_mog_am_delqfmth_l3m_m4 -- 住房贷款过去3个月M4+逾期的月数
            ,a_ln_mog_am_delqfmth_l6m_m1 -- 住房贷款过去6个月M1+逾期的月数
            ,a_ln_mog_am_delqfmth_l6m_m2 -- 住房贷款过去6个月M2+逾期的月数
            ,a_ln_mog_am_delqfmth_l6m_m3 -- 住房贷款过去6个月M3+逾期的月数
            ,a_ln_mog_am_delqfmth_l6m_m4 -- 住房贷款过去6个月M4+逾期的月数
            ,a_ln_mog_am_delqm_l3m_max -- 住房贷款过去3个月的最大逾期期数
            ,a_ln_mog_am_delqm_l6m_max -- 住房贷款过去6个月的最大逾期期数
            ,a_ln_mog_am_delqm_l12m_max -- 住房贷款过去12个月的最大逾期期数
            ,a_ln_mog_am_delqm_l24m_max -- 住房贷款过去24个月的最大逾期期数
            ,a_ln_mog_am_delqr_l3m_m1 -- 住房贷款过去3个月最近一次逾期距今的月份数
            ,a_ln_mog_am_delqr_l6m_m1 -- 住房贷款过去6个月最近一次逾期距今的月份数
            ,a_ln_mog_am_delqr_l12m_m1 -- 住房贷款过去12个月最近一次逾期距今的月份数
            ,a_ln_mog_am_delqr_l24m_m1 -- 住房贷款过去24个月最近一次逾期距今的月份数
            ,a_ln_mog_am_delqr_l3m_m2 -- 住房贷款过去3个月最近一次M2逾期距今的月份数
            ,a_ln_mog_am_delqr_l6m_m2 -- 住房贷款过去6个月最近一次M2逾期距今的月份数
            ,a_ln_mog_am_delqr_l12m_m2 -- 住房贷款过去12个月最近一次M2逾期距今的月份数
            ,a_ln_mog_am_delqr_l24m_m2 -- 住房贷款过去24个月最近一次M2逾期距今的月份数
            ,a_ln_mog_am_delqr_l3m_m3 -- 住房贷款过去3个月最近一次M3逾期距今的月份数
            ,a_ln_mog_am_delqr_l6m_m3 -- 住房贷款过去6个月最近一次M3逾期距今的月份数
            ,a_ln_mog_am_delqr_l12m_m3 -- 住房贷款过去12个月最近一次M3逾期距今的月份数
            ,a_ln_mog_am_delqr_l24m_m3 -- 住房贷款过去24个月最近一次M3逾期距今的月份数
            ,a_ln_mog_am_delqf_l3m_m1 -- 住房贷款过去3个月逾期1期的次数
            ,a_ln_mog_am_delqf_l3m_m2 -- 住房贷款过去3个月逾期2期的次数
            ,a_ln_mog_am_delqf_l3m_m3 -- 住房贷款过去3个月逾期3期的次数
            ,a_ln_mog_am_delqf_l3m_m4_plus -- 住房贷款过去3个月逾期4期或以上的次数
            ,a_ln_mog_am_delqf_l6m_m1 -- 住房贷款过去6个月逾期1期的次数
            ,a_ln_mog_am_delqf_l6m_m2 -- 住房贷款过去6个月逾期2期的次数
            ,a_ln_mog_am_delqf_l6m_m3 -- 住房贷款过去6个月逾期3期的次数
            ,a_ln_mog_am_delqf_l6m_m4_plus -- 住房贷款过去6个月逾期4期或以上的次数
            ,a_ln_mog_am_delqf_l12m_m1 -- 住房贷款过去12个月逾期1期的次数
            ,a_ln_mog_am_delqf_l12m_m2 -- 住房贷款过去12个月逾期2期的次数
            ,a_ln_mog_am_delqf_l12m_m3 -- 住房贷款过去12个月逾期3期的次数
            ,a_ln_mog_am_delqf_l12m_m4_plus -- 住房贷款过去12个月逾期4期或以上的次数
            ,a_ln_mog_am_delqf_l24m_m1 -- 住房贷款过去24个月逾期1期的次数
            ,a_ln_mog_am_delqf_l24m_m2 -- 住房贷款过去24个月逾期2期的次数
            ,a_ln_mog_am_delqf_l24m_m3 -- 住房贷款过去24个月逾期3期的次数
            ,a_ln_mog_am_delqf_l24m_m4_plus -- 住房贷款过去24个月逾期4期或以上的次数
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.rcds_ir_tzbl_a_zfdkyqxx_op(
            grade_key_id -- 申请评分流水号
            ,data_time -- 数据记录时间
            ,serialno -- 申请流水号
            ,create_time -- 创建时间
            ,a_ln_mog_am_delqfmth_l12m_m1 -- 住房贷款过去12个月M1+逾期的月数
            ,a_ln_mog_am_delqfmth_l12m_m2 -- 住房贷款过去12个月M2+逾期的月数
            ,a_ln_mog_am_delqfmth_l12m_m3 -- 住房贷款过去12个月M3+逾期的月数
            ,a_ln_mog_am_delqfmth_l12m_m4 -- 住房贷款过去12个月M4+逾期的月数
            ,a_ln_mog_am_delqfmth_l24m_m1 -- 住房贷款过去24个月M1+逾期的月数
            ,a_ln_mog_am_delqfmth_l24m_m2 -- 住房贷款过去24个月M2+逾期的月数
            ,a_ln_mog_am_delqfmth_l24m_m3 -- 住房贷款过去24个月M3+逾期的月数
            ,a_ln_mog_am_delqfmth_l24m_m4 -- 住房贷款过去24个月M4+逾期的月数
            ,a_ln_mog_am_delqfmth_l3m_m1 -- 住房贷款过去3个月M1+逾期的月数
            ,a_ln_mog_am_delqfmth_l3m_m2 -- 住房贷款过去3个月M2+逾期的月数
            ,a_ln_mog_am_delqfmth_l3m_m3 -- 住房贷款过去3个月M3+逾期的月数
            ,a_ln_mog_am_delqfmth_l3m_m4 -- 住房贷款过去3个月M4+逾期的月数
            ,a_ln_mog_am_delqfmth_l6m_m1 -- 住房贷款过去6个月M1+逾期的月数
            ,a_ln_mog_am_delqfmth_l6m_m2 -- 住房贷款过去6个月M2+逾期的月数
            ,a_ln_mog_am_delqfmth_l6m_m3 -- 住房贷款过去6个月M3+逾期的月数
            ,a_ln_mog_am_delqfmth_l6m_m4 -- 住房贷款过去6个月M4+逾期的月数
            ,a_ln_mog_am_delqm_l3m_max -- 住房贷款过去3个月的最大逾期期数
            ,a_ln_mog_am_delqm_l6m_max -- 住房贷款过去6个月的最大逾期期数
            ,a_ln_mog_am_delqm_l12m_max -- 住房贷款过去12个月的最大逾期期数
            ,a_ln_mog_am_delqm_l24m_max -- 住房贷款过去24个月的最大逾期期数
            ,a_ln_mog_am_delqr_l3m_m1 -- 住房贷款过去3个月最近一次逾期距今的月份数
            ,a_ln_mog_am_delqr_l6m_m1 -- 住房贷款过去6个月最近一次逾期距今的月份数
            ,a_ln_mog_am_delqr_l12m_m1 -- 住房贷款过去12个月最近一次逾期距今的月份数
            ,a_ln_mog_am_delqr_l24m_m1 -- 住房贷款过去24个月最近一次逾期距今的月份数
            ,a_ln_mog_am_delqr_l3m_m2 -- 住房贷款过去3个月最近一次M2逾期距今的月份数
            ,a_ln_mog_am_delqr_l6m_m2 -- 住房贷款过去6个月最近一次M2逾期距今的月份数
            ,a_ln_mog_am_delqr_l12m_m2 -- 住房贷款过去12个月最近一次M2逾期距今的月份数
            ,a_ln_mog_am_delqr_l24m_m2 -- 住房贷款过去24个月最近一次M2逾期距今的月份数
            ,a_ln_mog_am_delqr_l3m_m3 -- 住房贷款过去3个月最近一次M3逾期距今的月份数
            ,a_ln_mog_am_delqr_l6m_m3 -- 住房贷款过去6个月最近一次M3逾期距今的月份数
            ,a_ln_mog_am_delqr_l12m_m3 -- 住房贷款过去12个月最近一次M3逾期距今的月份数
            ,a_ln_mog_am_delqr_l24m_m3 -- 住房贷款过去24个月最近一次M3逾期距今的月份数
            ,a_ln_mog_am_delqf_l3m_m1 -- 住房贷款过去3个月逾期1期的次数
            ,a_ln_mog_am_delqf_l3m_m2 -- 住房贷款过去3个月逾期2期的次数
            ,a_ln_mog_am_delqf_l3m_m3 -- 住房贷款过去3个月逾期3期的次数
            ,a_ln_mog_am_delqf_l3m_m4_plus -- 住房贷款过去3个月逾期4期或以上的次数
            ,a_ln_mog_am_delqf_l6m_m1 -- 住房贷款过去6个月逾期1期的次数
            ,a_ln_mog_am_delqf_l6m_m2 -- 住房贷款过去6个月逾期2期的次数
            ,a_ln_mog_am_delqf_l6m_m3 -- 住房贷款过去6个月逾期3期的次数
            ,a_ln_mog_am_delqf_l6m_m4_plus -- 住房贷款过去6个月逾期4期或以上的次数
            ,a_ln_mog_am_delqf_l12m_m1 -- 住房贷款过去12个月逾期1期的次数
            ,a_ln_mog_am_delqf_l12m_m2 -- 住房贷款过去12个月逾期2期的次数
            ,a_ln_mog_am_delqf_l12m_m3 -- 住房贷款过去12个月逾期3期的次数
            ,a_ln_mog_am_delqf_l12m_m4_plus -- 住房贷款过去12个月逾期4期或以上的次数
            ,a_ln_mog_am_delqf_l24m_m1 -- 住房贷款过去24个月逾期1期的次数
            ,a_ln_mog_am_delqf_l24m_m2 -- 住房贷款过去24个月逾期2期的次数
            ,a_ln_mog_am_delqf_l24m_m3 -- 住房贷款过去24个月逾期3期的次数
            ,a_ln_mog_am_delqf_l24m_m4_plus -- 住房贷款过去24个月逾期4期或以上的次数
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.grade_key_id -- 申请评分流水号
    ,o.data_time -- 数据记录时间
    ,o.serialno -- 申请流水号
    ,o.create_time -- 创建时间
    ,o.a_ln_mog_am_delqfmth_l12m_m1 -- 住房贷款过去12个月M1+逾期的月数
    ,o.a_ln_mog_am_delqfmth_l12m_m2 -- 住房贷款过去12个月M2+逾期的月数
    ,o.a_ln_mog_am_delqfmth_l12m_m3 -- 住房贷款过去12个月M3+逾期的月数
    ,o.a_ln_mog_am_delqfmth_l12m_m4 -- 住房贷款过去12个月M4+逾期的月数
    ,o.a_ln_mog_am_delqfmth_l24m_m1 -- 住房贷款过去24个月M1+逾期的月数
    ,o.a_ln_mog_am_delqfmth_l24m_m2 -- 住房贷款过去24个月M2+逾期的月数
    ,o.a_ln_mog_am_delqfmth_l24m_m3 -- 住房贷款过去24个月M3+逾期的月数
    ,o.a_ln_mog_am_delqfmth_l24m_m4 -- 住房贷款过去24个月M4+逾期的月数
    ,o.a_ln_mog_am_delqfmth_l3m_m1 -- 住房贷款过去3个月M1+逾期的月数
    ,o.a_ln_mog_am_delqfmth_l3m_m2 -- 住房贷款过去3个月M2+逾期的月数
    ,o.a_ln_mog_am_delqfmth_l3m_m3 -- 住房贷款过去3个月M3+逾期的月数
    ,o.a_ln_mog_am_delqfmth_l3m_m4 -- 住房贷款过去3个月M4+逾期的月数
    ,o.a_ln_mog_am_delqfmth_l6m_m1 -- 住房贷款过去6个月M1+逾期的月数
    ,o.a_ln_mog_am_delqfmth_l6m_m2 -- 住房贷款过去6个月M2+逾期的月数
    ,o.a_ln_mog_am_delqfmth_l6m_m3 -- 住房贷款过去6个月M3+逾期的月数
    ,o.a_ln_mog_am_delqfmth_l6m_m4 -- 住房贷款过去6个月M4+逾期的月数
    ,o.a_ln_mog_am_delqm_l3m_max -- 住房贷款过去3个月的最大逾期期数
    ,o.a_ln_mog_am_delqm_l6m_max -- 住房贷款过去6个月的最大逾期期数
    ,o.a_ln_mog_am_delqm_l12m_max -- 住房贷款过去12个月的最大逾期期数
    ,o.a_ln_mog_am_delqm_l24m_max -- 住房贷款过去24个月的最大逾期期数
    ,o.a_ln_mog_am_delqr_l3m_m1 -- 住房贷款过去3个月最近一次逾期距今的月份数
    ,o.a_ln_mog_am_delqr_l6m_m1 -- 住房贷款过去6个月最近一次逾期距今的月份数
    ,o.a_ln_mog_am_delqr_l12m_m1 -- 住房贷款过去12个月最近一次逾期距今的月份数
    ,o.a_ln_mog_am_delqr_l24m_m1 -- 住房贷款过去24个月最近一次逾期距今的月份数
    ,o.a_ln_mog_am_delqr_l3m_m2 -- 住房贷款过去3个月最近一次M2逾期距今的月份数
    ,o.a_ln_mog_am_delqr_l6m_m2 -- 住房贷款过去6个月最近一次M2逾期距今的月份数
    ,o.a_ln_mog_am_delqr_l12m_m2 -- 住房贷款过去12个月最近一次M2逾期距今的月份数
    ,o.a_ln_mog_am_delqr_l24m_m2 -- 住房贷款过去24个月最近一次M2逾期距今的月份数
    ,o.a_ln_mog_am_delqr_l3m_m3 -- 住房贷款过去3个月最近一次M3逾期距今的月份数
    ,o.a_ln_mog_am_delqr_l6m_m3 -- 住房贷款过去6个月最近一次M3逾期距今的月份数
    ,o.a_ln_mog_am_delqr_l12m_m3 -- 住房贷款过去12个月最近一次M3逾期距今的月份数
    ,o.a_ln_mog_am_delqr_l24m_m3 -- 住房贷款过去24个月最近一次M3逾期距今的月份数
    ,o.a_ln_mog_am_delqf_l3m_m1 -- 住房贷款过去3个月逾期1期的次数
    ,o.a_ln_mog_am_delqf_l3m_m2 -- 住房贷款过去3个月逾期2期的次数
    ,o.a_ln_mog_am_delqf_l3m_m3 -- 住房贷款过去3个月逾期3期的次数
    ,o.a_ln_mog_am_delqf_l3m_m4_plus -- 住房贷款过去3个月逾期4期或以上的次数
    ,o.a_ln_mog_am_delqf_l6m_m1 -- 住房贷款过去6个月逾期1期的次数
    ,o.a_ln_mog_am_delqf_l6m_m2 -- 住房贷款过去6个月逾期2期的次数
    ,o.a_ln_mog_am_delqf_l6m_m3 -- 住房贷款过去6个月逾期3期的次数
    ,o.a_ln_mog_am_delqf_l6m_m4_plus -- 住房贷款过去6个月逾期4期或以上的次数
    ,o.a_ln_mog_am_delqf_l12m_m1 -- 住房贷款过去12个月逾期1期的次数
    ,o.a_ln_mog_am_delqf_l12m_m2 -- 住房贷款过去12个月逾期2期的次数
    ,o.a_ln_mog_am_delqf_l12m_m3 -- 住房贷款过去12个月逾期3期的次数
    ,o.a_ln_mog_am_delqf_l12m_m4_plus -- 住房贷款过去12个月逾期4期或以上的次数
    ,o.a_ln_mog_am_delqf_l24m_m1 -- 住房贷款过去24个月逾期1期的次数
    ,o.a_ln_mog_am_delqf_l24m_m2 -- 住房贷款过去24个月逾期2期的次数
    ,o.a_ln_mog_am_delqf_l24m_m3 -- 住房贷款过去24个月逾期3期的次数
    ,o.a_ln_mog_am_delqf_l24m_m4_plus -- 住房贷款过去24个月逾期4期或以上的次数
    ,o.start_dt -- 开始时间
    ,case when n.start_dt is not null then to_date('${batch_date}', 'yyyymmdd')
          when o.end_dt >= to_date('${batch_date}','yyyymmdd') then to_date('20991231','yyyymmdd')
          else o.end_dt
     end as end_dt -- 结束时间
    ,o.id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from ${iol_schema}.rcds_ir_tzbl_a_zfdkyqxx_bk o
    left join ${iol_schema}.rcds_ir_tzbl_a_zfdkyqxx_op n
        on
            o.grade_key_id = n.grade_key_id
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.rcds_ir_tzbl_a_zfdkyqxx_cl d
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
-- truncate table ${iol_schema}.rcds_ir_tzbl_a_zfdkyqxx;

-- 4.2 exchange partition
alter table ${iol_schema}.rcds_ir_tzbl_a_zfdkyqxx exchange partition p_19000101 with table ${iol_schema}.rcds_ir_tzbl_a_zfdkyqxx_cl;
alter table ${iol_schema}.rcds_ir_tzbl_a_zfdkyqxx exchange partition p_20991231 with table ${iol_schema}.rcds_ir_tzbl_a_zfdkyqxx_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.rcds_ir_tzbl_a_zfdkyqxx to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.rcds_ir_tzbl_a_zfdkyqxx_op purge;
drop table ${iol_schema}.rcds_ir_tzbl_a_zfdkyqxx_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.rcds_ir_tzbl_a_zfdkyqxx_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'rcds_ir_tzbl_a_zfdkyqxx',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
