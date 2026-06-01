/*
Purpose:    共性加工层-联合网贷借据信息
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd icl_cmm_unite_wl_dubil_info_clear
Createdate: 20190814
Logs:       20230210 陈伟峰 年批脚本
            20230518 陈伟峰 适配新一代改造
            20230706 徐子豪 调整第七组-综合信贷微粒贷的业务参数配置表关联方式,【贷款用途代码】取值方式。
            20230911 陈伟峰 新增字段【债权直转标志】加工逻辑，调整网商贷部分【贷款类型代码】加工逻辑
            20230914 陈伟峰 调整网商贷部分字段【开户日期,放款日期,起息日期,原始贷款期数,贷款期数,合同金额,借据金额,放款金额,当前利率生效日期,下次利率调整日期】取数逻辑
            20230922 陈伟峰 新增字段【原始放款日期、原始放款金额】，调整网商贷部分字段【原始贷款期数】加工逻辑
            20230926 徐子豪 新增字段【合同编号】
            20230927 徐子豪 根据M层调整蚂蚁花呗结清数据存放分区,同步修改取值方式为 job_cd in ('myhbf1','myhbf2')
            20250610 陈伟峰 新增字段【入账账户开户银行名称、还款账户开户银行编号、还款账户开户机构名称、人行普惠贷款标志、重组标志、重组贷款类型代码、重组日期、原始到期日期、固收利率】
                            同步更新当前表逻辑
           20251224 陈伟峰 调整微业贷出资比例加工逻辑
           20260114 陈伟峰 调整agt_wyd_dubil_attach_info的担保方式取值逻辑，改为直取guar_way_cd
           20260112 陈伟峰 新增富民联合网贷
           20260225 陈伟峰 调整信贷微粒贷本金逾期天数和利息逾期天数取数规则，从补充表取
           20260326 陈伟峰 调整信贷微粒贷字段【表内欠息余额、表外欠息余额、表内利息、表外利息、正常利息、逾期利息、逾期本金罚息、正常本金、逾期本金、呆滞本金、本金逾期标志、利息逾期标志、本金逾期天数、利息逾期天数、贷款五级分类代码、贷款十级分类代码】加工逻辑，使用新的逾期天数判断
		       20260402 谭钧泽 调整临时表创建规则
		       20260421 陈  凭 调整信贷微粒贷五级分类取数规则，按“本金和利息逾期天数的最大值”判断

*/

set timing on
-- 0.1 alter parallel
alter session force parallel query parallel 4;
alter session force parallel dml parallel 4;
-- alter session force parallel ddl parallel 1;

-- 1.1 drop timeout partition and add partition
whenever sqlerror continue none;
--alter table ${icl_schema}.cmm_unite_wl_dubil_info_clear drop partition p_${retain_day};
alter table ${icl_schema}.cmm_unite_wl_dubil_info_clear add partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

whenever sqlerror continue none;
drop table ${icl_schema}.tmp_cmm_unite_wl_dubil_info_clear_01 purge;
drop table ${icl_schema}.tmp_cmm_unite_wl_dubil_info_clear_02 purge;
drop table ${icl_schema}.tmp_cmm_unite_wl_dubil_info_clear_03 purge;
drop table ${icl_schema}.tmp_cmm_unite_wl_dubil_info_clear_04 purge;
drop table ${icl_schema}.tmp_cmm_unite_wl_dubil_info_clear_05 purge;
drop table ${icl_schema}.tmp_cmm_unite_wl_dubil_info_clear_06 purge;
drop table ${icl_schema}.tmp_cmm_unite_wl_dubil_info_clear_07 purge;
drop table ${icl_schema}.tmp_cmm_unite_wl_dubil_info_clear_08 purge;
drop table ${icl_schema}.tmp_cmm_unite_wl_dubil_info_clear_10 purge;
drop table ${icl_schema}.tmp_cmm_unite_wl_dubil_info_clear_11 purge;
drop table ${icl_schema}.tmp_cmm_unite_wl_dubil_info_clear_12 purge;
drop table ${icl_schema}.tmp_cmm_unite_wl_dubil_info_clear_13 purge;
drop table ${icl_schema}.tmp_cmm_unite_wl_dubil_info_clear_14 purge;
--drop table ${icl_schema}.tmp_cmm_unite_wl_dubil_info_clear_15 purge;
--drop table ${icl_schema}.tmp_cmm_unite_wl_dubil_info_clear_20 purge;
--drop table ${icl_schema}.tmp_cmm_unite_wl_dubil_info_clear_21 purge;
--drop table ${icl_schema}.tmp_cmm_unite_wl_dubil_info_clear_22 purge;
--drop table ${icl_schema}.tmp_cmm_unite_wl_dubil_info_clear_23 purge;
--drop table ${icl_schema}.tmp_cmm_unite_wl_dubil_info_clear_24 purge;
drop table ${icl_schema}.tmp_cmm_unite_wl_dubil_info_clear_25 purge;
drop table ${icl_schema}.tmp_cmm_unite_wl_dubil_info_clear_88 purge;
drop table ${icl_schema}.tmp_cmm_unite_wl_dubil_info_clear_26 purge;
drop table ${icl_schema}.tmp_cmm_unite_wl_dubil_info_clear_27 purge;
drop table ${icl_schema}.tmp_cmm_unite_wl_dubil_info_clear_28 purge;
drop table ${icl_schema}.tmp_cmm_unite_wl_dubil_info_clear_29 purge;
drop table ${icl_schema}.tmp_cmm_unite_wl_dubil_info_clear_30 purge;
drop table ${icl_schema}.tmp_cmm_unite_wl_dubil_info_clear_31 purge;
drop table ${icl_schema}.tmp_cmm_unite_wl_dubil_info_clear_32 purge;
drop table ${icl_schema}.tmp_cmm_unite_wl_dubil_info_clear_33 purge;


whenever sqlerror exit sql.sqlcode;
create table ${icl_schema}.tmp_cmm_unite_wl_dubil_info_clear_01
nologging
compress ${option_switch} for query high
as
select t1.dubil_id,
       sum(nvl(t1.paid_tot_amt, 0)) as paid_amt, -- 已偿还金额
       sum(nvl(t1.paid_nomal_pric, 0)) as paid_normal_prin, -- 已偿还正常本金
       sum(nvl(t1.paid_ovdue_pric, 0)) as paid_ovdue_prin, -- 已偿还逾期本金
       sum(nvl(t1.paid_nomal_int, 0)) as paid_normal_int, -- 已偿还正常利息
       sum(nvl(t1.paid_ovdue_int, 0)) as paid_ovdue_int, -- 已偿还逾期利息
       sum(nvl(t1.paid_ovdue_pric_pnlt, 0)) as paid_ovdue_prin_pnlt, -- 已偿还逾期本金罚息
       sum(nvl(t1.paid_ovdue_int_pnlt, 0)) as paid_ovdue_int_pnlt, -- 已偿还逾期利息罚息
       sum(nvl(t1.repay_plat_serv_fee, 0)) as paid_cost, -- 已偿还费用
       max(repay_dt) as last_repay_dt -- 上次还款日期
  from ${iml_schema}.evt_acp_repay_dtl t1
 where trunc(t1.repay_dt) <= to_date('${batch_date}','yyyymmdd')
  and t1.job_cd = 'myhbi1'
 group by t1.dubil_id
;
commit;

 whenever sqlerror exit sql.sqlcode;
create table ${icl_schema}.tmp_cmm_unite_wl_dubil_info_clear_02
nologging
compress ${option_switch} for query high
as
select hb1.dubil_id,
       (case when min(hb1.pric_turn_ovdue_dt) = to_date('29991231','yyyymmdd') then null else min(hb1.pric_turn_ovdue_dt) end) as prin_earliest_ovdue_dt, -- 首次本金逾期日期
       (case when min(hb1.int_turn_ovdue_dt) = to_date('29991231','yyyymmdd') then null else min(hb1.int_turn_ovdue_dt) end) as int_earliest_ovdue_dt,   -- 首次利息逾期日期
         case /*when max(hb1.pric_ovdue_days) = '0' then 0*/
              when min(hb1.pric_turn_ovdue_dt) = date'2999-12-31' then 0
              /*when to_date('${batch_date}','yyyymmdd') - trunc(min(hb1.pric_turn_ovdue_dt)) - max(hb1.pric_ovdue_days) <> 0 then max(hb1.pric_ovdue_days)*/
         else to_date('${batch_date}','yyyymmdd') - trunc(min(hb1.pric_turn_ovdue_dt))+1 end as prin_ovdue_days, -- 本金逾期天数
         case /*when max(hb1.int_ovdue_days) = '0' then 0*/
              when min(hb1.int_turn_ovdue_dt) =  date'2999-12-31' then 0
              /*when to_date('${batch_date}','yyyymmdd') - trunc(min(hb1.pric_turn_ovdue_dt)) - max(hb1.int_ovdue_days) <> 0 then max(hb1.int_ovdue_days)*/
         else to_date('${batch_date}','yyyymmdd') - trunc(min(hb1.int_turn_ovdue_dt)) +1 end as int_ovdue_days        -- 利息逾期天数
    from ${iml_schema}.agt_acp_repay_plan_h hb1
   where hb1.start_dt <= to_date('${batch_date}','yyyymmdd')
     and hb1.end_dt > to_date('${batch_date}','yyyymmdd')
     and hb1.inst_status_cd = 'OVD'
     and hb1.job_cd = 'myhbf1'
   group by hb1.dubil_id
;
commit;


whenever sqlerror exit sql.sqlcode;
create table ${icl_schema}.tmp_cmm_unite_wl_dubil_info_clear_03
nologging
compress ${option_switch} for query high
as
select dubil_id,
        sum(nvl(paid_tot_amt, 0))    as paid_amt,                  -- 已偿还金额
        sum(nvl(paid_nomal_pric, 0)) as paid_normal_prin,           -- 已偿还正常本金
        sum(nvl(paid_ovdue_pric, 0)) as paid_ovdue_prin,            -- 已偿还逾期本金
        sum(nvl(paid_nomal_int, 0))  as paid_normal_int,             -- 已偿还逾期本金
        sum(nvl(paid_ovdue_int, 0))  as paid_ovdue_int,              -- 已偿还逾期利息
        sum(nvl(paid_ovdue_pric_pnlt, 0)) as paid_ovdue_prin_pnlt,  -- 已偿还逾期本金罚息
        sum(nvl(paid_ovdue_int_pnlt, 0)) as paid_ovdue_int_pnlt,    -- 已偿还逾期利息罚息
        sum(nvl(plat_serv_fee_amt, 0)) as paid_cost,                -- 已偿还费用
        max(repay_dt) as last_repay_dt                              -- 上次还款日期
   from ${iml_schema}.evt_ajb_repay_dtl_flow
  where job_cd = 'myjbi2'
    and trunc(repay_dt) <= to_date('${batch_date}','yyyymmdd')
  group by dubil_id
;
commit;

whenever sqlerror exit sql.sqlcode;
create table ${icl_schema}.tmp_cmm_unite_wl_dubil_info_clear_04
nologging
compress ${option_switch} for query high
as
select   jb1.agt_id,
         (case when min(jb1.pric_turn_ovdue_dt) = to_date('29991231','yyyymmdd') then null else min(jb1.pric_turn_ovdue_dt) end) as prin_earliest_ovdue_dt, -- 首次本金逾期日期
         (case when min(jb1.int_turn_ovdue_dt)  = to_date('29991231','yyyymmdd') then null else min(jb1.int_turn_ovdue_dt) end) as int_earliest_ovdue_dt,   -- 首次利息逾期日期
         case /*when max(jb1.pric_ovdue_days) = '0' then 0*/
              when min(jb1.pric_turn_ovdue_dt) = date'2999-12-31' then 0
              /*when to_date('${batch_date}','yyyymmdd') - trunc(min(jb1.pric_turn_ovdue_dt)) - max(jb1.pric_ovdue_days) <> 0 then max(jb1.pric_ovdue_days)*/
         else to_date('${batch_date}','yyyymmdd') - trunc(min(jb1.pric_turn_ovdue_dt))+1 end as prin_ovdue_days, --本金逾期天数
         case /*when max(jb1.int_ovdue_days) = '0' then 0*/
              when min(jb1.int_turn_ovdue_dt) =  date'2999-12-31' then 0
              /*when to_date('${batch_date}','yyyymmdd') - trunc(min(jb1.int_turn_ovdue_dt)) - max(jb1.int_ovdue_days) <> 0 then max(jb1.int_ovdue_days)*/
         else to_date('${batch_date}','yyyymmdd') - trunc(min(jb1.int_turn_ovdue_dt)) +1 end as int_ovdue_days   --利息逾期天数
    from ${iml_schema}.agt_ajb_repay_plan_h jb1
where jb1.job_cd = 'myjbf2'
    and jb1.start_dt <= to_date('${batch_date}','yyyymmdd')
    and jb1.end_dt >to_date('${batch_date}','yyyymmdd')
    and jb1.inst_status_cd = 'OVD'
   group by jb1.agt_id;
commit;

whenever sqlerror exit sql.sqlcode;
create table ${icl_schema}.tmp_cmm_unite_wl_dubil_info_clear_05
nologging
compress ${option_switch} for query high
as
select dubil_id,
        sum(nvl(rpbl_tot_amt, 0)) as paid_amt, -- 已偿还金额
        sum(nvl(paid_nomal_pric, 0)) as paid_normal_prin, -- 已偿还正常本金
        sum(nvl(paid_ovdue_pric, 0)) as paid_ovdue_prin,  -- 已偿还逾期本金
        sum(nvl(paid_nomal_int, 0)) as paid_normal_int,   -- 已偿还正常本金利息
        sum(nvl(paid_ovdue_int, 0)) as paid_ovdue_int,    -- 已偿还逾期本金利息
        sum(nvl(paid_ovdue_pric_pnlt, 0)) as paid_ovdue_prin_pnlt, -- 已偿还逾期本金罚息
        sum(nvl(paid_ovdue_int_pnlt, 0)) as paid_ovdue_int_pnlt, -- 已偿还逾期利息罚息
        0 as paid_cost, -- 已偿还费用
        max(repay_dt) as last_repay_dt -- 上次还款日期
   from ${iml_schema}.evt_myloan_repay_dtl
  where job_cd = 'mybki1'
    and trunc(repay_dt) <= to_date('${batch_date}','yyyymmdd')
  group by dubil_id
;
commit;

whenever sqlerror exit sql.sqlcode;
create table ${icl_schema}.tmp_cmm_unite_wl_dubil_info_clear_06
nologging
compress ${option_switch} for query high
as
select bk1.agt_id,
        (case when min(bk1.pric_turn_ovdue_dt) = to_date('29991231','yyyymmdd') then null else min(bk1.pric_turn_ovdue_dt) end)  as prin_earliest_ovdue_dt,                                                  -- 首次本金逾期日期
        (case when min(bk1.int_turn_ovdue_dt)  = to_date('29991231','yyyymmdd') then null else min(bk1.int_turn_ovdue_dt)  end)   as int_earliest_ovdue_dt ,                                                  -- 首次利息逾期日期
         case /*when max(bk1.pric_ovdue_days) = '0' then 0*/
              when min(bk1.pric_turn_ovdue_dt) = date'2999-12-31' then 0
              /*when to_date('${batch_date}','yyyymmdd') - trunc(min(bk1.pric_turn_ovdue_dt)) - max(bk1.pric_ovdue_days) <> 0 then max(bk1.pric_ovdue_days)*/
         else to_date('${batch_date}','yyyymmdd') - trunc(min(bk1.pric_turn_ovdue_dt))+1 end as prin_ovdue_days, -- 本金逾期天数
         case /*when max(bk1.int_ovdue_days) = '0' then 0*/
              when min(bk1.int_turn_ovdue_dt) =  date'2999-12-31' then 0
              /*when to_date('${batch_date}','yyyymmdd') - trunc(min(bk1.pric_turn_ovdue_dt)) - max(bk1.int_ovdue_days) <> 0 then max(bk1.int_ovdue_days)*/
         else to_date('${batch_date}','yyyymmdd') - trunc(min(bk1.int_turn_ovdue_dt)) +1 end as int_ovdue_days   -- 利息逾期天数
    from ${iml_schema}.agt_myloan_repay_plan_h bk1
    where bk1.job_cd = 'mybkf1'
      and bk1.start_dt <= to_date('${batch_date}','yyyymmdd')
      and bk1.end_dt >　to_date('${batch_date}','yyyymmdd')
      and bk1.inst_status_cd = 'OVD'
    group by bk1.agt_id;
commit;

create table ${icl_schema}.tmp_cmm_unite_wl_dubil_info_clear_26
as
--网商贷
select t2.cust_id as cust_id,
       greatest(nvl((to_date('${batch_date}','yyyymmdd') - trunc(min(t1.pric_turn_ovdue_dt))+1 ),0) ,
               nvl((to_date('${batch_date}','yyyymmdd') -trunc(min(t1.int_turn_ovdue_dt))+1 ),0) ) as max_ovd_day,  -- 最大逾期天数
       case when (greatest(nvl((to_date('${batch_date}','yyyymmdd') - trunc(min(t1.pric_turn_ovdue_dt))+1 ),0) ,
                           nvl((to_date('${batch_date}','yyyymmdd') - trunc(min(t1.int_turn_ovdue_dt))+1 ),0) )) >=90
            then '1' else '0' end as cust_ovdue_flag   --逾期超过90天标志
      ,t1.job_cd as job_cd
 from ${iml_schema}.agt_myloan_repay_plan_h t1
inner join ${iml_schema}.agt_myloan_dubil t2
  on t1.dubil_id=t2.dubil_id
 and t2.create_dt<=to_date('${batch_date}','yyyymmdd')
 and t2.job_cd ='mybkf1'
 and t2.id_mark<>'D'
left join ${iml_schema}.agt_imp_dt_h t3
  on t3.agt_id = t1.agt_id
 and t3.dt_type_cd = '03'
 and t3.start_dt <= to_date('${batch_date}', 'yyyymmdd')
 and t3.end_dt > to_date('${batch_date}', 'yyyymmdd')
 and t3.job_cd = 'mybkf1'
where t3.imp_dt >= trunc(to_date('${batch_date}', 'yyyymmdd'), 'yyyy')
 and t1.inst_status_cd = 'OVD'
 and t1.start_dt <= to_date('${batch_date}','yyyymmdd')
 and t1.end_dt > to_date('${batch_date}','yyyymmdd')
 and t1.job_cd ='mybkf1'
group by t2.cust_id,t1.job_cd
;
commit;

create table ${icl_schema}.tmp_cmm_unite_wl_dubil_info_clear_07
nologging
compress ${option_switch} for query high
as
select
   agt_id
   ,max(case when bal_type_cd = '005007' then bal end) as ovd_prin_bal      --逾期本金余额
   ,max(case when bal_type_cd = '005006' then bal end) as prin_bal          --正常本金余额
   ,max(case when bal_type_cd = '006001' then bal end) as int_bal           --正常利息余额
   ,max(case when bal_type_cd = '006002' then bal end) as ovd_int_bal       --逾期利息余额
   ,max(case when bal_type_cd = '006003' then bal end) as ovd_prin_pnlt_bal --逾期本金罚息余额
   ,max(case when bal_type_cd = '006004' then bal end) as ovd_int_pnlt_bal  --逾期利息罚息余额
from ${iml_schema}.agt_bal_h
where start_dt <= to_date('${batch_date}','yyyymmdd')
and end_dt > to_date('${batch_date}','yyyymmdd')
and job_cd in('myhbf1','myjbf2','myjbf3','mybkf1')
--and job_cd = 'rcrsf1'
group by agt_id
;


-- 1.5 insert data to temp table
create table ${icl_schema}.tmp_cmm_unite_wl_dubil_info_clear_08
nologging
compress ${option_switch} for query high
as select
    agt_id
    ,lp_id
    ,intnal_dubil_id
    ,repay_plan_id
    ,acct_id
    ,acct_type_cd
    ,card_no
    ,loan_tot_perds
    ,curr_perds
    ,loan_pric
    ,rpbl_pric
    ,rpbl_fee_amt
    ,rpbl_int
    ,repaid_pric
    ,repaid_int
    ,repaid_pnlt
    ,repaid_comp_int
    ,repaid_fee
    ,reach_money_exp_repay_dt
    ,grace_dt
    ,modif_tm
    ,value_dt
    ,batch_doc_name
    ,ser_num
    ,repay_plan_oper_act_cd
from ${iml_schema}.agt_wld_repay_plan
where create_dt <= to_date('${batch_date}','yyyymmdd')
and id_mark<>'D'
and job_cd ='mpcsf1'
union all
select
    agt_id
    ,lp_id
    ,intnal_dubil_id
    ,repay_plan_id
    ,acct_id
    ,acct_type_cd
    ,card_no
    ,loan_tot_perds
    ,curr_perds
    ,loan_pric
    ,rpbl_pric
    ,rpbl_fee_amt
    ,rpbl_int
    ,repaid_pric
    ,repaid_int
    ,repaid_pnlt
    ,repaid_comp_int
    ,repaid_fee
    ,reach_money_exp_repay_dt
    ,grace_dt
    ,modif_tm
    ,value_dt
    ,batch_doc_name
    ,ser_num
    ,repay_plan_oper_act_cd
from ${iml_schema}.agt_wld_repay_plan_his
where id_mark<>'D'
and job_cd ='mpcsi1'
;


--M层给最大值DATEFORMAT_MAX，取结清数据，需要剔除最大值dateformat_max，同时结清日期小于当年
create table ${icl_schema}.tmp_cmm_unite_wl_dubil_info_clear_27
nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.agt_acp_dubil t1
where t1.payoff_dt < trunc(to_date('${batch_date}', 'yyyymmdd'), 'yyyy')
  and t1.create_dt <= to_date('${batch_date}', 'yyyymmdd')
  and t1.job_cd in ('myhbf1','myhbf2')
;

--M层给最大值dateformat_max，取结清数据，需要剔除最大值dateformat_max，同时结清日期小于当年
create table ${icl_schema}.tmp_cmm_unite_wl_dubil_info_clear_28
nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.agt_ajb_dubil t1
 where t1.payoff_dt < trunc(to_date('${batch_date}', 'yyyymmdd'), 'yyyy')  --肯定小于dateformat_max
   and t1.create_dt <= to_date('${batch_date}', 'yyyymmdd')
   and t1.job_cd = 'myjbf2'
   and t1.id_mark <> 'D'
;

--M层给最大值dateformat_max，取结清数据，需要剔除最大值dateformat_max，同时结清日期小于当年
create table ${icl_schema}.tmp_cmm_unite_wl_dubil_info_clear_29
nologging
compress ${option_switch} for query high
as
select t1.*
  from ${iml_schema}.agt_myloan_dubil t1
 left join ${iml_schema}.agt_imp_dt_h t18
   on t18.agt_id = t1.agt_id
   and t18.dt_type_cd = '03'
   and t18.start_dt <= to_date('${batch_date}', 'yyyymmdd')
   and t18.end_dt > to_date('${batch_date}', 'yyyymmdd')
   and t18.job_cd = 'mybkf1'
 where t18.imp_dt < trunc(to_date('${batch_date}', 'yyyymmdd'), 'yyyy')  --肯定小于dateformat_max
   and t1.create_dt <= to_date('${batch_date}', 'yyyymmdd')
   and t1.job_cd = 'mybkf1'
   and t1.id_mark <> 'D'
;

--M层给最大值20991231，取结清数据，需要剔除20991231，同时结清日期小于当年
create table ${icl_schema}.tmp_cmm_unite_wl_dubil_info_clear_30
nologging
compress ${option_switch} for query high
as
select t1.* from ${iml_schema}.agt_wld_dubil_info t1
   left join ${iml_schema}.agt_imp_dt_h t18
     on t1.agt_id = t18.agt_id
    and t18.dt_type_cd = '03'
    and t18.start_dt <= to_date('${batch_date}', 'yyyymmdd')
    and t18.end_dt > to_date('${batch_date}', 'yyyymmdd')
    and t18.job_cd = 'mpcsf1'
where t18.imp_dt < trunc(to_date('${batch_date}', 'yyyymmdd'), 'yyyy')  --肯定小于20991231
    and t1.create_dt <= to_date('${batch_date}', 'yyyymmdd')
    and t1.job_cd = 'mpcsf1'
    and t1.id_mark <> 'D'
;

--O层无默认值，M层给最大值99991231，取结清数据，需要剔除99991231，同时结清日期小于当年
create table ${icl_schema}.tmp_cmm_unite_wl_dubil_info_clear_31
nologging
compress ${option_switch} for query high
as
select t1.* from ${iml_schema}.agt_ajb_ped_3_dubil t1
    left join ${iml_schema}.agt_imp_dt_h t11
      on t11.agt_id = t1.agt_id
     and t11.dt_type_cd = '03'
     and t11.start_dt <= to_date('${batch_date}', 'yyyymmdd')
     and t11.end_dt > to_date('${batch_date}', 'yyyymmdd')
     and t11.job_cd = 'myjbf3'
where t11.imp_dt < trunc(to_date('${batch_date}', 'yyyymmdd'), 'yyyy')  --肯定小于99991231
 and t1.create_dt <= to_date('${batch_date}', 'yyyymmdd')
 and t1.job_cd = 'myjbf3'
 and t1.id_mark <> 'D'
;

--O层给默认值00010101，M层无默认值，取结清数据，需要剔除00010101，同时结清日期小于当年
create table ${icl_schema}.tmp_cmm_unite_wl_dubil_info_clear_33
nologging
compress ${option_switch} for query high
as select t1.*
     from ${iml_schema}.agt_wld_dubil_info_h t1
    where t1.payoff_dt < trunc(to_date('${batch_date}', 'yyyymmdd'), 'yyyy')
      and t1.payoff_dt <> ${iml_schema}.dateformat_min('')
      and t1.start_dt <= to_date('${batch_date}', 'yyyymmdd')
      and t1.end_dt > to_date('${batch_date}', 'yyyymmdd')
      and t1.job_cd ='icmsf1'
;

whenever sqlerror continue none;
drop table ${icl_schema}.cmm_unite_wl_dubil_info_clear_ex purge;

-- 2.1 insert into ex table
create table ${icl_schema}.cmm_unite_wl_dubil_info_clear_ex
nologging
compress ${option_switch} for query high
as select * from ${icl_schema}.cmm_unite_wl_dubil_info_clear where 0=1
;
commit;

-- 第一组（共九组）花呗
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ into ${icl_schema}.cmm_unite_wl_dubil_info_clear_ex(
   etl_dt                                 --数据日期
   ,lp_id                                 --法人编号
   ,dubil_id                              --借据编号
   ,core_dubil_id                         --核心借据编号
   ,cont_id                               --合同编号
   ,std_prod_id                           --标准产品编号
   ,prod_id                               --产品编号
   ,cust_id                               --客户编号
   ,subj_id                               --科目编号
   ,acctnt_cate_cd                        --会计类别代码
   ,enter_acct_acct_num                   --入账账号
   ,repay_num                             --还款账号
   ,rela_agt_id                           --关联协议编号
   ,rela_appl_flow_num                    --关联申请流水号
   ,curr_cd                               --币种代码
   ,bus_breed_id                          --业务品种编号
   ,loan_type_cd                          --贷款类型代码
   ,intnal_loan_type_cd                    --行内贷款类型代码
   ,asset_thd_cls_cd                      --资产三分类
   ,dubil_status_cd                       --借据状态代码
   ,loan_usage_cd                         --贷款用途代码
   ,dir_indus_cd                          --贷款贷款贷款投向行业代码
   ,cont_status_cd                        --合同状态代码
   ,loan_level4_cls_cd                    --贷款四级分类代码
   ,loan_level5_cls_cd                    --贷款五级分类代码
   ,loan_level10_cls_cd                   --贷款十级分类代码
   ,loan_level12_cls_cd                   --贷款十二级分类代码
   ,acru_non_acru_cd                      --应计非应计代码
   ,repay_way_cd                          --还款方式代码
   ,int_set_way_cd                        --结息方式代码
   ,int_accr_way_cd                       --计息方式代码
   ,int_rat_adj_way_cd                    --利率调整方式代码
   ,int_rat_adj_ped_corp_cd               --利率调整周期单位代码
   ,int_rat_adj_ped_freq                  --利率调整周期频率
   ,int_rat_base_type_cd                  --利率基准类型代码
   ,int_rat_float_way_cd                  --利率浮动方式代码
   ,int_rat_float_dir_cd                  --利率浮动方向代码
   ,int_rat_flo_val                       --利率浮动值
   ,pric_repay_freq_cd                    --本金还款周期频率
   ,int_repay_freq_cd                     --利息还款周期频率
   ,guar_way_cd                           --担保方式代码
   ,cust_char_cd                          --客户性质代码
   ,enter_acct_acct_num_type              --入账账号类型
   ,enter_acct_bank_name                  --入账账户开户银行名称
   ,repay_num_type                        --还款账号类型
   ,repay_open_acct_bank_id               --还款账户开户银行编号
   ,repay_open_acct_org_name              --还款账户开户机构名称
   ,intnal_carr_flg                       --内部结转标志
   ,dom_overs_flg                         --境内外标志
   ,white_list_cust_flg                   --白户标志
   ,farm_flg                              --农户标志
   ,agclt_flg                             --涉农标志
   ,int_accr_flg                          --计息标志
   ,comp_int_flg                          --复息标志
   ,ovdue_flg                             --逾期标志
   ,wrt_off_flg                           --核销标志
   ,pbc_inc_loan_flg                      --人行普惠贷款标志
   ,cred_rht_turn_flg                     --债权直转标志
   ,regroup_flg                           --重组标志
   ,regroup_loan_type_cd                  --重组贷款类型代码
   ,regroup_dt                            --重组日期
   ,open_acct_dt                          --开户日期
   ,distr_dt                              --放款日期
   ,init_distr_dt                         --原始放款日期
   ,value_dt                              --起息日期
   ,exp_dt                                --到期日期
   ,init_exp_dt                           --原始到期日期
   ,payoff_dt                             --结清日期
   ,last_repay_dt                         --上次还款日期
   ,next_repay_dt                         --下次还款日期
   ,curr_int_rat_effect_dt                --当前利率生效日期
   ,next_int_rat_adj_dt                   --下次利率调整日期
   ,cust_mgr_id                           --客户经理编号
   ,open_acct_org_id                      --开户机构编号
   ,mgmt_org_id                           --管理机构编号
   ,acct_instit_id                        --账务机构编号
   ,init_tot_perds                        --原始贷款期数
   ,tot_perds                             --贷款期数
   ,curr_issue_perds                      --当前期数
   ,surp_perds                            --剩余期数
   ,ovdue_perds                           --逾期期数
   ,pric_ovdue_days                       --本金逾期天数
   ,int_ovdue_days                        --利息逾期天数
   ,grace_period_days                     --宽限期天数
   ,inst_comm_fee_rat                     --分期手续费费率
   ,base_rat                              --基准利率
   ,exec_int_rat                          --执行利率
   ,ovdue_int_rat                         --逾期利率
   ,daily_exec_int_rat                    --每日执行利率
   ,int_rat                               --固收利率
   ,cont_amt                              --合同金额
   ,dubil_amt                             --借据金额
   ,distr_amt                             --放款金额
   ,init_distr_amt                        --原始放款金额
   ,bank_contri_ratio                     --银行出资比例
   ,td_acru_int                           --当日应计利息
   ,currt_acru_int                        --当期应计利息
   ,nomal_pric                            --正常本金
   ,ovdue_pric                            --逾期本金
   ,idle_pric                             --呆滞本金
   ,bad_debt_pric                         --呆账本金
   ,wrt_off_pric                          --核销本金
   ,nomal_int                             --正常利息
   ,ovdue_int                             --逾期利息
   ,wrt_off_int                           --核销利息
   ,ovdue_pric_pnlt                       --逾期本金罚息
   ,ovdue_int_pnlt                        --逾期利息罚息
   ,recvbl_over_int                       --应收欠息
   ,recvbl_acru_pnlt                      --应收应计罚息
   ,recvbl_pnlt                           --应收罚息
   ,recvbl_fee                            --应收费用
   ,in_bs_over_int_bal                    --表内欠息余额
   ,off_bs_over_int_bal                   --表外欠息余额
   ,in_bs_int                             --表内利息
   ,off_bs_int                            --表外利息
   ,acm_recvbl_uncol_int_amt              --累计应收未收利息金额
   ,repaid_nomal_pric                     --已偿还正常本金
   ,repaid_ovdue_pric                     --已偿还逾期本金
   ,repaid_nomal_int                      --已偿还正常利息
   ,repaid_ovdue_int                      --已偿还逾期利息
   ,repaid_ovdue_pric_pnlt                --已偿还逾期本金罚息
   ,repaid_ovdue_int_pnlt                 --已偿还逾期利息罚息
   ,repaid_fee                            --已偿还费用
   ,pric_bal                              --本金余额
   ,currt_bal                             --当期余额
   ,cl_curr_currt_bal                     --折本币当期余额
   ,job_cd                                --任务代码
   ,etl_timestamp                         --etl处理时间戳
)
select
   to_date('${batch_date}','yyyymmdd')                                               -- 数据日期
   ,t1.lp_id                                                                           -- 法人编号
   ,t1.dubil_id                                                                        -- 借据编号
   ,t1.dubil_id                                                                        -- 核心借据编号
   ,''                                                                                 -- 合同编号
   ,t14.prod_id                                                                        -- 标准产品编号
   ,t14.prod_id                                                                        -- 产品编号
   ,t1.cust_id                                                                         -- 客户编号
   ,'13030203'                                                                         -- 科目编号
   ,''                                                                                 -- 会计类别代码
   ,nvl(trim(t1.recvbl_acct_id),t1.recvbl_num)                                       -- 入账账号
   ,nvl(trim(t1.repay_acct_id),t1.repay_num)                                         -- 还款账号
   ,t1.crdt_appl_id                                                                    -- 关联协议编号
   ,t1.crdt_appl_id                                                                    -- 关联申请流水号
   ,t1.curr_cd                                                                         -- 币种代码
   ,'02001004135021'                                                                   -- 业务品种编号
   ,t1.dubil_type_cd                                                                   -- 贷款类型代码
   ,''                    --行内贷款类型代码
   ,t33.agt_status_cd                                                                  -- 资产三分类代码
   ,nvl(t10.agt_status_cd,t1.loan_status_cd)                                          -- 借据状态代码
   ,t1.loan_usage_cd                                                                   -- 贷款用途代码
   ,'F'                                                                                -- 贷款贷款贷款投向行业代码
   ,nvl(t16.agt_status_cd, t1.cont_status_cd)                                         -- 合同状态代码
   ,'00'                                                                               -- 贷款四级分类代码
    ,(case when greatest((case when decode(nvl(t16.agt_status_cd, t1.cont_status_cd), 'OVD', '1', '0') = '1' then nvl(t6.prin_ovdue_days,0) else 0  end)
                        ,(case when decode(nvl(t16.agt_status_cd, t1.cont_status_cd), 'OVD', '1', '0') = '1' then nvl(t6.int_ovdue_days,0)  else 0  end)) = 0 then '10'
           when greatest((case when decode(nvl(t16.agt_status_cd, t1.cont_status_cd), 'OVD', '1', '0') = '1' then nvl(t6.prin_ovdue_days,0) else 0  end)
                        ,(case when decode(nvl(t16.agt_status_cd, t1.cont_status_cd), 'OVD', '1', '0') = '1' then nvl(t6.int_ovdue_days,0)  else 0  end)) >= 1
            and greatest((case when decode(nvl(t16.agt_status_cd, t1.cont_status_cd), 'OVD', '1', '0') = '1' then nvl(t6.prin_ovdue_days,0) else 0  end)
                        ,(case when decode(nvl(t16.agt_status_cd, t1.cont_status_cd), 'OVD', '1', '0') = '1' then nvl(t6.int_ovdue_days,0)  else 0  end)) <=89  then '20'
           when greatest((case when decode(nvl(t16.agt_status_cd, t1.cont_status_cd), 'OVD', '1', '0') = '1' then nvl(t6.prin_ovdue_days,0) else 0  end)
                        ,(case when decode(nvl(t16.agt_status_cd, t1.cont_status_cd), 'OVD', '1', '0') = '1' then nvl(t6.int_ovdue_days,0)  else 0  end)) >= 90
            and greatest((case when decode(nvl(t16.agt_status_cd, t1.cont_status_cd), 'OVD', '1', '0') = '1' then nvl(t6.prin_ovdue_days,0) else 0  end)
                        ,(case when decode(nvl(t16.agt_status_cd, t1.cont_status_cd), 'OVD', '1', '0') = '1' then nvl(t6.int_ovdue_days,0)  else 0  end)) <=120 then '30'
           when greatest((case when decode(nvl(t16.agt_status_cd, t1.cont_status_cd), 'OVD', '1', '0') = '1' then nvl(t6.prin_ovdue_days,0) else 0  end)
                        ,(case when decode(nvl(t16.agt_status_cd, t1.cont_status_cd), 'OVD', '1', '0') = '1' then nvl(t6.int_ovdue_days,0)  else 0  end))>= 121
            and greatest((case when decode(nvl(t16.agt_status_cd, t1.cont_status_cd), 'OVD', '1', '0') = '1' then nvl(t6.prin_ovdue_days,0) else 0  end)
                        ,(case when decode(nvl(t16.agt_status_cd, t1.cont_status_cd), 'OVD', '1', '0') = '1' then nvl(t6.int_ovdue_days,0)  else 0  end)) <=180 then '40'
           when greatest((case when decode(nvl(t16.agt_status_cd, t1.cont_status_cd), 'OVD', '1', '0') = '1' then nvl(t6.prin_ovdue_days,0) else 0  end)
                        ,(case when decode(nvl(t16.agt_status_cd, t1.cont_status_cd), 'OVD', '1', '0') = '1' then nvl(t6.int_ovdue_days,0)  else 0  end)) >= 181 then '50'end) as loan_level5_cls_cd              --贷款五级分类代码
   ,(case when greatest((case when decode(nvl(t16.agt_status_cd, t1.cont_status_cd), 'OVD', '1', '0') = '1' then nvl(t6.prin_ovdue_days,0) else 0  end)
                        ,(case when decode(nvl(t16.agt_status_cd, t1.cont_status_cd), 'OVD', '1', '0') = '1' then nvl(t6.int_ovdue_days,0)  else 0  end)) = 0 then '15'
          when greatest((case when decode(nvl(t16.agt_status_cd, t1.cont_status_cd), 'OVD', '1', '0') = '1' then nvl(t6.prin_ovdue_days,0) else 0  end)
                        ,(case when decode(nvl(t16.agt_status_cd, t1.cont_status_cd), 'OVD', '1', '0') = '1' then nvl(t6.int_ovdue_days,0)  else 0  end)) >= 1
           and greatest((case when decode(nvl(t16.agt_status_cd, t1.cont_status_cd), 'OVD', '1', '0') = '1' then nvl(t6.prin_ovdue_days,0) else 0  end)
                        ,(case when decode(nvl(t16.agt_status_cd, t1.cont_status_cd), 'OVD', '1', '0') = '1' then nvl(t6.int_ovdue_days,0)  else 0  end)) <=59 then  '21'
          when greatest((case when decode(nvl(t16.agt_status_cd, t1.cont_status_cd), 'OVD', '1', '0') = '1' then nvl(t6.prin_ovdue_days,0) else 0  end)
                        ,(case when decode(nvl(t16.agt_status_cd, t1.cont_status_cd), 'OVD', '1', '0') = '1' then nvl(t6.int_ovdue_days,0)  else 0  end)) >= 60
           and greatest((case when decode(nvl(t16.agt_status_cd, t1.cont_status_cd), 'OVD', '1', '0') = '1' then nvl(t6.prin_ovdue_days,0) else 0  end)
                        ,(case when decode(nvl(t16.agt_status_cd, t1.cont_status_cd), 'OVD', '1', '0') = '1' then nvl(t6.int_ovdue_days,0)  else 0  end)) <=89 then  '22'
          when greatest((case when decode(nvl(t16.agt_status_cd, t1.cont_status_cd), 'OVD', '1', '0') = '1' then nvl(t6.prin_ovdue_days,0) else 0  end)
                        ,(case when decode(nvl(t16.agt_status_cd, t1.cont_status_cd), 'OVD', '1', '0') = '1' then nvl(t6.int_ovdue_days,0)  else 0  end)) >= 90
           and greatest((case when decode(nvl(t16.agt_status_cd, t1.cont_status_cd), 'OVD', '1', '0') = '1' then nvl(t6.prin_ovdue_days,0) else 0  end)
                        ,(case when decode(nvl(t16.agt_status_cd, t1.cont_status_cd), 'OVD', '1', '0') = '1' then nvl(t6.int_ovdue_days,0)  else 0  end)) <=120 then '30'
          when greatest((case when decode(nvl(t16.agt_status_cd, t1.cont_status_cd), 'OVD', '1', '0') = '1' then nvl(t6.prin_ovdue_days,0) else 0  end)
                        ,(case when decode(nvl(t16.agt_status_cd, t1.cont_status_cd), 'OVD', '1', '0') = '1' then nvl(t6.int_ovdue_days,0)  else 0  end))>= 121
           and greatest((case when decode(nvl(t16.agt_status_cd, t1.cont_status_cd), 'OVD', '1', '0') = '1' then nvl(t6.prin_ovdue_days,0) else 0  end)
                        ,(case when decode(nvl(t16.agt_status_cd, t1.cont_status_cd), 'OVD', '1', '0') = '1' then nvl(t6.int_ovdue_days,0)  else 0  end)) <=180 then'40'
          when greatest((case when decode(nvl(t16.agt_status_cd, t1.cont_status_cd), 'OVD', '1', '0') = '1' then nvl(t6.prin_ovdue_days,0) else 0  end)
                        ,(case when decode(nvl(t16.agt_status_cd, t1.cont_status_cd), 'OVD', '1', '0') = '1' then nvl(t6.int_ovdue_days,0)  else 0  end)) >= 181 then '50'else '90' end ) as loan_level10_cls_cd  --贷款十级分类代码
   ,'11'                                                                                   --贷款十二级分类代码
   ,nvl(trim(t1.acru_non_acru_flg),'0')                                                  --应计非应计代码
   ,nvl(trim(t1.repay_way_cd),'-')                                                       --还款方式代码
   ,'08'                                                                                   --结息方式代码
   ,'AB'                                                                                   --计息方式代码
   ,t1.int_rat_adj_way_cd                                                                  --利率调整方式代码
   ,t1.int_rat_adj_ped_corp_cd                                                             --利率调整周期单位代码
   ,case when t1.src_int_rat_type_cd = 'L4' then 6 when t1.src_int_rat_type_cd in ('L0', 'L1', 'L2', 'L3', 'L5') then 1 else 0 end  -- 利率调整周期频率
   ,t1.base_rat_type_cd                                                                    --利率基准类型代码
   ,case when t1.base_rat_type_cd='2231' then '1' else '-' end                         --利率浮动方式代码
   ,t1.int_rat_float_dir_cd                                                                --利率浮动方向代码
   ,case when t1.base_rat_type_cd='2231' then t8.int_rat_float_point else 0 end       --利率浮动值
   ,t1.pric_repay_freq_cd                                                                  --本金还款频率代码
   ,t1.int_repay_freq_cd                                                                   --利息还款频率代码
   ,t1.guar_type_cd                                                                        --担保方式代码
   ,'-'                                                                                    --客户性质代码
   ,t1.recvbl_num_type_cd                                                                  --入账账号类型
   ,''                                                                                     --入账账户开户银行名称
   ,t1.repay_num_type_cd                                                                   --还款账号类型
   ,''                                                                                     --还款账户开户银行编号
   ,''                                                                                     --还款账户开户机构名称
   ,decode(t1.intnal_carr_flg, 'Y', '1', '0')                                            --内部结转标志
   ,nvl(trim(t1.loan_cap_use_position_cd), '0')                                          --境内外标志
   ,t1.white_list_cust_flg                                                                 --白户标志
   ,'-'                                                                                    --农户标志
   ,'-'                                                                                    --涉农标志
   ,'1'                                                                                    --计息标志
   ,'0'                                                                                    --复息标志
   ,decode(nvl(t16.agt_status_cd, t1.cont_status_cd), 'OVD', '1', '0')                  --逾期标志
   ,decode(t17.agt_status_cd,'Y','1','0')                                                --核销标志
   ,''                                                                                     --人行普惠贷款标志
   ,'0'                                                                                    --债权直转标志
   ,''                                                                                     --重组标志
   ,''                                                                                     --重组贷款类型代码
   ,''                                                                                     --重组日期
   ,t1.distr_dt                                                                            --开户日期
   ,t1.distr_dt                                                                            --放款日期
   ,t1.distr_dt                                                                            --原始放款日期
   ,t1.loan_value_dt                                                                       --起息日期
   ,t1.loan_exp_dt                                                                         --到期日期
   ,t1.loan_exp_dt                                                                         --原始到期日期
   ,nvl(t1.payoff_dt, t1.loan_exp_dt)                                                     --结清日期
   ,nvl(trim(t4.last_repay_dt), t1.loan_value_dt)                                        --上次还款日期
   ,t15.imp_dt                                                                             --下次还款日期
   ,t1.distr_dt                                                                            --当前利率生效日期
   ,t1.distr_dt                                                                            --下次利率调整日期
   ,t30.cust_mgr_id                                                                        --客户经理编号
   ,'897001'                                                                               --开户机构编号
   ,'897001'                                                                               --管理机构编号
   ,'897001'                                                                               --账务机构编号
   ,t1.loan_cont_tenor                                                                     --原始贷款期数
   ,t1.loan_cont_tenor                                                                     --贷款期数
   ,nvl(t1.loan_cont_tenor, 0) - nvl(t1.unpayoff_perds, 0)                               --当前期数
   ,t1.unpayoff_perds                                                                      --剩余期数
   ,t1.ovdue_pd_cnt                                                                        --逾期期数
   ,case when decode(nvl(t16.agt_status_cd, t1.cont_status_cd), 'OVD', '1', '0') = '1' then nvl(t6.prin_ovdue_days,0) else 0  end      --本金逾期天数
   ,case when decode(nvl(t16.agt_status_cd, t1.cont_status_cd), 'OVD', '1', '0') = '1' then nvl(t6.int_ovdue_days,0)  else 0  end      --利息逾期天数
   ,t1.grace_period_days                                                                   --宽限期天数
   ,t1.inst_tot_comm_fee_rat                                                               --分期手续费费率
   ,nvl(t8.base_int_rat, 0)                                                               --基准利率
   ,nvl(t8.exec_int_rat, 0)                                                               --执行利率
   ,nvl(t8.exec_int_rat, 0) * 1.5                                                         --逾期利率
   ,nvl(t1.loan_actl_day_int_rat, 0)                                                      --每日执行利率
   ,0                                                                                      --固收利率
   ,nvl(t1.loan_init_pric, 0)                                                             --合同金额
   ,nvl(t1.loan_init_pric, 0)                                                             --借据金额
   ,nvl(t25.amt, 0)                                                                       --放款金额
   ,nvl(t25.amt, 0)                                                                       --原始放款金额
   ,0.9                                                                                    --银行出资比例
   ,(nvl(t3.nomal_int_amt, 0) + nvl(t3.ovdue_pric_pnlt, 0) + nvl(t3.ovdue_int_pnlt, 0))    --当日应计利息
   ,(nvl(t9.int_bal,0) + nvl(t9.ovd_int_bal,0))                                            --当期应计利息
   ,case when decode(t17.agt_status_cd,'Y','1','0') = '0' then nvl(t9.prin_bal,0) else 0 end --正常本金
   ,case when nvl(t1.acru_non_acru_flg,'1') = '0' and decode(t17.agt_status_cd,'Y','1','0') = '0' then nvl(t9.ovd_prin_bal,0) else 0 end  --逾期本金
   ,case when nvl(trim(t1.acru_non_acru_flg),'0') = '1' and decode(t17.agt_status_cd,'Y','1','0') = '0' then nvl(t9.ovd_prin_bal,0) else 0 end  --呆滞本金
   ,0                                                                                      --呆账本金
   ,case when decode(t17.agt_status_cd,'Y','1','0') = '1' then nvl(t9.prin_bal,0) + nvl(t9.ovd_prin_bal,0) else 0 end --核销本金
   ,nvl(t9.int_bal,0)                                                                      --正常利息
   ,nvl(t9.ovd_int_bal,0)                                                                  --逾期利息
   ,case when decode(t17.agt_status_cd,'Y','1','0') = '1' then (nvl(t9.int_bal,0) + nvl(t9.ovd_int_bal,0) + nvl(t9.ovd_prin_pnlt_bal,0) + nvl(t9.ovd_int_pnlt_bal,0)) else 0 end --核销利息
   ,nvl(t9.ovd_prin_pnlt_bal,0)                                                            --逾期本金罚息
   ,nvl(t9.ovd_int_pnlt_bal,0)                                                             --逾期利息罚息
   ,(nvl(t9.int_bal,0) + nvl(t9.ovd_int_bal,0))                                           --应收欠息
   ,nvl(t9.ovd_int_bal,0)                                                                  --应收应计罚息
   ,(nvl(t9.ovd_prin_pnlt_bal,0) + nvl(t9.ovd_int_pnlt_bal,0))                            --应收罚息
   ,nvl(t1.inst_tot_comm_fee_rat, 0) * nvl(t1.loan_init_pric, 0)                          --应收费用
   ,case when greatest(to_number(nvl(trim(t6.prin_ovdue_days),0)),to_number(nvl(trim(t6.int_ovdue_days),0))) < 90 then
           (nvl(t9.int_bal,0) + nvl(t9.ovd_int_bal,0))
         else 0
    end                                                                                    --表内欠息余额
   ,case when greatest(to_number(nvl(trim(t6.prin_ovdue_days),0)),to_number(nvl(trim(t6.int_ovdue_days),0))) >= 90 then
           (nvl(t9.int_bal,0) + nvl(t9.ovd_int_bal,0))
         else 0
    end                                                                                    --表外欠息余额
   ,case when greatest(to_number(nvl(trim(t6.prin_ovdue_days),0)),to_number(nvl(trim(t6.int_ovdue_days),0))) < 90 then
           (nvl(t9.int_bal,0) + nvl(t9.ovd_int_bal,0) + nvl(t9.ovd_prin_pnlt_bal,0) + nvl(t9.ovd_int_pnlt_bal,0))
         else 0
    end                      --表内利息
   ,case when greatest(to_number(nvl(trim(t6.prin_ovdue_days),0)),to_number(nvl(trim(t6.int_ovdue_days),0))) >= 90 then
           (nvl(t9.int_bal,0) + nvl(t9.ovd_int_bal,0) + nvl(t9.ovd_prin_pnlt_bal,0) + nvl(t9.ovd_int_pnlt_bal,0))
         else 0
    end                                                                                    --表外利息
   ,case when greatest(to_number(nvl(trim(t6.prin_ovdue_days),0)),to_number(nvl(trim(t6.int_ovdue_days),0))) >= 90 then
           (nvl(t9.int_bal,0) + nvl(t9.ovd_int_bal,0) + nvl(t9.ovd_prin_pnlt_bal,0) + nvl(t9.ovd_int_pnlt_bal,0))
         else 0
    end                                                                                    --累计应收未收利息金额
   ,nvl(t4.paid_normal_prin,0)                                                             --已偿还正常本金
   ,nvl(t4.paid_ovdue_prin,0)                                                              --已偿还逾期本金
   ,nvl(t4.paid_normal_int,0)                                                              --已偿还正常利息
   ,nvl(t4.paid_ovdue_int,0)                                                               --已偿还逾期利息
   ,nvl(t4.paid_ovdue_prin_pnlt,0)                                                         --已偿还逾期本金罚息
   ,nvl(t4.paid_ovdue_int_pnlt,0)                                                          --已偿还逾期利息罚息
   ,nvl(t4.paid_cost,0)                                                                    --已偿还费用
   ,nvl(t9.prin_bal,0) + nvl(t9.ovd_prin_bal,0)                                           --本金余额
   ,nvl(t9.prin_bal,0) + nvl(t9.ovd_prin_bal,0)                                           --当期余额
   ,(nvl(t9.prin_bal,0) + nvl(t9.ovd_prin_bal,0)) * nvl(t7.convt_cny_exch_rat, 1)       --折本币当期余额
   ,t1.job_cd                                                                               --任务代码
   ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6')                         --etl处理时间戳
from ${icl_schema}.tmp_cmm_unite_wl_dubil_info_clear_27 t1
  left join ${iml_schema}.agt_int_rat_h t8
    on t8.agt_id = t1.agt_id
    and t8.int_rat_type_cd = '003001'
    and t8.start_dt <= to_date('${batch_date}', 'yyyymmdd')
    and t8.end_dt > to_date('${batch_date}', 'yyyymmdd')
    and t8.job_cd = 'myhbf1'
  left join ${icl_schema}.tmp_cmm_unite_wl_dubil_info_clear_07 t9
    on t1.agt_id = t9.agt_id
  left join ${iml_schema}.agt_status_h t10
    on t10.agt_id = t1.agt_id
    and t10.agt_status_type_cd = 'CD1261'
    and t10.start_dt <= to_date('${batch_date}', 'yyyymmdd')
     and t10.end_dt > to_date('${batch_date}', 'yyyymmdd')
     and t10.job_cd = 'myhbf1'
    left join ${iml_schema}.agt_status_h t33
    on t33.agt_id = t1.agt_id
    and t33.agt_status_type_cd = 'CD2060'
    and t33.start_dt <= to_date('${batch_date}', 'yyyymmdd')
     and t33.end_dt > to_date('${batch_date}', 'yyyymmdd')
     and t33.job_cd = 'myhbf1'
   left join ${iml_schema}.agt_acp_int_provi_dtl t3
      on t1.agt_id = t3.agt_id
     and t3.etl_dt = to_date('${batch_date}', 'yyyymmdd')
     and t3.acru_non_acru_idf = '0'
     and t3.int_accr_dt = to_date('${batch_date}','yyyymmdd')
     and t3.job_cd = 'myhbi1'
   left join ${icl_schema}.tmp_cmm_unite_wl_dubil_info_clear_01 t4
     on t1.dubil_id = t4.dubil_id
   left join ${icl_schema}.tmp_cmm_unite_wl_dubil_info_clear_02 t6
      on t1.dubil_id = t6.dubil_id
   left join ${iml_schema}.ref_cny_fori_exch_mdl_p_h t7
      on t1.curr_cd = t7.curr_cd
     --and t7.dt = to_date('${batch_date}', 'yyyymmdd')
     and t7.start_dt <= to_date('${batch_date}', 'yyyymmdd')
     and t7.end_dt > to_date('${batch_date}', 'yyyymmdd')
--     and t7.id_mark <> 'D'
     and t7.job_cd = 'ncbsf1'
   left join ${iml_schema}.agt_prod_rela_h t14
      on t1.agt_id = t14.agt_id
     and t14.start_dt <= to_date('${batch_date}','yyyymmdd')
     and t14.end_dt > to_date('${batch_date}','yyyymmdd')
     and t14.job_cd ='myhbf1'
    left join ${iml_schema}.agt_imp_dt_h t15
     on t15.agt_id = t1.agt_id
    and t15.dt_type_cd = '05'
    and t15.start_dt <= to_date('${batch_date}', 'yyyymmdd')
     and t15.end_dt > to_date('${batch_date}', 'yyyymmdd')
     and t15.job_cd = 'myhbf1'
    left join ${iml_schema}.agt_status_h t16
     on t16.agt_id = t1.agt_id
    and t16.agt_status_type_cd = 'CD1278'
    and t16.start_dt <= to_date('${batch_date}', 'yyyymmdd')
     and t16.end_dt > to_date('${batch_date}', 'yyyymmdd')
     and t16.job_cd = 'myhbf1'
    left join ${iml_schema}.agt_status_h t17
     on t17.agt_id = t1.agt_id
    and t17.agt_status_type_cd = 'CD1102'
    and t17.start_dt <= to_date('${batch_date}', 'yyyymmdd')
     and t17.end_dt > to_date('${batch_date}', 'yyyymmdd')
     and t17.job_cd = 'myhbf1'
    left join  ${iml_schema}.agt_amt_h t25
      on t1.agt_id = t25.agt_id
     and t25.amt_type_cd= '001005'
     and t25.start_dt <= to_date('${batch_date}', 'yyyymmdd')
     and t25.end_dt > to_date('${batch_date}', 'yyyymmdd')
--     and t25.id_mark <> 'D'
     and t25.job_cd = 'myhbf1'
   left join ${iml_schema}.prd_prod_cust_mgr_rela_h t30
     on t30.prod_id = '202010100003'  -- 蚂蚁花呗联合贷款客户经理
    and t30.start_dt <= to_date('${batch_date}','yyyymmdd')
    and t30.end_dt > to_date('${batch_date}','yyyymmdd')
    and t30.job_cd = 'icmsf1'
where 1=1
;
commit;

-- 第二组（共九组）借呗
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ into ${icl_schema}.cmm_unite_wl_dubil_info_clear_ex(
   etl_dt                                 --数据日期
   ,lp_id                                 --法人编号
   ,dubil_id                              --借据编号
   ,core_dubil_id                         --核心借据编号
   ,cont_id                               --合同编号
   ,std_prod_id                           --标准产品编号
   ,prod_id                               --产品编号
   ,cust_id                               --客户编号
   ,subj_id                               --科目编号
   ,acctnt_cate_cd                        --会计类别代码
   ,enter_acct_acct_num                   --入账账号
   ,repay_num                             --还款账号
   ,rela_agt_id                           --关联协议编号
   ,rela_appl_flow_num                    --关联申请流水号
   ,curr_cd                               --币种代码
   ,bus_breed_id                          --业务品种编号
   ,loan_type_cd                          --贷款类型代码
   ,intnal_loan_type_cd                    --行内贷款类型代码
   ,asset_thd_cls_cd                      --资产三分类
   ,dubil_status_cd                       --借据状态代码
   ,loan_usage_cd                         --贷款用途代码
   ,dir_indus_cd                          --贷款贷款贷款投向行业代码
   ,cont_status_cd                        --合同状态代码
   ,loan_level4_cls_cd                    --贷款四级分类代码
   ,loan_level5_cls_cd                    --贷款五级分类代码
   ,loan_level10_cls_cd                   --贷款十级分类代码
   ,loan_level12_cls_cd                   --贷款十二级分类代码
   ,acru_non_acru_cd                      --应计非应计代码
   ,repay_way_cd                          --还款方式代码
   ,int_set_way_cd                        --结息方式代码
   ,int_accr_way_cd                       --计息方式代码
   ,int_rat_adj_way_cd                    --利率调整方式代码
   ,int_rat_adj_ped_corp_cd               --利率调整周期单位代码
   ,int_rat_adj_ped_freq                  --利率调整周期频率
   ,int_rat_base_type_cd                  --利率基准类型代码
   ,int_rat_float_way_cd                  --利率浮动方式代码
   ,int_rat_float_dir_cd                  --利率浮动方向代码
   ,int_rat_flo_val                       --利率浮动值
   ,pric_repay_freq_cd                    --本金还款周期频率
   ,int_repay_freq_cd                     --利息还款周期频率
   ,guar_way_cd                           --担保方式代码
   ,cust_char_cd                          --客户性质代码
   ,enter_acct_acct_num_type              --入账账号类型
   ,enter_acct_bank_name                  --入账账户开户银行名称
   ,repay_num_type                        --还款账号类型
   ,repay_open_acct_bank_id               --还款账户开户银行编号
   ,repay_open_acct_org_name              --还款账户开户机构名称
   ,intnal_carr_flg                       --内部结转标志
   ,dom_overs_flg                         --境内外标志
   ,white_list_cust_flg                   --白户标志
   ,farm_flg                              --农户标志
   ,agclt_flg                             --涉农标志
   ,int_accr_flg                          --计息标志
   ,comp_int_flg                          --复息标志
   ,ovdue_flg                             --逾期标志
   ,wrt_off_flg                           --核销标志
   ,pbc_inc_loan_flg                      --人行普惠贷款标志
   ,cred_rht_turn_flg                     --债权直转标志
   ,regroup_flg                           --重组标志
   ,regroup_loan_type_cd                  --重组贷款类型代码
   ,regroup_dt                            --重组日期
   ,open_acct_dt                          --开户日期
   ,distr_dt                              --放款日期
   ,init_distr_dt                         --原始放款日期
   ,value_dt                              --起息日期
   ,exp_dt                                --到期日期
   ,init_exp_dt                           --原始到期日期
   ,payoff_dt                             --结清日期
   ,last_repay_dt                         --上次还款日期
   ,next_repay_dt                         --下次还款日期
   ,curr_int_rat_effect_dt                --当前利率生效日期
   ,next_int_rat_adj_dt                   --下次利率调整日期
   ,cust_mgr_id                           --客户经理编号
   ,open_acct_org_id                      --开户机构编号
   ,mgmt_org_id                           --管理机构编号
   ,acct_instit_id                        --账务机构编号
   ,init_tot_perds                        --原始贷款期数
   ,tot_perds                             --贷款期数
   ,curr_issue_perds                      --当前期数
   ,surp_perds                            --剩余期数
   ,ovdue_perds                           --逾期期数
   ,pric_ovdue_days                       --本金逾期天数
   ,int_ovdue_days                        --利息逾期天数
   ,grace_period_days                     --宽限期天数
   ,inst_comm_fee_rat                     --分期手续费费率
   ,base_rat                              --基准利率
   ,exec_int_rat                          --执行利率
   ,ovdue_int_rat                         --逾期利率
   ,daily_exec_int_rat                    --每日执行利率
   ,int_rat                               --固收利率
   ,cont_amt                              --合同金额
   ,dubil_amt                             --借据金额
   ,distr_amt                             --放款金额
   ,init_distr_amt                        --原始放款金额
   ,bank_contri_ratio                     --银行出资比例
   ,td_acru_int                           --当日应计利息
   ,currt_acru_int                        --当期应计利息
   ,nomal_pric                            --正常本金
   ,ovdue_pric                            --逾期本金
   ,idle_pric                             --呆滞本金
   ,bad_debt_pric                         --呆账本金
   ,wrt_off_pric                          --核销本金
   ,nomal_int                             --正常利息
   ,ovdue_int                             --逾期利息
   ,wrt_off_int                           --核销利息
   ,ovdue_pric_pnlt                       --逾期本金罚息
   ,ovdue_int_pnlt                        --逾期利息罚息
   ,recvbl_over_int                       --应收欠息
   ,recvbl_acru_pnlt                      --应收应计罚息
   ,recvbl_pnlt                           --应收罚息
   ,recvbl_fee                            --应收费用
   ,in_bs_over_int_bal                    --表内欠息余额
   ,off_bs_over_int_bal                   --表外欠息余额
   ,in_bs_int                             --表内利息
   ,off_bs_int                            --表外利息
   ,acm_recvbl_uncol_int_amt              --累计应收未收利息金额
   ,repaid_nomal_pric                     --已偿还正常本金
   ,repaid_ovdue_pric                     --已偿还逾期本金
   ,repaid_nomal_int                      --已偿还正常利息
   ,repaid_ovdue_int                      --已偿还逾期利息
   ,repaid_ovdue_pric_pnlt                --已偿还逾期本金罚息
   ,repaid_ovdue_int_pnlt                 --已偿还逾期利息罚息
   ,repaid_fee                            --已偿还费用
   ,pric_bal                              --本金余额
   ,currt_bal                             --当期余额
   ,cl_curr_currt_bal                     --折本币当期余额
   ,job_cd                                --任务代码
   ,etl_timestamp                         --etl处理时间戳
)
select
    to_date('${batch_date}','yyyymmdd')                                                                --数据日期
    ,t1.lp_id                                                                                          --法人编号
    ,t1.dubil_id                                                                                      --借据编号
    ,t1.dubil_id                                                                                     -- 核心借据编号
    ,''                                                                                                --合同编号
    ,t16.prod_id                                                                                       --标准产品编号
    ,t16.prod_id                                                                                       --产品编号
    ,t1.cust_id                                                                                        --客户编号
    ,'13030203'                                                                                        --科目编号
    ,''                                                                                                --会计类别代码
    ,t1.recvbl_acct_id                                                                                --入账账号
    ,t1.repay_acct_id                                                                                  --还款账号
    ,t8.rela_agt_id                                                                                    --关联协议编号
    ,t8.rela_agt_id                                                                               --关联申请流水号
    ,nvl(t1.curr_cd, 'CNY')                                                                            --币种代码
    ,'02001004120222'                                                                                  --业务品种编号
    ,'00'                                                                                              --贷款类型代码
   ,''                    --行内贷款类型代码
    ,t33.agt_status_cd                                                                                 --资产三分类代码
    ,nvl(t12.agt_status_cd,t1.loan_status_cd)                                                          --借据状态代码
    ,t1.loan_usage_cd                                                                                  --贷款用途代码
    ,'F'                                                                                              --贷款贷款贷款投向行业代码
    ,nvl(t17.agt_status_cd, t1.cont_status_cd)                                                        --合同状态代码
    ,'00'                                                                                              --贷款四级分类代码
    ,(case when greatest(nvl(t5.prin_ovdue_days,0),nvl(t5.int_ovdue_days,0)) =0 then '10'
           when greatest(nvl(t5.prin_ovdue_days,0),nvl(t5.int_ovdue_days,0)) >=1 and greatest(nvl(t5.prin_ovdue_days,0),nvl(t5.int_ovdue_days,0))<=89 then '20'
           when greatest(nvl(t5.prin_ovdue_days,0),nvl(t5.int_ovdue_days,0)) >=90 and greatest(nvl(t5.prin_ovdue_days,0),nvl(t5.int_ovdue_days,0))<=120 then '30'
           when greatest(nvl(t5.prin_ovdue_days,0),nvl(t5.int_ovdue_days,0))>=121 and greatest(nvl(t5.prin_ovdue_days,0),nvl(t5.int_ovdue_days,0))<=180 then '40'
           when greatest(nvl(t5.prin_ovdue_days,0),nvl(t5.int_ovdue_days,0)) >=181 then '50' end) as loan_level5_cls_cd              --贷款五级分类代码
    ,(case when greatest(nvl(t5.prin_ovdue_days,0),nvl(t5.int_ovdue_days,0)) =0 then '15'
           when greatest(nvl(t5.prin_ovdue_days,0),nvl(t5.int_ovdue_days,0)) >= 1 and greatest(nvl(t5.prin_ovdue_days,0),nvl(t5.int_ovdue_days,0)) <=59 then '21'
           when greatest(nvl(t5.prin_ovdue_days,0),nvl(t5.int_ovdue_days,0)) >= 60 and greatest(nvl(t5.prin_ovdue_days,0),nvl(t5.int_ovdue_days,0)) <=89 then '22'
           when greatest(nvl(t5.prin_ovdue_days,0),nvl(t5.int_ovdue_days,0)) >= 90 and greatest(nvl(t5.prin_ovdue_days,0),nvl(t5.int_ovdue_days,0))<=120 then '30'
           when greatest(nvl(t5.prin_ovdue_days,0),nvl(t5.int_ovdue_days,0))>= 121 and greatest(nvl(t5.prin_ovdue_days,0),nvl(t5.int_ovdue_days,0)) <=180 then '40'
           when greatest(nvl(t5.prin_ovdue_days,0),nvl(t5.int_ovdue_days,0)) >= 181 then '50' else '90' end ) as loan_level10_cls_cd     --贷款十级分类代码
    ,'11'                                                                                              --贷款十二级分类代码
    ,nvl(trim(t1.acru_non_acru_flg),'0')                                                              --应计非应计代码
    ,nvl(trim(t1.repay_way_cd),'-')                                                                                  --还款方式代码
    ,'08'                                                                                              --结息方式代码
    ,'AB'                                                                                              --计息方式代码
    ,t1.int_rat_adj_way_cd                                                                            --利率调整方式代码
    ,t1.int_rat_adj_ped_corp_cd                                                                        --利率调整周期单位代码
    ,t1.int_rat_adj_ped_freq                                                                           --利率调整周期频率
    ,t1.base_rat_type_cd                                                                              --利率基准类型代码
    ,case when t1.base_rat_type_cd='2231' then '1' else '-' end                                        --利率浮动方式代码
    ,t1.int_rat_float_dir_cd                                                                           --利率浮动方向代码
    ,t9.int_rat_float_point                                                                            --利率浮动值
    ,t1.pric_repay_freq_cd                                                                            --本金还款周期频率
    ,t1.int_repay_freq_cd                                                                              --利息还款周期频率
    ,t1.guar_type_cd                                                                                  --担保方式代码
    ,'-'                                                                                                 --客户性质代码
    ,t1.recvbl_num_type_cd                                                                            --入账账号类型
    ,''                                                                                                --入账账户开户银行名称
    ,t1.repay_num_type_cd                                                                              --还款账号类型
    ,''                                                                                                 --还款账户开户银行编号
    ,''                                                                                                 --还款账户开户机构名称
    ,'0'                                                                                              --内部结转标志
    ,nvl(trim(t1.loan_cap_use_position_cd), '0')                                                      --境内外标志
    ,t1.white_list_cust_flg                                                                            --白户标志
    ,'-'                                                                                                --农户标志
 ,'-'                                                                                                --涉农标志
    ,'1'                                                                                              --计息标志
    ,'0'                                                                                              --复息标志
    ,decode(nvl(t17.agt_status_cd, t1.cont_status_cd), 'OVD', '1', '0')                                --逾期标志
    ,decode(t14.agt_status_cd, 'Y', '1', '0')                                                          --核销标志
 ,''                                                                                                --人行普惠贷款标志
    ,'0'                                                                                               --债权直转标志
    ,''                                                                                                --重组标志
    ,''                                                                                                --重组贷款类型代码
    ,''                                                                                                --重组日期
    ,t1.distr_dt                                                                                      --开户日期
    ,t1.distr_dt                                                                                      --放款日期
    ,t1.distr_dt                                                                                      --原始放款日期
    ,t1.loan_value_dt                                                                                  --起息日期
    ,t1.loan_exp_dt                                                                                    --到期日期
    ,t1.loan_exp_dt                                                                                    --原始到期日期
    ,t1.payoff_dt                                                                                      --结清日期
    ,nvl(t4.last_repay_dt, t1.loan_value_dt)                                                           --上次还款日期
    ,t11.imp_dt                                                                                        --下次还款日期
    ,t1.distr_dt                                                                                      --当前利率生效日期
    ,t1.distr_dt                                                                                      --下次利率调整日期
    ,t30.cust_mgr_id                                                                                        --客户经理编号
    ,'897001'                                                                                          --开户机构编号
    ,'897001'                                                                                          --管理机构编号
    ,'897001'                                                                                          --账务机构编号
    ,t1.loan_cont_tenor                                                                                --原始贷款期数
    ,t1.loan_cont_tenor                                                                                --贷款期数
    ,nvl(t1.loan_cont_tenor,0) - nvl(t1.unpayoff_perds,0)                                              --当前期数/*t3.pd_num*/
    ,t1.unpayoff_perds                                                                                --剩余期数
    ,t1.ovdue_pd_cnt                                                                                  --逾期期数
    ,case when decode(nvl(t17.agt_status_cd, t1.cont_status_cd), 'OVD', '1', '0') = '1' then nvl(t5.prin_ovdue_days,0) else 0 end  --本金逾期天数
    ,case when decode(nvl(t17.agt_status_cd, t1.cont_status_cd), 'OVD', '1', '0') = '1' then nvl(t5.int_ovdue_days, 0) else 0 end  --利息逾期天数
    ,t1.grace_period_days                                                                              --宽限期天数
    ,0                                                                                                --分期手续费费率
    ,nvl(t9.base_int_rat, 0)                                                                          --基准利率
    ,nvl(t9.exec_int_rat, 0)                                                                           --执行利率
    ,nvl(t9.exec_int_rat * 1.5, 0)                                                                     --逾期利率
    ,nvl(t1.loan_actl_day_int_rat, 0)                                                                 --每日执行利率
    ,0                                                                                                  --固收利率
    ,nvl(t1.distr_amt, 0)                                                                              --合同金额
    ,nvl(t1.distr_amt, 0)                                                                              --借据金额
    ,nvl(t25.amt, 0)                                                                                  --放款金额
    ,nvl(t25.amt, 0)                                                                                  --原始放款金额
    ,0.9                                                                                               --银行出资比例
    ,nvl(t2.today_accrued_int,0)                                                                      --当日应计利息
    ,nvl(t10.int_bal,0)+nvl(t10.ovd_int_bal,0)                      --当期应计利息
    ,case when decode(t14.agt_status_cd, 'Y', '1', '0') ='0' then nvl(t10.prin_bal,0) else 0 end       --正常本金
    ,case when nvl(trim(t1.acru_non_acru_flg),'0') = '0'
    and decode(t14.agt_status_cd, 'Y', '1', '0') = '0' then nvl(t10.ovd_prin_bal,0) else 0 end         --逾期本金
    ,case when nvl(trim(t1.acru_non_acru_flg),'0') = '1' and decode(t14.agt_status_cd, 'Y', '1', '0') = '0' then nvl(t10.ovd_prin_bal,0) else 0 end  --呆滞本金
    ,0                                                                                                 --呆账本金
    ,case when decode(t14.agt_status_cd,'Y','1','0') = '1' then nvl(t10.prin_bal,0) + nvl(t10.ovd_prin_bal,0) else 0 end --核销本金
    ,nvl(t10.int_bal,0)                                                                               --正常利息
    ,nvl(t10.ovd_int_bal,0)                                                                           --逾期利息
 ,case when decode(t14.agt_status_cd,'Y','1','0') = '1' then nvl(t10.int_bal,0) + nvl(t10.ovd_int_bal,0) + nvl(t10.ovd_prin_pnlt_bal,0) + nvl(t10.ovd_int_pnlt_bal,0) else 0 end  --核销利息
    ,nvl(t10.ovd_prin_pnlt_bal,0)                                                                     --逾期本金罚息
    ,nvl(t10.ovd_int_pnlt_bal,0)                                                                     --逾期利息罚息
    ,(nvl(t10.int_bal,0) + nvl(t10.ovd_int_bal,0))                                                   --应收欠息
    ,nvl(t10.ovd_int_bal,0)                                                                            --应收应计罚息
    ,(nvl(t10.ovd_prin_pnlt_bal,0) + nvl(t10.ovd_int_pnlt_bal,0))                                      --应收罚息
    ,0                                                                                                --应收费用
    ,case when greatest(to_number(nvl(trim(t5.prin_ovdue_days),0)),to_number(nvl(trim(t5.int_ovdue_days),0)))  < 90 then (nvl(t10.int_bal,0) + nvl(t10.ovd_int_bal,0)) else 0 end      --表内欠息余额
    ,case when greatest(to_number(nvl(trim(t5.prin_ovdue_days),0)),to_number(nvl(trim(t5.int_ovdue_days),0))) >= 90 then (nvl(t10.int_bal,0) + nvl(t10.ovd_int_bal,0)) else 0 end  --表外欠息余额
    ,case when greatest(to_number(nvl(trim(t5.prin_ovdue_days),0)),to_number(nvl(trim(t5.int_ovdue_days),0))) < 90  then (nvl(t10.int_bal,0) + nvl(t10.ovd_int_bal,0) + nvl(t10.ovd_prin_pnlt_bal,0) + nvl(t10.ovd_int_pnlt_bal,0)) else 0 end  --表内利息/*nvl(t5.on_int,0)*/
    ,case when greatest(to_number(nvl(trim(t5.prin_ovdue_days),0)),to_number(nvl(trim(t5.int_ovdue_days),0))) >= 90 then (nvl(t10.int_bal,0) + nvl(t10.ovd_int_bal,0) + nvl(t10.ovd_prin_pnlt_bal,0) + nvl(t10.ovd_int_pnlt_bal,0)) else 0 end  --表外利息
    ,case when greatest(to_number(nvl(trim(t5.prin_ovdue_days),0)),to_number(nvl(trim(t5.int_ovdue_days),0))) >= 90 then (nvl(t10.int_bal,0) + nvl(t10.ovd_int_bal,0) + nvl(t10.ovd_prin_pnlt_bal,0) + nvl(t10.ovd_int_pnlt_bal,0)) else 0 end     --累计应收未收利息金额
    ,nvl(t4.paid_normal_prin,0)                                                                       --已偿还正常本金
    ,nvl(t4.paid_ovdue_prin,0)                                                                       --已偿还逾期本金
    ,nvl(t4.paid_normal_int,0)                                                                       --已偿还正常利息
    ,nvl(t4.paid_ovdue_int,0)                                                                         --已偿还逾期利息
    ,nvl(t4.paid_ovdue_prin_pnlt,0)                                                                   --已偿还逾期本金罚息
    ,nvl(t4.paid_ovdue_int_pnlt,0)                                                                   --已偿还逾期利息罚息
    ,nvl(t4.paid_cost,0)                                                                             --已偿还费用
    ,nvl(t10.prin_bal,0) + nvl(t10.ovd_prin_bal ,0)                                                    --本金余额
    ,nvl(t10.prin_bal,0) + nvl(t10.ovd_prin_bal ,0)                                                    --当期余额
    ,(nvl(t10.prin_bal,0) + nvl(t10.ovd_prin_bal,0)) * nvl(t6.convt_cny_exch_rat,1)                    --折本币当期余额
    ,t1.job_cd                                                                                         --任务代码
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6')
from ${icl_schema}.tmp_cmm_unite_wl_dubil_info_clear_28 t1
  left join ${iml_schema}.agt_rela_h t8
   on t8.agt_id = t1.agt_id
   and t8.agt_rela_type_cd = '05'
   and t8.start_dt <= to_date('${batch_date}', 'yyyymmdd')
      and t8.end_dt > to_date('${batch_date}', 'yyyymmdd')
      and t8.job_cd = 'myjbf2'
    left join ${iml_schema}.agt_int_rat_h t9
     on t9.agt_id = t1.agt_id
     and t9.int_rat_type_cd = '003001'
     and t9.start_dt <= to_date('${batch_date}', 'yyyymmdd')
      and t9.end_dt > to_date('${batch_date}', 'yyyymmdd')
      and t9.job_cd = 'myjbf2'
    left join ${icl_schema}.tmp_cmm_unite_wl_dubil_info_clear_07 t10
     on t1.agt_id = t10.agt_id
    left join ${iml_schema}.agt_imp_dt_h t11
     on t11.agt_id = t1.agt_id
     and t11.dt_type_cd = '05'
     and t11.start_dt <= to_date('${batch_date}', 'yyyymmdd')
      and t11.end_dt > to_date('${batch_date}', 'yyyymmdd')
      and t11.job_cd = 'myjbf2'
    left join ${iml_schema}.agt_status_h t12
      on t12.agt_id = t1.agt_id
     and t12.agt_status_type_cd = 'CD1261'
     and t12.start_dt <= to_date('${batch_date}', 'yyyymmdd')
      and t12.end_dt > to_date('${batch_date}', 'yyyymmdd')
      and t12.job_cd = 'myjbf2'
     left join ${iml_schema}.agt_status_h t33
      on t33.agt_id = t1.agt_id
     and t33.agt_status_type_cd = 'CD2060'
     and t33.start_dt <= to_date('${batch_date}', 'yyyymmdd')
      and t33.end_dt > to_date('${batch_date}', 'yyyymmdd')
      and t33.job_cd = 'myjbf2'
    /*left join ${iml_schema}.agt_loan_ovdue_h t13
      on t13.agt_id = t1.agt_id
      and t13.start_dt <= to_date('${batch_date}', 'yyyymmdd')
      and t13.end_dt > to_date('${batch_date}', 'yyyymmdd')
      and t13.job_cd = 'myjbf2'*/
    left join ${iml_schema}.agt_status_h t14
     on t14.agt_id = t1.agt_id
     and t14.agt_status_type_cd = 'CD1102'
     and t14.start_dt <= to_date('${batch_date}', 'yyyymmdd')
     and t14.end_dt > to_date('${batch_date}', 'yyyymmdd')
     and t14.job_cd = 'myjbf2'
/*    left join ${iml_schema}.agt_rating_h t15
     on t15.agt_id = t1.agt_id
     and t15.rating_type_cd = '2'
     and t15.start_dt <= to_date('${batch_date}', 'yyyymmdd')
     and t15.end_dt > to_date('${batch_date}', 'yyyymmdd')
     and t15.job_cd = 'myjbf2' */
   left join (select agt_id,
                     sum((nvl(nomal_int_amt, 0) + nvl(ovdue_pric_pnlt, 0) + nvl(ovdue_int_pnlt, 0))) as today_accrued_int,
                     sum(nvl(ovdue_int_bal,0)+nvl(nomal_int_amt,0)) as in_bs_int
                from ${iml_schema}.agt_ajb_int_provi_dtl
               where int_accr_dt = to_date('${batch_date}','yyyymmdd')
                 and acru_non_acru_idf = '0'
                 and etl_dt = to_date('${batch_date}','yyyymmdd')
                 and job_cd = 'myjbi2'
               group by agt_id) t2
    on t1.agt_id = t2.agt_id
   /*left join ${iml_schema}.agt_ajb_repay_plan_h t3
    on t1.agt_id = t3.agt_id
     and t1.next_repay_dt = t3.inst_end_dt
      and t3.start_dt <= to_date('${batch_date}', 'yyyymmdd')
      and t3.end_dt > to_date('${batch_date}', 'yyyymmdd')
      and t3.job_cd = 'myjbf2'*/
   left join ${icl_schema}.tmp_cmm_unite_wl_dubil_info_clear_03 t4
     on t1.dubil_id = t4.dubil_id
   left join ${icl_schema}.tmp_cmm_unite_wl_dubil_info_clear_04 t5
      on t1.agt_id = t5.agt_id
   left join  ${iml_schema}.ref_cny_fori_exch_mdl_p_h t6
      on t1.curr_cd = t6.curr_cd
     --and t6.dt = to_date('${batch_date}', 'yyyymmdd')
      and t6.start_dt <= to_date('${batch_date}', 'yyyymmdd')
      and t6.end_dt > to_date('${batch_date}', 'yyyymmdd')
--      and t6.id_mark <> 'D'
      and t6.job_cd = 'ncbsf1'
    left join ${iml_schema}.agt_prod_rela_h t16
      on t1.agt_id = t16.agt_id
     and t16.start_dt <= to_date('${batch_date}','yyyymmdd')
     and t16.end_dt > to_date('${batch_date}','yyyymmdd')
     and t16.job_cd ='myjbf2'
     --and t16.job_cd in ('rcrsf1', 'rcrsf2')
    left join ${iml_schema}.agt_status_h t17
     on t17.agt_id = t1.agt_id
     and t17.agt_status_type_cd = 'CD1278'
     and t17.start_dt <= to_date('${batch_date}', 'yyyymmdd')
     and t17.end_dt > to_date('${batch_date}', 'yyyymmdd')
     and t17.job_cd = 'myjbf2'
    left join ${iml_schema}.agt_amt_h t25
      on t1.agt_id = t25.agt_id
     and t25.amt_type_cd= '001005'
     and t25.start_dt <= to_date('${batch_date}', 'yyyymmdd')
     and t25.end_dt > to_date('${batch_date}', 'yyyymmdd')
--    and t25.id_mark <> 'D'
     and t25.job_cd = 'myjbf2'
   left join ${iml_schema}.prd_prod_cust_mgr_rela_h t30
     on t30.prod_id = '202010100001'  -- 蚂蚁借呗联合贷款客户经理
    and t30.start_dt <= to_date('${batch_date}','yyyymmdd')
    and t30.end_dt > to_date('${batch_date}','yyyymmdd')
    and t30.job_cd = 'icmsf1'
where 1=1
;
commit;


-- 第三组（共九组）网商贷
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ into ${icl_schema}.cmm_unite_wl_dubil_info_clear_ex(
   etl_dt                                 --数据日期
   ,lp_id                                 --法人编号
   ,dubil_id                              --借据编号
   ,core_dubil_id                         --核心借据编号
   ,cont_id                               --合同编号
   ,std_prod_id                           --标准产品编号
   ,prod_id                               --产品编号
   ,cust_id                               --客户编号
   ,subj_id                               --科目编号
   ,acctnt_cate_cd                        --会计类别代码
   ,enter_acct_acct_num                   --入账账号
   ,repay_num                             --还款账号
   ,rela_agt_id                           --关联协议编号
   ,rela_appl_flow_num                    --关联申请流水号
   ,curr_cd                               --币种代码
   ,bus_breed_id                          --业务品种编号
   ,loan_type_cd                          --贷款类型代码
   ,intnal_loan_type_cd                    --行内贷款类型代码
   ,asset_thd_cls_cd                      --资产三分类
   ,dubil_status_cd                       --借据状态代码
   ,loan_usage_cd                         --贷款用途代码
   ,dir_indus_cd                          --贷款贷款贷款投向行业代码
   ,cont_status_cd                        --合同状态代码
   ,loan_level4_cls_cd                    --贷款四级分类代码
   ,loan_level5_cls_cd                    --贷款五级分类代码
   ,loan_level10_cls_cd                   --贷款十级分类代码
   ,loan_level12_cls_cd                   --贷款十二级分类代码
   ,acru_non_acru_cd                      --应计非应计代码
   ,repay_way_cd                          --还款方式代码
   ,int_set_way_cd                        --结息方式代码
   ,int_accr_way_cd                       --计息方式代码
   ,int_rat_adj_way_cd                    --利率调整方式代码
   ,int_rat_adj_ped_corp_cd               --利率调整周期单位代码
   ,int_rat_adj_ped_freq                  --利率调整周期频率
   ,int_rat_base_type_cd                  --利率基准类型代码
   ,int_rat_float_way_cd                  --利率浮动方式代码
   ,int_rat_float_dir_cd                  --利率浮动方向代码
   ,int_rat_flo_val                       --利率浮动值
   ,pric_repay_freq_cd                    --本金还款周期频率
   ,int_repay_freq_cd                     --利息还款周期频率
   ,guar_way_cd                           --担保方式代码
   ,cust_char_cd                          --客户性质代码
   ,enter_acct_acct_num_type              --入账账号类型
   ,enter_acct_bank_name                  --入账账户开户银行名称
   ,repay_num_type                        --还款账号类型
   ,repay_open_acct_bank_id               --还款账户开户银行编号
   ,repay_open_acct_org_name              --还款账户开户机构名称
   ,intnal_carr_flg                       --内部结转标志
   ,dom_overs_flg                         --境内外标志
   ,white_list_cust_flg                   --白户标志
   ,farm_flg                              --农户标志
   ,agclt_flg                             --涉农标志
   ,int_accr_flg                          --计息标志
   ,comp_int_flg                          --复息标志
   ,ovdue_flg                             --逾期标志
   ,wrt_off_flg                           --核销标志
   ,pbc_inc_loan_flg                      --人行普惠贷款标志
   ,cred_rht_turn_flg                     --债权直转标志
   ,regroup_flg                           --重组标志
   ,regroup_loan_type_cd                  --重组贷款类型代码
   ,regroup_dt                            --重组日期
   ,open_acct_dt                          --开户日期
   ,distr_dt                              --放款日期
   ,init_distr_dt                         --原始放款日期
   ,value_dt                              --起息日期
   ,exp_dt                                --到期日期
   ,init_exp_dt                           --原始到期日期
   ,payoff_dt                             --结清日期
   ,last_repay_dt                         --上次还款日期
   ,next_repay_dt                         --下次还款日期
   ,curr_int_rat_effect_dt                --当前利率生效日期
   ,next_int_rat_adj_dt                   --下次利率调整日期
   ,cust_mgr_id                           --客户经理编号
   ,open_acct_org_id                      --开户机构编号
   ,mgmt_org_id                           --管理机构编号
   ,acct_instit_id                        --账务机构编号
   ,init_tot_perds                        --原始贷款期数
   ,tot_perds                             --贷款期数
   ,curr_issue_perds                      --当前期数
   ,surp_perds                            --剩余期数
   ,ovdue_perds                           --逾期期数
   ,pric_ovdue_days                       --本金逾期天数
   ,int_ovdue_days                        --利息逾期天数
   ,grace_period_days                     --宽限期天数
   ,inst_comm_fee_rat                     --分期手续费费率
   ,base_rat                              --基准利率
   ,exec_int_rat                          --执行利率
   ,ovdue_int_rat                         --逾期利率
   ,daily_exec_int_rat                    --每日执行利率
   ,int_rat                               --固收利率
   ,cont_amt                              --合同金额
   ,dubil_amt                             --借据金额
   ,distr_amt                             --放款金额
   ,init_distr_amt                        --原始放款金额
   ,bank_contri_ratio                     --银行出资比例
   ,td_acru_int                           --当日应计利息
   ,currt_acru_int                        --当期应计利息
   ,nomal_pric                            --正常本金
   ,ovdue_pric                            --逾期本金
   ,idle_pric                             --呆滞本金
   ,bad_debt_pric                         --呆账本金
   ,wrt_off_pric                          --核销本金
   ,nomal_int                             --正常利息
   ,ovdue_int                             --逾期利息
   ,wrt_off_int                           --核销利息
   ,ovdue_pric_pnlt                       --逾期本金罚息
   ,ovdue_int_pnlt                        --逾期利息罚息
   ,recvbl_over_int                       --应收欠息
   ,recvbl_acru_pnlt                      --应收应计罚息
   ,recvbl_pnlt                           --应收罚息
   ,recvbl_fee                            --应收费用
   ,in_bs_over_int_bal                    --表内欠息余额
   ,off_bs_over_int_bal                   --表外欠息余额
   ,in_bs_int                             --表内利息
   ,off_bs_int                            --表外利息
   ,acm_recvbl_uncol_int_amt              --累计应收未收利息金额
   ,repaid_nomal_pric                     --已偿还正常本金
   ,repaid_ovdue_pric                     --已偿还逾期本金
   ,repaid_nomal_int                      --已偿还正常利息
   ,repaid_ovdue_int                      --已偿还逾期利息
   ,repaid_ovdue_pric_pnlt                --已偿还逾期本金罚息
   ,repaid_ovdue_int_pnlt                 --已偿还逾期利息罚息
   ,repaid_fee                            --已偿还费用
   ,pric_bal                              --本金余额
   ,currt_bal                             --当期余额
   ,cl_curr_currt_bal                     --折本币当期余额
   ,job_cd                                --任务代码
   ,etl_timestamp                         --etl处理时间戳
)
select
   to_date('${batch_date}','yyyymmdd')                                              --数据日期
   ,t1.lp_id                                                                         --法人编号
   ,t1.dubil_id                                                                      --借据编号
   ,t1.dubil_id                                                                      -- 核心借据编号
   ,t1.cont_id                                                                       --合同编号
   ,t15.prod_id                                                                      --标准产品编号
   ,t15.prod_id                                                                      --产品编号
   ,t1.cust_id                                                                      --客户编号
   ,'13030202'                                                                      --科目编号
   ,''                                                                               --会计类别代码
   ,t1.recvbl_acct_id                                                                --入账账号
   ,t1.repay_acct_id                                                                --还款账号
   ,t1.crdt_appl_id                                                                  --关联协议编号
   ,concat('MYBK',t1.cust_id)                                                        --关联申请流水号
   ,nvl(t1.curr_cd, 'CNY')                                                          --币种代码
   ,decode(t1.prod_type_cd, '1900010_LHD', '02001006135011', '1900010_LHDZT', '02001006160048', t1.prod_type_cd) --业务品种编号
   ,t1.myloan_dubil_type_cd                                                         --贷款类型代码
   ,''                    --行内贷款类型代码
   ,t33.agt_status_cd                                                                --资产三分类代码
   ,nvl(t11.agt_status_cd, t1.loan_status_cd)                                        --借据状态代码
   ,t1.loan_usage_cd                                                                --贷款用途代码
   ,decode(t1.loan_dir_indus_cd,'-','F5299',t1.loan_dir_indus_cd)                    --贷款贷款贷款投向行业代码
   ,nvl(t17.agt_status_cd, t1.cont_status_cd)                                        --合同状态代码
   ,'00'                                                                             --贷款四级分类代码
   ,decode (t14.rating_result_cd,'1','10','2','20','3','30','4','40','5','50',t14.rating_result_cd)                                                    --贷款五级分类代码
   ,decode (t14.rating_result_cd,'1','11','2','21','3','30','4','40','5','50','10','11','20','21',t14.rating_result_cd)                                                    --贷款十级分类代码
   ,'11'                                                                             --贷款十二级分类代码
   ,nvl(trim(t1.acru_non_acru_flg), '0')                                           --应计非应计代码
   ,nvl(trim(t1.repay_way_cd),'-')                                                 --还款方式代码
   ,'08'                                                                             --结息方式代码
   ,'AB'                                                                             --计息方式代码
   ,t1.int_rat_adj_way_cd                                                            --利率调整方式代码
   ,decode(t1.int_rat_adj_way_cd, 'L0', 'D', 'L1', 'W', 'L2', 'M', 'L3', 'Q', 'L4', 'M', 'L5', 'Y', 'O')               -- 利率调整周期单位代码
   ,case when t1.src_int_rat_type_cd = 'L4' then 6 when t1.src_int_rat_type_cd in ('L0', 'L1', 'L2', 'L3', 'L5') then 1 else 0 end               -- 利率调整周期频率
   ,t1.base_rat_type_cd                                                              --利率基准类型代码
   ,'1'                                                                              --利率浮动方式代码
   ,t1.int_rat_float_dir_cd                                                          --利率浮动方向代码
   ,t9.int_rat_float_point                                                           --利率浮动值
   ,t1.pric_repay_freq_cd                                                            --本金还款周期频率
   ,t1.int_repay_freq_cd                                                             --利息还款周期频率
   ,t1.guar_type_cd                                                                  --担保方式代码
   ,t1.cust_char_cd                                                                  --客户性质代码
   ,t1.recvbl_num_type_cd                                                            --入账账号类型
   ,''                                                                               --入账账户开户银行名称
   ,t1.repay_num_type_cd                                                             --还款账号类型
   ,''                                                                               --还款账户开户银行编号
   ,''                                                                               --还款账户开户机构名称
   ,'0'                                                                              --内部结转标志
   ,nvl(trim(t1.loan_cap_use_position_cd), '0')                                    --境内外标志
   ,t1.white_list_cust_flg                                                           --白户标志
   ,t1.farm_flg                                                                      --农户标志
   ,'-'
   ,'1'                                                                              --计息标志
   ,'0'                                                                              --复息标志
   ,decode(nvl(t17.agt_status_cd, t1.cont_status_cd), 'OVD', '1', '0')               --逾期标志
   ,decode(t13.agt_status_cd, 'Y', '1', '0')                                         --核销标志
   ,''                                                                                --人行普惠贷款标志
   ,t1.cred_rht_turn_flg                                                             --债权直转标志
   ,t32.isregroup                                                                    --重组标志
   ,t32.regrouptype                                                                  --重组贷款类型代码
   ,${iml_schema}.dateformat_max(t32.regroupdate)                                    --重组日期
   ,case when t1.cred_rht_turn_flg='1' then t1.hxb_loan_begin_dt else t1.distr_dt end  --开户日期
   ,case when t1.cred_rht_turn_flg='1' then t1.hxb_loan_begin_dt else t1.distr_dt end  --放款日期
   ,t1.distr_dt                                                                      --原始放款日期
   ,case when t1.cred_rht_turn_flg='1' then t1.hxb_loan_begin_dt else t1.loan_value_dt end   --起息日期
   ,t1.loan_exp_dt                                                                   --到期日期
   ,${iml_schema}.dateformat_max(t32.oldenddate)                                     --原始到期日期
   ,t18.imp_dt                                                                       --结清日期
   ,nvl(t4.last_repay_dt, t1.loan_value_dt)                                          --上次还款日期
   ,t16.imp_dt                                                                       --下次还款日期
   ,case when t1.cred_rht_turn_flg='1' then t1.hxb_loan_begin_dt else t1.distr_dt end     --当前利率生效日期
   ,case when t1.cred_rht_turn_flg='1' then t1.hxb_loan_begin_dt else t1.distr_dt end     --下次利率调整日期
   ,t30.cust_mgr_id                                                                  --客户经理编号
   ,'898001'                                                                         --开户机构编号
   ,'898001'                                                                         --管理机构编号
   ,'898001'                                                                         --账务机构编号
   ,t1.loan_cont_tenor                                                               --原始贷款期数
   ,case when t1.cred_rht_turn_flg='1' then t1.hxb_loan_tot_perds else  t1.loan_cont_tenor end      --贷款期数
   ,(case when t1.cred_rht_turn_flg='1' then t1.hxb_loan_tot_perds else  t1.loan_cont_tenor end)-nvl(t1.unpayoff_perds,0)       --当前期数
   ,t1.unpayoff_perds                                                                --剩余期数
   ,t1.ovdue_pd_cnt                                                                  --逾期期数
   ,case when decode(nvl(t17.agt_status_cd, t1.cont_status_cd), 'OVD', '1', '0') = '1' then nvl(t12.pric_ovdue_days, 0) else 0 end --本金逾期天数
   ,case when decode(nvl(t17.agt_status_cd, t1.cont_status_cd), 'OVD', '1', '0') = '1' then nvl(t12.int_ovdue_days,0) else 0 end --利息逾期天数
   ,t1.grace_period_days                                                             --宽限期天数
   ,0                                                                                --分期手续费费率
   ,nvl(t9.base_int_rat,0)                                                           --基准利率
   ,nvl(t9.exec_int_rat,0)                                                           --执行利率
   ,nvl(t9.exec_int_rat * 1.5,0)                                                     --逾期利率
   ,nvl(t1.loan_actl_day_int_rat,0)                                                  --每日执行利率
   ,nvl(t33.rate,0)                                                                  --固收利率
   ,case when t1.cred_rht_turn_flg='1' then t1.hxb_loan_amt else nvl(t1.distr_amt,0) end    --合同金额
   ,case when t1.cred_rht_turn_flg='1' then t1.hxb_loan_amt else nvl(t1.distr_amt,0) end    --借据金额
   ,case when t1.cred_rht_turn_flg='1' then t1.hxb_loan_amt else nvl(t1.distr_amt,0) end    --放款金额
   ,nvl(t1.distr_amt,0)                                                              --原始放款金额
   ,0.9                                                                              --银行出资比例
   ,(nvl(t2.nomal_int, 0) + nvl(t2.ovdue_pric_pnlt, 0) + nvl(t2.ovdue_int_pnlt, 0))  --当日应计利息
   ,nvl(t10.int_bal,0)+nvl(t10.ovd_int_bal,0)                                       --当期应计利息
   ,case when decode(t13.agt_status_cd, 'Y', '1', '0') = '0' then nvl(t10.prin_bal,0)end    --正常本金
   ,case when nvl(trim(t1.acru_non_acru_flg),'0') = '0' and decode(t13.agt_status_cd, 'Y', '1', '0') = '0' then nvl(t10.ovd_prin_bal,0) else 0 end --逾期本金
   ,case when nvl(trim(t1.acru_non_acru_flg),'0') = '1' and decode(t13.agt_status_cd,'Y','1','0') = '0' then nvl(t10.ovd_prin_bal,0) else 0 end --呆滞本金
   ,0                                                                                         --呆账本金
   ,case when decode(t13.agt_status_cd,'Y','1','0') = '1' then nvl(t10.prin_bal,0) + nvl(t10.ovd_prin_bal,0) else 0 end --核销本金
   ,nvl(t10.int_bal,0)                                                                       --正常利息
   ,nvl(t10.ovd_int_bal,0)                                                                   --逾期利息
   ,case when decode(t13.agt_status_cd,'Y','1','0') = '1' then nvl(t10.int_bal,0) + nvl(t10.ovd_int_bal,0) else 0 end --核销利息
   ,nvl(t10.ovd_prin_pnlt_bal,0)                                                             --逾期本金罚息
   ,nvl(t10.ovd_int_pnlt_bal,0)                                                              --逾期利息罚息
   ,nvl(t2.ovdue_int_bal,0)+nvl(t2.nomal_int,0)+nvl(t2.ovdue_pric_pnlt,0)+nvl(t2.ovdue_int_pnlt,0) --应收欠息/*nvl(t5.raccr_arr_int,0)*/
   ,nvl(t10.ovd_int_bal,0)                                                                   --应收应计罚息
   ,nvl(t2.ovdue_pric_pnlt,0)+nvl(t2.ovdue_int_pnlt,0)                                       --应收罚息/*nvl(t5.rcbl_pnty_int,0)*/
   ,0                                                                                        --应收费用
   ,case when greatest(to_number(nvl(trim(case when decode(nvl(t17.agt_status_cd, t1.cont_status_cd), 'OVD', '1', '0') = '1' then nvl(t12.pric_ovdue_days, 0) else 0 end),0)),to_number(nvl(trim(case when decode(nvl(t17.agt_status_cd, t1.cont_status_cd), 'OVD', '1', '0') = '1'
         then nvl(t12.int_ovdue_days,0) else 0 end),0)))  < 90 then (nvl(t10.int_bal,0) + nvl(t10.ovd_int_bal,0)) else 0 end --表内欠息余额
   ,case when greatest(to_number(nvl(trim(case when decode(nvl(t17.agt_status_cd, t1.cont_status_cd), 'OVD', '1', '0') = '1' then nvl(t12.pric_ovdue_days, 0) else 0 end),0)),to_number(nvl(trim(case when decode(nvl(t17.agt_status_cd, t1.cont_status_cd), 'OVD', '1', '0') = '1'
         then nvl(t12.int_ovdue_days,0) else 0 end),0))) >= 90 then (nvl(t10.int_bal,0) + nvl(t10.ovd_int_bal,0)) else 0 end --表外欠息余额
   ,case when greatest(to_number(nvl(trim(case when decode(nvl(t17.agt_status_cd, t1.cont_status_cd), 'OVD', '1', '0') = '1' then nvl(t12.pric_ovdue_days, 0) else 0 end),0)),to_number(nvl(trim(case when decode(nvl(t17.agt_status_cd, t1.cont_status_cd), 'OVD', '1', '0') = '1'
         then nvl(t12.int_ovdue_days,0) else 0 end),0)) ) < 90 then (nvl(t10.int_bal,0) + nvl(t10.ovd_int_bal,0) + nvl(t10.ovd_prin_pnlt_bal,0) + nvl(t10.ovd_int_pnlt_bal,0)) else 0 end --表内利息/*case when t2.acru_non_acru_flg = '0' then nvl(t2.ovdue_int_bal,0)+nvl(t2.nomal_int,0) else 0 end*/
   ,case when greatest(to_number(nvl(trim(case when decode(nvl(t17.agt_status_cd, t1.cont_status_cd), 'OVD', '1', '0') = '1' then nvl(t12.pric_ovdue_days, 0) else 0 end),0)),to_number(nvl(trim(case when decode(nvl(t17.agt_status_cd, t1.cont_status_cd), 'OVD', '1', '0') = '1'
         then nvl(t12.int_ovdue_days,0) else 0 end),0))) >= 90 then (nvl(t10.int_bal,0) + nvl(t10.ovd_int_bal,0) + nvl(t10.ovd_prin_pnlt_bal,0) + nvl(t10.ovd_int_pnlt_bal,0)) else 0 end --表外利息
   ,case when greatest(to_number(nvl(trim(case when decode(nvl(t17.agt_status_cd, t1.cont_status_cd), 'OVD', '1', '0') = '1' then nvl(t12.pric_ovdue_days, 0) else 0 end),0)),to_number(nvl(trim(case when decode(nvl(t17.agt_status_cd, t1.cont_status_cd), 'OVD', '1', '0') = '1'
         then nvl(t12.int_ovdue_days,0) else 0 end),0))) >= 90 then (nvl(t10.int_bal,0) + nvl(t10.ovd_int_bal,0) + nvl(t10.ovd_prin_pnlt_bal,0) + nvl(t10.ovd_int_pnlt_bal,0)) else 0 end --累计应收未收利息金额
   ,nvl(t4.paid_normal_prin,0)                                                               --已偿还正常本金
   ,nvl(t4.paid_ovdue_prin,0)                                                                --已偿还逾期本金
   ,nvl(t4.paid_normal_int,0)                                                                --已偿还正常利息
   ,nvl(t4.paid_ovdue_int,0)                                                                 --已偿还逾期利息
   ,nvl(t4.paid_ovdue_prin_pnlt,0)                                                           --已偿还逾期本金罚息
   ,nvl(t4.paid_ovdue_int_pnlt,0)                                                            --已偿还逾期利息罚息
   ,nvl(t4.paid_cost,0)                                                                      --已偿还费用
   ,nvl(t10.prin_bal,0)  + nvl(t10.ovd_prin_bal,0)                                           --本金余额
   ,nvl(t10.prin_bal,0)  + nvl(t10.ovd_prin_bal,0)                                           --当期余额
   ,(nvl(t10.prin_bal,0)  + nvl(t10.ovd_prin_bal,0)) * nvl(t6.convt_cny_exch_rat, 1)         --折本币当期余额
   ,t1.job_cd                                                                                --任务代码
   ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6')
from ${icl_schema}.tmp_cmm_unite_wl_dubil_info_clear_29 t1
  left join ${iml_schema}.agt_party_rela_h t8
   on t1.agt_id = t8.agt_id
   and t8.agt_party_rela_type_cd = '02'
   and t8.job_cd = 'mybkf1'
   and t8.start_dt <= to_date('${batch_date}', 'yyyymmdd')
    and t8.end_dt > to_date('${batch_date}', 'yyyymmdd')
  left join ${iml_schema}.agt_int_rat_h t9
   on t1.agt_id = t9.agt_id
   and t9.int_rat_type_cd = '003001'
   and t9.start_dt <= to_date('${batch_date}', 'yyyymmdd')
    and t9.end_dt > to_date('${batch_date}', 'yyyymmdd')
    and t9.job_cd = 'mybkf1'
  left join ${icl_schema}.tmp_cmm_unite_wl_dubil_info_clear_07 t10
   on t1.agt_id = t10.agt_id
  left join ${iml_schema}.agt_status_h t11
   on t1.agt_id = t11.agt_id
   and t11.agt_status_type_cd = 'CD1261'
   and t11.start_dt <= to_date('${batch_date}', 'yyyymmdd')
    and t11.end_dt > to_date('${batch_date}', 'yyyymmdd')
    and t11.job_cd = 'mybkf1'
   left join ${iml_schema}.agt_status_h t33
   on t1.agt_id = t33.agt_id
   and t33.agt_status_type_cd = 'CD2060'
   and t33.start_dt <= to_date('${batch_date}', 'yyyymmdd')
    and t33.end_dt > to_date('${batch_date}', 'yyyymmdd')
    and t33.job_cd = 'mybkf1'
   left join ${iml_schema}.agt_loan_ovdue_h t12
    on t1.agt_id = t12.agt_id
   and t12.start_dt <= to_date('${batch_date}', 'yyyymmdd')
    and t12.end_dt > to_date('${batch_date}', 'yyyymmdd')
    and t12.job_cd = 'mybkf1'
  left join ${iml_schema}.agt_status_h t13
    on t1.agt_id = t13.agt_id
   and t13.agt_status_type_cd = 'CD1102'
   and t13.start_dt <= to_date('${batch_date}', 'yyyymmdd')
    and t13.end_dt > to_date('${batch_date}', 'yyyymmdd')
    and t13.job_cd = 'mybkf1'
  left join ${iml_schema}.agt_rating_h t14
    on t14.agt_id = t1.agt_id
   and t14.rating_type_cd = '2'
   and t14.start_dt <= to_date('${batch_date}', 'yyyymmdd')
    and t14.end_dt > to_date('${batch_date}', 'yyyymmdd')
    and t14.job_cd = 'mybkf1'
  left join ${iml_schema}.agt_myloan_provi_dtl t2
     on t1.agt_id= t2.agt_id
    and t2.int_accr_dt = to_date('${batch_date}','yyyymmdd')
    and t2.acru_non_acru_flg = '0'
    and t2.etl_dt = to_date('${batch_date}', 'yyyymmdd')
    and t2.job_cd = 'mybki1'
  left join ${icl_schema}.tmp_cmm_unite_wl_dubil_info_clear_05 t4
    on t1.dubil_id= t4.dubil_id
/*  left join ${icl_schema}.tmp_cmm_unite_wl_dubil_info_clear_06 t5
    on t1.agt_id= t5.agt_id */
  left join ${iml_schema}.ref_cny_fori_exch_mdl_p_h t6
    on t1.curr_cd = t6.curr_cd
    --and t6.dt = to_date('${batch_date}', 'yyyymmdd')
    and t6.start_dt <= to_date('${batch_date}', 'yyyymmdd')
    and t6.end_dt > to_date('${batch_date}', 'yyyymmdd')
    and t6.id_mark <> 'D'
    and t6.job_cd ='ncbsf1'
  left join ${iml_schema}.agt_prod_rela_h t15
     on t1.agt_id = t15.agt_id
    and t15.start_dt <= to_date('${batch_date}','yyyymmdd')
    and t15.end_dt > to_date('${batch_date}','yyyymmdd')
    and t15.job_cd ='mybkf1'
    --and t15.job_cd in ('rcrsf1', 'rcrsf2')
   left join ${iml_schema}.agt_imp_dt_h t16
     on t16.agt_id = t1.agt_id
     and t16.dt_type_cd = '05'
     and t16.start_dt <= to_date('${batch_date}', 'yyyymmdd')
      and t16.end_dt > to_date('${batch_date}', 'yyyymmdd')
      and t16.job_cd = 'mybkf1'
   left join ${iml_schema}.agt_status_h t17
   on t1.agt_id = t17.agt_id
   and t17.agt_status_type_cd = 'CD1278'
   and t17.start_dt <= to_date('${batch_date}', 'yyyymmdd')
    and t17.end_dt > to_date('${batch_date}', 'yyyymmdd')
    and t17.job_cd = 'mybkf1'
   left join ${iml_schema}.agt_imp_dt_h t18
     on t18.agt_id = t1.agt_id
     and t18.dt_type_cd = '03'
     and t18.start_dt <= to_date('${batch_date}', 'yyyymmdd')
      and t18.end_dt > to_date('${batch_date}', 'yyyymmdd')
      and t18.job_cd = 'mybkf1'
   left join ${iml_schema}.prd_prod_cust_mgr_rela_h t30
     on t30.prod_id = '202020100001'  -- 网商贷客户经理
    and t30.start_dt <= to_date('${batch_date}','yyyymmdd')
    and t30.end_dt > to_date('${batch_date}','yyyymmdd')
    and t30.job_cd = 'icmsf1'
/*   left join ${icl_schema}.tmp_cmm_unite_wl_dubil_info_clear_26 t31
     on t1.cust_id=t31.cust_id */
   left join ${iol_schema}.icms_mybk_acc_loan t32
     on t1.dubil_id=t32.contractno
    and t32.start_dt <= to_date('${batch_date}','yyyymmdd')
    and t32.end_dt > to_date('${batch_date}','yyyymmdd')
    and t32.biztype<>'201020100057'   --房抵贷
   left join ${iol_schema}.icms_mybk_earnings_calc_detail_ef t33
     on t1.dubil_id = t33.contractno
    and t33.etl_dt = to_date('${batch_date}', 'yyyymmdd')
where 1=1
;
commit;

whenever sqlerror exit sql.sqlcode;
create table ${icl_schema}.tmp_cmm_unite_wl_dubil_info_clear_10
nologging
compress ${option_switch} for query high
as
select
   intnal_dubil_id
   ,curr_perds
   ,sum(nvl(rpbl_int, 0)) as curr_accrued_int
from ${icl_schema}.tmp_cmm_unite_wl_dubil_info_clear_08
group by intnal_dubil_id, curr_perds
;
commit;

create table ${icl_schema}.tmp_cmm_unite_wl_dubil_info_clear_11
nologging
compress ${option_switch} for query high
as
select intnal_dubil_id
       ,sum(nvl(repaid_pric, 0)) as paid_normal_prin
       ,0 as paid_ovdue_prin
       ,sum(nvl(repaid_int, 0) + nvl(repaid_comp_int, 0)) as paid_normal_int
       ,0 as paid_ovdue_int
       ,sum(nvl(repaid_pnlt, 0)) as paid_ovdue_prin_pnlt
       ,0 as paid_ovdue_int_pnlt
       ,sum(nvl(repaid_fee, 0)) as paid_cost
  from ${icl_schema}.tmp_cmm_unite_wl_dubil_info_clear_08
 group by intnal_dubil_id
;
commit;


create table ${icl_schema}.tmp_cmm_unite_wl_dubil_info_clear_88
nologging
compress ${option_switch} for query high
as
select intnal_dubil_id as intnal_dubil_id
        ,min(ovd_dt) as ovd_dt
from (
select wld1.intnal_dubil_id,
        case when wld2.intnal_dubil_id is not null then '0'
              when (nvl(wld1.rpbl_pric, 0) <> nvl(wld1.repaid_pric, 0) or
               nvl(wld1.rpbl_int, 0) <> nvl(wld1.repaid_int, 0)) and
               wld1.grace_dt < to_date('${batch_date}', 'yyyymmdd') 
              then '1'
              else '0' end as ovd_status,
        wld1.reach_money_exp_repay_dt as ovd_dt
 from ${icl_schema}.tmp_cmm_unite_wl_dubil_info_clear_08 wld1
 left join ${icl_schema}.tmp_cmm_unite_wl_dubil_info_clear_08 wld2
   on wld1.intnal_dubil_id = wld2.intnal_dubil_id
  and wld2.repay_plan_oper_act_cd = 'L'
where wld1.repay_plan_oper_act_cd <> 'L'
)  aa
where  aa.ovd_status = '1'
group by intnal_dubil_id
;
commit;


create table ${icl_schema}.tmp_cmm_unite_wl_dubil_info_clear_25
nologging
compress ${option_switch} for query high
as
select t1.intnal_dubil_id
      ,case when t2.intnal_dubil_id is null then '0' else '1' end as ovd_status
      ,case when t2.intnal_dubil_id is null then  0  else to_date('${batch_date}','yyyymmdd') - trunc(t2.ovd_dt) + 1 end as prin_ovdue_days
from ${iml_schema}.agt_wld_dubil_info t1
left join ${icl_schema}.tmp_cmm_unite_wl_dubil_info_clear_88 t2
   on t1.intnal_dubil_id = t2.intnal_dubil_id
where  t1.create_dt <= to_date('${batch_date}', 'yyyymmdd')
  and t1.job_cd = 'mpcsf1'
  and t1.id_mark <> 'D'
;
commit;


create table ${icl_schema}.tmp_cmm_unite_wl_dubil_info_clear_12
nologging
compress ${option_switch} for query high
as
select
   agt_id
   ,max(case when amt_type_cd = '001010' then amt end) as loan_bal_principal --欠款总本金
   ,max(case when amt_type_cd = '002016' then amt end) as loan_bal_interest  --欠款总利息
   ,max(case when amt_type_cd = '002017' then amt end) as loan_bal_penalty   --欠款总罚息
from ${iml_schema}.agt_amt_h
where start_dt <= to_date('${batch_date}','yyyymmdd')
and end_dt > to_date('${batch_date}','yyyymmdd')
and job_cd = 'mpcsf1'
group by agt_id
;
commit;


-- 第四组（共九组）微粒贷
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ into ${icl_schema}.cmm_unite_wl_dubil_info_clear_ex(
   etl_dt                                 --数据日期
   ,lp_id                                 --法人编号
   ,dubil_id                              --借据编号
   ,core_dubil_id                         --核心借据编号
   ,cont_id                               --合同编号
   ,std_prod_id                           --标准产品编号
   ,prod_id                               --产品编号
   ,cust_id                               --客户编号
   ,subj_id                               --科目编号
   ,acctnt_cate_cd                        --会计类别代码
   ,enter_acct_acct_num                   --入账账号
   ,repay_num                             --还款账号
   ,rela_agt_id                           --关联协议编号
   ,rela_appl_flow_num                    --关联申请流水号
   ,curr_cd                               --币种代码
   ,bus_breed_id                          --业务品种编号
   ,loan_type_cd                          --贷款类型代码
   ,intnal_loan_type_cd                    --行内贷款类型代码
   ,asset_thd_cls_cd                      --资产三分类
   ,dubil_status_cd                       --借据状态代码
   ,loan_usage_cd                         --贷款用途代码
   ,dir_indus_cd                          --贷款贷款贷款投向行业代码
   ,cont_status_cd                        --合同状态代码
   ,loan_level4_cls_cd                    --贷款四级分类代码
   ,loan_level5_cls_cd                    --贷款五级分类代码
   ,loan_level10_cls_cd                   --贷款十级分类代码
   ,loan_level12_cls_cd                   --贷款十二级分类代码
   ,acru_non_acru_cd                      --应计非应计代码
   ,repay_way_cd                          --还款方式代码
   ,int_set_way_cd                        --结息方式代码
   ,int_accr_way_cd                       --计息方式代码
   ,int_rat_adj_way_cd                    --利率调整方式代码
   ,int_rat_adj_ped_corp_cd               --利率调整周期单位代码
   ,int_rat_adj_ped_freq                  --利率调整周期频率
   ,int_rat_base_type_cd                  --利率基准类型代码
   ,int_rat_float_way_cd                  --利率浮动方式代码
   ,int_rat_float_dir_cd                  --利率浮动方向代码
   ,int_rat_flo_val                       --利率浮动值
   ,pric_repay_freq_cd                    --本金还款周期频率
   ,int_repay_freq_cd                     --利息还款周期频率
   ,guar_way_cd                           --担保方式代码
   ,cust_char_cd                          --客户性质代码
   ,enter_acct_acct_num_type              --入账账号类型
   ,enter_acct_bank_name                  --入账账户开户银行名称
   ,repay_num_type                        --还款账号类型
   ,repay_open_acct_bank_id               --还款账户开户银行编号
   ,repay_open_acct_org_name              --还款账户开户机构名称
   ,intnal_carr_flg                       --内部结转标志
   ,dom_overs_flg                         --境内外标志
   ,white_list_cust_flg                   --白户标志
   ,farm_flg                              --农户标志
   ,agclt_flg                             --涉农标志
   ,int_accr_flg                          --计息标志
   ,comp_int_flg                          --复息标志
   ,ovdue_flg                             --逾期标志
   ,wrt_off_flg                           --核销标志
   ,pbc_inc_loan_flg                      --人行普惠贷款标志
   ,cred_rht_turn_flg                     --债权直转标志
   ,regroup_flg                           --重组标志
   ,regroup_loan_type_cd                  --重组贷款类型代码
   ,regroup_dt                            --重组日期
   ,open_acct_dt                          --开户日期
   ,distr_dt                              --放款日期
   ,init_distr_dt                         --原始放款日期
   ,value_dt                              --起息日期
   ,exp_dt                                --到期日期
   ,init_exp_dt                           --原始到期日期
   ,payoff_dt                             --结清日期
   ,last_repay_dt                         --上次还款日期
   ,next_repay_dt                         --下次还款日期
   ,curr_int_rat_effect_dt                --当前利率生效日期
   ,next_int_rat_adj_dt                   --下次利率调整日期
   ,cust_mgr_id                           --客户经理编号
   ,open_acct_org_id                      --开户机构编号
   ,mgmt_org_id                           --管理机构编号
   ,acct_instit_id                        --账务机构编号
   ,init_tot_perds                        --原始贷款期数
   ,tot_perds                             --贷款期数
   ,curr_issue_perds                      --当前期数
   ,surp_perds                            --剩余期数
   ,ovdue_perds                           --逾期期数
   ,pric_ovdue_days                       --本金逾期天数
   ,int_ovdue_days                        --利息逾期天数
   ,grace_period_days                     --宽限期天数
   ,inst_comm_fee_rat                     --分期手续费费率
   ,base_rat                              --基准利率
   ,exec_int_rat                          --执行利率
   ,ovdue_int_rat                         --逾期利率
   ,daily_exec_int_rat                    --每日执行利率
   ,int_rat                               --固收利率
   ,cont_amt                              --合同金额
   ,dubil_amt                             --借据金额
   ,distr_amt                             --放款金额
   ,init_distr_amt                        --原始放款金额
   ,bank_contri_ratio                     --银行出资比例
   ,td_acru_int                           --当日应计利息
   ,currt_acru_int                        --当期应计利息
   ,nomal_pric                            --正常本金
   ,ovdue_pric                            --逾期本金
   ,idle_pric                             --呆滞本金
   ,bad_debt_pric                         --呆账本金
   ,wrt_off_pric                          --核销本金
   ,nomal_int                             --正常利息
   ,ovdue_int                             --逾期利息
   ,wrt_off_int                           --核销利息
   ,ovdue_pric_pnlt                       --逾期本金罚息
   ,ovdue_int_pnlt                        --逾期利息罚息
   ,recvbl_over_int                       --应收欠息
   ,recvbl_acru_pnlt                      --应收应计罚息
   ,recvbl_pnlt                           --应收罚息
   ,recvbl_fee                            --应收费用
   ,in_bs_over_int_bal                    --表内欠息余额
   ,off_bs_over_int_bal                   --表外欠息余额
   ,in_bs_int                             --表内利息
   ,off_bs_int                            --表外利息
   ,acm_recvbl_uncol_int_amt              --累计应收未收利息金额
   ,repaid_nomal_pric                     --已偿还正常本金
   ,repaid_ovdue_pric                     --已偿还逾期本金
   ,repaid_nomal_int                      --已偿还正常利息
   ,repaid_ovdue_int                      --已偿还逾期利息
   ,repaid_ovdue_pric_pnlt                --已偿还逾期本金罚息
   ,repaid_ovdue_int_pnlt                 --已偿还逾期利息罚息
   ,repaid_fee                            --已偿还费用
   ,pric_bal                              --本金余额
   ,currt_bal                             --当期余额
   ,cl_curr_currt_bal                     --折本币当期余额
   ,job_cd                                --任务代码
   ,etl_timestamp                         --etl处理时间戳
)
select
   to_date('${batch_date}','yyyymmdd')  -- 数据日期
   ,t1.lp_id                            -- 法人编号
   ,t1.dubil_id                         -- 借据编号
   ,t1.dubil_id                         -- 核心借据编号
   ,''                                  -- 合同编号
   ,t15.prod_id                         -- 标准产品编号
   ,t15.prod_id                         -- 产品编号
   ,t1.cust_id                          -- 客户编号
   ,'13030203'                          -- 科目编号
   ,''                                  -- 会计类别代码
   ,t1.dubil_id                         -- 入账账号
   ,t2.apot_repay_deduct_acct_num       -- 还款账号
   ,t1.cust_lmt_id                      -- 关联协议编号
   ,t1.cust_lmt_id                      -- 关联申请流水号
   ,'CNY'                               -- 币种代码
   ,'0900600100001'                     -- 业务品种编号
   ,t1.loan_type_cd                     -- 贷款类型代码
   ,''                    --行内贷款类型代码
   ,t33.agt_status_cd                   -- 资产三分类代码
   ,nvl(t10.agt_status_cd, t1.loan_status_cd)  -- 借据状态代码
   ,'000000'                            -- 贷款用途代码
   ,'F'                                 -- 贷款贷款贷款投向行业代码
   ,case when ${iml_schema}.dateformat_max(t18.imp_dt) <> ${iml_schema}.dateformat_max('') then 'CLEAR'
 --        when nvl(t25.ovd_status, 0) = '1' then 'OVD'
         when t25.intnal_dubil_id is not null then 'OVD'
         else 'NORMAL'
    end                                 -- 合同状态代码
   ,'00'                                -- 贷款四级分类代码
   ,(case when nvl(t12.pric_ovdue_days, 0) = 0 then '10'
           when nvl(t12.pric_ovdue_days, 0) >= 1 and   nvl(t12.pric_ovdue_days, 0) <= 89 then '20'
           when nvl(t12.pric_ovdue_days, 0) >= 90 and  nvl(t12.pric_ovdue_days, 0) <= 120 then '30'
           when nvl(t12.pric_ovdue_days, 0) >= 121 and nvl(t12.pric_ovdue_days, 0) <= 180 then '40'
           when nvl(t12.pric_ovdue_days, 0) >= 181 then '50'
           else '99'
     end) as loan_level5_cls_cd     -- 贷款五级分类代码
   ,(case when nvl(t12.pric_ovdue_days, 0) = 0 then '15'
          when nvl(t12.pric_ovdue_days, 0) >= 1 and  nvl(t12.pric_ovdue_days, 0) <= 59  then '21'
          when nvl(t12.pric_ovdue_days, 0) >= 60 and nvl(t12.pric_ovdue_days, 0) <= 89 then '22'
          when nvl(t12.pric_ovdue_days, 0) >= 90 and nvl(t12.pric_ovdue_days, 0) <= 120 then '30'
          when nvl(t12.pric_ovdue_days, 0)>= 121 and nvl(t12.pric_ovdue_days, 0) <= 180 then '40'
          when nvl(t12.pric_ovdue_days, 0) >= 181 then '50'
          else '90'
     end) as loan_level10_cls_cd   -- 贷款十级分类代码
   ,'11'                           -- 贷款十二级分类代码
   ,(case when (nvl(t9.bal, 0) + nvl(t7.loan_bal_principal, 0)) = 0 then '1'
          when t122.tran_ref_no is not null then '2' else '0'    end)    -- 应计非应计代码
   ,'2'                                         -- 还款方式代码
   ,'01'                                        -- 结息方式代码
   ,'AB'                                        -- 计息方式代码
   ,'0'                                         -- 利率调整方式代码
   ,'O'                                         -- 利率调整周期单位代码
   ,'0'                                         -- 利率调整周期频率
   ,case when t1.loan_rgst_dt > to_date('20191011','yyyymmdd')
         then '2231'    else '4000' end                             -- 利率基准类型代码'230' modify20210618
   ,case when t1.loan_rgst_dt > to_date('20191011','yyyymmdd')
         then '1'    else '9' end                             -- 利率浮动方式代码nvl(t8.int_rat_float_way_cd, '-') modify20210618
   ,'-'                                      -- 利率浮动方向代码
   ,case when t1.loan_rgst_dt >to_date('20191011','yyyymmdd')
         then t8.exec_int_rat- t28.currt_lpr_val
   else to_number('0') end                     -- 利率浮动值nvl(t8.int_rat_float_point, 0.00)  modify20210618
   ,'03'                                        -- 本金还款周期频率
   ,'03'                                        -- 利息还款周期频率
   ,'D'                                         -- 担保方式代码
   ,'-'                                         -- 客户性质代码
   ,'01'                                        -- 入账账号类型
   ,''                                          -- 入账账户开户银行名称
   ,'01'                                        -- 还款账号类型
   ,''                                          -- 还款账户开户银行编号
   ,''                                          -- 还款账户开户机构名称
   ,'0'                                         -- 内部结转标志
   ,'1'                                         -- 境内外标志
   ,'-'                                         -- 白户标志
   ,'-'                                         -- 农户标志
   ,'-'
   ,(case when (nvl(t9.bal, 0) + nvl(t7.loan_bal_principal, 0)) = 0 then '0'
          when t122.tran_ref_no is not null then '0'
          else '1'    end)                                        -- 计息标志
   ,'0'                                         -- 复息标志
   ,case when t25.intnal_dubil_id is not null then '1' else '0' end   -- 逾期标志
   ,(case when t122.tran_ref_no is not null then '1' else '0' end)   -- 核销标志
   ,''                                          -- 人行普惠贷款标志
   ,'0'                                         -- 债权直转标志
   ,''                                          -- 重组标志
   ,''                                          -- 重组贷款类型代码
   ,''                                          -- 重组日期
   ,t1.loan_rgst_dt                             -- 开户日期
   ,t1.loan_rgst_dt                             -- 放款日期
   ,t1.loan_rgst_dt                             -- 原始放款日期
   ,t1.loan_rgst_dt                             -- 起息日期
   ,t1.loan_exp_dt                              -- 到期日期
   ,t1.loan_exp_dt                              -- 原始到期日期
   ,t18.imp_dt                                  -- 结清日期
   ,${iml_schema}.dateformat_min(t16.imp_dt)    -- 上次还款日期
   ,${iml_schema}.dateformat_max(t17.imp_dt)    -- 下次还款日期
   ,t1.loan_rgst_dt                             -- 当前利率生效日期
   ,t19.imp_dt                                  -- 下次利率调整日期
   ,t30.cust_mgr_id                             -- 客户经理编号
   ,'897001'                                    -- 开户机构编号
   ,'897001'                                    -- 管理机构编号
   ,'897001'                                    -- 账务机构编号
   ,t1.loan_tot_perds                           -- 原始贷款期数
   ,case when t1.b_renew_tot_perds > 0
         then t1.b_renew_tot_perds
    else t1.loan_tot_perds end                  -- 贷款期数t1.loan_tot_perds         --modify20210618
   ,t1.curr_perds                               -- 当前期数
   ,t1.surp_perds                               -- 剩余期数
   ,t1.loan_ovdue_max_perds                     -- 逾期期数
   ,nvl(t12.pric_ovdue_days, 0)                 -- 本金逾期天数
   ,nvl(t12.pric_ovdue_days, 0)                 -- 利息逾期天数
   ,1                                           -- 宽限期天数
   ,0                                           -- 分期手续费费率
   ,case when t1.loan_rgst_dt > to_date('20191011','yyyymmdd')
         then to_char(t28.currt_lpr_val)
    else to_char(nvl(t1.exec_int_rat, 0)) end   -- 基准利率nvl(t8.exec_int_rat, 0) --modify20210618
   ,nvl(t8.exec_int_rat, 0)                     -- 执行利率
   ,nvl(t1.pnlt_int_rat, 0)                     -- 逾期利率
   ,nvl((t8.exec_int_rat / 360), 0)             -- 每日执行利率
   ,0                                           -- 固收利率
   ,nvl(t1.loan_pric,0) * t11.ratio             -- 合同金额
   ,nvl(t1.loan_pric,0) * t11.ratio             -- 借据金额
   ,nvl(t26.amt,0) * t11.ratio                  -- 放款金额
   ,nvl(t26.amt,0) * t11.ratio                  -- 原始放款金额
   ,nvl(t11.ratio, 1)                           -- 银行出资比例
   ,nvl(t9.bal,0) * t11.ratio * nvl(t8.exec_int_rat, 0)/360                                               --当日应计利息
   ,nvl(t3.curr_accrued_int, 0) * nvl(t11.ratio, 0)                                                       --当期应计利息
   ,case when nvl(t12.pric_ovdue_days, 0) > 0
         then 0
         else ((nvl(t9.bal, 0) + nvl(t7.loan_bal_principal, 0)) * nvl(t11.ratio,0)) end                   --正常本金
   ,case when nvl(t12.pric_ovdue_days, 0) > 0 and nvl(t12.pric_ovdue_days, 0) <= 90 and t122.tran_ref_no is null
         then ((nvl(t9.bal, 0) + nvl(t7.loan_bal_principal, 0)) * nvl(t11.ratio, 0))
         else 0 end                                                                                       --逾期本金
   ,case when nvl(t12.pric_ovdue_days, 0) > 90 and t122.tran_ref_no is null
         then ((nvl(t9.bal, 0) + nvl(t7.loan_bal_principal, 0)) * nvl(t11.ratio, 0))
         else 0 end                                                      --呆滞本金
   ,0                                                                                                     --呆账本金
   ,case when t122.tran_ref_no is not null
         then ((nvl(t9.bal, 0) + nvl(t7.loan_bal_principal, 0)) * nvl(t11.ratio, 0))
         else 0 end                                                                                       --核销本金
   ,case when nvl(t12.pric_ovdue_days, 0) > 0
         then 0
         else (nvl(t7.loan_bal_interest, 0) * nvl(t11.ratio, 0)) end                                      --正常利息
   ,case when nvl(t12.pric_ovdue_days, 0) > 0 and nvl(t12.pric_ovdue_days, 0) <= 90
         then (nvl(t7.loan_bal_interest, 0) + nvl(t7.loan_bal_principal,0)) * nvl(t11.ratio, 0)
         else 0 end                         --逾期利息
   ,case when t122.tran_ref_no is not null
         then (nvl(t7.loan_bal_interest, 0) + nvl(t7.loan_bal_penalty, 0)) * nvl(t11.ratio, 0)
         else 0 end                        --核销利息
   ,case when nvl(t12.pric_ovdue_days, 0) > 0 and nvl(t12.pric_ovdue_days, 0) <= 90
         then nvl(t7.loan_bal_penalty, 0) * nvl(t11.ratio, 0)
         else 0 end                                                                                       --逾期本金罚息
   ,0                                                                                                     --逾期利息罚息
   ,t7.loan_bal_interest * nvl(t11.ratio, 0)                                                              --应收欠息
   ,t7.loan_bal_penalty * nvl(t11.ratio, 0)                                                               --应收应计罚息
   ,t7.loan_bal_penalty * nvl(t11.ratio, 0)                                                               --应收罚息
   ,t1.loan_unexp_comm_fee * nvl(t11.ratio, 0)                                                            --应收费用
   ,case when nvl(t12.pric_ovdue_days, 0) < 90 then nvl(t7.loan_bal_interest, 0) * nvl(t11.ratio, 0) else 0 end  --表内欠息余额
   ,case when nvl(t12.pric_ovdue_days, 0) >= 90 then nvl(t7.loan_bal_interest, 0) * nvl(t11.ratio, 0) else 0 end   --表外欠息余额
   ,case when nvl(t12.pric_ovdue_days, 0) < 90 then (nvl(t7.loan_bal_interest, 0) + nvl(t7.loan_bal_penalty, 0)) * nvl(t11.ratio, 0) else 0 end   --表内利息
   ,case when nvl(t12.pric_ovdue_days, 0) >= 90 then (nvl(t7.loan_bal_interest, 0) + nvl(t7.loan_bal_penalty, 0)) * nvl(t11.ratio, 0) else 0 end    --表外利息
   ,(nvl(t7.loan_bal_interest, 0) + nvl(t7.loan_bal_penalty, 0)) * nvl(t11.ratio, 0)                  --累计应收未收利息金额
   ,t4.paid_normal_prin * nvl(t11.ratio, 0)                                                           --已偿还正常本金
   ,t4.paid_ovdue_prin * nvl(t11.ratio, 0)                                                            --已偿还逾期本金
   ,t4.paid_normal_int * nvl(t11.ratio, 0)                                                            --已偿还正常利息
   ,t4.paid_ovdue_int * nvl(t11.ratio, 0)                                                             --已偿还逾期利息
   ,t4.paid_ovdue_prin_pnlt * nvl(t11.ratio, 0)                                                       --已偿还逾期本金罚息
   ,t4.paid_ovdue_int_pnlt * nvl(t11.ratio, 0)                                                        --已偿还逾期利息罚息
   ,t4.paid_cost * nvl(t11.ratio, 0)                                                                  --已偿还费用
   ,((nvl(t9.bal, 0) + nvl(t7.loan_bal_principal, 0)) * nvl(t11.ratio, 0))                            --本金余额
   ,((nvl(t9.bal, 0) + nvl(t7.loan_bal_principal, 0)) * nvl(t11.ratio, 0))                            --当期余额
   ,((nvl(t9.bal, 0) + nvl(t7.loan_bal_principal, 0)) * nvl(t11.ratio, 0)) * nvl(t5.convt_cny_exch_rat, 1)--折本币当期余额
   ,t1.job_cd                                                                                             -- 任务代码
   ,to_timestamp('${batch_timestamp}','yyyy-mm-dd hh24:mi:ss.ff6')
from ${icl_schema}.tmp_cmm_unite_wl_dubil_info_clear_30 t1
   inner join ${iml_schema}.agt_wld_acct t2
      on t1.acct_id = t2.acct_id
     and t1.acct_type_cd = t2.acct_type_cd
     and t2.create_dt <= to_date('${batch_date}', 'yyyymmdd')
     and t2.job_cd = 'mpcsf1'
     and t2.id_mark <> 'D'
left join ${iml_schema}.agt_wld_dubil_attach_info t28
       on t28.tran_ref_no = t1.tran_ref_no
      /*and substr(t1.batch_doc_name,3,8) = substr(t28.batch_doc_name,48,8)*/
      and t28.start_dt <= to_date('${batch_date}','yyyymmdd')
      and t28.end_dt   >  to_date('${batch_date}','yyyymmdd')
      and t28.job_cd='mpcsi1'
   left join ${iml_schema}.agt_int_org_rela_h t11
      on t1.agt_id = t11.agt_id
     and t11.agt_int_org_type_cd = '04'
     and t11.start_dt <= to_date('${batch_date}', 'yyyymmdd')
     and t11.end_dt > to_date('${batch_date}', 'yyyymmdd')
     and t11.job_cd = 'mpcsf1'
   left join ${icl_schema}.tmp_cmm_unite_wl_dubil_info_clear_12 t7
     on t7.agt_id = t1.agt_id
   left join ${iml_schema}.agt_int_rat_h t8
     on t1.agt_id = t8.agt_id
     and t8.int_rat_type_cd = '003001'
     and t8.start_dt <= to_date('${batch_date}', 'yyyymmdd')
     and t8.end_dt > to_date('${batch_date}', 'yyyymmdd')
     and t8.job_cd = 'mpcsf1'
   left join ${iml_schema}.agt_bal_h t9
     on t1.agt_id = t9.agt_id
     and t9.bal_type_cd = '003004'
     and t9.start_dt <= to_date('${batch_date}', 'yyyymmdd')
     and t9.end_dt > to_date('${batch_date}', 'yyyymmdd')
     and t9.job_cd = 'mpcsf1'
   left join ${iml_schema}.agt_status_h t10
     on t1.agt_id = t10.agt_id
     and t10.agt_status_type_cd = 'CD1261'
     and t10.start_dt <= to_date('${batch_date}', 'yyyymmdd')
     and t10.end_dt > to_date('${batch_date}', 'yyyymmdd')
     and t10.job_cd = 'mpcsf1'
   left join ${iml_schema}.agt_status_h t33
     on t1.agt_id = t33.agt_id
     and t33.agt_status_type_cd = 'CD2060'
     and t33.start_dt <= to_date('${batch_date}', 'yyyymmdd')
     and t33.end_dt > to_date('${batch_date}', 'yyyymmdd')
     and t33.job_cd = 'mpcsf1'
   left join ${iml_schema}.agt_loan_ovdue_h t12
      on t1.agt_id = t12.agt_id
     and t12.start_dt <= to_date('${batch_date}', 'yyyymmdd')
     and t12.end_dt > to_date('${batch_date}', 'yyyymmdd')
     and t12.job_cd = 'mpcsf1'
   left join ${icl_schema}.tmp_cmm_unite_wl_dubil_info_clear_10 t3
     on t1.intnal_dubil_id = t3.intnal_dubil_id
     and t1.curr_perds = t3.curr_perds
   left join ${icl_schema}.tmp_cmm_unite_wl_dubil_info_clear_11 t4
     on t1.intnal_dubil_id = t4.intnal_dubil_id
   left join ${icl_schema}.tmp_cmm_unite_wl_dubil_info_clear_25 t25
     on t1.intnal_dubil_id = t25.intnal_dubil_id
   left join ${iml_schema}.ref_cny_fori_exch_mdl_p_h t5
     on t5.curr_cd = 'CNY'
    -- and t5.dt = to_date('${batch_date}', 'yyyymmdd')
     and t5.start_dt <= to_date('${batch_date}', 'yyyymmdd')
     and t5.end_dt > to_date('${batch_date}', 'yyyymmdd')
     and t5.id_mark <> 'D'
     and t5.job_cd = 'ncbsf1'
   left join (select distinct tran_ref_no 
                  from ${iml_schema}.evt_wld_dubil_wrt_off t where t.wrt_off_status_cd = 'CheckPass'
          and t.etl_dt <= to_date('${batch_date}', 'yyyymmdd')
          and t.job_cd = 'mpcsi1') t122
     on t1.tran_ref_no = t122.tran_ref_no
   left join ${iml_schema}.agt_prod_rela_h t15
     on t1.agt_id = t15.agt_id
    and t15.start_dt <= to_date('${batch_date}','yyyymmdd')
    and t15.end_dt > to_date('${batch_date}','yyyymmdd')
    and t15.job_cd = 'mpcsf1'
   left join ${iml_schema}.agt_imp_dt_h t16
     on t2.agt_id = t16.agt_id
    and t16.dt_type_cd = '36'
    and t16.start_dt <= to_date('${batch_date}', 'yyyymmdd')
    and t16.end_dt > to_date('${batch_date}', 'yyyymmdd')
    and t16.job_cd = 'mpcsf1'
   left join ${iml_schema}.agt_imp_dt_h t17
     on t2.agt_id = t17.agt_id
    and t17.dt_type_cd = '38'
    and t17.start_dt <= to_date('${batch_date}', 'yyyymmdd')
    and t17.end_dt > to_date('${batch_date}', 'yyyymmdd')
    and t17.job_cd = 'mpcsf1'
   left join ${iml_schema}.agt_imp_dt_h t18
     on t1.agt_id = t18.agt_id
    and t18.dt_type_cd = '03'
    and t18.start_dt <= to_date('${batch_date}', 'yyyymmdd')
    and t18.end_dt > to_date('${batch_date}', 'yyyymmdd')
    and t18.job_cd = 'mpcsf1'
   left join ${iml_schema}.agt_imp_dt_h t19
     on t1.agt_id = t19.agt_id
    and t19.dt_type_cd = '40'
    and t19.start_dt <= to_date('${batch_date}', 'yyyymmdd')
    and t19.end_dt > to_date('${batch_date}', 'yyyymmdd')
    and t19.job_cd = 'mpcsf1'
   left join ${iml_schema}.agt_amt_h t26
     on t1.agt_id = t26.agt_id
    and t26.amt_type_cd = '001005'
    and t26.start_dt <= to_date('${batch_date}', 'yyyymmdd')
    and t26.end_dt > to_date('${batch_date}', 'yyyymmdd')
    and t26.job_cd = 'mpcsf1'
    and t26.id_mark <> 'D'
   left join ${iml_schema}.prd_prod_cust_mgr_rela_h t30
     on t30.prod_id = '202010100003'  -- 微粒贷客户经理，新信贷暂未配置微粒贷客户经理编号
    and t30.start_dt <= to_date('${batch_date}','yyyymmdd')
    and t30.end_dt > to_date('${batch_date}','yyyymmdd')
    and t30.job_cd = 'icmsf1'
where 1=1
;
commit;

create table ${icl_schema}.tmp_cmm_unite_wl_dubil_info_clear_13
nologging
compress ${option_switch} for query high
as
select t1.dubil_id,
       sum(nvl(t1.paid_tot_amt, 0)) as paid_amt, -- 已偿还金额
       sum(nvl(t1.paid_nomal_pric, 0)) as paid_normal_prin, -- 已偿还正常本金
       sum(nvl(t1.paid_nomal_pric, 0)) as paid_ovdue_prin, -- 已偿还逾期本金
       sum(nvl(t1.paid_nomal_int, 0)) as paid_normal_int, -- 已偿还逾期本金
       sum(nvl(t1.paid_ovdue_int, 0)) as paid_ovdue_int, -- 已偿还逾期利息
       sum(nvl(t1.paid_ovdue_pric_pnlt, 0)) as paid_ovdue_prin_pnlt, -- 已偿还逾期本金罚息
       sum(nvl(t1.paid_ovdue_int_pnlt, 0)) as paid_ovdue_int_pnlt, -- 已偿还逾期利息罚息
       sum(nvl(t1.plat_serv_fee_amt, 0)) as paid_cost, -- 已偿还费用
       max(t1.repay_dt) as last_repay_dt -- 上次还款日期
  from ${iml_schema}.evt_ajb_ped_3_repay_dtl t1
 where trunc(t1.repay_dt) <= to_date('${batch_date}','yyyymmdd')
   and t1.job_cd = 'myjbi3'
 group by t1.dubil_id
;
commit;

create table ${icl_schema}.tmp_cmm_unite_wl_dubil_info_clear_14
nologging
compress ${option_switch} for query high
as
select jb32.dubil_id,
       (case when min(jb32.pric_turn_ovdue_dt) = to_date('29991231','yyyymmdd') then null else min(jb32.pric_turn_ovdue_dt) end) as prin_earliest_ovdue_dt, -- 首次本金逾期日期
       (case when min(jb32.int_turn_ovdue_dt) = to_date('29991231','yyyymmdd') then null else min(jb32.int_turn_ovdue_dt) end)  as int_earliest_ovdue_dt,   -- 首次利息逾期日期
       case /*when max(jb32.pric_ovdue_days) = '0' then 0*/
            when min(jb32.pric_turn_ovdue_dt) = date'2999-12-31' then 0
            /*when to_date('${batch_date}','yyyymmdd') - trunc(min(jb32.pric_turn_ovdue_dt)) - max(jb32.pric_ovdue_days) <> 0 then max(jb32.pric_ovdue_days)*/
       else to_date('${batch_date}','yyyymmdd') - trunc(min(jb32.pric_turn_ovdue_dt))+1 end as prin_ovdue_days, -- 本金逾期天数
       case /*when max(jb32.int_ovdue_days) = '0'  then 0*/
            when min(jb32.int_turn_ovdue_dt) =  date'2999-12-31' then 0
            /*when to_date('${batch_date}','yyyymmdd') - trunc(min(jb32.int_turn_ovdue_dt)) - max(jb32.int_ovdue_days) <> 0 then max(jb32.int_ovdue_days)*/
       else to_date('${batch_date}','yyyymmdd') - trunc(min(jb32.int_turn_ovdue_dt)) +1 end as int_ovdue_days   -- 利息逾期天数
  from ${iml_schema}.agt_ajb_ped_3_repay_plan_h jb32
 where jb32.start_dt <= to_date('${batch_date}','yyyymmdd')
   and jb32.end_dt > to_date('${batch_date}','yyyymmdd')
   and jb32.inst_status_cd = 'OVD'
   and jb32.job_cd = 'myjbf3'
 group by jb32.dubil_id
;
commit;

-- 第五组（共九组）借呗三期
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ into ${icl_schema}.cmm_unite_wl_dubil_info_clear_ex(
   etl_dt                                 --数据日期
   ,lp_id                                 --法人编号
   ,dubil_id                              --借据编号
   ,core_dubil_id                         --核心借据编号
   ,cont_id                               --合同编号
   ,std_prod_id                           --标准产品编号
   ,prod_id                               --产品编号
   ,cust_id                               --客户编号
   ,subj_id                               --科目编号
   ,acctnt_cate_cd                        --会计类别代码
   ,enter_acct_acct_num                   --入账账号
   ,repay_num                             --还款账号
   ,rela_agt_id                           --关联协议编号
   ,rela_appl_flow_num                    --关联申请流水号
   ,curr_cd                               --币种代码
   ,bus_breed_id                          --业务品种编号
   ,loan_type_cd                          --贷款类型代码
   ,intnal_loan_type_cd                    --行内贷款类型代码
   ,asset_thd_cls_cd                      --资产三分类
   ,dubil_status_cd                       --借据状态代码
   ,loan_usage_cd                         --贷款用途代码
   ,dir_indus_cd                          --贷款贷款贷款投向行业代码
   ,cont_status_cd                        --合同状态代码
   ,loan_level4_cls_cd                    --贷款四级分类代码
   ,loan_level5_cls_cd                    --贷款五级分类代码
   ,loan_level10_cls_cd                   --贷款十级分类代码
   ,loan_level12_cls_cd                   --贷款十二级分类代码
   ,acru_non_acru_cd                      --应计非应计代码
   ,repay_way_cd                          --还款方式代码
   ,int_set_way_cd                        --结息方式代码
   ,int_accr_way_cd                       --计息方式代码
   ,int_rat_adj_way_cd                    --利率调整方式代码
   ,int_rat_adj_ped_corp_cd               --利率调整周期单位代码
   ,int_rat_adj_ped_freq                  --利率调整周期频率
   ,int_rat_base_type_cd                  --利率基准类型代码
   ,int_rat_float_way_cd                  --利率浮动方式代码
   ,int_rat_float_dir_cd                  --利率浮动方向代码
   ,int_rat_flo_val                       --利率浮动值
   ,pric_repay_freq_cd                    --本金还款周期频率
   ,int_repay_freq_cd                     --利息还款周期频率
   ,guar_way_cd                           --担保方式代码
   ,cust_char_cd                          --客户性质代码
   ,enter_acct_acct_num_type              --入账账号类型
   ,enter_acct_bank_name                  --入账账户开户银行名称
   ,repay_num_type                        --还款账号类型
   ,repay_open_acct_bank_id               --还款账户开户银行编号
   ,repay_open_acct_org_name              --还款账户开户机构名称
   ,intnal_carr_flg                       --内部结转标志
   ,dom_overs_flg                         --境内外标志
   ,white_list_cust_flg                   --白户标志
   ,farm_flg                              --农户标志
   ,agclt_flg                             --涉农标志
   ,int_accr_flg                          --计息标志
   ,comp_int_flg                          --复息标志
   ,ovdue_flg                             --逾期标志
   ,wrt_off_flg                           --核销标志
   ,pbc_inc_loan_flg                      --人行普惠贷款标志
   ,cred_rht_turn_flg                     --债权直转标志
   ,regroup_flg                           --重组标志
   ,regroup_loan_type_cd                  --重组贷款类型代码
   ,regroup_dt                            --重组日期
   ,open_acct_dt                          --开户日期
   ,distr_dt                              --放款日期
   ,init_distr_dt                         --原始放款日期
   ,value_dt                              --起息日期
   ,exp_dt                                --到期日期
   ,init_exp_dt                           --原始到期日期
   ,payoff_dt                             --结清日期
   ,last_repay_dt                         --上次还款日期
   ,next_repay_dt                         --下次还款日期
   ,curr_int_rat_effect_dt                --当前利率生效日期
   ,next_int_rat_adj_dt                   --下次利率调整日期
   ,cust_mgr_id                           --客户经理编号
   ,open_acct_org_id                      --开户机构编号
   ,mgmt_org_id                           --管理机构编号
   ,acct_instit_id                        --账务机构编号
   ,init_tot_perds                        --原始贷款期数
   ,tot_perds                             --贷款期数
   ,curr_issue_perds                      --当前期数
   ,surp_perds                            --剩余期数
   ,ovdue_perds                           --逾期期数
   ,pric_ovdue_days                       --本金逾期天数
   ,int_ovdue_days                        --利息逾期天数
   ,grace_period_days                     --宽限期天数
   ,inst_comm_fee_rat                     --分期手续费费率
   ,base_rat                              --基准利率
   ,exec_int_rat                          --执行利率
   ,ovdue_int_rat                         --逾期利率
   ,daily_exec_int_rat                    --每日执行利率
   ,int_rat                               --固收利率
   ,cont_amt                              --合同金额
   ,dubil_amt                             --借据金额
   ,distr_amt                             --放款金额
   ,init_distr_amt                        --原始放款金额
   ,bank_contri_ratio                     --银行出资比例
   ,td_acru_int                           --当日应计利息
   ,currt_acru_int                        --当期应计利息
   ,nomal_pric                            --正常本金
   ,ovdue_pric                            --逾期本金
   ,idle_pric                             --呆滞本金
   ,bad_debt_pric                         --呆账本金
   ,wrt_off_pric                          --核销本金
   ,nomal_int                             --正常利息
   ,ovdue_int                             --逾期利息
   ,wrt_off_int                           --核销利息
   ,ovdue_pric_pnlt                       --逾期本金罚息
   ,ovdue_int_pnlt                        --逾期利息罚息
   ,recvbl_over_int                       --应收欠息
   ,recvbl_acru_pnlt                      --应收应计罚息
   ,recvbl_pnlt                           --应收罚息
   ,recvbl_fee                            --应收费用
   ,in_bs_over_int_bal                    --表内欠息余额
   ,off_bs_over_int_bal                   --表外欠息余额
   ,in_bs_int                             --表内利息
   ,off_bs_int                            --表外利息
   ,acm_recvbl_uncol_int_amt              --累计应收未收利息金额
   ,repaid_nomal_pric                     --已偿还正常本金
   ,repaid_ovdue_pric                     --已偿还逾期本金
   ,repaid_nomal_int                      --已偿还正常利息
   ,repaid_ovdue_int                      --已偿还逾期利息
   ,repaid_ovdue_pric_pnlt                --已偿还逾期本金罚息
   ,repaid_ovdue_int_pnlt                 --已偿还逾期利息罚息
   ,repaid_fee                            --已偿还费用
   ,pric_bal                              --本金余额
   ,currt_bal                             --当期余额
   ,cl_curr_currt_bal                     --折本币当期余额
   ,job_cd                                --任务代码
   ,etl_timestamp                         --etl处理时间戳
)
select
   to_date('${batch_date}','yyyymmdd')                                              --数据日期
   ,t1.lp_id                                                                         --法人编号
   ,t1.dubil_id                                                                      --借据编号
   ,t1.dubil_id                                                                      -- 核心借据编号
   ,''                                                                               --合同编号
   ,t16.prod_id                                                                      --标准产品编号
   ,t16.prod_id                                                                     --产品编号
   ,t1.cust_id                                                                      --客户编号
   ,'13030203'                                                                       --科目编号
   ,''                                                                               --会计类别代码
    ,t1.recvbl_acct_id                                                              --入账账号
    ,t1.repay_acct_id                                                                --还款账号
    ,t15.rela_agt_id                                                                --关联协议编号
    ,t15.rela_agt_id                                                                 --关联申请流水号
    ,nvl(t1.curr_cd, 'CNY')                                                          --币种代码
    ,'02001004165051'                                                                --业务品种编号
    ,'00'                                                                            --贷款类型代码
   ,''                    --行内贷款类型代码
    ,t33.agt_status_cd                                                               --资产三分类代码
    ,nvl(t14.agt_status_cd,t1.loan_status_cd)                                        --借据状态代码
    ,t1.loan_usage_cd                                                                --贷款用途代码
    ,'F'                                                                            --贷款贷款贷款投向行业代码
    ,nvl(t9.agt_status_cd, t1.cont_status_cd)                                        --合同状态代码
    ,'00'                                                                            --贷款四级分类代码
    ,(case when greatest(nvl(t5.prin_ovdue_days,0),nvl(t5.int_ovdue_days,0)) =0 then '10'
           when greatest(nvl(t5.prin_ovdue_days,0),nvl(t5.int_ovdue_days,0)) >=1 and greatest(nvl(t5.prin_ovdue_days,0),nvl(t5.int_ovdue_days,0))<=89 then '20'
           when greatest(nvl(t5.prin_ovdue_days,0),nvl(t5.int_ovdue_days,0)) >=90 and greatest(nvl(t5.prin_ovdue_days,0),nvl(t5.int_ovdue_days,0))<=120 then '30'
           when greatest(nvl(t5.prin_ovdue_days,0),nvl(t5.int_ovdue_days,0))>=121 and greatest(nvl(t5.prin_ovdue_days,0),nvl(t5.int_ovdue_days,0))<=180 then '40'
           when greatest(nvl(t5.prin_ovdue_days,0),nvl(t5.int_ovdue_days,0))>=181 then '50' end) as loan_level5_cls_cd                   --贷款五级分类代码
    ,(case when greatest(nvl(t5.prin_ovdue_days,0),nvl(t5.int_ovdue_days,0)) =0 then '15'
           when greatest(nvl(t5.prin_ovdue_days,0),nvl(t5.int_ovdue_days,0)) >=1 and greatest(nvl(t5.prin_ovdue_days,0),nvl(t5.int_ovdue_days,0)) <=59  then '21'
           when greatest(nvl(t5.prin_ovdue_days,0),nvl(t5.int_ovdue_days,0)) >=60 and greatest(nvl(t5.prin_ovdue_days,0),nvl(t5.int_ovdue_days,0)) <=89  then '22'
           when greatest(nvl(t5.prin_ovdue_days,0),nvl(t5.int_ovdue_days,0)) >=90 and greatest(nvl(t5.prin_ovdue_days,0),nvl(t5.int_ovdue_days,0)) <=120 then '30'
           when greatest(nvl(t5.prin_ovdue_days,0),nvl(t5.int_ovdue_days,0))>=121 and greatest(nvl(t5.prin_ovdue_days,0),nvl(t5.int_ovdue_days,0))<=180  then '40'
           when greatest(nvl(t5.prin_ovdue_days,0),nvl(t5.int_ovdue_days,0))>=181 then '50' else '90' end ) as loan_level10_cls_cd       --贷款十级分类代码
    ,'11'                                                                                              --贷款十二级分类代码
    ,nvl(trim(t1.acru_non_acru_flg),'0')                                                              --应计非应计代码
    ,nvl(trim(t1.repay_way_cd),'-')                                                                    --还款方式代码
    ,'08'                                                                                              --结息方式代码
    ,'AB'                                                                                              --计息方式代码
    ,t1.int_rat_adj_way_cd                                                                            --利率调整方式代码
    ,decode(t1.int_rat_adj_way_cd, 'L0', 'D', 'L1', 'W', 'L2', 'M', 'L3', 'Q', 'L4', 'M', 'L5', 'Y', 'O')   --利率调整周期单位代码
    ,case when t1.int_rat_adj_way_cd = 'L4' then 6 when t1.int_rat_adj_way_cd in ('L0', 'L1', 'L2', 'L3', 'L5') then 1 else 0 end  --利率调整周期频率
    ,t1.base_rat_type_cd                                                                              --利率基准类型代码
    ,case when t1.base_rat_type_cd='2231' then '1' else '-' end                                        --利率浮动方式代码
    ,t1.int_rat_float_dir_cd                                                                           --利率浮动方向代码
    ,t13.int_rat_float_point                                                                           --利率浮动值
    ,t1.pric_repay_freq_cd                                                                            --本金还款周期频率
    ,t1.int_repay_freq_cd                                                                             --利息还款周期频率
    ,t1.guar_type_cd                                                                                   --担保方式代码
    ,'-'                                                                                               --客户性质代码
    ,t1.recvbl_num_type_cd                                                                             --入账账号类型
    ,''                                                                                              --入账账户开户银行名称
    ,t1.repay_num_type_cd                                                                             --还款账号类型
    ,''                                                                                              --还款账户开户银行编号
    ,''                                                                                              --还款账户开户机构名称
    ,'0'                                                                                              --内部结转标志
    ,nvl(trim(t1.loan_cap_use_position_cd), '0')                                                      --境内外标志
    ,t1.white_list_cust_flg                                                                            --白户标志
    ,'-'                                                                                               --农户标志
    ,'-'
    ,'1'                                                                                               --计息标志
    ,'0'                                                                                               --复息标志
    ,decode(nvl(t9.agt_status_cd, t1.cont_status_cd),'OVD', '1', '0')                               --逾期标志
    ,decode(t10.agt_status_cd,'Y','1','0')                                                           --核销标志
    ,''                                                                                                --人行普惠贷款标志
    ,'0'                                                                                               --债权直转标志
    ,''                                                                                                --重组标志
    ,''                                                                                                --重组贷款类型代码
    ,''                                                                                                --重组日期
    ,t1.distr_dt                                                                                      --开户日期
    ,t1.distr_dt                                                                                      --放款日期
    ,t1.distr_dt                                                                                      --原始放款日期
    ,t1.loan_value_dt                                                                                  --起息日期
    ,t1.loan_exp_dt                                                                                    --到期日期
    ,t1.loan_exp_dt                                                                                    --原始到期日期
    ,t11.imp_dt                                                                                        --结清日期
    ,nvl(t4.last_repay_dt, t1.loan_value_dt)                                                           --上次还款日期
    ,t12.imp_dt                                                                                        --下次还款日期
    ,t1.distr_dt                                                                                      --当前利率生效日期
    ,${iml_schema}.dateformat_max('')                                                                  --下次利率调整日期
    ,t30.cust_mgr_id                                                                                   --客户经理编号
    ,'897001'                                                                                          --开户机构编号
    ,'897001'                                                                                          --管理机构编号
    ,'897001'                                                                                          --账务机构编号
    ,t1.loan_cont_tenor                                                                                --原始贷款期数
    ,t1.loan_cont_tenor                                                                                --贷款期数
    ,nvl(t1.loan_cont_tenor,0)-nvl(t1.unpayoff_perds,0)                                                --当前期数
    ,t1.unpayoff_perds                                                                                --剩余期数
    ,t1.ovdue_pd_cnt                                                                                  --逾期期数
    ,case when decode(nvl(t9.agt_status_cd, t1.cont_status_cd),'OVD', '1', '0') = '1' then nvl(t5.prin_ovdue_days,0) else 0 end --本金逾期天数
    ,case when decode(nvl(t9.agt_status_cd, t1.cont_status_cd),'OVD', '1', '0') = '1' then nvl(t5.int_ovdue_days, 0) else 0 end --利息逾期天数
    ,t1.grace_period_days                                                                              --宽限期天数
    ,0                                                                                                --分期手续费费率
    ,nvl(t13.base_int_rat, 0)                                                                          --基准利率
    ,nvl(t13.exec_int_rat, 0)                                                                          --执行利率
    ,nvl(t13.exec_int_rat * 1.5, 0)                                                                    --逾期利率
    ,nvl(t1.loan_actl_day_int_rat, 0)                                                                 --每日执行利率
    ,0                                                                                                   --固收利率
    ,nvl(t1.distr_amt, 0)                                                                              --合同金额
    ,nvl(t1.distr_amt, 0)                                                                              --借据金额
    ,nvl(t25.amt, 0)                                                                                  --放款金额
    ,nvl(t25.amt, 0)                                                                                  --原始放款金额
    ,1                                                                                                 --银行出资比例
    ,(nvl(t2.nomal_int_amt, 0) + nvl(t2.ovdue_pric_pnlt, 0) + nvl(t2.ovdue_int_pnlt, 0))              --当日应计利息
    ,nvl(t7.int_bal,0)+nvl(t7.ovd_int_bal,0)                                                           --当期应计利息
    ,case when decode(t10.agt_status_cd,'Y','1','0') = '0' then nvl(t7.prin_bal,0) else 0 end          --正常本金
    ,case when nvl(t1.acru_non_acru_flg,'1') = '0' and decode(t10.agt_status_cd,'Y','1','0') ='0' then nvl(t7.ovd_prin_bal,0) else 0 end --逾期本金
    ,case when nvl(trim(t1.acru_non_acru_flg),'0') = '1' and decode(t10.agt_status_cd,'Y','1','0')= '0' then t7.ovd_prin_bal else 0 end  --呆滞本金
    ,0                                                                                                    --呆账本金
    ,case when decode(t10.agt_status_cd,'Y','1','0') = '1' then nvl(t7.prin_bal,0) + nvl(t7.ovd_prin_bal,0) else 0 end --核销本金
    ,nvl(t7.int_bal,0)                                                                               --正常利息
    ,nvl(t7.ovd_int_bal,0)                                                                           --逾期利息
    ,case when decode(t10.agt_status_cd,'Y','1','0') = '1' then nvl(t7.int_bal,0) + nvl(t7.ovd_int_bal,0) + nvl(t7.ovd_prin_pnlt_bal,0) + nvl(t7.ovd_int_pnlt_bal,0) else 0 end --核销利息
    ,nvl(t7.ovd_prin_pnlt_bal,0)                                                                     --逾期本金罚息
    ,nvl(t7.ovd_int_pnlt_bal,0)                                                                       --逾期利息罚息
    ,(nvl(t7.int_bal,0) + nvl(t7.ovd_int_bal,0))                                                     --应收欠息
    ,nvl(t7.ovd_int_bal,0)                                                                            --应收应计罚息
    ,(nvl(t7.ovd_prin_pnlt_bal,0) + nvl(t7.ovd_int_pnlt_bal,0))                                       --应收罚息
    ,0                                                                                                --应收费用
    ,case when greatest(to_number(nvl(trim(t5.prin_ovdue_days),0)),to_number(nvl(trim(t5.int_ovdue_days),0))) < 90  then (nvl(t7.int_bal,0) + nvl(t7.ovd_int_bal,0)) else 0 end  --表内欠息余额
    ,case when greatest(to_number(nvl(trim(t5.prin_ovdue_days),0)),to_number(nvl(trim(t5.int_ovdue_days),0))) >= 90 then (nvl(t7.int_bal,0) + nvl(t7.ovd_int_bal,0)) else 0 end  --表外欠息余额
    ,case when greatest(to_number(nvl(trim(t5.prin_ovdue_days),0)),to_number(nvl(trim(t5.int_ovdue_days),0))) < 90  then (nvl(t7.int_bal,0) + nvl(t7.ovd_int_bal,0) + nvl(t7.ovd_prin_pnlt_bal,0) + nvl(t7.ovd_int_pnlt_bal,0)) else 0 end --表内利息
    ,case when greatest(to_number(nvl(trim(t5.prin_ovdue_days),0)),to_number(nvl(trim(t5.int_ovdue_days),0))) >= 90 then (nvl(t7.int_bal,0) + nvl(t7.ovd_int_bal,0) + nvl(t7.ovd_prin_pnlt_bal,0) + nvl(t7.ovd_int_pnlt_bal,0)) else 0 end  --表外利息
    ,case when greatest(to_number(nvl(trim(t5.prin_ovdue_days),0)),to_number(nvl(trim(t5.int_ovdue_days),0))) >= 90 then (nvl(t7.int_bal,0) + nvl(t7.ovd_int_bal,0) + nvl(t7.ovd_prin_pnlt_bal,0) + nvl(t7.ovd_int_pnlt_bal,0)) else 0 end  --累计应收未收利息金额
    ,nvl(t4.paid_normal_prin,0)                                                                       --已偿还正常本金
    ,nvl(t4.paid_ovdue_prin,0)                                                                       --已偿还逾期本金
    ,nvl(t4.paid_normal_int,0)                                                                       --已偿还正常利息
    ,nvl(t4.paid_ovdue_int,0)                                                                         --已偿还逾期利息
    ,nvl(t4.paid_ovdue_prin_pnlt,0)                                                                   --已偿还逾期本金罚息
    ,nvl(t4.paid_ovdue_int_pnlt,0)                                                                   --已偿还逾期利息罚息
    ,nvl(t4.paid_cost,0)                                                                             --已偿还费用
    ,nvl(t7.prin_bal,0)  + nvl(t7.ovd_prin_bal,0)                                                      --本金余额
    ,nvl(t7.prin_bal,0)  + nvl(t7.ovd_prin_bal,0)                                                      --当期余额
    ,(nvl(t7.prin_bal,0)  + nvl(t7.ovd_prin_bal,0)) * nvl(t6.convt_cny_exch_rat, 1)                    --折本币当期余额
    ,t1.job_cd                                                                                         --任务代码
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6')
from ${icl_schema}.tmp_cmm_unite_wl_dubil_info_clear_31 t1
  left join ${iml_schema}.agt_ajb_ped_3_int_provi_dtl t2
    on t1.dubil_id = t2.dubil_id
   and t2.etl_dt = to_date('${batch_date}', 'yyyymmdd')
   and t2.int_accr_dt = to_date('${batch_date}','yyyymmdd')
   and t2.acru_non_acru_flg = '0'
      and t2.job_cd = 'myjbi3'
    left join ${icl_schema}.tmp_cmm_unite_wl_dubil_info_clear_13 t4
      on t1.dubil_id = t4.dubil_id
    left join ${icl_schema}.tmp_cmm_unite_wl_dubil_info_clear_14 t5
      on t1.dubil_id = t5.dubil_id
   left join  ${iml_schema}.ref_cny_fori_exch_mdl_p_h t6
      on t1.curr_cd = t6.curr_cd
     --and t6.dt = to_date('${batch_date}', 'yyyymmdd')
      and t6.start_dt <= to_date('${batch_date}', 'yyyymmdd')
      and t6.end_dt > to_date('${batch_date}', 'yyyymmdd')
      and t6.id_mark <> 'D'
      and t6.job_cd = 'ncbsf1'
    left join ${icl_schema}.tmp_cmm_unite_wl_dubil_info_clear_07 t7
       on t1.agt_id = t7.agt_id
    left join ${iml_schema}.agt_status_h t9
     on t9.agt_id = t1.agt_id
     and t9.agt_status_type_cd = 'CD1278'
     and t9.start_dt <= to_date('${batch_date}', 'yyyymmdd')
     and t9.end_dt > to_date('${batch_date}', 'yyyymmdd')
     and t9.job_cd = 'myjbf3'
   left join ${iml_schema}.agt_status_h t33
     on t33.agt_id = t1.agt_id
     and t33.agt_status_type_cd = 'CD2060'
     and t33.start_dt <= to_date('${batch_date}', 'yyyymmdd')
     and t33.end_dt > to_date('${batch_date}', 'yyyymmdd')
     and t33.job_cd = 'myjbf3'
    left join ${iml_schema}.agt_status_h t10
     on t10.agt_id = t1.agt_id
     and t10.agt_status_type_cd = 'CD1102'
     and t10.start_dt <= to_date('${batch_date}', 'yyyymmdd')
     and t10.end_dt > to_date('${batch_date}', 'yyyymmdd')
     and t10.job_cd = 'myjbf3'
    left join ${iml_schema}.agt_status_h t14
     on t10.agt_id = t1.agt_id
     and t10.agt_status_type_cd = 'CD1261'
     and t10.start_dt <= to_date('${batch_date}', 'yyyymmdd')
     and t10.end_dt > to_date('${batch_date}', 'yyyymmdd')
     and t10.job_cd = 'myjbf3'
    left join ${iml_schema}.agt_imp_dt_h t11
      on t11.agt_id = t1.agt_id
     and t11.dt_type_cd = '03'
     and t11.start_dt <= to_date('${batch_date}', 'yyyymmdd')
     and t11.end_dt > to_date('${batch_date}', 'yyyymmdd')
     and t11.job_cd = 'myjbf3'
    left join ${iml_schema}.agt_imp_dt_h t12
     on t12.agt_id = t1.agt_id
     and t12.dt_type_cd = '05'
     and t12.start_dt <= to_date('${batch_date}', 'yyyymmdd')
     and t12.end_dt > to_date('${batch_date}', 'yyyymmdd')
     and t12.job_cd = 'myjbf3'
    left join ${iml_schema}.agt_int_rat_h t13
      on t1.agt_id = t13.agt_id
     and t13.int_rat_type_cd = '003001'
     and t13.start_dt <= to_date('${batch_date}', 'yyyymmdd')
     and t13.end_dt > to_date('${batch_date}', 'yyyymmdd')
     and t13.job_cd = 'myjbf3'
    left join ${iml_schema}.agt_rela_h t15
      on t1.agt_id = t15.agt_id
     and t15.agt_rela_type_cd = '05'
     and t15.start_dt <= to_date('${batch_date}', 'yyyymmdd')
     and t15.end_dt > to_date('${batch_date}', 'yyyymmdd')
     and t15.job_cd = 'myjbf3'
    left join ${iml_schema}.agt_prod_rela_h t16
     on t1.agt_id = t16.agt_id
    and t16.start_dt <= to_date('${batch_date}','yyyymmdd')
    and t16.end_dt > to_date('${batch_date}','yyyymmdd')
    and t16.job_cd ='myjbf3'
    left join ${iml_schema}.agt_amt_h t25
      on t1.agt_id = t25.agt_id
     and t25.amt_type_cd= '001005'
     and t25.start_dt <= to_date('${batch_date}', 'yyyymmdd')
     and t25.end_dt > to_date('${batch_date}', 'yyyymmdd')
     and t25.id_mark <> 'D'
     and t25.job_cd = 'myjbf3'
   left join ${iml_schema}.prd_prod_cust_mgr_rela_h t30
     on t30.prod_id = '202010100002'  -- 借呗三期客户经理
    and t30.start_dt <= to_date('${batch_date}','yyyymmdd')
    and t30.end_dt > to_date('${batch_date}','yyyymmdd')
    and t30.job_cd = 'icmsf1'
where 1=1
;
commit;

create table ${icl_schema}.tmp_cmm_unite_wl_dubil_info_clear_32
nologging
compress ${option_switch} for query high
as
select t1.intnal_dubil_id,
        min(t1.reach_money_exp_repay_dt) + 1 as prin_earliest_ovdue_dt,
        t2.ovd_status as ovd_status,
       case when t2.ovd_status = '0' then 0 else to_date('${batch_date}', 'yyyymmdd') - trunc(min(t1.reach_money_exp_repay_dt)) + 1
       end as prin_ovdue_days
  from ${iml_schema}.agt_wld_repay_plan_h t1
  left join (select wld1.intnal_dubil_id,
                       case when wld2.intnal_dubil_id is not null then '0'
                             when (nvl(wld1.rpbl_pric, 0) <> nvl(wld1.repaid_pric, 0) or nvl(wld1.rpbl_int, 0) <> nvl(wld1.repaid_int, 0)) and wld1.grace_dt < to_date('${batch_date}', 'yyyymmdd') then '1'
                             else '0' end as ovd_status
                 from ${iml_schema}.agt_wld_repay_plan_h wld1
                 left join ${iml_schema}.agt_wld_repay_plan_h wld2
                   on wld1.intnal_dubil_id = wld2.intnal_dubil_id
                  and wld2.start_dt <= to_date('${batch_date}', 'yyyymmdd')
                  and wld2.end_dt > to_date('${batch_date}', 'yyyymmdd')
                  and wld2.job_cd ='icmsf1'
                  and wld2.repay_plan_oper_act_cd = 'L'
                where wld1.repay_plan_oper_act_cd <> 'L'
                  and wld1.start_dt <= to_date('${batch_date}', 'yyyymmdd')
                  and wld1.end_dt > to_date('${batch_date}', 'yyyymmdd')
                  and wld1.job_cd ='icmsf1') t2
    on t1.intnal_dubil_id = t2.intnal_dubil_id
   and t2.ovd_status ='1'
 where t1.start_dt <= to_date('${batch_date}', 'yyyymmdd')
   and t1.end_dt > to_date('${batch_date}', 'yyyymmdd')
   and t1.job_cd ='icmsf1'
 group by t1.intnal_dubil_id, t2.ovd_status;


-- 第七组（共九组）微粒贷
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ into ${icl_schema}.cmm_unite_wl_dubil_info_clear_ex(
   etl_dt                                 --数据日期
   ,lp_id                                 --法人编号
   ,dubil_id                              --借据编号
   ,core_dubil_id                         --核心借据编号
   ,cont_id                               --合同编号
   ,std_prod_id                           --标准产品编号
   ,prod_id                               --产品编号
   ,cust_id                               --客户编号
   ,subj_id                               --科目编号
   ,acctnt_cate_cd                        --会计类别代码
   ,enter_acct_acct_num                   --入账账号
   ,repay_num                             --还款账号
   ,rela_agt_id                           --关联协议编号
   ,rela_appl_flow_num                    --关联申请流水号
   ,curr_cd                               --币种代码
   ,bus_breed_id                          --业务品种编号
   ,loan_type_cd                          --贷款类型代码
   ,intnal_loan_type_cd                    --行内贷款类型代码
   ,asset_thd_cls_cd                      --资产三分类
   ,dubil_status_cd                       --借据状态代码
   ,loan_usage_cd                         --贷款用途代码
   ,dir_indus_cd                          --贷款贷款贷款投向行业代码
   ,cont_status_cd                        --合同状态代码
   ,loan_level4_cls_cd                    --贷款四级分类代码
   ,loan_level5_cls_cd                    --贷款五级分类代码
   ,loan_level10_cls_cd                   --贷款十级分类代码
   ,loan_level12_cls_cd                   --贷款十二级分类代码
   ,acru_non_acru_cd                      --应计非应计代码
   ,repay_way_cd                          --还款方式代码
   ,int_set_way_cd                        --结息方式代码
   ,int_accr_way_cd                       --计息方式代码
   ,int_rat_adj_way_cd                    --利率调整方式代码
   ,int_rat_adj_ped_corp_cd               --利率调整周期单位代码
   ,int_rat_adj_ped_freq                  --利率调整周期频率
   ,int_rat_base_type_cd                  --利率基准类型代码
   ,int_rat_float_way_cd                  --利率浮动方式代码
   ,int_rat_float_dir_cd                  --利率浮动方向代码
   ,int_rat_flo_val                       --利率浮动值
   ,pric_repay_freq_cd                    --本金还款周期频率
   ,int_repay_freq_cd                     --利息还款周期频率
   ,guar_way_cd                           --担保方式代码
   ,cust_char_cd                          --客户性质代码
   ,enter_acct_acct_num_type              --入账账号类型
   ,enter_acct_bank_name                  --入账账户开户银行名称
   ,repay_num_type                        --还款账号类型
   ,repay_open_acct_bank_id               --还款账户开户银行编号
   ,repay_open_acct_org_name              --还款账户开户机构名称
   ,intnal_carr_flg                       --内部结转标志
   ,dom_overs_flg                         --境内外标志
   ,white_list_cust_flg                   --白户标志
   ,farm_flg                              --农户标志
   ,agclt_flg                             --涉农标志
   ,int_accr_flg                          --计息标志
   ,comp_int_flg                          --复息标志
   ,ovdue_flg                             --逾期标志
   ,wrt_off_flg                           --核销标志
   ,pbc_inc_loan_flg                      --人行普惠贷款标志
   ,cred_rht_turn_flg                     --债权直转标志
   ,regroup_flg                           --重组标志
   ,regroup_loan_type_cd                  --重组贷款类型代码
   ,regroup_dt                            --重组日期
   ,open_acct_dt                          --开户日期
   ,distr_dt                              --放款日期
   ,init_distr_dt                         --原始放款日期
   ,value_dt                              --起息日期
   ,exp_dt                                --到期日期
   ,init_exp_dt                           --原始到期日期
   ,payoff_dt                             --结清日期
   ,last_repay_dt                         --上次还款日期
   ,next_repay_dt                         --下次还款日期
   ,curr_int_rat_effect_dt                --当前利率生效日期
   ,next_int_rat_adj_dt                   --下次利率调整日期
   ,cust_mgr_id                           --客户经理编号
   ,open_acct_org_id                      --开户机构编号
   ,mgmt_org_id                           --管理机构编号
   ,acct_instit_id                        --账务机构编号
   ,init_tot_perds                        --原始贷款期数
   ,tot_perds                             --贷款期数
   ,curr_issue_perds                      --当前期数
   ,surp_perds                            --剩余期数
   ,ovdue_perds                           --逾期期数
   ,pric_ovdue_days                       --本金逾期天数
   ,int_ovdue_days                        --利息逾期天数
   ,grace_period_days                     --宽限期天数
   ,inst_comm_fee_rat                     --分期手续费费率
   ,base_rat                              --基准利率
   ,exec_int_rat                          --执行利率
   ,ovdue_int_rat                         --逾期利率
   ,daily_exec_int_rat                    --每日执行利率
   ,int_rat                               --固收利率
   ,cont_amt                              --合同金额
   ,dubil_amt                             --借据金额
   ,distr_amt                             --放款金额
   ,init_distr_amt                        --原始放款金额
   ,bank_contri_ratio                     --银行出资比例
   ,td_acru_int                           --当日应计利息
   ,currt_acru_int                        --当期应计利息
   ,nomal_pric                            --正常本金
   ,ovdue_pric                            --逾期本金
   ,idle_pric                             --呆滞本金
   ,bad_debt_pric                         --呆账本金
   ,wrt_off_pric                          --核销本金
   ,nomal_int                             --正常利息
   ,ovdue_int                             --逾期利息
   ,wrt_off_int                           --核销利息
   ,ovdue_pric_pnlt                       --逾期本金罚息
   ,ovdue_int_pnlt                        --逾期利息罚息
   ,recvbl_over_int                       --应收欠息
   ,recvbl_acru_pnlt                      --应收应计罚息
   ,recvbl_pnlt                           --应收罚息
   ,recvbl_fee                            --应收费用
   ,in_bs_over_int_bal                    --表内欠息余额
   ,off_bs_over_int_bal                   --表外欠息余额
   ,in_bs_int                             --表内利息
   ,off_bs_int                            --表外利息
   ,acm_recvbl_uncol_int_amt              --累计应收未收利息金额
   ,repaid_nomal_pric                     --已偿还正常本金
   ,repaid_ovdue_pric                     --已偿还逾期本金
   ,repaid_nomal_int                      --已偿还正常利息
   ,repaid_ovdue_int                      --已偿还逾期利息
   ,repaid_ovdue_pric_pnlt                --已偿还逾期本金罚息
   ,repaid_ovdue_int_pnlt                 --已偿还逾期利息罚息
   ,repaid_fee                            --已偿还费用
   ,pric_bal                              --本金余额
   ,currt_bal                             --当期余额
   ,cl_curr_currt_bal                     --折本币当期余额
   ,job_cd                                --任务代码
   ,etl_timestamp                         --etl处理时间戳
)
select
   to_date('${batch_date}','yyyymmdd')   -- 数据日期
   ,t1.lp_id                             -- 法人编号
   ,t1.dubil_id                          -- 借据编号
   ,t1.dubil_id                          -- 核心借据编号
   ,''                                   -- 合同编号
   ,t1.prod_id                           -- 标准产品编号
   ,t1.prod_id                           -- 产品编号
   ,t1.cust_id                           -- 客户编号
   ,case when t1.prod_id = '202010100008' then  '13030203'  --个人消费类贷款用途  --测试环境产品号，投产待调整 投产后产品号 202010100008
         when t1.prod_id = '202020100003' then  '13030202'  --个人经营类贷款用途  --测试环境产品号，投产待调整 投产后产品号 202020100003
         else ' ' end                    -- 科目编号
   ,''                                   -- 会计类别代码
   ,t1.card_no                           -- 入账账号
   ,t1.apot_repay_deduct_acct_num        -- 还款账号
   ,t1.cust_lmt_id                       -- 关联协议编号
   ,t1.cust_lmt_id                       -- 关联申请流水号
   ,'CNY'                                -- 币种代码
   ,t1.prod_id                      -- 业务品种编号
   ,t1.loan_type_cd                      -- 贷款类型代码
   ,''                    --行内贷款类型代码
   ,'AC'                                 -- 资产三分类代码
   ,t1.loan_status_cd                    -- 借据状态代码
   ,case when t1.prod_id = '202010100008' then  '100100'  --个人消费类贷款用途  --测试环境产品号，投产待调整 投产后产品号 202010100008
         when t1.prod_id = '202020100003' then  '100200'  --个人经营类贷款用途  --测试环境产品号，投产待调整 投产后产品号202020100003
         else ' ' end                    -- 贷款用途代码
   ,'F5299'                              -- 贷款贷款贷款投向行业代码
   ,case when ${iml_schema}.dateformat_max(t1.payoff_dt) <> ${iml_schema}.dateformat_max('') then 'CLEAR'
         when t7.ovd_status = '1' then 'OVD'
         else 'NORMAL' end               -- 合同状态代码
   ,'00'                                 -- 贷款四级分类代码
   ,case when greatest(t10.conti_owe_this_days, t10.conti_over_int_days)  = 0 then '10'
         when greatest(t10.conti_owe_this_days, t10.conti_over_int_days) >= 1   and greatest(t10.conti_owe_this_days, t10.conti_over_int_days) <= 89  then '20'
         when greatest(t10.conti_owe_this_days, t10.conti_over_int_days) >= 90  and greatest(t10.conti_owe_this_days, t10.conti_over_int_days) <= 120 then '30'
         when greatest(t10.conti_owe_this_days, t10.conti_over_int_days) >= 121 and greatest(t10.conti_owe_this_days, t10.conti_over_int_days) <= 180 then '40'
         when greatest(t10.conti_owe_this_days, t10.conti_over_int_days) >= 181 then '50'
         else '99' end                   -- 贷款五级分类代码
   ,case when coalesce(to_number(decode(t10.conti_owe_this_days,0,'',t10.conti_owe_this_days)),t10.conti_over_int_days,0) = 0 then '15'
         when coalesce(to_number(decode(t10.conti_owe_this_days,0,'',t10.conti_owe_this_days)),t10.conti_over_int_days,0) >= 1 and coalesce(to_number(decode(t10.conti_owe_this_days,0,'',t10.conti_owe_this_days)),t10.conti_over_int_days,0) <= 59  then '21'
         when coalesce(to_number(decode(t10.conti_owe_this_days,0,'',t10.conti_owe_this_days)),t10.conti_over_int_days,0) >= 60 and coalesce(to_number(decode(t10.conti_owe_this_days,0,'',t10.conti_owe_this_days)),t10.conti_over_int_days,0) <= 89 then '22'
         when coalesce(to_number(decode(t10.conti_owe_this_days,0,'',t10.conti_owe_this_days)),t10.conti_over_int_days,0) >= 90 and coalesce(to_number(decode(t10.conti_owe_this_days,0,'',t10.conti_owe_this_days)),t10.conti_over_int_days,0) <= 120 then '30'
         when coalesce(to_number(decode(t10.conti_owe_this_days,0,'',t10.conti_owe_this_days)),t10.conti_over_int_days,0) >= 121 and coalesce(to_number(decode(t10.conti_owe_this_days,0,'',t10.conti_owe_this_days)),t10.conti_over_int_days,0) <= 180 then '40'
         when coalesce(to_number(decode(t10.conti_owe_this_days,0,'',t10.conti_owe_this_days)),t10.conti_over_int_days,0) >= 181 then '50'
         else '90' end                   -- 贷款十级分类代码
   ,'11'                                 -- 贷款十二级分类代码
   ,case when t1.loan_unexp_bal + t1.debt_pric = 0 then '1'
         when t1.tran_ref_no is not null then '2'
         else '0'
         end                             -- 应计非应计代码
   ,'2'                                  -- 还款方式代码
   ,'01'                                 -- 结息方式代码
   ,'AB'                                 -- 计息方式代码
   ,'0'                                  -- 利率调整方式代码
   ,'O'                                  -- 利率调整周期单位代码
   ,'0'                                  -- 利率调整周期频率
   ,'2231'                               -- 利率基准类型代码
   ,'1'                                  -- 利率浮动方式代码
   ,'-'                                  -- 利率浮动方向代码
   ,t1.exec_int_rat-nvl(t10.currt_lpr_val,0) -- 利率浮动值
   ,'03'                                 -- 本金还款频率代码
   ,'03'                                 -- 利息还款频率代码
   ,'D'                                  -- 担保方式代码
   ,'-'                                  -- 客户性质代码
   ,'01'                                 -- 入账账号类型
   ,''                                   -- 入账账户开户银行名称
   ,'01'                                 -- 还款账号类型
   ,''                                   -- 还款账户开户银行编号
   ,''                                   -- 还款账户开户机构名称
   ,'0'                                  -- 内部结转标志
   ,'1'                                  -- 境内外标志
   ,'-'                                  -- 白户标志
   ,'-'                                  -- 农户标志
   ,'-'                                  -- 涉农标志
   ,case when (t1.loan_unexp_bal + t1.debt_pric) * nvl(t1.bank_contri_ratio, 0) = 0 then '0'
         when t6.tran_ref_no is not null then '0' else '1' end -- 计息标志
   ,'0'                                  -- 复息标志
   ,nvl(t7.ovd_status, '0')              -- 逾期标志
   ,case when t6.tran_ref_no is not null then '1' else '0' end  -- 核销标志
   ,''                                   --人行普惠贷款标志
   ,'0'                                  -- 债权直转标志
   ,''                                   -- 重组标志
   ,''                                   -- 重组贷款类型代码
   ,''                                   -- 重组日期
   ,t1.loan_rgst_dt                      -- 开户日期
   ,t1.loan_rgst_dt                      -- 放款日期
   ,t1.loan_rgst_dt                      -- 原始放款日期
   ,t1.loan_rgst_dt                      -- 起息日期
   ,t1.loan_exp_dt                       -- 到期日期
   ,t1.loan_exp_dt                       --原始到期日期
   ,t1.payoff_dt                         -- 结清日期
   ,t2.prev_repay_dt                     -- 上次还款日期
   ,t2.next_exp_repay_dt                 -- 下次还款日期
   ,t1.loan_rgst_dt                      -- 当前利率生效日期
   ,t1.renew_effect_dt                   -- 下次利率调整日期
   ,t8.cust_mgr_id                       -- 客户经理编号
   ,'805011'                             -- 开户机构编号
   ,'805011'                             -- 管理机构编号
   ,'805011'                             -- 账务机构编号
   ,t1.loan_tot_perds                    -- 原始贷款期数
   ,case when t1.b_renew_tot_perds > 0 then t1.b_renew_tot_perds
        else t1.loan_tot_perds end       -- 贷款期数
   ,t1.curr_perds                        -- 当前期数
   ,t1.surp_perds                        -- 剩余期数
   ,t1.loan_ovdue_max_perds              -- 逾期期数
   ,nvl(t10.conti_owe_this_days,0)      -- 本金逾期天数
   ,nvl(t10.conti_over_int_days,0)      -- 利息逾期天数
   ,1                                    -- 宽限期天数
   ,0                                    -- 分期手续费费率
   ,t10.currt_lpr_val                    -- 基准利率
   ,t1.exec_int_rat * 100                -- 执行利率
   ,t1.pnlt_int_rat* 100                 -- 逾期利率
   ,(t1.exec_int_rat /360)* 100          -- 每日执行利率
   ,0                                    -- 固收利率
   ,t1.loan_pric*t1.bank_contri_ratio    -- 合同金额
   ,t1.loan_pric*t1.bank_contri_ratio    -- 借据金额
   ,t1.loan_pric*t1.bank_contri_ratio    -- 放款金额
   ,t1.loan_pric*t1.bank_contri_ratio    -- 原始放款金额
   ,t1.bank_contri_ratio                 -- 银行出资比例
   ,(t1.loan_unexp_bal * t1.bank_contri_ratio * t1.exec_int_rat) / 360  -- 当日应计利息
   ,nvl(t3.curr_accrued_int,0) * t1.bank_contri_ratio                   -- 当期应计利息
   ,case when coalesce(to_number(decode(t10.conti_owe_this_days,0,'',t10.conti_owe_this_days)),t10.conti_over_int_days,0) > 0 then 0
         else (t1.loan_unexp_bal + t1.debt_pric) * t1.bank_contri_ratio end  -- 正常本金
   ,case when coalesce(to_number(decode(t10.conti_owe_this_days,0,'',t10.conti_owe_this_days)),t10.conti_over_int_days,0) > 0 and coalesce(to_number(decode(t10.conti_owe_this_days,0,'',t10.conti_owe_this_days)),t10.conti_over_int_days,0) < 90 and t6.tran_ref_no is null
         then (t1.loan_unexp_bal + t1.debt_pric) * t1.bank_contri_ratio
         else 0 end                      -- 逾期本金
   ,case when coalesce(to_number(decode(t10.conti_owe_this_days,0,'',t10.conti_owe_this_days)),t10.conti_over_int_days,0) >= 90 and t6.tran_ref_no  is null
         then (t1.loan_unexp_bal + t1.debt_pric) * t1.bank_contri_ratio
         else 0 end                      -- 呆滞本金
   ,0                                    -- 呆账本金
   ,case when t6.tran_ref_no  is not null
         then (t1.loan_unexp_bal + t1.debt_pric) * t1.bank_contri_ratio
         else 0 end                      -- 核销本金
   ,case when coalesce(to_number(decode(t10.conti_owe_this_days,0,'',t10.conti_owe_this_days)),t10.conti_over_int_days,0) > 0 then 0 else (t1.debt_int * t1.bank_contri_ratio) end  -- 正常利息
   ,case when coalesce(to_number(decode(t10.conti_owe_this_days,0,'',t10.conti_owe_this_days)),t10.conti_over_int_days,0) > 0 and coalesce(to_number(decode(t10.conti_owe_this_days,0,'',t10.conti_owe_this_days)),t10.conti_over_int_days,0) < 90
         then (t1.debt_int + t1.debt_pric) * t1.bank_contri_ratio
         else 0 end                      -- 逾期利息
   ,case when t6.tran_ref_no is not null
         then (t1.debt_int + t1.debt_pric) * t1.bank_contri_ratio
         else 0 end                      -- 核销利息
   ,case when coalesce(to_number(decode(t10.conti_owe_this_days,0,'',t10.conti_owe_this_days)),t10.conti_over_int_days,0) > 0 and coalesce(to_number(decode(t10.conti_owe_this_days,0,'',t10.conti_owe_this_days)),t10.conti_over_int_days,0) < 90
         then t1.debt_pric * t1.bank_contri_ratio
         else 0 end                                                                                           -- 逾期本金罚息
   ,0                                                                                                         -- 逾期利息罚息
   ,t1.debt_int * t1.bank_contri_ratio                                                                        -- 应收欠息
   ,t1.debt_pnlt * t1.bank_contri_ratio                                                                       -- 应收应计罚息
   ,t1.debt_pnlt * t1.bank_contri_ratio                                                                       -- 应收罚息
   ,t1.loan_unexp_comm_fee * t1.bank_contri_ratio                                                             -- 应收费用
   ,case when coalesce(to_number(decode(t10.conti_owe_this_days,0,'',t10.conti_owe_this_days)),t10.conti_over_int_days,0) < 90 then t1.debt_int * t1.bank_contri_ratio else 0 end                     -- 表内欠息余额
   ,case when coalesce(to_number(decode(t10.conti_owe_this_days,0,'',t10.conti_owe_this_days)),t10.conti_over_int_days,0) >= 90 then t1.debt_int * t1.bank_contri_ratio else 0 end                      -- 表外欠息余额
   ,case when coalesce(to_number(decode(t10.conti_owe_this_days,0,'',t10.conti_owe_this_days)),t10.conti_over_int_days,0) < 90 then (t1.debt_int + t1.debt_pnlt) * t1.bank_contri_ratio else 0 end    -- 表内利息
   ,case when coalesce(to_number(decode(t10.conti_owe_this_days,0,'',t10.conti_owe_this_days)),t10.conti_over_int_days,0) >= 90 then (t1.debt_int + t1.debt_pnlt) * t1.bank_contri_ratio else 0 end     -- 表外利息
   ,(t1.debt_int + t1.debt_pnlt) * t1.bank_contri_ratio                                                       -- 累计应收未收利息金额
   ,t4.paid_normal_prin * t1.bank_contri_ratio                                                                -- 已偿还正常本金
   ,0                                                                                                         -- 已偿还逾期本金
   ,t4.paid_normal_int * t1.bank_contri_ratio                                                                 -- 已偿还正常利息
   ,0                                                                                                         -- 已偿还逾期利息
   ,t4.paid_ovdue_prin_pnlt * t1.bank_contri_ratio                                                            -- 已偿还逾期本金罚息
   ,0                                                                                                         -- 已偿还逾期利息罚息
   ,t4.paid_cost * t1.bank_contri_ratio                                                                       -- 已偿还费用
   ,(t1.loan_unexp_bal + t1.debt_pric) * t1.bank_contri_ratio                                                 -- 本金余额
   ,(case when t6.tran_ref_no is not null then 0 else  (t1.loan_unexp_bal + t1.debt_pric) * t1.bank_contri_ratio end)  -- 当期余额
   ,(case when t6.tran_ref_no is not null then 0 else  (t1.loan_unexp_bal + t1.debt_pric) * t1.bank_contri_ratio end) * nvl(t5.convt_cny_exch_rat, 1)  -- 折本币当期余额
   ,t1.job_cd                                                                                                 -- 任务代码
   ,to_timestamp('${batch_timestamp}','yyyy-mm-dd hh24:mi:ss.ff6')
 from ${icl_schema}.tmp_cmm_unite_wl_dubil_info_clear_33 t1
inner join ${iml_schema}.agt_wld_acct_h t2
   on t1.acct_id =t2.acct_id
  and t1.acct_type_cd=t2.acct_type_cd
  and t2.start_dt <=to_date('${batch_date}', 'yyyymmdd')
  and t2.end_dt >to_date('${batch_date}', 'yyyymmdd')
  and t2.job_cd ='icmsf1'
 left join (select intnal_dubil_id, curr_perds, sum(nvl(rpbl_int, 0)) as curr_accrued_int
                from ${iml_schema}.agt_wld_repay_plan_h
               where start_dt <=to_date('${batch_date}', 'yyyymmdd')
                 and end_dt >to_date('${batch_date}', 'yyyymmdd')
                 and job_cd ='icmsf1'
               group by intnal_dubil_id, curr_perds) t3
   on t1.intnal_dubil_id =t3.intnal_dubil_id
  and t1.curr_perds=t3.curr_perds
 left join (select intnal_dubil_id,
                      sum(nvl(repaid_pric, 0)) as paid_normal_prin,
                      0 as paid_ovdue_prin,
                      sum(nvl(repaid_int, 0) + nvl(repaid_comp_int, 0)) as paid_normal_int,
                      0 as paid_ovdue_int,
                      sum(nvl(repaid_pnlt, 0)) as paid_ovdue_prin_pnlt,
                      0 as paid_ovdue_int_pnlt,
                      sum(nvl(repaid_fee, 0)) as paid_cost
              from ${iml_schema}.agt_wld_repay_plan_h
             where start_dt <=to_date('${batch_date}', 'yyyymmdd')
               and end_dt >to_date('${batch_date}', 'yyyymmdd')
               and job_cd ='icmsf1'
             group by intnal_dubil_id) t4
   on t1.intnal_dubil_id = t4.intnal_dubil_id
 left join ${iml_schema}.ref_cny_fori_exch_mdl_p_h t5
   on t5.curr_cd = 'CNY'
--  and t5.curr_sym_cd = 'EER'
  and t5.start_dt <=to_date('${batch_date}', 'yyyymmdd')
  and t5.end_dt >to_date('${batch_date}', 'yyyymmdd')
  and t5.job_cd ='ncbsf1'
 left join (select distinct tran_ref_no
                from ${iml_schema}.evt_wld_dubil_wrt_off t
               where t.wrt_off_status_cd = 'CheckPass'
                 and job_cd ='icmsi1') t6
   on t1.tran_ref_no = t6.tran_ref_no
 left join ${icl_schema}.tmp_cmm_unite_wl_dubil_info_clear_32 t7
   on t1.intnal_dubil_id =t7.intnal_dubil_id
 left join ${iml_schema}.prd_prod_cust_mgr_rela_h t8
   on t8.prod_id =t1.prod_id
  and t8.start_dt <= to_date('${batch_date}','yyyymmdd')
  and t8.end_dt > to_date('${batch_date}','yyyymmdd')
  and t8.job_cd = 'icmsf1'
 left join ${iml_schema}.agt_wld_dubil_attach_info t10
   on t1.dubil_id=t10.dubil_id
  and t10.start_dt <= to_date('${batch_date}','yyyymmdd')
  and t10.end_dt > to_date('${batch_date}','yyyymmdd')
  and t10.job_cd='icmsi1'
where 1=1
;
commit;


-- 第八组（共九组）字节小微贷
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ into ${icl_schema}.cmm_unite_wl_dubil_info_clear_ex(
   etl_dt	                             --数据日期
   ,lp_id	                             --法人编号
   ,dubil_id	                         --借据编号
   ,core_dubil_id                        --核心借据编号
   ,cont_id	                             --合同编号
   ,std_prod_id                          --标准产品编号
   ,prod_id	                             --产品编号
   ,cust_id	                             --客户编号
   ,subj_id	                             --科目编号
   ,acctnt_cate_cd                       --会计类别代码
   ,enter_acct_acct_num	                 --入账账号
   ,repay_num	                         --还款账号
   ,rela_agt_id	                         --关联协议编号
   ,rela_appl_flow_num                   --关联申请流水号
   ,curr_cd	                             --币种代码
   ,bus_breed_id	                     --业务品种编号
   ,loan_type_cd	                     --贷款类型代码
   ,intnal_loan_type_cd                    --行内贷款类型代码
   ,asset_thd_cls_cd			         --资产三分类代码
   ,dubil_status_cd	                     --借据状态代码
   ,loan_usage_cd	                     --贷款用途代码
   ,dir_indus_cd	                     --贷款贷款贷款投向行业代码
   ,cont_status_cd	                     --合同状态代码
   ,loan_level4_cls_cd	                 --贷款四级分类代码
   ,loan_level5_cls_cd	                 --贷款五级分类代码
   ,loan_level10_cls_cd	                 --贷款十级分类代码
   ,loan_level12_cls_cd	                 --贷款十二级分类代码
   ,acru_non_acru_cd	                 --应计非应计代码
   ,repay_way_cd	                     --还款方式代码
   ,int_set_way_cd	                     --结息方式代码
   ,int_accr_way_cd	                     --计息方式代码
   ,int_rat_adj_way_cd	                 --利率调整方式代码
   ,int_rat_adj_ped_corp_cd	             --利率调整周期单位代码
   ,int_rat_adj_ped_freq	             --利率调整周期频率
   ,int_rat_base_type_cd	             --利率基准类型代码
   ,int_rat_float_way_cd                 --利率浮动方式代码
   ,int_rat_float_dir_cd                 --利率浮动方向代码
   ,int_rat_flo_val                      --利率浮动值
   ,pric_repay_freq_cd	                 --本金还款周期频率
   ,int_repay_freq_cd	                 --利息还款周期频率
   ,guar_way_cd	                         --担保方式代码
   ,cust_char_cd                         --客户性质代码
   ,enter_acct_acct_num_type             --入账账号类型
   ,enter_acct_bank_name                 --入账账户开户银行名称
   ,repay_num_type	                     --还款账号类型
   ,repay_open_acct_bank_id              --还款账户开户银行编号
   ,repay_open_acct_org_name             --还款账户开户机构名称
   ,intnal_carr_flg	                     --内部结转标志
   ,dom_overs_flg	                     --境内外标志
   ,white_list_cust_flg                  --白户标志
   ,farm_flg                             --农户标志
   ,agclt_flg                            --涉农标志
   ,int_accr_flg	                     --计息标志
   ,comp_int_flg	                     --复息标志
   ,ovdue_flg	                         --逾期标志
   ,wrt_off_flg                          --核销标志
   ,pbc_inc_loan_flg                     --人行普惠贷款标志
   ,cred_rht_turn_flg                    --债权直转标志
   ,regroup_flg                          --重组标志
   ,regroup_loan_type_cd                 --重组贷款类型代码
   ,regroup_dt                           --重组日期
   ,open_acct_dt	                     --开户日期
   ,distr_dt	                         --放款日期
   ,init_distr_dt	                     --原始放款日期
   ,value_dt	                         --起息日期
   ,exp_dt	                             --到期日期
   ,init_exp_dt                          --原始到期日期
   ,payoff_dt	                         --结清日期
   ,last_repay_dt	                     --上次还款日期
   ,next_repay_dt	                     --下次还款日期
   ,curr_int_rat_effect_dt	             --当前利率生效日期
   ,next_int_rat_adj_dt	                 --下次利率调整日期
   ,cust_mgr_id	                         --客户经理编号
   ,open_acct_org_id	                 --开户机构编号
   ,mgmt_org_id	                         --管理机构编号
   ,acct_instit_id	                     --账务机构编号
   ,init_tot_perds                       --原始贷款期数
   ,tot_perds	                         --贷款期数
   ,curr_issue_perds	                 --当前期数
   ,surp_perds	                         --剩余期数
   ,ovdue_perds	                         --逾期期数
   ,pric_ovdue_days	                     --本金逾期天数
   ,int_ovdue_days	                     --利息逾期天数
   ,grace_period_days	                 --宽限期天数
   ,inst_comm_fee_rat	                 --分期手续费费率
   ,base_rat	                         --基准利率
   ,exec_int_rat	                     --执行利率
   ,ovdue_int_rat	                     --逾期利率
   ,daily_exec_int_rat	                 --每日执行利率
   ,int_rat                              --固收利率
   ,cont_amt	                         --合同金额
   ,dubil_amt	                         --借据金额
   ,distr_amt	                         --放款金额
   ,init_distr_amt	                     --原始放款金额
   ,bank_contri_ratio                    --银行出资比例
   ,td_acru_int	                         --当日应计利息
   ,currt_acru_int	                     --当期应计利息
   ,nomal_pric	                         --正常本金
   ,ovdue_pric	                         --逾期本金
   ,idle_pric                            --呆滞本金
   ,bad_debt_pric                        --呆账本金
   ,wrt_off_pric                         --核销本金
   ,nomal_int	                         --正常利息
   ,ovdue_int	                         --逾期利息
   ,wrt_off_int                          --核销利息
   ,ovdue_pric_pnlt	                     --逾期本金罚息
   ,ovdue_int_pnlt	                     --逾期利息罚息
   ,recvbl_over_int	                     --应收欠息
   ,recvbl_acru_pnlt	                 --应收应计罚息
   ,recvbl_pnlt	                         --应收罚息
   ,recvbl_fee	                         --应收费用
   ,in_bs_over_int_bal	                 --表内欠息余额
   ,off_bs_over_int_bal	                 --表外欠息余额
   ,in_bs_int	                         --表内利息
   ,off_bs_int	                         --表外利息
   ,acm_recvbl_uncol_int_amt	         --累计应收未收利息金额
   ,repaid_nomal_pric	                 --已偿还正常本金
   ,repaid_ovdue_pric	                 --已偿还逾期本金
   ,repaid_nomal_int	                 --已偿还正常利息
   ,repaid_ovdue_int	                 --已偿还逾期利息
   ,repaid_ovdue_pric_pnlt	             --已偿还逾期本金罚息
   ,repaid_ovdue_int_pnlt	             --已偿还逾期利息罚息
   ,repaid_fee	                         --已偿还费用
   ,pric_bal	                         --本金余额
   ,currt_bal	                         --当期余额
   ,cl_curr_currt_bal	                 --折本币当期余额
   ,job_cd                               --任务代码
   ,etl_timestamp                        --etl处理时间戳
)
select
   to_date('${batch_date}','yyyymmdd')   -- 数据日期
   ,t1.lp_id                             -- 法人编号
   ,t1.intnal_dubil_id                   -- 借据编号
   ,t1.dubil_id                          -- 核心借据编号
   ,t1.cont_id                           -- 合同编号
   ,t1.prod_id                           -- 标准产品编号
   ,t1.zjdk_prod_id                      -- 产品编号
   ,t1.cust_id                           -- 客户编号
   ,case when t1.prod_id='202020200001' then '13030202'    --个人经营性贷款
           when t1.prod_id='202010200009' then '13030203'    --个人消费贷款	
           else '' end                 -- 科目编号
   ,''                                   -- 会计类别代码
   ,t2.bank_card_num                     -- 入账账号
   ,t4.repay_num_id                      -- 还款账号
   ,t3.lmt_cont_id                       -- 关联协议编号
   ,t1.intnal_dubil_id                   -- 关联申请流水号
   ,t1.curr_cd                           -- 币种代码
   ,t1.prod_id                           -- 业务品种编号
   ,'00'                                 -- 贷款类型代码**
   ,''                    --行内贷款类型代码
   ,t1.asset_thd_cls_cd                  -- 资产三分类代码
   ,case when t1.loan_status_cd = '02' then '6' else '0' end -- 借据状态代码
   ,t2.borw_usage_cd                     -- 贷款用途代码(个人经营性贷款)
   ,t2.bl_induty_type_type_cd            -- 贷款贷款贷款投向行业代码
   ,case when ${iml_schema}.dateformat_max2(t1.payoff_dt) <> ${iml_schema}.dateformat_max2('') then 'CLEAR'
         when t1.loan_modal_cd = '2' then 'OVD'
         else 'NORMAL' end               -- 合同状态代码
   ,'00'                                 -- 贷款四级分类代码
   ,t1.loan_level5_cls_cd                -- 贷款五级分类代码
   ,case when t1.ovdue_days = 0 then '15'
         when t1.ovdue_days >= 1 and t1.ovdue_days <= 59  then '21'
         when t1.ovdue_days >= 60 and t1.ovdue_days <= 89 then '22'
         when t1.ovdue_days >= 90 and t1.ovdue_days <= 120 then '30'
         when t1.ovdue_days >= 121 and t1.ovdue_days <= 180 then '40'
         when t1.ovdue_days >= 181 then '50'
         else '90' end                   -- 贷款十级分类代码
   ,'11'                                 -- 贷款十二级分类代码
   ,t1.non_acru_flg                      -- 应计非应计代码
   ,decode(t1.repay_way_cd,'01','2','02','1','03','3','04','1','-') -- 还款方式代码
   ,'01'                                 -- 结息方式代码
   ,'AB'                                 -- 计息方式代码
   ,decode(t1.int_rat_adj_way_cd,'7','0','1') -- 利率调整方式代码
   ,decode(t1.int_rat_adj_ped_cd,'2','D','3','M','4','Q','5','Y','O') -- 利率调整周期单位代码
   ,'0'                                  -- 利率调整周期频率
   ,t1.base_rat_type_cd                  -- 利率基准类型代码
   ,decode(t1.int_rat_float_way_cd,'0','0','1','2','2','2','3','0','4','1','5','1','-')  -- 利率浮动方式代码
   ,decode(t1.int_rat_float_way_cd,'0','0','1','1','2','2','3','0','4','1','5','2','-')  -- 利率浮动方向代码
   ,t1.flo_val                           -- 利率浮动值
   ,decode(t1.repay_ped_corp_cd,'D','01','M','03','Y','06','C','11','00')                -- 本金还款频率代码
   ,decode(t1.repay_ped_corp_cd,'D','01','M','03','Y','06','C','11','00')                -- 利息还款频率代码
   ,decode(t1.guar_way_cd,'A','A','B','B','C','C','D','D','-','Z')                       -- 担保方式代码
   ,t1.cust_char_cd                      -- 客户性质代码
   ,decode(t1.enter_type_cd,'1','01','-') -- 入账账号类型
   ,t2.bank_name                         -- 入账账户开户银行名称
   ,decode(t1.repay_num_type_cd,'1','01','-') -- 还款账号类型
   ,''                                   -- 还款账户开户银行编号
   ,t4.repay_num_open_acct_org_name      -- 还款账户开户机构名称
   ,''                                   -- 内部结转标志
   ,''                                   -- 境内外标志
   ,''                                   -- 白户标志
   ,''                                   -- 农户标志
   ,''                                   -- 涉农标志
   ,'1'                                  -- 计息标志
   ,'0'                                  -- 复息标志
   ,case when t1.loan_modal_cd = '2' then '1' else '0' end -- 逾期标志
   ,t1.wrt_off_flg  -- 核销标志
   ,''                     --人行普惠贷款标志
   ,'0'                                  -- 债权直转标志
   ,''                                   -- 重组标志
   ,''                                   -- 重组贷款类型代码
   ,''                                   -- 重组日期
   ,t1.begin_dt                          -- 开户日期
   ,t1.begin_dt                          -- 放款日期
   ,t1.begin_dt                          -- 原始放款日期
   ,t1.begin_dt                          -- 起息日期
   ,t1.exp_dt                            -- 到期日期
   ,t1.exp_dt                            -- 原始到期日期
   ,t1.payoff_dt                         -- 结清日期
   ,t7.last_repaydt                      -- 上次还款日期
   ,null                                 -- 下次还款日期**
   ,t1.begin_dt                          -- 当前利率生效日期
   ,null                                 -- 下次利率调整日期
   ,t1.oper_teller_id                    -- 客户经理编号
   ,t1.oper_org_id                       -- 开户机构编号
   ,t1.mgmt_org_id                       -- 管理机构编号
   ,t1.fin_org_id                        -- 账务机构编号
   ,t1.loan_tot_perds                    -- 原始贷款期数
   ,t1.loan_tot_perds                    -- 贷款期数
   ,t1.currt_perds                       -- 当前期数
   ,t1.loan_tot_perds - t1.currt_perds   -- 剩余期数
   ,t6.ovd_count                         -- 逾期期数
   ,t1.ovdue_days                        -- 本金逾期天数
   ,t1.ovdue_days                        -- 利息逾期天数
   ,t1.grace_days                        -- 宽限期天数
   ,0                                    -- 分期手续费费率
   ,T1.base_rat                          -- 基准利率
   ,t1.exec_int_rat                      -- 执行利率
   ,t1.ovdue_exec_int_rat                -- 逾期利率
   ,(t1.exec_int_rat /360)               -- 每日执行利率
   ,0                                    -- 固收利率
   ,t3.cont_amt                          -- 合同金额
   ,t1.dubil_amt                         -- 借据金额
   ,t1.dubil_amt                         -- 放款金额
   ,t1.dubil_amt                         -- 原始放款金额
   ,t1.bank_contri_ratio                 -- 银行出资比例
   ,nvl(t1.td_provi_int,0)               -- 当日应计利息
   ,nvl(t1.int_bal,0) + nvl(t1.ovdue_int_bal,0) -- 当期应计利息
   ,nvl(t1.nomal_pric_bal,0)             -- 正常本金
   ,nvl(t1.ovdue_pric_bal,0)             -- 逾期本金
   ,0                                    -- 呆滞本金
   ,0                                    -- 呆账本金
   ,case when t1.wrt_off_flg = '1' then nvl(t1.nomal_pric_bal,0) + nvl(t1.ovdue_pric_bal,0) else 0 end -- 核销本金
   ,nvl(t1.int_bal,0)                    -- 正常利息
   ,nvl(t1.ovdue_int_bal,0)              -- 逾期利息
   ,case when t1.wrt_off_flg = '1' then nvl(t1.ovdue_int_bal,0) + nvl(t1.pnlt_bal,0) end-- 核销利息
   ,0                                    -- 逾期本金罚息
   ,0                                    -- 逾期利息罚息
   ,nvl(t1.int_bal,0) + nvl(t1.ovdue_int_bal,0)  -- 应收欠息
   ,nvl(t1.recvbl_pnlt,0)                -- 应收应计罚息
   ,nvl(t1.pnlt_bal,0)                   -- 应收罚息
   ,0                                    -- 应收费用
   ,case when t1.ovdue_days < 90   then nvl(t1.pnlt_bal,0) + nvl(t1.ovdue_int_bal,0) else 0 end -- 表内欠息余额
   ,case when t1.ovdue_days >= 90  then nvl(t1.pnlt_bal,0) + nvl(t1.ovdue_int_bal,0) else 0 end -- 表外欠息余额
   ,case when t1.ovdue_days < 90 then nvl(t1.int_bal,0) + nvl(t1.ovdue_int_bal,0) + nvl(t1.pnlt_bal,0) else 0 end -- 表内利息
   ,case when t1.ovdue_days >= 90  then nvl(t1.int_bal,0) + nvl(t1.ovdue_int_bal,0) + nvl(t1.pnlt_bal,0) else 0 end -- 表外利息
  ,nvl(t1.int_bal,0) + nvl(t1.pnlt_bal,0)                                               -- 累计应收未收利息金额
   ,nvl(t1.rpbl_pric,0)                                                                  -- 已偿还正常本金
   ,0                                                                                    -- 已偿还逾期本金
   ,nvl(t1.paid_int,0)                                                                   -- 已偿还正常利息
   ,0                                                                                    -- 已偿还逾期利息
   ,nvl(t1.paid_pnlt,0)                                                                  -- 已偿还逾期本金罚息
   ,0                                                                                    -- 已偿还逾期利息罚息
   ,nvl(t1.paid_adv_repay_comm_fee,0)                                                    -- 已偿还费用
   ,nvl(t1.nomal_pric_bal,0) + nvl(t1.ovdue_pric_bal,0)                                  -- 本金余额
   ,nvl(t1.nomal_pric_bal,0) + nvl(t1.ovdue_pric_bal,0) -- 当期余额
   ,nvl(t1.nomal_pric_bal,0) + nvl(t1.ovdue_pric_bal,0) * nvl(t5.convt_cny_exch_rat, 1)  -- 折本币当期余额
   ,t1.job_cd                                                                            -- 任务代码
   ,to_timestamp('${batch_timestamp}','yyyy-mm-dd hh24:mi:ss.ff6')
 from ${iml_schema}.agt_zjdk_dubil_info_h t1
 left join ${iml_schema}.agt_zjdk_crdt_appl_info_h t2
   on t1.intnal_dubil_id = t2.intnal_dubil_id
  and t2.lmt_cont_flg = '02'
  and t2.crdt_status_cd = 'Finished'
  and t2.start_dt <= to_date('${batch_date}', 'yyyymmdd')
  and t2.end_dt > to_date('${batch_date}', 'yyyymmdd')
  and t2.job_cd = 'icmsf1'
 left join ${iml_schema}.agt_zjdk_loan_cont_info_h t3
   on t1.intnal_dubil_id = t3.intnal_dubil_id
  and t3.lmt_cont_flg = '02'
--  and t3.cont_valid_flg = '1'
  and t3.start_dt <= to_date('${batch_date}', 'yyyymmdd')
  and t3.end_dt > to_date('${batch_date}', 'yyyymmdd')
  and t3.job_cd = 'icmsf1'
 left join(select intnal_dubil_id
                 ,repay_num_id
                 ,repay_num_open_acct_org_name
                 ,row_number() over(partition by intnal_dubil_id order by acct_dt desc,tran_dt desc)as rn  
             from ${iml_schema}.evt_zjdk_repay_flow
            where start_dt <= to_date('${batch_date}', 'yyyymmdd')
              and end_dt > to_date('${batch_date}', 'yyyymmdd')
              and job_cd = 'icmsf1'
          )t4
   on t1.intnal_dubil_id = t4.intnal_dubil_id
  and t4.rn = 1
 left join ${iml_schema}.ref_cny_fori_exch_mdl_p_h t5
   on t5.curr_cd = 'CNY'
  and t5.start_dt <= to_date('${batch_date}', 'yyyymmdd')
  and t5.end_dt > to_date('${batch_date}', 'yyyymmdd')
  and t5.job_cd ='ncbsf1'
 left join (select intnal_dubil_id,count(1) as ovd_count 
              from ${iml_schema}.agt_zjdk_repay_plan
              where curr_issue_status_cd = '02' --'OVD'
                and start_dt <= to_date('${batch_date}','yyyymmdd')
                and end_dt > to_date('${batch_date}','yyyymmdd')
                and job_cd = 'icmsf1'
                group by intnal_dubil_id
           )t6
   on t1.intnal_dubil_id = t6.intnal_dubil_id
 left join (select intnal_dubil_id,max(tran_dt) as last_repaydt 
              from ${iml_schema}.agt_zjdk_repay_dtl
              where start_dt <= to_date('${batch_date}','yyyymmdd')
                and end_dt > to_date('${batch_date}','yyyymmdd')
                and tran_dt <= to_date('${batch_date}','yyyymmdd')
                and job_cd = 'icmsf1'
             group by intnal_dubil_id
            )t7
   on t1.intnal_dubil_id = t7.intnal_dubil_id
where 1=1
  and t1.start_dt <= to_date('${batch_date}', 'yyyymmdd')
  and t1.end_dt > to_date('${batch_date}', 'yyyymmdd')
  and t1.job_cd ='icmsf1'
  and t1.payoff_dt < trunc(to_date('${batch_date}', 'yyyymmdd'), 'yyyy')
;
commit;

-- 第九组（共九组）微业贷
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ into ${icl_schema}.cmm_unite_wl_dubil_info_clear_ex(
   etl_dt                                 --数据日期
   ,lp_id                                 --法人编号
   ,dubil_id                              --借据编号
   ,core_dubil_id                         --核心借据编号
   ,cont_id                               --合同编号
   ,std_prod_id                           --标准产品编号
   ,prod_id                               --产品编号
   ,cust_id                               --客户编号
   ,subj_id                               --科目编号
   ,acctnt_cate_cd                        --会计类别代码
   ,enter_acct_acct_num                   --入账账号
   ,repay_num                             --还款账号
   ,rela_agt_id                           --关联协议编号
   ,rela_appl_flow_num                    --关联申请流水号
   ,curr_cd                               --币种代码
   ,bus_breed_id                          --业务品种编号
   ,loan_type_cd                          --贷款类型代码
   ,intnal_loan_type_cd                    --行内贷款类型代码
   ,asset_thd_cls_cd                      --资产三分类
   ,dubil_status_cd                       --借据状态代码
   ,loan_usage_cd                         --贷款用途代码
   ,dir_indus_cd                          --贷款贷款贷款投向行业代码
   ,cont_status_cd                        --合同状态代码
   ,loan_level4_cls_cd                    --贷款四级分类代码
   ,loan_level5_cls_cd                    --贷款五级分类代码
   ,loan_level10_cls_cd                   --贷款十级分类代码
   ,loan_level12_cls_cd                   --贷款十二级分类代码
   ,acru_non_acru_cd                      --应计非应计代码
   ,repay_way_cd                          --还款方式代码
   ,int_set_way_cd                        --结息方式代码
   ,int_accr_way_cd                       --计息方式代码
   ,int_rat_adj_way_cd                    --利率调整方式代码
   ,int_rat_adj_ped_corp_cd               --利率调整周期单位代码
   ,int_rat_adj_ped_freq                  --利率调整周期频率
   ,int_rat_base_type_cd                  --利率基准类型代码
   ,int_rat_float_way_cd                  --利率浮动方式代码
   ,int_rat_float_dir_cd                  --利率浮动方向代码
   ,int_rat_flo_val                       --利率浮动值
   ,pric_repay_freq_cd                    --本金还款周期频率
   ,int_repay_freq_cd                     --利息还款周期频率
   ,guar_way_cd                           --担保方式代码
   ,cust_char_cd                          --客户性质代码
   ,enter_acct_acct_num_type              --入账账号类型
   ,enter_acct_bank_name                  --入账账户开户银行名称
   ,repay_num_type                        --还款账号类型
   ,repay_open_acct_bank_id               --还款账户开户银行编号
   ,repay_open_acct_org_name              --还款账户开户机构名称
   ,intnal_carr_flg                       --内部结转标志
   ,dom_overs_flg                         --境内外标志
   ,white_list_cust_flg                   --白户标志
   ,farm_flg                              --农户标志
   ,agclt_flg                             --涉农标志
   ,int_accr_flg                          --计息标志
   ,comp_int_flg                          --复息标志
   ,ovdue_flg                             --逾期标志
   ,wrt_off_flg                           --核销标志
   ,pbc_inc_loan_flg                      --人行普惠贷款标志
   ,cred_rht_turn_flg                     --债权直转标志
   ,regroup_flg                           --重组标志
   ,regroup_loan_type_cd                  --重组贷款类型代码
   ,regroup_dt                            --重组日期
   ,open_acct_dt                          --开户日期
   ,distr_dt                              --放款日期
   ,init_distr_dt                         --原始放款日期
   ,value_dt                              --起息日期
   ,exp_dt                                --到期日期
   ,init_exp_dt                           --原始到期日期
   ,payoff_dt                             --结清日期
   ,last_repay_dt                         --上次还款日期
   ,next_repay_dt                         --下次还款日期
   ,curr_int_rat_effect_dt                --当前利率生效日期
   ,next_int_rat_adj_dt                   --下次利率调整日期
   ,cust_mgr_id                           --客户经理编号
   ,open_acct_org_id                      --开户机构编号
   ,mgmt_org_id                           --管理机构编号
   ,acct_instit_id                        --账务机构编号
   ,init_tot_perds                        --原始贷款期数
   ,tot_perds                             --贷款期数
   ,curr_issue_perds                      --当前期数
   ,surp_perds                            --剩余期数
   ,ovdue_perds                           --逾期期数
   ,pric_ovdue_days                       --本金逾期天数
   ,int_ovdue_days                        --利息逾期天数
   ,grace_period_days                     --宽限期天数
   ,inst_comm_fee_rat                     --分期手续费费率
   ,base_rat                              --基准利率
   ,exec_int_rat                          --执行利率
   ,ovdue_int_rat                         --逾期利率
   ,daily_exec_int_rat                    --每日执行利率
   ,int_rat                               --固收利率
   ,cont_amt                              --合同金额
   ,dubil_amt                             --借据金额
   ,distr_amt                             --放款金额
   ,init_distr_amt                        --原始放款金额
   ,bank_contri_ratio                     --银行出资比例
   ,td_acru_int                           --当日应计利息
   ,currt_acru_int                        --当期应计利息
   ,nomal_pric                            --正常本金
   ,ovdue_pric                            --逾期本金
   ,idle_pric                             --呆滞本金
   ,bad_debt_pric                         --呆账本金
   ,wrt_off_pric                          --核销本金
   ,nomal_int                             --正常利息
   ,ovdue_int                             --逾期利息
   ,wrt_off_int                           --核销利息
   ,ovdue_pric_pnlt                       --逾期本金罚息
   ,ovdue_int_pnlt                        --逾期利息罚息
   ,recvbl_over_int                       --应收欠息
   ,recvbl_acru_pnlt                      --应收应计罚息
   ,recvbl_pnlt                           --应收罚息
   ,recvbl_fee                            --应收费用
   ,in_bs_over_int_bal                    --表内欠息余额
   ,off_bs_over_int_bal                   --表外欠息余额
   ,in_bs_int                             --表内利息
   ,off_bs_int                            --表外利息
   ,acm_recvbl_uncol_int_amt              --累计应收未收利息金额
   ,repaid_nomal_pric                     --已偿还正常本金
   ,repaid_ovdue_pric                     --已偿还逾期本金
   ,repaid_nomal_int                      --已偿还正常利息
   ,repaid_ovdue_int                      --已偿还逾期利息
   ,repaid_ovdue_pric_pnlt                --已偿还逾期本金罚息
   ,repaid_ovdue_int_pnlt                 --已偿还逾期利息罚息
   ,repaid_fee                            --已偿还费用
   ,pric_bal                              --本金余额
   ,currt_bal                             --当期余额
   ,cl_curr_currt_bal                     --折本币当期余额
   ,job_cd                                --任务代码
   ,etl_timestamp                         --etl处理时间戳
)
select
   to_date('${batch_date}','yyyymmdd')   -- 数据日期
   ,t1.lp_id                             -- 法人编号
   ,t1.dubil_id                          -- 借据编号
   ,t1.dubil_id                          -- 核心借据编号
   ,t1.cont_id                           -- 合同编号
   ,t1.prod_id                           -- 标准产品编号
   ,t1.prod_id                           -- 产品编号
   ,t1.cust_id                           -- 客户编号
   ,case when t1.prod_id='201020100063' then '13030202' 
           else '13030101'  end       -- 科目编号(公司流动资金贷款)
   ,''                                   -- 会计类别代码
   ,t1.distr_acct_id                     -- 入账账号
   ,t1.repay_num_id                      -- 还款账号
   ,''                                   -- 关联协议编号**
   ,t1.out_acct_flow_num                 -- 关联申请流水号**
   ,t1.curr_cd                           -- 币种代码
   ,t1.prod_id                           -- 业务品种编号
   ,'00'                                 -- 贷款类型代码
   ,t1.prod_cls_cd                    --行内贷款类型代码
   ,t1.asset_thd_cls_cd                  -- 资产三分类代码
   ,case when t1.loan_status_cd = '0' then '1'
          when t1.loan_status_cd in ('2','4','3') then '6'
          else '0' end                  -- 借据状态代码
   ,t1.loan_usage_cd                     -- 贷款用途代码
   ,t2.indus_subclass_cd                 -- 贷款贷款贷款投向行业代码
   ,case when ${iml_schema}.dateformat_max2(t2.payoff_dt) <> ${iml_schema}.dateformat_max2('') then 'CLEAR'
          when t1.loan_status_cd = '1' then 'OVD'
          else 'NORMAL' end             -- 合同状态代码
   ,'00'                                 -- 贷款四级分类代码
   ,t1.level5_cls_cd                     -- 贷款五级分类代码
   ,case when t2.ovdue_days = 0 then '15'
         when t2.ovdue_days >= 1 and t2.ovdue_days <= 59  then '21'
         when t2.ovdue_days >= 60 and t2.ovdue_days <= 89 then '22'
         when t2.ovdue_days >= 90 and t2.ovdue_days <= 120 then '30'
         when t2.ovdue_days >= 121 and t2.ovdue_days <= 180 then '40'
         when t2.ovdue_days >= 181 then '50'
         else '90' end                   -- 贷款十级分类代码
   ,'11'                                 -- 贷款十二级分类代码
   ,''                                   -- 应计非应计代码
   ,t1.repay_way_cd                      -- 还款方式代码
   ,t1.int_set_way_cd                    -- 结息方式代码
   ,t1.int_accr_way_cd                   -- 计息方式代码
   ,decode(t1.int_rat_adj_way_cd,'7','0','1') -- 利率调整方式代码
   ,decode(t1.int_rat_adj_way_cd,'0','N','O') -- 利率调整周期单位代码
   ,'0'                                  -- 利率调整周期频率
   ,t1.base_rat_type_cd                  -- 利率基准类型代码
   ,decode(t1.int_rat_float_way_cd,'0','0','1','2','2','2','3','0','4','1','5','1','-')  -- 利率浮动方式代码
   ,'-'                                  -- 利率浮动方向代码
   ,t1.int_rat_flo_val                   -- 利率浮动值
   ,t2.repay_freq_cd                     -- 本金还款频率代码
   ,t2.repay_freq_cd                     -- 利息还款频率代码
   ,t2.guar_way_cd                       -- 担保方式代码
   ,'07'                                 -- 客户性质代码
   ,''                                   -- 入账账号类型
   ,t1.distr_org_name                    -- 入账账户开户银行名称
   ,''                                   -- 还款账号类型
   ,t1.repay_org_id                      -- 还款账户开户银行编号
   ,t1.repay_org_name                    -- 还款账户开户机构名称
   ,''                                   -- 内部结转标志
   ,'1'                                  -- 境内外标志
   ,t1.white_list_cust_flg               -- 白户标志
   ,''                                   -- 农户标志
   ,''                                   -- 涉农标志
   ,t2.int_accr_flg                      -- 计息标志
   ,'1'                                  -- 复息标志
   ,case when t1.loan_status_cd = '1' then '1' else '0' end -- 逾期标志
   ,case when t1.loan_status_cd = '5' then '1' else '0' end -- 核销标志
   ,case when t8.cust_id is not null and t8.nmal_amt <= 100000000 and t6.belong_indus_acct like 'P%' then '1'
         when t7.cust_id is not null and t7.nmal_amt <= 100000000 then '1' else '0' end   -- 人行普惠贷款标志**
   ,''                                   -- 债权直转标志
   ,t2.regroup_loan_flg                  -- 重组标志
   ,''                                   -- 重组贷款类型代码
   ,t2.regroup_dt                        -- 重组日期
   ,t1.effect_dt                         -- 开户日期
   ,t1.effect_dt                         -- 放款日期
   ,t1.effect_dt                         -- 原始放款日期
   ,t1.value_dt                          -- 起息日期
   ,t1.exp_dt                            -- 到期日期
   ,t1.exp_dt                            -- 原始到期日期
   ,t2.payoff_dt                         -- 结清日期
   ,null                                 -- 上次还款日期
   ,null                                 -- 下次还款日期
   ,t1.effect_dt                         -- 当前利率生效日期
   ,null                                 -- 下次利率调整日期
   ,t1.rgst_teller_id                    -- 客户经理编号
   ,t1.rgst_org_id                       -- 开户机构编号
   ,t1.rgst_org_id                       -- 管理机构编号
   ,t1.fin_org_id                        -- 账务机构编号
   ,t1.loan_tenor                        -- 原始贷款期数
   ,t1.loan_tenor                        -- 贷款期数
   ,t2.curr_perds                        -- 当前期数
   ,t4.term                              -- 剩余期数
   ,t4.ovdterm                           -- 逾期期数
   ,t2.ovdue_days                        -- 本金逾期天数
   ,t2.ovdue_days                        -- 利息逾期天数
   ,t2.grace_period                      -- 宽限期天数
   ,0                                    -- 分期手续费费率
   ,t1.base_rat                          -- 基准利率
   ,t1.loan_int_rat                      -- 执行利率
   ,t1.ovdue_int_rat                     -- 逾期利率
   ,(t1.loan_int_rat /360)               -- 每日执行利率
   ,0                                    -- 固收利率
   ,nvl(t1.loan_amt,0)                   -- 合同金额
   ,nvl(t1.loan_amt,0)                   -- 借据金额
   ,nvl(t1.loan_amt,0)                   -- 放款金额
   ,nvl(t1.loan_amt,0)                   -- 原始放款金额
   ,nvl(t9.participantratio,1)           -- 银行出资比例
   ,nvl(t1.td_acru_int,0)                -- 当日应计利息
   ,nvl(t2.int_recvbl,0) + nvl(t2.ovdue_int,0) -- 当期应计利息
   ,nvl(t1.loan_bal,0) - nvl(t2.ovdue_pric,0) -- 正常本金
   ,nvl(t2.ovdue_pric,0)                 -- 逾期本金
   ,case when t2.ovdue_days > 90 then nvl(t2.ovdue_pric,0) else 0 end  -- 呆滞本金
   ,0                                    -- 呆账本金
   ,0                                    -- 核销本金
   ,nvl(t2.int_recvbl,0)                 -- 正常利息
   ,nvl(t2.ovdue_int,0)                  -- 逾期利息
   ,0                                    -- 核销利息
   ,nvl(t4.rpbl_pric_pnlt,0)             -- 逾期本金罚息
   ,nvl(t4.rpbl_int_pnlt,0)              -- 逾期利息罚息
   ,nvl(t1.recvbl_over_int,0)            -- 应收欠息
   ,nvl(t1.recvbl_acru_pnlt,0)           -- 应收应计罚息
   ,nvl(t1.recvbl_pnlt,0)                -- 应收罚息
   ,0                                    -- 应收费用
   ,case when t2.ovdue_days < 90 then nvl(t1.recvbl_over_int,0) else 0 end -- 表内欠息余额
   ,case when t2.ovdue_days >= 90  then nvl(t1.recvbl_over_int,0) else 0 end -- 表外欠息余额
   ,case when t2.ovdue_days < 90 then nvl(t2.int_recvbl,0) + nvl(t2.ovdue_int,0) +  nvl(t4.rpbl_pric_pnlt,0) + nvl(t4.rpbl_int_pnlt,0) else 0 end -- 表内利息
   ,case when t2.ovdue_days >= 90  then nvl(t2.int_recvbl,0) + nvl(t2.ovdue_int,0) +  nvl(t4.rpbl_pric_pnlt,0) + nvl(t4.rpbl_int_pnlt,0) else 0 end -- 表外利息
   ,t4.ljys                                               -- 累计应收未收利息金额
   ,nvl(t3.reppay,0)                                     -- 已偿还正常本金
   ,nvl(t3.oreppay,0)                                    -- 已偿还逾期本金
   ,nvl(t3.reipay,0)                                     -- 已偿还正常利息
   ,nvl(t3.oreipay,0)                                    -- 已偿还逾期利息
   ,nvl(t3.repppay,0)                                    -- 已偿还逾期本金罚息
   ,0                                                    -- 已偿还逾期利息罚息
   ,0                                                    -- 已偿还费用
   ,nvl(t1.loan_bal,0)                                   -- 本金余额
   ,nvl(t1.loan_bal,0)                                   -- 当期余额
   ,nvl(t1.loan_bal,0) * nvl(t5.convt_cny_exch_rat, 1)   -- 折本币当期余额
   ,t1.job_cd                                                                            -- 任务代码
   ,to_timestamp('${batch_timestamp}','yyyy-mm-dd hh24:mi:ss.ff6')
 from ${iml_schema}.agt_wyd_dubil_h t1
 left join ${iml_schema}.agt_wyd_dubil_attach_info t2
   on t1.dubil_id = t2.dubil_id
  and t2.etl_dt = to_date('${batch_date}', 'yyyymmdd')
 left join (select dubil_id
                   ,sum(case when repay_type_cd in ('01','05','06') then nvl(repay_pric,0) else 0 end ) as reppay --正常本金
                   ,sum(case when repay_type_cd = '03' then nvl(repay_pric,0) else 0 end ) as oreppay             --逾期本金
                   ,sum(case when repay_type_cd in ('01','05','06') then nvl(repay_int,0) else 0 end) as reipay        --正常利息
                   ,sum(case when repay_type_cd = '03' then nvl(repay_int,0) else 0 end) as oreipay               --逾期利息
                   ,sum(case when repay_type_cd = '03' then nvl(repay_pnlt,0) else 0 end) as repppay              --本金罚息
              from ${iml_schema}.evt_wyd_repay_dtl
             where etl_dt <= to_date('${batch_date}', 'yyyymmdd')
                and job_cd ='icmsi1'
              group by dubil_id ) t3
   on t1.dubil_id = t3.dubil_id
  left join (select dubil_id
                     ,sum(case when currt_aldy_payoff_flg <> '1' then 1 else 0 end) as term
                     ,sum(case when pric_status_cd = '10' then 1 else 0 end) as ovdterm
                     ,sum(rpbl_pric_pnlt) as rpbl_pric_pnlt
                     ,sum(rpbl_int_pnlt) as rpbl_int_pnlt
                     ,sum(case when to_date('${batch_date}', 'yyyymmdd') >= exp_dt - 1 then nvl(rpbl_int,0) - nvl(paid_int,0) else 0 end) as ljys
                 from ${iml_schema}.agt_wyd_repay_plan
                where etl_dt = to_date('${batch_date}', 'yyyymmdd')
                  and job_cd ='icmsf1'
                group by dubil_id
            ) t4
   on t1.dubil_id = t4.dubil_id
 left join ${iml_schema}.ref_cny_fori_exch_mdl_p_h t5
   on t5.curr_cd = 'CNY'
  and t5.start_dt <= to_date('${batch_date}', 'yyyymmdd')
  and t5.end_dt > to_date('${batch_date}', 'yyyymmdd')
  and t5.job_cd ='ncbsf1'
  left join (select t1.cust_num, t2.belong_indus_acct
                 from ${iol_schema}.eifs_t00_party_pub_info t1
                 left join ${iol_schema}.eifs_t01_corp_cust_info t2
                   on t1.party_id = t2.party_id
                  and t2.start_dt <= to_date('${batch_date}', 'yyyymmdd')
                  and t2.end_dt > to_date('${batch_date}', 'yyyymmdd')
                where t1.start_dt <= to_date('${batch_date}', 'yyyymmdd')
                  and t1.end_dt > to_date('${batch_date}', 'yyyymmdd')
            ) t6
   on t1.cust_id = t6.cust_num
  left join (select t1.cust_id,sum(t1.nmal_amt) as nmal_amt
                 from ( select t1.cust_id,sum(t1.crdt_lmt)as nmal_amt
                           from ${iml_schema}.agt_wyd_lmt_h t1
                           left join ${iml_schema}.agt_wyd_out_acct_appl t2
                             on t1.cust_id = t2.cust_id
                            and t2.etl_dt = to_date('${batch_date}', 'yyyymmdd')
                            and t2.corp_size_cd in ('3','4')
                          where t1.lmt_status_cd = '2'
                            and t1.etl_dt = to_date('${batch_date}', 'yyyymmdd')
                          group by t1.cust_id
                          union all
                         select cust_id, sum(nmal_amt) as nmal_amt
                           from ${iml_schema}.agt_crdt_lmt_info_h
                          where lmt_prod_id not in '10000000001' --去掉单一最高授信额度
                            and (status_cd = 'Effective' or crdt_nmal_bal > 0) --额度有效或有余额
                            and substr(lmt_prod_id, 1, 7) = '1000101' --公司客户自用额度
                            and job_cd = 'icmsf1'
                            and start_dt <= to_date('${batch_date}', 'yyyymmdd')
                            and end_dt > to_date('${batch_date}', 'yyyymmdd')
                          group by cust_id
                        ) t1 group by t1.cust_id
            ) t7
   on t7.cust_id = t1.cust_id
   left join (select t1.cust_id,sum(t1.nmal_amt) as nmal_amt
                 from (select t1.cust_id,sum(t1.crdt_lmt) as nmal_amt
                          from ${iml_schema}.agt_wyd_lmt_h t1
                          left join ${iml_schema}.agt_wyd_out_acct_appl t2
                            on t1.cust_id = t2.cust_id
                           and t2.etl_dt = to_date('${batch_date}', 'yyyymmdd')
                          -- and t2.corp_size_cd in ('3','4')
                         where t1.lmt_status_cd = '2'
                           and t1.etl_dt = to_date('${batch_date}', 'yyyymmdd')
                         group by t1.cust_id
                        union all
                        select cust_id, sum(nmal_amt) as nmal_amt
                          from ${iml_schema}.agt_crdt_lmt_info_h
                         where lmt_prod_id not in '10000000001' --去掉单一最高授信额度
                           and (status_cd = 'Effective' or crdt_nmal_bal > 0) --额度有效或有余额
                           and substr(lmt_prod_id, 1, 7) = '1000101' --公司客户自用额度
                           and job_cd = 'icmsf1'
                           and start_dt <= to_date('${batch_date}', 'yyyymmdd')
                           and end_dt > to_date('${batch_date}', 'yyyymmdd')
                         group by cust_id
                         ) t1 group by t1.cust_id
            ) t8
   on t8.cust_id = t1.cust_id
 left join ${iol_schema}.icms_wyd_loan t9  
   on t1.dubil_id=t9.lendingref
  and t9.etl_dt =to_date('${batch_date}', 'yyyymmdd')
where 1 = 1
  and t1.etl_dt = to_date('${batch_date}', 'yyyymmdd')
  and t1.job_cd ='icmsf1'
  and t2.payoff_dt < trunc(to_date('${batch_date}', 'yyyymmdd'), 'yyyy')
;
commit;


-- 第十组（共十二组）唯品合作贷
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ into ${icl_schema}.cmm_unite_wl_dubil_info_clear_ex(
   etl_dt	                             --数据日期
   ,lp_id	                             --法人编号
   ,dubil_id	                         --借据编号
   ,core_dubil_id                        --核心借据编号
   ,cont_id	                             --合同编号
   ,std_prod_id                          --标准产品编号
   ,prod_id	                             --产品编号
   ,cust_id	                             --客户编号
   ,subj_id	                             --科目编号
   ,acctnt_cate_cd                       --会计类别代码
   ,enter_acct_acct_num	                 --入账账号
   ,repay_num	                         --还款账号
   ,rela_agt_id	                         --关联协议编号
   ,rela_appl_flow_num                   --关联申请流水号
   ,curr_cd	                             --币种代码
   ,bus_breed_id	                     --业务品种编号
   ,loan_type_cd	                     --贷款类型代码
   ,intnal_loan_type_cd                    --行内贷款类型代码
   ,asset_thd_cls_cd			         --资产三分类代码
   ,dubil_status_cd	                     --借据状态代码
   ,loan_usage_cd	                     --贷款用途代码
   ,dir_indus_cd	                     --贷款贷款贷款投向行业代码
   ,cont_status_cd	                     --合同状态代码
   ,loan_level4_cls_cd	                 --贷款四级分类代码
   ,loan_level5_cls_cd	                 --贷款五级分类代码
   ,loan_level10_cls_cd	                 --贷款十级分类代码
   ,loan_level12_cls_cd	                 --贷款十二级分类代码
   ,acru_non_acru_cd	                 --应计非应计代码
   ,repay_way_cd	                     --还款方式代码
   ,int_set_way_cd	                     --结息方式代码
   ,int_accr_way_cd	                     --计息方式代码
   ,int_rat_adj_way_cd	                 --利率调整方式代码
   ,int_rat_adj_ped_corp_cd	             --利率调整周期单位代码
   ,int_rat_adj_ped_freq	             --利率调整周期频率
   ,int_rat_base_type_cd	             --利率基准类型代码
   ,int_rat_float_way_cd                 --利率浮动方式代码
   ,int_rat_float_dir_cd                 --利率浮动方向代码
   ,int_rat_flo_val                      --利率浮动值
   ,pric_repay_freq_cd	                 --本金还款周期频率
   ,int_repay_freq_cd	                 --利息还款周期频率
   ,guar_way_cd	                         --担保方式代码
   ,cust_char_cd                         --客户性质代码
   ,enter_acct_acct_num_type             --入账账号类型
   ,enter_acct_bank_name                 --入账账户开户银行名称
   ,repay_num_type	                     --还款账号类型
   ,repay_open_acct_bank_id              --还款账户开户银行编号
   ,repay_open_acct_org_name             --还款账户开户机构名称
   ,intnal_carr_flg	                     --内部结转标志
   ,dom_overs_flg	                     --境内外标志
   ,white_list_cust_flg                  --白户标志
   ,farm_flg                             --农户标志
   ,agclt_flg                            --涉农标志
   ,int_accr_flg	                     --计息标志
   ,comp_int_flg	                     --复息标志
   ,ovdue_flg	                         --逾期标志
   ,wrt_off_flg                          --核销标志
   ,pbc_inc_loan_flg                     --人行普惠贷款标志
   ,cred_rht_turn_flg                    --债权直转标志
   ,regroup_flg                          --重组标志
   ,regroup_loan_type_cd                 --重组贷款类型代码
   ,regroup_dt                           --重组日期
   ,open_acct_dt	                     --开户日期
   ,distr_dt	                         --放款日期
   ,init_distr_dt	                     --原始放款日期
   ,value_dt	                         --起息日期
   ,exp_dt	                             --到期日期
   ,init_exp_dt                          --原始到期日期
   ,payoff_dt	                         --结清日期
   ,last_repay_dt	                     --上次还款日期
   ,next_repay_dt	                     --下次还款日期
   ,curr_int_rat_effect_dt	             --当前利率生效日期
   ,next_int_rat_adj_dt	                 --下次利率调整日期
   ,cust_mgr_id	                         --客户经理编号
   ,open_acct_org_id	                 --开户机构编号
   ,mgmt_org_id	                         --管理机构编号
   ,acct_instit_id	                     --账务机构编号
   ,init_tot_perds                       --原始贷款期数
   ,tot_perds	                         --贷款期数
   ,curr_issue_perds	                 --当前期数
   ,surp_perds	                         --剩余期数
   ,ovdue_perds	                         --逾期期数
   ,pric_ovdue_days	                     --本金逾期天数
   ,int_ovdue_days	                     --利息逾期天数
   ,grace_period_days	                 --宽限期天数
   ,inst_comm_fee_rat	                 --分期手续费费率
   ,base_rat	                         --基准利率
   ,exec_int_rat	                     --执行利率
   ,ovdue_int_rat	                     --逾期利率
   ,daily_exec_int_rat	                 --每日执行利率
   ,int_rat                              --固收利率
   ,cont_amt	                         --合同金额
   ,dubil_amt	                         --借据金额
   ,distr_amt	                         --放款金额
   ,init_distr_amt	                     --原始放款金额
   ,bank_contri_ratio                    --银行出资比例
   ,td_acru_int	                         --当日应计利息
   ,currt_acru_int	                     --当期应计利息
   ,nomal_pric	                         --正常本金
   ,ovdue_pric	                         --逾期本金
   ,idle_pric                            --呆滞本金
   ,bad_debt_pric                        --呆账本金
   ,wrt_off_pric                         --核销本金
   ,nomal_int	                         --正常利息
   ,ovdue_int	                         --逾期利息
   ,wrt_off_int                          --核销利息
   ,ovdue_pric_pnlt	                     --逾期本金罚息
   ,ovdue_int_pnlt	                     --逾期利息罚息
   ,recvbl_over_int	                     --应收欠息
   ,recvbl_acru_pnlt	                 --应收应计罚息
   ,recvbl_pnlt	                         --应收罚息
   ,recvbl_fee	                         --应收费用
   ,in_bs_over_int_bal	                 --表内欠息余额
   ,off_bs_over_int_bal	                 --表外欠息余额
   ,in_bs_int	                         --表内利息
   ,off_bs_int	                         --表外利息
   ,acm_recvbl_uncol_int_amt	         --累计应收未收利息金额
   ,repaid_nomal_pric	                 --已偿还正常本金
   ,repaid_ovdue_pric	                 --已偿还逾期本金
   ,repaid_nomal_int	                 --已偿还正常利息
   ,repaid_ovdue_int	                 --已偿还逾期利息
   ,repaid_ovdue_pric_pnlt	             --已偿还逾期本金罚息
   ,repaid_ovdue_int_pnlt	             --已偿还逾期利息罚息
   ,repaid_fee	                         --已偿还费用
   ,pric_bal	                         --本金余额
   ,currt_bal	                         --当期余额
   ,cl_curr_currt_bal	                 --折本币当期余额
   ,job_cd                               --任务代码
   ,etl_timestamp                        --etl处理时间戳
)
select
   to_date('${batch_date}','yyyymmdd')   -- 数据日期
   ,t1.lp_id                             -- 法人编号
   ,t1.dubil_id                          -- 借据编号
   ,t1.core_dubil_id                     -- 核心借据编号
   ,t1.cont_id                           -- 合同编号
   ,t1.prod_id                           -- 标准产品编号
   ,t1.prod_id                           -- 产品编号
   ,t1.cust_id                           -- 客户编号
   ,'13030203'                           -- 科目编号(个人消费类贷款用途)
   ,''                                   -- 会计类别代码
   ,t6.acctno                            -- 入账账号
   ,t1.repay_num_id                      -- 还款账号
   ,''                                   -- 关联协议编号**
   ,t1.out_acct_flow_num                 -- 关联申请流水号
   ,t1.curr_cd                           -- 币种代码
   ,t1.prod_id                           -- 业务品种编号
   ,'00'                                 -- 贷款类型代码
   ,''                    --行内贷款类型代码
   ,t1.asset_thd_cls_cd                  -- 资产三分类代码
   ,case when t1.accti_status_cd = 'ZHC' then '1' 
         else '0' end                    -- 借据状态代码
   ,t1.loan_usage_cd                     -- 贷款用途代码
   ,''                                   -- 贷款贷款贷款投向行业代码(公司贷款监管才强制监管)
   ,case when ${iml_schema}.dateformat_max2(t1.payoff_dt) <> ${iml_schema}.dateformat_max2('') then 'CLEAR'
         when t1.accti_status_cd = 'YUQ' then 'OVD'
         else 'NORMAL' end               -- 合同状态代码
   ,'00'                                 -- 贷款四级分类代码
   ,t1.loan_level5_cls_cd                -- 贷款五级分类代码
   ,case when t1.ovdue_days = 0 then '15'
         when t1.ovdue_days >= 1 and t1.ovdue_days <= 59  then '21'
         when t1.ovdue_days >= 60 and t1.ovdue_days <= 89 then '22'
         when t1.ovdue_days >= 90 and t1.ovdue_days <= 120 then '30'
         when t1.ovdue_days >= 121 and t1.ovdue_days <= 180 then '40'
         when t1.ovdue_days >= 181 then '50'
         else '90' end                   -- 贷款十级分类代码
   ,'11'                                 -- 贷款十二级分类代码
   ,''                                   -- 应计非应计代码
   ,t1.repay_way_cd                      -- 还款方式代码
   ,t1.int_set_way_cd                    -- 结息方式代码
   ,t1.int_accr_way_cd                   -- 计息方式代码
   ,decode(t1.int_rat_adj_way_cd,'7','0','1')  -- 利率调整方式代码
   ,t1.int_rat_adj_ped_cd                -- 利率调整周期单位代码
   ,'0'                                  -- 利率调整周期频率
   ,t1.base_rat_type_cd                  -- 利率基准类型代码
   ,'3'                                  -- 利率浮动方式代码
   ,'-'                                  -- 利率浮动方向代码
   ,t1.float_range                       -- 利率浮动值
   ,''                                   -- 本金还款频率代码
   ,''                                   -- 利息还款频率代码
   ,t1.guar_way_cd                       -- 担保方式代码
   ,'9'                                  -- 客户性质代码
   ,''                                   -- 入账账号类型
   ,t6.bankname                          -- 入账账户开户银行名称
   ,t7.accttype                          -- 还款账号类型
   ,''                                   -- 还款账户开户银行编号
   ,t7.orgname                           -- 还款账户开户机构名称
   ,''                                   -- 内部结转标志
   ,'1'                                  -- 境内外标志
   ,''                                   -- 白户标志
   ,''                                   -- 农户标志
   ,''                                   -- 涉农标志
   ,'1'                                  -- 计息标志
   ,'1'                                  -- 复息标志
   ,case when t1.accti_status_cd = 'YUQ' then '1' else '0' end -- 逾期标志
   ,case when t1.accti_status_cd = 'WRN' then '1' else '0' end -- 核销标志
   ,''                                   -- 人行普惠贷款标志
   ,''                                   -- 债权直转标志
   ,''                                   -- 重组标志
   ,''                                   -- 重组贷款类型代码
   ,''                                   -- 重组日期
   ,t1.loan_distr_dt                     -- 开户日期
   ,t1.loan_distr_dt                     -- 放款日期
   ,t1.loan_distr_dt                     -- 原始放款日期
   ,t1.loan_distr_dt                     -- 起息日期
   ,t1.loan_exp_dt                       -- 到期日期
   ,t1.loan_exp_dt                       -- 原始到期日期
   ,t1.payoff_dt                         -- 结清日期
   ,null                                 -- 上次还款日期
   ,t1.next_repay_dt                     -- 下次还款日期
   ,t1.loan_distr_dt                     -- 当前利率生效日期
   ,null                                 -- 下次利率调整日期
   ,t1.oper_teller_id                    -- 客户经理编号
   ,t1.oper_org_id                       -- 开户机构编号
   ,t1.mgmt_org_id                       -- 管理机构编号
   ,t1.acct_instit_id                    -- 账务机构编号
   ,t1.tot_perds                         -- 原始贷款期数
   ,t1.tot_perds                         -- 贷款期数
   ,t1.curr_perds                        -- 当前期数
   ,t1.tot_perds -  t1.curr_perds        -- 剩余期数
   ,t4.ovdterm                           -- 逾期期数
   ,t1.ovdue_days                        -- 本金逾期天数
   ,t1.ovdue_days                        -- 利息逾期天数
   ,t1.grace_period_days                 -- 宽限期天数
   ,0                                    -- 分期手续费费率
   ,t1.base_rat                          -- 基准利率
   ,t1.exec_int_rat                      -- 执行利率
   ,t1.ovdue_int_rat                     -- 逾期利率
   ,(t1.ovdue_int_rat /360)              -- 每日执行利率
   ,0                                    -- 固收利率
   ,nvl(t1.dubil_amt,0)                  -- 合同金额
   ,nvl(t1.dubil_amt,0)                  -- 借据金额
   ,nvl(t1.dubil_amt,0)                  -- 放款金额
   ,nvl(t1.dubil_amt,0)                  -- 原始放款金额
   ,t1.bank_contri_ratio                 -- 银行出资比例
   ,nvl(t1.td_provi_int,0)               -- 当日应计利息
   ,nvl(t1.nomal_int,0)  + nvl(t1.ovdue_int_bal,0) -- 当期应计利息
   ,nvl(t1.nomal_pric,0)                 -- 正常本金
   ,nvl(t1.ovdue_pric_bal,0)             -- 逾期本金
   ,case when t1.ovdue_days > 90 then nvl(t1.ovdue_pric_bal,0) else 0 end  -- 呆滞本金
   ,0                                    -- 呆账本金
   ,case when t1.accti_status_cd = 'WRN' then nvl(t1.nomal_pric,0) + nvl(t1.ovdue_pric_bal,0) else 0 end  -- 核销本金
   ,nvl(t1.nomal_int,0)                  -- 正常利息
   ,nvl(t1.ovdue_int_bal,0)              -- 逾期利息
   ,case when t1.accti_status_cd = 'WRN' then nvl(t1.nomal_int,0)  + nvl(t1.ovdue_int_bal,0)  else 0 end  -- 核销利息
   ,nvl(t4.rpbl_pric_pnlt,0)             -- 逾期本金罚息
   ,nvl(t4.rpbl_int_pnlt,0)              -- 逾期利息罚息
   ,nvl(t1.nomal_int,0)  + nvl(t1.ovdue_int_bal,0) -- 应收欠息
   ,nvl(t1.ovdue_int_bal,0)              -- 应收应计罚息
   ,nvl(t1.recvbl_pnlt,0)                -- 应收罚息
   ,0                                    -- 应收费用
   ,case when t1.ovdue_days < 90 then nvl(t1.nomal_int,0)  + nvl(t1.ovdue_int_bal,0) else 0 end -- 表内欠息余额
   ,case when t1.ovdue_days >= 90  then nvl(t1.nomal_int,0)  + nvl(t1.ovdue_int_bal,0) else 0 end -- 表外欠息余额
   ,case when t1.ovdue_days < 90 then nvl(t1.nomal_int,0)  + nvl(t1.ovdue_int_bal,0) +  nvl(t4.rpbl_pric_pnlt,0) + nvl(t4.rpbl_int_pnlt,0) else 0 end -- 表内利息
   ,case when t1.ovdue_days >= 90  then nvl(t1.nomal_int,0)  + nvl(t1.ovdue_int_bal,0) +  nvl(t4.rpbl_pric_pnlt,0) + nvl(t4.rpbl_int_pnlt,0) else 0 end -- 表外利息
   ,t4.ljys                                              -- 累计应收未收利息金额
   ,nvl(t3.reppay,0)                                     -- 已偿还正常本金
   ,nvl(t3.oreppay,0)                                    -- 已偿还逾期本金
   ,nvl(t3.reipay,0)                                     -- 已偿还正常利息
   ,nvl(t3.oreipay,0)                                    -- 已偿还逾期利息
   ,nvl(t3.repppay,0)                                    -- 已偿还逾期本金罚息
   ,0                                                    -- 已偿还逾期利息罚息
   ,nvl(t3.fee,0)                                         -- 已偿还费用
   ,nvl(t1.dubil_bal,0)                                   -- 本金余额
   ,nvl(t1.dubil_bal,0)                                   -- 当期余额
   ,nvl(t1.dubil_bal,0) * nvl(t5.convt_cny_exch_rat, 1)   -- 折本币当期余额
   ,t1.job_cd                                                                            -- 任务代码
   ,to_timestamp('${batch_timestamp}','yyyy-mm-dd hh24:mi:ss.ff6')
 from ${iml_schema}.agt_wph_dubil_info_h t1
 left join ( select t.dubil_id
                    ,sum(reppay) as reppay
					,sum(oreppay) as oreppay
					,sum(reipay) as reipay
					,sum(oreipay) as oreipay
					,sum(repppay) as repppay
					,sum(fee) as fee
            from 
             (select dubil_id
                    ,sum(case when ovdue_days < 0 then nvl(paid_pric,0) else 0 end ) as reppay
					,sum(case when ovdue_days > 0 then nvl(paid_pric,0) else 0 end)  as oreppay
					,sum(case when ovdue_days <0 then nvl(paid_int,0) else 0 end )   as reipay
					,sum(case when ovdue_days > 0 then nvl(paid_int,0) else 0 end)   as oreipay
					,sum(case when ovdue_days > 0 then nvl(paid_pnlt,0) else 0 end)  as repppay
					,sum(nvl(paid_other_fee,0)) as fee
               from ${iml_schema}.evt_wph_repay_dtl
			   where etl_dt <= to_date('${batch_date}', 'yyyymmdd')
			   group by dubil_id
			/* union all
			 select dubil_id
			        ,sum(case when ovdue_days < 0 then nvl(ths_tm_comp_pric_invtor,0) + nvl(ths_tm_comp_pric_fubon,0) else 0 end) as reppay
					,sum(case when ovdue_days > 0 then nvl(ths_tm_comp_pric_invtor,0) + nvl(ths_tm_comp_pric_fubon,0) else 0 end) as oreppay
					,sum(case when ovdue_days < 0 then nvl(ths_tm_comp_int_invtor,0) + nvl(ths_tm_comp_int_fubon,0) else 0 end) as reipay
					,sum(case when ovdue_days > 0 then nvl(ths_tm_comp_int_invtor,0) + nvl(ths_tm_comp_int_fubon,0) else 0 end) as oreipay
					,sum(case when ovdue_days > 0 then nvl(ths_tm_comp_pnlt_invtor,0) + nvl(ths_tm_comp_pnlt_fubon,0) else 0 end) as repppay
					,0 as fee
			   from ${iml_schema}.evt_wph_comp_dtl
			   where etl_dt <= to_date('${batch_date}', 'yyyymmdd')
			   group by dubil_id*/
			   ) t group by t.dubil_id 
           ) t3
   on t1.dubil_id = t3.dubil_id
  left join (select dubil_id
                    ,sum(case when PD_STATUS_CD = 'JIQ' then 1 else 0 end) as term
					,sum(case when PD_STATUS_CD = 'YUQ' then 1 else 0 end) as ovdterm
					,sum(paid_pnlt) as rpbl_pric_pnlt
					,sum(paid_comp_int) as rpbl_int_pnlt
					,sum(case when to_date('${batch_date}', 'yyyymmdd') >= exp_dt - 1 then nvl(rpbl_int,0) - nvl(paid_int,0) else 0 end) as ljys
               from ${iml_schema}.agt_wph_repay_plan
			   where start_dt <= to_date('${batch_date}', 'yyyymmdd')
			     and end_dt > to_date('${batch_date}', 'yyyymmdd')
			     and job_cd = 'icmsf1'
			   group by dubil_id
            ) t4
   on t1.dubil_id = t4.dubil_id
 left join ${iml_schema}.ref_cny_fori_exch_mdl_p_h t5
   on t5.curr_cd = 'CNY'
  and t5.start_dt <= to_date('${batch_date}', 'yyyymmdd')
  and t5.end_dt > to_date('${batch_date}', 'yyyymmdd')
  and t5.job_cd ='ncbsf1'
 left join (select internalkey as dubil_id
                   ,acctname as  acctname --入账账户名
				   ,acctno as acctno --入账账户号
				   ,bankname as bankname --入账账户银行名称
                   ,row_number() over(partition by internalkey order by inputdate desc)as rn  
             from ${iol_schema}.icms_wph_loan_payment_result
			 where start_dt <= to_date('${batch_date}', 'yyyymmdd')
			   and end_dt > to_date('${batch_date}', 'yyyymmdd')	 
            ) t6
   on t1.dubil_id = t6.dubil_id
  left join (select internalkey as dubil_id
                   ,repayaccttype as accttype
                   ,repayacctname as  acctname --入账账户名
				   ,repayacctno as acctno --入账账户号
				   ,repaychannel as orgname --入账账户机构名称
                   ,row_number() over(partition by internalkey order by inputdate desc)as rn  
             from ${iol_schema}.icms_wph_deduction_result
			 where start_dt <= to_date('${batch_date}', 'yyyymmdd')
			   and end_dt > to_date('${batch_date}', 'yyyymmdd')	 
            ) t7
   on t1.dubil_id = t7.dubil_id
   and t7.rn=1
where 1 = 1
  and t1.start_dt <= to_date('${batch_date}', 'yyyymmdd')
  and t1.end_dt > to_date('${batch_date}', 'yyyymmdd')
  and t1.job_cd ='icmsf1'
  and t1.payoff_dt < trunc(to_date('${batch_date}', 'yyyymmdd'), 'yyyy')
;
commit;


-- 第十一组（共十二组）分期乐
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ into ${icl_schema}.cmm_unite_wl_dubil_info_clear_ex(
   etl_dt	                             --数据日期
   ,lp_id	                             --法人编号
   ,dubil_id	                         --借据编号
   ,core_dubil_id                        --核心借据编号
   ,cont_id	                             --合同编号
   ,std_prod_id                          --标准产品编号
   ,prod_id	                             --产品编号
   ,cust_id	                             --客户编号
   ,subj_id	                             --科目编号
   ,acctnt_cate_cd                       --会计类别代码
   ,enter_acct_acct_num	                 --入账账号
   ,repay_num	                         --还款账号
   ,rela_agt_id	                         --关联协议编号
   ,rela_appl_flow_num                   --关联申请流水号
   ,curr_cd	                             --币种代码
   ,bus_breed_id	                     --业务品种编号
   ,loan_type_cd	                     --贷款类型代码
   ,intnal_loan_type_cd                    --行内贷款类型代码
   ,asset_thd_cls_cd			         --资产三分类代码
   ,dubil_status_cd	                     --借据状态代码
   ,loan_usage_cd	                     --贷款用途代码
   ,dir_indus_cd	                     --贷款贷款贷款投向行业代码
   ,cont_status_cd	                     --合同状态代码
   ,loan_level4_cls_cd	                 --贷款四级分类代码
   ,loan_level5_cls_cd	                 --贷款五级分类代码
   ,loan_level10_cls_cd	                 --贷款十级分类代码
   ,loan_level12_cls_cd	                 --贷款十二级分类代码
   ,acru_non_acru_cd	                 --应计非应计代码
   ,repay_way_cd	                     --还款方式代码
   ,int_set_way_cd	                     --结息方式代码
   ,int_accr_way_cd	                     --计息方式代码
   ,int_rat_adj_way_cd	                 --利率调整方式代码
   ,int_rat_adj_ped_corp_cd	             --利率调整周期单位代码
   ,int_rat_adj_ped_freq	             --利率调整周期频率
   ,int_rat_base_type_cd	             --利率基准类型代码
   ,int_rat_float_way_cd                 --利率浮动方式代码
   ,int_rat_float_dir_cd                 --利率浮动方向代码
   ,int_rat_flo_val                      --利率浮动值
   ,pric_repay_freq_cd	                 --本金还款周期频率
   ,int_repay_freq_cd	                 --利息还款周期频率
   ,guar_way_cd	                         --担保方式代码
   ,cust_char_cd                         --客户性质代码
   ,enter_acct_acct_num_type             --入账账号类型
   ,enter_acct_bank_name                 --入账账户开户银行名称
   ,repay_num_type	                     --还款账号类型
   ,repay_open_acct_bank_id              --还款账户开户银行编号
   ,repay_open_acct_org_name             --还款账户开户机构名称
   ,intnal_carr_flg	                     --内部结转标志
   ,dom_overs_flg	                     --境内外标志
   ,white_list_cust_flg                  --白户标志
   ,farm_flg                             --农户标志
   ,agclt_flg                            --涉农标志
   ,int_accr_flg	                     --计息标志
   ,comp_int_flg	                     --复息标志
   ,ovdue_flg	                         --逾期标志
   ,wrt_off_flg                          --核销标志
   ,pbc_inc_loan_flg                     --人行普惠贷款标志
   ,cred_rht_turn_flg                    --债权直转标志
   ,regroup_flg                          --重组标志
   ,regroup_loan_type_cd                 --重组贷款类型代码
   ,regroup_dt                           --重组日期
   ,open_acct_dt	                     --开户日期
   ,distr_dt	                         --放款日期
   ,init_distr_dt	                     --原始放款日期
   ,value_dt	                         --起息日期
   ,exp_dt	                             --到期日期
   ,init_exp_dt                          --原始到期日期
   ,payoff_dt	                         --结清日期
   ,last_repay_dt	                     --上次还款日期
   ,next_repay_dt	                     --下次还款日期
   ,curr_int_rat_effect_dt	             --当前利率生效日期
   ,next_int_rat_adj_dt	                 --下次利率调整日期
   ,cust_mgr_id	                         --客户经理编号
   ,open_acct_org_id	                 --开户机构编号
   ,mgmt_org_id	                         --管理机构编号
   ,acct_instit_id	                     --账务机构编号
   ,init_tot_perds                       --原始贷款期数
   ,tot_perds	                         --贷款期数
   ,curr_issue_perds	                 --当前期数
   ,surp_perds	                         --剩余期数
   ,ovdue_perds	                         --逾期期数
   ,pric_ovdue_days	                     --本金逾期天数
   ,int_ovdue_days	                     --利息逾期天数
   ,grace_period_days	                 --宽限期天数
   ,inst_comm_fee_rat	                 --分期手续费费率
   ,base_rat	                         --基准利率
   ,exec_int_rat	                     --执行利率
   ,ovdue_int_rat	                     --逾期利率
   ,daily_exec_int_rat	                 --每日执行利率
   ,int_rat                              --固收利率
   ,cont_amt	                         --合同金额
   ,dubil_amt	                         --借据金额
   ,distr_amt	                         --放款金额
   ,init_distr_amt	                     --原始放款金额
   ,bank_contri_ratio                    --银行出资比例
   ,td_acru_int	                         --当日应计利息
   ,currt_acru_int	                     --当期应计利息
   ,nomal_pric	                         --正常本金
   ,ovdue_pric	                         --逾期本金
   ,idle_pric                            --呆滞本金
   ,bad_debt_pric                        --呆账本金
   ,wrt_off_pric                         --核销本金
   ,nomal_int	                         --正常利息
   ,ovdue_int	                         --逾期利息
   ,wrt_off_int                          --核销利息
   ,ovdue_pric_pnlt	                     --逾期本金罚息
   ,ovdue_int_pnlt	                     --逾期利息罚息
   ,recvbl_over_int	                     --应收欠息
   ,recvbl_acru_pnlt	                 --应收应计罚息
   ,recvbl_pnlt	                         --应收罚息
   ,recvbl_fee	                         --应收费用
   ,in_bs_over_int_bal	                 --表内欠息余额
   ,off_bs_over_int_bal	                 --表外欠息余额
   ,in_bs_int	                         --表内利息
   ,off_bs_int	                         --表外利息
   ,acm_recvbl_uncol_int_amt	         --累计应收未收利息金额
   ,repaid_nomal_pric	                 --已偿还正常本金
   ,repaid_ovdue_pric	                 --已偿还逾期本金
   ,repaid_nomal_int	                 --已偿还正常利息
   ,repaid_ovdue_int	                 --已偿还逾期利息
   ,repaid_ovdue_pric_pnlt	             --已偿还逾期本金罚息
   ,repaid_ovdue_int_pnlt	             --已偿还逾期利息罚息
   ,repaid_fee	                         --已偿还费用
   ,pric_bal	                         --本金余额
   ,currt_bal	                         --当期余额
   ,cl_curr_currt_bal	                 --折本币当期余额
   ,job_cd                               --任务代码
   ,etl_timestamp                        --etl处理时间戳
)
select
    to_date('${batch_date}','yyyymmdd')                         --数据日期
    ,t1.lp_id                                                       --法人编号
    ,t1.dubil_id                                                    --借据编号
    ,t1.dubil_id                                                    --核心借据编号
    ,t1.cont_id                                                     --合同编号
    ,t1.prod_id                                                     --标准产品编号
    ,t1.prod_id                                                     --产品编号
    ,t1.cust_id                                                     --客户编号
    ,'13030203'                                                     --科目编号
    ,''                                                             --会计类别代码
    ,t1.enter_id                                                    --入账账号
    ,t1.repay_num_id                                                --还款账号
    ,t2.rela_cont_id                                                --关联协议编号
    ,t2.crdt_appl_id                                                --关联申请流水号
    ,t1.curr_cd                                                     --币种代码
    ,t1.prod_id                                                     --业务品种编号
    ,''                                                             --贷款类型代码
   ,''                    --行内贷款类型代码
    ,t1.asset_thd_cls_cd                                            --资产三分类代码
    ,decode(t1.loan_status_cd,'01','3','02','1','03','7','04','5','05','1','06','1','0')       --借据状态代码
    ,'019002'                                                       --贷款用途代码
    ,''                                                             --贷款贷款贷款投向行业代码
    ,decode(t2.cont_status_cd,'2','NORMAL','4','CLEAR','-')      --合同状态代码
    ,''                                                             --贷款四级分类代码
    ,t1.loan_level5_cls_cd                                          --贷款五级分类代码
    ,''                                                             --贷款十级分类代码
    ,''                                                             --贷款十二级分类代码
    ,t1.acru_non_acru_idf_cd                                        --应计非应计代码
    ,t1.repay_way_cd                                                --还款方式代码
    ,'01'                                                           --结息方式代码
    ,t1.int_accr_way_cd                                             --计息方式代码
    ,decode(t1.int_rat_adj_way_cd,'7','0','1')                      --利率调整方式代码
    ,t1.int_rat_adj_ped_cd                                          --利率调整周期单位代码
    ,'0'                                                            --利率调整周期频率
    ,t1.base_rat_type_cd                                            --利率基准类型代码
    ,t1.int_rat_float_way_cd                                        --利率浮动方式代码
    ,'-'                                                            --利率浮动方向代码
    ,t1.float_range                                                 --利率浮动值
    ,t1.repay_ped_cd                                                --本金还款频率代码
    ,t1.repay_ped_cd                                                --利息还款频率代码
    ,t1.guar_way_cd                                                 --担保方式代码
    ,'-'                                                            --客户性质代码
    ,t1.enter_type_cd                                               --入账账号类型
    ,t4.recvbl_acct_open_bank_num                                   --入账账户开户银行名称
    ,t1.repay_num_type_cd                                           --还款账号类型
    ,''                                                             --还款账户开户银行编号
    ,''                                                             --还款账户开户机构名称
    ,'-'                                                            --内部结转标志
    ,'-'                                                            --境内外标志
    ,'-'                                                            --白户标志
    ,'-'                                                            --农户标志
    ,'-'                                                            --涉农标志
    ,'1'                                                            --计息标志
    ,'-'                                                            --复息标志
    ,'-'                                                            --逾期标志
    ,t1.wrt_off_status_cd                                           --核销标志
    ,''                                                             --人行普惠贷款标志
    ,'-'                                                            --债权直转标志
    ,'-'                                                            --重组标志
    ,''                                                             --重组贷款类型代码
    ,''                                                             --重组日期
    ,t1.effect_dt                                                   --开户日期
    ,t1.effect_dt                                                   --放款日期
    ,t1.effect_dt                                                   --原始放款日期
    ,t1.effect_dt                                                   --起息日期
    ,t1.exp_dt                                                      --到期日期
    ,t1.exp_dt                                                      --原始到期日期
    ,t1.payoff_dt                                                   --结清日期
    ,''                                                             --上次还款日期
    ,''                                                             --下次还款日期
    ,t1.effect_dt                                                   --当前利率生效日期
    ,''                                                             --下次利率调整日期
    ,t1.rgst_teller_id                                              --客户经理编号
    ,t1.rgst_org_id                                                 --开户机构编号
    ,t1.mgmt_org_id                                                 --管理机构编号
    ,t1.acct_instit_id                                              --账务机构编号
    ,t1.tot_perds                                                   --原始贷款期数
    ,t1.tot_perds                                                   --贷款期数
    ,t1.curr_perds                                                  --当前期数
    ,t1.tot_perds-t1.curr_perds                                     --剩余期数
    ,''                                                             --逾期期数
    ,0                                                              --本金逾期天数
    ,0                                                              --利息逾期天数
    ,t1.grace_period                                                --宽限期天数
    ,0                                                              --分期手续费费率
    ,t1.base_rat                                                    --基准利率
    ,t1.exec_int_rat                                                --执行利率
    ,t1.ovdue_int_rat                                               --逾期利率
    ,t1.exec_int_rat                                                --每日执行利率
    ,0                                                              --固收利率
    ,nvl(t2.cont_amt,0)                                           --合同金额
    ,t1.dubil_amt                                                   --借据金额
    ,t1.dubil_amt                                                   --放款金额
    ,t1.dubil_amt                                                   --原始放款金额
    ,t1.bank_contri_ratio                                           --银行出资比例
    ,t1.td_provi_int                                                --当日应计利息
    ,t1.currt_int_bal                                               --当期应计利息
    ,t1.nomal_pric_bal                                              --正常本金
    ,t1.ovdue_pric_bal                                              --逾期本金
    ,0                                                              --呆滞本金
    ,0                                                              --呆账本金
    ,0                                                              --核销本金
    ,t1.currt_int_bal                                               --正常利息
    ,t1.ovdue_int_bal                                               --逾期利息
    ,0                                                              --核销利息
    ,t1.recvbl_pnlt                                                 --逾期本金罚息
    ,0                                                              --逾期利息罚息
    ,0                                                              --应收欠息
    ,t1.recvbl_pnlt                                                 --应收应计罚息
    ,t1.recvbl_pnlt                                                 --应收罚息
    ,0                                                              --应收费用
    ,t1.currt_int_bal+t1.ovdue_int_bal                              --表内欠息余额
    ,0                                                              --表外欠息余额
    ,t1.ovdue_int_bal+t1.pnlt_bal                                   --表内利息
    ,0                                                              --表外利息
    ,t1.currt_int_bal+t1.ovdue_int_bal                              --累计应收未收利息金额
    ,t1.paid_pric                                                   --已偿还正常本金
    ,0                                                               --已偿还逾期本金
    ,t1.paid_int                                                    --已偿还正常利息
    ,0                                                               --已偿还逾期利息
    ,t1.paid_pnlt                                                   --已偿还逾期本金罚息
    ,0                                                               --已偿还逾期利息罚息
    ,0                                                               --已偿还费用
    ,t1.nomal_pric_bal+t1.ovdue_pric_bal                            --本金余额
    ,t1.nomal_pric_bal+t1.ovdue_pric_bal                            --当期余额
    ,(t1.nomal_pric_bal+t1.ovdue_pric_bal) * nvl(t3.convt_cny_exch_rat, 1)          --折本币当期余额
    ,t1.job_cd                                                          --任务代码
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6')    --etl处理时间戳
 from ${iml_schema}.agt_lx_dubil_info_h t1
 left join ${iml_schema}.agt_lx_loan_cont_info_h t2
   on t1.cont_id = t2.cont_id
  and t2.cont_type_cd = '02' --业务合同
  and t2.start_dt <= to_date('${batch_date}', 'yyyymmdd')
  and t2.end_dt > to_date('${batch_date}', 'yyyymmdd')
  and t2.job_cd ='icmsf1'
 left join ${iml_schema}.ref_cny_fori_exch_mdl_p_h t3
   on t3.curr_cd = 'CNY'
  and t3.start_dt <= to_date('${batch_date}', 'yyyymmdd')
  and t3.end_dt > to_date('${batch_date}', 'yyyymmdd')
  and t3.job_cd ='ncbsf1'
 left join ${iml_schema}.agt_lx_out_acct_appl T4		
    on t1.dubil_id = t4.dubil_id	
   and t4.start_dt <= to_date('${batch_date}', 'yyyymmdd')
   and t4.end_dt > to_date('${batch_date}', 'yyyymmdd')
   and t4.job_cd ='icmsf1'
where t1.start_dt <= to_date('${batch_date}', 'yyyymmdd')
  and t1.end_dt > to_date('${batch_date}', 'yyyymmdd')
  and t1.job_cd ='icmsf1'
  and t1.payoff_dt < trunc(to_date('${batch_date}', 'yyyymmdd'), 'yyyy')
;
commit;

-- 第十二组（共十二组）富民联合贷
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ into ${icl_schema}.cmm_unite_wl_dubil_info_clear_ex(
   etl_dt	                             --数据日期
   ,lp_id	                             --法人编号
   ,dubil_id	                         --借据编号
   ,core_dubil_id                        --核心借据编号
   ,cont_id	                             --合同编号
   ,std_prod_id                          --标准产品编号
   ,prod_id	                             --产品编号
   ,cust_id	                             --客户编号
   ,subj_id	                             --科目编号
   ,acctnt_cate_cd                       --会计类别代码
   ,enter_acct_acct_num	                 --入账账号
   ,repay_num	                         --还款账号
   ,rela_agt_id	                         --关联协议编号
   ,rela_appl_flow_num                   --关联申请流水号
   ,curr_cd	                             --币种代码
   ,bus_breed_id	                     --业务品种编号
   ,loan_type_cd	                     --贷款类型代码
    ,intnal_loan_type_cd                  --行内贷款类型代码
   ,asset_thd_cls_cd			         --资产三分类代码
   ,dubil_status_cd	                     --借据状态代码
   ,loan_usage_cd	                     --贷款用途代码
   ,dir_indus_cd	                     --贷款贷款贷款投向行业代码
   ,cont_status_cd	                     --合同状态代码
   ,loan_level4_cls_cd	                 --贷款四级分类代码
   ,loan_level5_cls_cd	                 --贷款五级分类代码
   ,loan_level10_cls_cd	                 --贷款十级分类代码
   ,loan_level12_cls_cd	                 --贷款十二级分类代码
   ,acru_non_acru_cd	                 --应计非应计代码
   ,repay_way_cd	                     --还款方式代码
   ,int_set_way_cd	                     --结息方式代码
   ,int_accr_way_cd	                     --计息方式代码
   ,int_rat_adj_way_cd	                 --利率调整方式代码
   ,int_rat_adj_ped_corp_cd	             --利率调整周期单位代码
   ,int_rat_adj_ped_freq	             --利率调整周期频率
   ,int_rat_base_type_cd	             --利率基准类型代码
   ,int_rat_float_way_cd                 --利率浮动方式代码
   ,int_rat_float_dir_cd                 --利率浮动方向代码
   ,int_rat_flo_val                      --利率浮动值
   ,pric_repay_freq_cd	                 --本金还款周期频率
   ,int_repay_freq_cd	                 --利息还款周期频率
   ,guar_way_cd	                         --担保方式代码
   ,cust_char_cd                         --客户性质代码
   ,enter_acct_acct_num_type             --入账账号类型
   ,enter_acct_bank_name                 --入账账户开户银行名称
   ,repay_num_type	                     --还款账号类型
   ,repay_open_acct_bank_id              --还款账户开户银行编号
   ,repay_open_acct_org_name             --还款账户开户机构名称
   ,intnal_carr_flg	                     --内部结转标志
   ,dom_overs_flg	                     --境内外标志
   ,white_list_cust_flg                  --白户标志
   ,farm_flg                             --农户标志
   ,agclt_flg                            --涉农标志
   ,int_accr_flg	                     --计息标志
   ,comp_int_flg	                     --复息标志
   ,ovdue_flg	                         --逾期标志
   ,wrt_off_flg                          --核销标志
   ,pbc_inc_loan_flg                     --人行普惠贷款标志
   ,cred_rht_turn_flg                    --债权直转标志
   ,regroup_flg                          --重组标志
   ,regroup_loan_type_cd                 --重组贷款类型代码
   ,regroup_dt                           --重组日期
   ,open_acct_dt	                     --开户日期
   ,distr_dt	                         --放款日期
   ,init_distr_dt	                     --原始放款日期
   ,value_dt	                         --起息日期
   ,exp_dt	                             --到期日期
   ,init_exp_dt                          --原始到期日期
   ,payoff_dt	                         --结清日期
   ,last_repay_dt	                     --上次还款日期
   ,next_repay_dt	                     --下次还款日期
   ,curr_int_rat_effect_dt	             --当前利率生效日期
   ,next_int_rat_adj_dt	                 --下次利率调整日期
   ,cust_mgr_id	                         --客户经理编号
   ,open_acct_org_id	                 --开户机构编号
   ,mgmt_org_id	                         --管理机构编号
   ,acct_instit_id	                     --账务机构编号
   ,init_tot_perds                       --原始贷款期数
   ,tot_perds	                         --贷款期数
   ,curr_issue_perds	                 --当前期数
   ,surp_perds	                         --剩余期数
   ,ovdue_perds	                         --逾期期数
   ,pric_ovdue_days	                     --本金逾期天数
   ,int_ovdue_days	                     --利息逾期天数
   ,grace_period_days	                 --宽限期天数
   ,inst_comm_fee_rat	                 --分期手续费费率
   ,base_rat	                         --基准利率
   ,exec_int_rat	                     --执行利率
   ,ovdue_int_rat	                     --逾期利率
   ,daily_exec_int_rat	                 --每日执行利率
   ,int_rat                              --固收利率
   ,cont_amt	                         --合同金额
   ,dubil_amt	                         --借据金额
   ,distr_amt	                         --放款金额
   ,init_distr_amt	                     --原始放款金额
   ,bank_contri_ratio                    --银行出资比例
   ,td_acru_int	                         --当日应计利息
   ,currt_acru_int	                     --当期应计利息
   ,nomal_pric	                         --正常本金
   ,ovdue_pric	                         --逾期本金
   ,idle_pric                            --呆滞本金
   ,bad_debt_pric                        --呆账本金
   ,wrt_off_pric                         --核销本金
   ,nomal_int	                         --正常利息
   ,ovdue_int	                         --逾期利息
   ,wrt_off_int                          --核销利息
   ,ovdue_pric_pnlt	                     --逾期本金罚息
   ,ovdue_int_pnlt	                     --逾期利息罚息
   ,recvbl_over_int	                     --应收欠息
   ,recvbl_acru_pnlt	                 --应收应计罚息
   ,recvbl_pnlt	                         --应收罚息
   ,recvbl_fee	                         --应收费用
   ,in_bs_over_int_bal	                 --表内欠息余额
   ,off_bs_over_int_bal	                 --表外欠息余额
   ,in_bs_int	                         --表内利息
   ,off_bs_int	                         --表外利息
   ,acm_recvbl_uncol_int_amt	         --累计应收未收利息金额
   ,repaid_nomal_pric	                 --已偿还正常本金
   ,repaid_ovdue_pric	                 --已偿还逾期本金
   ,repaid_nomal_int	                 --已偿还正常利息
   ,repaid_ovdue_int	                 --已偿还逾期利息
   ,repaid_ovdue_pric_pnlt	             --已偿还逾期本金罚息
   ,repaid_ovdue_int_pnlt	             --已偿还逾期利息罚息
   ,repaid_fee	                         --已偿还费用
   ,pric_bal	                         --本金余额
   ,currt_bal	                         --当期余额
   ,cl_curr_currt_bal	                 --折本币当期余额
   ,job_cd                               --任务代码
   ,etl_timestamp                        --etl处理时间戳
)
select
    to_date('${batch_date}','yyyymmdd')                                 --数据日期
    ,t1.lp_id                                                              --法人编号
    ,t1.dubil_id                                                           --借据编号
    ,t1.dubil_id                                                           --核心借据编号
    ,t1.cont_id                                                            --合同编号
    ,t1.prod_id                                                            --标准产品编号
    ,t1.prod_id                                                            --产品编号
    ,t1.cust_id                                                            --客户编号
    ,case when substr(t1.prod_id,1,5) ='20201' then '13030203'      --个人消费贷款	
            when substr(t1.prod_id,1,5) ='20202' then '13030202'     --个人经营性贷款
            else '' end                                                 --科目编号
    ,''                                                                    --会计类别代码
    ,t1.enter_id                                                           --入账账号
    ,t1.repay_num_id                                                       --还款账号
    ,t1.out_acct_flow_num                                                  --关联协议编号
    ,t1.partner_ova_flow_num                                               --关联申请流水号
    ,t1.curr_cd                                                            --币种代码
    ,t1.prod_id                                                            --业务品种编号
    ,'00'                                                                  --贷款类型代码
    ,t1.loan_type_cd                                                       --行内贷款类型代码
    ,t1.asset_thd_cls_cd                                                   --资产三分类代码
    ,decode(t1.dubil_status_cd,'A','1','C','7','P','1','R','5',t1.dubil_status_cd)     --借据状态代码
    ,t2.loan_usage_cd                                                      --贷款用途代码
    ,t2.loan_dir_indus_cd                                                  --贷款贷款贷款投向行业代码
    ,decode(t2.cont_status_cd,'2','NORMAL','4','CLEAR','-')             --合同状态代码
    ,''                                                                    --贷款四级分类代码
    ,t1.level5_cls_cd                                                      --贷款五级分类代码
    ,''                                                                    --贷款十级分类代码
    ,''                                                                    --贷款十二级分类代码
    ,t1.acru_non_acru_cd                                                   --应计非应计代码
    ,t1.repay_way_cd                                                       --还款方式代码
    ,t1.stl_way_cd                                                         --结息方式代码
    ,t1.int_accr_way_cd                                                    --计息方式代码
    ,decode(t1.int_rat_adj_way_cd,'7','0','1')                          --利率调整方式代码
    ,t1.int_rat_adj_ped_cd                                                 --利率调整周期单位代码
    ,''                                                                    --利率调整周期频率
    ,t1.base_rat_type_cd                                                   --利率基准类型代码
    ,t1.int_rat_float_way_cd                                               --利率浮动方式代码
    ,t1.int_rat_float_dir_cd                                               --利率浮动方向代码
    ,t1.int_rat_float_spread                                               --利率浮动值
    ,t1.repay_ped_cd                                                       --本金还款频率代码
    ,t1.repay_ped_cd                                                       --利息还款频率代码
    ,t1.main_guar_way_cd                                                   --担保方式代码
    ,nvl(trim(t3.indtype),'-')                                           --客户性质代码
    ,t1.enter_type_cd                                                      --入账账号类型
    ,t1.enter_name                                                         --入账账户开户银行名称
    ,t1.repay_num_type_cd                                                  --还款账号类型
    ,''                                                                    --还款账户开户银行编号
    ,t1.repay_num_name                                                     --还款账户开户机构名称
    ,'-'                                                                   --内部结转标志
    ,'-'                                                                   --境内外标志
    ,'-'                                                                   --白户标志
    ,nvl(trim(t3.isfarmer),'-')                                        --农户标志
    ,'-'                                                                   --涉农标志
    ,'1'                                                                   --计息标志
    ,'1'                                                                   --复息标志
    ,decode(t1.dubil_status_cd,'P','1','0')                             --逾期标志
    ,nvl(trim(t1.wrt_off_flg),'0')                                      --核销标志
    ,'-'                                                                   --人行普惠贷款标志
    ,'-'                                                                   --债权直转标志
    ,'-'                                                                   --重组标志
    ,'-'                                                                   --重组贷款类型代码
    ,''                                                                    --重组日期
    ,t1.out_acct_dt                                                        --开户日期
    ,t1.out_acct_dt                                                        --放款日期
    ,t1.out_acct_dt                                                        --原始放款日期
    ,t1.out_acct_dt                                                        --起息日期
    ,t1.exp_dt                                                             --到期日期
    ,t1.exp_dt                                                             --原始到期日期
    ,t1.payoff_dt                                                          --结清日期
    ,t4.repay_dt                                                           --上次还款日期
    ,''                                                                    --下次还款日期
    ,t1.out_acct_dt                                                        --当前利率生效日期
    ,''                                                                    --下次利率调整日期
    ,t1.rgst_teller_id                                                     --客户经理编号
    ,t1.out_acct_org_id                                                    --开户机构编号
    ,t1.out_acct_org_id                                                    --管理机构编号
    ,t1.out_acct_org_id                                                    --账务机构编号
    ,t1.loan_perds                                                         --原始贷款期数
    ,t1.loan_perds                                                         --贷款期数
    ,t1.curr_perds                                                         --当前期数
    ,t1.unpayoff_perds                                                     --剩余期数
    ,''                                                                    --逾期期数
--    ,case when t1.loan_ovdue_days > 0 then '1' else '0' end         --本金逾期标志
--    ,case when t1.loan_int_ovdue_days > 0 then '1' else '0' end     --利息逾期标志
    ,t1.loan_ovdue_days                                                    --本金逾期天数
    ,t1.loan_int_ovdue_days                                                --利息逾期天数
    ,t1.grace_period                                                       --宽限期天数
    ,''                                                                    --分期手续费费率
    ,t1.base_rat                                                           --基准利率
    ,t1.exec_int_rat                                                       --执行利率
    ,t1.ovdue_int_rat                                                      --逾期利率
    ,t1.exec_int_rat/365                                                   --每日执行利率
    ,t1.int_rat                                                            --固收利率
    ,t2.cont_amt                                                           --合同金额
    ,t1.dubil_amt                                                          --借据金额
    ,t1.dubil_amt                                                          --放款金额
    ,t1.dubil_amt                                                          --原始放款金额
    ,t1.bank_contri_ratio                                                  --银行出资比例
    ,t1.td_acru_int                                                        --当日应计利息
    ,t1.nomal_int_bal+t1.ovdue_int_bal                                     --当期应计利息
    ,t1.nomal_pric_bal                                                     --正常本金
    ,t1.ovdue_pric_bal                                                     --逾期本金
    ,0                                                                    --呆滞本金
    ,0                                                                    --呆账本金
    ,t1.wrt_off_pric                                                       --核销本金
    ,t1.nomal_int_bal                                                      --正常利息
    ,t1.ovdue_int_bal                                                      --逾期利息
    ,t1.wrt_off_int                                                        --核销利息
    ,t1.pnlt_bal                                                           --逾期本金罚息
    ,t1.comp_int_bal                                                       --逾期利息罚息
    ,t1.ovdue_int_bal+t1.pnlt_bal                                          --应收欠息
    ,t1.recvbl_pnlt                                                        --应收应计罚息
    ,t1.recvbl_pnlt                                                        --应收罚息
    ,0                                                                    --应收费用
    ,case when greatest(t1.loan_ovdue_days,t1.loan_int_ovdue_days) < 90 then t1.ovdue_int_bal+t1.pnlt_bal else 0 end           --表内欠息余额
    ,case when greatest(t1.loan_ovdue_days,t1.loan_int_ovdue_days) >= 90 then t1.ovdue_int_bal+t1.pnlt_bal else 0 end          --表外欠息余额
    ,case when greatest(t1.loan_ovdue_days,t1.loan_int_ovdue_days) < 90 then t1.ovdue_int_bal+t1.pnlt_bal else 0 end           --表内利息
    ,case when greatest(t1.loan_ovdue_days,t1.loan_int_ovdue_days) >= 90 then t1.ovdue_int_bal+t1.pnlt_bal else 0 end          --表外利息
    ,t1.nomal_int_bal+t1.ovdue_int_bal+t1.pnlt_bal                                               --累计应收未收利息金额
    ,nvl(t4.repaid_nomal_pric,0)                                                                --已偿还正常本金
    ,nvl(t4.repaid_ovdue_pric,0)                                                                --已偿还逾期本金
    ,nvl(t4.repaid_nomal_int,0)                                                                 --已偿还正常利息
    ,nvl(t4.repaid_ovdue_int,0)                                                                 --已偿还逾期利息
    ,nvl(t4.repaid_ovdue_pric_pnlt,0)                                                           --已偿还逾期本金罚息
    ,nvl(t4.repaid_ovdue_int_pnlt,0)                                                            --已偿还逾期利息罚息
    ,nvl(t4.repaid_fee,0)                                                                       --已偿还费用
    ,t1.nomal_pric_bal+t1.ovdue_pric_bal                                   --本金余额
    ,t1.loan_bal                                                           --当期余额
    ,t1.loan_bal * nvl(t5.convt_cny_exch_rat, 1)                         --折本币当期余额
    ,'icms_lh'                                                             --任务代码
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6')       --etl处理时间戳
 from ${iml_schema}.agt_lhwd_dubil_info_h t1
 left join ${iml_schema}.agt_lhwd_loan_cont_info_h t2
   on t1.cont_id = t2.cont_id
  and t2.start_dt <= to_date('${batch_date}', 'yyyymmdd')
  and t2.end_dt > to_date('${batch_date}', 'yyyymmdd')
  and t2.job_cd ='icmsf1'
 left join ${iol_schema}.icms_customer_info_lhdk t3		
   on t1.cust_id = t3.customerid
  and t3.start_dt <= to_date('${batch_date}', 'yyyymmdd')
  and t3.end_dt > to_date('${batch_date}', 'yyyymmdd')
 left join (select dubil_id
                       ,max(repay_dt) as repay_dt 
                       ,sum(case when repay_num_type_cd in ('12','13','14') then paid_pric else 0 end) as repaid_nomal_pric
                       ,sum(case when repay_num_type_cd in ('11','15') then paid_pric else 0 end) as repaid_ovdue_pric
                       ,sum(case when repay_num_type_cd in ('12','13','14') then paid_int else 0 end) as repaid_nomal_int
                       ,sum(case when repay_num_type_cd in ('11','15') then paid_int else 0 end) as repaid_ovdue_int
                       ,sum(paid_pnlt) as repaid_ovdue_pric_pnlt
                       ,0 as repaid_ovdue_int_pnlt
                       ,sum(paid_adv_repay_comm_fee) as repaid_fee
                 from ${iml_schema}.evt_lhwd_repay_dtl 
                where repay_dt <to_date('${batch_date}', 'yyyymmdd')+1  --还款日期带时分秒
                   and etl_dt <=to_date('${batch_date}', 'yyyymmdd')
                   and job_cd ='icmsf1'
                group by dubil_id)t4
   on t1.dubil_id=t4.dubil_id
 left join ${iml_schema}.ref_cny_fori_exch_mdl_p_h t5
   on t5.curr_cd = 'CNY'
  and t5.start_dt <= to_date('${batch_date}', 'yyyymmdd')
  and t5.end_dt > to_date('${batch_date}', 'yyyymmdd')
  and t5.job_cd ='ncbsf1'
where t1.start_dt <= to_date('${batch_date}', 'yyyymmdd')
  and t1.end_dt > to_date('${batch_date}', 'yyyymmdd')
  and t1.job_cd ='icmsi1'
  and t1.payoff_dt < trunc(to_date('${batch_date}', 'yyyymmdd'), 'yyyy')
;
commit;

commit;
delete from ${icl_schema}.cmm_icl_batch_jnl  where etl_dt = to_date('${batch_date}', 'yyyymmdd') and tab_name = 'cmm_unite_wl_dubil_info_clear';
commit;
whenever sqlerror exit sql.sqlcode;
insert into ${icl_schema}.cmm_icl_batch_jnl(
    etl_dt                            -- 数据日期
   ,tab_name                           -- 表名
  ,batch_status                       -- 跑批状态
  ,batch_tm                           -- 跑批时间
  ,etl_timestamp                      -- etl处理时间
)
select
   to_date('${batch_date}', 'yyyymmdd')                               -- 跑批日期
   ,'cmm_unite_wl_dubil_info_clear'
   ,1                                                                 -- 跑批状态
   ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6')   -- 跑批时间
   ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6')   -- etl处理时间
from dual;
;
commit;

-- 2.3 exchage ex table and target table
alter table ${icl_schema}.cmm_unite_wl_dubil_info_clear exchange partition p_${batch_date} with table ${icl_schema}.cmm_unite_wl_dubil_info_clear_ex;

-- 3.1 drop ex table
--drop table ${icl_schema}.tmp_cmm_unite_wl_dubil_info_clear_01 purge;
--drop table ${icl_schema}.tmp_cmm_unite_wl_dubil_info_clear_02 purge;
--drop table ${icl_schema}.tmp_cmm_unite_wl_dubil_info_clear_03 purge;
--drop table ${icl_schema}.tmp_cmm_unite_wl_dubil_info_clear_04 purge;
--drop table ${icl_schema}.tmp_cmm_unite_wl_dubil_info_clear_05 purge;
--drop table ${icl_schema}.tmp_cmm_unite_wl_dubil_info_clear_06 purge;
--drop table ${icl_schema}.tmp_cmm_unite_wl_dubil_info_clear_07 purge;
--drop table ${icl_schema}.tmp_cmm_unite_wl_dubil_info_clear_08 purge;
--drop table ${icl_schema}.tmp_cmm_unite_wl_dubil_info_clear_10 purge;
--drop table ${icl_schema}.tmp_cmm_unite_wl_dubil_info_clear_11 purge;
--drop table ${icl_schema}.tmp_cmm_unite_wl_dubil_info_clear_12 purge;
--drop table ${icl_schema}.tmp_cmm_unite_wl_dubil_info_clear_13 purge;
--drop table ${icl_schema}.tmp_cmm_unite_wl_dubil_info_clear_14 purge;
--drop table ${icl_schema}.tmp_cmm_unite_wl_dubil_info_clear_15 purge;
--drop table ${icl_schema}.tmp_cmm_unite_wl_dubil_info_clear_24 purge;
--drop table ${icl_schema}.tmp_cmm_unite_wl_dubil_info_clear_25 purge;
--drop table ${icl_schema}.tmp_cmm_unite_wl_dubil_info_clear_88 purge;
--drop table ${icl_schema}.cmm_unite_wl_dubil_info_clear_ex purge;
--drop table ${icl_schema}.cmm_unite_wl_dubil_info_clear_ex_02 purge;
--drop table ${icl_schema}.tmp_cmm_unite_wl_dubil_info_clear_26 purge;
--drop table ${icl_schema}.tmp_cmm_unite_wl_dubil_info_clear_27 purge;
--drop table ${icl_schema}.tmp_cmm_unite_wl_dubil_info_clear_28 purge;
--drop table ${icl_schema}.tmp_cmm_unite_wl_dubil_info_clear_29 purge;
--drop table ${icl_schema}.tmp_cmm_unite_wl_dubil_info_clear_30 purge;
--drop table ${icl_schema}.tmp_cmm_unite_wl_dubil_info_clear_31 purge;
--drop table ${icl_schema}.tmp_cmm_unite_wl_dubil_info_clear_32 purge;
--drop table ${icl_schema}.tmp_cmm_unite_wl_dubil_info_clear_33 purge;

-- 3.3 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname=>'${icl_schema}',tabname=>'cmm_unite_wl_dubil_info_clear',partname=>'p_${batch_date}',estimate_percent=>10,method_opt=>'for all columns size 1',no_invalidate=>false,granularity=>'partition',cascade=>true,force=>true,degree=>8);
