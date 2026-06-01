/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_icms_business_rpt_segment
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
create table ${iol_schema}.icms_business_rpt_segment_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.icms_business_rpt_segment
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.icms_business_rpt_segment_op purge;
drop table ${iol_schema}.icms_business_rpt_segment_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.icms_business_rpt_segment_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.icms_business_rpt_segment where 0=1;

create table ${iol_schema}.icms_business_rpt_segment_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.icms_business_rpt_segment where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.icms_business_rpt_segment_cl(
            serialno -- 流水号
            ,repaydate -- 还款日期
            ,payfrequencytype -- 还款周期类型
            ,segtermid -- 子还款方式
            ,segtodate -- 区段结束日
            ,payfrequency -- 指定周期值
            ,termid -- 还款方式
            ,migtflag -- 迁移标志：crsrcrilcupl
            ,segfromdate -- 区段起始日
            ,inputuserid -- 登记人
            ,curterm -- 当前期数
            ,objecttype -- 对象类型：BusinessPutout可用于出账，RPTChange可用于贷后还款方式变更
            ,payfrequencyunit -- 指定周期单位
            ,inputorgid -- 登记机构
            ,defaultdueday -- 默认还款日
            ,inputdate -- 登记日期
            ,objectno -- 对象编号
            ,segrptamount -- 指定金额
            ,corporgid -- 法人机构编号
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.icms_business_rpt_segment_op(
            serialno -- 流水号
            ,repaydate -- 还款日期
            ,payfrequencytype -- 还款周期类型
            ,segtermid -- 子还款方式
            ,segtodate -- 区段结束日
            ,payfrequency -- 指定周期值
            ,termid -- 还款方式
            ,migtflag -- 迁移标志：crsrcrilcupl
            ,segfromdate -- 区段起始日
            ,inputuserid -- 登记人
            ,curterm -- 当前期数
            ,objecttype -- 对象类型：BusinessPutout可用于出账，RPTChange可用于贷后还款方式变更
            ,payfrequencyunit -- 指定周期单位
            ,inputorgid -- 登记机构
            ,defaultdueday -- 默认还款日
            ,inputdate -- 登记日期
            ,objectno -- 对象编号
            ,segrptamount -- 指定金额
            ,corporgid -- 法人机构编号
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.serialno, o.serialno) as serialno -- 流水号
    ,nvl(n.repaydate, o.repaydate) as repaydate -- 还款日期
    ,nvl(n.payfrequencytype, o.payfrequencytype) as payfrequencytype -- 还款周期类型
    ,nvl(n.segtermid, o.segtermid) as segtermid -- 子还款方式
    ,nvl(n.segtodate, o.segtodate) as segtodate -- 区段结束日
    ,nvl(n.payfrequency, o.payfrequency) as payfrequency -- 指定周期值
    ,nvl(n.termid, o.termid) as termid -- 还款方式
    ,nvl(n.migtflag, o.migtflag) as migtflag -- 迁移标志：crsrcrilcupl
    ,nvl(n.segfromdate, o.segfromdate) as segfromdate -- 区段起始日
    ,nvl(n.inputuserid, o.inputuserid) as inputuserid -- 登记人
    ,nvl(n.curterm, o.curterm) as curterm -- 当前期数
    ,nvl(n.objecttype, o.objecttype) as objecttype -- 对象类型：BusinessPutout可用于出账，RPTChange可用于贷后还款方式变更
    ,nvl(n.payfrequencyunit, o.payfrequencyunit) as payfrequencyunit -- 指定周期单位
    ,nvl(n.inputorgid, o.inputorgid) as inputorgid -- 登记机构
    ,nvl(n.defaultdueday, o.defaultdueday) as defaultdueday -- 默认还款日
    ,nvl(n.inputdate, o.inputdate) as inputdate -- 登记日期
    ,nvl(n.objectno, o.objectno) as objectno -- 对象编号
    ,nvl(n.segrptamount, o.segrptamount) as segrptamount -- 指定金额
    ,nvl(n.corporgid, o.corporgid) as corporgid -- 法人机构编号
    ,case when
            n.serialno is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.serialno is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.serialno is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.icms_business_rpt_segment_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.icms_business_rpt_segment where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.serialno = n.serialno
where (
        o.serialno is null
    )
    or (
        n.serialno is null
    )
    or (
        o.repaydate <> n.repaydate
        or o.payfrequencytype <> n.payfrequencytype
        or o.segtermid <> n.segtermid
        or o.segtodate <> n.segtodate
        or o.payfrequency <> n.payfrequency
        or o.termid <> n.termid
        or o.migtflag <> n.migtflag
        or o.segfromdate <> n.segfromdate
        or o.inputuserid <> n.inputuserid
        or o.curterm <> n.curterm
        or o.objecttype <> n.objecttype
        or o.payfrequencyunit <> n.payfrequencyunit
        or o.inputorgid <> n.inputorgid
        or o.defaultdueday <> n.defaultdueday
        or o.inputdate <> n.inputdate
        or o.objectno <> n.objectno
        or o.segrptamount <> n.segrptamount
        or o.corporgid <> n.corporgid
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.icms_business_rpt_segment_cl(
            serialno -- 流水号
            ,repaydate -- 还款日期
            ,payfrequencytype -- 还款周期类型
            ,segtermid -- 子还款方式
            ,segtodate -- 区段结束日
            ,payfrequency -- 指定周期值
            ,termid -- 还款方式
            ,migtflag -- 迁移标志：crsrcrilcupl
            ,segfromdate -- 区段起始日
            ,inputuserid -- 登记人
            ,curterm -- 当前期数
            ,objecttype -- 对象类型：BusinessPutout可用于出账，RPTChange可用于贷后还款方式变更
            ,payfrequencyunit -- 指定周期单位
            ,inputorgid -- 登记机构
            ,defaultdueday -- 默认还款日
            ,inputdate -- 登记日期
            ,objectno -- 对象编号
            ,segrptamount -- 指定金额
            ,corporgid -- 法人机构编号
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.icms_business_rpt_segment_op(
            serialno -- 流水号
            ,repaydate -- 还款日期
            ,payfrequencytype -- 还款周期类型
            ,segtermid -- 子还款方式
            ,segtodate -- 区段结束日
            ,payfrequency -- 指定周期值
            ,termid -- 还款方式
            ,migtflag -- 迁移标志：crsrcrilcupl
            ,segfromdate -- 区段起始日
            ,inputuserid -- 登记人
            ,curterm -- 当前期数
            ,objecttype -- 对象类型：BusinessPutout可用于出账，RPTChange可用于贷后还款方式变更
            ,payfrequencyunit -- 指定周期单位
            ,inputorgid -- 登记机构
            ,defaultdueday -- 默认还款日
            ,inputdate -- 登记日期
            ,objectno -- 对象编号
            ,segrptamount -- 指定金额
            ,corporgid -- 法人机构编号
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.serialno -- 流水号
    ,o.repaydate -- 还款日期
    ,o.payfrequencytype -- 还款周期类型
    ,o.segtermid -- 子还款方式
    ,o.segtodate -- 区段结束日
    ,o.payfrequency -- 指定周期值
    ,o.termid -- 还款方式
    ,o.migtflag -- 迁移标志：crsrcrilcupl
    ,o.segfromdate -- 区段起始日
    ,o.inputuserid -- 登记人
    ,o.curterm -- 当前期数
    ,o.objecttype -- 对象类型：BusinessPutout可用于出账，RPTChange可用于贷后还款方式变更
    ,o.payfrequencyunit -- 指定周期单位
    ,o.inputorgid -- 登记机构
    ,o.defaultdueday -- 默认还款日
    ,o.inputdate -- 登记日期
    ,o.objectno -- 对象编号
    ,o.segrptamount -- 指定金额
    ,o.corporgid -- 法人机构编号
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
from ${iol_schema}.icms_business_rpt_segment_bk o
    left join ${iol_schema}.icms_business_rpt_segment_op n
        on
            o.serialno = n.serialno
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.icms_business_rpt_segment_cl d
        on
            o.serialno = d.serialno
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
--truncate table ${iol_schema}.icms_business_rpt_segment;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('icms_business_rpt_segment') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.icms_business_rpt_segment drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.icms_business_rpt_segment add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.icms_business_rpt_segment exchange partition p_${batch_date} with table ${iol_schema}.icms_business_rpt_segment_cl;
alter table ${iol_schema}.icms_business_rpt_segment exchange partition p_20991231 with table ${iol_schema}.icms_business_rpt_segment_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.icms_business_rpt_segment to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.icms_business_rpt_segment_op purge;
drop table ${iol_schema}.icms_business_rpt_segment_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.icms_business_rpt_segment_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'icms_business_rpt_segment',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
