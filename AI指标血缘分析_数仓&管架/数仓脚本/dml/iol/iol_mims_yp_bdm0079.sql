/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_mims_yp_bdm0079
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
create table ${iol_schema}.mims_yp_bdm0079_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.mims_yp_bdm0079
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.mims_yp_bdm0079_op purge;
drop table ${iol_schema}.mims_yp_bdm0079_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.mims_yp_bdm0079_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.mims_yp_bdm0079 where 0=1;

create table ${iol_schema}.mims_yp_bdm0079_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.mims_yp_bdm0079 where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.mims_yp_bdm0079_cl(
            sccode -- 押品编号
            ,bil_num -- 票据号码
            ,bil_amt -- 票据金额
            ,due_day -- 到期日
            ,acpt_row_num -- 承兑行行号
            ,acpt_row_bnk_nm -- 承兑行行名
            ,impa_dt -- 质押日期
            ,impa_fname -- 出质人全称
            ,impa_acct_num -- 出质人账号
            ,impa_open_bk_num -- 出质人开户行行号
            ,impa_open_bk_name -- 出质人开户行行名
            ,csld_soci_crdt_cd -- 出质人统一社会信用代码
            ,org_num -- 机构号
            ,pawn_open_bk_name -- 质权人开户行名
            ,flag -- 质押标识（0质押 1解质押）
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.mims_yp_bdm0079_op(
            sccode -- 押品编号
            ,bil_num -- 票据号码
            ,bil_amt -- 票据金额
            ,due_day -- 到期日
            ,acpt_row_num -- 承兑行行号
            ,acpt_row_bnk_nm -- 承兑行行名
            ,impa_dt -- 质押日期
            ,impa_fname -- 出质人全称
            ,impa_acct_num -- 出质人账号
            ,impa_open_bk_num -- 出质人开户行行号
            ,impa_open_bk_name -- 出质人开户行行名
            ,csld_soci_crdt_cd -- 出质人统一社会信用代码
            ,org_num -- 机构号
            ,pawn_open_bk_name -- 质权人开户行名
            ,flag -- 质押标识（0质押 1解质押）
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.sccode, o.sccode) as sccode -- 押品编号
    ,nvl(n.bil_num, o.bil_num) as bil_num -- 票据号码
    ,nvl(n.bil_amt, o.bil_amt) as bil_amt -- 票据金额
    ,nvl(n.due_day, o.due_day) as due_day -- 到期日
    ,nvl(n.acpt_row_num, o.acpt_row_num) as acpt_row_num -- 承兑行行号
    ,nvl(n.acpt_row_bnk_nm, o.acpt_row_bnk_nm) as acpt_row_bnk_nm -- 承兑行行名
    ,nvl(n.impa_dt, o.impa_dt) as impa_dt -- 质押日期
    ,nvl(n.impa_fname, o.impa_fname) as impa_fname -- 出质人全称
    ,nvl(n.impa_acct_num, o.impa_acct_num) as impa_acct_num -- 出质人账号
    ,nvl(n.impa_open_bk_num, o.impa_open_bk_num) as impa_open_bk_num -- 出质人开户行行号
    ,nvl(n.impa_open_bk_name, o.impa_open_bk_name) as impa_open_bk_name -- 出质人开户行行名
    ,nvl(n.csld_soci_crdt_cd, o.csld_soci_crdt_cd) as csld_soci_crdt_cd -- 出质人统一社会信用代码
    ,nvl(n.org_num, o.org_num) as org_num -- 机构号
    ,nvl(n.pawn_open_bk_name, o.pawn_open_bk_name) as pawn_open_bk_name -- 质权人开户行名
    ,nvl(n.flag, o.flag) as flag -- 质押标识（0质押 1解质押）
    ,case when
            n.sccode is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.sccode is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.sccode is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.mims_yp_bdm0079_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.mims_yp_bdm0079 where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.sccode = n.sccode
where (
        o.sccode is null
    )
    or (
        n.sccode is null
    )
    or (
        o.bil_num <> n.bil_num
        or o.bil_amt <> n.bil_amt
        or o.due_day <> n.due_day
        or o.acpt_row_num <> n.acpt_row_num
        or o.acpt_row_bnk_nm <> n.acpt_row_bnk_nm
        or o.impa_dt <> n.impa_dt
        or o.impa_fname <> n.impa_fname
        or o.impa_acct_num <> n.impa_acct_num
        or o.impa_open_bk_num <> n.impa_open_bk_num
        or o.impa_open_bk_name <> n.impa_open_bk_name
        or o.csld_soci_crdt_cd <> n.csld_soci_crdt_cd
        or o.org_num <> n.org_num
        or o.pawn_open_bk_name <> n.pawn_open_bk_name
        or o.flag <> n.flag
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.mims_yp_bdm0079_cl(
            sccode -- 押品编号
            ,bil_num -- 票据号码
            ,bil_amt -- 票据金额
            ,due_day -- 到期日
            ,acpt_row_num -- 承兑行行号
            ,acpt_row_bnk_nm -- 承兑行行名
            ,impa_dt -- 质押日期
            ,impa_fname -- 出质人全称
            ,impa_acct_num -- 出质人账号
            ,impa_open_bk_num -- 出质人开户行行号
            ,impa_open_bk_name -- 出质人开户行行名
            ,csld_soci_crdt_cd -- 出质人统一社会信用代码
            ,org_num -- 机构号
            ,pawn_open_bk_name -- 质权人开户行名
            ,flag -- 质押标识（0质押 1解质押）
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.mims_yp_bdm0079_op(
            sccode -- 押品编号
            ,bil_num -- 票据号码
            ,bil_amt -- 票据金额
            ,due_day -- 到期日
            ,acpt_row_num -- 承兑行行号
            ,acpt_row_bnk_nm -- 承兑行行名
            ,impa_dt -- 质押日期
            ,impa_fname -- 出质人全称
            ,impa_acct_num -- 出质人账号
            ,impa_open_bk_num -- 出质人开户行行号
            ,impa_open_bk_name -- 出质人开户行行名
            ,csld_soci_crdt_cd -- 出质人统一社会信用代码
            ,org_num -- 机构号
            ,pawn_open_bk_name -- 质权人开户行名
            ,flag -- 质押标识（0质押 1解质押）
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.sccode -- 押品编号
    ,o.bil_num -- 票据号码
    ,o.bil_amt -- 票据金额
    ,o.due_day -- 到期日
    ,o.acpt_row_num -- 承兑行行号
    ,o.acpt_row_bnk_nm -- 承兑行行名
    ,o.impa_dt -- 质押日期
    ,o.impa_fname -- 出质人全称
    ,o.impa_acct_num -- 出质人账号
    ,o.impa_open_bk_num -- 出质人开户行行号
    ,o.impa_open_bk_name -- 出质人开户行行名
    ,o.csld_soci_crdt_cd -- 出质人统一社会信用代码
    ,o.org_num -- 机构号
    ,o.pawn_open_bk_name -- 质权人开户行名
    ,o.flag -- 质押标识（0质押 1解质押）
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
from ${iol_schema}.mims_yp_bdm0079_bk o
    left join ${iol_schema}.mims_yp_bdm0079_op n
        on
            o.sccode = n.sccode
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.mims_yp_bdm0079_cl d
        on
            o.sccode = d.sccode
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
--truncate table ${iol_schema}.mims_yp_bdm0079;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('mims_yp_bdm0079') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.mims_yp_bdm0079 drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.mims_yp_bdm0079 add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.mims_yp_bdm0079 exchange partition p_${batch_date} with table ${iol_schema}.mims_yp_bdm0079_cl;
alter table ${iol_schema}.mims_yp_bdm0079 exchange partition p_20991231 with table ${iol_schema}.mims_yp_bdm0079_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.mims_yp_bdm0079 to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.mims_yp_bdm0079_op purge;
drop table ${iol_schema}.mims_yp_bdm0079_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.mims_yp_bdm0079_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'mims_yp_bdm0079',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
