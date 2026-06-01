/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_isbs_rptcod
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
create table ${iol_schema}.isbs_rptcod_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.isbs_rptcod
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.isbs_rptcod_op purge;
drop table ${iol_schema}.isbs_rptcod_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.isbs_rptcod_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.isbs_rptcod where 0=1;

create table ${iol_schema}.isbs_rptcod_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.isbs_rptcod where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.isbs_rptcod_cl(
            inr -- 主键
            ,trninr -- TRN表关联主键
            ,ownref -- 业务编号
            ,djdate -- 登记日期
            ,djtime -- 登记时间
            ,fincod -- 借据号
            ,docid -- 单据ID
            ,creextkey -- 创建客户ID
            ,doccur -- 币种
            ,docamt -- 金额
            ,doctyp -- 单据类型
            ,bchkeyinr -- 经办机构INR
            ,crefrm -- 创建交易
            ,intyp -- 导入方式
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.isbs_rptcod_op(
            inr -- 主键
            ,trninr -- TRN表关联主键
            ,ownref -- 业务编号
            ,djdate -- 登记日期
            ,djtime -- 登记时间
            ,fincod -- 借据号
            ,docid -- 单据ID
            ,creextkey -- 创建客户ID
            ,doccur -- 币种
            ,docamt -- 金额
            ,doctyp -- 单据类型
            ,bchkeyinr -- 经办机构INR
            ,crefrm -- 创建交易
            ,intyp -- 导入方式
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.inr, o.inr) as inr -- 主键
    ,nvl(n.trninr, o.trninr) as trninr -- TRN表关联主键
    ,nvl(n.ownref, o.ownref) as ownref -- 业务编号
    ,nvl(n.djdate, o.djdate) as djdate -- 登记日期
    ,nvl(n.djtime, o.djtime) as djtime -- 登记时间
    ,nvl(n.fincod, o.fincod) as fincod -- 借据号
    ,nvl(n.docid, o.docid) as docid -- 单据ID
    ,nvl(n.creextkey, o.creextkey) as creextkey -- 创建客户ID
    ,nvl(n.doccur, o.doccur) as doccur -- 币种
    ,nvl(n.docamt, o.docamt) as docamt -- 金额
    ,nvl(n.doctyp, o.doctyp) as doctyp -- 单据类型
    ,nvl(n.bchkeyinr, o.bchkeyinr) as bchkeyinr -- 经办机构INR
    ,nvl(n.crefrm, o.crefrm) as crefrm -- 创建交易
    ,nvl(n.intyp, o.intyp) as intyp -- 导入方式
    ,case when
            n.inr is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.inr is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.inr is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.isbs_rptcod_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.isbs_rptcod where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.inr = n.inr
where (
        o.inr is null
    )
    or (
        n.inr is null
    )
    or (
        o.trninr <> n.trninr
        or o.ownref <> n.ownref
        or o.djdate <> n.djdate
        or o.djtime <> n.djtime
        or o.fincod <> n.fincod
        or o.docid <> n.docid
        or o.creextkey <> n.creextkey
        or o.doccur <> n.doccur
        or o.docamt <> n.docamt
        or o.doctyp <> n.doctyp
        or o.bchkeyinr <> n.bchkeyinr
        or o.crefrm <> n.crefrm
        or o.intyp <> n.intyp
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.isbs_rptcod_cl(
            inr -- 主键
            ,trninr -- TRN表关联主键
            ,ownref -- 业务编号
            ,djdate -- 登记日期
            ,djtime -- 登记时间
            ,fincod -- 借据号
            ,docid -- 单据ID
            ,creextkey -- 创建客户ID
            ,doccur -- 币种
            ,docamt -- 金额
            ,doctyp -- 单据类型
            ,bchkeyinr -- 经办机构INR
            ,crefrm -- 创建交易
            ,intyp -- 导入方式
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.isbs_rptcod_op(
            inr -- 主键
            ,trninr -- TRN表关联主键
            ,ownref -- 业务编号
            ,djdate -- 登记日期
            ,djtime -- 登记时间
            ,fincod -- 借据号
            ,docid -- 单据ID
            ,creextkey -- 创建客户ID
            ,doccur -- 币种
            ,docamt -- 金额
            ,doctyp -- 单据类型
            ,bchkeyinr -- 经办机构INR
            ,crefrm -- 创建交易
            ,intyp -- 导入方式
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.inr -- 主键
    ,o.trninr -- TRN表关联主键
    ,o.ownref -- 业务编号
    ,o.djdate -- 登记日期
    ,o.djtime -- 登记时间
    ,o.fincod -- 借据号
    ,o.docid -- 单据ID
    ,o.creextkey -- 创建客户ID
    ,o.doccur -- 币种
    ,o.docamt -- 金额
    ,o.doctyp -- 单据类型
    ,o.bchkeyinr -- 经办机构INR
    ,o.crefrm -- 创建交易
    ,o.intyp -- 导入方式
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
from ${iol_schema}.isbs_rptcod_bk o
    left join ${iol_schema}.isbs_rptcod_op n
        on
            o.inr = n.inr
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.isbs_rptcod_cl d
        on
            o.inr = d.inr
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
--truncate table ${iol_schema}.isbs_rptcod;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('isbs_rptcod') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.isbs_rptcod drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.isbs_rptcod add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.isbs_rptcod exchange partition p_${batch_date} with table ${iol_schema}.isbs_rptcod_cl;
alter table ${iol_schema}.isbs_rptcod exchange partition p_20991231 with table ${iol_schema}.isbs_rptcod_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.isbs_rptcod to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.isbs_rptcod_op purge;
drop table ${iol_schema}.isbs_rptcod_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.isbs_rptcod_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'isbs_rptcod',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
