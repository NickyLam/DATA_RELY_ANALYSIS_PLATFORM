/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_iers_oa_approveinfo
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
create table ${iol_schema}.iers_oa_approveinfo_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.iers_oa_approveinfo
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.iers_oa_approveinfo_op purge;
drop table ${iol_schema}.iers_oa_approveinfo_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.iers_oa_approveinfo_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.iers_oa_approveinfo where 0=1;

create table ${iol_schema}.iers_oa_approveinfo_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.iers_oa_approveinfo where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.iers_oa_approveinfo_cl(
            rela_traninfo -- 
            ,pk_dept -- 主键
            ,relation_info -- 
            ,rela_amount -- 
            ,rela_tranprise -- 
            ,pk_approveinfo -- 主键
            ,dr -- 删除标志
            ,ts -- 时间戳
            ,billno -- 单据号
            ,tradeopp -- 
            ,busicode -- 编码
            ,rela_amount_analyse -- 
            ,exist_bljl -- 
            ,exist_fljf -- 
            ,memo -- 助记码
            ,rela_tranflag -- 标志
            ,rela_balance_amount -- 余额
            ,user_code -- 用户编号
            ,user_id -- 用户pk
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.iers_oa_approveinfo_op(
            rela_traninfo -- 
            ,pk_dept -- 主键
            ,relation_info -- 
            ,rela_amount -- 
            ,rela_tranprise -- 
            ,pk_approveinfo -- 主键
            ,dr -- 删除标志
            ,ts -- 时间戳
            ,billno -- 单据号
            ,tradeopp -- 
            ,busicode -- 编码
            ,rela_amount_analyse -- 
            ,exist_bljl -- 
            ,exist_fljf -- 
            ,memo -- 助记码
            ,rela_tranflag -- 标志
            ,rela_balance_amount -- 余额
            ,user_code -- 用户编号
            ,user_id -- 用户pk
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.rela_traninfo, o.rela_traninfo) as rela_traninfo -- 
    ,nvl(n.pk_dept, o.pk_dept) as pk_dept -- 主键
    ,nvl(n.relation_info, o.relation_info) as relation_info -- 
    ,nvl(n.rela_amount, o.rela_amount) as rela_amount -- 
    ,nvl(n.rela_tranprise, o.rela_tranprise) as rela_tranprise -- 
    ,nvl(n.pk_approveinfo, o.pk_approveinfo) as pk_approveinfo -- 主键
    ,nvl(n.dr, o.dr) as dr -- 删除标志
    ,nvl(n.ts, o.ts) as ts -- 时间戳
    ,nvl(n.billno, o.billno) as billno -- 单据号
    ,nvl(n.tradeopp, o.tradeopp) as tradeopp -- 
    ,nvl(n.busicode, o.busicode) as busicode -- 编码
    ,nvl(n.rela_amount_analyse, o.rela_amount_analyse) as rela_amount_analyse -- 
    ,nvl(n.exist_bljl, o.exist_bljl) as exist_bljl -- 
    ,nvl(n.exist_fljf, o.exist_fljf) as exist_fljf -- 
    ,nvl(n.memo, o.memo) as memo -- 助记码
    ,nvl(n.rela_tranflag, o.rela_tranflag) as rela_tranflag -- 标志
    ,nvl(n.rela_balance_amount, o.rela_balance_amount) as rela_balance_amount -- 余额
    ,nvl(n.user_code, o.user_code) as user_code -- 用户编号
    ,nvl(n.user_id, o.user_id) as user_id -- 用户pk
    ,case when
            n.pk_approveinfo is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.pk_approveinfo is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.pk_approveinfo is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.iers_oa_approveinfo_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.iers_oa_approveinfo where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.pk_approveinfo = n.pk_approveinfo
where (
        o.pk_approveinfo is null
    )
    or (
        n.pk_approveinfo is null
    )
    or (
        o.rela_traninfo <> n.rela_traninfo
        or o.pk_dept <> n.pk_dept
        or o.relation_info <> n.relation_info
        or o.rela_amount <> n.rela_amount
        or o.rela_tranprise <> n.rela_tranprise
        or o.dr <> n.dr
        or o.ts <> n.ts
        or o.billno <> n.billno
        or o.tradeopp <> n.tradeopp
        or o.busicode <> n.busicode
        or o.rela_amount_analyse <> n.rela_amount_analyse
        or o.exist_bljl <> n.exist_bljl
        or o.exist_fljf <> n.exist_fljf
        or o.memo <> n.memo
        or o.rela_tranflag <> n.rela_tranflag
        or o.rela_balance_amount <> n.rela_balance_amount
        or o.user_code <> n.user_code
        or o.user_id <> n.user_id
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.iers_oa_approveinfo_cl(
            rela_traninfo -- 
            ,pk_dept -- 主键
            ,relation_info -- 
            ,rela_amount -- 
            ,rela_tranprise -- 
            ,pk_approveinfo -- 主键
            ,dr -- 删除标志
            ,ts -- 时间戳
            ,billno -- 单据号
            ,tradeopp -- 
            ,busicode -- 编码
            ,rela_amount_analyse -- 
            ,exist_bljl -- 
            ,exist_fljf -- 
            ,memo -- 助记码
            ,rela_tranflag -- 标志
            ,rela_balance_amount -- 余额
            ,user_code -- 用户编号
            ,user_id -- 用户pk
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.iers_oa_approveinfo_op(
            rela_traninfo -- 
            ,pk_dept -- 主键
            ,relation_info -- 
            ,rela_amount -- 
            ,rela_tranprise -- 
            ,pk_approveinfo -- 主键
            ,dr -- 删除标志
            ,ts -- 时间戳
            ,billno -- 单据号
            ,tradeopp -- 
            ,busicode -- 编码
            ,rela_amount_analyse -- 
            ,exist_bljl -- 
            ,exist_fljf -- 
            ,memo -- 助记码
            ,rela_tranflag -- 标志
            ,rela_balance_amount -- 余额
            ,user_code -- 用户编号
            ,user_id -- 用户pk
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.rela_traninfo -- 
    ,o.pk_dept -- 主键
    ,o.relation_info -- 
    ,o.rela_amount -- 
    ,o.rela_tranprise -- 
    ,o.pk_approveinfo -- 主键
    ,o.dr -- 删除标志
    ,o.ts -- 时间戳
    ,o.billno -- 单据号
    ,o.tradeopp -- 
    ,o.busicode -- 编码
    ,o.rela_amount_analyse -- 
    ,o.exist_bljl -- 
    ,o.exist_fljf -- 
    ,o.memo -- 助记码
    ,o.rela_tranflag -- 标志
    ,o.rela_balance_amount -- 余额
    ,o.user_code -- 用户编号
    ,o.user_id -- 用户pk
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
from ${iol_schema}.iers_oa_approveinfo_bk o
    left join ${iol_schema}.iers_oa_approveinfo_op n
        on
            o.pk_approveinfo = n.pk_approveinfo
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.iers_oa_approveinfo_cl d
        on
            o.pk_approveinfo = d.pk_approveinfo
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
--truncate table ${iol_schema}.iers_oa_approveinfo;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('iers_oa_approveinfo') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.iers_oa_approveinfo drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.iers_oa_approveinfo add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.iers_oa_approveinfo exchange partition p_${batch_date} with table ${iol_schema}.iers_oa_approveinfo_cl;
alter table ${iol_schema}.iers_oa_approveinfo exchange partition p_20991231 with table ${iol_schema}.iers_oa_approveinfo_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.iers_oa_approveinfo to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.iers_oa_approveinfo_op purge;
drop table ${iol_schema}.iers_oa_approveinfo_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.iers_oa_approveinfo_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'iers_oa_approveinfo',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
