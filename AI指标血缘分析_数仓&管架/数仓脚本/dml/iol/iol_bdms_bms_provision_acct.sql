/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_bdms_bms_provision_acct
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
create table ${iol_schema}.bdms_bms_provision_acct_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.bdms_bms_provision_acct;

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.bdms_bms_provision_acct_op purge;
drop table ${iol_schema}.bdms_bms_provision_acct_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.bdms_bms_provision_acct_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.bdms_bms_provision_acct where 0=1;

create table ${iol_schema}.bdms_bms_provision_acct_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.bdms_bms_provision_acct where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.bdms_bms_provision_acct_cl(
            prov_acct_id -- 计提记账表ID
            ,top_bank_no -- 所属总行行号
            ,brch_no -- 机构号
            ,dr_subject_no -- 借科目
            ,cr_subject_no -- 贷科目
            ,prov_interest -- 计提利息
            ,acct_dt -- 计账日
            ,is_success -- 是否记账成功
            ,prod_no -- 业务产品号
            ,create_time -- 创建时间
            ,reserve1 -- 保留字段1
            ,reserve2 -- 保留字段2
            ,reserve3 -- 保留字段3
            ,draft_number -- 票号
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.bdms_bms_provision_acct_op(
            prov_acct_id -- 计提记账表ID
            ,top_bank_no -- 所属总行行号
            ,brch_no -- 机构号
            ,dr_subject_no -- 借科目
            ,cr_subject_no -- 贷科目
            ,prov_interest -- 计提利息
            ,acct_dt -- 计账日
            ,is_success -- 是否记账成功
            ,prod_no -- 业务产品号
            ,create_time -- 创建时间
            ,reserve1 -- 保留字段1
            ,reserve2 -- 保留字段2
            ,reserve3 -- 保留字段3
            ,draft_number -- 票号
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.prov_acct_id, o.prov_acct_id) as prov_acct_id -- 计提记账表ID
    ,nvl(n.top_bank_no, o.top_bank_no) as top_bank_no -- 所属总行行号
    ,nvl(n.brch_no, o.brch_no) as brch_no -- 机构号
    ,nvl(n.dr_subject_no, o.dr_subject_no) as dr_subject_no -- 借科目
    ,nvl(n.cr_subject_no, o.cr_subject_no) as cr_subject_no -- 贷科目
    ,nvl(n.prov_interest, o.prov_interest) as prov_interest -- 计提利息
    ,nvl(n.acct_dt, o.acct_dt) as acct_dt -- 计账日
    ,nvl(n.is_success, o.is_success) as is_success -- 是否记账成功
    ,nvl(n.prod_no, o.prod_no) as prod_no -- 业务产品号
    ,nvl(n.create_time, o.create_time) as create_time -- 创建时间
    ,nvl(n.reserve1, o.reserve1) as reserve1 -- 保留字段1
    ,nvl(n.reserve2, o.reserve2) as reserve2 -- 保留字段2
    ,nvl(n.reserve3, o.reserve3) as reserve3 -- 保留字段3
    ,nvl(n.draft_number, o.draft_number) as draft_number -- 票号
    ,case when
            n.prov_acct_id is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.prov_acct_id is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.prov_acct_id is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.bdms_bms_provision_acct_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.bdms_bms_provision_acct where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.prov_acct_id = n.prov_acct_id
where (
        o.prov_acct_id is null
    )
    or (
        n.prov_acct_id is null
    )
    or (
        o.top_bank_no <> n.top_bank_no
        or o.brch_no <> n.brch_no
        or o.dr_subject_no <> n.dr_subject_no
        or o.cr_subject_no <> n.cr_subject_no
        or o.prov_interest <> n.prov_interest
        or o.acct_dt <> n.acct_dt
        or o.is_success <> n.is_success
        or o.prod_no <> n.prod_no
        or o.create_time <> n.create_time
        or o.reserve1 <> n.reserve1
        or o.reserve2 <> n.reserve2
        or o.reserve3 <> n.reserve3
        or o.draft_number <> n.draft_number
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.bdms_bms_provision_acct_cl(
            prov_acct_id -- 计提记账表ID
            ,top_bank_no -- 所属总行行号
            ,brch_no -- 机构号
            ,dr_subject_no -- 借科目
            ,cr_subject_no -- 贷科目
            ,prov_interest -- 计提利息
            ,acct_dt -- 计账日
            ,is_success -- 是否记账成功
            ,prod_no -- 业务产品号
            ,create_time -- 创建时间
            ,reserve1 -- 保留字段1
            ,reserve2 -- 保留字段2
            ,reserve3 -- 保留字段3
            ,draft_number -- 票号
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.bdms_bms_provision_acct_op(
            prov_acct_id -- 计提记账表ID
            ,top_bank_no -- 所属总行行号
            ,brch_no -- 机构号
            ,dr_subject_no -- 借科目
            ,cr_subject_no -- 贷科目
            ,prov_interest -- 计提利息
            ,acct_dt -- 计账日
            ,is_success -- 是否记账成功
            ,prod_no -- 业务产品号
            ,create_time -- 创建时间
            ,reserve1 -- 保留字段1
            ,reserve2 -- 保留字段2
            ,reserve3 -- 保留字段3
            ,draft_number -- 票号
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.prov_acct_id -- 计提记账表ID
    ,o.top_bank_no -- 所属总行行号
    ,o.brch_no -- 机构号
    ,o.dr_subject_no -- 借科目
    ,o.cr_subject_no -- 贷科目
    ,o.prov_interest -- 计提利息
    ,o.acct_dt -- 计账日
    ,o.is_success -- 是否记账成功
    ,o.prod_no -- 业务产品号
    ,o.create_time -- 创建时间
    ,o.reserve1 -- 保留字段1
    ,o.reserve2 -- 保留字段2
    ,o.reserve3 -- 保留字段3
    ,o.draft_number -- 票号
    ,o.start_dt -- 开始时间
    ,case when n.start_dt is not null then to_date('${batch_date}', 'yyyymmdd')
          when o.end_dt >= to_date('${batch_date}','yyyymmdd') then to_date('20991231','yyyymmdd')
          else o.end_dt
     end as end_dt -- 结束时间
    ,o.id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from ${iol_schema}.bdms_bms_provision_acct_bk o
    left join ${iol_schema}.bdms_bms_provision_acct_op n
        on
            o.prov_acct_id = n.prov_acct_id
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.bdms_bms_provision_acct_cl d
        on
            o.prov_acct_id = d.prov_acct_id
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
-- truncate table ${iol_schema}.bdms_bms_provision_acct;

-- 4.2 exchange partition
alter table ${iol_schema}.bdms_bms_provision_acct exchange partition p_19000101 with table ${iol_schema}.bdms_bms_provision_acct_cl;
alter table ${iol_schema}.bdms_bms_provision_acct exchange partition p_20991231 with table ${iol_schema}.bdms_bms_provision_acct_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.bdms_bms_provision_acct to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.bdms_bms_provision_acct_op purge;
drop table ${iol_schema}.bdms_bms_provision_acct_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.bdms_bms_provision_acct_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'bdms_bms_provision_acct',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
