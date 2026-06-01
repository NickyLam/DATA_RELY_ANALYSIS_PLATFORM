/*
Purpose:    偏源模型层-增量流水脚本，清空目标表当天分区，把当天数据与目标表进行分区交换。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_mpcs_a57tredeemlist
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
drop table ${iol_schema}.mpcs_a57tredeemlist_ex purge;
alter table ${iol_schema}.mpcs_a57tredeemlist add partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

-- 2.2 truncate target table batch_date partition
whenever sqlerror exit sql.sqlcode;
alter table ${iol_schema}.mpcs_a57tredeemlist truncate partition p_${batch_date};

-- 2.3 insert data to ex table
create table ${iol_schema}.mpcs_a57tredeemlist_ex nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.mpcs_a57tredeemlist where 0=1;

insert /*+ append */ into ${iol_schema}.mpcs_a57tredeemlist_ex(
    sysid -- 渠道标识
    ,srcseqno -- 请求流水
    ,acctno -- 结算账号
    ,fudcd -- 基金代码
    ,units -- 赎回份额，单位为0.01 份
    ,redeemtype -- 1 为普通赎回 0 为D+0 赎回（增值转出专用）
    ,reqtm -- 申请时间
    ,memo -- 附加信息
    ,dataid -- 数据ID
    ,hostseqno -- 主机流水
    ,hostdt -- 主机日期
    ,hostrspcd -- 主机响应码
    ,hostrspmsg -- 主机响应信息
    ,colflag -- 对账标志 0正常 1挂账成功 2挂账失败
    ,coltm -- 对账时间
    ,rspcd -- 响应码
    ,rspmsg -- 响应信息
    ,hangflag -- 挂账标志
    ,fudorderno -- 赎回订单号(基金公司生成)
    ,rsptm -- 响应时间
    ,etl_dt -- ETL处理日期
    ,etl_timestamp -- ETL处理时间戳
)
select
    sysid -- 渠道标识
    ,srcseqno -- 请求流水
    ,acctno -- 结算账号
    ,fudcd -- 基金代码
    ,units -- 赎回份额，单位为0.01 份
    ,redeemtype -- 1 为普通赎回 0 为D+0 赎回（增值转出专用）
    ,reqtm -- 申请时间
    ,memo -- 附加信息
    ,dataid -- 数据ID
    ,hostseqno -- 主机流水
    ,hostdt -- 主机日期
    ,hostrspcd -- 主机响应码
    ,hostrspmsg -- 主机响应信息
    ,colflag -- 对账标志 0正常 1挂账成功 2挂账失败
    ,coltm -- 对账时间
    ,rspcd -- 响应码
    ,rspmsg -- 响应信息
    ,hangflag -- 挂账标志
    ,fudorderno -- 赎回订单号(基金公司生成)
    ,rsptm -- 响应时间
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from ${itl_schema}.mpcs_a57tredeemlist
where etl_dt = to_date('${batch_date}', 'yyyymmdd')
;

-- 2.4 exchage ex table and target table
alter table ${iol_schema}.mpcs_a57tredeemlist exchange partition p_${batch_date} with table ${iol_schema}.mpcs_a57tredeemlist_ex;

-- 3.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.mpcs_a57tredeemlist to ${iml_schema};

-- 3.2 drop ex table
drop table ${iol_schema}.mpcs_a57tredeemlist_ex purge;

-- 4 gater table status
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'mpcs_a57tredeemlist',partname => 'p_${batch_date}', granularity => 'PARTITION', degree => 8, cascade => true);