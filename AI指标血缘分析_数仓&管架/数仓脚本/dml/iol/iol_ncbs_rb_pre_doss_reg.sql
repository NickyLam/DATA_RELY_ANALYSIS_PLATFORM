/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_ncbs_rb_pre_doss_reg
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
create table ${iol_schema}.ncbs_rb_pre_doss_reg_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.ncbs_rb_pre_doss_reg
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.ncbs_rb_pre_doss_reg_op purge;
drop table ${iol_schema}.ncbs_rb_pre_doss_reg_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ncbs_rb_pre_doss_reg_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.ncbs_rb_pre_doss_reg where 0=1;

create table ${iol_schema}.ncbs_rb_pre_doss_reg_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.ncbs_rb_pre_doss_reg where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.ncbs_rb_pre_doss_reg_cl(
            batch_no -- 批次号|批次号
            ,base_acct_no -- 交易账号/卡号|用于描述不同账户结构下的账号，如果是卡的话代表卡号，否则代表账号
            ,acct_seq_no -- 账户子账号|账户序列号，采用顺序数字，表示在同一账号、账户类型、币种下的不同子账户，比如定期存款序列号，卡下选择账户
            ,doss_date -- 转久悬日期|转久悬日期
            ,acct_name -- 账户名称|账户名称，一般指中文账户名称
            ,acct_branch -- 开户机构编号|账户实际开户机构，柜面为实际网点机构，线上渠道一般为对应主账户的实际开户机构
            ,pre_trf_flag -- 预转标识|久悬户预转标识|s-预转成功,f-预转失败
            ,batch_status -- 批次处理状态|批次处理状态|n-新建,v-已验证,w-待处理(部分成功),s-成功,f-失败,d-待审批,a-已审批
            ,failure_reason -- 失败原因|失败原因
            ,audit_date -- 审计日期|审计日期
            ,company -- 法人|法人
            ,tran_timestamp -- 交易时间戳|交易时间戳
            ,approve_status -- 审批状态|久悬户处理审批状态|y-审核通过,n-审核不通过
            ,remark -- 备注|备注
            ,internal_key -- 账户内部键值|账户内部键值
            ,client_no -- 客户编号|客户编号
            ,approval_date -- 复核日期|复核日期
            ,sub_seq_no -- 系统子流水号|系统子流水号
            ,user_id -- 交易柜员编号|核心交易柜员编号
            ,control_msg -- 
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.ncbs_rb_pre_doss_reg_op(
            batch_no -- 批次号|批次号
            ,base_acct_no -- 交易账号/卡号|用于描述不同账户结构下的账号，如果是卡的话代表卡号，否则代表账号
            ,acct_seq_no -- 账户子账号|账户序列号，采用顺序数字，表示在同一账号、账户类型、币种下的不同子账户，比如定期存款序列号，卡下选择账户
            ,doss_date -- 转久悬日期|转久悬日期
            ,acct_name -- 账户名称|账户名称，一般指中文账户名称
            ,acct_branch -- 开户机构编号|账户实际开户机构，柜面为实际网点机构，线上渠道一般为对应主账户的实际开户机构
            ,pre_trf_flag -- 预转标识|久悬户预转标识|s-预转成功,f-预转失败
            ,batch_status -- 批次处理状态|批次处理状态|n-新建,v-已验证,w-待处理(部分成功),s-成功,f-失败,d-待审批,a-已审批
            ,failure_reason -- 失败原因|失败原因
            ,audit_date -- 审计日期|审计日期
            ,company -- 法人|法人
            ,tran_timestamp -- 交易时间戳|交易时间戳
            ,approve_status -- 审批状态|久悬户处理审批状态|y-审核通过,n-审核不通过
            ,remark -- 备注|备注
            ,internal_key -- 账户内部键值|账户内部键值
            ,client_no -- 客户编号|客户编号
            ,approval_date -- 复核日期|复核日期
            ,sub_seq_no -- 系统子流水号|系统子流水号
            ,user_id -- 交易柜员编号|核心交易柜员编号
            ,control_msg -- 
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.batch_no, o.batch_no) as batch_no -- 批次号|批次号
    ,nvl(n.base_acct_no, o.base_acct_no) as base_acct_no -- 交易账号/卡号|用于描述不同账户结构下的账号，如果是卡的话代表卡号，否则代表账号
    ,nvl(n.acct_seq_no, o.acct_seq_no) as acct_seq_no -- 账户子账号|账户序列号，采用顺序数字，表示在同一账号、账户类型、币种下的不同子账户，比如定期存款序列号，卡下选择账户
    ,nvl(n.doss_date, o.doss_date) as doss_date -- 转久悬日期|转久悬日期
    ,nvl(n.acct_name, o.acct_name) as acct_name -- 账户名称|账户名称，一般指中文账户名称
    ,nvl(n.acct_branch, o.acct_branch) as acct_branch -- 开户机构编号|账户实际开户机构，柜面为实际网点机构，线上渠道一般为对应主账户的实际开户机构
    ,nvl(n.pre_trf_flag, o.pre_trf_flag) as pre_trf_flag -- 预转标识|久悬户预转标识|s-预转成功,f-预转失败
    ,nvl(n.batch_status, o.batch_status) as batch_status -- 批次处理状态|批次处理状态|n-新建,v-已验证,w-待处理(部分成功),s-成功,f-失败,d-待审批,a-已审批
    ,nvl(n.failure_reason, o.failure_reason) as failure_reason -- 失败原因|失败原因
    ,nvl(n.audit_date, o.audit_date) as audit_date -- 审计日期|审计日期
    ,nvl(n.company, o.company) as company -- 法人|法人
    ,nvl(n.tran_timestamp, o.tran_timestamp) as tran_timestamp -- 交易时间戳|交易时间戳
    ,nvl(n.approve_status, o.approve_status) as approve_status -- 审批状态|久悬户处理审批状态|y-审核通过,n-审核不通过
    ,nvl(n.remark, o.remark) as remark -- 备注|备注
    ,nvl(n.internal_key, o.internal_key) as internal_key -- 账户内部键值|账户内部键值
    ,nvl(n.client_no, o.client_no) as client_no -- 客户编号|客户编号
    ,nvl(n.approval_date, o.approval_date) as approval_date -- 复核日期|复核日期
    ,nvl(n.sub_seq_no, o.sub_seq_no) as sub_seq_no -- 系统子流水号|系统子流水号
    ,nvl(n.user_id, o.user_id) as user_id -- 交易柜员编号|核心交易柜员编号
    ,nvl(n.control_msg, o.control_msg) as control_msg -- 
    ,case when
            n.internal_key is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.internal_key is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.internal_key is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.ncbs_rb_pre_doss_reg_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.ncbs_rb_pre_doss_reg where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.internal_key = n.internal_key
where (
        o.internal_key is null
    )
    or (
        n.internal_key is null
    )
    or (
        o.batch_no <> n.batch_no
        or o.base_acct_no <> n.base_acct_no
        or o.acct_seq_no <> n.acct_seq_no
        or o.doss_date <> n.doss_date
        or o.acct_name <> n.acct_name
        or o.acct_branch <> n.acct_branch
        or o.pre_trf_flag <> n.pre_trf_flag
        or o.batch_status <> n.batch_status
        or o.failure_reason <> n.failure_reason
        or o.audit_date <> n.audit_date
        or o.company <> n.company
        or o.tran_timestamp <> n.tran_timestamp
        or o.approve_status <> n.approve_status
        or o.remark <> n.remark
        or o.client_no <> n.client_no
        or o.approval_date <> n.approval_date
        or o.sub_seq_no <> n.sub_seq_no
        or o.user_id <> n.user_id
        or o.control_msg <> n.control_msg
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.ncbs_rb_pre_doss_reg_cl(
            batch_no -- 批次号|批次号
            ,base_acct_no -- 交易账号/卡号|用于描述不同账户结构下的账号，如果是卡的话代表卡号，否则代表账号
            ,acct_seq_no -- 账户子账号|账户序列号，采用顺序数字，表示在同一账号、账户类型、币种下的不同子账户，比如定期存款序列号，卡下选择账户
            ,doss_date -- 转久悬日期|转久悬日期
            ,acct_name -- 账户名称|账户名称，一般指中文账户名称
            ,acct_branch -- 开户机构编号|账户实际开户机构，柜面为实际网点机构，线上渠道一般为对应主账户的实际开户机构
            ,pre_trf_flag -- 预转标识|久悬户预转标识|s-预转成功,f-预转失败
            ,batch_status -- 批次处理状态|批次处理状态|n-新建,v-已验证,w-待处理(部分成功),s-成功,f-失败,d-待审批,a-已审批
            ,failure_reason -- 失败原因|失败原因
            ,audit_date -- 审计日期|审计日期
            ,company -- 法人|法人
            ,tran_timestamp -- 交易时间戳|交易时间戳
            ,approve_status -- 审批状态|久悬户处理审批状态|y-审核通过,n-审核不通过
            ,remark -- 备注|备注
            ,internal_key -- 账户内部键值|账户内部键值
            ,client_no -- 客户编号|客户编号
            ,approval_date -- 复核日期|复核日期
            ,sub_seq_no -- 系统子流水号|系统子流水号
            ,user_id -- 交易柜员编号|核心交易柜员编号
            ,control_msg -- 
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.ncbs_rb_pre_doss_reg_op(
            batch_no -- 批次号|批次号
            ,base_acct_no -- 交易账号/卡号|用于描述不同账户结构下的账号，如果是卡的话代表卡号，否则代表账号
            ,acct_seq_no -- 账户子账号|账户序列号，采用顺序数字，表示在同一账号、账户类型、币种下的不同子账户，比如定期存款序列号，卡下选择账户
            ,doss_date -- 转久悬日期|转久悬日期
            ,acct_name -- 账户名称|账户名称，一般指中文账户名称
            ,acct_branch -- 开户机构编号|账户实际开户机构，柜面为实际网点机构，线上渠道一般为对应主账户的实际开户机构
            ,pre_trf_flag -- 预转标识|久悬户预转标识|s-预转成功,f-预转失败
            ,batch_status -- 批次处理状态|批次处理状态|n-新建,v-已验证,w-待处理(部分成功),s-成功,f-失败,d-待审批,a-已审批
            ,failure_reason -- 失败原因|失败原因
            ,audit_date -- 审计日期|审计日期
            ,company -- 法人|法人
            ,tran_timestamp -- 交易时间戳|交易时间戳
            ,approve_status -- 审批状态|久悬户处理审批状态|y-审核通过,n-审核不通过
            ,remark -- 备注|备注
            ,internal_key -- 账户内部键值|账户内部键值
            ,client_no -- 客户编号|客户编号
            ,approval_date -- 复核日期|复核日期
            ,sub_seq_no -- 系统子流水号|系统子流水号
            ,user_id -- 交易柜员编号|核心交易柜员编号
            ,control_msg -- 
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.batch_no -- 批次号|批次号
    ,o.base_acct_no -- 交易账号/卡号|用于描述不同账户结构下的账号，如果是卡的话代表卡号，否则代表账号
    ,o.acct_seq_no -- 账户子账号|账户序列号，采用顺序数字，表示在同一账号、账户类型、币种下的不同子账户，比如定期存款序列号，卡下选择账户
    ,o.doss_date -- 转久悬日期|转久悬日期
    ,o.acct_name -- 账户名称|账户名称，一般指中文账户名称
    ,o.acct_branch -- 开户机构编号|账户实际开户机构，柜面为实际网点机构，线上渠道一般为对应主账户的实际开户机构
    ,o.pre_trf_flag -- 预转标识|久悬户预转标识|s-预转成功,f-预转失败
    ,o.batch_status -- 批次处理状态|批次处理状态|n-新建,v-已验证,w-待处理(部分成功),s-成功,f-失败,d-待审批,a-已审批
    ,o.failure_reason -- 失败原因|失败原因
    ,o.audit_date -- 审计日期|审计日期
    ,o.company -- 法人|法人
    ,o.tran_timestamp -- 交易时间戳|交易时间戳
    ,o.approve_status -- 审批状态|久悬户处理审批状态|y-审核通过,n-审核不通过
    ,o.remark -- 备注|备注
    ,o.internal_key -- 账户内部键值|账户内部键值
    ,o.client_no -- 客户编号|客户编号
    ,o.approval_date -- 复核日期|复核日期
    ,o.sub_seq_no -- 系统子流水号|系统子流水号
    ,o.user_id -- 交易柜员编号|核心交易柜员编号
    ,o.control_msg -- 
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
from ${iol_schema}.ncbs_rb_pre_doss_reg_bk o
    left join ${iol_schema}.ncbs_rb_pre_doss_reg_op n
        on
            o.internal_key = n.internal_key
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.ncbs_rb_pre_doss_reg_cl d
        on
            o.internal_key = d.internal_key
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
--truncate table ${iol_schema}.ncbs_rb_pre_doss_reg;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('ncbs_rb_pre_doss_reg') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.ncbs_rb_pre_doss_reg drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.ncbs_rb_pre_doss_reg add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.ncbs_rb_pre_doss_reg exchange partition p_${batch_date} with table ${iol_schema}.ncbs_rb_pre_doss_reg_cl;
alter table ${iol_schema}.ncbs_rb_pre_doss_reg exchange partition p_20991231 with table ${iol_schema}.ncbs_rb_pre_doss_reg_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.ncbs_rb_pre_doss_reg to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.ncbs_rb_pre_doss_reg_op purge;
drop table ${iol_schema}.ncbs_rb_pre_doss_reg_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.ncbs_rb_pre_doss_reg_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'ncbs_rb_pre_doss_reg',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
