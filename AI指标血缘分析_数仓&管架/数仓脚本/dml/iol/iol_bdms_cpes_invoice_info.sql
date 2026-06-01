/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_bdms_cpes_invoice_info
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
create table ${iol_schema}.bdms_cpes_invoice_info_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.bdms_cpes_invoice_info
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.bdms_cpes_invoice_info_op purge;
drop table ${iol_schema}.bdms_cpes_invoice_info_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.bdms_cpes_invoice_info_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.bdms_cpes_invoice_info where 0=1;

create table ${iol_schema}.bdms_cpes_invoice_info_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.bdms_cpes_invoice_info where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.bdms_cpes_invoice_info_cl(
            id -- ID
            ,product_no -- 产品类型编号
            ,contract_id -- 协议ID
            ,branch_no -- 交易机构编号
            ,draft_number -- 票据号码
            ,invoice_code -- 发票代码
            ,invoice_number -- 发票号码
            ,invoice_btno -- 发票批次号
            ,invoice_date -- 发票日期
            ,scale -- 占用比例
            ,invoice_amount -- 发票金额
            ,draft_ocp_amount -- 票据占用金额
            ,disaffirm_status -- 状态
            ,invoice_curcd -- 发票据代码
            ,invoice_type -- 发票据类型
            ,remark -- 澶囨敞
            ,checkcode -- 校验码
            ,create_time -- 创建时间
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.bdms_cpes_invoice_info_op(
            id -- ID
            ,product_no -- 产品类型编号
            ,contract_id -- 协议ID
            ,branch_no -- 交易机构编号
            ,draft_number -- 票据号码
            ,invoice_code -- 发票代码
            ,invoice_number -- 发票号码
            ,invoice_btno -- 发票批次号
            ,invoice_date -- 发票日期
            ,scale -- 占用比例
            ,invoice_amount -- 发票金额
            ,draft_ocp_amount -- 票据占用金额
            ,disaffirm_status -- 状态
            ,invoice_curcd -- 发票据代码
            ,invoice_type -- 发票据类型
            ,remark -- 澶囨敞
            ,checkcode -- 校验码
            ,create_time -- 创建时间
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.id, o.id) as id -- ID
    ,nvl(n.product_no, o.product_no) as product_no -- 产品类型编号
    ,nvl(n.contract_id, o.contract_id) as contract_id -- 协议ID
    ,nvl(n.branch_no, o.branch_no) as branch_no -- 交易机构编号
    ,nvl(n.draft_number, o.draft_number) as draft_number -- 票据号码
    ,nvl(n.invoice_code, o.invoice_code) as invoice_code -- 发票代码
    ,nvl(n.invoice_number, o.invoice_number) as invoice_number -- 发票号码
    ,nvl(n.invoice_btno, o.invoice_btno) as invoice_btno -- 发票批次号
    ,nvl(n.invoice_date, o.invoice_date) as invoice_date -- 发票日期
    ,nvl(n.scale, o.scale) as scale -- 占用比例
    ,nvl(n.invoice_amount, o.invoice_amount) as invoice_amount -- 发票金额
    ,nvl(n.draft_ocp_amount, o.draft_ocp_amount) as draft_ocp_amount -- 票据占用金额
    ,nvl(n.disaffirm_status, o.disaffirm_status) as disaffirm_status -- 状态
    ,nvl(n.invoice_curcd, o.invoice_curcd) as invoice_curcd -- 发票据代码
    ,nvl(n.invoice_type, o.invoice_type) as invoice_type -- 发票据类型
    ,nvl(n.remark, o.remark) as remark -- 澶囨敞
    ,nvl(n.checkcode, o.checkcode) as checkcode -- 校验码
    ,nvl(n.create_time, o.create_time) as create_time -- 创建时间
    ,case when
            n.id is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.id is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.id is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.bdms_cpes_invoice_info_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.bdms_cpes_invoice_info where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.id = n.id
where (
        o.id is null
    )
    or (
        n.id is null
    )
    or (
        o.product_no <> n.product_no
        or o.contract_id <> n.contract_id
        or o.branch_no <> n.branch_no
        or o.draft_number <> n.draft_number
        or o.invoice_code <> n.invoice_code
        or o.invoice_number <> n.invoice_number
        or o.invoice_btno <> n.invoice_btno
        or o.invoice_date <> n.invoice_date
        or o.scale <> n.scale
        or o.invoice_amount <> n.invoice_amount
        or o.draft_ocp_amount <> n.draft_ocp_amount
        or o.disaffirm_status <> n.disaffirm_status
        or o.invoice_curcd <> n.invoice_curcd
        or o.invoice_type <> n.invoice_type
        or o.remark <> n.remark
        or o.checkcode <> n.checkcode
        or o.create_time <> n.create_time
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.bdms_cpes_invoice_info_cl(
            id -- ID
            ,product_no -- 产品类型编号
            ,contract_id -- 协议ID
            ,branch_no -- 交易机构编号
            ,draft_number -- 票据号码
            ,invoice_code -- 发票代码
            ,invoice_number -- 发票号码
            ,invoice_btno -- 发票批次号
            ,invoice_date -- 发票日期
            ,scale -- 占用比例
            ,invoice_amount -- 发票金额
            ,draft_ocp_amount -- 票据占用金额
            ,disaffirm_status -- 状态
            ,invoice_curcd -- 发票据代码
            ,invoice_type -- 发票据类型
            ,remark -- 澶囨敞
            ,checkcode -- 校验码
            ,create_time -- 创建时间
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.bdms_cpes_invoice_info_op(
            id -- ID
            ,product_no -- 产品类型编号
            ,contract_id -- 协议ID
            ,branch_no -- 交易机构编号
            ,draft_number -- 票据号码
            ,invoice_code -- 发票代码
            ,invoice_number -- 发票号码
            ,invoice_btno -- 发票批次号
            ,invoice_date -- 发票日期
            ,scale -- 占用比例
            ,invoice_amount -- 发票金额
            ,draft_ocp_amount -- 票据占用金额
            ,disaffirm_status -- 状态
            ,invoice_curcd -- 发票据代码
            ,invoice_type -- 发票据类型
            ,remark -- 澶囨敞
            ,checkcode -- 校验码
            ,create_time -- 创建时间
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.id -- ID
    ,o.product_no -- 产品类型编号
    ,o.contract_id -- 协议ID
    ,o.branch_no -- 交易机构编号
    ,o.draft_number -- 票据号码
    ,o.invoice_code -- 发票代码
    ,o.invoice_number -- 发票号码
    ,o.invoice_btno -- 发票批次号
    ,o.invoice_date -- 发票日期
    ,o.scale -- 占用比例
    ,o.invoice_amount -- 发票金额
    ,o.draft_ocp_amount -- 票据占用金额
    ,o.disaffirm_status -- 状态
    ,o.invoice_curcd -- 发票据代码
    ,o.invoice_type -- 发票据类型
    ,o.remark -- 澶囨敞
    ,o.checkcode -- 校验码
    ,o.create_time -- 创建时间
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
from ${iol_schema}.bdms_cpes_invoice_info_bk o
    left join ${iol_schema}.bdms_cpes_invoice_info_op n
        on
            o.id = n.id
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.bdms_cpes_invoice_info_cl d
        on
            o.id = d.id
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
--truncate table ${iol_schema}.bdms_cpes_invoice_info;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('bdms_cpes_invoice_info') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.bdms_cpes_invoice_info drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.bdms_cpes_invoice_info add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.bdms_cpes_invoice_info exchange partition p_${batch_date} with table ${iol_schema}.bdms_cpes_invoice_info_cl;
alter table ${iol_schema}.bdms_cpes_invoice_info exchange partition p_20991231 with table ${iol_schema}.bdms_cpes_invoice_info_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.bdms_cpes_invoice_info to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.bdms_cpes_invoice_info_op purge;
drop table ${iol_schema}.bdms_cpes_invoice_info_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.bdms_cpes_invoice_info_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'bdms_cpes_invoice_info',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
