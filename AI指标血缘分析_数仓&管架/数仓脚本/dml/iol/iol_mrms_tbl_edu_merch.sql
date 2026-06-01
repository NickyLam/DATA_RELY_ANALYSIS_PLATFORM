/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_mrms_tbl_edu_merch
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
create table ${iol_schema}.mrms_tbl_edu_merch_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.mrms_tbl_edu_merch
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.mrms_tbl_edu_merch_op purge;
drop table ${iol_schema}.mrms_tbl_edu_merch_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.mrms_tbl_edu_merch_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.mrms_tbl_edu_merch where 0=1;

create table ${iol_schema}.mrms_tbl_edu_merch_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.mrms_tbl_edu_merch where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.mrms_tbl_edu_merch_cl(
            merch_num -- 商户号
            ,merch_name -- 商户名称
            ,merch_status -- 商户状态0待审核  1正常    2关闭
            ,jg_acct_no -- 监管账号-付款账号
            ,jg_acct_name -- 监管账号名
            ,jg_acct_bank_no -- 监管账户开户行号
            ,jg_acct_type -- 监管账户类型 0-对公账户，1-个人账户，2-内部户，3-监管账户
            ,dz_acct_no -- 垫资账号-收款账号
            ,dz_acct_name -- 垫资账号名称
            ,dz_acct_bank_no -- 垫资户开户行号
            ,dz_acct_type -- 垫资账户类型 0-对公账户，1-个人账户，2-内部户，3-监管账户
            ,brh_id -- 所属机构号
            ,brh_name -- 所属机构名
            ,created_time -- 创建时间
            ,updated_time -- 修改时间
            ,reserved1 -- 保留字段
            ,reserved2 -- 保留字段
            ,reserved3 -- 保留字段
            ,reserved4 -- 保留字段
            ,reserved5 -- 保留字段
            ,is_w_control -- 是否白名单控制 0否，1是
            ,check_tlr -- 维护柜员
            ,acq_inst_id -- 审批柜员
            ,spell_name -- 商户简称
            ,jg_acct_bank_name -- 清算账户开户行名
            ,ftp_host -- 商户ftp-host
            ,ftp_port -- 商户ftp-port
            ,ftp_user -- 商户ftp-user
            ,ftp_password -- 商户ftp-password
            ,ftp_local -- 商户ftp-本地上传路径
            ,ftp_remote -- 商户ftp-远程请求文件路径
            ,ftp_remote_ret -- 商户ftp-远程回盘文件路径
            ,is_approve -- 是否免审批即可转账 0 -否， 1- 是
            ,flow_status -- 流程状态(0 添加待审核,1 修改待审核,2 关闭待审核,3 回退, 9 通过)
            ,buss_team_na -- 业务团队名称
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.mrms_tbl_edu_merch_op(
            merch_num -- 商户号
            ,merch_name -- 商户名称
            ,merch_status -- 商户状态0待审核  1正常    2关闭
            ,jg_acct_no -- 监管账号-付款账号
            ,jg_acct_name -- 监管账号名
            ,jg_acct_bank_no -- 监管账户开户行号
            ,jg_acct_type -- 监管账户类型 0-对公账户，1-个人账户，2-内部户，3-监管账户
            ,dz_acct_no -- 垫资账号-收款账号
            ,dz_acct_name -- 垫资账号名称
            ,dz_acct_bank_no -- 垫资户开户行号
            ,dz_acct_type -- 垫资账户类型 0-对公账户，1-个人账户，2-内部户，3-监管账户
            ,brh_id -- 所属机构号
            ,brh_name -- 所属机构名
            ,created_time -- 创建时间
            ,updated_time -- 修改时间
            ,reserved1 -- 保留字段
            ,reserved2 -- 保留字段
            ,reserved3 -- 保留字段
            ,reserved4 -- 保留字段
            ,reserved5 -- 保留字段
            ,is_w_control -- 是否白名单控制 0否，1是
            ,check_tlr -- 维护柜员
            ,acq_inst_id -- 审批柜员
            ,spell_name -- 商户简称
            ,jg_acct_bank_name -- 清算账户开户行名
            ,ftp_host -- 商户ftp-host
            ,ftp_port -- 商户ftp-port
            ,ftp_user -- 商户ftp-user
            ,ftp_password -- 商户ftp-password
            ,ftp_local -- 商户ftp-本地上传路径
            ,ftp_remote -- 商户ftp-远程请求文件路径
            ,ftp_remote_ret -- 商户ftp-远程回盘文件路径
            ,is_approve -- 是否免审批即可转账 0 -否， 1- 是
            ,flow_status -- 流程状态(0 添加待审核,1 修改待审核,2 关闭待审核,3 回退, 9 通过)
            ,buss_team_na -- 业务团队名称
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.merch_num, o.merch_num) as merch_num -- 商户号
    ,nvl(n.merch_name, o.merch_name) as merch_name -- 商户名称
    ,nvl(n.merch_status, o.merch_status) as merch_status -- 商户状态0待审核  1正常    2关闭
    ,nvl(n.jg_acct_no, o.jg_acct_no) as jg_acct_no -- 监管账号-付款账号
    ,nvl(n.jg_acct_name, o.jg_acct_name) as jg_acct_name -- 监管账号名
    ,nvl(n.jg_acct_bank_no, o.jg_acct_bank_no) as jg_acct_bank_no -- 监管账户开户行号
    ,nvl(n.jg_acct_type, o.jg_acct_type) as jg_acct_type -- 监管账户类型 0-对公账户，1-个人账户，2-内部户，3-监管账户
    ,nvl(n.dz_acct_no, o.dz_acct_no) as dz_acct_no -- 垫资账号-收款账号
    ,nvl(n.dz_acct_name, o.dz_acct_name) as dz_acct_name -- 垫资账号名称
    ,nvl(n.dz_acct_bank_no, o.dz_acct_bank_no) as dz_acct_bank_no -- 垫资户开户行号
    ,nvl(n.dz_acct_type, o.dz_acct_type) as dz_acct_type -- 垫资账户类型 0-对公账户，1-个人账户，2-内部户，3-监管账户
    ,nvl(n.brh_id, o.brh_id) as brh_id -- 所属机构号
    ,nvl(n.brh_name, o.brh_name) as brh_name -- 所属机构名
    ,nvl(n.created_time, o.created_time) as created_time -- 创建时间
    ,nvl(n.updated_time, o.updated_time) as updated_time -- 修改时间
    ,nvl(n.reserved1, o.reserved1) as reserved1 -- 保留字段
    ,nvl(n.reserved2, o.reserved2) as reserved2 -- 保留字段
    ,nvl(n.reserved3, o.reserved3) as reserved3 -- 保留字段
    ,nvl(n.reserved4, o.reserved4) as reserved4 -- 保留字段
    ,nvl(n.reserved5, o.reserved5) as reserved5 -- 保留字段
    ,nvl(n.is_w_control, o.is_w_control) as is_w_control -- 是否白名单控制 0否，1是
    ,nvl(n.check_tlr, o.check_tlr) as check_tlr -- 维护柜员
    ,nvl(n.acq_inst_id, o.acq_inst_id) as acq_inst_id -- 审批柜员
    ,nvl(n.spell_name, o.spell_name) as spell_name -- 商户简称
    ,nvl(n.jg_acct_bank_name, o.jg_acct_bank_name) as jg_acct_bank_name -- 清算账户开户行名
    ,nvl(n.ftp_host, o.ftp_host) as ftp_host -- 商户ftp-host
    ,nvl(n.ftp_port, o.ftp_port) as ftp_port -- 商户ftp-port
    ,nvl(n.ftp_user, o.ftp_user) as ftp_user -- 商户ftp-user
    ,nvl(n.ftp_password, o.ftp_password) as ftp_password -- 商户ftp-password
    ,nvl(n.ftp_local, o.ftp_local) as ftp_local -- 商户ftp-本地上传路径
    ,nvl(n.ftp_remote, o.ftp_remote) as ftp_remote -- 商户ftp-远程请求文件路径
    ,nvl(n.ftp_remote_ret, o.ftp_remote_ret) as ftp_remote_ret -- 商户ftp-远程回盘文件路径
    ,nvl(n.is_approve, o.is_approve) as is_approve -- 是否免审批即可转账 0 -否， 1- 是
    ,nvl(n.flow_status, o.flow_status) as flow_status -- 流程状态(0 添加待审核,1 修改待审核,2 关闭待审核,3 回退, 9 通过)
    ,nvl(n.buss_team_na, o.buss_team_na) as buss_team_na -- 业务团队名称
    ,case when
            n.merch_num is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.merch_num is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.merch_num is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.mrms_tbl_edu_merch_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.mrms_tbl_edu_merch where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.merch_num = n.merch_num
where (
        o.merch_num is null
    )
    or (
        n.merch_num is null
    )
    or (
        o.merch_name <> n.merch_name
        or o.merch_status <> n.merch_status
        or o.jg_acct_no <> n.jg_acct_no
        or o.jg_acct_name <> n.jg_acct_name
        or o.jg_acct_bank_no <> n.jg_acct_bank_no
        or o.jg_acct_type <> n.jg_acct_type
        or o.dz_acct_no <> n.dz_acct_no
        or o.dz_acct_name <> n.dz_acct_name
        or o.dz_acct_bank_no <> n.dz_acct_bank_no
        or o.dz_acct_type <> n.dz_acct_type
        or o.brh_id <> n.brh_id
        or o.brh_name <> n.brh_name
        or o.created_time <> n.created_time
        or o.updated_time <> n.updated_time
        or o.reserved1 <> n.reserved1
        or o.reserved2 <> n.reserved2
        or o.reserved3 <> n.reserved3
        or o.reserved4 <> n.reserved4
        or o.reserved5 <> n.reserved5
        or o.is_w_control <> n.is_w_control
        or o.check_tlr <> n.check_tlr
        or o.acq_inst_id <> n.acq_inst_id
        or o.spell_name <> n.spell_name
        or o.jg_acct_bank_name <> n.jg_acct_bank_name
        or o.ftp_host <> n.ftp_host
        or o.ftp_port <> n.ftp_port
        or o.ftp_user <> n.ftp_user
        or o.ftp_password <> n.ftp_password
        or o.ftp_local <> n.ftp_local
        or o.ftp_remote <> n.ftp_remote
        or o.ftp_remote_ret <> n.ftp_remote_ret
        or o.is_approve <> n.is_approve
        or o.flow_status <> n.flow_status
        or o.buss_team_na <> n.buss_team_na
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.mrms_tbl_edu_merch_cl(
            merch_num -- 商户号
            ,merch_name -- 商户名称
            ,merch_status -- 商户状态0待审核  1正常    2关闭
            ,jg_acct_no -- 监管账号-付款账号
            ,jg_acct_name -- 监管账号名
            ,jg_acct_bank_no -- 监管账户开户行号
            ,jg_acct_type -- 监管账户类型 0-对公账户，1-个人账户，2-内部户，3-监管账户
            ,dz_acct_no -- 垫资账号-收款账号
            ,dz_acct_name -- 垫资账号名称
            ,dz_acct_bank_no -- 垫资户开户行号
            ,dz_acct_type -- 垫资账户类型 0-对公账户，1-个人账户，2-内部户，3-监管账户
            ,brh_id -- 所属机构号
            ,brh_name -- 所属机构名
            ,created_time -- 创建时间
            ,updated_time -- 修改时间
            ,reserved1 -- 保留字段
            ,reserved2 -- 保留字段
            ,reserved3 -- 保留字段
            ,reserved4 -- 保留字段
            ,reserved5 -- 保留字段
            ,is_w_control -- 是否白名单控制 0否，1是
            ,check_tlr -- 维护柜员
            ,acq_inst_id -- 审批柜员
            ,spell_name -- 商户简称
            ,jg_acct_bank_name -- 清算账户开户行名
            ,ftp_host -- 商户ftp-host
            ,ftp_port -- 商户ftp-port
            ,ftp_user -- 商户ftp-user
            ,ftp_password -- 商户ftp-password
            ,ftp_local -- 商户ftp-本地上传路径
            ,ftp_remote -- 商户ftp-远程请求文件路径
            ,ftp_remote_ret -- 商户ftp-远程回盘文件路径
            ,is_approve -- 是否免审批即可转账 0 -否， 1- 是
            ,flow_status -- 流程状态(0 添加待审核,1 修改待审核,2 关闭待审核,3 回退, 9 通过)
            ,buss_team_na -- 业务团队名称
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.mrms_tbl_edu_merch_op(
            merch_num -- 商户号
            ,merch_name -- 商户名称
            ,merch_status -- 商户状态0待审核  1正常    2关闭
            ,jg_acct_no -- 监管账号-付款账号
            ,jg_acct_name -- 监管账号名
            ,jg_acct_bank_no -- 监管账户开户行号
            ,jg_acct_type -- 监管账户类型 0-对公账户，1-个人账户，2-内部户，3-监管账户
            ,dz_acct_no -- 垫资账号-收款账号
            ,dz_acct_name -- 垫资账号名称
            ,dz_acct_bank_no -- 垫资户开户行号
            ,dz_acct_type -- 垫资账户类型 0-对公账户，1-个人账户，2-内部户，3-监管账户
            ,brh_id -- 所属机构号
            ,brh_name -- 所属机构名
            ,created_time -- 创建时间
            ,updated_time -- 修改时间
            ,reserved1 -- 保留字段
            ,reserved2 -- 保留字段
            ,reserved3 -- 保留字段
            ,reserved4 -- 保留字段
            ,reserved5 -- 保留字段
            ,is_w_control -- 是否白名单控制 0否，1是
            ,check_tlr -- 维护柜员
            ,acq_inst_id -- 审批柜员
            ,spell_name -- 商户简称
            ,jg_acct_bank_name -- 清算账户开户行名
            ,ftp_host -- 商户ftp-host
            ,ftp_port -- 商户ftp-port
            ,ftp_user -- 商户ftp-user
            ,ftp_password -- 商户ftp-password
            ,ftp_local -- 商户ftp-本地上传路径
            ,ftp_remote -- 商户ftp-远程请求文件路径
            ,ftp_remote_ret -- 商户ftp-远程回盘文件路径
            ,is_approve -- 是否免审批即可转账 0 -否， 1- 是
            ,flow_status -- 流程状态(0 添加待审核,1 修改待审核,2 关闭待审核,3 回退, 9 通过)
            ,buss_team_na -- 业务团队名称
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.merch_num -- 商户号
    ,o.merch_name -- 商户名称
    ,o.merch_status -- 商户状态0待审核  1正常    2关闭
    ,o.jg_acct_no -- 监管账号-付款账号
    ,o.jg_acct_name -- 监管账号名
    ,o.jg_acct_bank_no -- 监管账户开户行号
    ,o.jg_acct_type -- 监管账户类型 0-对公账户，1-个人账户，2-内部户，3-监管账户
    ,o.dz_acct_no -- 垫资账号-收款账号
    ,o.dz_acct_name -- 垫资账号名称
    ,o.dz_acct_bank_no -- 垫资户开户行号
    ,o.dz_acct_type -- 垫资账户类型 0-对公账户，1-个人账户，2-内部户，3-监管账户
    ,o.brh_id -- 所属机构号
    ,o.brh_name -- 所属机构名
    ,o.created_time -- 创建时间
    ,o.updated_time -- 修改时间
    ,o.reserved1 -- 保留字段
    ,o.reserved2 -- 保留字段
    ,o.reserved3 -- 保留字段
    ,o.reserved4 -- 保留字段
    ,o.reserved5 -- 保留字段
    ,o.is_w_control -- 是否白名单控制 0否，1是
    ,o.check_tlr -- 维护柜员
    ,o.acq_inst_id -- 审批柜员
    ,o.spell_name -- 商户简称
    ,o.jg_acct_bank_name -- 清算账户开户行名
    ,o.ftp_host -- 商户ftp-host
    ,o.ftp_port -- 商户ftp-port
    ,o.ftp_user -- 商户ftp-user
    ,o.ftp_password -- 商户ftp-password
    ,o.ftp_local -- 商户ftp-本地上传路径
    ,o.ftp_remote -- 商户ftp-远程请求文件路径
    ,o.ftp_remote_ret -- 商户ftp-远程回盘文件路径
    ,o.is_approve -- 是否免审批即可转账 0 -否， 1- 是
    ,o.flow_status -- 流程状态(0 添加待审核,1 修改待审核,2 关闭待审核,3 回退, 9 通过)
    ,o.buss_team_na -- 业务团队名称
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
from ${iol_schema}.mrms_tbl_edu_merch_bk o
    left join ${iol_schema}.mrms_tbl_edu_merch_op n
        on
            o.merch_num = n.merch_num
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.mrms_tbl_edu_merch_cl d
        on
            o.merch_num = d.merch_num
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
--truncate table ${iol_schema}.mrms_tbl_edu_merch;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('mrms_tbl_edu_merch') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.mrms_tbl_edu_merch drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.mrms_tbl_edu_merch add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.mrms_tbl_edu_merch exchange partition p_${batch_date} with table ${iol_schema}.mrms_tbl_edu_merch_cl;
alter table ${iol_schema}.mrms_tbl_edu_merch exchange partition p_20991231 with table ${iol_schema}.mrms_tbl_edu_merch_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.mrms_tbl_edu_merch to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.mrms_tbl_edu_merch_op purge;
drop table ${iol_schema}.mrms_tbl_edu_merch_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.mrms_tbl_edu_merch_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'mrms_tbl_edu_merch',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
