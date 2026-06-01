/*
Purpose:    偏源模型层-全量流水脚本，清空目标表，把当天数据与目标表进行分区交换。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_dsvp_seal_accmanaglog
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
drop table ${iol_schema}.dsvp_seal_accmanaglog_ex purge;
alter table ${iol_schema}.dsvp_seal_accmanaglog add partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

-- 2.2 truncate target table
whenever sqlerror exit sql.sqlcode;
truncate table ${iol_schema}.dsvp_seal_accmanaglog;

-- 2.3 insert data to ex table
create table ${iol_schema}.dsvp_seal_accmanaglog_ex nologging
compress
as
select * from ${iol_schema}.dsvp_seal_accmanaglog where 0=1;

insert /*+ append */ into ${iol_schema}.dsvp_seal_accmanaglog_ex(
    dbserno -- 序列号
    ,workdate -- 工作日期
    ,branchno -- 机构编号
    ,siteid -- 节点号
    ,accountno -- 账号
    ,opertype -- 操作类型
    ,oldprintno -- 旧印鉴卡号
    ,newprintno -- 新印鉴卡号
    ,createdate -- 建模日期
    ,usedate -- 启用日期
    ,operatorname -- 操作员工中文名称
    ,accountproperty -- 账户性质
    ,ownbranchno -- 柜员所属机构编号
    ,ownbranchname -- 机构中文全称
    ,belongflag -- 主从标志（0：非共用，1：主账户，2:从账户）
    ,quality -- 通兑标志（1：通存通兑，2：不通兑）
    ,monittype -- 监控标志
    ,rightoper -- 授权员工编号
    ,rightopername -- 授权员工中文名称
    ,opendate -- 开户日期
    ,destroydate -- 销户日期
    ,drawoutdate -- 抽卡日期
    ,describes -- 备注
    ,accountname -- 账户名
    ,accounttype -- 账户类型
    ,operator -- 员工编号
    ,deleteflag -- 删除标志
    ,opertypesum -- 操作类型统计
    ,systemtime -- 系统时间
    ,etl_dt -- ETL处理日期
    ,etl_timestamp -- ETL处理时间戳
)
select
    dbserno -- 序列号
    ,workdate -- 工作日期
    ,branchno -- 机构编号
    ,siteid -- 节点号
    ,accountno -- 账号
    ,opertype -- 操作类型
    ,oldprintno -- 旧印鉴卡号
    ,newprintno -- 新印鉴卡号
    ,createdate -- 建模日期
    ,usedate -- 启用日期
    ,operatorname -- 操作员工中文名称
    ,accountproperty -- 账户性质
    ,ownbranchno -- 柜员所属机构编号
    ,ownbranchname -- 机构中文全称
    ,belongflag -- 主从标志（0：非共用，1：主账户，2:从账户）
    ,quality -- 通兑标志（1：通存通兑，2：不通兑）
    ,monittype -- 监控标志
    ,rightoper -- 授权员工编号
    ,rightopername -- 授权员工中文名称
    ,opendate -- 开户日期
    ,destroydate -- 销户日期
    ,drawoutdate -- 抽卡日期
    ,describes -- 备注
    ,accountname -- 账户名
    ,accounttype -- 账户类型
    ,operator -- 员工编号
    ,deleteflag -- 删除标志
    ,opertypesum -- 操作类型统计
    ,systemtime -- 系统时间
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from ${itl_schema}.dsvp_seal_accmanaglog
where etl_dt = to_date('${batch_date}', 'yyyymmdd')
;

-- 2.4 exchage ex table and target table
alter table ${iol_schema}.dsvp_seal_accmanaglog exchange partition p_${batch_date} with table ${iol_schema}.dsvp_seal_accmanaglog_ex;

-- 3.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.dsvp_seal_accmanaglog to ${iml_schema};

-- 3.2 drop ex table
drop table ${iol_schema}.dsvp_seal_accmanaglog_ex purge;

-- 4 gater table status
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'dsvp_seal_accmanaglog',partname => 'p_${batch_date}', granularity => 'PARTITION', degree => 8, cascade => true);