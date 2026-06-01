/*
Purpose:    整合模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iml_agt_retl_dubil_renew_appl_icmsf1
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
alter table ${iml_schema}.agt_retl_dubil_renew_appl add partition p_icmsf1 values ('icmsf1')(
        subpartition p_icmsf1_19000101 values (to_date('19000101','yyyymmdd'))
        ,subpartition p_icmsf1_20991231 values (to_date('20991231','yyyymmdd'))
    )
;

-- if backup table is exists, mean script if failed on last time
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
create table ${iml_schema}.agt_retl_dubil_renew_appl_icmsf1_bk nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.agt_retl_dubil_renew_appl partition for ('icmsf1')
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd')
;

-- 2.2 drop temp table
whenever sqlerror continue none ;
-- it is no need to check when this segment SQL was return faied
drop table ${iml_schema}.agt_retl_dubil_renew_appl_icmsf1_tm purge;
drop table ${iml_schema}.agt_retl_dubil_renew_appl_icmsf1_op purge;
drop table ${iml_schema}.agt_retl_dubil_renew_appl_icmsf1_cl purge;

-- 2.3 create temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.agt_retl_dubil_renew_appl_icmsf1_tm nologging
compress ${option_switch} for query high
as select
    appl_id -- 申请编号
    ,lp_id -- 法人编号
    ,renew_flow_num -- 展期流水号
    ,rela_dubil_id -- 关联借据编号
    ,obj_id -- 对象编号
    ,obj_type_name -- 对象类型名称
    ,base_rat_type_cd -- 基准利率类型代码
    ,renew_sucs_flg -- 展期成功标志
    ,renew_cont_id -- 展期合同编号
    ,repay_way_cd -- 还款方式代码
    ,repay_ped_cd -- 还款周期代码
    ,effect_dt -- 生效日期
    ,exp_dt -- 到期日期
    ,mon_tenor -- 月期限
    ,base_int_rat -- 基准利率
    ,int_rat_float_point -- 利率浮动点数
    ,int_rat_float_way_cd -- 利率浮动方式代码
    ,loan_exec_year_int_rat -- 执行年利率
    ,ovdue_int_rat_float_way_cd -- 逾期利率浮动方式代码
    ,ovdue_int_rat_fl_rt -- 逾期利率浮动比例
    ,int_rat_adj_way_cd -- 利率调整方式代码
    ,int_rat_adj_ped_cd -- 利率调整周期代码
    ,regroup_loan_flg -- 重组贷款标志
    ,aldy_call_core_intfc_flg -- 已调用核心接口标志
    ,precon_id -- 预约编号
    ,blon_loan_amort_dt -- 气球贷摊销日期
    ,blon_loan_incrs_amt -- 气球贷递增金额
    ,blon_loan_incrs_ratio -- 气球贷递增比例
    ,remark -- 备注
    ,init_cont_exp_dt -- 原合同到期日期
    ,init_repay_way_cd -- 原还款方式代码
    ,init_repay_ped_cd -- 原还款周期代码
    ,init_int_rat_float_way_cd -- 原利率浮动方式代码
    ,init_int_rat_adj_way_cd -- 原利率调整方式代码
    ,init_int_rat_float_point -- 原利率浮动点数
    ,init_exec_year_int_rat -- 原执行年利率
    ,to_date('${batch_date}', 'yyyymmdd') as etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
from ${iml_schema}.agt_retl_dubil_renew_appl partition for ('icmsf1')
where 0=1
;

create table ${iml_schema}.agt_retl_dubil_renew_appl_icmsf1_op nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.agt_retl_dubil_renew_appl partition for ('icmsf1') where 0=1;

create table ${iml_schema}.agt_retl_dubil_renew_appl_icmsf1_cl nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.agt_retl_dubil_renew_appl partition for ('icmsf1') where 0=1;

-- 3.1 get new data into table
-- icms_renew_info-1
insert into ${iml_schema}.agt_retl_dubil_renew_appl_icmsf1_tm(
    appl_id -- 申请编号
    ,lp_id -- 法人编号
    ,renew_flow_num -- 展期流水号
    ,rela_dubil_id -- 关联借据编号
    ,obj_id -- 对象编号
    ,obj_type_name -- 对象类型名称
    ,base_rat_type_cd -- 基准利率类型代码
    ,renew_sucs_flg -- 展期成功标志
    ,renew_cont_id -- 展期合同编号
    ,repay_way_cd -- 还款方式代码
    ,repay_ped_cd -- 还款周期代码
    ,effect_dt -- 生效日期
    ,exp_dt -- 到期日期
    ,mon_tenor -- 月期限
    ,base_int_rat -- 基准利率
    ,int_rat_float_point -- 利率浮动点数
    ,int_rat_float_way_cd -- 利率浮动方式代码
    ,loan_exec_year_int_rat -- 执行年利率
    ,ovdue_int_rat_float_way_cd -- 逾期利率浮动方式代码
    ,ovdue_int_rat_fl_rt -- 逾期利率浮动比例
    ,int_rat_adj_way_cd -- 利率调整方式代码
    ,int_rat_adj_ped_cd -- 利率调整周期代码
    ,regroup_loan_flg -- 重组贷款标志
    ,aldy_call_core_intfc_flg -- 已调用核心接口标志
    ,precon_id -- 预约编号
    ,blon_loan_amort_dt -- 气球贷摊销日期
    ,blon_loan_incrs_amt -- 气球贷递增金额
    ,blon_loan_incrs_ratio -- 气球贷递增比例
    ,remark -- 备注
    ,init_cont_exp_dt -- 原合同到期日期
    ,init_repay_way_cd -- 原还款方式代码
    ,init_repay_ped_cd -- 原还款周期代码
    ,init_int_rat_float_way_cd -- 原利率浮动方式代码
    ,init_int_rat_adj_way_cd -- 原利率调整方式代码
    ,init_int_rat_float_point -- 原利率浮动点数
    ,init_exec_year_int_rat -- 原执行年利率
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
)
select
    '206012'||P1.SERIALNO -- 申请编号
    ,'9999' -- 法人编号
    ,P1.SERIALNO -- 展期流水号
    ,P1.DUEBILLSERIALNO -- 关联借据编号
    ,P1.OBJECTNO -- 对象编号
    ,P1.OBJECTTYPE -- 对象类型名称
    ,nvl(trim(P1.BASERATETYPE),'-') -- 基准利率类型代码
    ,case when  P1.EXECSTATUS = 'S' then '1' else '0' end -- 展期成功标志
    ,P1.CONTRACTNO -- 展期合同编号
    ,nvl(trim(P1.NEWREPAYTYPE),'-') -- 还款方式代码
    ,nvl(trim(P1.NEWREPAYCYCLE),'-') -- 还款周期代码
    ,P1.OLDMATURITY -- 生效日期
    ,P1.MATURITY -- 到期日期
    ,P1.TERMMONTH -- 月期限
    ,P1.BASERATE -- 基准利率
    ,P1.FLOATRANGE -- 利率浮动点数
    ,nvl(trim(P1.RATEFLOATTYPE),'-') -- 利率浮动方式代码
    ,P1.EXECUTERATE -- 执行年利率
    ,nvl(trim(P1.OVERDUERATEFLOATTYPE),'-') -- 逾期利率浮动方式代码
    ,P1.OVERDUERATEFLOATVALUE -- 逾期利率浮动比例
    ,nvl(trim(P1.RATEADJUSTTYPE),'-') -- 利率调整方式代码
    ,nvl(trim(P1.RATEADJUSTFREQUENCY),'-') -- 利率调整周期代码
    ,nvl(trim(P1.WHETHERTORESTRUCTURETHELOAN),'-') -- 重组贷款标志
    ,case when  P1.STATUS = 'S' then '1' else '0' end -- 已调用核心接口标志
    ,P1.ORDERNO -- 预约编号
    ,P1.BALLDATE -- 气球贷摊销日期
    ,P1.BAILSUM -- 气球贷递增金额
    ,P1.PDGPAYPERCENT -- 气球贷递增比例
    ,P1.REMARK -- 备注
    ,P1.OLDMATURITY -- 原合同到期日期
    ,nvl(trim(P1.REPAYTYPE),'-') -- 原还款方式代码
    ,nvl(trim(P1.REPAYCYCLE),'-') -- 原还款周期代码
    ,nvl(trim(P1.OLDRATEFLOATTYPE),'-') -- 原利率浮动方式代码
    ,nvl(trim(P1.OLDRATEADJUSTTYPE),'-') -- 原利率调整方式代码
    ,P1.OLDFLOATRANGE -- 原利率浮动点数
    ,P1.OLDEXECUTERATE -- 原执行年利率
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,'icms_renew_info' -- 源表名称
    ,'icmsf1' -- 任务编码
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间戳
from ${iol_schema}.icms_renew_info p1
where p1.start_dt <= to_date('${batch_date}','yyyymmdd') and p1.end_dt > to_date('${batch_date}','yyyymmdd')
;
commit;


commit;

whenever sqlerror exit sql.sqlcode;
declare
cnt integer;
begin
  for cur in (select 1 from dual) loop
  	select count(1) into cnt from (select 1 from ${iml_schema}.agt_retl_dubil_renew_appl_icmsf1_tm 
  	                                group by 
  	                                        appl_id
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
        into ${iml_schema}.agt_retl_dubil_renew_appl_icmsf1_cl(
            appl_id -- 申请编号
    ,lp_id -- 法人编号
    ,renew_flow_num -- 展期流水号
    ,rela_dubil_id -- 关联借据编号
    ,obj_id -- 对象编号
    ,obj_type_name -- 对象类型名称
    ,base_rat_type_cd -- 基准利率类型代码
    ,renew_sucs_flg -- 展期成功标志
    ,renew_cont_id -- 展期合同编号
    ,repay_way_cd -- 还款方式代码
    ,repay_ped_cd -- 还款周期代码
    ,effect_dt -- 生效日期
    ,exp_dt -- 到期日期
    ,mon_tenor -- 月期限
    ,base_int_rat -- 基准利率
    ,int_rat_float_point -- 利率浮动点数
    ,int_rat_float_way_cd -- 利率浮动方式代码
    ,loan_exec_year_int_rat -- 执行年利率
    ,ovdue_int_rat_float_way_cd -- 逾期利率浮动方式代码
    ,ovdue_int_rat_fl_rt -- 逾期利率浮动比例
    ,int_rat_adj_way_cd -- 利率调整方式代码
    ,int_rat_adj_ped_cd -- 利率调整周期代码
    ,regroup_loan_flg -- 重组贷款标志
    ,aldy_call_core_intfc_flg -- 已调用核心接口标志
    ,precon_id -- 预约编号
    ,blon_loan_amort_dt -- 气球贷摊销日期
    ,blon_loan_incrs_amt -- 气球贷递增金额
    ,blon_loan_incrs_ratio -- 气球贷递增比例
    ,remark -- 备注
    ,init_cont_exp_dt -- 原合同到期日期
    ,init_repay_way_cd -- 原还款方式代码
    ,init_repay_ped_cd -- 原还款周期代码
    ,init_int_rat_float_way_cd -- 原利率浮动方式代码
    ,init_int_rat_adj_way_cd -- 原利率调整方式代码
    ,init_int_rat_float_point -- 原利率浮动点数
    ,init_exec_year_int_rat -- 原执行年利率
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iml_schema}.agt_retl_dubil_renew_appl_icmsf1_op(
            appl_id -- 申请编号
    ,lp_id -- 法人编号
    ,renew_flow_num -- 展期流水号
    ,rela_dubil_id -- 关联借据编号
    ,obj_id -- 对象编号
    ,obj_type_name -- 对象类型名称
    ,base_rat_type_cd -- 基准利率类型代码
    ,renew_sucs_flg -- 展期成功标志
    ,renew_cont_id -- 展期合同编号
    ,repay_way_cd -- 还款方式代码
    ,repay_ped_cd -- 还款周期代码
    ,effect_dt -- 生效日期
    ,exp_dt -- 到期日期
    ,mon_tenor -- 月期限
    ,base_int_rat -- 基准利率
    ,int_rat_float_point -- 利率浮动点数
    ,int_rat_float_way_cd -- 利率浮动方式代码
    ,loan_exec_year_int_rat -- 执行年利率
    ,ovdue_int_rat_float_way_cd -- 逾期利率浮动方式代码
    ,ovdue_int_rat_fl_rt -- 逾期利率浮动比例
    ,int_rat_adj_way_cd -- 利率调整方式代码
    ,int_rat_adj_ped_cd -- 利率调整周期代码
    ,regroup_loan_flg -- 重组贷款标志
    ,aldy_call_core_intfc_flg -- 已调用核心接口标志
    ,precon_id -- 预约编号
    ,blon_loan_amort_dt -- 气球贷摊销日期
    ,blon_loan_incrs_amt -- 气球贷递增金额
    ,blon_loan_incrs_ratio -- 气球贷递增比例
    ,remark -- 备注
    ,init_cont_exp_dt -- 原合同到期日期
    ,init_repay_way_cd -- 原还款方式代码
    ,init_repay_ped_cd -- 原还款周期代码
    ,init_int_rat_float_way_cd -- 原利率浮动方式代码
    ,init_int_rat_adj_way_cd -- 原利率调整方式代码
    ,init_int_rat_float_point -- 原利率浮动点数
    ,init_exec_year_int_rat -- 原执行年利率
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.appl_id, o.appl_id) as appl_id -- 申请编号
    ,nvl(n.lp_id, o.lp_id) as lp_id -- 法人编号
    ,nvl(n.renew_flow_num, o.renew_flow_num) as renew_flow_num -- 展期流水号
    ,nvl(n.rela_dubil_id, o.rela_dubil_id) as rela_dubil_id -- 关联借据编号
    ,nvl(n.obj_id, o.obj_id) as obj_id -- 对象编号
    ,nvl(n.obj_type_name, o.obj_type_name) as obj_type_name -- 对象类型名称
    ,nvl(n.base_rat_type_cd, o.base_rat_type_cd) as base_rat_type_cd -- 基准利率类型代码
    ,nvl(n.renew_sucs_flg, o.renew_sucs_flg) as renew_sucs_flg -- 展期成功标志
    ,nvl(n.renew_cont_id, o.renew_cont_id) as renew_cont_id -- 展期合同编号
    ,nvl(n.repay_way_cd, o.repay_way_cd) as repay_way_cd -- 还款方式代码
    ,nvl(n.repay_ped_cd, o.repay_ped_cd) as repay_ped_cd -- 还款周期代码
    ,nvl(n.effect_dt, o.effect_dt) as effect_dt -- 生效日期
    ,nvl(n.exp_dt, o.exp_dt) as exp_dt -- 到期日期
    ,nvl(n.mon_tenor, o.mon_tenor) as mon_tenor -- 月期限
    ,nvl(n.base_int_rat, o.base_int_rat) as base_int_rat -- 基准利率
    ,nvl(n.int_rat_float_point, o.int_rat_float_point) as int_rat_float_point -- 利率浮动点数
    ,nvl(n.int_rat_float_way_cd, o.int_rat_float_way_cd) as int_rat_float_way_cd -- 利率浮动方式代码
    ,nvl(n.loan_exec_year_int_rat, o.loan_exec_year_int_rat) as loan_exec_year_int_rat -- 执行年利率
    ,nvl(n.ovdue_int_rat_float_way_cd, o.ovdue_int_rat_float_way_cd) as ovdue_int_rat_float_way_cd -- 逾期利率浮动方式代码
    ,nvl(n.ovdue_int_rat_fl_rt, o.ovdue_int_rat_fl_rt) as ovdue_int_rat_fl_rt -- 逾期利率浮动比例
    ,nvl(n.int_rat_adj_way_cd, o.int_rat_adj_way_cd) as int_rat_adj_way_cd -- 利率调整方式代码
    ,nvl(n.int_rat_adj_ped_cd, o.int_rat_adj_ped_cd) as int_rat_adj_ped_cd -- 利率调整周期代码
    ,nvl(n.regroup_loan_flg, o.regroup_loan_flg) as regroup_loan_flg -- 重组贷款标志
    ,nvl(n.aldy_call_core_intfc_flg, o.aldy_call_core_intfc_flg) as aldy_call_core_intfc_flg -- 已调用核心接口标志
    ,nvl(n.precon_id, o.precon_id) as precon_id -- 预约编号
    ,nvl(n.blon_loan_amort_dt, o.blon_loan_amort_dt) as blon_loan_amort_dt -- 气球贷摊销日期
    ,nvl(n.blon_loan_incrs_amt, o.blon_loan_incrs_amt) as blon_loan_incrs_amt -- 气球贷递增金额
    ,nvl(n.blon_loan_incrs_ratio, o.blon_loan_incrs_ratio) as blon_loan_incrs_ratio -- 气球贷递增比例
    ,nvl(n.remark, o.remark) as remark -- 备注
    ,nvl(n.init_cont_exp_dt, o.init_cont_exp_dt) as init_cont_exp_dt -- 原合同到期日期
    ,nvl(n.init_repay_way_cd, o.init_repay_way_cd) as init_repay_way_cd -- 原还款方式代码
    ,nvl(n.init_repay_ped_cd, o.init_repay_ped_cd) as init_repay_ped_cd -- 原还款周期代码
    ,nvl(n.init_int_rat_float_way_cd, o.init_int_rat_float_way_cd) as init_int_rat_float_way_cd -- 原利率浮动方式代码
    ,nvl(n.init_int_rat_adj_way_cd, o.init_int_rat_adj_way_cd) as init_int_rat_adj_way_cd -- 原利率调整方式代码
    ,nvl(n.init_int_rat_float_point, o.init_int_rat_float_point) as init_int_rat_float_point -- 原利率浮动点数
    ,nvl(n.init_exec_year_int_rat, o.init_exec_year_int_rat) as init_exec_year_int_rat -- 原执行年利率
    ,case when
            n.appl_id is null
            and n.lp_id is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.appl_id is null
            and n.lp_id is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.appl_id is null
            and n.lp_id is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,nvl(n.src_table_name, o.src_table_name) as src_table_name -- 源表名称
    ,nvl(n.job_cd, o.job_cd) as job_cd -- 任务编码
    ,nvl(n.etl_timestamp, o.etl_timestamp) as etl_timestamp -- ETL处理时间戳
from ${iml_schema}.agt_retl_dubil_renew_appl_icmsf1_tm n
    full join (select * from ${iml_schema}.agt_retl_dubil_renew_appl_icmsf1_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
        on
            o.appl_id = n.appl_id
            and o.lp_id = n.lp_id
where (
        o.appl_id is null
        and o.lp_id is null
    )
    or (
        n.appl_id is null
        and n.lp_id is null
    )
    or (
        o.renew_flow_num <> n.renew_flow_num
        or o.rela_dubil_id <> n.rela_dubil_id
        or o.obj_id <> n.obj_id
        or o.obj_type_name <> n.obj_type_name
        or o.base_rat_type_cd <> n.base_rat_type_cd
        or o.renew_sucs_flg <> n.renew_sucs_flg
        or o.renew_cont_id <> n.renew_cont_id
        or o.repay_way_cd <> n.repay_way_cd
        or o.repay_ped_cd <> n.repay_ped_cd
        or o.effect_dt <> n.effect_dt
        or o.exp_dt <> n.exp_dt
        or o.mon_tenor <> n.mon_tenor
        or o.base_int_rat <> n.base_int_rat
        or o.int_rat_float_point <> n.int_rat_float_point
        or o.int_rat_float_way_cd <> n.int_rat_float_way_cd
        or o.loan_exec_year_int_rat <> n.loan_exec_year_int_rat
        or o.ovdue_int_rat_float_way_cd <> n.ovdue_int_rat_float_way_cd
        or o.ovdue_int_rat_fl_rt <> n.ovdue_int_rat_fl_rt
        or o.int_rat_adj_way_cd <> n.int_rat_adj_way_cd
        or o.int_rat_adj_ped_cd <> n.int_rat_adj_ped_cd
        or o.regroup_loan_flg <> n.regroup_loan_flg
        or o.aldy_call_core_intfc_flg <> n.aldy_call_core_intfc_flg
        or o.precon_id <> n.precon_id
        or o.blon_loan_amort_dt <> n.blon_loan_amort_dt
        or o.blon_loan_incrs_amt <> n.blon_loan_incrs_amt
        or o.blon_loan_incrs_ratio <> n.blon_loan_incrs_ratio
        or o.remark <> n.remark
        or o.init_cont_exp_dt <> n.init_cont_exp_dt
        or o.init_repay_way_cd <> n.init_repay_way_cd
        or o.init_repay_ped_cd <> n.init_repay_ped_cd
        or o.init_int_rat_float_way_cd <> n.init_int_rat_float_way_cd
        or o.init_int_rat_adj_way_cd <> n.init_int_rat_adj_way_cd
        or o.init_int_rat_float_point <> n.init_int_rat_float_point
        or o.init_exec_year_int_rat <> n.init_exec_year_int_rat
    )
;
commit;

-- 3.3 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iml_schema}.agt_retl_dubil_renew_appl_icmsf1_cl(
            appl_id -- 申请编号
    ,lp_id -- 法人编号
    ,renew_flow_num -- 展期流水号
    ,rela_dubil_id -- 关联借据编号
    ,obj_id -- 对象编号
    ,obj_type_name -- 对象类型名称
    ,base_rat_type_cd -- 基准利率类型代码
    ,renew_sucs_flg -- 展期成功标志
    ,renew_cont_id -- 展期合同编号
    ,repay_way_cd -- 还款方式代码
    ,repay_ped_cd -- 还款周期代码
    ,effect_dt -- 生效日期
    ,exp_dt -- 到期日期
    ,mon_tenor -- 月期限
    ,base_int_rat -- 基准利率
    ,int_rat_float_point -- 利率浮动点数
    ,int_rat_float_way_cd -- 利率浮动方式代码
    ,loan_exec_year_int_rat -- 执行年利率
    ,ovdue_int_rat_float_way_cd -- 逾期利率浮动方式代码
    ,ovdue_int_rat_fl_rt -- 逾期利率浮动比例
    ,int_rat_adj_way_cd -- 利率调整方式代码
    ,int_rat_adj_ped_cd -- 利率调整周期代码
    ,regroup_loan_flg -- 重组贷款标志
    ,aldy_call_core_intfc_flg -- 已调用核心接口标志
    ,precon_id -- 预约编号
    ,blon_loan_amort_dt -- 气球贷摊销日期
    ,blon_loan_incrs_amt -- 气球贷递增金额
    ,blon_loan_incrs_ratio -- 气球贷递增比例
    ,remark -- 备注
    ,init_cont_exp_dt -- 原合同到期日期
    ,init_repay_way_cd -- 原还款方式代码
    ,init_repay_ped_cd -- 原还款周期代码
    ,init_int_rat_float_way_cd -- 原利率浮动方式代码
    ,init_int_rat_adj_way_cd -- 原利率调整方式代码
    ,init_int_rat_float_point -- 原利率浮动点数
    ,init_exec_year_int_rat -- 原执行年利率
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iml_schema}.agt_retl_dubil_renew_appl_icmsf1_op(
            appl_id -- 申请编号
    ,lp_id -- 法人编号
    ,renew_flow_num -- 展期流水号
    ,rela_dubil_id -- 关联借据编号
    ,obj_id -- 对象编号
    ,obj_type_name -- 对象类型名称
    ,base_rat_type_cd -- 基准利率类型代码
    ,renew_sucs_flg -- 展期成功标志
    ,renew_cont_id -- 展期合同编号
    ,repay_way_cd -- 还款方式代码
    ,repay_ped_cd -- 还款周期代码
    ,effect_dt -- 生效日期
    ,exp_dt -- 到期日期
    ,mon_tenor -- 月期限
    ,base_int_rat -- 基准利率
    ,int_rat_float_point -- 利率浮动点数
    ,int_rat_float_way_cd -- 利率浮动方式代码
    ,loan_exec_year_int_rat -- 执行年利率
    ,ovdue_int_rat_float_way_cd -- 逾期利率浮动方式代码
    ,ovdue_int_rat_fl_rt -- 逾期利率浮动比例
    ,int_rat_adj_way_cd -- 利率调整方式代码
    ,int_rat_adj_ped_cd -- 利率调整周期代码
    ,regroup_loan_flg -- 重组贷款标志
    ,aldy_call_core_intfc_flg -- 已调用核心接口标志
    ,precon_id -- 预约编号
    ,blon_loan_amort_dt -- 气球贷摊销日期
    ,blon_loan_incrs_amt -- 气球贷递增金额
    ,blon_loan_incrs_ratio -- 气球贷递增比例
    ,remark -- 备注
    ,init_cont_exp_dt -- 原合同到期日期
    ,init_repay_way_cd -- 原还款方式代码
    ,init_repay_ped_cd -- 原还款周期代码
    ,init_int_rat_float_way_cd -- 原利率浮动方式代码
    ,init_int_rat_adj_way_cd -- 原利率调整方式代码
    ,init_int_rat_float_point -- 原利率浮动点数
    ,init_exec_year_int_rat -- 原执行年利率
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.appl_id -- 申请编号
    ,o.lp_id -- 法人编号
    ,o.renew_flow_num -- 展期流水号
    ,o.rela_dubil_id -- 关联借据编号
    ,o.obj_id -- 对象编号
    ,o.obj_type_name -- 对象类型名称
    ,o.base_rat_type_cd -- 基准利率类型代码
    ,o.renew_sucs_flg -- 展期成功标志
    ,o.renew_cont_id -- 展期合同编号
    ,o.repay_way_cd -- 还款方式代码
    ,o.repay_ped_cd -- 还款周期代码
    ,o.effect_dt -- 生效日期
    ,o.exp_dt -- 到期日期
    ,o.mon_tenor -- 月期限
    ,o.base_int_rat -- 基准利率
    ,o.int_rat_float_point -- 利率浮动点数
    ,o.int_rat_float_way_cd -- 利率浮动方式代码
    ,o.loan_exec_year_int_rat -- 执行年利率
    ,o.ovdue_int_rat_float_way_cd -- 逾期利率浮动方式代码
    ,o.ovdue_int_rat_fl_rt -- 逾期利率浮动比例
    ,o.int_rat_adj_way_cd -- 利率调整方式代码
    ,o.int_rat_adj_ped_cd -- 利率调整周期代码
    ,o.regroup_loan_flg -- 重组贷款标志
    ,o.aldy_call_core_intfc_flg -- 已调用核心接口标志
    ,o.precon_id -- 预约编号
    ,o.blon_loan_amort_dt -- 气球贷摊销日期
    ,o.blon_loan_incrs_amt -- 气球贷递增金额
    ,o.blon_loan_incrs_ratio -- 气球贷递增比例
    ,o.remark -- 备注
    ,o.init_cont_exp_dt -- 原合同到期日期
    ,o.init_repay_way_cd -- 原还款方式代码
    ,o.init_repay_ped_cd -- 原还款周期代码
    ,o.init_int_rat_float_way_cd -- 原利率浮动方式代码
    ,o.init_int_rat_adj_way_cd -- 原利率调整方式代码
    ,o.init_int_rat_float_point -- 原利率浮动点数
    ,o.init_exec_year_int_rat -- 原执行年利率
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
from ${iml_schema}.agt_retl_dubil_renew_appl_icmsf1_bk o
    left join ${iml_schema}.agt_retl_dubil_renew_appl_icmsf1_op n
        on
            o.appl_id = n.appl_id
            and o.lp_id = n.lp_id
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iml_schema}.agt_retl_dubil_renew_appl_icmsf1_cl d
        on
            o.appl_id = d.appl_id
            and o.lp_id = d.lp_id
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;
-- 4.1 truncate target table
--truncate table ${iml_schema}.agt_retl_dubil_renew_appl;
--alter table ${iml_schema}.agt_retl_dubil_renew_appl truncate partition for ('icmsf1') reuse storage;

-- 4.2 rebuild partition
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
declare
v_sql varchar2(100);
begin
for cur in (select subpartition_name 
              from all_tab_subpartitions 
             where table_owner=upper('${iml_schema}') 
               and table_name=upper('agt_retl_dubil_renew_appl') 
               and substr(subpartition_name,1,8)=upper('p_icmsf1')
               and substr(subpartition_name,10) >= '${batch_date}' 
               and substr(subpartition_name,10) < '20991231') loop
    v_sql := 'alter table ${iml_schema}.agt_retl_dubil_renew_appl drop subpartition ' || cur.subpartition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/

whenever sqlerror exit sql.sqlcode;
alter table ${iml_schema}.agt_retl_dubil_renew_appl modify partition p_icmsf1 
add subpartition p_icmsf1_${batch_date} values(to_date('${batch_date}','YYYYMMDD')) ;

-- 4.3 exchange partition
alter table ${iml_schema}.agt_retl_dubil_renew_appl exchange subpartition p_icmsf1_${batch_date} with table ${iml_schema}.agt_retl_dubil_renew_appl_icmsf1_cl;
alter table ${iml_schema}.agt_retl_dubil_renew_appl exchange subpartition p_icmsf1_20991231 with table ${iml_schema}.agt_retl_dubil_renew_appl_icmsf1_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iml_schema}.agt_retl_dubil_renew_appl to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iml_schema}.agt_retl_dubil_renew_appl_icmsf1_tm purge;
drop table ${iml_schema}.agt_retl_dubil_renew_appl_icmsf1_op purge;
drop table ${iml_schema}.agt_retl_dubil_renew_appl_icmsf1_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iml_schema}.agt_retl_dubil_renew_appl_icmsf1_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iml_schema}',tabname => 'agt_retl_dubil_renew_appl', partname => 'p_icmsf1_20991231',ESTIMATE_PERCENT=>10, method_opt=>'for all columns size 1',no_invalidate=>false, force=>true, granularity => 'SUBPARTITION', degree => 8, cascade => true);
