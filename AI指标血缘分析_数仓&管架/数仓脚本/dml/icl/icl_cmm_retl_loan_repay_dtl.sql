/*
Purpose:    共性加工层-零售贷款还款明细：包括所有行内零售贷款账户的还款明细，数据主要来源于新核心系统。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd icl_cmm_retl_loan_repay_dtl
CreateDate: 20190815
Logs:       20220606 新增字段【贷款号】
            20220802 曹永茂 补加金额类型：ODI-复利、ODP-罚息
            20220803 李森辉 调整【还款子期数】口径，赋固定值：1000
            20221114 曹永茂 调整【还款账户编号】取数口径
            20221222 温旺清 调整 evt_repay_dtl 的算法
            20230111 陈伟峰 调整agt_loan_acct_stl_info_h 取数逻辑
            20230330 翟若平 调整字段【当期还款本金、当期还款利息、当期还款罚息、当期还款复利】的加工口径
            20240116 饶雅   新增字段【冲账标志】
            20241212 谢宁   新增字段【回收模式代码】
            20250106 陈伟峰 新增【网商贷-房抵贷】产品数据
            20250427 陈伟峰 调整房抵贷还款子期数逻辑，使用默认值1000
            20250811 陈伟峰 调整房抵贷还款流水表，取T-2数据
            20260104 陈伟峰 evt_repay_flow调整为全量流水
*/

set timing on
-- 0.1 alter parallel
alter session force parallel query parallel 4;
alter session force parallel dml parallel 4;
-- alter session force parallel ddl parallel 1;

-- 1.1 drop timeout partition and add partition
whenever sqlerror continue none;
--alter table ${icl_schema}.cmm_retl_loan_repay_dtl drop partition p_${retain_day};
alter table ${icl_schema}.cmm_retl_loan_repay_dtl add partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

-- 1.2 drop tmp table
whenever sqlerror continue none ;
drop table ${icl_schema}.cmm_retl_loan_repay_dtl_ex purge;
drop table ${icl_schema}.tmp_cmm_retl_loan_repay_dtl_01 purge;

-- 1.3 insert data to tmp table
-- 获取还款信息（还款期数、当期还款本金、当期还款利息、当期还款罚息、当期还款复利等、还款账户编号）
whenever sqlerror exit sql.sqlcode;
create table ${icl_schema}.tmp_cmm_retl_loan_repay_dtl_01
nologging
compress ${option_switch} for query high
as
select t1.callbk_id
       ,t1.acct_id
       ,t1.curr_pd
	     ,t2.tran_ref_no
       ,t2.bus_tran_dt
       ,t2.loan_repay_type_cd
       ,t2.loan_repay_dt
       ,t2.curr_cd
	     ,t2.tran_cd
	     ,t2.revs_flg
	     ,t3.stl_cust_acct_num -- 还款账户编号
	     ,t2.callbk_mode_cd
       ,sum(decode(t1.amt_type_cd, 'OSL', t1.callbk_pric * decode(t2.loan_repay_type_cd, 'WV', -1, 1), 0)) as osl_amt
       ,sum(decode(t1.amt_type_cd, 'PRI', t1.callbk_pric * decode(t2.loan_repay_type_cd, 'WV', -1, 1), 0)) as pri_amt
       ,sum(decode(t1.amt_type_cd, 'PRD', t1.callbk_pric * decode(t2.loan_repay_type_cd, 'WV', -1, 1), 0)) as prd_amt
       ,sum(decode(t1.amt_type_cd, 'INT', t1.callbk_pric * decode(t2.loan_repay_type_cd, 'WV', -1, 1), 'INTP', t1.callbk_pric * decode(t2.loan_repay_type_cd, 'WV', -1, 1), 0)) as int_amt
       ,sum(decode(t1.amt_type_cd, 'ODP', t1.callbk_pric * decode(t2.loan_repay_type_cd, 'WV', -1, 1), 'ODPP', t1.callbk_pric * decode(t2.loan_repay_type_cd, 'WV', -1, 1), 0)) as odpp_amt
       ,sum(decode(t1.amt_type_cd, 'ODI', t1.callbk_pric * decode(t2.loan_repay_type_cd, 'WV', -1, 1), 'ODIP', t1.callbk_pric * decode(t2.loan_repay_type_cd, 'WV', -1, 1), 0)) as odip_amt
	     ,sum(nvl(t2.adv_repay_fee_amt, 0)) as adv_repay_fee_amt  -- 当期还款费用
	     ,case when max(t4.exp_dt) < t2.bus_tran_dt then '1' else '0' end  as ovdue_repay_flg
       ,max(t5.int_set_dt) as repaybl_dt        
  from ${iml_schema}.evt_repay_dtl t1
  inner join ${iml_schema}.evt_repay_flow t2
    on t1.callbk_id = t2.callbk_id
   and t2.bus_tran_dt = to_date('${batch_date}', 'yyyymmdd')
--   and t2.etl_dt <= to_date('${batch_date}','yyyymmdd')
   and t2.job_cd = 'ncbsi1'
  left join (SELECT callbk_id, acct_id, stl_cust_acct_num,
                    row_number() over(partition BY callbk_id, acct_id order by tran_stl_id asc) rn
               FROM iml.agt_loan_acct_stl_info_h
              WHERE start_dt <= to_date('${batch_date}','yyyymmdd')
                and end_dt > to_date('${batch_date}','yyyymmdd')
                AND evt_cate_id = 'REC'
                AND job_cd = 'ncbsf1') t3
    on t2.callbk_id = t3.callbk_id
   and t1.acct_id = t3.acct_id
   and t3.rn = 1
  left join ${iml_schema}.agt_loan_repay_plan_pd_h t4
     on t1.acct_id = t4.acct_id
    and t1.curr_pd = t4.curr_pd
    and t4.job_cd = 'ncbsf1'
    and t4.start_dt <= to_date('${batch_date}', 'yyyymmdd')
    and t4.end_dt > to_date('${batch_date}', 'yyyymmdd')    
  left join ${iml_schema}.agt_loan_repay_plan_dtl_h t5
     on t1.acct_id = t5.acct_id
    and t1.curr_pd = t5.curr_pd
    and t1.amt_type_cd = t5.amt_type_cd
    and t5.job_cd = 'ncbsf1'
    and t5.start_dt <= to_date('${batch_date}', 'yyyymmdd')
    and t5.end_dt > to_date('${batch_date}', 'yyyymmdd')         
 where t1.job_cd = 'ncbsf1'
 group by t1.callbk_id
         ,t1.acct_id
         ,t1.curr_pd
		     ,t2.tran_ref_no
         ,t2.bus_tran_dt
         ,t2.loan_repay_type_cd
         ,t2.loan_repay_dt
         ,t2.curr_cd
		     ,t2.tran_cd
		     ,t2.revs_flg
         ,t3.stl_cust_acct_num
         ,t2.callbk_mode_cd 		  
;

-- 1.4 create table for exchage and add partition
whenever sqlerror exit sql.sqlcode;
create table ${icl_schema}.cmm_retl_loan_repay_dtl_ex 
nologging
compress ${option_switch} for query high
as select * from ${icl_schema}.cmm_retl_loan_repay_dtl where 0=1;

-- 第一组 核心贷款还款流水
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ into ${icl_schema}.cmm_retl_loan_repay_dtl_ex(
       etl_dt                         -- 数据日期
       ,lp_id                         -- 法人编号
       ,acct_id                       -- 账户编号
       ,dubil_id                      -- 借据编号
       ,cont_id                       -- 合同编号
       ,loan_num                      -- 贷款号
       ,cust_id                       -- 客户编号
       ,repay_acct_id                 -- 还款账户编号
       ,repay_flow_id                 -- 还款流水编号
       ,repay_dt                      -- 还款日期
       ,repaybl_dt                    -- 应还款日期
       ,repay_perds                   -- 还款期数
       ,repay_sub_perds               -- 还款子期数
       ,adv_repay_flg                 -- 提前还款标志
       ,ovdue_repay_flg               -- 逾期还款标志
       ,comp_repay_flg                -- 代偿还款标志
       ,strk_bal_flg                  -- 冲账标志
       ,bf_repay_status_cd            -- 还款前还款状态代码
       ,repay_post_repay_status_cd    -- 还款后还款状态代码
       ,acru_non_acru_cd              -- 应计非应计代码
       ,tran_cd                       -- 交易代码
       ,curr_cd                       -- 币种代码
       ,dtl_seq_num                   -- 明细序号
       ,callbk_mode_cd                -- 回收模式代码
       ,repay_evt_cd                  -- 还款事件代码
       ,repay_evt_descb               -- 还款事件描述
       ,currt_repay_recvbl_acru_int   -- 当期还款应收应计利息
       ,currt_repay_coll_acru_int     -- 当期还款催收应计利息
       ,currt_repay_recvbl_over_int   -- 当期还款应收欠息
       ,currt_repay_coll_over_int     -- 当期还款催收欠息
       ,currt_repay_recvbl_acru_pnlt  -- 当期还款应收应计罚息
       ,currt_repay_coll_acru_pnlt    -- 当期还款催收应计罚息
       ,currt_repay_recvbl_pnlt       -- 当期还款应收罚息
       ,currt_repay_coll_pnlt         -- 当期还款催收罚息
       ,currt_repay_acru_comp_int     -- 当期还款应计复息
       ,currt_repay_recvbl_comp_int   -- 当期还款应收复息
       ,currt_fine                    -- 当期罚金
       ,currt_wrt_off_int             -- 当期核销利息
       ,curr_nomal_pric_bal           -- 当前正常本金余额
       ,currt_repay_pric              -- 当期还款本金
       ,currt_repay_int               -- 当期还款利息
       ,currt_repay_pnlt              -- 当期还款罚息
       ,currt_repay_comp_int          -- 当期还款复利
       ,currt_repay_fee               -- 当期还款费用
       ,unbd_int                      -- 未入账利息
       ,job_cd                        -- 任务代码
       ,etl_timestamp                 -- 数据处理时间
)
select to_date('${batch_date}','yyyymmdd')                                 -- 数据日期
       ,t1.lp_id                                                           -- 法人编号
       ,t1.acct_id                                                         -- 账户编号
       ,t1.dubil_id                                                        -- 借据编号
       ,t3.cont_id                                                         -- 合同编号
       ,t1.loan_num                                                        -- 贷款号
       ,t1.cust_id                                                         -- 客户编号
       ,t5.stl_cust_acct_num                                               -- 还款账户编号
       ,t5.tran_ref_no                                                     -- 还款流水编号
       ,t5.bus_tran_dt                                                     -- 还款日期
       ,t5.repaybl_dt                                                      -- 应还款日期
       ,t5.curr_pd                                                         -- 还款期数
       ,1000                                                               -- 还款子期数
       ,decode(t5.loan_repay_type_cd, 'ER', '1', '0')                      -- 提前还款标志
       ,t5.ovdue_repay_flg                                                 -- 逾期还款标志
       ,''                                                                 -- 代偿还款标志
       ,t5.revs_flg
       ,t5.loan_repay_type_cd                                              -- 还款前还款状态代码
       ,''                                                                 -- 还款后还款状态代码
       ,''                                                                 -- 应计非应计代码
       ,''                                                                 -- 交易代码
       ,t5.curr_cd                                                         -- 币种代码
       ,t5.callbk_id                                                       -- 明细序号
       ,t5.callbk_mode_cd                                                  -- 回收模式代码
       ,t5.tran_cd                                                         -- 还款事件代码
       ,t7.tran_code_descb                                                 -- 还款事件描述
       ,''                                                                 -- 当期还款应收应计利息
       ,''                                                                 -- 当期还款催收应计利息
       ,''                                                                 -- 当期还款应收欠息
       ,''                                                                 -- 当期还款催收欠息
       ,''                                                                 -- 当期还款应收应计罚息
       ,''                                                                 -- 当期还款催收应计罚息
       ,''                                                                 -- 当期还款应收罚息
       ,''                                                                 -- 当期还款催收罚息
       ,''                                                                 -- 当期还款应计复息
       ,''                                                                 -- 当期还款应收复息
       ,''                                                                 -- 当期罚金
       ,''                                                                 -- 当期核销利息
       ,t6.ld_nomal_pric                                                   -- 当前正常本金余额
       ,t5.pri_amt                                                         -- 当期还款本金
       ,t5.int_amt                                                         -- 当期还款利息
       ,t5.odpp_amt                                                        -- 当期还款罚息
       ,t5.odip_amt                                                        -- 当期还款复利
       ,t5.adv_repay_fee_amt                                               -- 当期还款费用
       ,''                                                                 -- 未入账利息
       ,t1.job_cd                                                          -- 任务代码
       ,to_timestamp('${batch_timestamp}','yyyy-mm-dd hh24:mi:ss.ff6')     -- 数据处理时间
  from ${iml_schema}.agt_loan_acct_info_h t1
  inner join ${icl_schema}.tmp_cmm_retl_loan_repay_dtl_01 t5
    on t1.acct_id = t5.acct_id
  left join ${iml_schema}.agt_loan_acct_attach_info_h t3
    on t1.loan_num = t3.loan_num
   and t3.start_dt <= to_date('${batch_date}','yyyymmdd')
   and t3.end_dt > to_date('${batch_date}','yyyymmdd')
   and t3.job_cd = 'ncbsf1'
  left join ${iml_schema}.agt_loan_acct_bal_h t6
    on t1.acct_id = t6.acct_id
   and t6.start_dt <= to_date('${batch_date}','yyyymmdd')
   and t6.end_dt > to_date('${batch_date}','yyyymmdd')
   and t6.job_cd = 'ncbsf1'
  left join ${iml_schema}.ref_tran_code_para t7  -- 还款事件描述
    on t5.tran_cd = t7.tran_code
   and t7.bus_cls_cd = 'CL'
   and t7.start_dt <= to_date('${batch_date}','yyyymmdd')
   and t7.end_dt > to_date('${batch_date}','yyyymmdd')
   and t7.job_cd = 'ncbsf1'
 inner join ${iml_schema}.prd_loan_prod_info_h t8
    on t1.prod_id = t8.prod_id
   and t8.crdt_prod_cate_cd in ('2', '4')
   and t8.start_dt <= to_date('${batch_date}','yyyymmdd')
   and t8.end_dt > to_date('${batch_date}','yyyymmdd')
   and t8.job_cd = 'icmsf1'
 where t1.start_dt <= to_date('${batch_date}','yyyymmdd')
   and t1.end_dt > to_date('${batch_date}','yyyymmdd')
   and t1.job_cd = 'ncbsf1'
;
commit;


-- 第二组 信贷房抵贷还款流水
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ into ${icl_schema}.cmm_retl_loan_repay_dtl_ex(
       etl_dt                         -- 数据日期
       ,lp_id                         -- 法人编号
       ,acct_id                       -- 账户编号
       ,dubil_id                      -- 借据编号
       ,cont_id                       -- 合同编号
       ,loan_num                      -- 贷款号
       ,cust_id                       -- 客户编号
       ,repay_acct_id                 -- 还款账户编号
       ,repay_flow_id                 -- 还款流水编号
       ,repay_dt                      -- 还款日期
       ,repaybl_dt                    -- 应还款日期
       ,repay_perds                   -- 还款期数
       ,repay_sub_perds               -- 还款子期数
       ,adv_repay_flg                 -- 提前还款标志
       ,ovdue_repay_flg               -- 逾期还款标志
       ,comp_repay_flg                -- 代偿还款标志
       ,strk_bal_flg                  -- 冲账标志
       ,bf_repay_status_cd            -- 还款前还款状态代码
       ,repay_post_repay_status_cd    -- 还款后还款状态代码
       ,acru_non_acru_cd              -- 应计非应计代码
       ,tran_cd                       -- 交易代码
       ,curr_cd                       -- 币种代码
       ,dtl_seq_num                   -- 明细序号
       ,callbk_mode_cd                -- 回收模式代码
       ,repay_evt_cd                  -- 还款事件代码
       ,repay_evt_descb               -- 还款事件描述
       ,currt_repay_recvbl_acru_int   -- 当期还款应收应计利息
       ,currt_repay_coll_acru_int     -- 当期还款催收应计利息
       ,currt_repay_recvbl_over_int   -- 当期还款应收欠息
       ,currt_repay_coll_over_int     -- 当期还款催收欠息
       ,currt_repay_recvbl_acru_pnlt  -- 当期还款应收应计罚息
       ,currt_repay_coll_acru_pnlt    -- 当期还款催收应计罚息
       ,currt_repay_recvbl_pnlt       -- 当期还款应收罚息
       ,currt_repay_coll_pnlt         -- 当期还款催收罚息
       ,currt_repay_acru_comp_int     -- 当期还款应计复息
       ,currt_repay_recvbl_comp_int   -- 当期还款应收复息
       ,currt_fine                    -- 当期罚金
       ,currt_wrt_off_int             -- 当期核销利息
       ,curr_nomal_pric_bal           -- 当前正常本金余额
       ,currt_repay_pric              -- 当期还款本金
       ,currt_repay_int               -- 当期还款利息
       ,currt_repay_pnlt              -- 当期还款罚息
       ,currt_repay_comp_int          -- 当期还款复利
       ,currt_repay_fee               -- 当期还款费用
       ,unbd_int                      -- 未入账利息
       ,job_cd                        -- 任务代码
       ,etl_timestamp                 -- 数据处理时间
)
select 
       to_date('${batch_date}','yyyymmdd')                         -- 数据日期
       ,'9999'                                                     -- 法人编号
       ,t1.duebillno	                                             --	账户编号
       ,t1.duebillno	                                             --	借据编号
       ,t2.rela_cont_id	                                           --	合同编号
       ,''	                                                       --	贷款号
       ,t1.customerid	                                             --	客户编号
       ,t1.payaccountno	                                           --	还款账户编号
       ,t1.serialno	                                               --	还款流水编号
       ,t1.transdate	                                             --	还款日期
       ,t4.enddate	                                               --	应还款日期
       ,t1.stageno	                                               --	还款期数
       ,1000	                                                       --	还款子期数
       ,case when t4.enddate >t1.transdate then '1' else '0' end	 --	提前还款标志
       ,case when t3.befstatus ='OVD' then '1' else '0' end	       --	逾期还款标志
       ,case when t1.receipttype ='05' then '1' else '0' end	     --	代偿还款标志
       ,t1.reversal	                                               --	冲账标志
       ,t3.befstatus	                                             --	还款前还款状态代码
       ,''	                                                       --	还款后还款状态代码
       ,t3.befaccruedstatus	                                       --	应计非应计代码
       ,''	                                                       --	交易代码
       ,t1.currency	                                               --	币种代码
       ,' '	                                                       --	明细序号
       ,'1'	                                                         --	回收模式代码
       ,t1.receipttype	                                           --	还款事件代码
       ,''	                                                       --	还款事件描述
       ,0	                                                         --	当期还款应收应计利息
       ,0	                                                         --	当期还款催收应计利息
       ,0	                                                         --	当期还款应收欠息
       ,0	                                                         --	当期还款催收欠息
       ,0	                                                         --	当期还款应收应计罚息
       ,0	                                                         --	当期还款催收应计罚息
       ,0	                                                         --	当期还款应收罚息
       ,0	                                                         --	当期还款催收罚息
       ,0	                                                         --	当期还款应计复息
       ,0	                                                         --	当期还款应收复息
       ,0	                                                         --	当期罚金
       ,0	                                                         --	当期核销利息
       ,t1.remamt	                                                 --	当前正常本金余额
       ,t1.priamt	                                                 --	当期还款本金
       ,t1.intamt	                                                 --	当期还款利息
       ,t1.odpamt	                                                 --	当期还款罚息
       ,t1.odiamt	                                                 --	当期还款复利
       ,0	                                                         --	当期还款费用
       ,0	                                                         --	未入账利息
       ,'icmsf1'                                                   -- 任务代码
       ,to_timestamp('${batch_timestamp}','yyyy-mm-dd hh24:mi:ss.ff6')      -- 数据处理时间
 from ${iol_schema}.icms_bat_repayment t1
inner join ${iml_schema}.agt_loan_dubil_info_h t2
   on t1.duebillno=t2.dubil_id
  and t2.start_dt <= to_date('${batch_date}', 'yyyymmdd')
  and t2.end_dt > to_date('${batch_date}', 'yyyymmdd')
  and t2.prod_id ='201020100057'
  and t2.job_cd = 'icmsf1'
 left join ${iol_schema}.icms_mybk_repay_cont_tail t3
   on t1.duebillno=t3.contractno 
  and t1.serialno=t3.seqno
  and t3.etl_dt = to_date('${batch_date}', 'yyyymmdd') -1
  and t3.repaydate = t1.transdate
 left join ${iol_schema}.icms_repayment_plan_info t4
   on t1.duebillno=t4.duebillserialno 
  and t1.stageno=t4.dateno
  and t4.start_dt <= to_date('${batch_date}', 'yyyymmdd')
  and t4.end_dt > to_date('${batch_date}', 'yyyymmdd')
 where t1.start_dt <= to_date('${batch_date}', 'yyyymmdd')
  and t1.end_dt > to_date('${batch_date}', 'yyyymmdd')
  and t1.transdate=to_date('${batch_date}', 'yyyymmdd')-1;
commit;

-- 2.2 exchage ex table and target table
alter table ${icl_schema}.cmm_retl_loan_repay_dtl exchange partition p_${batch_date} with table ${icl_schema}.cmm_retl_loan_repay_dtl_ex;

-- 3.1 drop ex table
--drop table ${icl_schema}.cmm_retl_loan_repay_dtl_ex purge;

-- 3.2 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${icl_schema}',tabname => 'cmm_retl_loan_repay_dtl',partname => 'p_${batch_date}',granularity => 'PARTITION', degree => 8, cascade => true);