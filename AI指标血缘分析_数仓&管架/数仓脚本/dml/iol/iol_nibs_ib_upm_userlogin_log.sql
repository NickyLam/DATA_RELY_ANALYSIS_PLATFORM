/*
Purpose:    偏源模型层-增量流水脚本，清空目标表当天分区，把当天数据与目标表进行分区交换。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_nibs_ib_upm_userlogin_log
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
drop table ${iol_schema}.nibs_ib_upm_userlogin_log_ex purge;
alter table ${iol_schema}.nibs_ib_upm_userlogin_log add partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

-- 2.2 truncate target table batch_date partition
whenever sqlerror exit sql.sqlcode;
alter table ${iol_schema}.nibs_ib_upm_userlogin_log truncate partition p_${batch_date};

-- 2.3 insert data to ex table
create table ${iol_schema}.nibs_ib_upm_userlogin_log_ex nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.nibs_ib_upm_userlogin_log where 0=1;

insert /*+ append */ into ${iol_schema}.nibs_ib_upm_userlogin_log_ex(
    causefailure -- 失败原因
    ,note1 -- 备注1
    ,note2 -- 备注2
    ,note3 -- 备注3
    ,note4 -- 备注4
    ,note5 -- 备注5
    ,loginstate -- 登录状态 : 0失败 1成功
    ,regtype -- 登记类型 : 登记类型：0登出 1登入
    ,regtime -- 登记时间-hhmmss
    ,datereg -- 登记日期-yyyymmdd
    ,deviceoid -- 设备oid
    ,hostname -- 主机名
    ,loginip -- 登录ip
    ,sessionid -- sessionid
    ,outflag -- 1-本人登出，2-强制登出
    ,username -- 用户名称
    ,usernum -- 用户编号
    ,appnum -- 渠道编号
    ,branchnum -- 机构号
    ,etl_dt -- ETL处理日期
    ,etl_timestamp -- ETL处理时间戳
)
select
    causefailure -- 失败原因
    ,note1 -- 备注1
    ,note2 -- 备注2
    ,note3 -- 备注3
    ,note4 -- 备注4
    ,note5 -- 备注5
    ,loginstate -- 登录状态 : 0失败 1成功
    ,regtype -- 登记类型 : 登记类型：0登出 1登入
    ,regtime -- 登记时间-hhmmss
    ,datereg -- 登记日期-yyyymmdd
    ,deviceoid -- 设备oid
    ,hostname -- 主机名
    ,loginip -- 登录ip
    ,sessionid -- sessionid
    ,outflag -- 1-本人登出，2-强制登出
    ,username -- 用户名称
    ,usernum -- 用户编号
    ,appnum -- 渠道编号
    ,branchnum -- 机构号
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from ${itl_schema}.nibs_ib_upm_userlogin_log
where etl_dt = to_date('${batch_date}', 'yyyymmdd')
;

-- 2.4 exchage ex table and target table
alter table ${iol_schema}.nibs_ib_upm_userlogin_log exchange partition p_${batch_date} with table ${iol_schema}.nibs_ib_upm_userlogin_log_ex;

-- 3.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.nibs_ib_upm_userlogin_log to ${iml_schema};

-- 3.2 drop ex table
drop table ${iol_schema}.nibs_ib_upm_userlogin_log_ex purge;

-- 4 gater table status
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'nibs_ib_upm_userlogin_log',partname => 'p_${batch_date}', granularity => 'PARTITION', degree => 8, cascade => true);