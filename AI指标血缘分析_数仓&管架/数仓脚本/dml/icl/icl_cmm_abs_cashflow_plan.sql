/*
purpose:    共性加工层-ABS现金流还款计划，数据主要来源同业系统、资金系统
author:     sunline
usage:      python $ETL_HOME/script/main.py 20210713 icl_cmm_abs_cashflow_plan
createdate: 20210205
logs: 20210703 陈伟峰 新增模型【ABS现金流还款计划】
      20210722 陈伟峰 调整同业系统未来还款计划的加工逻辑
      20211107 何桐金 【agt_secu_acct_accti_bal_h、agt_cap_asset_bal】增加job_cd过滤条件

*/

set timing on
-- 0.1 alter parallel
alter session force parallel query parallel 4;
alter session force parallel dml parallel 4;
-- alter session force parallel ddl parallel 1;

-- 1.1 drop timeout partition and add partition
whenever sqlerror continue none;
--alter table ${icl_schema}.cmm_abs_cashflow_plan drop partition p_${retain_day};
alter table ${icl_schema}.cmm_abs_cashflow_plan add partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

-- 1.2 drop temporary table cmm_abs_cashflow_plan_ex
whenever sqlerror continue none ;
drop table ${icl_schema}.cmm_abs_cashflow_plan_ex purge;

-- 2.1 create temporary table cmm_abs_cashflow_plan_ex
whenever sqlerror exit sql.sqlcode;
create table ${icl_schema}.cmm_abs_cashflow_plan_ex
nologging
compress ${option_switch} for query high
as
select * from ${icl_schema}.cmm_abs_cashflow_plan where 0=1;

-- 2.2 insert into data to temporary table cmm_abs_cashflow_plan_ex

--第一组（共三组）同业未来还款计划

whenever sqlerror exit sql.sqlcode;
insert /*+ append */ into ${icl_schema}.cmm_abs_cashflow_plan_ex(
        etl_dt                          -- 数据日期
        ,lp_id                          -- 法人编号
        ,bond_item_id                   -- 债项编号
        ,rpbl_dt                        -- 应还日期
        ,rpbl_pric                      -- 应还本金
        ,rpbl_int                       -- 应还利息
        ,job_cd                         -- 任务代码
        ,etl_timestamp                  -- 数据处理时间
)
select to_date('${batch_date}','yyyymmdd')           -- 数据日期
       ,t1.lp_id                                     -- 法人编号
       ,t2.obj_id                                    -- 债项编号
       ,t1.pay_dt                                    -- 应还日期
       ,sum(abs(t2.cp*t1.pric_amt))                  -- 应还本金
       ,sum(abs(t2.cp*t1.int_amt))                   -- 应还利息
       ,t1.job_cd                                    -- 任务代码
       ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') -- etl处理时间戳
from ${iml_schema}.prd_ibank_cashflow_dtl_h t1 --iol.tbsi_paymentinfo t1
inner join (select fin_instm_id
                   ,asset_type_id
				           ,market_type_id
                   ,a.intnal_vch_acct_id
                   ,sum(a.actl_qtty) as cp
                   ,max(a.obj_id) as obj_id
             from (select a1.obj_id
			                   ,a1.intnal_vch_acct_id
			                   ,a1.fin_instm_id
			                   ,a1.asset_type_id
			                   ,a1.market_type_id
			                   ,nvl(trim(a1.actl_qtty),0) as actl_qtty
                    from ${iml_schema}.agt_secu_acct_accti_bal_h a1 --   ${iol_schema}.ibms_ttrd_accounting_secu_obj a1   调整依赖
                    left join ${iml_schema}.prd_fin_instm c --ttrd_instrument c
                      on a1.fin_instm_id=c.fin_instm_id
	          		     and a1.asset_type_id=c.asset_type_id
	          		     and a1.market_type_id=c.market_type_id
	          		     and c.create_dt <= to_date('${batch_date}','yyyymmdd')
                     and c.job_cd = 'ibmsf1'
                     and c.id_mark <> 'D'
                   where (c.prod_type_cd is null or c.prod_type_cd<>'2000')
                     and a1.asset_type_id in ('SPT_BD','SPT_CB','SPT_ABS')
                     and a1.start_dt <=to_date('${batch_date}','yyyymmdd')
                     and a1.end_dt >to_date('${batch_date}','yyyymmdd')
                     and a1.job_cd = 'ibmsf1'
                      ) a
             group by a.fin_instm_id,a.asset_type_id,a.market_type_id,a.intnal_vch_acct_id
			      ) t2
   on t1.real_fin_instm_id = t2.fin_instm_id
  and t1.asset_type_id = t2.asset_type_id
  and t1.market_type_id = t2.market_type_id
 left join ${iml_schema}.prd_fin_instm t3--ttrd_instrument t3
   on t1.real_fin_instm_id=t3.fin_instm_id
  and t1.asset_type_id=t3.asset_type_id
  and t1.market_type_id=t3.market_type_id
  and t3.create_dt <= to_date('${batch_date}','yyyymmdd')
  and t3.job_cd = 'ibmsf1'
  and t3.id_mark <> 'D'
where t1.pay_dt> to_date('${batch_date}','yyyymmdd')
  and t1.pay_amt*t2.cp<>0
  and t1.start_dt <=to_date('${batch_date}','yyyymmdd')
  and t1.end_dt >to_date('${batch_date}','yyyymmdd')
  and t1.job_cd='ibmsf1'
  and t3.prod_type_cd = '1100'
group by t1.lp_id,t2.obj_id,t1.pay_dt,t1.job_cd;
commit;


--第二组（共三组）同业历史还款计划

whenever sqlerror exit sql.sqlcode;
insert /*+ append */ into ${icl_schema}.cmm_abs_cashflow_plan_ex(
        etl_dt                          -- 数据日期
        ,lp_id                          -- 法人编号
        ,bond_item_id                   -- 债项编号
        ,rpbl_dt                        -- 应还日期
        ,rpbl_pric                      -- 应还本金
        ,rpbl_int                       -- 应还利息
        ,job_cd                         -- 任务代码
        ,etl_timestamp                  -- 数据处理时间
)
select to_date('${batch_date}','yyyymmdd')       -- 数据日期
       ,t1.lp_id                                 -- 法人编号
       ,t1.accti_obj_id                          -- 债项编号
       ,t1.chg_dt                                -- 应还日期
       ,abs(sum(t2.real_cp))                     -- 应还本金
       ,abs(sum(t2.real_ai))                     -- 应还利息
       ,t1.job_cd                                -- 任务代码
       ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') -- etl处理时间戳
from ${iml_schema}.agt_secu_acct_accti_bal_chg_h  t1 --ttrd_accounting_secu_chg_his t1
left join ${iol_schema}.ibms_ttrd_set_instruction_secu_his t2
  on t1.instr_id = t2.secu_inst_id
left join ${iol_schema}.ibms_ttrd_set_instruction_his t3
  on t3.inst_id = t2.inst_id
left join ${iml_schema}.prd_fin_instm t4 --ttrd_instrument t4
  on t1.fin_instm_id = t4.fin_instm_id
 and t1.asset_type_id=t4.asset_type_id
 and t1.market_type_id=t4.market_type_id
 and t4.prod_type_cd in ('1100')
 and t4.create_dt <= to_date('${batch_date}','yyyymmdd')
 and t4.job_cd = 'ibmsf1'
 and t4.id_mark <> 'D'
where t1.revo_rela_chg_id = '-1'
 and t1.accti_type_cd = 'R'
 and nvl(trim(t2.real_ai),0)+nvl(trim(t2.real_cp),0) <> 0
 and t3.state = '999'
 and t1.start_dt <= to_date('${batch_date}','yyyymmdd')
 and t1.end_dt > to_date('${batch_date}','yyyymmdd')
 and t1.job_cd = 'ibmsf1'
group by t1.lp_id,t1.accti_obj_id,t1.chg_dt,t1.job_cd;
commit;


--第二组（共三组）资金还款计划

whenever sqlerror exit sql.sqlcode;
insert /*+ append */ into ${icl_schema}.cmm_abs_cashflow_plan_ex(
        etl_dt                          -- 数据日期
        ,lp_id                          -- 法人编号
        ,bond_item_id                   -- 债项编号
        ,rpbl_dt                        -- 应还日期
        ,rpbl_pric                      -- 应还本金
        ,rpbl_int                       -- 应还利息
        ,job_cd                         -- 任务代码
        ,etl_timestamp                  -- 数据处理时间
)
select to_date('${batch_date}','yyyymmdd')      -- 数据日期
       ,t1.lp_id                                -- 法人编号
       ,t1.asset_bal_id                         -- 债项编号
       ,t3.pay_dt                               -- 应还日期
       ,t1.hold_pos* t3.pric_amt/10000         -- 应还本金
       ,t1.hold_pos* t3.int_amt/10000          -- 应还利息
       ,t1.job_cd                               -- 任务代码
       ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') -- etl处理时间戳
from ${iml_schema}.agt_cap_asset_bal t1  --TBS_V_BALANCE T1
inner join (select max(asset_bal_id) as asset_bal_id
		               ,b.main_asset_id
		               ,b.minor_asset_id
              from ${iml_schema}.agt_cap_asset_bal b
			       inner join ${iml_schema}.prd_bond_basic_info s --customer.v_security s
			          on b.main_asset_id = s.bond_id
			         and s.bond_type_cd in ('L','L1')
               and s.create_dt <= to_date('${batch_date}','yyyymmdd')
               and s.job_cd = 'ctmsf1'
               and s.id_mark <> 'D'
             where b.bus_cate_name = '现券'
               and b.stl_dt <= to_date('${batch_date}','yyyymmdd')  --持仓日期
               and b.job_cd='ctmsf1'
             group by b.dept_id
			               ,b.bus_cate_name
			               ,b.asset_type_name
			               ,b.main_asset_id
			               ,b.minor_asset_id
			               ,b.acct_b_id
            ) t2
   on t1.asset_bal_id = t2.asset_bal_id
inner join ${iml_schema}.prd_bond_rpp_int_plan t3 --tbs_v_security_pymn_schd t3
   on t1.main_asset_id = t3.bond_id
  and t3.create_dt <= to_date('${batch_date}','yyyymmdd')
  and t3.job_cd = 'ctmsf1'
  and t3.id_mark <> 'D'
where t1.hold_pos >0
  and t1.create_dt <= to_date('${batch_date}','yyyymmdd')
  and t1.job_cd ='ctmsf1';
commit;


-- 2.3 exchage ex table and target table
alter table ${icl_schema}.cmm_abs_cashflow_plan exchange partition p_${batch_date} with table ${icl_schema}.cmm_abs_cashflow_plan_ex;

-- 3.1 drop ex table
drop table ${icl_schema}.cmm_abs_cashflow_plan_ex purge;

-- 3.3 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname=>'${icl_schema}',tabname=>'cmm_abs_cashflow_plan',partname=>'p_${batch_date}',estimate_percent=>10,method_opt=>'for all columns size 1',no_invalidate=>false,granularity=>'partition',cascade=>true,force=>true,degree=>8);
