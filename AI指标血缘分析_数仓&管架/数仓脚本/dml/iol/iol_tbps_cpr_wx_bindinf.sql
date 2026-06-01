/*
Purpose:    偏源模型层-全量流水脚本，清空目标表，把当天数据与目标表进行分区交换。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_tbps_cpr_wx_bindinf
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
drop table ${iol_schema}.tbps_cpr_wx_bindinf_ex purge;
alter table ${iol_schema}.tbps_cpr_wx_bindinf add partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

-- 2.2 truncate target table
whenever sqlerror exit sql.sqlcode;
truncate table ${iol_schema}.tbps_cpr_wx_bindinf;

-- 2.3 insert data to ex table
create table ${iol_schema}.tbps_cpr_wx_bindinf_ex nologging
compress
as
select * from ${iol_schema}.tbps_cpr_wx_bindinf where 0=1;

insert /*+ append */ into ${iol_schema}.tbps_cpr_wx_bindinf_ex(
    cwb_openid -- OPENID
    ,cwb_openacc -- 公众号(2:公司微信公众号;1:交易银行微信)
    ,cwb_accno -- 卡号/账号
    ,cwb_acctype -- 账号类型(1:网银账户)
    ,cwb_userctftype -- 证件类型
    ,cwb_userctfno -- 证件号
    ,cwb_userno -- 操作员ID(网银顺序号)
    ,cwb_username -- 操作员姓名
    ,cwb_phone -- 操作员电话
    ,cwb_cstno -- 企业客户号(ECIF号)
    ,cwb_ctftype -- 企业证件类型
    ,cwb_ctfno -- 企业证件号
    ,cwb_bindstatus -- 绑定状态（0失败 1正常 2未绑定 3异常）
    ,cwb_firsttime -- 首次绑定时间
    ,cwb_updatetime -- 更新时间
    ,cwb_channel -- 渠道(GSW:公司微信公众号)
    ,cwb_remark1 -- 预留字段1
    ,cwb_remark2 -- 预留字段2
    ,cwb_remark3 -- 预留字段3
    ,cwb_show -- 切换显示 0:不显示，1:显示
    ,etl_dt -- ETL处理日期
    ,etl_timestamp -- ETL处理时间戳
)
select
    cwb_openid -- OPENID
    ,cwb_openacc -- 公众号(2:公司微信公众号;1:交易银行微信)
    ,cwb_accno -- 卡号/账号
    ,cwb_acctype -- 账号类型(1:网银账户)
    ,cwb_userctftype -- 证件类型
    ,cwb_userctfno -- 证件号
    ,cwb_userno -- 操作员ID(网银顺序号)
    ,cwb_username -- 操作员姓名
    ,cwb_phone -- 操作员电话
    ,cwb_cstno -- 企业客户号(ECIF号)
    ,cwb_ctftype -- 企业证件类型
    ,cwb_ctfno -- 企业证件号
    ,cwb_bindstatus -- 绑定状态（0失败 1正常 2未绑定 3异常）
    ,cwb_firsttime -- 首次绑定时间
    ,cwb_updatetime -- 更新时间
    ,cwb_channel -- 渠道(GSW:公司微信公众号)
    ,cwb_remark1 -- 预留字段1
    ,cwb_remark2 -- 预留字段2
    ,cwb_remark3 -- 预留字段3
    ,cwb_show -- 切换显示 0:不显示，1:显示
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from ${itl_schema}.tbps_cpr_wx_bindinf
where etl_dt = to_date('${batch_date}', 'yyyymmdd')
;

-- 2.4 exchage ex table and target table
alter table ${iol_schema}.tbps_cpr_wx_bindinf exchange partition p_${batch_date} with table ${iol_schema}.tbps_cpr_wx_bindinf_ex;

-- 3.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.tbps_cpr_wx_bindinf to ${iml_schema};

-- 3.2 drop ex table
drop table ${iol_schema}.tbps_cpr_wx_bindinf_ex purge;

-- 4 gater table status
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'tbps_cpr_wx_bindinf',partname => 'p_${batch_date}', granularity => 'PARTITION', degree => 8, cascade => true);