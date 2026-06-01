/*
Purpose:    报表集市层-零售贷款日均余额信息表：包括所有的零售贷款日均余额。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd idl_dmm_retl_loan_avg_bal_info
CreateDate: 20220329
Logs:       20250410 陈伟峰 手工脚本
*/

set timing on
-- 0.1 alter parallel
alter session force parallel query parallel 8;
alter session force parallel dml parallel 8;
-- alter seesion force parallel ddl parallel 1;

-- 1.1 drop timeout partition and add partition
whenever sqlerror continue none;
--alter table ${idl_schema}.dmm_retl_loan_avg_bal_info drop partition p_${retain_day};
alter table ${idl_schema}.dmm_retl_loan_avg_bal_info add partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

-- 1.2 create table for exchage and add partition
whenever sqlerror continue none;
drop table ${idl_schema}.dmm_retl_loan_avg_bal_info_ex purge;
drop table ${idl_schema}.tmp_dmm_retl_loan_avg_bal_info_01 purge;
drop table ${idl_schema}.tmp_dmm_retl_loan_avg_bal_info_02 purge;

--1.3 获取借据逾期情况
whenever sqlerror exit sql.sqlcode;
create table ${idl_schema}.tmp_dmm_retl_loan_avg_bal_info_01
nologging
compress ${option_switch} for query high
as
select distinct serialno
  from ${iol_schema}.icms_business_duebill
 where overduedays <>0
   and productid='201020100042'
   and start_dt <=to_date('${batch_date}','yyyymmdd')
   and end_dt >to_date('${month_start}','yyyymmdd')    --月初日期
;

--1.4 获取借据逾期日期
whenever sqlerror exit sql.sqlcode;
create table ${idl_schema}.tmp_dmm_retl_loan_avg_bal_info_02
nologging
compress ${option_switch} for query high
as
select serialno
       ,case when min(start_dt) <=to_date('${month_start}','yyyymmdd') then to_date('${month_start}','yyyymmdd')
              else min(start_dt) end as ovdue_dt
  from ${iol_schema}.icms_business_duebill
 where productid='201020100042'
    and overduedays <>0
    and start_dt <=to_date('${batch_date}','yyyymmdd')
    and end_dt >to_date('${month_start}','yyyymmdd')    --月初日期
  group by serialno
;

-- 2.1 insert into ex table
whenever sqlerror exit sql.sqlcode;
create table ${idl_schema}.dmm_retl_loan_avg_bal_info_ex
nologging
compress ${option_switch} for query high
as select * from ${idl_schema}.dmm_retl_loan_avg_bal_info where 0=1;

--第一组 核心贷款账户信息
whenever sqlerror exit sql.sqlcode;
insert into ${idl_schema}.dmm_retl_loan_avg_bal_info_ex(
       etl_dt                         -- 数据日期
       ,lp_id                         -- 法人编号
       ,dubil_num                     -- 借据号
       ,std_prod_id                   -- 标准产品编号
       ,curr_mon_is_ovdue_flg         -- 当月是否逾期标志
       ,curr_mon_fir_ovdue_dt         -- 当月首次逾期日期
       ,m_avg_bal                     -- 月日均余额
       ,job_cd                        -- 任务代码
       ,etl_timestamp                 -- 数据处理时间
)
select to_date('${batch_date}','yyyymmdd')                                         --数据日期
       ,'9999'                                                                        --法人编号
       ,t1.cmisloan_no                                                                --借据号
       ,t1.prod_type                                                                  --标准产品编号
       ,case when t4.serialno is not null then '1' else '0' end                 --当月是否逾期标志
       ,t5.ovdue_dt                                                                   --当月是否逾期标志
       ,nvl(t3.loan_bal,0)/to_number(substr('${batch_date}', 7, 2))              --月日均余额
       ,'ncbsf1'                                                                      --任务代码
       ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6')               --数据处理时间
 from ${iol_schema}.ncbs_cl_acct t1
  left join (select loanno,sum(loan_bal) as loan_bal from (
               select loanno,normpr+reacin+veripr as loan_bal
                 from ${iol_schema}.tgls_ama_loan_acct_h  p1
                where to_date(trandt,'yyyymmdd') between to_date('${month_start}','yyyymmdd') and to_date('${batch_date}','yyyymmdd') 
                  and etl_dt between to_date('${month_start}','yyyymmdd') and to_date('${batch_date}','yyyymmdd') 
               union all
              select loanno,normpr+reacin+veripr as loan_bal
                from ${iol_schema}.tgls_ama_loan_acct p1
               where not exists
                 (select 1
                    from ${iol_schema}.tgls_ama_loan_acct_h p2
                   where p1.stacid = p2.stacid
                      and p1.systid = p2.systid
                      and p1.loanno = p2.loanno
                      and p1.trandt = p2.trandt
                      and p2.etl_dt between to_date('${month_start}','yyyymmdd') and to_date('${batch_date}','yyyymmdd') )
                 and start_dt <= to_date('${batch_date}', 'yyyymmdd')
                 and end_dt > to_date('${month_start}', 'yyyymmdd'))
               group by loanno) t3
    on t1.loan_no||t1.dd_no = t3.loanno
  left join ${idl_schema}.tmp_dmm_retl_loan_avg_bal_info_01 t4
    on t1.cmisloan_no=t4.serialno
  left join ${idl_schema}.tmp_dmm_retl_loan_avg_bal_info_02 t5
    on t1.cmisloan_no=t5.serialno
where t1.start_dt <= to_date('${batch_date}', 'yyyymmdd')
   and t1.end_dt > to_date('${batch_date}', 'yyyymmdd')
   and decode(trim(t1.auto_reversal_flag),null,'-',t1.auto_reversal_flag) <> 'Y'   --剔除自动冲正的数据
   and t1.appr_flag <> 'N'
   and t1.acct_open_date <=to_date('${batch_date}', 'yyyymmdd')
   and t1.prod_type='201020100042'  --致景科技
;
commit;


-- 2.2 exchage ex table and target table
alter table ${idl_schema}.dmm_retl_loan_avg_bal_info exchange partition p_${batch_date} with table ${idl_schema}.dmm_retl_loan_avg_bal_info_ex;

-- 3.1 drop ex table
drop table ${idl_schema}.dmm_retl_loan_avg_bal_info_ex purge;
--drop table ${idl_schema}.tmp_dmm_retl_loan_avg_bal_info_01 purge;
--drop table ${idl_schema}.tmp_dmm_retl_loan_avg_bal_info_02 purge;

-- 3.2 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${idl_schema}',tabname => 'dmm_retl_loan_avg_bal_info', partname => 'p_${batch_date}', granularity => 'PARTITION', degree => 8, cascade => true);
