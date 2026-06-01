/*
Purpose:    共性加工层-贷款核销信息：包括行内的对公贷款和零售贷款的贷款核销信息及累计核销收回的信息，数据来源于新核心系统NCBS。
Author:     Sunline/huangrong
Usage:      python $ETL_HOME/script/main.py yyyymmdd icl_cmm_loan_wrt_off_info
Createdate: 20200522
Logs:                20200624 周沁晖 零售贷款核销信息分组，因O层改表算法，调整T2表过滤条件
            20201106 周沁晖 调整逻辑：（第一组） t1.dubil_id = t2.acct_id ----> t1.loan_acct_id = t2.acct_id
                                                                                     全部收回标志 decode(t2.acct_status_cd, '12', '02', '12') ----> decode(t2.acct_status_cd, '12', '1', '0')
                                                                                     删除t4表中 kt.etl_dt = to_date('${batch_date}', 'yyyymmdd')、lb.etl_dt = to_date('${batch_date}', 'yyyymmdd')限定条件
                                                                                     新增t4表中 kt.tran_code = 'hxrepy'限定条件
                                                                                     t1.dubil_id = t4.loan_acct_id ----> t1.loan_acct_id = t4.loan_acct_id
                                                                                     t2.agt_id = t5.agt_id ----> t2.dubil_id = substr(t5.agt_id,7)
                                      （第二组） 新增临时表tmp_cmm_loan_wrt_off_info_01用于替换原t6表并调整关联逻辑t1.agt_id = t6.agt_id ----> t1.dubil_id = t6.agt_id
                                                 删除t2表中 rad.tran_dt = to_date('${batch_date}', 'yyyymmdd')限定条件
            20210804 陈伟峰 调整零售贷款中【核销收回垫付费用WRT_OFF_RETRA_ADVC_FEE】取数逻辑，从账户主表取->从账户主表的核销垫付款金额-核销垫付费余额
                            调整【核销收回本金-WRT_OFF_RETRA_PRIC】取数逻辑，从贷款客户账户交易明细表取【WRITE_OFF_REPAY_PRIC】->账户主表的【初始核销本金】减去【呆滞本金】减去【逾期本金】减去【正常本金】
                            调整【核销收回表外利息WRT_OFF_RETRA_OFF_BS_INT】取数逻辑
            20220425 李森辉 1、取数数据源调整，由旧核心系统和贷款产品系统调整为新核心系统取数
                            2、将对公贷款核销信息和零售贷款核销信息合并为一组。
                            3、新一代改造置空字段【APPL_TELLER_ID-申请柜员编号、WRT_OFF_ADVC_MONEY_AMT-核销垫付款项金额、WRT_OFF_RETRA_ADVC_FEE-核销收回垫付费用】
            20220606 温旺清 新增字段【贷款号】
            20220824 刘维勇 修改agt_loan_acct_info_h关联条件为t2.AGT_id = t3.AGT_id
            20220826 李森辉 1、调整【全部收回标志、合同编号】加工逻辑
            20221118 翟若平 调整字段【实核贷款本金、实核表内利息、实核表外利息】的加工口径
            20221222 温旺清 调整 evt_repay_dtl 的算法
            20230310 陈伟峰	调整agt_loan_acct_info_h表dubil_id使用逻辑，增加银团贷款'203010400001','602060100002'拼接规则	
            20230920 陈伟峰	调整字段【核销垫付款项金额】的加工口径
            20240507 饶雅   调整核销收回信息中CL_RECEIPT关联条件，剔除冲正交易
            20260104 陈伟峰 evt_repay_flow调整为全量流水
*/

set timing on
-- 0.1 alter parallel
alter session force parallel query parallel 4;
alter session force parallel dml parallel 4;
-- alter session force parallel ddl parallel 1;

-- 1.1 drop timeout partition and add partition
whenever sqlerror continue none;
--alter table ${icl_schema}.cmm_loan_wrt_off_info drop partition p_${retain_day};
alter table ${icl_schema}.cmm_loan_wrt_off_info add partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

-- 1.2 drop temporary table cmm_loan_wrt_off_info_ex
whenever sqlerror continue none ;
drop table ${icl_schema}.cmm_loan_wrt_off_info_ex purge;
drop table ${icl_schema}.tmp_cmm_loan_wrt_off_info_01 purge;

-- 1.3 insert data to tmp table
-- 获取核销收回信息（核销收回本金、核销收回表内利息、核销收回表外利息、核销收回笔数、全部收回标志、最后核销收回日期等）
whenever sqlerror exit sql.sqlcode;
create table ${icl_schema}.tmp_cmm_loan_wrt_off_info_01
nologging
compress ${option_switch} for query high
as
select t1.agt_id,
       t1.acct_id,
       sum(coalesce(t5.pri_amt, t3.callbk_pric, 0)) as wrt_off_retra_pric, -- 核销收回本金
       sum(nvl(t5.int_amt, 0)) as wrt_off_retra_in_bs_int, -- 核销收回表内利息
       sum(nvl(t5.odpp_amt, 0)) as wrt_off_retra_off_bs_int, -- 核销收回表外利息
       count(distinct t3.callbk_id) as wrt_off_retra_cnt, -- 核销收回笔数
       --max(decode(t2.last_acct_status_cd, 'C', '1', '0')) as all_retra_flg, -- 全部收回标志
       max(decode(case when t2.acct_status_modif_dt > to_date('${batch_date}', 'yyyymmdd') then t2.last_acct_status_cd else t2.acct_status_cd end, 'C', '1', '0'))  as all_retra_flg, -- 全部收回标志
       max(t3.bus_tran_dt) as final_wrt_off_retra_dt -- 最后核销收回日期
  from ${iml_schema}.agt_loan_acct_wrt_off_h t1
 inner join ${iml_schema}.agt_loan_acct_info_h t2
    on t2.agt_id = t1.agt_id
   and t2.start_dt <= to_date('${batch_date}', 'yyyymmdd')
   and t2.end_dt > to_date('${batch_date}', 'yyyymmdd')
   and t2.job_cd = 'ncbsf1'
  left join ${iml_schema}.evt_repay_flow t3
    on t3.loan_num = t2.loan_num
   and t3.revs_flg <>'1'
   and t3.bus_tran_dt >= t1.wrt_off_dt
   and t3.bus_tran_dt <= to_date('${batch_date}', 'yyyymmdd')
 --  and t3.etl_dt <= to_date('${batch_date}','yyyymmdd')
   and t3.job_cd = 'ncbsi1'
  left join (select t4.evt_id,
                    sum(decode(t4.amt_type_cd, 'OSL', t4.callbk_pric, 0)) as osl_amt,
                    sum(decode(t4.amt_type_cd, 'PRI', t4.callbk_pric, 0)) as pri_amt,
                    sum(decode(t4.amt_type_cd, 'PRD', t4.callbk_pric, 0)) as prd_amt,
                    sum(decode(t4.amt_type_cd, 'INT', t4.callbk_pric, 'INTP', t4.callbk_pric, 0)) as int_amt,
                    sum(decode(t4.amt_type_cd, 'ODPP', t4.callbk_pric, 0)) as odpp_amt,
                    sum(decode(t4.amt_type_cd, 'ODIP', t4.callbk_pric, 0)) as odip_amt
               from ${iml_schema}.evt_repay_dtl t4
              where t4.etl_dt = to_date('${batch_date}','yyyymmdd')
                and t4.job_cd = 'ncbsf1'
              group by t4.evt_id) t5
    on t3.evt_id = t5.evt_id
 where t1.start_dt <= to_date('${batch_date}', 'yyyymmdd')
   and t1.end_dt > to_date('${batch_date}', 'yyyymmdd')
   and t1.job_cd = 'ncbsf1'
 group by t1.agt_id, t1.acct_id
;

-- 2.1 insert into ex table
whenever sqlerror exit sql.sqlcode;
create table ${icl_schema}.cmm_loan_wrt_off_info_ex
nologging
compress ${option_switch} for query high
as
select * from ${icl_schema}.cmm_loan_wrt_off_info where 0=1;

-- 第一组（共一组）贷款核销信息
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ into ${icl_schema}.cmm_loan_wrt_off_info_ex(
       etl_dt                     -- 数据日期
       ,lp_id                     -- 法人编号
       ,acct_id                   -- 账户编号
       ,dubil_id                  -- 借据编号
       ,cont_id                   -- 合同编号
       ,loan_num                  -- 贷款号
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
       ,t1.acct_id                                                       -- 账户编号
       ,case when t2.prod_id in ('203010400001','602060100002') 
             then t2.dubil_id||t2.distr_flow_num
             else t2.dubil_id 
             end                                                         -- 借据号
       ,nvl(trim(t5.contract_no), t3.rela_cont_id)                       -- 合同编号
       ,t2.loan_num                                                      -- 贷款号
       ,t2.prod_id                                                       -- 标准产品编号
       ,t1.cust_id                                                       -- 客户编号
       ,t2.open_acct_org_id                                              -- 所属机构编号
       ,''                                                               -- 申请柜员编号
       ,t1.wrt_off_dt                                                    -- 首次核销日期
       ,t2.curr_cd                                                       -- 币种代码
       --,t1.ld_wrt_off_pric                                               -- 实核贷款本金  -- 当前时点
       ,t1.wrt_off_tm_point_amt                                          -- 实核贷款本金  --核销时点
       ,0                                                                -- 实核表内利息
       --,t1.ld_wrt_off_pnlt_int + t1.ld_wrt_off_nomal_int                 -- 实核表外利息  -- 当前时点
       ,t1.wrt_off_tm_point_int_amt + t1.wrt_off_tm_point_pnlt_amt + t1.wrt_off_tm_point_comp_int_amt       -- 实核表外利息  --核销时点
       ,t6.advc_fee                                                               -- 核销垫付款项金额
       ,t4.wrt_off_retra_pric                                            -- 核销收回本金
       ,t4.wrt_off_retra_in_bs_int                                       -- 核销收回表内利息
       ,t4.wrt_off_retra_off_bs_int                                      -- 核销收回表外利息
       ,''                                                               -- 核销收回垫付费用
       ,t4.wrt_off_retra_cnt                                             -- 核销收回笔数
       ,t4.all_retra_flg                                                 -- 全部收回标志
       ,t4.final_wrt_off_retra_dt                                        -- 最后核销收回日期
       ,t1.job_cd                                                        -- 任务代码
       ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6')  -- 数据处理时间
  from (select t1.*,row_number()over(partition by t1.acct_id order by t1.wrt_off_dt desc) as rn
          from  ${iml_schema}.agt_loan_acct_wrt_off_h t1
	       where t1.start_dt <= to_date('${batch_date}', 'yyyymmdd')
             and t1.end_dt > to_date('${batch_date}', 'yyyymmdd')
             and t1.job_cd = 'ncbsf1') t1
  left join ${iml_schema}.agt_loan_acct_info_h t2
    on t1.agt_id = t2.agt_id
   and t2.start_dt <= to_date('${batch_date}', 'yyyymmdd')
   and t2.end_dt > to_date('${batch_date}', 'yyyymmdd')
   and t2.job_cd = 'ncbsf1'
  left join ${iml_schema}.agt_loan_dubil_info_h t3
    on (case when t2.prod_id in ('203010400001','602060100002') 
             then t2.dubil_id||t2.distr_flow_num
             else t2.dubil_id 
             end) = t3.dubil_id
   -- on t2.agt_id = t3.agt_id
   and t3.start_dt <= to_date('${batch_date}', 'yyyymmdd')
   and t3.end_dt > to_date('${batch_date}', 'yyyymmdd')
   and t3.job_cd = 'icmsf1'
  left join ${icl_schema}.tmp_cmm_loan_wrt_off_info_01 t4
    on t1.agt_id = t4.agt_id
  left join ${iol_schema}.ncbs_cl_loan t5
    on t2.loan_num = t5.loan_no
   and t5.start_dt <= to_date('${batch_date}', 'yyyymmdd')
   and t5.end_dt > to_date('${batch_date}', 'yyyymmdd')
  left join ${iml_schema}.agt_ant_wrt_off_dubil t6
    on (case when t2.prod_id in ('203010400001','602060100002') 
             then t2.dubil_id||t2.distr_flow_num
             else t2.dubil_id 
             end)=t6.dubil_id
   and t6.bus_type_cd in ('0')
   and t6.create_dt <= to_date('${batch_date}', 'yyyymmdd')
   and t6.job_cd = 'myhxf1'
   and t6.id_mark <> 'D'
  where rn = 1
;
commit;

-- 2.3 exchage ex table and target table
alter table ${icl_schema}.cmm_loan_wrt_off_info exchange partition p_${batch_date} with table ${icl_schema}.cmm_loan_wrt_off_info_ex;

-- 3.1 drop ex table
--drop table ${icl_schema}.cmm_loan_wrt_off_info_ex purge;
--drop table ${icl_schema}.tmp_cmm_loan_wrt_off_info_01 purge;

-- 3.3 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${icl_schema}',tabname => 'cmm_loan_wrt_off_info', partname => 'p_${batch_date}', granularity => 'PARTITION', degree => 8, cascade => true);