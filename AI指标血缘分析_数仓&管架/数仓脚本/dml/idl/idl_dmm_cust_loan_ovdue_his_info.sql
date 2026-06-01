/*
Purpose:    报表集市层-零售贷款日均余额信息表：包括所有的零售贷款日均余额。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd idl_dmm_cust_loan_ovdue_his_info
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
--alter table ${idl_schema}.dmm_cust_loan_ovdue_his_info drop partition p_${retain_day};
alter table ${idl_schema}.dmm_cust_loan_ovdue_his_dtl drop partition p_${batch_date};
alter table ${idl_schema}.dmm_cust_loan_ovdue_his_dtl add partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));
alter table ${idl_schema}.dmm_cust_loan_ovdue_his_info add partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

-- 1.2 create table for exchage and add partition
whenever sqlerror continue none;
drop table ${idl_schema}.dmm_cust_loan_ovdue_his_info_ex purge;

-- 2.1 insert into ex table
whenever sqlerror exit sql.sqlcode;
create table ${idl_schema}.dmm_cust_loan_ovdue_his_info_ex
nologging
compress ${option_switch} for query high
as select * from ${idl_schema}.dmm_cust_loan_ovdue_his_info where 0=1;

--第一组 处理客户贷款逾期明细到临时表
whenever sqlerror exit sql.sqlcode;
insert into ${idl_schema}.dmm_cust_loan_ovdue_his_dtl(
    etl_dt  -- 数据日期
    ,lp_id  -- 法人编号
    ,cust_id  --客户编号
	,acct_id  --账户编号
    ,dubil_num  --借据编号
    ,std_prod_id  --标准产品编号
    ,ovdue_dt  --逾期日期
    ,ovdue_days  --逾期天数
    ,job_cd  -- 任务代码
    ,etl_timestamp  -- 数据处理时间
)
select 
    to_date('${batch_date}', 'yyyymmdd')                              -- 数据日期
    ,'9999'                                                           -- 法人编号
    ,t1.client_no                                                     --客户编号
    ,t1.internal_key                                                  --账户编号
    ,t2.cmisloan_no                                                   --借据编号
    ,t2.prod_type                                                     --标准产品编号
    ,t1.start_dt                                                      --逾期日期
    ,greatest(t1.pri_due_days，t1.int_due_days)                       --逾期天数
    ,'ncbsf1'                                                         -- 任务代码 
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6')  -- etl处理时间戳
 from ${iol_schema}.ncbs_cl_acct_attach t1
 inner join ${iol_schema}.ncbs_cl_acct t2 
   on t1.internal_key=t2.internal_key
  and (t2.client_type ='100' and t2.prod_type like '201%'
    or t2.client_type ='200' and t2.prod_type like '20301%')
  and t2.start_dt <=to_date('${batch_date}','yyyymmdd') 
  and t2.end_dt >to_date('${batch_date}','yyyymmdd')
where (t1.pri_due_days +t1.int_due_days) >0
  and t1.start_dt <=to_date('${batch_date}','yyyymmdd') 
  and t1.start_dt >=to_date('${batch_date}','yyyymmdd') -179
  and t1.end_dt >to_date('${batch_date}','yyyymmdd') -179
;
commit;


--第二组 处理客户逾期指标到结果表
whenever sqlerror exit sql.sqlcode;
insert into ${idl_schema}.dmm_cust_loan_ovdue_his_info_ex(
    etl_dt  -- 数据日期
    ,lp_id  -- 法人编号
    ,cust_id  --客户编号
	,max_ovdue_day_t  --近30天内最大逾期天数
	,max_ovdue_day_n   --近90天内最大逾期天数
	,ovdue_month_cnt  --近180天内当月最大逾期天数>3天的月份
    ,job_cd  -- 任务代码
    ,etl_timestamp  -- 数据处理时间
)
select 
    to_date('${batch_date}', 'yyyymmdd')                          -- 数据日期
    ,'9999'                                                          -- 法人编号
    ,t1.client_no                                                    -- 客户编号
	,nvl(t2.max_ovdue_day_t,0)                                      -- 近30天内最大逾期天数
	,nvl(t3.max_ovdue_day_n,0)                                      -- 近90天内最大逾期天数
	,nvl(t4.ovdue_month_cnt,0)                                      -- 近180天内当月最大逾期天数>3天的月份
    ,'ncbsf1'                                                         -- 任务代码 
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6')  -- etl处理时间戳
 from (select distinct client_no 
         from ${iol_schema}.ncbs_cl_acct
        where start_dt <=to_date('${batch_date}','yyyymmdd') 
          and end_dt >to_date('${batch_date}','yyyymmdd')) t1
 left join  (select cust_id,max(ovdue_days) as max_ovdue_day_t
               from ${idl_schema}.dmm_cust_loan_ovdue_his_dtl 
			  where ovdue_dt <=to_date('${batch_date}','yyyymmdd') 
			    and ovdue_dt >=to_date('${batch_date}','yyyymmdd') -29
			    and etl_dt=to_date('${batch_date}','yyyymmdd')
              group by cust_id) t2
on t1.client_no=t2.cust_id
 left join (select cust_id,max(ovdue_days) as max_ovdue_day_n
              from ${idl_schema}.dmm_cust_loan_ovdue_his_dtl 
			 where ovdue_dt <=to_date('${batch_date}','yyyymmdd') 
			   and ovdue_dt >=to_date('${batch_date}','yyyymmdd') -89
			   and etl_dt=to_date('${batch_date}','yyyymmdd')
             group by cust_id) t3
on t1.client_no=t3.cust_id
 left join (select cust_id,count(distinct to_char(ovdue_dt,'yyyymm')) as ovdue_month_cnt
              from ${idl_schema}.dmm_cust_loan_ovdue_his_dtl 
			 where ovdue_days >3 
			   and ovdue_dt <=to_date('${batch_date}','yyyymmdd') 
			   and ovdue_dt >=to_date('${batch_date}','yyyymmdd') -189
			   and etl_dt=to_date('${batch_date}','yyyymmdd')
             group by cust_id ) t4
on t1.client_no=t4.cust_id
where t1.client_no in (select cust_id 
                         from ${idl_schema}.dmm_cust_loan_ovdue_his_dtl
                        where etl_dt=to_date('${batch_date}','yyyymmdd'))	
;
commit;

-- 2.2 exchage ex table and target table
alter table ${idl_schema}.dmm_cust_loan_ovdue_his_info exchange partition p_${batch_date} with table ${idl_schema}.dmm_cust_loan_ovdue_his_info_ex;

-- 3.1 drop ex table
drop table ${idl_schema}.dmm_cust_loan_ovdue_his_info_ex purge;
--drop table ${idl_schema}.tmp_dmm_cust_loan_ovdue_his_info_01 purge;
--drop table ${idl_schema}.tmp_dmm_cust_loan_ovdue_his_info_02 purge;

-- 3.2 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${idl_schema}',tabname => 'dmm_cust_loan_ovdue_his_info', partname => 'p_${batch_date}', granularity => 'PARTITION', degree => 8, cascade => true);
