/*
Purpose:    共性加工层-对公贷款还款明细：包括所有对公贷款账户的所有还款明细信息，数据来源于新核心系统（NCBS）。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd icl_cmm_corp_loan_repay_dtl
CreateDate: 20220401
Logs:       20220608 李森辉 新增字段【贷款号】
            20220917 温旺清 修改临时表tmp_cmm_corp_loan_repay_dtl_01取数逻辑
            20221112 曹永茂 调整【还款账户编号】取数口径
            20221222 温旺清 调整 evt_repay_dtl 的算法
            20230109 陈伟峰 新增字段【明细序号】，调整主键，新增【明细序号】为主键
            20230111 陈伟峰 调整agt_loan_acct_stl_info_h 取数逻辑
            20230310 陈伟峰	调整agt_loan_acct_info_h表dubil_id使用逻辑，增加银团贷款'203010400001','602060100002'拼接规则	
            20230330 翟若平 调整字段【当期还款本金、当期还款利息、当期还款罚息、当期还款复利】的加工口径
            20241029 谢  宁 新增字段【还款事件代码】
            20241105 陈伟峰 调整prd_loan_prod_info_h关联方式，避免过滤集团委托贷款数据
			20250410 陈  凭 新增字段【还款类型代码】
            20260104 陈伟峰 evt_repay_flow调整为全量流水
*/

set timing on
-- 0.1 alter parallel
alter session force parallel query parallel 4;
alter session force parallel dml parallel 4;
-- alter session force parallel ddl parallel 1;

-- 1.1 drop timeout partition and add partition
whenever sqlerror continue none;
--alter table ${icl_schema}.cmm_corp_loan_repay_dtl drop partition p_${retain_day};
alter table ${icl_schema}.cmm_corp_loan_repay_dtl add partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

-- 1.2 drop tmp table
whenever sqlerror continue none ;
drop table ${icl_schema}.cmm_corp_loan_repay_dtl_ex purge;
drop table ${icl_schema}.tmp_cmm_corp_loan_repay_dtl_01 purge;

-- 1.3 insert data to tmp table
-- 获取还款信息（还款期数、当期还款本金、当期还款利息、当期还款罚息、当期还款复利等、还款账户编号）
whenever sqlerror exit sql.sqlcode;
create table ${icl_schema}.tmp_cmm_corp_loan_repay_dtl_01
nologging
compress ${option_switch} for query high
as
select t1.callbk_id
       ,t1.acct_id
       ,t1.curr_pd
       ,t2.tran_ref_no  -- 还款流水编号
       ,t2.bus_tran_dt  -- 还款日期
       ,t2.loan_repay_type_cd
       ,t2.loan_repay_dt
       ,t2.revs_flg  -- 冲账标志
       ,t2.curr_cd  -- 币种代码
       ,t3.stl_cust_acct_num -- 还款账户编号
       ,t2.tran_cd
       ,sum(nvl(t2.adv_repay_pric_amt, 0)) as adv_repay_pric_amt -- 当期提前还款本金
       ,sum(nvl(t2.adv_repay_fee_amt, 0)) as adv_repay_fee_amt  -- 当期还款费用
       ,sum(decode(t1.amt_type_cd, 'OSL', t1.callbk_pric * decode(t2.loan_repay_type_cd, 'WV', -1, 1), 0)) as osl_amt
       ,sum(decode(t1.amt_type_cd, 'PRI', t1.callbk_pric * decode(t2.loan_repay_type_cd, 'WV', -1, 1), 0)) as pri_amt
       ,sum(decode(t1.amt_type_cd, 'PRD', t1.callbk_pric * decode(t2.loan_repay_type_cd, 'WV', -1, 1), 0)) as prd_amt
       ,sum(decode(t1.amt_type_cd, 'INT', t1.callbk_pric * decode(t2.loan_repay_type_cd, 'WV', -1, 1), 'INTP', t1.callbk_pric * decode(t2.loan_repay_type_cd, 'WV', -1, 1), 0)) as int_amt
       ,sum(decode(t1.amt_type_cd, 'ODP', t1.callbk_pric * decode(t2.loan_repay_type_cd, 'WV', -1, 1), 0)) as odpp_amt
       ,sum(decode(t1.amt_type_cd, 'ODI', t1.callbk_pric * decode(t2.loan_repay_type_cd, 'WV', -1, 1), 0)) as odip_amt
	    -- ,row_number() over(partition by acct_id order by tran_tm desc) rn
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
 where t1.job_cd = 'ncbsf1'
 group by t1.callbk_id
          ,t1.acct_id
          ,t1.curr_pd
          ,t2.tran_ref_no
          ,t2.bus_tran_dt
          ,t2.loan_repay_type_cd
          ,t2.loan_repay_dt
          ,t2.revs_flg
          ,t2.curr_cd
          ,t3.stl_cust_acct_num
          ,t2.tran_cd
;

-- 1.4 create table for exchage and add partition
whenever sqlerror exit sql.sqlcode;
create table ${icl_schema}.cmm_corp_loan_repay_dtl_ex 
nologging
compress ${option_switch} for query high
as select * from ${icl_schema}.cmm_corp_loan_repay_dtl where 0=1;

-- 第一组
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ into ${icl_schema}.cmm_corp_loan_repay_dtl_ex(
       etl_dt                  -- 数据日期
       ,lp_id                  -- 法人编号
       ,acct_id                -- 账户编号
       ,dubil_id               -- 借据编号
       ,loan_num               -- 贷款号
       ,cont_id                -- 合同编号
       ,cust_id                -- 客户编号
       ,repay_acct_id          -- 还款账户编号
       ,repay_flow_id          -- 还款流水编号
       ,dtl_seq_num            -- 明细序号
       ,repay_dt               -- 还款日期
       ,repay_perds            -- 还款期数
       ,adv_repay_flg          -- 提前还款标志
       ,ovdue_repay_flg        -- 逾期还款标志
       ,debit_crdt_flg         -- 借贷标志
       ,strk_bal_flg           -- 冲账标志
       ,repay_evt_cd           -- 还款事件代码
       ,repay_chn_cd           -- 还款渠道代码
	   ,repay_type_cd          -- 还款类型代码
       ,curr_cd                -- 币种代码
       ,curr_nomal_pric_bal    -- 当前正常本金余额
       ,currt_adv_repay_pric   -- 当期提前还款本金
       ,currt_repay_pric       -- 当期还款本金
       ,currt_repay_int        -- 当期还款利息
       ,currt_repay_pnlt       -- 当期还款罚息
       ,currt_repay_comp_int   -- 当期还款复利
       ,currt_repay_fee        -- 当期还款费用
       ,job_cd                 -- 任务代码
       ,etl_timestamp          -- 数据处理时间
)
select to_date('${batch_date}','yyyymmdd')  -- 数据日期
       ,t1.lp_id  -- 法人编号
       ,t1.acct_id  -- 账户编号
       ,case when t1.prod_id in ('203010400001','602060100002') 
             then t1.dubil_id||t1.distr_flow_num
             else t1.dubil_id 
             end     -- 借据号
       ,t1.loan_num  -- 贷款号
       ,t3.cont_id   -- 合同编号
       ,t1.cust_id  -- 客户编号
       ,t5.stl_cust_acct_num  -- 还款账户编号
       ,t5.tran_ref_no  -- 还款流水编号
       ,t5.callbk_id   -- 明细序号
       ,t5.bus_tran_dt  -- 还款日期
       ,t5.curr_pd  -- 还款期数
       ,decode(t5.loan_repay_type_cd, 'ER', '1', '0')  -- 提前还款标志
       ,case when t5.loan_repay_dt < t5.bus_tran_dt then '1' else '0' end  -- 逾期还款标志
       ,t4.debit_crdt_flg  -- 借贷标志
       ,t5.revs_flg  -- 冲账标志
       ,t5.tran_cd   -- 还款事件代码
       ,t4.chn_id  -- 还款渠道代码
	   ,nvl(trim(t5.loan_repay_type_cd),'-') -- 还款类型代码
       ,t5.curr_cd  -- 币种代码
       ,t6.ld_nomal_pric  -- 当前正常本金余额
       ,t5.adv_repay_pric_amt  -- 当期提前还款本金
       ,t5.pri_amt  -- 当期还款本金
       ,t5.int_amt  -- 当期还款利息
       ,t5.odpp_amt  -- 当期还款罚息
       ,t5.odip_amt  -- 当期还款复利
       ,t5.adv_repay_fee_amt  -- 当期还款费用
       ,t1.job_cd  -- 任务代码
       ,to_timestamp('${batch_timestamp}','yyyy-mm-dd hh24:mi:ss.ff6')  -- 数据处理时间
  from ${iml_schema}.agt_loan_acct_info_h t1
 inner join ${icl_schema}.tmp_cmm_corp_loan_repay_dtl_01 t5
    on t1.acct_id = t5.acct_id
  left join ${iml_schema}.agt_loan_acct_attach_info_h t3
    on t1.loan_num = t3.loan_num
   and t3.start_dt <= to_date('${batch_date}','yyyymmdd')
   and t3.end_dt > to_date('${batch_date}','yyyymmdd')
   and t3.job_cd = 'ncbsf1'
  left join (select acct_id, tran_dt, tran_ref_no, cntpty_cust_acct_num, debit_crdt_flg, chn_id,
                    row_number() over(partition by acct_id, tran_dt, tran_ref_no order by tran_flow_num desc) rn
               from ${iml_schema}.evt_loan_fin_tran_flow
              where job_cd = 'ncbsi1'
                and trim(cntpty_cust_acct_num) is not null) t4 -- -- SIT3-20220619批量报错应急处理
    on t1.acct_id = t4.acct_id
   and t5.bus_tran_dt = t4.tran_dt
   and t5.tran_ref_no = t4.tran_ref_no
   and t4.tran_dt <= to_date('${batch_date}','yyyymmdd')
   and t4.rn = 1
  /* left join ${icl_schema}.tmp_cmm_corp_loan_repay_dtl_01 t5
    on t2.callbk_id = t5.callbk_id */
  left join ${iml_schema}.agt_loan_acct_bal_h t6
    on t1.agt_id = t6.agt_id
   and t6.start_dt <= to_date('${batch_date}','yyyymmdd')
   and t6.end_dt > to_date('${batch_date}','yyyymmdd')
   and t6.job_cd = 'ncbsf1'
  left join ${iml_schema}.prd_loan_prod_info_h t7
    on t1.prod_id = t7.prod_id
--   and t7.crdt_prod_cate_cd not in ('2','3','4')   --零售贷款,联合网贷,个人委托贷款
   and t7.start_dt <= to_date('${batch_date}','yyyymmdd')
   and t7.end_dt > to_date('${batch_date}','yyyymmdd')
   and t7.job_cd = 'icmsf1'
 where t1.start_dt <= to_date('${batch_date}','yyyymmdd')
   and t1.end_dt > to_date('${batch_date}','yyyymmdd')
   and t1.job_cd = 'ncbsf1'
   and ( t7.crdt_prod_cate_cd not in ('2','3','4') or t1.prod_id ='602030100003')   --零售贷款,联合网贷,个人委托贷款，集团委托贷款
;
commit;

-- 2.2 exchage ex table and target table
alter table ${icl_schema}.cmm_corp_loan_repay_dtl exchange partition p_${batch_date} with table ${icl_schema}.cmm_corp_loan_repay_dtl_ex;

-- 3.1 drop ex table
drop table ${icl_schema}.cmm_corp_loan_repay_dtl_ex purge;
drop table ${icl_schema}.tmp_cmm_corp_loan_repay_dtl_01 purge;

-- 3.2 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${icl_schema}',tabname => 'cmm_corp_loan_repay_dtl',partname => 'p_${batch_date}',granularity => 'PARTITION', degree => 8, cascade => true);