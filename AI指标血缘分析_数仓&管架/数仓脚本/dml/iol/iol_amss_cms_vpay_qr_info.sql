/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_amss_cms_vpay_qr_info
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
create table ${iol_schema}.amss_cms_vpay_qr_info_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.amss_cms_vpay_qr_info
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.amss_cms_vpay_qr_info_op purge;
drop table ${iol_schema}.amss_cms_vpay_qr_info_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.amss_cms_vpay_qr_info_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.amss_cms_vpay_qr_info where 0=1;

create table ${iol_schema}.amss_cms_vpay_qr_info_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.amss_cms_vpay_qr_info where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.amss_cms_vpay_qr_info_cl(
            qr_id -- 二维码id
            ,channel_id -- 渠道id
            ,channel_name -- 渠道名称
            ,second_channel_id -- 二级渠道ID
            ,second_channel_name -- 二级渠道名称
            ,salesman_id -- 业务员ID.关联员工表 的 EMP_ID 字段
            ,salesman_name -- 业务员姓名
            ,merchant_id -- 商户编号
            ,merchant_name -- 商户名称
            ,use_status -- 状态.0-禁用  1-未绑定  2-已绑定   3-已失效
            ,bind_time -- 绑定时间
            ,qr_logo -- 二维码logo.二维码logo路径
            ,mch_logo -- 渠道logo
            ,qr_url -- 二维码访问url.二维码访问路径
            ,qr_batch_id -- 二维码生成批次ID
            ,update_time -- 更新时间
            ,create_time -- 创建时间
            ,accept_org_id -- 受理机构id
            ,qr_no -- 二维码的设备号
            ,cashier_id -- 收银员ID.关联员工表 的 EMP_ID 字段
            ,cashier_name -- 收银员姓名
            ,fld_n1 -- 备用1
            ,fld_n2 -- 备用2
            ,fld_s1 -- 字符备用1
            ,fld_s2 -- 字符备用2
            ,enabled -- 启用状态。1或空-启用，0-冻结
            ,business_type -- 业务类型 1-开票
            ,origin -- 来源  --1自有，2Api
            ,terminal_id -- 终端编号
            ,mch_terminal_id -- 商户侧终端编号
            ,terminal_address -- 终端布放地址，省-市-区-详细地址
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.amss_cms_vpay_qr_info_op(
            qr_id -- 二维码id
            ,channel_id -- 渠道id
            ,channel_name -- 渠道名称
            ,second_channel_id -- 二级渠道ID
            ,second_channel_name -- 二级渠道名称
            ,salesman_id -- 业务员ID.关联员工表 的 EMP_ID 字段
            ,salesman_name -- 业务员姓名
            ,merchant_id -- 商户编号
            ,merchant_name -- 商户名称
            ,use_status -- 状态.0-禁用  1-未绑定  2-已绑定   3-已失效
            ,bind_time -- 绑定时间
            ,qr_logo -- 二维码logo.二维码logo路径
            ,mch_logo -- 渠道logo
            ,qr_url -- 二维码访问url.二维码访问路径
            ,qr_batch_id -- 二维码生成批次ID
            ,update_time -- 更新时间
            ,create_time -- 创建时间
            ,accept_org_id -- 受理机构id
            ,qr_no -- 二维码的设备号
            ,cashier_id -- 收银员ID.关联员工表 的 EMP_ID 字段
            ,cashier_name -- 收银员姓名
            ,fld_n1 -- 备用1
            ,fld_n2 -- 备用2
            ,fld_s1 -- 字符备用1
            ,fld_s2 -- 字符备用2
            ,enabled -- 启用状态。1或空-启用，0-冻结
            ,business_type -- 业务类型 1-开票
            ,origin -- 来源  --1自有，2Api
            ,terminal_id -- 终端编号
            ,mch_terminal_id -- 商户侧终端编号
            ,terminal_address -- 终端布放地址，省-市-区-详细地址
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.qr_id, o.qr_id) as qr_id -- 二维码id
    ,nvl(n.channel_id, o.channel_id) as channel_id -- 渠道id
    ,nvl(n.channel_name, o.channel_name) as channel_name -- 渠道名称
    ,nvl(n.second_channel_id, o.second_channel_id) as second_channel_id -- 二级渠道ID
    ,nvl(n.second_channel_name, o.second_channel_name) as second_channel_name -- 二级渠道名称
    ,nvl(n.salesman_id, o.salesman_id) as salesman_id -- 业务员ID.关联员工表 的 EMP_ID 字段
    ,nvl(n.salesman_name, o.salesman_name) as salesman_name -- 业务员姓名
    ,nvl(n.merchant_id, o.merchant_id) as merchant_id -- 商户编号
    ,nvl(n.merchant_name, o.merchant_name) as merchant_name -- 商户名称
    ,nvl(n.use_status, o.use_status) as use_status -- 状态.0-禁用  1-未绑定  2-已绑定   3-已失效
    ,nvl(n.bind_time, o.bind_time) as bind_time -- 绑定时间
    ,nvl(n.qr_logo, o.qr_logo) as qr_logo -- 二维码logo.二维码logo路径
    ,nvl(n.mch_logo, o.mch_logo) as mch_logo -- 渠道logo
    ,nvl(n.qr_url, o.qr_url) as qr_url -- 二维码访问url.二维码访问路径
    ,nvl(n.qr_batch_id, o.qr_batch_id) as qr_batch_id -- 二维码生成批次ID
    ,nvl(n.update_time, o.update_time) as update_time -- 更新时间
    ,nvl(n.create_time, o.create_time) as create_time -- 创建时间
    ,nvl(n.accept_org_id, o.accept_org_id) as accept_org_id -- 受理机构id
    ,nvl(n.qr_no, o.qr_no) as qr_no -- 二维码的设备号
    ,nvl(n.cashier_id, o.cashier_id) as cashier_id -- 收银员ID.关联员工表 的 EMP_ID 字段
    ,nvl(n.cashier_name, o.cashier_name) as cashier_name -- 收银员姓名
    ,nvl(n.fld_n1, o.fld_n1) as fld_n1 -- 备用1
    ,nvl(n.fld_n2, o.fld_n2) as fld_n2 -- 备用2
    ,nvl(n.fld_s1, o.fld_s1) as fld_s1 -- 字符备用1
    ,nvl(n.fld_s2, o.fld_s2) as fld_s2 -- 字符备用2
    ,nvl(n.enabled, o.enabled) as enabled -- 启用状态。1或空-启用，0-冻结
    ,nvl(n.business_type, o.business_type) as business_type -- 业务类型 1-开票
    ,nvl(n.origin, o.origin) as origin -- 来源  --1自有，2Api
    ,nvl(n.terminal_id, o.terminal_id) as terminal_id -- 终端编号
    ,nvl(n.mch_terminal_id, o.mch_terminal_id) as mch_terminal_id -- 商户侧终端编号
    ,nvl(n.terminal_address, o.terminal_address) as terminal_address -- 终端布放地址，省-市-区-详细地址
    ,case when
            n.qr_id is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.qr_id is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.qr_id is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.amss_cms_vpay_qr_info_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.amss_cms_vpay_qr_info where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.qr_id = n.qr_id
where (
        o.qr_id is null
    )
    or (
        n.qr_id is null
    )
    or (
        o.channel_id <> n.channel_id
        or o.channel_name <> n.channel_name
        or o.second_channel_id <> n.second_channel_id
        or o.second_channel_name <> n.second_channel_name
        or o.salesman_id <> n.salesman_id
        or o.salesman_name <> n.salesman_name
        or o.merchant_id <> n.merchant_id
        or o.merchant_name <> n.merchant_name
        or o.use_status <> n.use_status
        or o.bind_time <> n.bind_time
        or o.qr_logo <> n.qr_logo
        or o.mch_logo <> n.mch_logo
        or o.qr_url <> n.qr_url
        or o.qr_batch_id <> n.qr_batch_id
        or o.update_time <> n.update_time
        or o.create_time <> n.create_time
        or o.accept_org_id <> n.accept_org_id
        or o.qr_no <> n.qr_no
        or o.cashier_id <> n.cashier_id
        or o.cashier_name <> n.cashier_name
        or o.fld_n1 <> n.fld_n1
        or o.fld_n2 <> n.fld_n2
        or o.fld_s1 <> n.fld_s1
        or o.fld_s2 <> n.fld_s2
        or o.enabled <> n.enabled
        or o.business_type <> n.business_type
        or o.origin <> n.origin
        or o.terminal_id <> n.terminal_id
        or o.mch_terminal_id <> n.mch_terminal_id
        or o.terminal_address <> n.terminal_address
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.amss_cms_vpay_qr_info_cl(
            qr_id -- 二维码id
            ,channel_id -- 渠道id
            ,channel_name -- 渠道名称
            ,second_channel_id -- 二级渠道ID
            ,second_channel_name -- 二级渠道名称
            ,salesman_id -- 业务员ID.关联员工表 的 EMP_ID 字段
            ,salesman_name -- 业务员姓名
            ,merchant_id -- 商户编号
            ,merchant_name -- 商户名称
            ,use_status -- 状态.0-禁用  1-未绑定  2-已绑定   3-已失效
            ,bind_time -- 绑定时间
            ,qr_logo -- 二维码logo.二维码logo路径
            ,mch_logo -- 渠道logo
            ,qr_url -- 二维码访问url.二维码访问路径
            ,qr_batch_id -- 二维码生成批次ID
            ,update_time -- 更新时间
            ,create_time -- 创建时间
            ,accept_org_id -- 受理机构id
            ,qr_no -- 二维码的设备号
            ,cashier_id -- 收银员ID.关联员工表 的 EMP_ID 字段
            ,cashier_name -- 收银员姓名
            ,fld_n1 -- 备用1
            ,fld_n2 -- 备用2
            ,fld_s1 -- 字符备用1
            ,fld_s2 -- 字符备用2
            ,enabled -- 启用状态。1或空-启用，0-冻结
            ,business_type -- 业务类型 1-开票
            ,origin -- 来源  --1自有，2Api
            ,terminal_id -- 终端编号
            ,mch_terminal_id -- 商户侧终端编号
            ,terminal_address -- 终端布放地址，省-市-区-详细地址
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.amss_cms_vpay_qr_info_op(
            qr_id -- 二维码id
            ,channel_id -- 渠道id
            ,channel_name -- 渠道名称
            ,second_channel_id -- 二级渠道ID
            ,second_channel_name -- 二级渠道名称
            ,salesman_id -- 业务员ID.关联员工表 的 EMP_ID 字段
            ,salesman_name -- 业务员姓名
            ,merchant_id -- 商户编号
            ,merchant_name -- 商户名称
            ,use_status -- 状态.0-禁用  1-未绑定  2-已绑定   3-已失效
            ,bind_time -- 绑定时间
            ,qr_logo -- 二维码logo.二维码logo路径
            ,mch_logo -- 渠道logo
            ,qr_url -- 二维码访问url.二维码访问路径
            ,qr_batch_id -- 二维码生成批次ID
            ,update_time -- 更新时间
            ,create_time -- 创建时间
            ,accept_org_id -- 受理机构id
            ,qr_no -- 二维码的设备号
            ,cashier_id -- 收银员ID.关联员工表 的 EMP_ID 字段
            ,cashier_name -- 收银员姓名
            ,fld_n1 -- 备用1
            ,fld_n2 -- 备用2
            ,fld_s1 -- 字符备用1
            ,fld_s2 -- 字符备用2
            ,enabled -- 启用状态。1或空-启用，0-冻结
            ,business_type -- 业务类型 1-开票
            ,origin -- 来源  --1自有，2Api
            ,terminal_id -- 终端编号
            ,mch_terminal_id -- 商户侧终端编号
            ,terminal_address -- 终端布放地址，省-市-区-详细地址
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.qr_id -- 二维码id
    ,o.channel_id -- 渠道id
    ,o.channel_name -- 渠道名称
    ,o.second_channel_id -- 二级渠道ID
    ,o.second_channel_name -- 二级渠道名称
    ,o.salesman_id -- 业务员ID.关联员工表 的 EMP_ID 字段
    ,o.salesman_name -- 业务员姓名
    ,o.merchant_id -- 商户编号
    ,o.merchant_name -- 商户名称
    ,o.use_status -- 状态.0-禁用  1-未绑定  2-已绑定   3-已失效
    ,o.bind_time -- 绑定时间
    ,o.qr_logo -- 二维码logo.二维码logo路径
    ,o.mch_logo -- 渠道logo
    ,o.qr_url -- 二维码访问url.二维码访问路径
    ,o.qr_batch_id -- 二维码生成批次ID
    ,o.update_time -- 更新时间
    ,o.create_time -- 创建时间
    ,o.accept_org_id -- 受理机构id
    ,o.qr_no -- 二维码的设备号
    ,o.cashier_id -- 收银员ID.关联员工表 的 EMP_ID 字段
    ,o.cashier_name -- 收银员姓名
    ,o.fld_n1 -- 备用1
    ,o.fld_n2 -- 备用2
    ,o.fld_s1 -- 字符备用1
    ,o.fld_s2 -- 字符备用2
    ,o.enabled -- 启用状态。1或空-启用，0-冻结
    ,o.business_type -- 业务类型 1-开票
    ,o.origin -- 来源  --1自有，2Api
    ,o.terminal_id -- 终端编号
    ,o.mch_terminal_id -- 商户侧终端编号
    ,o.terminal_address -- 终端布放地址，省-市-区-详细地址
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
from ${iol_schema}.amss_cms_vpay_qr_info_bk o
    left join ${iol_schema}.amss_cms_vpay_qr_info_op n
        on
            o.qr_id = n.qr_id
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.amss_cms_vpay_qr_info_cl d
        on
            o.qr_id = d.qr_id
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
--truncate table ${iol_schema}.amss_cms_vpay_qr_info;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('amss_cms_vpay_qr_info') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.amss_cms_vpay_qr_info drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.amss_cms_vpay_qr_info add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.amss_cms_vpay_qr_info exchange partition p_${batch_date} with table ${iol_schema}.amss_cms_vpay_qr_info_cl;
alter table ${iol_schema}.amss_cms_vpay_qr_info exchange partition p_20991231 with table ${iol_schema}.amss_cms_vpay_qr_info_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.amss_cms_vpay_qr_info to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.amss_cms_vpay_qr_info_op purge;
drop table ${iol_schema}.amss_cms_vpay_qr_info_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.amss_cms_vpay_qr_info_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'amss_cms_vpay_qr_info',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
