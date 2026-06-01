/*
Purpose:    偏源模型层-增量流水脚本，清空目标表当天分区，把当天数据与目标表进行分区交换。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_osbs_pbs_logon_flow
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
drop table ${iol_schema}.osbs_pbs_logon_flow_ex purge;
alter table ${iol_schema}.osbs_pbs_logon_flow add partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

-- 2.2 truncate target table batch_date partition
whenever sqlerror exit sql.sqlcode;
alter table ${iol_schema}.osbs_pbs_logon_flow truncate partition p_${batch_date};

-- 2.3 insert data to ex table
create table ${iol_schema}.osbs_pbs_logon_flow_ex nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.osbs_pbs_logon_flow where 0=1;

insert /*+ append */ into ${iol_schema}.osbs_pbs_logon_flow_ex(
    plf_flowno -- 流水号
    ,plf_ecifno -- 全行统一客户号
    ,plf_operationtype -- 操作类型
    ,plf_result -- 登陆结果
    ,plf_resultmsg -- 登陆结果描述
    ,plf_loginid -- 登陆名
    ,plf_logondate -- 登陆时间
    ,plf_channel -- 渠道
    ,plf_deviceno -- 登录设备号
    ,plf_customerip -- 客户IP
    ,plf_hostname -- 当前服务器主机名
    ,plf_src_serverip -- 请求来源服务器IP
    ,plf_userno -- 用户顺序号
    ,plf_userid -- 登录名称
    ,plf_logintype -- 01安全手机号码(手机APP上送) 02昵称 03账号（实体卡账号） 04证件号 05预留手机号（投融资APP上送） 06 微信登录 11 手势登录 12 指纹登录 13 二维码登录
    ,etl_dt -- ETL处理日期
    ,etl_timestamp -- ETL处理时间戳
)
select
    plf_flowno -- 流水号
    ,plf_ecifno -- 全行统一客户号
    ,plf_operationtype -- 操作类型
    ,plf_result -- 登陆结果
    ,plf_resultmsg -- 登陆结果描述
    ,plf_loginid -- 登陆名
    ,plf_logondate -- 登陆时间
    ,plf_channel -- 渠道
    ,plf_deviceno -- 登录设备号
    ,plf_customerip -- 客户IP
    ,plf_hostname -- 当前服务器主机名
    ,plf_src_serverip -- 请求来源服务器IP
    ,plf_userno -- 用户顺序号
    ,plf_userid -- 登录名称
    ,plf_logintype -- 01安全手机号码(手机APP上送) 02昵称 03账号（实体卡账号） 04证件号 05预留手机号（投融资APP上送） 06 微信登录 11 手势登录 12 指纹登录 13 二维码登录
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from ${itl_schema}.osbs_pbs_logon_flow
where etl_dt = to_date('${batch_date}', 'yyyymmdd')
;

-- 2.4 exchage ex table and target table
alter table ${iol_schema}.osbs_pbs_logon_flow exchange partition p_${batch_date} with table ${iol_schema}.osbs_pbs_logon_flow_ex;

-- 3.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.osbs_pbs_logon_flow to ${iml_schema};

-- 3.2 drop ex table
drop table ${iol_schema}.osbs_pbs_logon_flow_ex purge;

-- 4 gater table status
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'osbs_pbs_logon_flow',partname => 'p_${batch_date}', granularity => 'PARTITION', degree => 8, cascade => true);