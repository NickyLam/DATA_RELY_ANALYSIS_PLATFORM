/*
Purpose:    偏源模型层-增量流水脚本，清空目标表当天分区，把当天数据与目标表进行分区交换。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_icms_cl_credit_divide_serial
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
drop table ${iol_schema}.icms_cl_credit_divide_serial_ex purge;
alter table ${iol_schema}.icms_cl_credit_divide_serial add partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

-- 2.2 truncate target table batch_date partition
whenever sqlerror exit sql.sqlcode;
alter table ${iol_schema}.icms_cl_credit_divide_serial truncate partition p_${batch_date};

-- 2.3 insert data to ex table
create table ${iol_schema}.icms_cl_credit_divide_serial_ex nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.icms_cl_credit_divide_serial where 0=1;

insert /*+ append */ into ${iol_schema}.icms_cl_credit_divide_serial_ex(
    creditno -- 额度系统业务编号
    ,inputuserid -- 登记人
    ,dividecurrency -- 切分币种
    ,exposureamount -- 切分敞口金额
    ,occupyexposureamount -- 占用敞口金额
    ,availableexposuresum -- 可用敞口金额
    ,availablenominalsum -- 可用名义金额
    ,inputdate -- 登记日期
    ,updateuserid -- 更新人
    ,updateorgid -- 更新机构
    ,dividetype -- 切分类型:机构/产品/客户
    ,parentdivideno -- 上层控制编号
    ,divideno -- 控制编号
    ,nominalamount -- 切分名义金额
    ,occupynominalamount -- 占用名义金额
    ,objectno -- 切分对象的编号
    ,objectname -- 切分对象的名称
    ,inputorgid -- 登记机构
    ,updatedate -- 更新日期
    ,serialno -- 流水号
    ,etl_dt -- ETL处理日期
    ,etl_timestamp -- ETL处理时间戳
)
select
    creditno -- 额度系统业务编号
    ,inputuserid -- 登记人
    ,dividecurrency -- 切分币种
    ,exposureamount -- 切分敞口金额
    ,occupyexposureamount -- 占用敞口金额
    ,availableexposuresum -- 可用敞口金额
    ,availablenominalsum -- 可用名义金额
    ,inputdate -- 登记日期
    ,updateuserid -- 更新人
    ,updateorgid -- 更新机构
    ,dividetype -- 切分类型:机构/产品/客户
    ,parentdivideno -- 上层控制编号
    ,divideno -- 控制编号
    ,nominalamount -- 切分名义金额
    ,occupynominalamount -- 占用名义金额
    ,objectno -- 切分对象的编号
    ,objectname -- 切分对象的名称
    ,inputorgid -- 登记机构
    ,updatedate -- 更新日期
    ,serialno -- 流水号
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from ${itl_schema}.icms_cl_credit_divide_serial
where etl_dt = to_date('${batch_date}', 'yyyymmdd')
;

-- 2.4 exchage ex table and target table
alter table ${iol_schema}.icms_cl_credit_divide_serial exchange partition p_${batch_date} with table ${iol_schema}.icms_cl_credit_divide_serial_ex;

-- 3.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.icms_cl_credit_divide_serial to ${iml_schema};

-- 3.2 drop ex table
drop table ${iol_schema}.icms_cl_credit_divide_serial_ex purge;

-- 4 gater table status
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'icms_cl_credit_divide_serial',partname => 'p_${batch_date}', granularity => 'PARTITION', degree => 8, cascade => true);