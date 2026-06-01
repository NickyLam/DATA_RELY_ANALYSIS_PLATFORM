/*
Purpose:    偏源模型层-全量流水脚本，清空目标表，把当天数据与目标表进行分区交换。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_osbs_pbs_private_bank_authen_flow
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
drop table ${iol_schema}.osbs_pbs_private_bank_authen_flow_ex purge;
alter table ${iol_schema}.osbs_pbs_private_bank_authen_flow add partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

-- 2.2 truncate target table
whenever sqlerror exit sql.sqlcode;
truncate table ${iol_schema}.osbs_pbs_private_bank_authen_flow;

-- 2.3 insert data to ex table
create table ${iol_schema}.osbs_pbs_private_bank_authen_flow_ex nologging
compress
as
select * from ${iol_schema}.osbs_pbs_private_bank_authen_flow where 0=1;

insert /*+ append */ into ${iol_schema}.osbs_pbs_private_bank_authen_flow_ex(
    apb_flowno -- 流水表流水号
    ,apb_no -- 授权表流水号
    ,apb_channelcode -- 渠道号
    ,apb_ecifno -- 客户号
    ,apb_certno -- 身份证
    ,apb_ecifphone -- ECIF预留手机号
    ,apb_wechatphone -- 微信客户手机号
    ,apb_updatestatus -- 更新状态：1、更新  0、不更新 3更新失败
    ,apb_createtime -- 创建时间
    ,apb_updatetime -- 更新时间
    ,apb_enabled -- 授权是否有效：1、有效;2、失效
    ,apb_appid -- APPID
    ,apb_operation -- 操作（1、新增2、修改3、删除4、解除授权）
    ,apb_operationstatus -- 操作状态（0、开始、1、成功、2、失败）
    ,apb_failreasoncode -- 失败原因代码0没有失败
    ,apb_remake -- 备注
    ,etl_dt -- ETL处理日期
    ,etl_timestamp -- ETL处理时间戳
)
select
    apb_flowno -- 流水表流水号
    ,apb_no -- 授权表流水号
    ,apb_channelcode -- 渠道号
    ,apb_ecifno -- 客户号
    ,apb_certno -- 身份证
    ,apb_ecifphone -- ECIF预留手机号
    ,apb_wechatphone -- 微信客户手机号
    ,apb_updatestatus -- 更新状态：1、更新  0、不更新 3更新失败
    ,apb_createtime -- 创建时间
    ,apb_updatetime -- 更新时间
    ,apb_enabled -- 授权是否有效：1、有效;2、失效
    ,apb_appid -- APPID
    ,apb_operation -- 操作（1、新增2、修改3、删除4、解除授权）
    ,apb_operationstatus -- 操作状态（0、开始、1、成功、2、失败）
    ,apb_failreasoncode -- 失败原因代码0没有失败
    ,apb_remake -- 备注
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from ${itl_schema}.osbs_pbs_private_bank_authen_flow
where etl_dt = to_date('${batch_date}', 'yyyymmdd')
;

-- 2.4 exchage ex table and target table
alter table ${iol_schema}.osbs_pbs_private_bank_authen_flow exchange partition p_${batch_date} with table ${iol_schema}.osbs_pbs_private_bank_authen_flow_ex;

-- 3.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.osbs_pbs_private_bank_authen_flow to ${iml_schema};

-- 3.2 drop ex table
drop table ${iol_schema}.osbs_pbs_private_bank_authen_flow_ex purge;

-- 4 gater table status
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'osbs_pbs_private_bank_authen_flow',partname => 'p_${batch_date}', granularity => 'PARTITION', degree => 8, cascade => true);