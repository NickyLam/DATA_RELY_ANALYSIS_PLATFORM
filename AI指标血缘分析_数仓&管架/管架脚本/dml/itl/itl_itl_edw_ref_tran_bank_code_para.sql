/*
Purpose:    应用集市层-建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd itl_itl_edw_ref_tran_bank_code_para
CreateDate: 20180515
FileType:   DML
Logs:
    zjj 2018-05-15 新建表本
*/

set timing on

-- 1 alter parallel
alter session force parallel query parallel 4;
alter session force parallel dml parallel 4;
-- alter session force parallel ddl parallel 4;


-- 2.1 drop timeout partition and add partition
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none;
alter table ${itl_schema}.itl_edw_ref_tran_bank_code_para drop partition p_${retain_day};
alter table ${itl_schema}.itl_edw_ref_tran_bank_code_para drop partition p_${batch_date};

-- 2.2 add today partition
whenever sqlerror exit sql.sqlcode;
alter table ${itl_schema}.itl_edw_ref_tran_bank_code_para add  partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

-- 2.3 insert data target table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ into ${itl_schema}.itl_edw_ref_tran_bank_code_para partition for (to_date('${batch_date}','yyyymmdd')) (
    etl_dt  -- 数据日期
    ,tran_code  -- 交易码
    ,tran_name  -- 交易名称
    ,fin_tran_flg  -- 金融交易标志
    ,etl_timestamp  -- ETL处理时间戳
)
select
    to_date('${batch_date}','yyyymmdd') as etl_dt  -- 数据日期
    ,replace(replace(t1.tran_code,chr(13),''),chr(10),'')  -- 交易码
    ,replace(replace(t1.tran_name,chr(13),''),chr(10),'')  -- 交易名称
    ,replace(replace(t1.fin_tran_flg,chr(13),''),chr(10),'')  -- 金融交易标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp  -- ETL处理时间戳
from ${msl_schema}.msl_edw_ref_tran_bank_code_para t1    --交易银行交易码参数
where t1.create_dt <= to_date('${batch_date}','yyyymmdd') ;
commit;


-- 4 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${itl_schema}',tabname => 'itl_edw_ref_tran_bank_code_para',partname => 'p_${batch_date}', granularity => 'PARTITION', degree => 8, cascade => true);