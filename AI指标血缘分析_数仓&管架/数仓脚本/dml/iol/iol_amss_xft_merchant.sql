/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_amss_xft_merchant
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
create table ${iol_schema}.amss_xft_merchant_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.amss_xft_merchant
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.amss_xft_merchant_op purge;
drop table ${iol_schema}.amss_xft_merchant_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.amss_xft_merchant_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.amss_xft_merchant where 0=1;

create table ${iol_schema}.amss_xft_merchant_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.amss_xft_merchant where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.amss_xft_merchant_cl(
            merchant_id -- 商户编号（主键）
            ,merchant_name -- 商户名称
            ,merchant_short_name -- 商户简称
            ,account_code -- 清分账户
            ,account_name -- 清分账户名
            ,account_bank -- 清算账户开户行（总行名称）
            ,account_bank_name -- 清算账户开户行名（分行/支行）
            ,account_type -- 清算账户类型-默认：3-内部户
            ,channel_id -- 机构编号（对应渠道ChannelId）
            ,channel_name -- 机构名称
            ,examine_status -- 审核状态 (0:未审核 1:审核通过 2:审核不通过 3:需再次审核)
            ,check_flag -- 是否校验 (0-不校验, 1-校验)
            ,merchant_status -- 商户状态 (0-禁用, 1-启用)
            ,clear_mode -- 清算模式 (1-自动清算, 2-客户发起清算)
            ,deposit_account -- 入账账户
            ,deposit_account_name -- 入账户名
            ,rate_max -- 入账金额比例上限
            ,rate_min -- 入账金额比例下限
            ,amt_max -- 入账金额上限
            ,amt_min -- 入账金额下限
            ,ftp_host -- 商户FTP-IP
            ,ftp_port -- 商户FTP-端口
            ,ftp_user -- 商户FTP-用户名
            ,ftp_password -- 商户FTP-密码
            ,ftp_local -- 商户FTP-本地上传路径
            ,ftp_remote -- 商户FTP-远程路径
            ,ftp_remote_ret -- 商户FTP-回盘文件路径
            ,create_emp -- 创建人
            ,create_time -- 创建时间
            ,update_emp -- 更新人
            ,update_time -- 更新时间
            ,fld_s1 -- 字符型保留字段1
            ,fld_s2 -- 字符型保留字段2
            ,fld_s3 -- 字符型保留字段3
            ,fld_n1 -- 数值型保留字段1
            ,fld_n2 -- 数值型保留字段2
            ,fld_n3 -- 数值型保留字段3
            ,audit_emp -- 审核人
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.amss_xft_merchant_op(
            merchant_id -- 商户编号（主键）
            ,merchant_name -- 商户名称
            ,merchant_short_name -- 商户简称
            ,account_code -- 清分账户
            ,account_name -- 清分账户名
            ,account_bank -- 清算账户开户行（总行名称）
            ,account_bank_name -- 清算账户开户行名（分行/支行）
            ,account_type -- 清算账户类型-默认：3-内部户
            ,channel_id -- 机构编号（对应渠道ChannelId）
            ,channel_name -- 机构名称
            ,examine_status -- 审核状态 (0:未审核 1:审核通过 2:审核不通过 3:需再次审核)
            ,check_flag -- 是否校验 (0-不校验, 1-校验)
            ,merchant_status -- 商户状态 (0-禁用, 1-启用)
            ,clear_mode -- 清算模式 (1-自动清算, 2-客户发起清算)
            ,deposit_account -- 入账账户
            ,deposit_account_name -- 入账户名
            ,rate_max -- 入账金额比例上限
            ,rate_min -- 入账金额比例下限
            ,amt_max -- 入账金额上限
            ,amt_min -- 入账金额下限
            ,ftp_host -- 商户FTP-IP
            ,ftp_port -- 商户FTP-端口
            ,ftp_user -- 商户FTP-用户名
            ,ftp_password -- 商户FTP-密码
            ,ftp_local -- 商户FTP-本地上传路径
            ,ftp_remote -- 商户FTP-远程路径
            ,ftp_remote_ret -- 商户FTP-回盘文件路径
            ,create_emp -- 创建人
            ,create_time -- 创建时间
            ,update_emp -- 更新人
            ,update_time -- 更新时间
            ,fld_s1 -- 字符型保留字段1
            ,fld_s2 -- 字符型保留字段2
            ,fld_s3 -- 字符型保留字段3
            ,fld_n1 -- 数值型保留字段1
            ,fld_n2 -- 数值型保留字段2
            ,fld_n3 -- 数值型保留字段3
            ,audit_emp -- 审核人
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.merchant_id, o.merchant_id) as merchant_id -- 商户编号（主键）
    ,nvl(n.merchant_name, o.merchant_name) as merchant_name -- 商户名称
    ,nvl(n.merchant_short_name, o.merchant_short_name) as merchant_short_name -- 商户简称
    ,nvl(n.account_code, o.account_code) as account_code -- 清分账户
    ,nvl(n.account_name, o.account_name) as account_name -- 清分账户名
    ,nvl(n.account_bank, o.account_bank) as account_bank -- 清算账户开户行（总行名称）
    ,nvl(n.account_bank_name, o.account_bank_name) as account_bank_name -- 清算账户开户行名（分行/支行）
    ,nvl(n.account_type, o.account_type) as account_type -- 清算账户类型-默认：3-内部户
    ,nvl(n.channel_id, o.channel_id) as channel_id -- 机构编号（对应渠道ChannelId）
    ,nvl(n.channel_name, o.channel_name) as channel_name -- 机构名称
    ,nvl(n.examine_status, o.examine_status) as examine_status -- 审核状态 (0:未审核 1:审核通过 2:审核不通过 3:需再次审核)
    ,nvl(n.check_flag, o.check_flag) as check_flag -- 是否校验 (0-不校验, 1-校验)
    ,nvl(n.merchant_status, o.merchant_status) as merchant_status -- 商户状态 (0-禁用, 1-启用)
    ,nvl(n.clear_mode, o.clear_mode) as clear_mode -- 清算模式 (1-自动清算, 2-客户发起清算)
    ,nvl(n.deposit_account, o.deposit_account) as deposit_account -- 入账账户
    ,nvl(n.deposit_account_name, o.deposit_account_name) as deposit_account_name -- 入账户名
    ,nvl(n.rate_max, o.rate_max) as rate_max -- 入账金额比例上限
    ,nvl(n.rate_min, o.rate_min) as rate_min -- 入账金额比例下限
    ,nvl(n.amt_max, o.amt_max) as amt_max -- 入账金额上限
    ,nvl(n.amt_min, o.amt_min) as amt_min -- 入账金额下限
    ,nvl(n.ftp_host, o.ftp_host) as ftp_host -- 商户FTP-IP
    ,nvl(n.ftp_port, o.ftp_port) as ftp_port -- 商户FTP-端口
    ,nvl(n.ftp_user, o.ftp_user) as ftp_user -- 商户FTP-用户名
    ,nvl(n.ftp_password, o.ftp_password) as ftp_password -- 商户FTP-密码
    ,nvl(n.ftp_local, o.ftp_local) as ftp_local -- 商户FTP-本地上传路径
    ,nvl(n.ftp_remote, o.ftp_remote) as ftp_remote -- 商户FTP-远程路径
    ,nvl(n.ftp_remote_ret, o.ftp_remote_ret) as ftp_remote_ret -- 商户FTP-回盘文件路径
    ,nvl(n.create_emp, o.create_emp) as create_emp -- 创建人
    ,nvl(n.create_time, o.create_time) as create_time -- 创建时间
    ,nvl(n.update_emp, o.update_emp) as update_emp -- 更新人
    ,nvl(n.update_time, o.update_time) as update_time -- 更新时间
    ,nvl(n.fld_s1, o.fld_s1) as fld_s1 -- 字符型保留字段1
    ,nvl(n.fld_s2, o.fld_s2) as fld_s2 -- 字符型保留字段2
    ,nvl(n.fld_s3, o.fld_s3) as fld_s3 -- 字符型保留字段3
    ,nvl(n.fld_n1, o.fld_n1) as fld_n1 -- 数值型保留字段1
    ,nvl(n.fld_n2, o.fld_n2) as fld_n2 -- 数值型保留字段2
    ,nvl(n.fld_n3, o.fld_n3) as fld_n3 -- 数值型保留字段3
    ,nvl(n.audit_emp, o.audit_emp) as audit_emp -- 审核人
    ,case when
            n.merchant_id is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.merchant_id is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.merchant_id is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.amss_xft_merchant_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.amss_xft_merchant where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.merchant_id = n.merchant_id
where (
        o.merchant_id is null
    )
    or (
        n.merchant_id is null
    )
    or (
        o.merchant_name <> n.merchant_name
        or o.merchant_short_name <> n.merchant_short_name
        or o.account_code <> n.account_code
        or o.account_name <> n.account_name
        or o.account_bank <> n.account_bank
        or o.account_bank_name <> n.account_bank_name
        or o.account_type <> n.account_type
        or o.channel_id <> n.channel_id
        or o.channel_name <> n.channel_name
        or o.examine_status <> n.examine_status
        or o.check_flag <> n.check_flag
        or o.merchant_status <> n.merchant_status
        or o.clear_mode <> n.clear_mode
        or o.deposit_account <> n.deposit_account
        or o.deposit_account_name <> n.deposit_account_name
        or o.rate_max <> n.rate_max
        or o.rate_min <> n.rate_min
        or o.amt_max <> n.amt_max
        or o.amt_min <> n.amt_min
        or o.ftp_host <> n.ftp_host
        or o.ftp_port <> n.ftp_port
        or o.ftp_user <> n.ftp_user
        or o.ftp_password <> n.ftp_password
        or o.ftp_local <> n.ftp_local
        or o.ftp_remote <> n.ftp_remote
        or o.ftp_remote_ret <> n.ftp_remote_ret
        or o.create_emp <> n.create_emp
        or o.create_time <> n.create_time
        or o.update_emp <> n.update_emp
        or o.update_time <> n.update_time
        or o.fld_s1 <> n.fld_s1
        or o.fld_s2 <> n.fld_s2
        or o.fld_s3 <> n.fld_s3
        or o.fld_n1 <> n.fld_n1
        or o.fld_n2 <> n.fld_n2
        or o.fld_n3 <> n.fld_n3
        or o.audit_emp <> n.audit_emp
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.amss_xft_merchant_cl(
            merchant_id -- 商户编号（主键）
            ,merchant_name -- 商户名称
            ,merchant_short_name -- 商户简称
            ,account_code -- 清分账户
            ,account_name -- 清分账户名
            ,account_bank -- 清算账户开户行（总行名称）
            ,account_bank_name -- 清算账户开户行名（分行/支行）
            ,account_type -- 清算账户类型-默认：3-内部户
            ,channel_id -- 机构编号（对应渠道ChannelId）
            ,channel_name -- 机构名称
            ,examine_status -- 审核状态 (0:未审核 1:审核通过 2:审核不通过 3:需再次审核)
            ,check_flag -- 是否校验 (0-不校验, 1-校验)
            ,merchant_status -- 商户状态 (0-禁用, 1-启用)
            ,clear_mode -- 清算模式 (1-自动清算, 2-客户发起清算)
            ,deposit_account -- 入账账户
            ,deposit_account_name -- 入账户名
            ,rate_max -- 入账金额比例上限
            ,rate_min -- 入账金额比例下限
            ,amt_max -- 入账金额上限
            ,amt_min -- 入账金额下限
            ,ftp_host -- 商户FTP-IP
            ,ftp_port -- 商户FTP-端口
            ,ftp_user -- 商户FTP-用户名
            ,ftp_password -- 商户FTP-密码
            ,ftp_local -- 商户FTP-本地上传路径
            ,ftp_remote -- 商户FTP-远程路径
            ,ftp_remote_ret -- 商户FTP-回盘文件路径
            ,create_emp -- 创建人
            ,create_time -- 创建时间
            ,update_emp -- 更新人
            ,update_time -- 更新时间
            ,fld_s1 -- 字符型保留字段1
            ,fld_s2 -- 字符型保留字段2
            ,fld_s3 -- 字符型保留字段3
            ,fld_n1 -- 数值型保留字段1
            ,fld_n2 -- 数值型保留字段2
            ,fld_n3 -- 数值型保留字段3
            ,audit_emp -- 审核人
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.amss_xft_merchant_op(
            merchant_id -- 商户编号（主键）
            ,merchant_name -- 商户名称
            ,merchant_short_name -- 商户简称
            ,account_code -- 清分账户
            ,account_name -- 清分账户名
            ,account_bank -- 清算账户开户行（总行名称）
            ,account_bank_name -- 清算账户开户行名（分行/支行）
            ,account_type -- 清算账户类型-默认：3-内部户
            ,channel_id -- 机构编号（对应渠道ChannelId）
            ,channel_name -- 机构名称
            ,examine_status -- 审核状态 (0:未审核 1:审核通过 2:审核不通过 3:需再次审核)
            ,check_flag -- 是否校验 (0-不校验, 1-校验)
            ,merchant_status -- 商户状态 (0-禁用, 1-启用)
            ,clear_mode -- 清算模式 (1-自动清算, 2-客户发起清算)
            ,deposit_account -- 入账账户
            ,deposit_account_name -- 入账户名
            ,rate_max -- 入账金额比例上限
            ,rate_min -- 入账金额比例下限
            ,amt_max -- 入账金额上限
            ,amt_min -- 入账金额下限
            ,ftp_host -- 商户FTP-IP
            ,ftp_port -- 商户FTP-端口
            ,ftp_user -- 商户FTP-用户名
            ,ftp_password -- 商户FTP-密码
            ,ftp_local -- 商户FTP-本地上传路径
            ,ftp_remote -- 商户FTP-远程路径
            ,ftp_remote_ret -- 商户FTP-回盘文件路径
            ,create_emp -- 创建人
            ,create_time -- 创建时间
            ,update_emp -- 更新人
            ,update_time -- 更新时间
            ,fld_s1 -- 字符型保留字段1
            ,fld_s2 -- 字符型保留字段2
            ,fld_s3 -- 字符型保留字段3
            ,fld_n1 -- 数值型保留字段1
            ,fld_n2 -- 数值型保留字段2
            ,fld_n3 -- 数值型保留字段3
            ,audit_emp -- 审核人
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.merchant_id -- 商户编号（主键）
    ,o.merchant_name -- 商户名称
    ,o.merchant_short_name -- 商户简称
    ,o.account_code -- 清分账户
    ,o.account_name -- 清分账户名
    ,o.account_bank -- 清算账户开户行（总行名称）
    ,o.account_bank_name -- 清算账户开户行名（分行/支行）
    ,o.account_type -- 清算账户类型-默认：3-内部户
    ,o.channel_id -- 机构编号（对应渠道ChannelId）
    ,o.channel_name -- 机构名称
    ,o.examine_status -- 审核状态 (0:未审核 1:审核通过 2:审核不通过 3:需再次审核)
    ,o.check_flag -- 是否校验 (0-不校验, 1-校验)
    ,o.merchant_status -- 商户状态 (0-禁用, 1-启用)
    ,o.clear_mode -- 清算模式 (1-自动清算, 2-客户发起清算)
    ,o.deposit_account -- 入账账户
    ,o.deposit_account_name -- 入账户名
    ,o.rate_max -- 入账金额比例上限
    ,o.rate_min -- 入账金额比例下限
    ,o.amt_max -- 入账金额上限
    ,o.amt_min -- 入账金额下限
    ,o.ftp_host -- 商户FTP-IP
    ,o.ftp_port -- 商户FTP-端口
    ,o.ftp_user -- 商户FTP-用户名
    ,o.ftp_password -- 商户FTP-密码
    ,o.ftp_local -- 商户FTP-本地上传路径
    ,o.ftp_remote -- 商户FTP-远程路径
    ,o.ftp_remote_ret -- 商户FTP-回盘文件路径
    ,o.create_emp -- 创建人
    ,o.create_time -- 创建时间
    ,o.update_emp -- 更新人
    ,o.update_time -- 更新时间
    ,o.fld_s1 -- 字符型保留字段1
    ,o.fld_s2 -- 字符型保留字段2
    ,o.fld_s3 -- 字符型保留字段3
    ,o.fld_n1 -- 数值型保留字段1
    ,o.fld_n2 -- 数值型保留字段2
    ,o.fld_n3 -- 数值型保留字段3
    ,o.audit_emp -- 审核人
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
from ${iol_schema}.amss_xft_merchant_bk o
    left join ${iol_schema}.amss_xft_merchant_op n
        on
            o.merchant_id = n.merchant_id
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.amss_xft_merchant_cl d
        on
            o.merchant_id = d.merchant_id
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
--truncate table ${iol_schema}.amss_xft_merchant;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('amss_xft_merchant') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.amss_xft_merchant drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.amss_xft_merchant add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.amss_xft_merchant exchange partition p_${batch_date} with table ${iol_schema}.amss_xft_merchant_cl;
alter table ${iol_schema}.amss_xft_merchant exchange partition p_20991231 with table ${iol_schema}.amss_xft_merchant_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.amss_xft_merchant to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.amss_xft_merchant_op purge;
drop table ${iol_schema}.amss_xft_merchant_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.amss_xft_merchant_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'amss_xft_merchant',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
