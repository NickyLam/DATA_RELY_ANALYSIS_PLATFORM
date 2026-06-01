/*
Purpose:    偏源模型层-全量流水脚本，清空目标表，把当天数据与目标表进行分区交换。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_ibms_tcb_bond_eval
CreateDate: 20180515
Logs:
    zjj 2018-05-15 新建脚本
*/

set timing on

-- 1 alter parallel
alter session force parallel query parallel 8;
alter session force parallel dml parallel 8;
-- alter session force parallel ddl parallel 8;

-- 2.1 create table for exchage and add partition
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.ibms_tcb_bond_eval_ex purge;
alter table ${iol_schema}.ibms_tcb_bond_eval add partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

-- 2.2 truncate target table
whenever sqlerror exit sql.sqlcode;
truncate table ${iol_schema}.ibms_tcb_bond_eval;

-- 2.3 insert data to ex table
create table ${iol_schema}.ibms_tcb_bond_eval_ex nologging
compress
as
select * from ${iol_schema}.ibms_tcb_bond_eval where 0=1;

insert /*+ append */ into ${iol_schema}.ibms_tcb_bond_eval_ex(
    i_code -- 金融工具代码
    ,a_type -- 资产类型
    ,m_type -- 市场类型
    ,beg_date -- 开始日期
    ,end_date -- 结束日期
    ,netprice -- 净价金额
    ,ai -- 应计利息
    ,yield -- 估价收益率
    ,term -- 待偿期
    ,modified_d -- 估价修正久期
    ,convexity -- 估价凸性
    ,dvbp -- 估价基点价值
    ,rd_modified -- 估价利差久期
    ,rd_convexity -- 估价利差凸性
    ,r_modified -- 估价利率久期
    ,r_convexity -- 估价利率凸性
    ,fullprice -- 估值类型
    ,is_onedate -- 来源
    ,imp_date -- 导入日期
    ,pipe_id -- 管道编号
    ,rd_yield -- 点差收益率
    ,etl_dt -- ETL处理日期
    ,etl_timestamp -- ETL处理时间戳
)
select
    i_code -- 金融工具代码
    ,a_type -- 资产类型
    ,m_type -- 市场类型
    ,beg_date -- 开始日期
    ,end_date -- 结束日期
    ,netprice -- 净价金额
    ,ai -- 应计利息
    ,yield -- 估价收益率
    ,term -- 待偿期
    ,modified_d -- 估价修正久期
    ,convexity -- 估价凸性
    ,dvbp -- 估价基点价值
    ,rd_modified -- 估价利差久期
    ,rd_convexity -- 估价利差凸性
    ,r_modified -- 估价利率久期
    ,r_convexity -- 估价利率凸性
    ,fullprice -- 估值类型
    ,is_onedate -- 来源
    ,imp_date -- 导入日期
    ,pipe_id -- 管道编号
    ,rd_yield -- 点差收益率
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from ${itl_schema}.ibms_tcb_bond_eval
where etl_dt = to_date('${batch_date}', 'yyyymmdd')
;

-- 2.4 exchage ex table and target table
alter table ${iol_schema}.ibms_tcb_bond_eval exchange partition p_${batch_date} with table ${iol_schema}.ibms_tcb_bond_eval_ex;

-- 3.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.ibms_tcb_bond_eval to ${iml_schema};

-- 3.2 drop ex table
drop table ${iol_schema}.ibms_tcb_bond_eval_ex purge;

-- 4 gater table status
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'ibms_tcb_bond_eval',partname => 'p_${batch_date}', granularity => 'PARTITION', degree => 8, cascade => true);