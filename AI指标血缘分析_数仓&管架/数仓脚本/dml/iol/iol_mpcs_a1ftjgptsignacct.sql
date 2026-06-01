/*
Purpose:    偏源模型层-全量流水脚本，清空目标表，把当天数据与目标表进行分区交换。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_mpcs_a1ftjgptsignacct
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
drop table ${iol_schema}.mpcs_a1ftjgptsignacct_ex purge;
alter table ${iol_schema}.mpcs_a1ftjgptsignacct add partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

-- 2.2 truncate target table
whenever sqlerror exit sql.sqlcode;
truncate table ${iol_schema}.mpcs_a1ftjgptsignacct;

-- 2.3 insert data to ex table
create table ${iol_schema}.mpcs_a1ftjgptsignacct_ex nologging
compress
as
select * from ${iol_schema}.mpcs_a1ftjgptsignacct where 0=1;

insert /*+ append */ into ${iol_schema}.mpcs_a1ftjgptsignacct_ex(
    syscd -- 系统编号
    ,account -- 监管账号
    ,accountname -- 监管账号户名
    ,updt -- 最后修改时间
    ,status -- 签约状态
    ,signdate -- 签约日期
    ,signtime -- 签约时间
    ,offdate -- 解约日期
    ,offtime -- 解约时间
    ,oprbrn -- 交易机构
    ,oprtlr -- 交易柜员
    ,chkbrn -- 复核机构
    ,chktlr -- 复核柜员
    ,autbrn -- 授权机构
    ,auttlr -- 授权柜员
    ,companyname -- 单位名称
    ,projectname -- 项目名称
    ,contactnum -- 联系人
    ,telphome -- 联系人电话
    ,opbankname -- 开户行
    ,remarks -- 备注
    ,accountstatus -- 监管状态
    ,errmsg -- 错误信息
    ,sndflag -- 发送状态
    ,returncode -- 表示操作结果信息
    ,reason -- 返回信息
    ,openbrn -- 开户机构
    ,historicalflag -- 历史数据标志
    ,opendate -- 开户日期
    ,xzqhbm -- 行政区划编码
    ,globseqnum -- 全局流水号
    ,uniqueseqnum -- 业务流水号
    ,srvtrxseq -- 系统内流水号
    ,ztstrnseqno -- 系统内流水号
    ,etl_dt -- ETL处理日期
    ,etl_timestamp -- ETL处理时间戳
)
select
    syscd -- 系统编号
    ,account -- 监管账号
    ,accountname -- 监管账号户名
    ,updt -- 最后修改时间
    ,status -- 签约状态
    ,signdate -- 签约日期
    ,signtime -- 签约时间
    ,offdate -- 解约日期
    ,offtime -- 解约时间
    ,oprbrn -- 交易机构
    ,oprtlr -- 交易柜员
    ,chkbrn -- 复核机构
    ,chktlr -- 复核柜员
    ,autbrn -- 授权机构
    ,auttlr -- 授权柜员
    ,companyname -- 单位名称
    ,projectname -- 项目名称
    ,contactnum -- 联系人
    ,telphome -- 联系人电话
    ,opbankname -- 开户行
    ,remarks -- 备注
    ,accountstatus -- 监管状态
    ,errmsg -- 错误信息
    ,sndflag -- 发送状态
    ,returncode -- 表示操作结果信息
    ,reason -- 返回信息
    ,openbrn -- 开户机构
    ,historicalflag -- 历史数据标志
    ,opendate -- 开户日期
    ,xzqhbm -- 行政区划编码
    ,globseqnum -- 全局流水号
    ,uniqueseqnum -- 业务流水号
    ,srvtrxseq -- 系统内流水号
    ,ztstrnseqno -- 系统内流水号
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from ${itl_schema}.mpcs_a1ftjgptsignacct
where etl_dt = to_date('${batch_date}', 'yyyymmdd')
;

-- 2.4 exchage ex table and target table
alter table ${iol_schema}.mpcs_a1ftjgptsignacct exchange partition p_${batch_date} with table ${iol_schema}.mpcs_a1ftjgptsignacct_ex;

-- 3.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.mpcs_a1ftjgptsignacct to ${iml_schema};

-- 3.2 drop ex table
drop table ${iol_schema}.mpcs_a1ftjgptsignacct_ex purge;

-- 4 gater table status
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'mpcs_a1ftjgptsignacct',partname => 'p_${batch_date}', granularity => 'PARTITION', degree => 8, cascade => true);