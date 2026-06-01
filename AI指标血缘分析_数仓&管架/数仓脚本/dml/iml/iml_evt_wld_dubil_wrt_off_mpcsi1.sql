/*
Purpose:    整全模型层-增量流水脚本，清空目标表当天分区数据，把当天数据与目标表进行分区交换。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iml_evt_wld_dubil_wrt_off_mpcsi1
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
drop table ${iml_schema}.evt_wld_dubil_wrt_off_mpcsi1_tm purge;
alter table ${iml_schema}.evt_wld_dubil_wrt_off add partition p_mpcsi1 values ('mpcsi1')(
        subpartition p_mpcsi1_${batch_date} values (to_date('${batch_date}','yyyymmdd'))
    )
;
alter table ${iml_schema}.evt_wld_dubil_wrt_off modify partition p_mpcsi1
    add subpartition p_mpcsi1_${batch_date} values (to_date('${batch_date}','yyyymmdd'))
;

whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.evt_wld_dubil_wrt_off_mpcsi1_tm
compress ${option_switch} for query high
as
select
    evt_id -- 事件编号
    ,lp_id -- 法人编号
    ,ser_num -- 序列号
    ,batch_doc_name -- 批量文件名称
    ,wrt_off_dt -- 核销日期
    ,cust_id -- 客户编号
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
-- mpcs_a0nds_loan_writeoff_list_suc-
insert into ${iml_schema}.evt_wld_dubil_wrt_off_mpcsi1_tm(
    evt_id -- 事件编号
    ,lp_id -- 法人编号
    ,ser_num -- 序列号
    ,batch_doc_name -- 批量文件名称
    ,wrt_off_dt -- 核销日期
    ,cust_id -- 客户编号
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
    '102009'||P1.WRITEOFF_DATE||P1.SEQNO -- 事件编号
    ,'9999' -- 法人编号
    ,P1.SEQNO -- 序列号
    ,P1.BATCHFILENAME -- 批量文件名称
    ,${iml_schema}.DATEFORMAT_MAX(P1.WRITEOFF_DATE) -- 核销日期
    ,NVL(p2.cbscustno,' ') -- 客户编号
    ,P1.NAME -- 客户名称
    ,P1.LOAN_INIT_PRIN -- 核销本金
    ,P1.LOAN_INTR_PENALTY -- 核销利息
    ,P1.BANK_PROPORTION -- 银行出资比例
    ,P1.BANK_NO -- 银行编号
    ,P1.BANK_GROUP_ID -- 银团编号
    ,P1.PRODUCT_CD -- 贷款产品编号
    ,P1.LOGICAL_CARD_NO -- 卡号
    ,P1.REF_NBR -- 交易参考号
    ,NVL(TRIM(P1.WRITEOFF_PROC_STATUS),'-') -- 核销状态代码
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,'mpcs_a0nds_loan_writeoff_list_suc' -- 源表名称
    ,'mpcsi1' -- 任务编码
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间戳
from ${iol_schema}.mpcs_a0nds_loan_writeoff_list_suc p1
    left join ${iol_schema}.mpcs_a0ntm_customer p2 on p1.cust_id=to_char(p2.cust_id) and   p2.START_DT<=TO_DATE('${batch_date}','YYYYMMDD') AND p2.END_DT>TO_DATE('${batch_date}','YYYYMMDD')
where p1.start_dt <= to_date('${batch_date}','yyyymmdd') and p1.end_dt > to_date('${batch_date}','yyyymmdd')
    AND ${iml_schema}.DATEFORMAT_MAX(P1.WRITEOFF_DATE)=${iml_schema}.DATEFORMAT_MAX('${batch_date}')
;
commit;



-- 3.2 truncate target table batch_date partition
alter table ${iml_schema}.evt_wld_dubil_wrt_off truncate subpartition p_mpcsi1_${batch_date} reuse storage;


-- 3.3 exchage tm table and target table
alter table ${iml_schema}.evt_wld_dubil_wrt_off exchange subpartition p_mpcsi1_${batch_date} with table ${iml_schema}.evt_wld_dubil_wrt_off_mpcsi1_tm;

-- 4.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iml_schema}.evt_wld_dubil_wrt_off to ${iml_schema};

-- 4.2 drop tm table
drop table ${iml_schema}.evt_wld_dubil_wrt_off_mpcsi1_tm purge;

-- 5 gater table status
exec dbms_stats.gather_table_stats(ownname => '${iml_schema}',tabname => 'evt_wld_dubil_wrt_off', partname => 'p_mpcsi1_${batch_date}', granularity => 'SUBPARTITION', degree => 8, cascade => true);