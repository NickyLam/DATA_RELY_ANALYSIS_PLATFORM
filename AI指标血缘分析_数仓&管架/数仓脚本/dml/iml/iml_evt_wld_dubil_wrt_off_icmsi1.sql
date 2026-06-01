/*
Purpose:    整全模型层-增量流水脚本，清空目标表当天分区数据，把当天数据与目标表进行分区交换。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iml_evt_wld_dubil_wrt_off_icmsi1
CreateDate: 20180515
Logs:
    zjj 2018-05-15 新建表本
*/

set timing on

-- 1 alter parallel
alter session force parallel query parallel 4;
alter session force parallel dml parallel 4;
-- alter session force parallel ddl parallel 1;

-- 2.1 create table for exchage and add partition
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iml_schema}.evt_wld_dubil_wrt_off_icmsi1_tm purge;
alter table ${iml_schema}.evt_wld_dubil_wrt_off add partition p_icmsi1 values ('icmsi1')(
        subpartition p_icmsi1_${batch_date} values (to_date('${batch_date}','yyyymmdd'))
    )
;
alter table ${iml_schema}.evt_wld_dubil_wrt_off modify partition p_icmsi1
    add subpartition p_icmsi1_${batch_date} values (to_date('${batch_date}','yyyymmdd'))
;

whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.evt_wld_dubil_wrt_off_icmsi1_tm
compress ${option_switch} for query high
as
select
    evt_id -- 事件编号
    ,lp_id -- 法人编号
    ,ser_num -- 序列号
    ,batch_doc_name -- 批量文件名称
    ,wrt_off_dt -- 核销日期
    ,cust_id -- 交易客户编号
    ,cust_name -- 客户名称
    ,wrt_off_pric -- 核销本金
    ,wrt_off_int -- 核销利息
    ,bank_contri_ratio -- 银行出资比例
    ,bank_id -- 银行编号
    ,syn_id -- 银团编号
    ,loan_prod_id -- 贷款产品编号
    ,card_no -- 卡号
    ,tran_ref_no -- 交易参考号
    ,wrt_off_status_cd -- 核销状态代码
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
from ${iml_schema}.evt_wld_dubil_wrt_off
where 0=1;


-- it is no need to check when this segment SQL was return faied
whenever sqlerror exit sql.sqlcode;
-- 3.1 insert data to tm table
-- icms_ds_loan_writeoff_list_success-1
insert into ${iml_schema}.evt_wld_dubil_wrt_off_icmsi1_tm(
    evt_id -- 事件编号
    ,lp_id -- 法人编号
    ,ser_num -- 序列号
    ,batch_doc_name -- 批量文件名称
    ,wrt_off_dt -- 核销日期
    ,cust_id -- 交易客户编号
    ,cust_name -- 客户名称
    ,wrt_off_pric -- 核销本金
    ,wrt_off_int -- 核销利息
    ,bank_contri_ratio -- 银行出资比例
    ,bank_id -- 银行编号
    ,syn_id -- 银团编号
    ,loan_prod_id -- 贷款产品编号
    ,card_no -- 卡号
    ,tran_ref_no -- 交易参考号
    ,wrt_off_status_cd -- 核销状态代码
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
)
select
    '102009'||P1.WRITEOFFDATE||P1.REFNBR||P1.LOGICALCARDNO -- 事件编号
    ,'9999' -- 法人编号
    ,' ' -- 序列号
    ,' ' -- 批量文件名称
    ,${iml_schema}.DATEFORMAT_MAX2(P1.WRITEOFFDATE) -- 核销日期
    ,NVL(trim(P2.CUSTOMERID),to_char(P1.CUSTID)) -- 交易客户编号
    ,P1.NAME -- 客户名称
    ,P1.LOANINITPRIN -- 核销本金
    ,P1.LOANINTRPENALTY -- 核销利息
    ,P1.BANKPROPORTION -- 银行出资比例
    ,P1.BANKNO -- 银行编号
    ,P1.BANKGROUPID -- 银团编号
    ,P1.PRODUCTCD -- 贷款产品编号
    ,P1.LOGICALCARDNO -- 卡号
    ,P1.REFNBR -- 交易参考号
    ,NVL(TRIM(P1.WRITEOFFPROCSTATUS),'-') -- 核销状态代码
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,'icms_ds_loan_writeoff_list_success' -- 源表名称
    ,'icmsi1' -- 任务编码
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间戳
from ${iol_schema}.icms_ds_loan_writeoff_list_success p1
  INNER JOIN ${iol_schema}.icms_customer_info_wld P2
  ON P1.CUSTID=P2.WLDCUSTID  
  AND P2.START_DT<=TO_DATE('${batch_date}','YYYYMMDD') AND P2.END_DT>TO_DATE('${batch_date}','YYYYMMDD')
WHERE  1 = 1 
      AND P1.BANKGROUPID in ('GHB06','GHB07')
      AND p1.writeoffdate = to_char(to_date('${batch_date}','yyyymmdd'),'yyyy-mm-dd')
;
commit;



-- 3.2 truncate target table batch_date partition
alter table ${iml_schema}.evt_wld_dubil_wrt_off truncate subpartition p_icmsi1_${batch_date} reuse storage;


-- 3.3 exchage tm table and target table
alter table ${iml_schema}.evt_wld_dubil_wrt_off exchange subpartition p_icmsi1_${batch_date} with table ${iml_schema}.evt_wld_dubil_wrt_off_icmsi1_tm;

-- 4.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iml_schema}.evt_wld_dubil_wrt_off to ${iml_schema};

-- 4.2 drop tm table
drop table ${iml_schema}.evt_wld_dubil_wrt_off_icmsi1_tm purge;

-- 5 gater table status
exec dbms_stats.gather_table_stats(ownname => '${iml_schema}',tabname => 'evt_wld_dubil_wrt_off', partname => 'p_icmsi1_${batch_date}', ESTIMATE_PERCENT=>10, method_opt=>'for all columns size 1',no_invalidate=>false, force=>true, granularity => 'SUBPARTITION', degree => 8, cascade => true);