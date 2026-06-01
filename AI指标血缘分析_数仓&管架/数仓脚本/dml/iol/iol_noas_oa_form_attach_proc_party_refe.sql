/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_noas_oa_form_attach_proc_party_refe
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
create table ${iol_schema}.noas_oa_form_attach_proc_party_refe_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.noas_oa_form_attach_proc_party_refe;

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.noas_oa_form_attach_proc_party_refe_op purge;
drop table ${iol_schema}.noas_oa_form_attach_proc_party_refe_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.noas_oa_form_attach_proc_party_refe_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.noas_oa_form_attach_proc_party_refe where 0=1;

create table ${iol_schema}.noas_oa_form_attach_proc_party_refe_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.noas_oa_form_attach_proc_party_refe where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.noas_oa_form_attach_proc_party_refe_cl(
            reference_id -- 主键
            ,attachment_id -- 附件ID
            ,process_ins_id -- 流程实例ID
            ,form_def_id -- 表单ID
            ,last_updated_stamp -- bosent自带最后修改时间
            ,last_updated_tx_stamp -- bosent自带最后修改时间
            ,created_stamp -- bosent自带创建时间
            ,created_tx_stamp -- bosent自带创建时间
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.noas_oa_form_attach_proc_party_refe_op(
            reference_id -- 主键
            ,attachment_id -- 附件ID
            ,process_ins_id -- 流程实例ID
            ,form_def_id -- 表单ID
            ,last_updated_stamp -- bosent自带最后修改时间
            ,last_updated_tx_stamp -- bosent自带最后修改时间
            ,created_stamp -- bosent自带创建时间
            ,created_tx_stamp -- bosent自带创建时间
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.reference_id, o.reference_id) as reference_id -- 主键
    ,nvl(n.attachment_id, o.attachment_id) as attachment_id -- 附件ID
    ,nvl(n.process_ins_id, o.process_ins_id) as process_ins_id -- 流程实例ID
    ,nvl(n.form_def_id, o.form_def_id) as form_def_id -- 表单ID
    ,nvl(n.last_updated_stamp, o.last_updated_stamp) as last_updated_stamp -- bosent自带最后修改时间
    ,nvl(n.last_updated_tx_stamp, o.last_updated_tx_stamp) as last_updated_tx_stamp -- bosent自带最后修改时间
    ,nvl(n.created_stamp, o.created_stamp) as created_stamp -- bosent自带创建时间
    ,nvl(n.created_tx_stamp, o.created_tx_stamp) as created_tx_stamp -- bosent自带创建时间
    ,case when
            n.reference_id is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.reference_id is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.reference_id is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.noas_oa_form_attach_proc_party_refe_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.noas_oa_form_attach_proc_party_refe where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.reference_id = n.reference_id
where (
        o.reference_id is null
    )
    or (
        n.reference_id is null
    )
    or (
        o.attachment_id <> n.attachment_id
        or o.process_ins_id <> n.process_ins_id
        or o.form_def_id <> n.form_def_id
        or o.last_updated_stamp <> n.last_updated_stamp
        or o.last_updated_tx_stamp <> n.last_updated_tx_stamp
        or o.created_stamp <> n.created_stamp
        or o.created_tx_stamp <> n.created_tx_stamp
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.noas_oa_form_attach_proc_party_refe_cl(
            reference_id -- 主键
            ,attachment_id -- 附件ID
            ,process_ins_id -- 流程实例ID
            ,form_def_id -- 表单ID
            ,last_updated_stamp -- bosent自带最后修改时间
            ,last_updated_tx_stamp -- bosent自带最后修改时间
            ,created_stamp -- bosent自带创建时间
            ,created_tx_stamp -- bosent自带创建时间
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.noas_oa_form_attach_proc_party_refe_op(
            reference_id -- 主键
            ,attachment_id -- 附件ID
            ,process_ins_id -- 流程实例ID
            ,form_def_id -- 表单ID
            ,last_updated_stamp -- bosent自带最后修改时间
            ,last_updated_tx_stamp -- bosent自带最后修改时间
            ,created_stamp -- bosent自带创建时间
            ,created_tx_stamp -- bosent自带创建时间
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.reference_id -- 主键
    ,o.attachment_id -- 附件ID
    ,o.process_ins_id -- 流程实例ID
    ,o.form_def_id -- 表单ID
    ,o.last_updated_stamp -- bosent自带最后修改时间
    ,o.last_updated_tx_stamp -- bosent自带最后修改时间
    ,o.created_stamp -- bosent自带创建时间
    ,o.created_tx_stamp -- bosent自带创建时间
    ,o.start_dt -- 开始时间
    ,case when n.start_dt is not null then to_date('${batch_date}', 'yyyymmdd')
          when o.end_dt >= to_date('${batch_date}','yyyymmdd') then to_date('20991231','yyyymmdd')
          else o.end_dt
     end as end_dt -- 结束时间
    ,o.id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from ${iol_schema}.noas_oa_form_attach_proc_party_refe_bk o
    left join ${iol_schema}.noas_oa_form_attach_proc_party_refe_op n
        on
            o.reference_id = n.reference_id
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.noas_oa_form_attach_proc_party_refe_cl d
        on
            o.reference_id = d.reference_id
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
-- truncate table ${iol_schema}.noas_oa_form_attach_proc_party_refe;

-- 4.2 exchange partition
alter table ${iol_schema}.noas_oa_form_attach_proc_party_refe exchange partition p_19000101 with table ${iol_schema}.noas_oa_form_attach_proc_party_refe_cl;
alter table ${iol_schema}.noas_oa_form_attach_proc_party_refe exchange partition p_20991231 with table ${iol_schema}.noas_oa_form_attach_proc_party_refe_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.noas_oa_form_attach_proc_party_refe to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.noas_oa_form_attach_proc_party_refe_op purge;
drop table ${iol_schema}.noas_oa_form_attach_proc_party_refe_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.noas_oa_form_attach_proc_party_refe_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'noas_oa_form_attach_proc_party_refe',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
