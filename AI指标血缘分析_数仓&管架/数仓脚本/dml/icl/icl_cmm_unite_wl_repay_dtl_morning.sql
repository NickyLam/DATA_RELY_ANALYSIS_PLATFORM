/*
Purpose:    共性加工层-联合网贷还款明细：包括所有的花呗、借呗、网商贷、微粒贷、借呗三期、京东金融等网络贷款的还款明细信息。数据来源于综合信贷管理系统(ICMS)和中台系统(MPCS)。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py 20221112 icl_cmm_unite_wl_repay_dtl
CreateDate: 20190815
Logs:       20250220 谢宁 新增微业贷
            20250730 陈伟峰 新增乐分期
            20251222 陈伟峰 新增对公微业贷203050100002
*/

set timing on
-- 0.1 alter parallel
alter session force parallel query parallel 4;
alter session force parallel dml parallel 4;
-- alter session force parallel ddl parallel 1;

-- 1.1 drop timeout partition and add partition
whenever sqlerror continue none;
--alter table ${icl_schema}.cmm_unite_wl_repay_dtl drop partition p_${retain_day};
alter table ${icl_schema}.cmm_unite_wl_repay_dtl add partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

-- 1.2 drop tmp table
whenever sqlerror continue none ;
drop table ${icl_schema}.cmm_unite_wl_repay_dtl_ex purge;
drop table ${icl_schema}.cmm_unite_wl_repay_dtl_ex01 purge;
;

-- 1.3 create table for exchage and add partition
whenever sqlerror exit sql.sqlcode;
create table ${icl_schema}.cmm_unite_wl_repay_dtl_ex 
nologging
compress ${option_switch} for query high
as select * from ${icl_schema}.cmm_unite_wl_repay_dtl where 0=1;


-- 第一组 微业贷
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ into ${icl_schema}.cmm_unite_wl_repay_dtl_ex(
       etl_dt                        -- 数据日期
       ,lp_id                        -- 法人编号
       ,dubil_id                     -- 借据编号
       ,cust_id                      -- 客户编号
       ,prod_id                      -- 产品编号
       ,repay_acct_id                -- 还款账户编号
       ,repay_flow_id                -- 还款流水编号
       ,repay_dt                     -- 还款日期
       ,intnal_carr_flg              -- 内部结转标志
       ,wrt_off_flg                  -- 核销标志
       ,adv_repay_flg                -- 提前还款标志
       ,ovdue_repay_flg              -- 逾期还款标志
       ,acru_non_acru_cd             -- 应计非应计代码
       ,repay_type_cd                -- 还款类型代码
       ,curr_cd                      -- 币种代码
       ,curr_nomal_pric_bal          -- 当前正常本金余额
       ,currt_repay_amt              -- 当期还款金额
       ,currt_repay_pric             -- 当期还款本金
       ,currt_repay_nomal_pric       -- 当期还款正常本金
       ,currt_repay_ovdue_pric       -- 当期还款逾期本金
       ,curr_repay_int               -- 当前还款利息
       ,currt_repay_nomal_int        -- 当期还款正常利息
       ,currt_repay_ovdue_int        -- 当期还款逾期利息
       ,currt_repay_pnlt             -- 当期还款罚息
       ,currt_repay_ovdue_pric_pnlt  -- 当期还款逾期本金罚息
       ,currt_repay_ovdue_int_pnlt   -- 当期还款逾期利息罚息
       ,currt_repay_fee              -- 当期还款费用
       ,currt_repay_fee_rat          -- 当期还款费率
       ,bf_repay_recvbl_uncol_nomal_pric       -- 还款前的应收未收正常本金
       ,bf_repay_recvbl_uncol_ovdue_pric       -- 还款前的应收未收逾期本金
       ,bf_repay_recvbl_uncol_nomal_int        -- 还款前的应收未收正常利息
       ,bf_repay_recvbl_uncol_ovdue_int        -- 还款前的应收未收逾期利息
       ,bf_repay_recvbl_uncol_ovdue_pric_pnlt  -- 还款前的应收未收逾期本金罚息
       ,bf_repay_recvbl_uncol_ovdue_int_pnlt   -- 还款前的应收未收逾期利息罚息
       ,job_cd                       -- 任务代码
       ,etl_timestamp                -- 数据处理时间
)
select to_date('${batch_date}','yyyymmdd')                                 -- 数据日期
       ,t1.lp_id                                                           -- 法人编号
       ,t1.dubil_id                                                        -- 借据编号
       ,t1.cust_id                                                         -- 客户编号
       ,t1.prod_id                                                         -- 产品编号
       ,t2.repay_num_id                                                    -- 还款账户编号**
       ,t1.repay_flow_num                                                  -- 还款流水编号
       ,t1.repay_dt                                                        -- 还款日期
       ,'0'                                                                -- 内部结转标志
       ,''                                                                 -- 核销标志
       ,case when t1.repay_type_cd in ('05','06') then '1' else '0' end    -- 提前还款标志
       ,case when t1.repay_type_cd = '03' then '1' else '0' end            -- 逾期还款标志
       ,''                                                                 -- 应计非应计代码
       ,t1.repay_type_cd                                                   -- 还款类型代码
       ,'CNY'                                                              -- 币种代码
       ,nvl(t2.loan_bal,0)                                                 -- 当前正常本金余额
       ,nvl(t1.repay_pric,0)+nvl(t1.repay_int,0)+nvl(t1.repay_pnlt,0)+nvl(t1.repay_fee,0) -- 当期还款金额
       ,nvl(t1.repay_pric,0)                                               -- 当期还款本金
       ,case when t1.repay_type_cd in ('01') then nvl(t1.repay_pric,0) end -- 当期还款正常本金
       ,case when t1.repay_type_cd in ('03') then nvl(t1.repay_pric,0) end -- 当期还款逾期本金
       ,nvl(t1.repay_int,0)                                                -- 当前还款利息
       ,case when t1.repay_type_cd in ('01') then nvl(t1.repay_int,0) end  -- 当期还款正常利息
       ,case when t1.repay_type_cd in ('03') then nvl(t1.repay_int,0) end  -- 当期还款逾期利息
       ,nvl(t1.repay_pnlt,0)                                               -- 当期还款罚息
       ,case when t1.repay_type_cd in ('01') then nvl(t1.repay_pnlt,0) end -- 当期还款逾期本金罚息
       ,case when t1.repay_type_cd in ('03') then nvl(t1.repay_pnlt,0) end -- 当期还款逾期利息罚息
       ,nvl(t1.repay_fee,0)                                                -- 当期还款费用
       ,''                                                                 -- 当期还款费率
       ,''                                                                 -- 还款前的应收未收正常本金
       ,''                                                                 -- 还款前的应收未收逾期本金
       ,''                                                                 -- 还款前的应收未收正常利息
       ,''                                                                 -- 还款前的应收未收逾期利息
       ,''                                                                 -- 还款前的应收未收逾期本金罚息
       ,''                                                                 -- 还款前的应收未收逾期利息罚息
       ,t1.job_cd                                                          -- 任务代码
       ,to_timestamp('${batch_timestamp}','yyyy-mm-dd hh24:mi:ss.ff6')     -- 数据处理时间    
  from ${iml_schema}.evt_wyd_repay_dtl t1
  left join ${iml_schema}.agt_wyd_dubil_h t2
    on t1.dubil_id = t2.dubil_id
   and t2.etl_dt = to_date('${batch_date}','yyyymmdd')
   and t2.job_cd = 'icmsf1'
 where t1.etl_dt = to_date('${batch_date}','yyyymmdd')
   and t1.job_cd = 'icmsi1'
   and trunc(t1.repay_dt) = to_date('${batch_date}','yyyymmdd')
   and t1.PROD_ID in ('201020100063','203050100002') --微业贷3.0\对公微业贷
;
commit;

-- 第二组 分期乐
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ into ${icl_schema}.cmm_unite_wl_repay_dtl_ex(
       etl_dt                        -- 数据日期
       ,lp_id                        -- 法人编号
       ,dubil_id                     -- 借据编号
       ,cust_id                      -- 客户编号
       ,prod_id                      -- 产品编号
       ,repay_acct_id                -- 还款账户编号
       ,repay_flow_id                -- 还款流水编号
       ,repay_dt                     -- 还款日期
       ,intnal_carr_flg              -- 内部结转标志
       ,wrt_off_flg                  -- 核销标志
       ,adv_repay_flg                -- 提前还款标志
       ,ovdue_repay_flg              -- 逾期还款标志
       ,acru_non_acru_cd             -- 应计非应计代码
       ,repay_type_cd                -- 还款类型代码
       ,curr_cd                      -- 币种代码
       ,curr_nomal_pric_bal          -- 当前正常本金余额
       ,currt_repay_amt              -- 当期还款金额
       ,currt_repay_pric             -- 当期还款本金
       ,currt_repay_nomal_pric       -- 当期还款正常本金
       ,currt_repay_ovdue_pric       -- 当期还款逾期本金
       ,curr_repay_int               -- 当前还款利息
       ,currt_repay_nomal_int        -- 当期还款正常利息
       ,currt_repay_ovdue_int        -- 当期还款逾期利息
       ,currt_repay_pnlt             -- 当期还款罚息
       ,currt_repay_ovdue_pric_pnlt  -- 当期还款逾期本金罚息
       ,currt_repay_ovdue_int_pnlt   -- 当期还款逾期利息罚息
       ,currt_repay_fee              -- 当期还款费用
       ,currt_repay_fee_rat          -- 当期还款费率
       ,bf_repay_recvbl_uncol_nomal_pric       -- 还款前的应收未收正常本金
       ,bf_repay_recvbl_uncol_ovdue_pric       -- 还款前的应收未收逾期本金
       ,bf_repay_recvbl_uncol_nomal_int        -- 还款前的应收未收正常利息
       ,bf_repay_recvbl_uncol_ovdue_int        -- 还款前的应收未收逾期利息
       ,bf_repay_recvbl_uncol_ovdue_pric_pnlt  -- 还款前的应收未收逾期本金罚息
       ,bf_repay_recvbl_uncol_ovdue_int_pnlt   -- 还款前的应收未收逾期利息罚息
       ,job_cd                       -- 任务代码
       ,etl_timestamp                -- 数据处理时间
)
select
        to_date('${batch_date}','yyyymmdd')                            -- 数据日期
       ,t1.lp_id                                                          -- 法人编号
       ,t1.dubil_id                                                       --借据编号
       ,t3.cust_id                                                        --客户编号
       ,t3.prod_id                                                        --产品编号
       ,t1.repay_num_id                                                   --还款账户编号
       ,t1.src_appl_flow_num ||t1.dubil_id||t1.repay_perds||t1.repay_type_cd   --还款流水编号
       ,t1.repay_dt                                                       --还款日期
       ,''                                                                --内部结转标志
       ,''                                                                --核销标志
       ,case when t1.repay_type_cd ='PO' then '1' else '0' end     --提前还款标志
       ,case when t1.repay_type_cd ='08' then '1' else '0' end     --逾期还款标志
       ,''                                                                --应计非应计代码
       ,t1.repay_type_cd                                                  --还款类型代码
       ,t1.curr_cd                                                        --币种代码
       ,sum(t3.nomal_pric_bal)                                           --当前正常本金余额
       ,sum(t1.paid_amt_tot)                                             --当期还款金额
       ,sum(t1.paid_pric)                                                --当期还款本金
       ,sum(t1.paid_pric)                                                --当前还款正常本金
       ,0                                                                 --当期还款逾期本金
       ,sum(t1.paid_int)                                                 --当期还款利息
       ,sum(t1.paid_int)                                                 --当期还款正常利息
       ,0                                                                  --当期还款逾期利息
       ,sum(t1.paid_pnlt)                                                --当期还款罚息
       ,0                                                                  --当期还款逾期本金罚息
       ,0                                                                  --当期还款逾期利息罚息
       ,0                                                                  --当期还款费用
       ,0                                                                  --当期还款费率
       ,0                                                                  --还款前的应收未收正常本金
       ,0                                                                  --还款前的应收未收逾期本金
       ,0                                                                  --还款前的应收未收正常利息
       ,0                                                                  --还款前的应收未收逾期利息
       ,0                                                                  --还款前的应收未收逾期本金罚息
       ,0                                                                  --还款前的应收未收逾期利息罚息
       ,t1.job_cd                                                          -- 任务代码
       ,to_timestamp('${batch_timestamp}','yyyy-mm-dd hh24:mi:ss.ff6')     -- 数据处理时间    
  from ${iml_schema}.evt_lx_repay_dtl t1
  left join ${iml_schema}.agt_lx_dubil_info_h t3
    on t1.dubil_id = t3.dubil_id
   and t3.start_dt <= to_date('${batch_date}','yyyymmdd')
   and t3.end_dt > to_date('${batch_date}','yyyymmdd')
   and t3.job_cd = 'icmsf1'
 where t1.job_cd = 'icmsi1'
   and trunc(t1.repay_dt) = to_date('${batch_date}','yyyymmdd')  --不能卡etl_dt，会漏数
group by t1.lp_id
           ,t1.dubil_id
           ,t3.cust_id
           ,t3.prod_id
           ,t1.repay_num_id
           ,t1.src_appl_flow_num
           ,t1.repay_perds
           ,t1.repay_dt
           ,t1.repay_type_cd
           ,t1.curr_cd
           ,t1.job_cd
;
commit;
 



delete from ${icl_schema}.cmm_icl_batch_jnl where etl_dt = to_date('${batch_date}', 'yyyymmdd') and tab_name = 'cmm_unite_wl_repay_dtl_morning';
commit;
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ into ${icl_schema}.cmm_icl_batch_jnl(
       etl_dt          -- 数据日期
       ,tab_name       -- 表名
       ,batch_status   -- 跑批状态
       ,batch_tm       -- 跑批时间
       ,etl_timestamp  -- etl处理时间
)
select to_date('${batch_date}', 'yyyymmdd')                              -- 跑批日期
       ,'cmm_unite_wl_repay_dtl_morning'                                  -- 表名
       ,1                                                                -- 跑批状态
       ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6')  -- 跑批时间
       ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6')  -- etl处理时间
  from dual;
;
commit; 

-- 2.2 exchage ex table and target table
alter table ${icl_schema}.cmm_unite_wl_repay_dtl exchange partition p_${batch_date} with table ${icl_schema}.cmm_unite_wl_repay_dtl_ex;

-- 3.1 drop ex table
drop table ${icl_schema}.cmm_unite_wl_repay_dtl_ex purge;

-- 3.2 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname=>'${icl_schema}',tabname=>'cmm_unite_wl_repay_dtl',partname=>'p_${batch_date}',estimate_percent=>10,method_opt=>'for all columns size 1',no_invalidate=>false,granularity=>'partition',cascade=>true,force=>true,degree=>8);