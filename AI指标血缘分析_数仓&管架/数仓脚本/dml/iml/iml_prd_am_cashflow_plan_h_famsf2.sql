/*
Purpose:    整合模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iml_prd_am_cashflow_plan_h_famsf2
CreateDate: 20180515
Logs:
    zjj 2018-05-15 新建表本
*/

set timing on

-- 1 alter parallel
alter session force parallel query parallel 4;
alter session force parallel dml parallel 4;
-- alter session force parallel ddl parallel 1;

-- 2.1 create backup table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
alter table ${iml_schema}.prd_am_cashflow_plan_h add partition p_famsf2 values ('famsf2')(
        subpartition p_famsf2_19000101 values less than (to_date('20991231','yyyymmdd'))
        ,subpartition p_famsf2_20991231 values less than (maxvalue)
    )
;

-- if backup table is exists, mean script if failed on last time
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
create table ${iml_schema}.prd_am_cashflow_plan_h_famsf2_bk nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.prd_am_cashflow_plan_h partition for ('famsf2')
;

-- 2.2 drop temp table
whenever sqlerror continue none ;
-- it is no need to check when this segment SQL was return faied
drop table ${iml_schema}.prd_am_cashflow_plan_h_famsf2_tm purge;
drop table ${iml_schema}.prd_am_cashflow_plan_h_famsf2_op purge;
drop table ${iml_schema}.prd_am_cashflow_plan_h_famsf2_cl purge;

-- 2.3 create temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.prd_am_cashflow_plan_h_famsf2_tm nologging
compress ${option_switch} for query high
as select
    cashflow_id -- 现金流编号
    ,lp_id -- 法人编号
    ,cashflow_seq_num -- 现金流序号
    ,cashflow_cate_cd -- 现金流类别代码
    ,nadj_calc_start_dt -- 未调整计算开始日期
    ,nadj_calc_end_dt -- 未调整计算结束日期
    ,nadj_plan_pay_dt -- 未调整计划支付日期
    ,a_adjust_calc_start_dt -- 调整后计算开始日期
    ,a_adjust_calc_end_dt -- 调整后计算结束日期
    ,a_adjust_plan_pay_dt -- 调整后计划支付日期
    ,calc_ped_days -- 计算周期天数
    ,integy_ped_start_dt -- 完整周期开始日期
    ,integy_ped_end_dt -- 完整周期结束日期
    ,integy_ped_days -- 完整周期天数
    ,plan_pay_pric -- 计划支付本金
    ,int_accr_pric -- 计息本金
    ,plan_pay_int -- 计划支付利息
    ,pay_int_flg -- 支付利息标志
    ,plan_pay_amt -- 计划支付金额
    ,cashflow_base -- 现金流基数
    ,base_corp_type_cd -- 基数单位类型代码
    ,year_pay_int_cnt -- 年付息次数
    ,fin_prod_id -- 金融产品编号
    ,prod_cate_cd -- 产品类别代码
    ,brch_seq_num -- 分支序号
    ,pay_type_cd -- 支付类型代码
    ,intrv_net_yld_rat -- 区间净收益率
    ,to_date('${batch_date}', 'yyyymmdd') as etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
from ${iml_schema}.prd_am_cashflow_plan_h partition for ('famsf2')
where 0=1
;

create table ${iml_schema}.prd_am_cashflow_plan_h_famsf2_op nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.prd_am_cashflow_plan_h partition for ('famsf2') where 0=1;

create table ${iml_schema}.prd_am_cashflow_plan_h_famsf2_cl nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.prd_am_cashflow_plan_h partition for ('famsf2') where 0=1;

-- 3.1 get new data into table
-- fams_fin_cash_plan-1
insert into ${iml_schema}.prd_am_cashflow_plan_h_famsf2_tm(
    cashflow_id -- 现金流编号
    ,lp_id -- 法人编号
    ,cashflow_seq_num -- 现金流序号
    ,cashflow_cate_cd -- 现金流类别代码
    ,nadj_calc_start_dt -- 未调整计算开始日期
    ,nadj_calc_end_dt -- 未调整计算结束日期
    ,nadj_plan_pay_dt -- 未调整计划支付日期
    ,a_adjust_calc_start_dt -- 调整后计算开始日期
    ,a_adjust_calc_end_dt -- 调整后计算结束日期
    ,a_adjust_plan_pay_dt -- 调整后计划支付日期
    ,calc_ped_days -- 计算周期天数
    ,integy_ped_start_dt -- 完整周期开始日期
    ,integy_ped_end_dt -- 完整周期结束日期
    ,integy_ped_days -- 完整周期天数
    ,plan_pay_pric -- 计划支付本金
    ,int_accr_pric -- 计息本金
    ,plan_pay_int -- 计划支付利息
    ,pay_int_flg -- 支付利息标志
    ,plan_pay_amt -- 计划支付金额
    ,cashflow_base -- 现金流基数
    ,base_corp_type_cd -- 基数单位类型代码
    ,year_pay_int_cnt -- 年付息次数
    ,fin_prod_id -- 金融产品编号
    ,prod_cate_cd -- 产品类别代码
    ,brch_seq_num -- 分支序号
    ,pay_type_cd -- 支付类型代码
    ,intrv_net_yld_rat -- 区间净收益率
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
)
select
    P1.CASH_ID -- 现金流编号
    ,'9999' -- 法人编号
    ,P1.CASH_NUM -- 现金流序号
    ,CASE WHEN R1.TARGET_CD_VAL IS NOT NULL THEN R1.TARGET_CD_VAL ELSE '@'||P1.CASH_TYPE END -- 现金流类别代码
    ,P1.VDATE_UNADJUST -- 未调整计算开始日期
    ,P1.MDATE_UNADJUST -- 未调整计算结束日期
    ,P1.PAY_DATE_UNADJUST -- 未调整计划支付日期
    ,P1.VDATE -- 调整后计算开始日期
    ,P1.MDATE -- 调整后计算结束日期
    ,P1.PAY_DATE -- 调整后计划支付日期
    ,P1.TERMDAYS -- 计算周期天数
    ,P1.VDATE_TERM -- 完整周期开始日期
    ,P1.MDATE_TERM -- 完整周期结束日期
    ,P1.TERMDAYS_TERM -- 完整周期天数
    ,P1.PRIN_AMT -- 计划支付本金
    ,P1.INT_PRIN_AMT -- 计息本金
    ,P1.INT_AMT -- 计划支付利息
    ,P1.IS_PAY_INT -- 支付利息标志
    ,P1.CASH_AMT -- 计划支付金额
    ,P1.CASH_BASEAMT -- 现金流基数
    ,CASE WHEN R2.TARGET_CD_VAL IS NOT NULL THEN R2.TARGET_CD_VAL ELSE '@'||P1.CASH_UNIT_TYPE END -- 基数单位类型代码
    ,P1.FREQUENCY -- 年付息次数
    ,P1.FINPROD_ID -- 金融产品编号
    ,CASE WHEN P1.FINPROD_TYPE2=' ' THEN '-' ELSE P1.FINPROD_TYPE2 END  -- 产品类别代码
    ,P1.BRANCH -- 分支序号
    ,CASE WHEN R3.TARGET_CD_VAL IS NOT NULL THEN R3.TARGET_CD_VAL ELSE '@'||P1.PAY_TYPE END -- 支付类型代码
    ,P1.RANGE_YIELD -- 区间净收益率
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,'fams_fin_cash_plan' -- 源表名称
    ,'famsf2' -- 任务编码
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间戳
from ${iol_schema}.fams_fin_cash_plan p1
    left join ${iml_schema}.ref_pub_cd_map r1 on P1.CASH_TYPE = R1.SRC_CODE_VAL
        AND R1.SORC_SYS_CD= 'FAMS'
        AND R1.SRC_TAB_EN_NAME= 'FAMS_FIN_CASH_PLAN'
        AND R1.SRC_FIELD_EN_NAME= 'CASH_TYPE'
        AND R1.TARGET_TAB_EN_NAME= 'PRD_AM_CASHFLOW_PLAN_H'
        AND R1.TARGET_TAB_FIELD_EN_NAME= 'CASHFLOW_CATE_CD'
    left join ${iml_schema}.ref_pub_cd_map r2 on P1.CASH_UNIT_TYPE = R2.SRC_CODE_VAL
        AND R2.SORC_SYS_CD= 'FAMS'
        AND R2.SRC_TAB_EN_NAME= 'FAMS_FIN_CASH_PLAN'
        AND R2.SRC_FIELD_EN_NAME= 'CASH_UNIT_TYPE'
        AND R2.TARGET_TAB_EN_NAME= 'PRD_AM_CASHFLOW_PLAN_H'
        AND R2.TARGET_TAB_FIELD_EN_NAME= 'BASE_CORP_TYPE_CD'
    left join ${iml_schema}.ref_pub_cd_map r3 on P1.PAY_TYPE = R3.SRC_CODE_VAL
        AND R3.SORC_SYS_CD= 'FAMS'
        AND R3.SRC_TAB_EN_NAME= 'FAMS_FIN_CASH_PLAN'
        AND R3.SRC_FIELD_EN_NAME= 'PAY_TYPE'
        AND R3.TARGET_TAB_EN_NAME= 'PRD_AM_CASHFLOW_PLAN_H'
        AND R3.TARGET_TAB_FIELD_EN_NAME= 'PAY_TYPE_CD'
where p1.start_dt <= to_date('${batch_date}','yyyymmdd') and p1.end_dt > to_date('${batch_date}','yyyymmdd')
;
commit;


commit;

-- 3.2 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iml_schema}.prd_am_cashflow_plan_h_famsf2_cl(
            cashflow_id -- 现金流编号
    ,lp_id -- 法人编号
    ,cashflow_seq_num -- 现金流序号
    ,cashflow_cate_cd -- 现金流类别代码
    ,nadj_calc_start_dt -- 未调整计算开始日期
    ,nadj_calc_end_dt -- 未调整计算结束日期
    ,nadj_plan_pay_dt -- 未调整计划支付日期
    ,a_adjust_calc_start_dt -- 调整后计算开始日期
    ,a_adjust_calc_end_dt -- 调整后计算结束日期
    ,a_adjust_plan_pay_dt -- 调整后计划支付日期
    ,calc_ped_days -- 计算周期天数
    ,integy_ped_start_dt -- 完整周期开始日期
    ,integy_ped_end_dt -- 完整周期结束日期
    ,integy_ped_days -- 完整周期天数
    ,plan_pay_pric -- 计划支付本金
    ,int_accr_pric -- 计息本金
    ,plan_pay_int -- 计划支付利息
    ,pay_int_flg -- 支付利息标志
    ,plan_pay_amt -- 计划支付金额
    ,cashflow_base -- 现金流基数
    ,base_corp_type_cd -- 基数单位类型代码
    ,year_pay_int_cnt -- 年付息次数
    ,fin_prod_id -- 金融产品编号
    ,prod_cate_cd -- 产品类别代码
    ,brch_seq_num -- 分支序号
    ,pay_type_cd -- 支付类型代码
    ,intrv_net_yld_rat -- 区间净收益率
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iml_schema}.prd_am_cashflow_plan_h_famsf2_op(
            cashflow_id -- 现金流编号
    ,lp_id -- 法人编号
    ,cashflow_seq_num -- 现金流序号
    ,cashflow_cate_cd -- 现金流类别代码
    ,nadj_calc_start_dt -- 未调整计算开始日期
    ,nadj_calc_end_dt -- 未调整计算结束日期
    ,nadj_plan_pay_dt -- 未调整计划支付日期
    ,a_adjust_calc_start_dt -- 调整后计算开始日期
    ,a_adjust_calc_end_dt -- 调整后计算结束日期
    ,a_adjust_plan_pay_dt -- 调整后计划支付日期
    ,calc_ped_days -- 计算周期天数
    ,integy_ped_start_dt -- 完整周期开始日期
    ,integy_ped_end_dt -- 完整周期结束日期
    ,integy_ped_days -- 完整周期天数
    ,plan_pay_pric -- 计划支付本金
    ,int_accr_pric -- 计息本金
    ,plan_pay_int -- 计划支付利息
    ,pay_int_flg -- 支付利息标志
    ,plan_pay_amt -- 计划支付金额
    ,cashflow_base -- 现金流基数
    ,base_corp_type_cd -- 基数单位类型代码
    ,year_pay_int_cnt -- 年付息次数
    ,fin_prod_id -- 金融产品编号
    ,prod_cate_cd -- 产品类别代码
    ,brch_seq_num -- 分支序号
    ,pay_type_cd -- 支付类型代码
    ,intrv_net_yld_rat -- 区间净收益率
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.cashflow_id, o.cashflow_id) as cashflow_id -- 现金流编号
    ,nvl(n.lp_id, o.lp_id) as lp_id -- 法人编号
    ,nvl(n.cashflow_seq_num, o.cashflow_seq_num) as cashflow_seq_num -- 现金流序号
    ,nvl(n.cashflow_cate_cd, o.cashflow_cate_cd) as cashflow_cate_cd -- 现金流类别代码
    ,nvl(n.nadj_calc_start_dt, o.nadj_calc_start_dt) as nadj_calc_start_dt -- 未调整计算开始日期
    ,nvl(n.nadj_calc_end_dt, o.nadj_calc_end_dt) as nadj_calc_end_dt -- 未调整计算结束日期
    ,nvl(n.nadj_plan_pay_dt, o.nadj_plan_pay_dt) as nadj_plan_pay_dt -- 未调整计划支付日期
    ,nvl(n.a_adjust_calc_start_dt, o.a_adjust_calc_start_dt) as a_adjust_calc_start_dt -- 调整后计算开始日期
    ,nvl(n.a_adjust_calc_end_dt, o.a_adjust_calc_end_dt) as a_adjust_calc_end_dt -- 调整后计算结束日期
    ,nvl(n.a_adjust_plan_pay_dt, o.a_adjust_plan_pay_dt) as a_adjust_plan_pay_dt -- 调整后计划支付日期
    ,nvl(n.calc_ped_days, o.calc_ped_days) as calc_ped_days -- 计算周期天数
    ,nvl(n.integy_ped_start_dt, o.integy_ped_start_dt) as integy_ped_start_dt -- 完整周期开始日期
    ,nvl(n.integy_ped_end_dt, o.integy_ped_end_dt) as integy_ped_end_dt -- 完整周期结束日期
    ,nvl(n.integy_ped_days, o.integy_ped_days) as integy_ped_days -- 完整周期天数
    ,nvl(n.plan_pay_pric, o.plan_pay_pric) as plan_pay_pric -- 计划支付本金
    ,nvl(n.int_accr_pric, o.int_accr_pric) as int_accr_pric -- 计息本金
    ,nvl(n.plan_pay_int, o.plan_pay_int) as plan_pay_int -- 计划支付利息
    ,nvl(n.pay_int_flg, o.pay_int_flg) as pay_int_flg -- 支付利息标志
    ,nvl(n.plan_pay_amt, o.plan_pay_amt) as plan_pay_amt -- 计划支付金额
    ,nvl(n.cashflow_base, o.cashflow_base) as cashflow_base -- 现金流基数
    ,nvl(n.base_corp_type_cd, o.base_corp_type_cd) as base_corp_type_cd -- 基数单位类型代码
    ,nvl(n.year_pay_int_cnt, o.year_pay_int_cnt) as year_pay_int_cnt -- 年付息次数
    ,nvl(n.fin_prod_id, o.fin_prod_id) as fin_prod_id -- 金融产品编号
    ,nvl(n.prod_cate_cd, o.prod_cate_cd) as prod_cate_cd -- 产品类别代码
    ,nvl(n.brch_seq_num, o.brch_seq_num) as brch_seq_num -- 分支序号
    ,nvl(n.pay_type_cd, o.pay_type_cd) as pay_type_cd -- 支付类型代码
    ,nvl(n.intrv_net_yld_rat, o.intrv_net_yld_rat) as intrv_net_yld_rat -- 区间净收益率
    ,case when
            n.cashflow_id is null
            and n.lp_id is null
            and n.a_adjust_calc_end_dt is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.cashflow_id is null
            and n.lp_id is null
            and n.a_adjust_calc_end_dt is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.cashflow_id is null
            and n.lp_id is null
            and n.a_adjust_calc_end_dt is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,nvl(n.src_table_name, o.src_table_name) as src_table_name -- 源表名称
    ,nvl(n.job_cd, o.job_cd) as job_cd -- 任务编码
    ,nvl(n.etl_timestamp, o.etl_timestamp) as etl_timestamp -- ETL处理时间戳
from ${iml_schema}.prd_am_cashflow_plan_h_famsf2_tm n
    full join (select * from ${iml_schema}.prd_am_cashflow_plan_h_famsf2_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
        on
            o.cashflow_id = n.cashflow_id
            and o.lp_id = n.lp_id
            and o.a_adjust_calc_end_dt = n.a_adjust_calc_end_dt
where (
        o.cashflow_id is null
        and o.lp_id is null
        and o.a_adjust_calc_end_dt is null
    )
    or (
        n.cashflow_id is null
        and n.lp_id is null
        and n.a_adjust_calc_end_dt is null
    )
    or (
        o.cashflow_seq_num <> n.cashflow_seq_num
        or o.cashflow_cate_cd <> n.cashflow_cate_cd
        or o.nadj_calc_start_dt <> n.nadj_calc_start_dt
        or o.nadj_calc_end_dt <> n.nadj_calc_end_dt
        or o.nadj_plan_pay_dt <> n.nadj_plan_pay_dt
        or o.a_adjust_calc_start_dt <> n.a_adjust_calc_start_dt
        or o.a_adjust_plan_pay_dt <> n.a_adjust_plan_pay_dt
        or o.calc_ped_days <> n.calc_ped_days
        or o.integy_ped_start_dt <> n.integy_ped_start_dt
        or o.integy_ped_end_dt <> n.integy_ped_end_dt
        or o.integy_ped_days <> n.integy_ped_days
        or o.plan_pay_pric <> n.plan_pay_pric
        or o.int_accr_pric <> n.int_accr_pric
        or o.plan_pay_int <> n.plan_pay_int
        or o.pay_int_flg <> n.pay_int_flg
        or o.plan_pay_amt <> n.plan_pay_amt
        or o.cashflow_base <> n.cashflow_base
        or o.base_corp_type_cd <> n.base_corp_type_cd
        or o.year_pay_int_cnt <> n.year_pay_int_cnt
        or o.fin_prod_id <> n.fin_prod_id
        or o.prod_cate_cd <> n.prod_cate_cd
        or o.brch_seq_num <> n.brch_seq_num
        or o.pay_type_cd <> n.pay_type_cd
        or o.intrv_net_yld_rat <> n.intrv_net_yld_rat
    )
;
commit;

-- 3.3 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iml_schema}.prd_am_cashflow_plan_h_famsf2_cl(
            cashflow_id -- 现金流编号
    ,lp_id -- 法人编号
    ,cashflow_seq_num -- 现金流序号
    ,cashflow_cate_cd -- 现金流类别代码
    ,nadj_calc_start_dt -- 未调整计算开始日期
    ,nadj_calc_end_dt -- 未调整计算结束日期
    ,nadj_plan_pay_dt -- 未调整计划支付日期
    ,a_adjust_calc_start_dt -- 调整后计算开始日期
    ,a_adjust_calc_end_dt -- 调整后计算结束日期
    ,a_adjust_plan_pay_dt -- 调整后计划支付日期
    ,calc_ped_days -- 计算周期天数
    ,integy_ped_start_dt -- 完整周期开始日期
    ,integy_ped_end_dt -- 完整周期结束日期
    ,integy_ped_days -- 完整周期天数
    ,plan_pay_pric -- 计划支付本金
    ,int_accr_pric -- 计息本金
    ,plan_pay_int -- 计划支付利息
    ,pay_int_flg -- 支付利息标志
    ,plan_pay_amt -- 计划支付金额
    ,cashflow_base -- 现金流基数
    ,base_corp_type_cd -- 基数单位类型代码
    ,year_pay_int_cnt -- 年付息次数
    ,fin_prod_id -- 金融产品编号
    ,prod_cate_cd -- 产品类别代码
    ,brch_seq_num -- 分支序号
    ,pay_type_cd -- 支付类型代码
    ,intrv_net_yld_rat -- 区间净收益率
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iml_schema}.prd_am_cashflow_plan_h_famsf2_op(
            cashflow_id -- 现金流编号
    ,lp_id -- 法人编号
    ,cashflow_seq_num -- 现金流序号
    ,cashflow_cate_cd -- 现金流类别代码
    ,nadj_calc_start_dt -- 未调整计算开始日期
    ,nadj_calc_end_dt -- 未调整计算结束日期
    ,nadj_plan_pay_dt -- 未调整计划支付日期
    ,a_adjust_calc_start_dt -- 调整后计算开始日期
    ,a_adjust_calc_end_dt -- 调整后计算结束日期
    ,a_adjust_plan_pay_dt -- 调整后计划支付日期
    ,calc_ped_days -- 计算周期天数
    ,integy_ped_start_dt -- 完整周期开始日期
    ,integy_ped_end_dt -- 完整周期结束日期
    ,integy_ped_days -- 完整周期天数
    ,plan_pay_pric -- 计划支付本金
    ,int_accr_pric -- 计息本金
    ,plan_pay_int -- 计划支付利息
    ,pay_int_flg -- 支付利息标志
    ,plan_pay_amt -- 计划支付金额
    ,cashflow_base -- 现金流基数
    ,base_corp_type_cd -- 基数单位类型代码
    ,year_pay_int_cnt -- 年付息次数
    ,fin_prod_id -- 金融产品编号
    ,prod_cate_cd -- 产品类别代码
    ,brch_seq_num -- 分支序号
    ,pay_type_cd -- 支付类型代码
    ,intrv_net_yld_rat -- 区间净收益率
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.cashflow_id -- 现金流编号
    ,o.lp_id -- 法人编号
    ,o.cashflow_seq_num -- 现金流序号
    ,o.cashflow_cate_cd -- 现金流类别代码
    ,o.nadj_calc_start_dt -- 未调整计算开始日期
    ,o.nadj_calc_end_dt -- 未调整计算结束日期
    ,o.nadj_plan_pay_dt -- 未调整计划支付日期
    ,o.a_adjust_calc_start_dt -- 调整后计算开始日期
    ,o.a_adjust_calc_end_dt -- 调整后计算结束日期
    ,o.a_adjust_plan_pay_dt -- 调整后计划支付日期
    ,o.calc_ped_days -- 计算周期天数
    ,o.integy_ped_start_dt -- 完整周期开始日期
    ,o.integy_ped_end_dt -- 完整周期结束日期
    ,o.integy_ped_days -- 完整周期天数
    ,o.plan_pay_pric -- 计划支付本金
    ,o.int_accr_pric -- 计息本金
    ,o.plan_pay_int -- 计划支付利息
    ,o.pay_int_flg -- 支付利息标志
    ,o.plan_pay_amt -- 计划支付金额
    ,o.cashflow_base -- 现金流基数
    ,o.base_corp_type_cd -- 基数单位类型代码
    ,o.year_pay_int_cnt -- 年付息次数
    ,o.fin_prod_id -- 金融产品编号
    ,o.prod_cate_cd -- 产品类别代码
    ,o.brch_seq_num -- 分支序号
    ,o.pay_type_cd -- 支付类型代码
    ,o.intrv_net_yld_rat -- 区间净收益率
    ,o.start_dt -- 开始时间
    ,case when n.start_dt is not null then to_date('${batch_date}', 'yyyymmdd')
          when o.end_dt >= to_date('${batch_date}','yyyymmdd') then to_date('20991231','yyyymmdd')
          else o.end_dt
     end as end_dt -- 结束时间
    ,o.id_mark -- 增删标志
    ,o.src_table_name -- 源表名称
    ,o.job_cd -- 任务编码
    ,o.etl_timestamp -- ETL处理时间戳
from ${iml_schema}.prd_am_cashflow_plan_h_famsf2_bk o
    left join ${iml_schema}.prd_am_cashflow_plan_h_famsf2_op n
        on
            o.cashflow_id = n.cashflow_id
            and o.lp_id = n.lp_id
            and o.a_adjust_calc_end_dt = n.a_adjust_calc_end_dt
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iml_schema}.prd_am_cashflow_plan_h_famsf2_cl d
        on
            o.cashflow_id = d.cashflow_id
            and o.lp_id = d.lp_id
            and o.a_adjust_calc_end_dt = d.a_adjust_calc_end_dt
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
--truncate table ${iml_schema}.prd_am_cashflow_plan_h;
alter table ${iml_schema}.prd_am_cashflow_plan_h truncate partition for ('famsf2') reuse storage;

-- 4.2 exchange partition
alter table ${iml_schema}.prd_am_cashflow_plan_h exchange subpartition p_famsf2_19000101 with table ${iml_schema}.prd_am_cashflow_plan_h_famsf2_cl;
alter table ${iml_schema}.prd_am_cashflow_plan_h exchange subpartition p_famsf2_20991231 with table ${iml_schema}.prd_am_cashflow_plan_h_famsf2_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iml_schema}.prd_am_cashflow_plan_h to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iml_schema}.prd_am_cashflow_plan_h_famsf2_tm purge;
drop table ${iml_schema}.prd_am_cashflow_plan_h_famsf2_op purge;
drop table ${iml_schema}.prd_am_cashflow_plan_h_famsf2_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iml_schema}.prd_am_cashflow_plan_h_famsf2_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iml_schema}',tabname => 'prd_am_cashflow_plan_h', partname => 'p_famsf2_20991231', granularity => 'SUBPARTITION', degree => 8, cascade => true);
