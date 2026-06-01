/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_ncbs_cif_category_type
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
create table ${iol_schema}.ncbs_cif_category_type_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.ncbs_cif_category_type
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.ncbs_cif_category_type_op purge;
drop table ${iol_schema}.ncbs_cif_category_type_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ncbs_cif_category_type_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.ncbs_cif_category_type where 0=1;

create table ${iol_schema}.ncbs_cif_category_type_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.ncbs_cif_category_type where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.ncbs_cif_category_type_cl(
            client_type -- 客户类型
            ,bank_flag -- 是否为银行
            ,broker_flag -- 是否为经纪人
            ,category_desc -- 客户细分类型描述
            ,category_type -- 存款人类别
            ,central_bank_flag -- 是否为中央银行
            ,company -- 法人
            ,corporation_flag -- 是否为企业标识
            ,fin_institution -- 金融机构标志
            ,government_flag -- 政府部门标志
            ,individual_flag -- 对公对私标志
            ,intl_institution_flag -- 国际组织标志
            ,join_collat_flag -- 联合体标志
            ,other_flag -- 是否是其他
            ,rep_office -- 是否为代表处
            ,libra_op_time -- libra执行次数
            ,tran_timestamp -- 交易时间戳
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.ncbs_cif_category_type_op(
            client_type -- 客户类型
            ,bank_flag -- 是否为银行
            ,broker_flag -- 是否为经纪人
            ,category_desc -- 客户细分类型描述
            ,category_type -- 存款人类别
            ,central_bank_flag -- 是否为中央银行
            ,company -- 法人
            ,corporation_flag -- 是否为企业标识
            ,fin_institution -- 金融机构标志
            ,government_flag -- 政府部门标志
            ,individual_flag -- 对公对私标志
            ,intl_institution_flag -- 国际组织标志
            ,join_collat_flag -- 联合体标志
            ,other_flag -- 是否是其他
            ,rep_office -- 是否为代表处
            ,libra_op_time -- libra执行次数
            ,tran_timestamp -- 交易时间戳
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.client_type, o.client_type) as client_type -- 客户类型
    ,nvl(n.bank_flag, o.bank_flag) as bank_flag -- 是否为银行
    ,nvl(n.broker_flag, o.broker_flag) as broker_flag -- 是否为经纪人
    ,nvl(n.category_desc, o.category_desc) as category_desc -- 客户细分类型描述
    ,nvl(n.category_type, o.category_type) as category_type -- 存款人类别
    ,nvl(n.central_bank_flag, o.central_bank_flag) as central_bank_flag -- 是否为中央银行
    ,nvl(n.company, o.company) as company -- 法人
    ,nvl(n.corporation_flag, o.corporation_flag) as corporation_flag -- 是否为企业标识
    ,nvl(n.fin_institution, o.fin_institution) as fin_institution -- 金融机构标志
    ,nvl(n.government_flag, o.government_flag) as government_flag -- 政府部门标志
    ,nvl(n.individual_flag, o.individual_flag) as individual_flag -- 对公对私标志
    ,nvl(n.intl_institution_flag, o.intl_institution_flag) as intl_institution_flag -- 国际组织标志
    ,nvl(n.join_collat_flag, o.join_collat_flag) as join_collat_flag -- 联合体标志
    ,nvl(n.other_flag, o.other_flag) as other_flag -- 是否是其他
    ,nvl(n.rep_office, o.rep_office) as rep_office -- 是否为代表处
    ,nvl(n.libra_op_time, o.libra_op_time) as libra_op_time -- libra执行次数
    ,nvl(n.tran_timestamp, o.tran_timestamp) as tran_timestamp -- 交易时间戳
    ,case when
            n.category_type is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.category_type is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.category_type is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.ncbs_cif_category_type_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.ncbs_cif_category_type where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.category_type = n.category_type
where (
        o.category_type is null
    )
    or (
        n.category_type is null
    )
    or (
        o.client_type <> n.client_type
        or o.bank_flag <> n.bank_flag
        or o.broker_flag <> n.broker_flag
        or o.category_desc <> n.category_desc
        or o.central_bank_flag <> n.central_bank_flag
        or o.company <> n.company
        or o.corporation_flag <> n.corporation_flag
        or o.fin_institution <> n.fin_institution
        or o.government_flag <> n.government_flag
        or o.individual_flag <> n.individual_flag
        or o.intl_institution_flag <> n.intl_institution_flag
        or o.join_collat_flag <> n.join_collat_flag
        or o.other_flag <> n.other_flag
        or o.rep_office <> n.rep_office
        or o.libra_op_time <> n.libra_op_time
        or o.tran_timestamp <> n.tran_timestamp
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.ncbs_cif_category_type_cl(
            client_type -- 客户类型
            ,bank_flag -- 是否为银行
            ,broker_flag -- 是否为经纪人
            ,category_desc -- 客户细分类型描述
            ,category_type -- 存款人类别
            ,central_bank_flag -- 是否为中央银行
            ,company -- 法人
            ,corporation_flag -- 是否为企业标识
            ,fin_institution -- 金融机构标志
            ,government_flag -- 政府部门标志
            ,individual_flag -- 对公对私标志
            ,intl_institution_flag -- 国际组织标志
            ,join_collat_flag -- 联合体标志
            ,other_flag -- 是否是其他
            ,rep_office -- 是否为代表处
            ,libra_op_time -- libra执行次数
            ,tran_timestamp -- 交易时间戳
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.ncbs_cif_category_type_op(
            client_type -- 客户类型
            ,bank_flag -- 是否为银行
            ,broker_flag -- 是否为经纪人
            ,category_desc -- 客户细分类型描述
            ,category_type -- 存款人类别
            ,central_bank_flag -- 是否为中央银行
            ,company -- 法人
            ,corporation_flag -- 是否为企业标识
            ,fin_institution -- 金融机构标志
            ,government_flag -- 政府部门标志
            ,individual_flag -- 对公对私标志
            ,intl_institution_flag -- 国际组织标志
            ,join_collat_flag -- 联合体标志
            ,other_flag -- 是否是其他
            ,rep_office -- 是否为代表处
            ,libra_op_time -- libra执行次数
            ,tran_timestamp -- 交易时间戳
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.client_type -- 客户类型
    ,o.bank_flag -- 是否为银行
    ,o.broker_flag -- 是否为经纪人
    ,o.category_desc -- 客户细分类型描述
    ,o.category_type -- 存款人类别
    ,o.central_bank_flag -- 是否为中央银行
    ,o.company -- 法人
    ,o.corporation_flag -- 是否为企业标识
    ,o.fin_institution -- 金融机构标志
    ,o.government_flag -- 政府部门标志
    ,o.individual_flag -- 对公对私标志
    ,o.intl_institution_flag -- 国际组织标志
    ,o.join_collat_flag -- 联合体标志
    ,o.other_flag -- 是否是其他
    ,o.rep_office -- 是否为代表处
    ,o.libra_op_time -- libra执行次数
    ,o.tran_timestamp -- 交易时间戳
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
from ${iol_schema}.ncbs_cif_category_type_bk o
    left join ${iol_schema}.ncbs_cif_category_type_op n
        on
            o.category_type = n.category_type
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.ncbs_cif_category_type_cl d
        on
            o.category_type = d.category_type
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
--truncate table ${iol_schema}.ncbs_cif_category_type;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('ncbs_cif_category_type') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.ncbs_cif_category_type drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.ncbs_cif_category_type add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.ncbs_cif_category_type exchange partition p_${batch_date} with table ${iol_schema}.ncbs_cif_category_type_cl;
alter table ${iol_schema}.ncbs_cif_category_type exchange partition p_20991231 with table ${iol_schema}.ncbs_cif_category_type_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.ncbs_cif_category_type to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.ncbs_cif_category_type_op purge;
drop table ${iol_schema}.ncbs_cif_category_type_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.ncbs_cif_category_type_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'ncbs_cif_category_type',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
