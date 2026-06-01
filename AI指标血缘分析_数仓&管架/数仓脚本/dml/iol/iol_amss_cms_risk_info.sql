/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_amss_cms_risk_info
CreateDate: 20180515
Logs:
    zjj 2018-05-15 新建脚本
*/

set timing on

-- 1 alter parallel
alter session force parallel query parallel 8;
alter session force parallel dml parallel 8;
-- alter session force parallel ddl parallel 8;

-- 2.1 create backup table
-- if backup table is exists, mean script if failed on last time
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
create table ${iol_schema}.amss_cms_risk_info_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.amss_cms_risk_info
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.amss_cms_risk_info_op purge;
drop table ${iol_schema}.amss_cms_risk_info_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.amss_cms_risk_info_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.amss_cms_risk_info where 0=1;

create table ${iol_schema}.amss_cms_risk_info_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.amss_cms_risk_info where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.amss_cms_risk_info_cl(
            risk_id -- 主键
            ,risk_pro -- 提供方. 0:威富通 1:支付宝
            ,risk_type -- 校验类型.0:卡号,1:商户名,2:身份证号,3:手机
            ,risk_status -- 校验状态.1已校验
            ,risk_result -- 校验结果.0：初始，1:正常，2：危险
            ,risk_info -- 黑名单数据.错误值
            ,remark -- 备注信息
            ,create_user -- 
            ,create_emp -- 
            ,create_time -- 创建时间.
            ,update_time -- 更新时间.
            ,fld_n1 -- 数值型保留字段1.数值型保留字段1
            ,fld_n2 -- 数值型保留字段2.数值型保留字段2
            ,fld_s1 -- 字符型保留字段1.字符型保留字段1
            ,fld_s2 -- 字符型保留字段2.字符型保留字段2
            ,thi_risk_status -- 第三方风险状态
            ,risk_level -- 第三方风险等级
            ,channel_id -- 所属渠道.关联渠道ID，只有受理机构允许为空
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.amss_cms_risk_info_op(
            risk_id -- 主键
            ,risk_pro -- 提供方. 0:威富通 1:支付宝
            ,risk_type -- 校验类型.0:卡号,1:商户名,2:身份证号,3:手机
            ,risk_status -- 校验状态.1已校验
            ,risk_result -- 校验结果.0：初始，1:正常，2：危险
            ,risk_info -- 黑名单数据.错误值
            ,remark -- 备注信息
            ,create_user -- 
            ,create_emp -- 
            ,create_time -- 创建时间.
            ,update_time -- 更新时间.
            ,fld_n1 -- 数值型保留字段1.数值型保留字段1
            ,fld_n2 -- 数值型保留字段2.数值型保留字段2
            ,fld_s1 -- 字符型保留字段1.字符型保留字段1
            ,fld_s2 -- 字符型保留字段2.字符型保留字段2
            ,thi_risk_status -- 第三方风险状态
            ,risk_level -- 第三方风险等级
            ,channel_id -- 所属渠道.关联渠道ID，只有受理机构允许为空
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.risk_id, o.risk_id) as risk_id -- 主键
    ,nvl(n.risk_pro, o.risk_pro) as risk_pro -- 提供方. 0:威富通 1:支付宝
    ,nvl(n.risk_type, o.risk_type) as risk_type -- 校验类型.0:卡号,1:商户名,2:身份证号,3:手机
    ,nvl(n.risk_status, o.risk_status) as risk_status -- 校验状态.1已校验
    ,nvl(n.risk_result, o.risk_result) as risk_result -- 校验结果.0：初始，1:正常，2：危险
    ,nvl(n.risk_info, o.risk_info) as risk_info -- 黑名单数据.错误值
    ,nvl(n.remark, o.remark) as remark -- 备注信息
    ,nvl(n.create_user, o.create_user) as create_user -- 
    ,nvl(n.create_emp, o.create_emp) as create_emp -- 
    ,nvl(n.create_time, o.create_time) as create_time -- 创建时间.
    ,nvl(n.update_time, o.update_time) as update_time -- 更新时间.
    ,nvl(n.fld_n1, o.fld_n1) as fld_n1 -- 数值型保留字段1.数值型保留字段1
    ,nvl(n.fld_n2, o.fld_n2) as fld_n2 -- 数值型保留字段2.数值型保留字段2
    ,nvl(n.fld_s1, o.fld_s1) as fld_s1 -- 字符型保留字段1.字符型保留字段1
    ,nvl(n.fld_s2, o.fld_s2) as fld_s2 -- 字符型保留字段2.字符型保留字段2
    ,nvl(n.thi_risk_status, o.thi_risk_status) as thi_risk_status -- 第三方风险状态
    ,nvl(n.risk_level, o.risk_level) as risk_level -- 第三方风险等级
    ,nvl(n.channel_id, o.channel_id) as channel_id -- 所属渠道.关联渠道ID，只有受理机构允许为空
    ,case when
            n.risk_id is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.risk_id is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.risk_id is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.amss_cms_risk_info_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.amss_cms_risk_info where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.risk_id = n.risk_id
where (
        o.risk_id is null
    )
    or (
        n.risk_id is null
    )
    or (
        o.risk_pro <> n.risk_pro
        or o.risk_type <> n.risk_type
        or o.risk_status <> n.risk_status
        or o.risk_result <> n.risk_result
        or o.risk_info <> n.risk_info
        or o.remark <> n.remark
        or o.create_user <> n.create_user
        or o.create_emp <> n.create_emp
        or o.create_time <> n.create_time
        or o.update_time <> n.update_time
        or o.fld_n1 <> n.fld_n1
        or o.fld_n2 <> n.fld_n2
        or o.fld_s1 <> n.fld_s1
        or o.fld_s2 <> n.fld_s2
        or o.thi_risk_status <> n.thi_risk_status
        or o.risk_level <> n.risk_level
        or o.channel_id <> n.channel_id
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.amss_cms_risk_info_cl(
            risk_id -- 主键
            ,risk_pro -- 提供方. 0:威富通 1:支付宝
            ,risk_type -- 校验类型.0:卡号,1:商户名,2:身份证号,3:手机
            ,risk_status -- 校验状态.1已校验
            ,risk_result -- 校验结果.0：初始，1:正常，2：危险
            ,risk_info -- 黑名单数据.错误值
            ,remark -- 备注信息
            ,create_user -- 
            ,create_emp -- 
            ,create_time -- 创建时间.
            ,update_time -- 更新时间.
            ,fld_n1 -- 数值型保留字段1.数值型保留字段1
            ,fld_n2 -- 数值型保留字段2.数值型保留字段2
            ,fld_s1 -- 字符型保留字段1.字符型保留字段1
            ,fld_s2 -- 字符型保留字段2.字符型保留字段2
            ,thi_risk_status -- 第三方风险状态
            ,risk_level -- 第三方风险等级
            ,channel_id -- 所属渠道.关联渠道ID，只有受理机构允许为空
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.amss_cms_risk_info_op(
            risk_id -- 主键
            ,risk_pro -- 提供方. 0:威富通 1:支付宝
            ,risk_type -- 校验类型.0:卡号,1:商户名,2:身份证号,3:手机
            ,risk_status -- 校验状态.1已校验
            ,risk_result -- 校验结果.0：初始，1:正常，2：危险
            ,risk_info -- 黑名单数据.错误值
            ,remark -- 备注信息
            ,create_user -- 
            ,create_emp -- 
            ,create_time -- 创建时间.
            ,update_time -- 更新时间.
            ,fld_n1 -- 数值型保留字段1.数值型保留字段1
            ,fld_n2 -- 数值型保留字段2.数值型保留字段2
            ,fld_s1 -- 字符型保留字段1.字符型保留字段1
            ,fld_s2 -- 字符型保留字段2.字符型保留字段2
            ,thi_risk_status -- 第三方风险状态
            ,risk_level -- 第三方风险等级
            ,channel_id -- 所属渠道.关联渠道ID，只有受理机构允许为空
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.risk_id -- 主键
    ,o.risk_pro -- 提供方. 0:威富通 1:支付宝
    ,o.risk_type -- 校验类型.0:卡号,1:商户名,2:身份证号,3:手机
    ,o.risk_status -- 校验状态.1已校验
    ,o.risk_result -- 校验结果.0：初始，1:正常，2：危险
    ,o.risk_info -- 黑名单数据.错误值
    ,o.remark -- 备注信息
    ,o.create_user -- 
    ,o.create_emp -- 
    ,o.create_time -- 创建时间.
    ,o.update_time -- 更新时间.
    ,o.fld_n1 -- 数值型保留字段1.数值型保留字段1
    ,o.fld_n2 -- 数值型保留字段2.数值型保留字段2
    ,o.fld_s1 -- 字符型保留字段1.字符型保留字段1
    ,o.fld_s2 -- 字符型保留字段2.字符型保留字段2
    ,o.thi_risk_status -- 第三方风险状态
    ,o.risk_level -- 第三方风险等级
    ,o.channel_id -- 所属渠道.关联渠道ID，只有受理机构允许为空
    ,o.start_dt -- 开始时间
    ,case when n.start_dt is not null then to_date('${batch_date}', 'yyyymmdd')
          when o.end_dt >= to_date('${batch_date}','yyyymmdd') then to_date('20991231','yyyymmdd')
          else o.end_dt
     end as end_dt -- 结束时间
    ,case when n.start_dt is not null
          then 'I'
          when o.end_dt >= to_date('${batch_date}','yyyymmdd')
          then 'I'
          else o.id_mark
     end as id_mark  -- 增删标志 
    ,o.etl_timestamp -- ETL处理时间
from ${iol_schema}.amss_cms_risk_info_bk o
    left join ${iol_schema}.amss_cms_risk_info_op n
        on
            o.risk_id = n.risk_id
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.amss_cms_risk_info_cl d
        on
            o.risk_id = d.risk_id
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
--truncate table ${iol_schema}.amss_cms_risk_info;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('amss_cms_risk_info') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.amss_cms_risk_info drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.amss_cms_risk_info add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.amss_cms_risk_info exchange partition p_${batch_date} with table ${iol_schema}.amss_cms_risk_info_cl;
alter table ${iol_schema}.amss_cms_risk_info exchange partition p_20991231 with table ${iol_schema}.amss_cms_risk_info_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.amss_cms_risk_info to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.amss_cms_risk_info_op purge;
drop table ${iol_schema}.amss_cms_risk_info_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.amss_cms_risk_info_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'amss_cms_risk_info',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
