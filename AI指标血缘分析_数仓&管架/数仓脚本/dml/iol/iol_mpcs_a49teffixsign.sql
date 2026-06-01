/*
Purpose:    偏源模型层-全量流水脚本，清空目标表，把当天数据与目标表进行分区交换。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_mpcs_a49teffixsign
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
drop table ${iol_schema}.mpcs_a49teffixsign_ex purge;
alter table ${iol_schema}.mpcs_a49teffixsign add partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

-- 2.2 truncate target table
whenever sqlerror exit sql.sqlcode;
truncate table ${iol_schema}.mpcs_a49teffixsign;

-- 2.3 insert data to ex table
create table ${iol_schema}.mpcs_a49teffixsign_ex nologging
compress
as
select * from ${iol_schema}.mpcs_a49teffixsign where 0=1;

insert /*+ append */ into ${iol_schema}.mpcs_a49teffixsign_ex(
    signdt -- 签约日期
    ,cntrsq -- 合同顺序号
    ,signtm -- 签约时间
    ,custtp -- 客户类型
    ,unitcd -- 组织机构代码
    ,citycd -- 城市代码
    ,cntrtp -- 合同(协议)类型
    ,busitp -- 业务种类
    ,cntrno -- 合同(协议)号
    ,iotype -- 来往标志
    ,recvbk -- 收款行号
    ,rebkna -- 收款行名
    ,recvac -- 收款账号
    ,recvna -- 收款户名
    ,pyerbk -- 付款行行号
    ,pybkna -- 付款行名
    ,pyerac -- 付款人账号
    ,pyerna -- 付款人名称
    ,cncldt -- 合同撤销日期
    ,userid -- 登记柜员
    ,brchno -- 登记部门
    ,ckbrus -- 复核柜员
    ,cntrst -- 协议状态
    ,modidt -- 维护日期
    ,moditm -- 维护时间
    ,modius -- 维护柜员
    ,modibr -- 维护部门
    ,clckus -- 维护授权柜员
    ,remark -- 附言
    ,etl_dt -- ETL处理日期
    ,etl_timestamp -- ETL处理时间戳
)
select
    signdt -- 签约日期
    ,cntrsq -- 合同顺序号
    ,signtm -- 签约时间
    ,custtp -- 客户类型
    ,unitcd -- 组织机构代码
    ,citycd -- 城市代码
    ,cntrtp -- 合同(协议)类型
    ,busitp -- 业务种类
    ,cntrno -- 合同(协议)号
    ,iotype -- 来往标志
    ,recvbk -- 收款行号
    ,rebkna -- 收款行名
    ,recvac -- 收款账号
    ,recvna -- 收款户名
    ,pyerbk -- 付款行行号
    ,pybkna -- 付款行名
    ,pyerac -- 付款人账号
    ,pyerna -- 付款人名称
    ,cncldt -- 合同撤销日期
    ,userid -- 登记柜员
    ,brchno -- 登记部门
    ,ckbrus -- 复核柜员
    ,cntrst -- 协议状态
    ,modidt -- 维护日期
    ,moditm -- 维护时间
    ,modius -- 维护柜员
    ,modibr -- 维护部门
    ,clckus -- 维护授权柜员
    ,remark -- 附言
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from ${itl_schema}.mpcs_a49teffixsign
where etl_dt = to_date('${batch_date}', 'yyyymmdd')
;

-- 2.4 exchage ex table and target table
alter table ${iol_schema}.mpcs_a49teffixsign exchange partition p_${batch_date} with table ${iol_schema}.mpcs_a49teffixsign_ex;

-- 3.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.mpcs_a49teffixsign to ${iml_schema};

-- 3.2 drop ex table
drop table ${iol_schema}.mpcs_a49teffixsign_ex purge;

-- 4 gater table status
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'mpcs_a49teffixsign',partname => 'p_${batch_date}', granularity => 'PARTITION', degree => 8, cascade => true);