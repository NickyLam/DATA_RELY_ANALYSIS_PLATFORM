/*
Purpose:    整合模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iml_prd_ibank_cashflow_dtl_h_ibmsf1
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
alter table ${iml_schema}.prd_ibank_cashflow_dtl_h add partition p_ibmsf1 values ('ibmsf1')(
        subpartition p_ibmsf1_19000101 values (to_date('19000101','yyyymmdd'))
        ,subpartition p_ibmsf1_20991231 values (to_date('20991231','yyyymmdd'))
    )
;

-- if backup table is exists, mean script if failed on last time
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
create table ${iml_schema}.prd_ibank_cashflow_dtl_h_ibmsf1_bk nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.prd_ibank_cashflow_dtl_h partition for ('ibmsf1')
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd')
;

-- 2.2 drop temp table
whenever sqlerror continue none ;
-- it is no need to check when this segment SQL was return faied
drop table ${iml_schema}.prd_ibank_cashflow_dtl_h_ibmsf1_tm purge;
drop table ${iml_schema}.prd_ibank_cashflow_dtl_h_ibmsf1_op purge;
drop table ${iml_schema}.prd_ibank_cashflow_dtl_h_ibmsf1_cl purge;

-- 2.3 create temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.prd_ibank_cashflow_dtl_h_ibmsf1_tm nologging
compress ${option_switch} for query high
as select
    fin_instm_id -- 金融工具编号
    ,asset_type_id -- 资产类型编号
    ,market_type_id -- 市场类型编号
    ,lp_id -- 法人编号
    ,task_group_id -- 任务组编号
    ,cashflow_id -- 现金流编号
    ,int_rat_flow_id -- 利率流编号
    ,pricing_envir_id -- 定价环境编号
    ,cfm_cashflow_flg -- 确定现金流标志
    ,calc_dt -- 计算日期
    ,int_accr_start_dt -- 计息开始日期
    ,int_accr_end_dt -- 计息结束日期
    ,pay_dt -- 支付日期
    ,pay_amt -- 支付金额
    ,disct_rat -- 折现率
    ,pric_amt -- 本金金额
    ,pre_pric_amt -- 预测本金金额
    ,int_amt -- 利息金额
    ,pre_int_amt -- 预测利息金额
    ,pay_bf_pric -- 支付前本金
    ,pay_post_pric -- 支付后本金
    ,option_premium -- 期权费
    ,pre_option_premium -- 预测期权费
    ,curr_cd -- 币种代码
    ,stl_curr_cd -- 结算币种代码
    ,accu_pd -- 累积违约概率
    ,real_fin_instm_id -- 真实金融工具编号
    ,src_update_tm -- 源更新时间
    ,to_date('${batch_date}', 'yyyymmdd') as etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
from ${iml_schema}.prd_ibank_cashflow_dtl_h partition for ('ibmsf1')
where 0=1
;

create table ${iml_schema}.prd_ibank_cashflow_dtl_h_ibmsf1_op nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.prd_ibank_cashflow_dtl_h partition for ('ibmsf1') where 0=1;

create table ${iml_schema}.prd_ibank_cashflow_dtl_h_ibmsf1_cl nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.prd_ibank_cashflow_dtl_h partition for ('ibmsf1') where 0=1;

-- 3.1 get new data into table
-- ibms_tbsi_paymentinfo-1
insert into ${iml_schema}.prd_ibank_cashflow_dtl_h_ibmsf1_tm(
    fin_instm_id -- 金融工具编号
    ,asset_type_id -- 资产类型编号
    ,market_type_id -- 市场类型编号
    ,lp_id -- 法人编号
    ,task_group_id -- 任务组编号
    ,cashflow_id -- 现金流编号
    ,int_rat_flow_id -- 利率流编号
    ,pricing_envir_id -- 定价环境编号
    ,cfm_cashflow_flg -- 确定现金流标志
    ,calc_dt -- 计算日期
    ,int_accr_start_dt -- 计息开始日期
    ,int_accr_end_dt -- 计息结束日期
    ,pay_dt -- 支付日期
    ,pay_amt -- 支付金额
    ,disct_rat -- 折现率
    ,pric_amt -- 本金金额
    ,pre_pric_amt -- 预测本金金额
    ,int_amt -- 利息金额
    ,pre_int_amt -- 预测利息金额
    ,pay_bf_pric -- 支付前本金
    ,pay_post_pric -- 支付后本金
    ,option_premium -- 期权费
    ,pre_option_premium -- 预测期权费
    ,curr_cd -- 币种代码
    ,stl_curr_cd -- 结算币种代码
    ,accu_pd -- 累积违约概率
    ,real_fin_instm_id -- 真实金融工具编号
    ,src_update_tm -- 源更新时间
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
)
select
    P1.I_CODE -- 金融工具编号
    ,P1.A_TYPE -- 资产类型编号
    ,P1.M_TYPE -- 市场类型编号
    ,'9999' -- 法人编号
    ,P1.TG_CODE -- 任务组编号
    ,P1.PI_ID -- 现金流编号
    ,P1.STREAM_ID -- 利率流编号
    ,P1.PE_CODE -- 定价环境编号
    ,to_char(P1.PI_FIXED) -- 确定现金流标志
    ,${iml_schema}.dateformat_min(P1.BEG_DATE) -- 计算日期
    ,${iml_schema}.dateformat_min(P1.PI_CALCSTARTDATE) -- 计息开始日期
    ,${iml_schema}.dateformat_max(P1.PI_CALCENDDATE) -- 计息结束日期
    ,${iml_schema}.dateformat_min(P1.PI_PAYMENTDATE) -- 支付日期
    ,P1.PI_AMOUNT -- 支付金额
    ,P1.PI_DISCOUNT -- 折现率
    ,P1.PI_NOTIONALAMOUNT -- 本金金额
    ,P1.PI_NOTIONALAMOUNT_FORCASTED -- 预测本金金额
    ,P1.PI_INTERESTAMOUNT -- 利息金额
    ,P1.PI_INTERESTAMOUNT_FORCASTED -- 预测利息金额
    ,P1.PI_PRENOTIONALAMOUNT -- 支付前本金
    ,P1.PI_NEXTNOTIONALAMOUNT -- 支付后本金
    ,P1.PI_PREMIUM -- 期权费
    ,P1.PI_PREMIUM_FORCASTED -- 预测期权费
    ,NVL(TRIM(P1.PI_CURRENCY),'CNY') -- 币种代码
    ,NVL(TRIM(P1.PI_SETTLECURRENCY),'CNY') -- 结算币种代码
    ,P1.PI_CUMUDEFAULTRATE -- 累积违约概率
    ,P1.REAL_I_CODE -- 真实金融工具编号
    ,${iml_schema}.dateformat_min(P1.IMP_TIME) -- 源更新时间
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,'ibms_tbsi_paymentinfo' -- 源表名称
    ,'ibmsf1' -- 任务编码
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间戳
from ${iol_schema}.ibms_tbsi_paymentinfo p1
where p1.start_dt <= to_date('${batch_date}','yyyymmdd') and p1.end_dt > to_date('${batch_date}','yyyymmdd')
;
commit;


commit;

whenever sqlerror exit sql.sqlcode;
declare
cnt integer;
begin
  for cur in (select 1 from dual) loop
  	select count(1) into cnt from (select 1 from ${iml_schema}.prd_ibank_cashflow_dtl_h_ibmsf1_tm 
  	                                group by 
  	                                        fin_instm_id
  	                                        ,asset_type_id
  	                                        ,market_type_id
  	                                        ,lp_id
  	                                        ,task_group_id
  	                                        ,cashflow_id
  	                                        ,int_rat_flow_id
  	                                        ,pricing_envir_id
  	                                        ,int_accr_end_dt
  	                               having count(1) > 1);
    if cnt = 0 
      then
        continue;
      else
        raise_application_error(-20001,'primary key is duplication');
    end if;
  end loop;
end;
/


-- 3.2 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iml_schema}.prd_ibank_cashflow_dtl_h_ibmsf1_cl(
            fin_instm_id -- 金融工具编号
    ,asset_type_id -- 资产类型编号
    ,market_type_id -- 市场类型编号
    ,lp_id -- 法人编号
    ,task_group_id -- 任务组编号
    ,cashflow_id -- 现金流编号
    ,int_rat_flow_id -- 利率流编号
    ,pricing_envir_id -- 定价环境编号
    ,cfm_cashflow_flg -- 确定现金流标志
    ,calc_dt -- 计算日期
    ,int_accr_start_dt -- 计息开始日期
    ,int_accr_end_dt -- 计息结束日期
    ,pay_dt -- 支付日期
    ,pay_amt -- 支付金额
    ,disct_rat -- 折现率
    ,pric_amt -- 本金金额
    ,pre_pric_amt -- 预测本金金额
    ,int_amt -- 利息金额
    ,pre_int_amt -- 预测利息金额
    ,pay_bf_pric -- 支付前本金
    ,pay_post_pric -- 支付后本金
    ,option_premium -- 期权费
    ,pre_option_premium -- 预测期权费
    ,curr_cd -- 币种代码
    ,stl_curr_cd -- 结算币种代码
    ,accu_pd -- 累积违约概率
    ,real_fin_instm_id -- 真实金融工具编号
    ,src_update_tm -- 源更新时间
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iml_schema}.prd_ibank_cashflow_dtl_h_ibmsf1_op(
            fin_instm_id -- 金融工具编号
    ,asset_type_id -- 资产类型编号
    ,market_type_id -- 市场类型编号
    ,lp_id -- 法人编号
    ,task_group_id -- 任务组编号
    ,cashflow_id -- 现金流编号
    ,int_rat_flow_id -- 利率流编号
    ,pricing_envir_id -- 定价环境编号
    ,cfm_cashflow_flg -- 确定现金流标志
    ,calc_dt -- 计算日期
    ,int_accr_start_dt -- 计息开始日期
    ,int_accr_end_dt -- 计息结束日期
    ,pay_dt -- 支付日期
    ,pay_amt -- 支付金额
    ,disct_rat -- 折现率
    ,pric_amt -- 本金金额
    ,pre_pric_amt -- 预测本金金额
    ,int_amt -- 利息金额
    ,pre_int_amt -- 预测利息金额
    ,pay_bf_pric -- 支付前本金
    ,pay_post_pric -- 支付后本金
    ,option_premium -- 期权费
    ,pre_option_premium -- 预测期权费
    ,curr_cd -- 币种代码
    ,stl_curr_cd -- 结算币种代码
    ,accu_pd -- 累积违约概率
    ,real_fin_instm_id -- 真实金融工具编号
    ,src_update_tm -- 源更新时间
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.fin_instm_id, o.fin_instm_id) as fin_instm_id -- 金融工具编号
    ,nvl(n.asset_type_id, o.asset_type_id) as asset_type_id -- 资产类型编号
    ,nvl(n.market_type_id, o.market_type_id) as market_type_id -- 市场类型编号
    ,nvl(n.lp_id, o.lp_id) as lp_id -- 法人编号
    ,nvl(n.task_group_id, o.task_group_id) as task_group_id -- 任务组编号
    ,nvl(n.cashflow_id, o.cashflow_id) as cashflow_id -- 现金流编号
    ,nvl(n.int_rat_flow_id, o.int_rat_flow_id) as int_rat_flow_id -- 利率流编号
    ,nvl(n.pricing_envir_id, o.pricing_envir_id) as pricing_envir_id -- 定价环境编号
    ,nvl(n.cfm_cashflow_flg, o.cfm_cashflow_flg) as cfm_cashflow_flg -- 确定现金流标志
    ,nvl(n.calc_dt, o.calc_dt) as calc_dt -- 计算日期
    ,nvl(n.int_accr_start_dt, o.int_accr_start_dt) as int_accr_start_dt -- 计息开始日期
    ,nvl(n.int_accr_end_dt, o.int_accr_end_dt) as int_accr_end_dt -- 计息结束日期
    ,nvl(n.pay_dt, o.pay_dt) as pay_dt -- 支付日期
    ,nvl(n.pay_amt, o.pay_amt) as pay_amt -- 支付金额
    ,nvl(n.disct_rat, o.disct_rat) as disct_rat -- 折现率
    ,nvl(n.pric_amt, o.pric_amt) as pric_amt -- 本金金额
    ,nvl(n.pre_pric_amt, o.pre_pric_amt) as pre_pric_amt -- 预测本金金额
    ,nvl(n.int_amt, o.int_amt) as int_amt -- 利息金额
    ,nvl(n.pre_int_amt, o.pre_int_amt) as pre_int_amt -- 预测利息金额
    ,nvl(n.pay_bf_pric, o.pay_bf_pric) as pay_bf_pric -- 支付前本金
    ,nvl(n.pay_post_pric, o.pay_post_pric) as pay_post_pric -- 支付后本金
    ,nvl(n.option_premium, o.option_premium) as option_premium -- 期权费
    ,nvl(n.pre_option_premium, o.pre_option_premium) as pre_option_premium -- 预测期权费
    ,nvl(n.curr_cd, o.curr_cd) as curr_cd -- 币种代码
    ,nvl(n.stl_curr_cd, o.stl_curr_cd) as stl_curr_cd -- 结算币种代码
    ,nvl(n.accu_pd, o.accu_pd) as accu_pd -- 累积违约概率
    ,nvl(n.real_fin_instm_id, o.real_fin_instm_id) as real_fin_instm_id -- 真实金融工具编号
    ,nvl(n.src_update_tm, o.src_update_tm) as src_update_tm -- 源更新时间
    ,case when
            n.fin_instm_id is null
            and n.asset_type_id is null
            and n.market_type_id is null
            and n.lp_id is null
            and n.task_group_id is null
            and n.cashflow_id is null
            and n.int_rat_flow_id is null
            and n.pricing_envir_id is null
            and n.int_accr_end_dt is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.fin_instm_id is null
            and n.asset_type_id is null
            and n.market_type_id is null
            and n.lp_id is null
            and n.task_group_id is null
            and n.cashflow_id is null
            and n.int_rat_flow_id is null
            and n.pricing_envir_id is null
            and n.int_accr_end_dt is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.fin_instm_id is null
            and n.asset_type_id is null
            and n.market_type_id is null
            and n.lp_id is null
            and n.task_group_id is null
            and n.cashflow_id is null
            and n.int_rat_flow_id is null
            and n.pricing_envir_id is null
            and n.int_accr_end_dt is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,nvl(n.src_table_name, o.src_table_name) as src_table_name -- 源表名称
    ,nvl(n.job_cd, o.job_cd) as job_cd -- 任务编码
    ,nvl(n.etl_timestamp, o.etl_timestamp) as etl_timestamp -- ETL处理时间戳
from ${iml_schema}.prd_ibank_cashflow_dtl_h_ibmsf1_tm n
    full join (select * from ${iml_schema}.prd_ibank_cashflow_dtl_h_ibmsf1_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
        on
            o.fin_instm_id = n.fin_instm_id
            and o.asset_type_id = n.asset_type_id
            and o.market_type_id = n.market_type_id
            and o.lp_id = n.lp_id
            and o.task_group_id = n.task_group_id
            and o.cashflow_id = n.cashflow_id
            and o.int_rat_flow_id = n.int_rat_flow_id
            and o.pricing_envir_id = n.pricing_envir_id
            and o.int_accr_end_dt = n.int_accr_end_dt
where (
        o.fin_instm_id is null
        and o.asset_type_id is null
        and o.market_type_id is null
        and o.lp_id is null
        and o.task_group_id is null
        and o.cashflow_id is null
        and o.int_rat_flow_id is null
        and o.pricing_envir_id is null
        and o.int_accr_end_dt is null
    )
    or (
        n.fin_instm_id is null
        and n.asset_type_id is null
        and n.market_type_id is null
        and n.lp_id is null
        and n.task_group_id is null
        and n.cashflow_id is null
        and n.int_rat_flow_id is null
        and n.pricing_envir_id is null
        and n.int_accr_end_dt is null
    )
    or (
        o.cfm_cashflow_flg <> n.cfm_cashflow_flg
        or o.calc_dt <> n.calc_dt
        or o.int_accr_start_dt <> n.int_accr_start_dt
        or o.pay_dt <> n.pay_dt
        or o.pay_amt <> n.pay_amt
        or o.disct_rat <> n.disct_rat
        or o.pric_amt <> n.pric_amt
        or o.pre_pric_amt <> n.pre_pric_amt
        or o.int_amt <> n.int_amt
        or o.pre_int_amt <> n.pre_int_amt
        or o.pay_bf_pric <> n.pay_bf_pric
        or o.pay_post_pric <> n.pay_post_pric
        or o.option_premium <> n.option_premium
        or o.pre_option_premium <> n.pre_option_premium
        or o.curr_cd <> n.curr_cd
        or o.stl_curr_cd <> n.stl_curr_cd
        or o.accu_pd <> n.accu_pd
        or o.real_fin_instm_id <> n.real_fin_instm_id
        or o.src_update_tm <> n.src_update_tm
    )
;
commit;

-- 3.3 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iml_schema}.prd_ibank_cashflow_dtl_h_ibmsf1_cl(
            fin_instm_id -- 金融工具编号
    ,asset_type_id -- 资产类型编号
    ,market_type_id -- 市场类型编号
    ,lp_id -- 法人编号
    ,task_group_id -- 任务组编号
    ,cashflow_id -- 现金流编号
    ,int_rat_flow_id -- 利率流编号
    ,pricing_envir_id -- 定价环境编号
    ,cfm_cashflow_flg -- 确定现金流标志
    ,calc_dt -- 计算日期
    ,int_accr_start_dt -- 计息开始日期
    ,int_accr_end_dt -- 计息结束日期
    ,pay_dt -- 支付日期
    ,pay_amt -- 支付金额
    ,disct_rat -- 折现率
    ,pric_amt -- 本金金额
    ,pre_pric_amt -- 预测本金金额
    ,int_amt -- 利息金额
    ,pre_int_amt -- 预测利息金额
    ,pay_bf_pric -- 支付前本金
    ,pay_post_pric -- 支付后本金
    ,option_premium -- 期权费
    ,pre_option_premium -- 预测期权费
    ,curr_cd -- 币种代码
    ,stl_curr_cd -- 结算币种代码
    ,accu_pd -- 累积违约概率
    ,real_fin_instm_id -- 真实金融工具编号
    ,src_update_tm -- 源更新时间
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iml_schema}.prd_ibank_cashflow_dtl_h_ibmsf1_op(
            fin_instm_id -- 金融工具编号
    ,asset_type_id -- 资产类型编号
    ,market_type_id -- 市场类型编号
    ,lp_id -- 法人编号
    ,task_group_id -- 任务组编号
    ,cashflow_id -- 现金流编号
    ,int_rat_flow_id -- 利率流编号
    ,pricing_envir_id -- 定价环境编号
    ,cfm_cashflow_flg -- 确定现金流标志
    ,calc_dt -- 计算日期
    ,int_accr_start_dt -- 计息开始日期
    ,int_accr_end_dt -- 计息结束日期
    ,pay_dt -- 支付日期
    ,pay_amt -- 支付金额
    ,disct_rat -- 折现率
    ,pric_amt -- 本金金额
    ,pre_pric_amt -- 预测本金金额
    ,int_amt -- 利息金额
    ,pre_int_amt -- 预测利息金额
    ,pay_bf_pric -- 支付前本金
    ,pay_post_pric -- 支付后本金
    ,option_premium -- 期权费
    ,pre_option_premium -- 预测期权费
    ,curr_cd -- 币种代码
    ,stl_curr_cd -- 结算币种代码
    ,accu_pd -- 累积违约概率
    ,real_fin_instm_id -- 真实金融工具编号
    ,src_update_tm -- 源更新时间
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.fin_instm_id -- 金融工具编号
    ,o.asset_type_id -- 资产类型编号
    ,o.market_type_id -- 市场类型编号
    ,o.lp_id -- 法人编号
    ,o.task_group_id -- 任务组编号
    ,o.cashflow_id -- 现金流编号
    ,o.int_rat_flow_id -- 利率流编号
    ,o.pricing_envir_id -- 定价环境编号
    ,o.cfm_cashflow_flg -- 确定现金流标志
    ,o.calc_dt -- 计算日期
    ,o.int_accr_start_dt -- 计息开始日期
    ,o.int_accr_end_dt -- 计息结束日期
    ,o.pay_dt -- 支付日期
    ,o.pay_amt -- 支付金额
    ,o.disct_rat -- 折现率
    ,o.pric_amt -- 本金金额
    ,o.pre_pric_amt -- 预测本金金额
    ,o.int_amt -- 利息金额
    ,o.pre_int_amt -- 预测利息金额
    ,o.pay_bf_pric -- 支付前本金
    ,o.pay_post_pric -- 支付后本金
    ,o.option_premium -- 期权费
    ,o.pre_option_premium -- 预测期权费
    ,o.curr_cd -- 币种代码
    ,o.stl_curr_cd -- 结算币种代码
    ,o.accu_pd -- 累积违约概率
    ,o.real_fin_instm_id -- 真实金融工具编号
    ,o.src_update_tm -- 源更新时间
    ,o.start_dt -- 开始时间
    ,case when n.start_dt is not null then to_date('${batch_date}', 'yyyymmdd')
          when o.end_dt >= to_date('${batch_date}','yyyymmdd') then to_date('20991231','yyyymmdd')
          else o.end_dt
     end as end_dt -- 结束时间
    , case when n.start_dt is not null
          then 'I'
          when o.end_dt >= to_date('${batch_date}','yyyymmdd')
          then 'I'
          else o.id_mark
     end as id_mark  -- 增删标志 
    ,o.src_table_name -- 源表名称
    ,o.job_cd -- 任务编码
    ,o.etl_timestamp -- ETL处理时间戳
from ${iml_schema}.prd_ibank_cashflow_dtl_h_ibmsf1_bk o
    left join ${iml_schema}.prd_ibank_cashflow_dtl_h_ibmsf1_op n
        on
            o.fin_instm_id = n.fin_instm_id
            and o.asset_type_id = n.asset_type_id
            and o.market_type_id = n.market_type_id
            and o.lp_id = n.lp_id
            and o.task_group_id = n.task_group_id
            and o.cashflow_id = n.cashflow_id
            and o.int_rat_flow_id = n.int_rat_flow_id
            and o.pricing_envir_id = n.pricing_envir_id
            and o.int_accr_end_dt = n.int_accr_end_dt
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iml_schema}.prd_ibank_cashflow_dtl_h_ibmsf1_cl d
        on
            o.fin_instm_id = d.fin_instm_id
            and o.asset_type_id = d.asset_type_id
            and o.market_type_id = d.market_type_id
            and o.lp_id = d.lp_id
            and o.task_group_id = d.task_group_id
            and o.cashflow_id = d.cashflow_id
            and o.int_rat_flow_id = d.int_rat_flow_id
            and o.pricing_envir_id = d.pricing_envir_id
            and o.int_accr_end_dt = d.int_accr_end_dt
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;
-- 4.1 truncate target table
--truncate table ${iml_schema}.prd_ibank_cashflow_dtl_h;
--alter table ${iml_schema}.prd_ibank_cashflow_dtl_h truncate partition for ('ibmsf1') reuse storage;

-- 4.2 rebuild partition
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
declare
v_sql varchar2(100);
begin
for cur in (select subpartition_name 
              from all_tab_subpartitions 
             where table_owner=upper('${iml_schema}') 
               and table_name=upper('prd_ibank_cashflow_dtl_h') 
               and substr(subpartition_name,1,8)=upper('p_ibmsf1')
               and substr(subpartition_name,10) >= '${batch_date}' 
               and substr(subpartition_name,10) < '20991231') loop
    v_sql := 'alter table ${iml_schema}.prd_ibank_cashflow_dtl_h drop subpartition ' || cur.subpartition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/

alter table ${iml_schema}.prd_ibank_cashflow_dtl_h modify partition p_ibmsf1 
add subpartition p_ibmsf1_${batch_date} values(to_date('${batch_date}','YYYYMMDD')) ;

-- 4.3 exchange partition
alter table ${iml_schema}.prd_ibank_cashflow_dtl_h exchange subpartition p_ibmsf1_${batch_date} with table ${iml_schema}.prd_ibank_cashflow_dtl_h_ibmsf1_cl;
alter table ${iml_schema}.prd_ibank_cashflow_dtl_h exchange subpartition p_ibmsf1_20991231 with table ${iml_schema}.prd_ibank_cashflow_dtl_h_ibmsf1_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iml_schema}.prd_ibank_cashflow_dtl_h to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iml_schema}.prd_ibank_cashflow_dtl_h_ibmsf1_tm purge;
drop table ${iml_schema}.prd_ibank_cashflow_dtl_h_ibmsf1_op purge;
drop table ${iml_schema}.prd_ibank_cashflow_dtl_h_ibmsf1_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iml_schema}.prd_ibank_cashflow_dtl_h_ibmsf1_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iml_schema}',tabname => 'prd_ibank_cashflow_dtl_h', partname => 'p_ibmsf1_20991231',ESTIMATE_PERCENT=>10, method_opt=>'for all columns size 1',no_invalidate=>false, force=>true, granularity => 'SUBPARTITION', degree => 8, cascade => true);
