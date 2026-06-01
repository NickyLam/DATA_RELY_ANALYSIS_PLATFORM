/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_scfs_scf_fnc_price_view
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
create table ${iol_schema}.scfs_scf_fnc_price_view_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.scfs_scf_fnc_price_view
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.scfs_scf_fnc_price_view_op purge;
drop table ${iol_schema}.scfs_scf_fnc_price_view_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.scfs_scf_fnc_price_view_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.scfs_scf_fnc_price_view where 0=1;

create table ${iol_schema}.scfs_scf_fnc_price_view_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.scfs_scf_fnc_price_view where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.scfs_scf_fnc_price_view_cl(
            out_acct_seq_num -- 出账流水号
            ,iou_id -- 借据编号
            ,pd_nm -- 产品名称
            ,ctr_id -- 合同编号
            ,fnc_jrnl_id -- 融资编号
            ,pric_ord_nbr -- 定价单号
            ,credit_aggreement -- 信贷合同编号
            ,cst_nm -- 融资企业名称
            ,core_entp_nm -- 核心企业名称
            ,ths_fnc_amt -- 融资金额
            ,iou_amt -- 借款金额
            ,fnc_dt -- 融资日期
            ,fnc_bg_dt -- 融资开始日期
            ,fnc_ex_dt -- 融资结束日期
            ,pcs_st_cd_nm -- 审批结果
            ,fns_st_cd_nm -- 融资状态
            ,is_used_ph -- 
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.scfs_scf_fnc_price_view_op(
            out_acct_seq_num -- 出账流水号
            ,iou_id -- 借据编号
            ,pd_nm -- 产品名称
            ,ctr_id -- 合同编号
            ,fnc_jrnl_id -- 融资编号
            ,pric_ord_nbr -- 定价单号
            ,credit_aggreement -- 信贷合同编号
            ,cst_nm -- 融资企业名称
            ,core_entp_nm -- 核心企业名称
            ,ths_fnc_amt -- 融资金额
            ,iou_amt -- 借款金额
            ,fnc_dt -- 融资日期
            ,fnc_bg_dt -- 融资开始日期
            ,fnc_ex_dt -- 融资结束日期
            ,pcs_st_cd_nm -- 审批结果
            ,fns_st_cd_nm -- 融资状态
            ,is_used_ph -- 
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.out_acct_seq_num, o.out_acct_seq_num) as out_acct_seq_num -- 出账流水号
    ,nvl(n.iou_id, o.iou_id) as iou_id -- 借据编号
    ,nvl(n.pd_nm, o.pd_nm) as pd_nm -- 产品名称
    ,nvl(n.ctr_id, o.ctr_id) as ctr_id -- 合同编号
    ,nvl(n.fnc_jrnl_id, o.fnc_jrnl_id) as fnc_jrnl_id -- 融资编号
    ,nvl(n.pric_ord_nbr, o.pric_ord_nbr) as pric_ord_nbr -- 定价单号
    ,nvl(n.credit_aggreement, o.credit_aggreement) as credit_aggreement -- 信贷合同编号
    ,nvl(n.cst_nm, o.cst_nm) as cst_nm -- 融资企业名称
    ,nvl(n.core_entp_nm, o.core_entp_nm) as core_entp_nm -- 核心企业名称
    ,nvl(n.ths_fnc_amt, o.ths_fnc_amt) as ths_fnc_amt -- 融资金额
    ,nvl(n.iou_amt, o.iou_amt) as iou_amt -- 借款金额
    ,nvl(n.fnc_dt, o.fnc_dt) as fnc_dt -- 融资日期
    ,nvl(n.fnc_bg_dt, o.fnc_bg_dt) as fnc_bg_dt -- 融资开始日期
    ,nvl(n.fnc_ex_dt, o.fnc_ex_dt) as fnc_ex_dt -- 融资结束日期
    ,nvl(n.pcs_st_cd_nm, o.pcs_st_cd_nm) as pcs_st_cd_nm -- 审批结果
    ,nvl(n.fns_st_cd_nm, o.fns_st_cd_nm) as fns_st_cd_nm -- 融资状态
    ,nvl(n.is_used_ph, o.is_used_ph) as is_used_ph -- 
    ,case when
            n.iou_id is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.iou_id is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.iou_id is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.scfs_scf_fnc_price_view_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.scfs_scf_fnc_price_view where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.iou_id = n.iou_id
where (
        o.iou_id is null
    )
    or (
        n.iou_id is null
    )
    or (
        o.out_acct_seq_num <> n.out_acct_seq_num
        or o.pd_nm <> n.pd_nm
        or o.ctr_id <> n.ctr_id
        or o.fnc_jrnl_id <> n.fnc_jrnl_id
        or o.pric_ord_nbr <> n.pric_ord_nbr
        or o.credit_aggreement <> n.credit_aggreement
        or o.cst_nm <> n.cst_nm
        or o.core_entp_nm <> n.core_entp_nm
        or o.ths_fnc_amt <> n.ths_fnc_amt
        or o.iou_amt <> n.iou_amt
        or o.fnc_dt <> n.fnc_dt
        or o.fnc_bg_dt <> n.fnc_bg_dt
        or o.fnc_ex_dt <> n.fnc_ex_dt
        or o.pcs_st_cd_nm <> n.pcs_st_cd_nm
        or o.fns_st_cd_nm <> n.fns_st_cd_nm
        or o.is_used_ph <> n.is_used_ph
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.scfs_scf_fnc_price_view_cl(
            out_acct_seq_num -- 出账流水号
            ,iou_id -- 借据编号
            ,pd_nm -- 产品名称
            ,ctr_id -- 合同编号
            ,fnc_jrnl_id -- 融资编号
            ,pric_ord_nbr -- 定价单号
            ,credit_aggreement -- 信贷合同编号
            ,cst_nm -- 融资企业名称
            ,core_entp_nm -- 核心企业名称
            ,ths_fnc_amt -- 融资金额
            ,iou_amt -- 借款金额
            ,fnc_dt -- 融资日期
            ,fnc_bg_dt -- 融资开始日期
            ,fnc_ex_dt -- 融资结束日期
            ,pcs_st_cd_nm -- 审批结果
            ,fns_st_cd_nm -- 融资状态
            ,is_used_ph -- 
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.scfs_scf_fnc_price_view_op(
            out_acct_seq_num -- 出账流水号
            ,iou_id -- 借据编号
            ,pd_nm -- 产品名称
            ,ctr_id -- 合同编号
            ,fnc_jrnl_id -- 融资编号
            ,pric_ord_nbr -- 定价单号
            ,credit_aggreement -- 信贷合同编号
            ,cst_nm -- 融资企业名称
            ,core_entp_nm -- 核心企业名称
            ,ths_fnc_amt -- 融资金额
            ,iou_amt -- 借款金额
            ,fnc_dt -- 融资日期
            ,fnc_bg_dt -- 融资开始日期
            ,fnc_ex_dt -- 融资结束日期
            ,pcs_st_cd_nm -- 审批结果
            ,fns_st_cd_nm -- 融资状态
            ,is_used_ph -- 
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.out_acct_seq_num -- 出账流水号
    ,o.iou_id -- 借据编号
    ,o.pd_nm -- 产品名称
    ,o.ctr_id -- 合同编号
    ,o.fnc_jrnl_id -- 融资编号
    ,o.pric_ord_nbr -- 定价单号
    ,o.credit_aggreement -- 信贷合同编号
    ,o.cst_nm -- 融资企业名称
    ,o.core_entp_nm -- 核心企业名称
    ,o.ths_fnc_amt -- 融资金额
    ,o.iou_amt -- 借款金额
    ,o.fnc_dt -- 融资日期
    ,o.fnc_bg_dt -- 融资开始日期
    ,o.fnc_ex_dt -- 融资结束日期
    ,o.pcs_st_cd_nm -- 审批结果
    ,o.fns_st_cd_nm -- 融资状态
    ,o.is_used_ph -- 
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
from ${iol_schema}.scfs_scf_fnc_price_view_bk o
    left join ${iol_schema}.scfs_scf_fnc_price_view_op n
        on
            o.iou_id = n.iou_id
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.scfs_scf_fnc_price_view_cl d
        on
            o.iou_id = d.iou_id
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
--truncate table ${iol_schema}.scfs_scf_fnc_price_view;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('scfs_scf_fnc_price_view') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.scfs_scf_fnc_price_view drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.scfs_scf_fnc_price_view add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.scfs_scf_fnc_price_view exchange partition p_${batch_date} with table ${iol_schema}.scfs_scf_fnc_price_view_cl;
alter table ${iol_schema}.scfs_scf_fnc_price_view exchange partition p_20991231 with table ${iol_schema}.scfs_scf_fnc_price_view_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.scfs_scf_fnc_price_view to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.scfs_scf_fnc_price_view_op purge;
drop table ${iol_schema}.scfs_scf_fnc_price_view_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.scfs_scf_fnc_price_view_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'scfs_scf_fnc_price_view',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
