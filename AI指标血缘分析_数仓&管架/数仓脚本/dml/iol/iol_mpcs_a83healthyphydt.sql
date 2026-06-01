/*
Purpose:    偏源模型层-全量流水脚本，清空目标表，把当天数据与目标表进行分区交换。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_mpcs_a83healthyphydt
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
drop table ${iol_schema}.mpcs_a83healthyphydt_ex purge;
alter table ${iol_schema}.mpcs_a83healthyphydt add partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

-- 2.2 truncate target table
whenever sqlerror exit sql.sqlcode;
truncate table ${iol_schema}.mpcs_a83healthyphydt;

-- 2.3 insert data to ex table
create table ${iol_schema}.mpcs_a83healthyphydt_ex nologging
compress
as
select * from ${iol_schema}.mpcs_a83healthyphydt where 0=1;

insert /*+ append */ into ${iol_schema}.mpcs_a83healthyphydt_ex(
    transeq -- 批次号
    ,dealdt -- 操作日期
    ,no -- 批次序号
    ,yshacct -- 映山红卡号
    ,yshclassname -- 映山红卡等级中文说明
    ,yshclass -- 映山红卡等级 0-映山红卡 1-映山红钻石卡
    ,ltkacct -- 龙腾卡卡号
    ,ltkclass -- 龙腾卡等级 0-白金 1-钻石
    ,custname -- 用户姓名
    ,idtfno -- 身份证号
    ,phone -- 联系电话
    ,content -- 权益内容
    ,contentoff -- 权益供应商
    ,orderdt -- 预约日期
    ,usedt -- 使用日期
    ,offername -- 服务机构
    ,remark -- 备注
    ,brnnbr -- 申请机构
    ,tlrnbr -- 申请柜员
    ,remark1 -- 0-下单成 1-已取消 2-已使用
    ,remark2 -- 
    ,remark3 -- 
    ,remark4 -- 
    ,etl_dt -- ETL处理日期
    ,etl_timestamp -- ETL处理时间戳
)
select
    transeq -- 批次号
    ,dealdt -- 操作日期
    ,no -- 批次序号
    ,yshacct -- 映山红卡号
    ,yshclassname -- 映山红卡等级中文说明
    ,yshclass -- 映山红卡等级 0-映山红卡 1-映山红钻石卡
    ,ltkacct -- 龙腾卡卡号
    ,ltkclass -- 龙腾卡等级 0-白金 1-钻石
    ,custname -- 用户姓名
    ,idtfno -- 身份证号
    ,phone -- 联系电话
    ,content -- 权益内容
    ,contentoff -- 权益供应商
    ,orderdt -- 预约日期
    ,usedt -- 使用日期
    ,offername -- 服务机构
    ,remark -- 备注
    ,brnnbr -- 申请机构
    ,tlrnbr -- 申请柜员
    ,remark1 -- 0-下单成 1-已取消 2-已使用
    ,remark2 -- 
    ,remark3 -- 
    ,remark4 -- 
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from ${itl_schema}.mpcs_a83healthyphydt
where etl_dt = to_date('${batch_date}', 'yyyymmdd')
;

-- 2.4 exchage ex table and target table
alter table ${iol_schema}.mpcs_a83healthyphydt exchange partition p_${batch_date} with table ${iol_schema}.mpcs_a83healthyphydt_ex;

-- 3.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.mpcs_a83healthyphydt to ${iml_schema};

-- 3.2 drop ex table
drop table ${iol_schema}.mpcs_a83healthyphydt_ex purge;

-- 4 gater table status
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'mpcs_a83healthyphydt',partname => 'p_${batch_date}', granularity => 'PARTITION', degree => 8, cascade => true);