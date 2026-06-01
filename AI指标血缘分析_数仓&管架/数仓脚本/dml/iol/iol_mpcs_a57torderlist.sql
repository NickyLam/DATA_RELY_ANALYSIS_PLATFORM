/*
Purpose:    偏源模型层-增量流水脚本，清空目标表当天分区，把当天数据与目标表进行分区交换。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_mpcs_a57torderlist
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
drop table ${iol_schema}.mpcs_a57torderlist_ex purge;
alter table ${iol_schema}.mpcs_a57torderlist add partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

-- 2.2 truncate target table batch_date partition
whenever sqlerror exit sql.sqlcode;
alter table ${iol_schema}.mpcs_a57torderlist truncate partition p_${batch_date};

-- 2.3 insert data to ex table
create table ${iol_schema}.mpcs_a57torderlist_ex nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.mpcs_a57torderlist where 0=1;

insert /*+ append */ into ${iol_schema}.mpcs_a57torderlist_ex(
    sysid -- 渠道标识
    ,srcseqno -- 请求流水
    ,acctno -- 结算账号
    ,fudcd -- 基金代码
    ,ordertype -- 订单类型 1：申购 2：认购 3：定投 4：余额增值转入
    ,trnamt -- 交易金额，单位为分
    ,ccy -- 币种，目前只支持人民币
    ,chargetype -- 手续费类型 0：申购费前端收费 1：申购费后端收费 2：无申购费，按保有量收费
    ,reqtm -- 申请时间
    ,memo -- 附加信息
    ,rspcd -- 响应码
    ,rspmsg -- 响应信息
    ,orderno -- 申购订单号
    ,rsptm -- 响应时间
    ,etl_dt -- ETL处理日期
    ,etl_timestamp -- ETL处理时间戳
)
select
    sysid -- 渠道标识
    ,srcseqno -- 请求流水
    ,acctno -- 结算账号
    ,fudcd -- 基金代码
    ,ordertype -- 订单类型 1：申购 2：认购 3：定投 4：余额增值转入
    ,trnamt -- 交易金额，单位为分
    ,ccy -- 币种，目前只支持人民币
    ,chargetype -- 手续费类型 0：申购费前端收费 1：申购费后端收费 2：无申购费，按保有量收费
    ,reqtm -- 申请时间
    ,memo -- 附加信息
    ,rspcd -- 响应码
    ,rspmsg -- 响应信息
    ,orderno -- 申购订单号
    ,rsptm -- 响应时间
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from ${itl_schema}.mpcs_a57torderlist
where etl_dt = to_date('${batch_date}', 'yyyymmdd')
;

-- 2.4 exchage ex table and target table
alter table ${iol_schema}.mpcs_a57torderlist exchange partition p_${batch_date} with table ${iol_schema}.mpcs_a57torderlist_ex;

-- 3.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.mpcs_a57torderlist to ${iml_schema};

-- 3.2 drop ex table
drop table ${iol_schema}.mpcs_a57torderlist_ex purge;

-- 4 gater table status
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'mpcs_a57torderlist',partname => 'p_${batch_date}', granularity => 'PARTITION', degree => 8, cascade => true);