/*
Purpose:    偏源模型层-增量流水脚本，清空目标表当天分区，把当天数据与目标表进行分区交换。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_icms_customer_memo
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
drop table ${iol_schema}.icms_customer_memo_ex purge;
alter table ${iol_schema}.icms_customer_memo add partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

-- 2.2 truncate target table batch_date partition
whenever sqlerror exit sql.sqlcode;
alter table ${iol_schema}.icms_customer_memo truncate partition p_${batch_date};

-- 2.3 insert data to ex table
create table ${iol_schema}.icms_customer_memo_ex nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.icms_customer_memo where 0=1;

insert /*+ append */ into ${iol_schema}.icms_customer_memo_ex(
    serialno -- 流水号
    ,customerid -- 客户编号
    ,migtflag -- 
    ,inputorgid -- 登记机构
    ,eventdescribe -- 事件描述及原因
    ,degree -- 程度
    ,eventname -- 事件名称
    ,eventtype -- 事件类型
    ,influence -- 正负面影响
    ,remark -- 备注
    ,updatedate -- 更新日期
    ,updateuserid -- 更新人
    ,occurdate -- 发生日期
    ,inputdate -- 登记日期
    ,updateorgid -- 更新机构
    ,corporgid -- 法人机构编号
    ,influencelevel -- 正负面程度
    ,signface -- 正负面
    ,inputuserid -- 登记人
    ,etl_dt -- ETL处理日期
    ,etl_timestamp -- ETL处理时间戳
)
select
    serialno -- 流水号
    ,customerid -- 客户编号
    ,migtflag -- 
    ,inputorgid -- 登记机构
    ,eventdescribe -- 事件描述及原因
    ,degree -- 程度
    ,eventname -- 事件名称
    ,eventtype -- 事件类型
    ,influence -- 正负面影响
    ,remark -- 备注
    ,updatedate -- 更新日期
    ,updateuserid -- 更新人
    ,occurdate -- 发生日期
    ,inputdate -- 登记日期
    ,updateorgid -- 更新机构
    ,corporgid -- 法人机构编号
    ,influencelevel -- 正负面程度
    ,signface -- 正负面
    ,inputuserid -- 登记人
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from ${itl_schema}.icms_customer_memo
where etl_dt = to_date('${batch_date}', 'yyyymmdd')
;

-- 2.4 exchage ex table and target table
alter table ${iol_schema}.icms_customer_memo exchange partition p_${batch_date} with table ${iol_schema}.icms_customer_memo_ex;

-- 3.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.icms_customer_memo to ${iml_schema};

-- 3.2 drop ex table
drop table ${iol_schema}.icms_customer_memo_ex purge;

-- 4 gater table status
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'icms_customer_memo',partname => 'p_${batch_date}', granularity => 'PARTITION', degree => 8, cascade => true);