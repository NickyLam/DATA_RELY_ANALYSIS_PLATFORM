/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_ctms_vi_tbs_account_cptys_info
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
create table ${iol_schema}.ctms_vi_tbs_account_cptys_info_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.ctms_vi_tbs_account_cptys_info
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.ctms_vi_tbs_account_cptys_info_op purge;
drop table ${iol_schema}.ctms_vi_tbs_account_cptys_info_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ctms_vi_tbs_account_cptys_info_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.ctms_vi_tbs_account_cptys_info where 0=1;

create table ${iol_schema}.ctms_vi_tbs_account_cptys_info_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.ctms_vi_tbs_account_cptys_info where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.ctms_vi_tbs_account_cptys_info_cl(
            core_tran_flow_num -- 全局流水号
            ,biz_seq_num -- 系统流水号
            ,seq -- 交易序号
            ,tx_cntpty_acct_num -- 交易对手账号
            ,tx_cntpty_name -- 交易对手名称
            ,cntpty_fin_inst_brac_cd -- 交易对手行号
            ,cntpty_fin_inst_brac_name -- 交易对手行名
            ,dist -- 对手银行所在地行政区划
            ,tx_cntpty_cert_type -- 交易对手证件类型
            ,tx_cntpty_cert_no -- 交易对手证件号码
            ,cpty_type -- 交易对手行号类型
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.ctms_vi_tbs_account_cptys_info_op(
            core_tran_flow_num -- 全局流水号
            ,biz_seq_num -- 系统流水号
            ,seq -- 交易序号
            ,tx_cntpty_acct_num -- 交易对手账号
            ,tx_cntpty_name -- 交易对手名称
            ,cntpty_fin_inst_brac_cd -- 交易对手行号
            ,cntpty_fin_inst_brac_name -- 交易对手行名
            ,dist -- 对手银行所在地行政区划
            ,tx_cntpty_cert_type -- 交易对手证件类型
            ,tx_cntpty_cert_no -- 交易对手证件号码
            ,cpty_type -- 交易对手行号类型
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.core_tran_flow_num, o.core_tran_flow_num) as core_tran_flow_num -- 全局流水号
    ,nvl(n.biz_seq_num, o.biz_seq_num) as biz_seq_num -- 系统流水号
    ,nvl(n.seq, o.seq) as seq -- 交易序号
    ,nvl(n.tx_cntpty_acct_num, o.tx_cntpty_acct_num) as tx_cntpty_acct_num -- 交易对手账号
    ,nvl(n.tx_cntpty_name, o.tx_cntpty_name) as tx_cntpty_name -- 交易对手名称
    ,nvl(n.cntpty_fin_inst_brac_cd, o.cntpty_fin_inst_brac_cd) as cntpty_fin_inst_brac_cd -- 交易对手行号
    ,nvl(n.cntpty_fin_inst_brac_name, o.cntpty_fin_inst_brac_name) as cntpty_fin_inst_brac_name -- 交易对手行名
    ,nvl(n.dist, o.dist) as dist -- 对手银行所在地行政区划
    ,nvl(n.tx_cntpty_cert_type, o.tx_cntpty_cert_type) as tx_cntpty_cert_type -- 交易对手证件类型
    ,nvl(n.tx_cntpty_cert_no, o.tx_cntpty_cert_no) as tx_cntpty_cert_no -- 交易对手证件号码
    ,nvl(n.cpty_type, o.cpty_type) as cpty_type -- 交易对手行号类型
    ,case when
            n.seq is null
            and n.cntpty_fin_inst_brac_cd  is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.seq is null
            and n.cntpty_fin_inst_brac_cd  is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.seq is null
            and n.cntpty_fin_inst_brac_cd  is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.ctms_vi_tbs_account_cptys_info_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.ctms_vi_tbs_account_cptys_info where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.seq = n.seq
            and o.cntpty_fin_inst_brac_cd = n.cntpty_fin_inst_brac_cd
where (
        o.seq is null
        and o.cntpty_fin_inst_brac_cd is null
    )
    or (
        n.seq is null
        and n.cntpty_fin_inst_brac_cd is null
    )
    or (
        o.core_tran_flow_num <> n.core_tran_flow_num
        or o.biz_seq_num <> n.biz_seq_num
        or o.tx_cntpty_acct_num <> n.tx_cntpty_acct_num
        or o.tx_cntpty_name <> n.tx_cntpty_name
        or o.cntpty_fin_inst_brac_cd <> n.cntpty_fin_inst_brac_cd
        or o.cntpty_fin_inst_brac_name <> n.cntpty_fin_inst_brac_name
        or o.dist <> n.dist
        or o.tx_cntpty_cert_type <> n.tx_cntpty_cert_type
        or o.tx_cntpty_cert_no <> n.tx_cntpty_cert_no
        or o.cpty_type <> n.cpty_type
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.ctms_vi_tbs_account_cptys_info_cl(
            core_tran_flow_num -- 全局流水号
            ,biz_seq_num -- 系统流水号
            ,seq -- 交易序号
            ,tx_cntpty_acct_num -- 交易对手账号
            ,tx_cntpty_name -- 交易对手名称
            ,cntpty_fin_inst_brac_cd -- 交易对手行号
            ,cntpty_fin_inst_brac_name -- 交易对手行名
            ,dist -- 对手银行所在地行政区划
            ,tx_cntpty_cert_type -- 交易对手证件类型
            ,tx_cntpty_cert_no -- 交易对手证件号码
            ,cpty_type -- 交易对手行号类型
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.ctms_vi_tbs_account_cptys_info_op(
            core_tran_flow_num -- 全局流水号
            ,biz_seq_num -- 系统流水号
            ,seq -- 交易序号
            ,tx_cntpty_acct_num -- 交易对手账号
            ,tx_cntpty_name -- 交易对手名称
            ,cntpty_fin_inst_brac_cd -- 交易对手行号
            ,cntpty_fin_inst_brac_name -- 交易对手行名
            ,dist -- 对手银行所在地行政区划
            ,tx_cntpty_cert_type -- 交易对手证件类型
            ,tx_cntpty_cert_no -- 交易对手证件号码
            ,cpty_type -- 交易对手行号类型
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.core_tran_flow_num -- 全局流水号
    ,o.biz_seq_num -- 系统流水号
    ,o.seq -- 交易序号
    ,o.tx_cntpty_acct_num -- 交易对手账号
    ,o.tx_cntpty_name -- 交易对手名称
    ,o.cntpty_fin_inst_brac_cd -- 交易对手行号
    ,o.cntpty_fin_inst_brac_name -- 交易对手行名
    ,o.dist -- 对手银行所在地行政区划
    ,o.tx_cntpty_cert_type -- 交易对手证件类型
    ,o.tx_cntpty_cert_no -- 交易对手证件号码
    ,o.cpty_type -- 交易对手行号类型
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
from ${iol_schema}.ctms_vi_tbs_account_cptys_info_bk o
    left join ${iol_schema}.ctms_vi_tbs_account_cptys_info_op n
        on
            o.seq = n.seq
            and o.cntpty_fin_inst_brac_cd = n.cntpty_fin_inst_brac_cd
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.ctms_vi_tbs_account_cptys_info_cl d
        on
            o.seq = d.seq
            and o.cntpty_fin_inst_brac_cd = d.cntpty_fin_inst_brac_cd
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
--truncate table ${iol_schema}.ctms_vi_tbs_account_cptys_info;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('ctms_vi_tbs_account_cptys_info') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.ctms_vi_tbs_account_cptys_info drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.ctms_vi_tbs_account_cptys_info add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.ctms_vi_tbs_account_cptys_info exchange partition p_${batch_date} with table ${iol_schema}.ctms_vi_tbs_account_cptys_info_cl;
alter table ${iol_schema}.ctms_vi_tbs_account_cptys_info exchange partition p_20991231 with table ${iol_schema}.ctms_vi_tbs_account_cptys_info_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.ctms_vi_tbs_account_cptys_info to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.ctms_vi_tbs_account_cptys_info_op purge;
drop table ${iol_schema}.ctms_vi_tbs_account_cptys_info_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.ctms_vi_tbs_account_cptys_info_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'ctms_vi_tbs_account_cptys_info',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
