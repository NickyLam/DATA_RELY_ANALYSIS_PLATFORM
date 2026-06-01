/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_icms_fina_row
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
create table ${iol_schema}.icms_fina_row_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.icms_fina_row
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.icms_fina_row_op purge;
drop table ${iol_schema}.icms_fina_row_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.icms_fina_row_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.icms_fina_row where 0=1;

create table ${iol_schema}.icms_fina_row_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.icms_fina_row where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.icms_fina_row_cl(
            rowno -- 行号
            ,sheetno -- 报表号
            ,inputuserid -- 登记人
            ,valueone -- 值一
            ,rowname -- 行名称
            ,standardvalue -- 标准值
            ,migtflag -- 迁移标志：crsrcrilcupl
            ,subjectno -- 科目
            ,valuetwo -- 值二
            ,inputdate -- 登记日期登记日期时间
            ,inputorgid -- 登记机构
            ,updateuserid -- 更新人
            ,valuefour -- 列4值
            ,updateorgid -- 更新机构
            ,updatedate -- 更新日期
            ,valuethree -- 列3值
            ,displayorder -- 显示次序
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.icms_fina_row_op(
            rowno -- 行号
            ,sheetno -- 报表号
            ,inputuserid -- 登记人
            ,valueone -- 值一
            ,rowname -- 行名称
            ,standardvalue -- 标准值
            ,migtflag -- 迁移标志：crsrcrilcupl
            ,subjectno -- 科目
            ,valuetwo -- 值二
            ,inputdate -- 登记日期登记日期时间
            ,inputorgid -- 登记机构
            ,updateuserid -- 更新人
            ,valuefour -- 列4值
            ,updateorgid -- 更新机构
            ,updatedate -- 更新日期
            ,valuethree -- 列3值
            ,displayorder -- 显示次序
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.rowno, o.rowno) as rowno -- 行号
    ,nvl(n.sheetno, o.sheetno) as sheetno -- 报表号
    ,nvl(n.inputuserid, o.inputuserid) as inputuserid -- 登记人
    ,nvl(n.valueone, o.valueone) as valueone -- 值一
    ,nvl(n.rowname, o.rowname) as rowname -- 行名称
    ,nvl(n.standardvalue, o.standardvalue) as standardvalue -- 标准值
    ,nvl(n.migtflag, o.migtflag) as migtflag -- 迁移标志：crsrcrilcupl
    ,nvl(n.subjectno, o.subjectno) as subjectno -- 科目
    ,nvl(n.valuetwo, o.valuetwo) as valuetwo -- 值二
    ,nvl(n.inputdate, o.inputdate) as inputdate -- 登记日期登记日期时间
    ,nvl(n.inputorgid, o.inputorgid) as inputorgid -- 登记机构
    ,nvl(n.updateuserid, o.updateuserid) as updateuserid -- 更新人
    ,nvl(n.valuefour, o.valuefour) as valuefour -- 列4值
    ,nvl(n.updateorgid, o.updateorgid) as updateorgid -- 更新机构
    ,nvl(n.updatedate, o.updatedate) as updatedate -- 更新日期
    ,nvl(n.valuethree, o.valuethree) as valuethree -- 列3值
    ,nvl(n.displayorder, o.displayorder) as displayorder -- 显示次序
    ,case when
            n.rowno is null
            and n.sheetno is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.rowno is null
            and n.sheetno is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.rowno is null
            and n.sheetno is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.icms_fina_row_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.icms_fina_row where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.rowno = n.rowno
            and o.sheetno = n.sheetno
where (
        o.rowno is null
        and o.sheetno is null
    )
    or (
        n.rowno is null
        and n.sheetno is null
    )
    or (
        o.inputuserid <> n.inputuserid
        or o.valueone <> n.valueone
        or o.rowname <> n.rowname
        or o.standardvalue <> n.standardvalue
        or o.migtflag <> n.migtflag
        or o.subjectno <> n.subjectno
        or o.valuetwo <> n.valuetwo
        or o.inputdate <> n.inputdate
        or o.inputorgid <> n.inputorgid
        or o.updateuserid <> n.updateuserid
        or o.valuefour <> n.valuefour
        or o.updateorgid <> n.updateorgid
        or o.updatedate <> n.updatedate
        or o.valuethree <> n.valuethree
        or o.displayorder <> n.displayorder
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.icms_fina_row_cl(
            rowno -- 行号
            ,sheetno -- 报表号
            ,inputuserid -- 登记人
            ,valueone -- 值一
            ,rowname -- 行名称
            ,standardvalue -- 标准值
            ,migtflag -- 迁移标志：crsrcrilcupl
            ,subjectno -- 科目
            ,valuetwo -- 值二
            ,inputdate -- 登记日期登记日期时间
            ,inputorgid -- 登记机构
            ,updateuserid -- 更新人
            ,valuefour -- 列4值
            ,updateorgid -- 更新机构
            ,updatedate -- 更新日期
            ,valuethree -- 列3值
            ,displayorder -- 显示次序
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.icms_fina_row_op(
            rowno -- 行号
            ,sheetno -- 报表号
            ,inputuserid -- 登记人
            ,valueone -- 值一
            ,rowname -- 行名称
            ,standardvalue -- 标准值
            ,migtflag -- 迁移标志：crsrcrilcupl
            ,subjectno -- 科目
            ,valuetwo -- 值二
            ,inputdate -- 登记日期登记日期时间
            ,inputorgid -- 登记机构
            ,updateuserid -- 更新人
            ,valuefour -- 列4值
            ,updateorgid -- 更新机构
            ,updatedate -- 更新日期
            ,valuethree -- 列3值
            ,displayorder -- 显示次序
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.rowno -- 行号
    ,o.sheetno -- 报表号
    ,o.inputuserid -- 登记人
    ,o.valueone -- 值一
    ,o.rowname -- 行名称
    ,o.standardvalue -- 标准值
    ,o.migtflag -- 迁移标志：crsrcrilcupl
    ,o.subjectno -- 科目
    ,o.valuetwo -- 值二
    ,o.inputdate -- 登记日期登记日期时间
    ,o.inputorgid -- 登记机构
    ,o.updateuserid -- 更新人
    ,o.valuefour -- 列4值
    ,o.updateorgid -- 更新机构
    ,o.updatedate -- 更新日期
    ,o.valuethree -- 列3值
    ,o.displayorder -- 显示次序
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
from ${iol_schema}.icms_fina_row_bk o
    left join ${iol_schema}.icms_fina_row_op n
        on
            o.rowno = n.rowno
            and o.sheetno = n.sheetno
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.icms_fina_row_cl d
        on
            o.rowno = d.rowno
            and o.sheetno = d.sheetno
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
--truncate table ${iol_schema}.icms_fina_row;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('icms_fina_row') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.icms_fina_row drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.icms_fina_row add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.icms_fina_row exchange partition p_${batch_date} with table ${iol_schema}.icms_fina_row_cl;
alter table ${iol_schema}.icms_fina_row exchange partition p_20991231 with table ${iol_schema}.icms_fina_row_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.icms_fina_row to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.icms_fina_row_op purge;
drop table ${iol_schema}.icms_fina_row_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.icms_fina_row_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'icms_fina_row',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
