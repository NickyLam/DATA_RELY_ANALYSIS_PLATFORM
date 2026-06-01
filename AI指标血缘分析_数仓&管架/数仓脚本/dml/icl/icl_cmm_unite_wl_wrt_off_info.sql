/*
Purpose:    共性加工层-联合网贷核销主表：包括我行与第三方合作平台联合的贷款核销信息及累计核销收回的信息，数据主要来源于零售信贷系统、中台系统
Author:     Sunline/huangrong
Usage:      python $ETL_HOME/script/main.py yyyymmdd icl_cmm_unite_wl_wrt_off_info
Createdate: 20200605
Logs:       20210807 陈伟峰 调整中台部分的贷款信息中【实核贷款本金-ACTL_WRTOFF_LOAN_PRIC】，【实核表外利息-ACTL_WRTOFF_OFF_BS_INT】逻辑
            20210926 陈伟峰 修复【全部收回标志-all_retra_flg】因联合网贷借据表无往年结清数据导致数据不准确的问题
            20220513 李森辉 1、取数数据源调整，由旧零售信贷系统调整为综合信贷管理系统，微粒贷取数源保持不变。
                            2、调整T1表的加工逻辑，增加过滤条件【BUSINESSTYPE IN ('1', '2', '3', '4')】
                            3、调整字段【核销垫付款项金额】的取数口径
            20221228 陈伟峰 调整repay_dt->trunc(repay_dt)
            20230103 陈伟峰 调整微粒贷部分debit_crdt_flg = '0' ->debit_crdt_flg = 'D'
            20230105 陈伟峰 调整agt_ant_wrt_off_dubil跟agt_status_h关联条件，T3.agt_id = T1.agt_id-> SUBSTR(t3.agt_id,7) = T1.dubil_id
            20230614 陈伟峰 添加综合信贷微粒贷核销数据
			20240601 陈伟峰 添加京东金融核销数据
			20241105 谢宁 增加日志表输出
            20260205 陈伟峰 优化【标准产品代码、全部收回标志】取数逻辑
*/

set timing on
-- 0.1 alter parallel
alter session force parallel query parallel 4;
alter session force parallel dml parallel 4;
-- alter session force parallel ddl parallel 1;

-- 1.1 drop timeout partition and add partition
whenever sqlerror continue none;
--alter table ${icl_schema}.cmm_unite_wl_wrt_off_info drop partition p_${retain_day};
alter table ${icl_schema}.cmm_unite_wl_wrt_off_info add partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

whenever sqlerror continue none ;
drop table ${icl_schema}.cmm_unite_wl_wrt_off_info_ex purge;
drop table ${icl_schema}.cmm_unite_wl_wrt_off_info_01 purge;

-- 2.1 insert into ex table
whenever sqlerror exit sql.sqlcode;
create table ${icl_schema}.cmm_unite_wl_wrt_off_info_ex
nologging
compress ${option_switch} for query high
as
select * from ${icl_schema}.cmm_unite_wl_wrt_off_info where 0=1;

create table ${icl_schema}.cmm_unite_wl_wrt_off_info_01
nologging
compress ${option_switch} for query high
as
select t1.dubil_id as dubil_id
        ,t1.lp_id as lp_id   --add hr
        ,t1.cust_id as cust_id
        ,t1.acct_instit_id as org_id
        ,t2.imp_dt as fir_wrt_off_dt
        ,t1.recvbl_pric as recvbl_pric
        ,t1.recvbl_off_bs_int as recvbl_off_bs_int
        ,t1.advc_fee as advc_fee
        ,t4.prod_id as std_prod_id
        ,case when t5.agt_status_cd ='04' then 'CLEAR' else 'NORMAL' end as cont_status_cd
        ,t1.job_cd as job_cd --add hr
   from ${iml_schema}.agt_ant_wrt_off_dubil t1
   left join ${iml_schema}.agt_imp_dt_h t2
     on t1.agt_id = t2.agt_id
    and t2.dt_type_cd = '45'
    and t2.start_dt <= to_date('${batch_date}', 'yyyymmdd')
    and t2.end_dt > to_date('${batch_date}', 'yyyymmdd')
    and t2.job_cd = 'myhxf1'
   inner join ${iml_schema}.agt_jd_loan_dubil_info t3
     on t3.dubil_id = t1.dubil_id
    and t3.create_dt <= to_date('${batch_date}', 'yyyymmdd')
    and t3.job_cd = 'jdjrf1'
    and t3.id_mark <> 'D'
  left join ${iml_schema}.agt_prod_rela_h t4
    on t3.agt_id = t4.agt_id
   and t4.start_dt <= to_date('${batch_date}','yyyymmdd')
   and t4.end_dt > to_date('${batch_date}','yyyymmdd')
   and t4.agt_prod_rela_type_cd = '02'
   and t4.job_cd ='jdjrf1'
  left join ${iml_schema}.agt_status_h t5
    on t3.agt_id = t5.agt_id
   and t5.start_dt <= to_date('${batch_date}', 'yyyymmdd')
   and t5.end_dt > to_date('${batch_date}', 'yyyymmdd')
   and t5.agt_status_type_cd = 'CD1258'
   and t5.job_cd = 'jdjrf1'
  where t1.bus_type_cd in ('1', '2', '3', '4','6')
    and t1.create_dt <= to_date('${batch_date}', 'yyyymmdd')
    and t1.job_cd = 'myhxf1'
    and t1.id_mark <> 'D'
union all
select t1.dubil_id as dubil_id
        ,t1.lp_id as lp_id   --add hr
        ,t1.cust_id as cust_id
        ,t1.acct_instit_id as org_id
        ,t2.imp_dt as fir_wrt_off_dt
        ,t1.recvbl_pric as recvbl_pric
        ,t1.recvbl_off_bs_int as recvbl_off_bs_int
        ,t1.advc_fee as advc_fee
        ,t4.prod_id as std_prod_id
        ,t5.agt_status_cd  as cont_status_cd
        ,t1.job_cd as job_cd --add hr
   from ${iml_schema}.agt_ant_wrt_off_dubil t1
   left join ${iml_schema}.agt_imp_dt_h t2
     on t1.agt_id = t2.agt_id
    and t2.dt_type_cd = '45'
    and t2.start_dt <= to_date('${batch_date}', 'yyyymmdd')
    and t2.end_dt > to_date('${batch_date}', 'yyyymmdd')
    and t2.job_cd = 'myhxf1'
   left join ${iml_schema}.agt_status_h t3
     on substr(t3.agt_id,7) = t1.dubil_id
    and t3.agt_status_type_cd = 'CD1102'
    and t3.start_dt <= to_date('${batch_date}', 'yyyymmdd')
    and t3.end_dt > to_date('${batch_date}', 'yyyymmdd')
    and t3.job_cd in ('myhbf1', 'myjbf2', 'myjbf3', 'mybkf1')
   left join ${iml_schema}.agt_prod_rela_h t4
     on t1.dubil_id = substr(t4.agt_id,7)
    and t4.start_dt <= to_date('${batch_date}','yyyymmdd')
    and t4.end_dt > to_date('${batch_date}','yyyymmdd')
    and t4.job_cd in ('myhbf1','myjbf2','myjbf3','mybkf1')
  left join ${iml_schema}.agt_status_h t5
    on t1.dubil_id = substr(t5.agt_id,7)
   and t5.start_dt <= to_date('${batch_date}', 'yyyymmdd')
   and t5.end_dt > to_date('${batch_date}', 'yyyymmdd')
   and t5.agt_status_type_cd = 'CD1278'
   and t5.job_cd in ('myhbf1','myjbf2','myjbf3','mybkf1')
  where t3.agt_status_cd = 'Y'  -- t1.wrt_off_status_cd = 'Y'
    and t1.bus_type_cd in ('1', '2', '3', '4')
    and t1.create_dt <= to_date('${batch_date}', 'yyyymmdd')
    and t1.job_cd = 'myhxf1'
    and t1.id_mark <> 'D'
  union all
 select al.dubil_id as dubil_id
        ,al.lp_id as lp_id  --add hr
        ,al.cust_id as cust_id
        ,'897001' as org_id
        ,ls.wrt_off_dt as fir_wrt_off_dt
        ,case when flow.actl_wrtoff_loan_pric>0 then flow.actl_wrtoff_loan_pric 
              else suc.wrt_off_pric * suc.bank_contri_ratio 
          end as recvbl_pric
        ,case when flow.actl_wrtoff_off_bs_int>0 then flow.actl_wrtoff_off_bs_int
              else suc.wrt_off_int * suc.bank_contri_ratio 
          end as recvbl_off_bs_int
        ,0 as advc_fee
        ,t2.prod_id as std_prod_id
        ,case when ${iml_schema}.dateformat_max(t3.imp_dt) <> ${iml_schema}.dateformat_max('') then 'CLEAR'
               else 'NORMAL' end as cont_status_cd
        ,ls.job_cd as job_cd  --add hr
   from ${iml_schema}.evt_wld_dubil_wrt_off ls
  inner join ${iml_schema}.agt_wld_dubil_info al
     on ls.tran_ref_no = al.tran_ref_no
    and al.create_dt <= to_date('${batch_date}', 'yyyymmdd')
    and al.id_mark <>'D'  --add hr
    and al.job_cd = 'mpcsf1'
   left join ${iml_schema}.agt_prod_rela_h t2
     on al.agt_id = t2.agt_id
    and t2.start_dt <= to_date('${batch_date}','yyyymmdd')
    and t2.end_dt > to_date('${batch_date}','yyyymmdd')
    and t2.job_cd = 'mpcsf1'
   left join (select tran_ref_no
                    ,sum(case when evt_tran_code in ('G911','G301') and bal_compnt_group_cd = 'LP' 
                              then enter_acct_amt else 0 end) as actl_wrtoff_loan_pric   --实核贷款本金
                    ,sum(case when evt_tran_code in ('G911') and bal_compnt_group_cd in ('LI','LT') 
                              then enter_acct_amt else 0 end) as actl_wrtoff_off_bs_int --实核表外利息
               from ${iml_schema}.evt_wld_acct_ety_tran --iol.mpcs_a0nds_accounting_flow
              where evt_tran_code in ('G911','G301')
                and decode(debit_crdt_flg,'0','D','1','C',debit_crdt_flg) = 'D'
                and subj_id in ('111001156601002010', '111001156601002020')
                and bal_compnt_group_cd in ('LI','LT','LP')
                        and job_cd='mpcsi1'
              group by tran_ref_no) flow
     on ls.tran_ref_no = flow.tran_ref_no
   left join ${iml_schema}.evt_wld_dubil_wrt_off suc  --  iol.mpcs_a0nds_loan_writeoff_list_suc suc
     on ls.tran_ref_no = suc.tran_ref_no
      and suc.job_cd='mpcsi1'
   left join ${iml_schema}.agt_imp_dt_h t3
   	 on al.agt_id = t3.agt_id
   	and t3.dt_type_cd = '03'
   	and t3.start_dt <= to_date('${batch_date}', 'yyyymmdd')
    and t3.end_dt > to_date('${batch_date}', 'yyyymmdd')
    and t3.job_cd = 'mpcsf1'
  where ls.wrt_off_status_cd = 'CheckPass'  ---modi hr 字段取为o层表，checkpass改为CheckPass
    and ls.wrt_off_dt <= to_date('${batch_date}', 'yyyymmdd')
    and ls.job_cd = 'mpcsi1'
    --20230614 新增综合信贷微粒贷核销数据
  union all
 select al.dubil_id as dubil_id
        ,al.lp_id as lp_id
        ,al.cust_id as cust_id
        ,'805011' as org_id
        ,ls.wrt_off_dt as fir_wrt_off_dt
        ,case when flow.actl_wrtoff_loan_pric>0 then flow.actl_wrtoff_loan_pric 
              else suc.wrt_off_pric * suc.bank_contri_ratio 
          end as recvbl_pric
        ,case when flow.actl_wrtoff_off_bs_int>0 then flow.actl_wrtoff_off_bs_int
              else suc.wrt_off_int * suc.bank_contri_ratio 
          end as recvbl_off_bs_int
        ,0 as advc_fee
        ,al.prod_id as std_prod_id
        ,case when al.payoff_dt <> to_date('00010101', 'yyyymmdd') then 'CLEAR'
               else 'NORMAL' end as cont_status_cd
        ,ls.job_cd as job_cd
   from ${iml_schema}.evt_wld_dubil_wrt_off ls
  inner join ${iml_schema}.agt_wld_dubil_info_h al
     on ls.tran_ref_no = al.tran_ref_no
    and al.start_dt <= to_date('${batch_date}', 'yyyymmdd')
    and al.end_dt > to_date('${batch_date}', 'yyyymmdd')
    and al.job_cd = 'icmsf1'
   left join (select tran_ref_no
                    ,sum(case when evt_tran_code in ('G911','G301') and bal_compnt_group_cd = 'LP' 
                              then enter_acct_amt else 0 end) as actl_wrtoff_loan_pric   --实核贷款本金
                    ,sum(case when evt_tran_code in ('G911') and bal_compnt_group_cd in ('LI','LT') 
                              then enter_acct_amt else 0 end) as actl_wrtoff_off_bs_int --实核表外利息
               from ${iml_schema}.evt_wld_acct_ety_tran
              where evt_tran_code in ('G911','G301')
                and decode(debit_crdt_flg,'0','D','1','C',debit_crdt_flg) = 'D'
                and subj_id in ('111001156601002010', '111001156601002020')
                and bal_compnt_group_cd in ('LI','LT','LP')
                and job_cd='icmsi1'
              group by tran_ref_no) flow
     on ls.tran_ref_no = flow.tran_ref_no
   left join ${iml_schema}.evt_wld_dubil_wrt_off suc
     on ls.tran_ref_no = suc.tran_ref_no
      and suc.job_cd='icmsi1'
  where ls.wrt_off_status_cd = 'CheckPass'
    and ls.wrt_off_dt <= to_date('${batch_date}', 'yyyymmdd')
    and ls.job_cd = 'icmsi1'
;

whenever sqlerror exit sql.sqlcode;
insert /*+ append */ into ${icl_schema}.cmm_unite_wl_wrt_off_info_ex(
       etl_dt                     -- 数据日期
       ,lp_id                     -- 法人编号
       ,acct_id                   -- 账户编号
       ,dubil_id                  -- 借据编号
       ,cont_id                   -- 合同编号
       ,std_prod_id               -- 标准产品编号
       ,cust_id                   -- 客户编号
       ,belong_org_id             -- 所属机构编号
       ,appl_teller_id            -- 申请柜员编号
       ,fir_wrt_off_dt            -- 首次核销日期
       ,curr_cd                   -- 币种代码
       ,actl_wrtoff_loan_pric     -- 实核贷款本金
       ,actl_wrtoff_in_bs_int     -- 实核表内利息
       ,actl_wrtoff_off_bs_int    -- 实核表外利息
       ,wrt_off_advc_money_amt    -- 核销垫付款项金额
       ,wrt_off_retra_pric        -- 核销收回本金
       ,wrt_off_retra_in_bs_int   -- 核销收回表内利息
       ,wrt_off_retra_off_bs_int  -- 核销收回表外利息
       ,wrt_off_retra_advc_fee    -- 核销收回垫付费用
       ,wrt_off_retra_cnt         -- 核销收回笔数
       ,all_retra_flg             -- 全部收回标志
       ,final_wrt_off_retra_dt    -- 最后核销收回日期
       ,job_cd                    -- 任务代码
       ,etl_timestamp             -- 数据处理时间
)
select to_date('${batch_date}','yyyymmdd')                               -- 数据日期
       ,t1.lp_id                                                         -- 法人编号
       ,t1.dubil_id                                                      -- 账户编号
       ,t1.dubil_id                                                      -- 借据编号
       ,t1.dubil_id                                                      -- 合同编号
       ,t1.std_prod_id                                                   -- 标准产品编号
       ,t1.cust_id                                                       -- 客户编号
       ,t1.org_id                                                        -- 所属机构编号
       ,''                                                               -- 申请柜员编号
       ,t1.fir_wrt_off_dt                                                -- 首次核销日期
       ,'CNY'                                                            -- 币种代码
       ,t1.recvbl_pric                                                   -- 实核贷款本金
       ,0                                                                -- 实核表内利息
       ,t1.recvbl_off_bs_int                                             -- 实核表外利息
       ,t1.advc_fee                                                      -- 核销垫付款项金额
       ,t3.write_off_repay_pric                                          -- 核销收回本金
       ,0                                                                -- 核销收回表内利息
       ,t3.write_off_repay_off_bs_int                                    -- 核销收回表外利息
       ,t3.write_off_repay_adv_cost                                      -- 核销收回垫付费用
       ,t3.write_off_repay_cnt                                           -- 核销收回笔数
       ,case when t1.cont_status_cd='CLEAR' 
             then '1' else '0' end                                     -- 全部收回标志
       ,t3.write_off_repay_dt                                            -- 最后核销收回日期
       ,t1.job_cd                                                        -- 任务代码
       ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6')  -- 数据处理时间
  from ${icl_schema}.cmm_unite_wl_wrt_off_info_01 t1
/*  left join ${icl_schema}.cmm_unite_wl_dubil_info t2
    on t1.dubil_id = t2.dubil_id
   and t2.etl_dt = to_date('${batch_date}', 'yyyymmdd') */
  left join (select dubil_id,
                    sum(nvl(currt_repay_pric, 0)) as write_off_repay_pric,
                    0 as write_off_repay_in_bs_int,
                    sum(nvl(curr_repay_int, 0) + nvl(currt_repay_pnlt, 0)) as write_off_repay_off_bs_int,
                    sum(nvl(currt_repay_fee, 0)) as write_off_repay_adv_cost,
                    count(1) as write_off_repay_cnt,
                    max(repay_dt) as write_off_repay_dt
               from ${icl_schema}.cmm_unite_wl_repay_dtl  --modi hr
              where trunc(repay_dt) <= to_date('${batch_date}', 'yyyymmdd')
                and wrt_off_flg = '1'
              group by dubil_id) t3
    on t1.dubil_id = t3.dubil_id;
commit;


delete from ${icl_schema}.cmm_icl_batch_jnl  where etl_dt = to_date('${batch_date}', 'yyyymmdd') and tab_name = 'cmm_unite_wl_wrt_off_info';
commit;
whenever sqlerror exit sql.sqlcode;
insert into ${icl_schema}.cmm_icl_batch_jnl(
    etl_dt	                           -- 数据日期
   ,tab_name                           -- 表名
	 ,batch_status                       -- 跑批状态
	 ,batch_tm                           -- 跑批时间
	 ,etl_timestamp                      -- etl处理时间
)
select
   to_date('${batch_date}', 'yyyymmdd')                               -- 跑批日期
   ,'cmm_unite_wl_wrt_off_info'
   ,1                                                                 -- 跑批状态
   ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6')   -- 跑批时间
   ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6')   -- etl处理时间
from dual;
;
commit;


-- 2.3 exchage ex table and target table
alter table ${icl_schema}.cmm_unite_wl_wrt_off_info exchange partition p_${batch_date} with table ${icl_schema}.cmm_unite_wl_wrt_off_info_ex;

-- 3.1 drop ex table
drop table ${icl_schema}.cmm_unite_wl_wrt_off_info_ex purge;
drop table ${icl_schema}.cmm_unite_wl_wrt_off_info_01 purge;

-- 3.3 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname=>'${icl_schema}',tabname=>'cmm_unite_wl_wrt_off_info',partname=>'p_${batch_date}',estimate_percent=>10,method_opt=>'for all columns size 1',no_invalidate=>false,granularity=>'partition',cascade=>true,force=>true,degree=>8);