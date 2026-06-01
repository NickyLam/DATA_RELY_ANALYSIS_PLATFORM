/*
Purpose:    偏源模型层-全量流水脚本，清空目标表，把当天数据与目标表进行分区交换。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_mpcs_a72tsmpapplyinfo
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
drop table ${iol_schema}.mpcs_a72tsmpapplyinfo_ex purge;
alter table ${iol_schema}.mpcs_a72tsmpapplyinfo add partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

-- 2.2 truncate target table
whenever sqlerror exit sql.sqlcode;
truncate table ${iol_schema}.mpcs_a72tsmpapplyinfo;

-- 2.3 insert data to ex table
create table ${iol_schema}.mpcs_a72tsmpapplyinfo_ex nologging
compress
as
select * from ${iol_schema}.mpcs_a72tsmpapplyinfo where 0=1;

insert /*+ append */ into ${iol_schema}.mpcs_a72tsmpapplyinfo_ex(
    transdate -- 申请日期
    ,transtime -- 申请时间
    ,applystate -- 应用申请状态:99已接收申请，待行方审核处理 00申请通过 01申请失败：使用RSPMSG定义失败原因
    ,persnlstate -- 应用个人化状态:99等待轮询处理 00个人化成功 01个人化失败 02个人化准备就绪 03已向人行返回个人化指令(因无sessionid，可能导致由状态5变为状态3) 04找不到个人化指令文件 05开卡申请未通过 06应用删除
    ,rspcd -- 核心返回码
    ,rspmsg -- 核心返回信息
    ,msgid -- 报文标识号
    ,pamid -- PAMID
    ,instpaid -- 实例PAID
    ,acctno -- 电子现金主账户
    ,periddata -- 联机PIN数据
    ,custno -- 客户号
    ,certidtype -- 证据类型
    ,certid -- 证件号码
    ,pername -- 姓名
    ,phoneid -- 手机号码
    ,cardnm -- 卡号
    ,stepnum -- 步骤总数
    ,stepindex -- 步骤序号
    ,dgifilename -- DGI文件名
    ,etl_dt -- ETL处理日期
    ,etl_timestamp -- ETL处理时间戳
)
select
    transdate -- 申请日期
    ,transtime -- 申请时间
    ,applystate -- 应用申请状态:99已接收申请，待行方审核处理 00申请通过 01申请失败：使用RSPMSG定义失败原因
    ,persnlstate -- 应用个人化状态:99等待轮询处理 00个人化成功 01个人化失败 02个人化准备就绪 03已向人行返回个人化指令(因无sessionid，可能导致由状态5变为状态3) 04找不到个人化指令文件 05开卡申请未通过 06应用删除
    ,rspcd -- 核心返回码
    ,rspmsg -- 核心返回信息
    ,msgid -- 报文标识号
    ,pamid -- PAMID
    ,instpaid -- 实例PAID
    ,acctno -- 电子现金主账户
    ,periddata -- 联机PIN数据
    ,custno -- 客户号
    ,certidtype -- 证据类型
    ,certid -- 证件号码
    ,pername -- 姓名
    ,phoneid -- 手机号码
    ,cardnm -- 卡号
    ,stepnum -- 步骤总数
    ,stepindex -- 步骤序号
    ,dgifilename -- DGI文件名
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from ${itl_schema}.mpcs_a72tsmpapplyinfo
where etl_dt = to_date('${batch_date}', 'yyyymmdd')
;

-- 2.4 exchage ex table and target table
alter table ${iol_schema}.mpcs_a72tsmpapplyinfo exchange partition p_${batch_date} with table ${iol_schema}.mpcs_a72tsmpapplyinfo_ex;

-- 3.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.mpcs_a72tsmpapplyinfo to ${iml_schema};

-- 3.2 drop ex table
drop table ${iol_schema}.mpcs_a72tsmpapplyinfo_ex purge;

-- 4 gater table status
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'mpcs_a72tsmpapplyinfo',partname => 'p_${batch_date}', granularity => 'PARTITION', degree => 8, cascade => true);