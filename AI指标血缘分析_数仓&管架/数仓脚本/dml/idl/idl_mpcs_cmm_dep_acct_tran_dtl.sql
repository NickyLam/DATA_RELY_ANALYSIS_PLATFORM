/*
Purpose:    应用集市层-建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd idl_mpcs_cmm_dep_acct_tran_dtl
CreateDate: 20180515
FileType:   DML
Logs:
    zjj 2018-05-15 新建表本
*/

set timing on

-- 1 alter parallel
alter session force parallel query parallel 8;
alter session force parallel dml parallel 8;
-- alter session force parallel ddl parallel 8;


-- 2.1 drop timeout partition and add partition
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none;
alter table ${idl_schema}.mpcs_cmm_dep_acct_tran_dtl drop partition p_${batch_date};

-- 2.2 add today partition
whenever sqlerror exit sql.sqlcode;
alter table ${idl_schema}.mpcs_cmm_dep_acct_tran_dtl add partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

-- 2.3 insert data target table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ into ${idl_schema}.mpcs_cmm_dep_acct_tran_dtl partition for (to_date('${batch_date}','yyyymmdd')) (
    etl_dt  -- 数据日期
    ,tran_flow_num  -- 交易流水号
    ,cust_acct_id  -- 客户账户编号
    ,tran_dt  -- 交易日期
    ,debit_crdt_dir_cd  -- 借贷方向代码
    ,type1  -- 0：无法区分类型
    ,tran_amt  -- 交易金额
    ,tran_bal  -- 交易余额
    ,operate  -- 代表新增
    ,tran_org_id  -- 交易机构编号
    ,tran_teller_id  -- 交易柜员编号
    ,job_cd  -- 任务代码
    ,acct_bill_flow_num --账单流水号
    ,etl_timestamp  -- 时间戳
)
select
    to_date('${batch_date}','yyyymmdd')  -- 数据日期
    ,replace(replace(t.tran_flow_num||t.acct_bill_flow_num,chr(13),''),chr(10),'') as tran_flow_num   -- 交易流水号
    ,replace(replace(t.cust_acct_id,chr(13),''),chr(10),'') as cust_acct_id   -- 客户账户编号
    ,replace(replace(t.tran_dt,chr(13),''),chr(10),'') as tran_dt   -- 交易日期
    ,replace(replace(t.debit_crdt_dir_cd,chr(13),''),chr(10),'') as debit_crdt_dir_cd   -- 借贷方向代码
    ,'0'  -- 0：无法区分类型
    ,t.tran_amt  -- 交易金额
    ,t.tran_bal  -- 交易余额
    ,'1'  -- 代表新增
    ,replace(replace(t.tran_org_id,chr(13),''),chr(10),'') as tran_org_id   -- 交易机构编号
    ,replace(replace(t.tran_teller_id,chr(13),''),chr(10),'') as tran_teller_id   -- 交易柜员编号
    ,replace(replace(t.job_cd,chr(13),''),chr(10),'') as job_cd  -- 任务代码
    ,replace(replace(t.acct_bill_flow_num,chr(13),''),chr(10),'') as acct_bill_flow_num  -- 账单流水号
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6')  -- 时间戳
 from ${icl_schema}.cmm_dep_acct_tran_dtl t --存款账户交易明细
where NOT EXISTS(SELECT 1 FROM ${icl_schema}.cmm_dep_acct_tran_dtl TT --存款账户交易明细
                   WHERE t.tran_amt = 0
                     AND trim(t.debit_crdt_dir_cd) IS NULL
                     AND t.lp_id = tt.lp_id
                     AND t.tran_flow_num = tt.tran_flow_num
                     AND t.tran_dt = tt.tran_dt
                     AND t.acct_bill_flow_num = tt.acct_bill_flow_num
                     AND tt.etl_dt=to_date('${batch_date}','yyyymmdd')) 
   AND EXISTS (SELECT 1 FROM ${icl_schema}.cmm_dep_cust_acct_info T1 --存款主账户信息
                 WHERE t.cust_acct_id = t1.cust_acct_id
                   AND t1.etl_dt=to_date('${batch_date}','yyyymmdd')
                   AND EXISTS (SELECT 1 FROM ${icl_schema}.cmm_intnal_org_info T2 --内部机构信息表
                                WHERE t1.open_acct_org_id = t2.org_id
                                  AND t2.org_name like '%惠州%'
                                  AND t2.etl_dt=to_date('${batch_date}','yyyymmdd')))
   AND T.ETL_DT=to_date('${batch_date}','yyyymmdd')
   AND T.ENTRY_FLG='1';
commit;

-- 3 table grant
-- whenever sqlerror exit sql.sqlcode;
-- grant select on ${idl_schema}.mpcs_cmm_dep_acct_tran_dtl to ${iol_schema};

-- 4 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${idl_schema}',tabname => 'mpcs_cmm_dep_acct_tran_dtl',partname => 'p_${batch_date}', granularity => 'PARTITION', degree => 8, cascade => true);