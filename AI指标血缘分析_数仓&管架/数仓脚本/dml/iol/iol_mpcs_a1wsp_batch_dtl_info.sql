/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_mpcs_a1wsp_batch_dtl_info
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
create table ${iol_schema}.mpcs_a1wsp_batch_dtl_info_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.mpcs_a1wsp_batch_dtl_info
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.mpcs_a1wsp_batch_dtl_info_op purge;
drop table ${iol_schema}.mpcs_a1wsp_batch_dtl_info_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.mpcs_a1wsp_batch_dtl_info_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.mpcs_a1wsp_batch_dtl_info where 0=1;

create table ${iol_schema}.mpcs_a1wsp_batch_dtl_info_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.mpcs_a1wsp_batch_dtl_info where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.mpcs_a1wsp_batch_dtl_info_cl(
            detail_no -- 明细编号
            ,batch_no -- 批次编号
            ,trans_status -- 交易状态(00-初始化;01-交易成功;02-交易失败;03-状态未知;99-处理中)
            ,payee_acct_no -- 收款账号
            ,trans_amt -- 交易金额
            ,trans_split_amt -- 交易金额(超限拆分)
            ,dtl_remark -- 明细备注
            ,employee_id -- 员工ID
            ,employee_name -- 员工姓名
            ,phone_no -- 员工电话
            ,cert_no -- 员工证件号码
            ,company_id -- 企业ID
            ,company_name -- 企业名称
            ,row_num -- 行号
            ,create_timestamp -- 创建时间戳
            ,update_timestamp -- 更新时间戳
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.mpcs_a1wsp_batch_dtl_info_op(
            detail_no -- 明细编号
            ,batch_no -- 批次编号
            ,trans_status -- 交易状态(00-初始化;01-交易成功;02-交易失败;03-状态未知;99-处理中)
            ,payee_acct_no -- 收款账号
            ,trans_amt -- 交易金额
            ,trans_split_amt -- 交易金额(超限拆分)
            ,dtl_remark -- 明细备注
            ,employee_id -- 员工ID
            ,employee_name -- 员工姓名
            ,phone_no -- 员工电话
            ,cert_no -- 员工证件号码
            ,company_id -- 企业ID
            ,company_name -- 企业名称
            ,row_num -- 行号
            ,create_timestamp -- 创建时间戳
            ,update_timestamp -- 更新时间戳
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.detail_no, o.detail_no) as detail_no -- 明细编号
    ,nvl(n.batch_no, o.batch_no) as batch_no -- 批次编号
    ,nvl(n.trans_status, o.trans_status) as trans_status -- 交易状态(00-初始化;01-交易成功;02-交易失败;03-状态未知;99-处理中)
    ,nvl(n.payee_acct_no, o.payee_acct_no) as payee_acct_no -- 收款账号
    ,nvl(n.trans_amt, o.trans_amt) as trans_amt -- 交易金额
    ,nvl(n.trans_split_amt, o.trans_split_amt) as trans_split_amt -- 交易金额(超限拆分)
    ,nvl(n.dtl_remark, o.dtl_remark) as dtl_remark -- 明细备注
    ,nvl(n.employee_id, o.employee_id) as employee_id -- 员工ID
    ,nvl(n.employee_name, o.employee_name) as employee_name -- 员工姓名
    ,nvl(n.phone_no, o.phone_no) as phone_no -- 员工电话
    ,nvl(n.cert_no, o.cert_no) as cert_no -- 员工证件号码
    ,nvl(n.company_id, o.company_id) as company_id -- 企业ID
    ,nvl(n.company_name, o.company_name) as company_name -- 企业名称
    ,nvl(n.row_num, o.row_num) as row_num -- 行号
    ,nvl(n.create_timestamp, o.create_timestamp) as create_timestamp -- 创建时间戳
    ,nvl(n.update_timestamp, o.update_timestamp) as update_timestamp -- 更新时间戳
    ,case when
            n.detail_no is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.detail_no is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.detail_no is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.mpcs_a1wsp_batch_dtl_info_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.mpcs_a1wsp_batch_dtl_info where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.detail_no = n.detail_no
where (
        o.detail_no is null
    )
    or (
        n.detail_no is null
    )
    or (
        o.batch_no <> n.batch_no
        or o.trans_status <> n.trans_status
        or o.payee_acct_no <> n.payee_acct_no
        or o.trans_amt <> n.trans_amt
        or o.trans_split_amt <> n.trans_split_amt
        or o.dtl_remark <> n.dtl_remark
        or o.employee_id <> n.employee_id
        or o.employee_name <> n.employee_name
        or o.phone_no <> n.phone_no
        or o.cert_no <> n.cert_no
        or o.company_id <> n.company_id
        or o.company_name <> n.company_name
        or o.row_num <> n.row_num
        or o.create_timestamp <> n.create_timestamp
        or o.update_timestamp <> n.update_timestamp
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.mpcs_a1wsp_batch_dtl_info_cl(
            detail_no -- 明细编号
            ,batch_no -- 批次编号
            ,trans_status -- 交易状态(00-初始化;01-交易成功;02-交易失败;03-状态未知;99-处理中)
            ,payee_acct_no -- 收款账号
            ,trans_amt -- 交易金额
            ,trans_split_amt -- 交易金额(超限拆分)
            ,dtl_remark -- 明细备注
            ,employee_id -- 员工ID
            ,employee_name -- 员工姓名
            ,phone_no -- 员工电话
            ,cert_no -- 员工证件号码
            ,company_id -- 企业ID
            ,company_name -- 企业名称
            ,row_num -- 行号
            ,create_timestamp -- 创建时间戳
            ,update_timestamp -- 更新时间戳
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.mpcs_a1wsp_batch_dtl_info_op(
            detail_no -- 明细编号
            ,batch_no -- 批次编号
            ,trans_status -- 交易状态(00-初始化;01-交易成功;02-交易失败;03-状态未知;99-处理中)
            ,payee_acct_no -- 收款账号
            ,trans_amt -- 交易金额
            ,trans_split_amt -- 交易金额(超限拆分)
            ,dtl_remark -- 明细备注
            ,employee_id -- 员工ID
            ,employee_name -- 员工姓名
            ,phone_no -- 员工电话
            ,cert_no -- 员工证件号码
            ,company_id -- 企业ID
            ,company_name -- 企业名称
            ,row_num -- 行号
            ,create_timestamp -- 创建时间戳
            ,update_timestamp -- 更新时间戳
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.detail_no -- 明细编号
    ,o.batch_no -- 批次编号
    ,o.trans_status -- 交易状态(00-初始化;01-交易成功;02-交易失败;03-状态未知;99-处理中)
    ,o.payee_acct_no -- 收款账号
    ,o.trans_amt -- 交易金额
    ,o.trans_split_amt -- 交易金额(超限拆分)
    ,o.dtl_remark -- 明细备注
    ,o.employee_id -- 员工ID
    ,o.employee_name -- 员工姓名
    ,o.phone_no -- 员工电话
    ,o.cert_no -- 员工证件号码
    ,o.company_id -- 企业ID
    ,o.company_name -- 企业名称
    ,o.row_num -- 行号
    ,o.create_timestamp -- 创建时间戳
    ,o.update_timestamp -- 更新时间戳
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
from ${iol_schema}.mpcs_a1wsp_batch_dtl_info_bk o
    left join ${iol_schema}.mpcs_a1wsp_batch_dtl_info_op n
        on
            o.detail_no = n.detail_no
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.mpcs_a1wsp_batch_dtl_info_cl d
        on
            o.detail_no = d.detail_no
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
--truncate table ${iol_schema}.mpcs_a1wsp_batch_dtl_info;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('mpcs_a1wsp_batch_dtl_info') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.mpcs_a1wsp_batch_dtl_info drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.mpcs_a1wsp_batch_dtl_info add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.mpcs_a1wsp_batch_dtl_info exchange partition p_${batch_date} with table ${iol_schema}.mpcs_a1wsp_batch_dtl_info_cl;
alter table ${iol_schema}.mpcs_a1wsp_batch_dtl_info exchange partition p_20991231 with table ${iol_schema}.mpcs_a1wsp_batch_dtl_info_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.mpcs_a1wsp_batch_dtl_info to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.mpcs_a1wsp_batch_dtl_info_op purge;
drop table ${iol_schema}.mpcs_a1wsp_batch_dtl_info_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.mpcs_a1wsp_batch_dtl_info_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'mpcs_a1wsp_batch_dtl_info',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
