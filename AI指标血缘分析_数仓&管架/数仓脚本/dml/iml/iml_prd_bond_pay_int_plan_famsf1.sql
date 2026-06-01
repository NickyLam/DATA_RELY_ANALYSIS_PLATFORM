/*
Purpose:    整全模型层-快照表脚本，备份目标表当月数据（不含当天），用前一天数据与当天数据整合后插入到目标表中。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iml_prd_bond_pay_int_plan_famsf1
CreateDate: 20180515
Logs:
    zjj 2018-05-15 新建表本
*/

set timing on

-- 1 alter parallel
alter session force parallel query parallel 4;
alter session force parallel dml parallel 4;
-- alter session force parallel ddl parallel 1;

-- 2.1 create table for exchage and add partition
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iml_schema}.prd_bond_pay_int_plan_famsf1_tm purge;
drop table ${iml_schema}.prd_bond_pay_int_plan_famsf1_ex purge;

-- 2.2 add partition for target table
alter table ${iml_schema}.prd_bond_pay_int_plan add partition p_famsf1 values ('famsf1')(
        subpartition p_famsf1_${batch_date} values (to_date('${batch_date}','yyyymmdd'))
    )
;
alter table ${iml_schema}.prd_bond_pay_int_plan modify partition p_famsf1
    add subpartition p_famsf1_${batch_date} values (to_date('${batch_date}','yyyymmdd'))
;

-- 2.3 if backup table is exists, mean script if failed on last time
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
create table ${iml_schema}.prd_bond_pay_int_plan_famsf1_bk nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.prd_bond_pay_int_plan partition for ('famsf1')
where create_dt < to_date('${batch_date}','yyyymmdd')
;

-- 2.4 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.prd_bond_pay_int_plan_famsf1_tm
compress ${option_switch} for query high
as
select
    prod_id -- 产品编号
    ,lp_id -- 法人编号
    ,pay_int_plan_id -- 付息计划编号
    ,plan_int_accr_start_dt -- 计划计息起始日期
    ,plan_int_accr_end_dt -- 计划计息结束日期
    ,actl_int_accr_start_dt -- 实际计息起始日期
    ,actl_int_accr_end_dt -- 实际计息结束日期
    ,pay_int_dt -- 付息日期
    ,currt_int_rat -- 当期利率
    ,currt_acru_int -- 当期应计利息
    ,td_acru_int -- 当日应计利息
    ,pay_pric_amt -- 支付本金金额
    ,pay_cashflow_amt -- 支付现金流金额
    ,int_accr_pric_amt -- 计息本金金额
    ,currt_hook_init_int_rat -- 当期挂钩原始利率
    ,currt_adj_coef -- 当期调整系数
    ,float_int_rat_point -- 浮动利率点数
    ,valid_flg -- 有效标志
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
from ${iml_schema}.prd_bond_pay_int_plan
where 0=1;

-- 2.5 create temp table
create table ${iml_schema}.prd_bond_pay_int_plan_famsf1_ex nologging
compress ${option_switch} for query high
as select * from ${iml_schema}.prd_bond_pay_int_plan partition for ('famsf1') where 0=1;

-- 2.1 insert data to tm table
-- fams_src_secschedule-
insert into ${iml_schema}.prd_bond_pay_int_plan_famsf1_tm(
    prod_id -- 产品编号
    ,lp_id -- 法人编号
    ,pay_int_plan_id -- 付息计划编号
    ,plan_int_accr_start_dt -- 计划计息起始日期
    ,plan_int_accr_end_dt -- 计划计息结束日期
    ,actl_int_accr_start_dt -- 实际计息起始日期
    ,actl_int_accr_end_dt -- 实际计息结束日期
    ,pay_int_dt -- 付息日期
    ,currt_int_rat -- 当期利率
    ,currt_acru_int -- 当期应计利息
    ,td_acru_int -- 当日应计利息
    ,pay_pric_amt -- 支付本金金额
    ,pay_cashflow_amt -- 支付现金流金额
    ,int_accr_pric_amt -- 计息本金金额
    ,currt_hook_init_int_rat -- 当期挂钩原始利率
    ,currt_adj_coef -- 当期调整系数
    ,float_int_rat_point -- 浮动利率点数
    ,valid_flg -- 有效标志
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
)
select
    P1.SECID -- 产品编号
    ,'9999' -- 法人编号
    ,TO_CHAR(P1.SCHEDULENUM) -- 付息计划编号
    ,${iml_schema}.DATEFORMAT_MIN(to_char(P1.TOTALINTERESTSTARTDAY)) -- 计划计息起始日期
    ,${iml_schema}.DATEFORMAT_MAX(to_char(P1.TOTALINTERESTENDDAY)) -- 计划计息结束日期
    ,${iml_schema}.DATEFORMAT_MIN(to_char(P1.INTERESTSTARTDAY)) -- 实际计息起始日期
    ,${iml_schema}.DATEFORMAT_MAX(to_char(P1.INTERESTENDDAY)) -- 实际计息结束日期
    ,${iml_schema}.DATEFORMAT_MAX(to_char(P1.INTERESTPAYDAY)) -- 付息日期
    ,P1.COUPONRATE -- 当期利率
    ,P1.ACCRUEINTAMT -- 当期应计利息
    ,P1.DAILYACCRUEINT -- 当日应计利息
    ,P1.PRINAMTPAY -- 支付本金金额
    ,P1.CASHPAY -- 支付现金流金额
    ,P1.PRINAMT -- 计息本金金额
    ,P1.BASICRATE -- 当期挂钩原始利率
    ,P1.COEFFICIENT -- 当期调整系数
    ,P1.SPREADRATE_8 -- 浮动利率点数
    ,P1.EFFECTFLAG -- 有效标志
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,'fams_src_secschedule' -- 源表名称
    ,'famsf1' -- 任务编码
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间戳
from ${iol_schema}.fams_src_secschedule p1
where p1.start_dt <= to_date('${batch_date}','yyyymmdd') and p1.end_dt > to_date('${batch_date}','yyyymmdd')
;
commit;


commit;



whenever sqlerror exit sql.sqlcode;
declare
cnt integer;
begin
  for cur in (select 1 from dual) loop
  	select count(1) into cnt from (select 1 from ${iml_schema}.prd_bond_pay_int_plan_famsf1_tm 
  	                                group by 
  	                                        prod_id
  	                                        ,lp_id
  	                                        ,pay_int_plan_id
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

-- 2.2 chage data and update_dt, create_dt, etl_dt
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ into ${iml_schema}.prd_bond_pay_int_plan_famsf1_ex(
    prod_id -- 产品编号
    ,lp_id -- 法人编号
    ,pay_int_plan_id -- 付息计划编号
    ,plan_int_accr_start_dt -- 计划计息起始日期
    ,plan_int_accr_end_dt -- 计划计息结束日期
    ,actl_int_accr_start_dt -- 实际计息起始日期
    ,actl_int_accr_end_dt -- 实际计息结束日期
    ,pay_int_dt -- 付息日期
    ,currt_int_rat -- 当期利率
    ,currt_acru_int -- 当期应计利息
    ,td_acru_int -- 当日应计利息
    ,pay_pric_amt -- 支付本金金额
    ,pay_cashflow_amt -- 支付现金流金额
    ,int_accr_pric_amt -- 计息本金金额
    ,currt_hook_init_int_rat -- 当期挂钩原始利率
    ,currt_adj_coef -- 当期调整系数
    ,float_int_rat_point -- 浮动利率点数
    ,valid_flg -- 有效标志
    ,create_dt -- 创建日期
    ,update_dt -- 更新日期
    ,etl_dt -- ETL处理日期
    ,id_mark -- 增删标志
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
)
select
    nvl(n.prod_id, o.prod_id) as prod_id -- 产品编号
    ,nvl(n.lp_id, o.lp_id) as lp_id -- 法人编号
    ,nvl(n.pay_int_plan_id, o.pay_int_plan_id) as pay_int_plan_id -- 付息计划编号
    ,nvl(n.plan_int_accr_start_dt, o.plan_int_accr_start_dt) as plan_int_accr_start_dt -- 计划计息起始日期
    ,nvl(n.plan_int_accr_end_dt, o.plan_int_accr_end_dt) as plan_int_accr_end_dt -- 计划计息结束日期
    ,nvl(n.actl_int_accr_start_dt, o.actl_int_accr_start_dt) as actl_int_accr_start_dt -- 实际计息起始日期
    ,nvl(n.actl_int_accr_end_dt, o.actl_int_accr_end_dt) as actl_int_accr_end_dt -- 实际计息结束日期
    ,nvl(n.pay_int_dt, o.pay_int_dt) as pay_int_dt -- 付息日期
    ,nvl(n.currt_int_rat, o.currt_int_rat) as currt_int_rat -- 当期利率
    ,nvl(n.currt_acru_int, o.currt_acru_int) as currt_acru_int -- 当期应计利息
    ,nvl(n.td_acru_int, o.td_acru_int) as td_acru_int -- 当日应计利息
    ,nvl(n.pay_pric_amt, o.pay_pric_amt) as pay_pric_amt -- 支付本金金额
    ,nvl(n.pay_cashflow_amt, o.pay_cashflow_amt) as pay_cashflow_amt -- 支付现金流金额
    ,nvl(n.int_accr_pric_amt, o.int_accr_pric_amt) as int_accr_pric_amt -- 计息本金金额
    ,nvl(n.currt_hook_init_int_rat, o.currt_hook_init_int_rat) as currt_hook_init_int_rat -- 当期挂钩原始利率
    ,nvl(n.currt_adj_coef, o.currt_adj_coef) as currt_adj_coef -- 当期调整系数
    ,nvl(n.float_int_rat_point, o.float_int_rat_point) as float_int_rat_point -- 浮动利率点数
    ,nvl(n.valid_flg, o.valid_flg) as valid_flg -- 有效标志
    ,nvl(o.create_dt, to_date('${batch_date}', 'yyyymmdd')) as create_dt -- 创建日期
    ,case when (
                o.prod_id is null
                and o.lp_id is null
                and o.pay_int_plan_id is null
            ) or (
                o.plan_int_accr_start_dt <> n.plan_int_accr_start_dt
                or o.plan_int_accr_end_dt <> n.plan_int_accr_end_dt
                or o.actl_int_accr_start_dt <> n.actl_int_accr_start_dt
                or o.actl_int_accr_end_dt <> n.actl_int_accr_end_dt
                or o.pay_int_dt <> n.pay_int_dt
                or o.currt_int_rat <> n.currt_int_rat
                or o.currt_acru_int <> n.currt_acru_int
                or o.td_acru_int <> n.td_acru_int
                or o.pay_pric_amt <> n.pay_pric_amt
                or o.pay_cashflow_amt <> n.pay_cashflow_amt
                or o.int_accr_pric_amt <> n.int_accr_pric_amt
                or o.currt_hook_init_int_rat <> n.currt_hook_init_int_rat
                or o.currt_adj_coef <> n.currt_adj_coef
                or o.float_int_rat_point <> n.float_int_rat_point
                or o.valid_flg <> n.valid_flg
            ) or (
                 case when (
                           n.prod_id is null
                           and n.lp_id is null
                           and n.pay_int_plan_id is null
                         )
                      then 'D'
                 else 'I'
                 end
            )<> o.id_mark
        then to_date('${batch_date}', 'yyyymmdd')
        else o.update_dt
     end as update_dt -- 更新日期
    ,to_date('${batch_date}', 'yyyymmdd') as etl_dt -- ETL处理日期
    ,case when (
                n.prod_id is null
                and n.lp_id is null
                and n.pay_int_plan_id is null
            )
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,nvl(n.src_table_name, o.src_table_name) as src_table_name -- 源表名称
    ,nvl(n.job_cd, o.job_cd) as job_cd -- 任务编码
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间戳
from ${iml_schema}.prd_bond_pay_int_plan_famsf1_tm n
    full join ${iml_schema}.prd_bond_pay_int_plan_famsf1_bk o
        on
            o.prod_id = n.prod_id
            and o.lp_id = n.lp_id
            and o.pay_int_plan_id = n.pay_int_plan_id
;
commit;

-- 3.1 truncate target table batch_date partition
whenever sqlerror exit sql.sqlcode;
alter table ${iml_schema}.prd_bond_pay_int_plan truncate partition for ('famsf1') reuse storage;

-- 3.2 exchage tm table and target table
alter table ${iml_schema}.prd_bond_pay_int_plan exchange subpartition p_famsf1_${batch_date} with table ${iml_schema}.prd_bond_pay_int_plan_famsf1_ex;

-- 3.3 drop subpartition last_date partition
whenever sqlerror continue none ;
alter table ${iml_schema}.prd_bond_pay_int_plan drop subpartition p_famsf1_${last_date} update global indexes;

-- 4.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iml_schema}.prd_bond_pay_int_plan to ${iml_schema};

-- 4.2 drop tm table
drop table ${iml_schema}.prd_bond_pay_int_plan_famsf1_tm purge;
drop table ${iml_schema}.prd_bond_pay_int_plan_famsf1_ex purge;
drop table ${iml_schema}.prd_bond_pay_int_plan_famsf1_bk purge;

-- 5 gater table status
exec dbms_stats.gather_table_stats(ownname => '${iml_schema}',tabname => 'prd_bond_pay_int_plan', partname => 'p_famsf1_${batch_date}', ESTIMATE_PERCENT=>10, method_opt=>'for all columns size 1',no_invalidate=>false, force=>true, granularity => 'SUBPARTITION', degree => 8, cascade => true);