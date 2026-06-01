/*
Purpose:    整合模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iml_prd_int_accr_dtl_ibmsf1
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
alter table ${iml_schema}.prd_int_accr_dtl add partition p_ibmsf1 values ('ibmsf1')(
        subpartition p_ibmsf1_19000101 values (to_date('19000101','yyyymmdd'))
        ,subpartition p_ibmsf1_20991231 values (to_date('20991231','yyyymmdd'))
    )
;

-- if backup table is exists, mean script if failed on last time
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
create table ${iml_schema}.prd_int_accr_dtl_ibmsf1_bk nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.prd_int_accr_dtl partition for ('ibmsf1')
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd')
;

-- 2.2 drop temp table
whenever sqlerror continue none ;
-- it is no need to check when this segment SQL was return faied
drop table ${iml_schema}.prd_int_accr_dtl_ibmsf1_tm purge;
drop table ${iml_schema}.prd_int_accr_dtl_ibmsf1_op purge;
drop table ${iml_schema}.prd_int_accr_dtl_ibmsf1_cl purge;

-- 2.3 create temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.prd_int_accr_dtl_ibmsf1_tm nologging
compress ${option_switch} for query high
as select
    fin_instm_id -- 金融工具编号
    ,asset_type_id -- 资产类型编号
    ,market_type_id -- 市场类型编号
    ,task_group_id -- 任务组编号
    ,cashflow_id -- 现金流编号
    ,int_rat_flow_id -- 利率流编号
    ,int_accr_dtl_id -- 计息明细编号
    ,pricing_envir_id -- 定价环境编号
    ,lp_id -- 法人编号
    ,int_accr_start_dt -- 计息开始日期
    ,int_accr_end_dt -- 计息结束日期
    ,set_int_dt -- 定息日期
    ,actl_int_rat -- 实际利率
    ,int_accr_year_cnt -- 计息年数
    ,int_accr_intrv_int_rat -- 计息区间利率
    ,spd -- 利差
    ,int_rat_uplmi -- 利率上限
    ,int_rat_lolmi -- 利率下限
    ,base_rat_mult -- 基准利率倍数
    ,actl_fin_instm_id -- 实际金融工具编号
    ,pay_int_dt -- 付息日期
    ,int_accr_intrv_int -- 计息区间利息
    ,int_accr_intrv_pric -- 计息区间本金
    ,to_date('${batch_date}', 'yyyymmdd') as etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
from ${iml_schema}.prd_int_accr_dtl partition for ('ibmsf1')
where 0=1
;

create table ${iml_schema}.prd_int_accr_dtl_ibmsf1_op nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.prd_int_accr_dtl partition for ('ibmsf1') where 0=1;

create table ${iml_schema}.prd_int_accr_dtl_ibmsf1_cl nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.prd_int_accr_dtl partition for ('ibmsf1') where 0=1;

-- 3.1 get new data into table
-- ibms_tbsi_accrualdetail-
insert into ${iml_schema}.prd_int_accr_dtl_ibmsf1_tm(
    fin_instm_id -- 金融工具编号
    ,asset_type_id -- 资产类型编号
    ,market_type_id -- 市场类型编号
    ,task_group_id -- 任务组编号
    ,cashflow_id -- 现金流编号
    ,int_rat_flow_id -- 利率流编号
    ,int_accr_dtl_id -- 计息明细编号
    ,pricing_envir_id -- 定价环境编号
    ,lp_id -- 法人编号
    ,int_accr_start_dt -- 计息开始日期
    ,int_accr_end_dt -- 计息结束日期
    ,set_int_dt -- 定息日期
    ,actl_int_rat -- 实际利率
    ,int_accr_year_cnt -- 计息年数
    ,int_accr_intrv_int_rat -- 计息区间利率
    ,spd -- 利差
    ,int_rat_uplmi -- 利率上限
    ,int_rat_lolmi -- 利率下限
    ,base_rat_mult -- 基准利率倍数
    ,actl_fin_instm_id -- 实际金融工具编号
    ,pay_int_dt -- 付息日期
    ,int_accr_intrv_int -- 计息区间利息
    ,int_accr_intrv_pric -- 计息区间本金
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
)
select
    P1.I_CODE -- 金融工具编号
    ,P1.A_TYPE -- 资产类型编号
    ,P1.M_TYPE -- 市场类型编号
    ,P1.TG_CODE -- 任务组编号
    ,P1.AD_CFID -- 现金流编号
    ,P1.STREAM_ID -- 利率流编号
    ,P1.SELF_ID -- 计息明细编号
    ,P1.PE_CODE -- 定价环境编号
    ,'9999' -- 法人编号
    ,${iml_schema}.DATEFORMAT_MIN(P1.AD_STARTDATE） -- 计息开始日期
    ,${iml_schema}.DATEFORMAT_MAX(P1.AD_ENDDATE） -- 计息结束日期
    ,${iml_schema}.DATEFORMAT_MIN(P1.AD_FIXINGDATE） -- 定息日期
    ,P1.AD_ACTUALRATE*100 -- 实际利率
    ,P1.AD_YEARFRACTION -- 计息年数
    ,P1.AD_FIXINGRATE*100 -- 计息区间利率
    ,P1.AD_SPREAD -- 利差
    ,P1.AD_CAPRATE -- 利率上限
    ,P1.AD_FLOORRATE -- 利率下限
    ,P1.AD_MULTIPLIER -- 基准利率倍数
    ,P1.REAL_I_CODE -- 实际金融工具编号
    ,${iml_schema}.DATEFORMAT_MAX(P1.AD_PAYMENTDATE） -- 付息日期
    ,P1.AD_INTERESTAMOUNT -- 计息区间利息
    ,P1.AD_NOTIONALAMOUNT -- 计息区间本金
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,'ibms_tbsi_accrualdetail' -- 源表名称
    ,'ibmsf1' -- 任务编码
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间戳
from ${iol_schema}.ibms_tbsi_accrualdetail p1
where p1.start_dt <= to_date('${batch_date}','yyyymmdd') and p1.end_dt > to_date('${batch_date}','yyyymmdd')
;
commit;


commit;

whenever sqlerror exit sql.sqlcode;
declare
cnt integer;
begin
  for cur in (select 1 from dual) loop
  	select count(1) into cnt from (select 1 from ${iml_schema}.prd_int_accr_dtl_ibmsf1_tm 
  	                                group by 
  	                                        fin_instm_id
  	                                        ,asset_type_id
  	                                        ,market_type_id
  	                                        ,task_group_id
  	                                        ,cashflow_id
  	                                        ,int_rat_flow_id
  	                                        ,int_accr_dtl_id
  	                                        ,pricing_envir_id
  	                                        ,lp_id
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
        into ${iml_schema}.prd_int_accr_dtl_ibmsf1_cl(
            fin_instm_id -- 金融工具编号
    ,asset_type_id -- 资产类型编号
    ,market_type_id -- 市场类型编号
    ,task_group_id -- 任务组编号
    ,cashflow_id -- 现金流编号
    ,int_rat_flow_id -- 利率流编号
    ,int_accr_dtl_id -- 计息明细编号
    ,pricing_envir_id -- 定价环境编号
    ,lp_id -- 法人编号
    ,int_accr_start_dt -- 计息开始日期
    ,int_accr_end_dt -- 计息结束日期
    ,set_int_dt -- 定息日期
    ,actl_int_rat -- 实际利率
    ,int_accr_year_cnt -- 计息年数
    ,int_accr_intrv_int_rat -- 计息区间利率
    ,spd -- 利差
    ,int_rat_uplmi -- 利率上限
    ,int_rat_lolmi -- 利率下限
    ,base_rat_mult -- 基准利率倍数
    ,actl_fin_instm_id -- 实际金融工具编号
    ,pay_int_dt -- 付息日期
    ,int_accr_intrv_int -- 计息区间利息
    ,int_accr_intrv_pric -- 计息区间本金
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iml_schema}.prd_int_accr_dtl_ibmsf1_op(
            fin_instm_id -- 金融工具编号
    ,asset_type_id -- 资产类型编号
    ,market_type_id -- 市场类型编号
    ,task_group_id -- 任务组编号
    ,cashflow_id -- 现金流编号
    ,int_rat_flow_id -- 利率流编号
    ,int_accr_dtl_id -- 计息明细编号
    ,pricing_envir_id -- 定价环境编号
    ,lp_id -- 法人编号
    ,int_accr_start_dt -- 计息开始日期
    ,int_accr_end_dt -- 计息结束日期
    ,set_int_dt -- 定息日期
    ,actl_int_rat -- 实际利率
    ,int_accr_year_cnt -- 计息年数
    ,int_accr_intrv_int_rat -- 计息区间利率
    ,spd -- 利差
    ,int_rat_uplmi -- 利率上限
    ,int_rat_lolmi -- 利率下限
    ,base_rat_mult -- 基准利率倍数
    ,actl_fin_instm_id -- 实际金融工具编号
    ,pay_int_dt -- 付息日期
    ,int_accr_intrv_int -- 计息区间利息
    ,int_accr_intrv_pric -- 计息区间本金
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
    ,nvl(n.task_group_id, o.task_group_id) as task_group_id -- 任务组编号
    ,nvl(n.cashflow_id, o.cashflow_id) as cashflow_id -- 现金流编号
    ,nvl(n.int_rat_flow_id, o.int_rat_flow_id) as int_rat_flow_id -- 利率流编号
    ,nvl(n.int_accr_dtl_id, o.int_accr_dtl_id) as int_accr_dtl_id -- 计息明细编号
    ,nvl(n.pricing_envir_id, o.pricing_envir_id) as pricing_envir_id -- 定价环境编号
    ,nvl(n.lp_id, o.lp_id) as lp_id -- 法人编号
    ,nvl(n.int_accr_start_dt, o.int_accr_start_dt) as int_accr_start_dt -- 计息开始日期
    ,nvl(n.int_accr_end_dt, o.int_accr_end_dt) as int_accr_end_dt -- 计息结束日期
    ,nvl(n.set_int_dt, o.set_int_dt) as set_int_dt -- 定息日期
    ,nvl(n.actl_int_rat, o.actl_int_rat) as actl_int_rat -- 实际利率
    ,nvl(n.int_accr_year_cnt, o.int_accr_year_cnt) as int_accr_year_cnt -- 计息年数
    ,nvl(n.int_accr_intrv_int_rat, o.int_accr_intrv_int_rat) as int_accr_intrv_int_rat -- 计息区间利率
    ,nvl(n.spd, o.spd) as spd -- 利差
    ,nvl(n.int_rat_uplmi, o.int_rat_uplmi) as int_rat_uplmi -- 利率上限
    ,nvl(n.int_rat_lolmi, o.int_rat_lolmi) as int_rat_lolmi -- 利率下限
    ,nvl(n.base_rat_mult, o.base_rat_mult) as base_rat_mult -- 基准利率倍数
    ,nvl(n.actl_fin_instm_id, o.actl_fin_instm_id) as actl_fin_instm_id -- 实际金融工具编号
    ,nvl(n.pay_int_dt, o.pay_int_dt) as pay_int_dt -- 付息日期
    ,nvl(n.int_accr_intrv_int, o.int_accr_intrv_int) as int_accr_intrv_int -- 计息区间利息
    ,nvl(n.int_accr_intrv_pric, o.int_accr_intrv_pric) as int_accr_intrv_pric -- 计息区间本金
    ,case when
            n.fin_instm_id is null
            and n.asset_type_id is null
            and n.market_type_id is null
            and n.task_group_id is null
            and n.cashflow_id is null
            and n.int_rat_flow_id is null
            and n.int_accr_dtl_id is null
            and n.pricing_envir_id is null
            and n.lp_id is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.fin_instm_id is null
            and n.asset_type_id is null
            and n.market_type_id is null
            and n.task_group_id is null
            and n.cashflow_id is null
            and n.int_rat_flow_id is null
            and n.int_accr_dtl_id is null
            and n.pricing_envir_id is null
            and n.lp_id is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.fin_instm_id is null
            and n.asset_type_id is null
            and n.market_type_id is null
            and n.task_group_id is null
            and n.cashflow_id is null
            and n.int_rat_flow_id is null
            and n.int_accr_dtl_id is null
            and n.pricing_envir_id is null
            and n.lp_id is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,nvl(n.src_table_name, o.src_table_name) as src_table_name -- 源表名称
    ,nvl(n.job_cd, o.job_cd) as job_cd -- 任务编码
    ,nvl(n.etl_timestamp, o.etl_timestamp) as etl_timestamp -- ETL处理时间戳
from ${iml_schema}.prd_int_accr_dtl_ibmsf1_tm n
    full join (select * from ${iml_schema}.prd_int_accr_dtl_ibmsf1_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
        on
            o.fin_instm_id = n.fin_instm_id
            and o.asset_type_id = n.asset_type_id
            and o.market_type_id = n.market_type_id
            and o.task_group_id = n.task_group_id
            and o.cashflow_id = n.cashflow_id
            and o.int_rat_flow_id = n.int_rat_flow_id
            and o.int_accr_dtl_id = n.int_accr_dtl_id
            and o.pricing_envir_id = n.pricing_envir_id
            and o.lp_id = n.lp_id
where (
        o.fin_instm_id is null
        and o.asset_type_id is null
        and o.market_type_id is null
        and o.task_group_id is null
        and o.cashflow_id is null
        and o.int_rat_flow_id is null
        and o.int_accr_dtl_id is null
        and o.pricing_envir_id is null
        and o.lp_id is null
    )
    or (
        n.fin_instm_id is null
        and n.asset_type_id is null
        and n.market_type_id is null
        and n.task_group_id is null
        and n.cashflow_id is null
        and n.int_rat_flow_id is null
        and n.int_accr_dtl_id is null
        and n.pricing_envir_id is null
        and n.lp_id is null
    )
    or (
        o.int_accr_start_dt <> n.int_accr_start_dt
        or o.int_accr_end_dt <> n.int_accr_end_dt
        or o.set_int_dt <> n.set_int_dt
        or o.actl_int_rat <> n.actl_int_rat
        or o.int_accr_year_cnt <> n.int_accr_year_cnt
        or o.int_accr_intrv_int_rat <> n.int_accr_intrv_int_rat
        or o.spd <> n.spd
        or o.int_rat_uplmi <> n.int_rat_uplmi
        or o.int_rat_lolmi <> n.int_rat_lolmi
        or o.base_rat_mult <> n.base_rat_mult
        or o.actl_fin_instm_id <> n.actl_fin_instm_id
        or o.pay_int_dt <> n.pay_int_dt
        or o.int_accr_intrv_int <> n.int_accr_intrv_int
        or o.int_accr_intrv_pric <> n.int_accr_intrv_pric
    )
;
commit;

-- 3.3 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iml_schema}.prd_int_accr_dtl_ibmsf1_cl(
            fin_instm_id -- 金融工具编号
    ,asset_type_id -- 资产类型编号
    ,market_type_id -- 市场类型编号
    ,task_group_id -- 任务组编号
    ,cashflow_id -- 现金流编号
    ,int_rat_flow_id -- 利率流编号
    ,int_accr_dtl_id -- 计息明细编号
    ,pricing_envir_id -- 定价环境编号
    ,lp_id -- 法人编号
    ,int_accr_start_dt -- 计息开始日期
    ,int_accr_end_dt -- 计息结束日期
    ,set_int_dt -- 定息日期
    ,actl_int_rat -- 实际利率
    ,int_accr_year_cnt -- 计息年数
    ,int_accr_intrv_int_rat -- 计息区间利率
    ,spd -- 利差
    ,int_rat_uplmi -- 利率上限
    ,int_rat_lolmi -- 利率下限
    ,base_rat_mult -- 基准利率倍数
    ,actl_fin_instm_id -- 实际金融工具编号
    ,pay_int_dt -- 付息日期
    ,int_accr_intrv_int -- 计息区间利息
    ,int_accr_intrv_pric -- 计息区间本金
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iml_schema}.prd_int_accr_dtl_ibmsf1_op(
            fin_instm_id -- 金融工具编号
    ,asset_type_id -- 资产类型编号
    ,market_type_id -- 市场类型编号
    ,task_group_id -- 任务组编号
    ,cashflow_id -- 现金流编号
    ,int_rat_flow_id -- 利率流编号
    ,int_accr_dtl_id -- 计息明细编号
    ,pricing_envir_id -- 定价环境编号
    ,lp_id -- 法人编号
    ,int_accr_start_dt -- 计息开始日期
    ,int_accr_end_dt -- 计息结束日期
    ,set_int_dt -- 定息日期
    ,actl_int_rat -- 实际利率
    ,int_accr_year_cnt -- 计息年数
    ,int_accr_intrv_int_rat -- 计息区间利率
    ,spd -- 利差
    ,int_rat_uplmi -- 利率上限
    ,int_rat_lolmi -- 利率下限
    ,base_rat_mult -- 基准利率倍数
    ,actl_fin_instm_id -- 实际金融工具编号
    ,pay_int_dt -- 付息日期
    ,int_accr_intrv_int -- 计息区间利息
    ,int_accr_intrv_pric -- 计息区间本金
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
    ,o.task_group_id -- 任务组编号
    ,o.cashflow_id -- 现金流编号
    ,o.int_rat_flow_id -- 利率流编号
    ,o.int_accr_dtl_id -- 计息明细编号
    ,o.pricing_envir_id -- 定价环境编号
    ,o.lp_id -- 法人编号
    ,o.int_accr_start_dt -- 计息开始日期
    ,o.int_accr_end_dt -- 计息结束日期
    ,o.set_int_dt -- 定息日期
    ,o.actl_int_rat -- 实际利率
    ,o.int_accr_year_cnt -- 计息年数
    ,o.int_accr_intrv_int_rat -- 计息区间利率
    ,o.spd -- 利差
    ,o.int_rat_uplmi -- 利率上限
    ,o.int_rat_lolmi -- 利率下限
    ,o.base_rat_mult -- 基准利率倍数
    ,o.actl_fin_instm_id -- 实际金融工具编号
    ,o.pay_int_dt -- 付息日期
    ,o.int_accr_intrv_int -- 计息区间利息
    ,o.int_accr_intrv_pric -- 计息区间本金
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
from ${iml_schema}.prd_int_accr_dtl_ibmsf1_bk o
    left join ${iml_schema}.prd_int_accr_dtl_ibmsf1_op n
        on
            o.fin_instm_id = n.fin_instm_id
            and o.asset_type_id = n.asset_type_id
            and o.market_type_id = n.market_type_id
            and o.task_group_id = n.task_group_id
            and o.cashflow_id = n.cashflow_id
            and o.int_rat_flow_id = n.int_rat_flow_id
            and o.int_accr_dtl_id = n.int_accr_dtl_id
            and o.pricing_envir_id = n.pricing_envir_id
            and o.lp_id = n.lp_id
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iml_schema}.prd_int_accr_dtl_ibmsf1_cl d
        on
            o.fin_instm_id = d.fin_instm_id
            and o.asset_type_id = d.asset_type_id
            and o.market_type_id = d.market_type_id
            and o.task_group_id = d.task_group_id
            and o.cashflow_id = d.cashflow_id
            and o.int_rat_flow_id = d.int_rat_flow_id
            and o.int_accr_dtl_id = d.int_accr_dtl_id
            and o.pricing_envir_id = d.pricing_envir_id
            and o.lp_id = d.lp_id
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;
-- 4.1 truncate target table
--truncate table ${iml_schema}.prd_int_accr_dtl;
--alter table ${iml_schema}.prd_int_accr_dtl truncate partition for ('ibmsf1') reuse storage;

-- 4.2 rebuild partition
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
declare
v_sql varchar2(100);
begin
for cur in (select subpartition_name 
              from all_tab_subpartitions 
             where table_owner=upper('${iml_schema}') 
               and table_name=upper('prd_int_accr_dtl') 
               and substr(subpartition_name,1,8)=upper('p_ibmsf1')
               and substr(subpartition_name,10) >= '${batch_date}' 
               and substr(subpartition_name,10) < '20991231') loop
    v_sql := 'alter table ${iml_schema}.prd_int_accr_dtl drop subpartition ' || cur.subpartition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/

alter table ${iml_schema}.prd_int_accr_dtl modify partition p_ibmsf1 
add subpartition p_ibmsf1_${batch_date} values(to_date('${batch_date}','YYYYMMDD')) ;

-- 4.3 exchange partition
alter table ${iml_schema}.prd_int_accr_dtl exchange subpartition p_ibmsf1_${batch_date} with table ${iml_schema}.prd_int_accr_dtl_ibmsf1_cl;
alter table ${iml_schema}.prd_int_accr_dtl exchange subpartition p_ibmsf1_20991231 with table ${iml_schema}.prd_int_accr_dtl_ibmsf1_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iml_schema}.prd_int_accr_dtl to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iml_schema}.prd_int_accr_dtl_ibmsf1_tm purge;
drop table ${iml_schema}.prd_int_accr_dtl_ibmsf1_op purge;
drop table ${iml_schema}.prd_int_accr_dtl_ibmsf1_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iml_schema}.prd_int_accr_dtl_ibmsf1_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iml_schema}',tabname => 'prd_int_accr_dtl', partname => 'p_ibmsf1_20991231',ESTIMATE_PERCENT=>10, method_opt=>'for all columns size 1',no_invalidate=>false, force=>true, granularity => 'SUBPARTITION', degree => 8, cascade => true);
