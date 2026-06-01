/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_tgls_cbrc_cell_info
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
create table ${iol_schema}.tgls_cbrc_cell_info_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.tgls_cbrc_cell_info
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.tgls_cbrc_cell_info_op purge;
drop table ${iol_schema}.tgls_cbrc_cell_info_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.tgls_cbrc_cell_info_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.tgls_cbrc_cell_info where 0=1;

create table ${iol_schema}.tgls_cbrc_cell_info_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.tgls_cbrc_cell_info where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.tgls_cbrc_cell_info_cl(
            subsys -- 子系统编号
            ,shetcd -- 报表编码
            ,itemcd -- 数据项编码
            ,cellid -- 数据项id
            ,itemna -- 数据项名称
            ,crcycd -- 数据项币种
            ,upitem -- 上级数据项
            ,totltp -- 汇总类别
            ,totllv -- 汇总层次
            ,status -- 数据项状态
            ,plusfg -- 加减标志
            ,begndt -- 启用日期
            ,overdt -- 停用日期
            ,inptfg -- 0：指标公式1：excel公式2：静态值
            ,fomutp -- 取值方式
            ,foluma -- 取数公式
            ,datatp -- 值类型num:数字类型char:字符类型date:日期类型
            ,fomuds -- 取数公式说明
            ,remark -- 备注
            ,unitnm -- 数据单位
            ,verson -- 版本号
            ,coluna -- 数据项对应列名称
            ,rowsna -- 数据项对应行名称
            ,stacid -- 账套
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.tgls_cbrc_cell_info_op(
            subsys -- 子系统编号
            ,shetcd -- 报表编码
            ,itemcd -- 数据项编码
            ,cellid -- 数据项id
            ,itemna -- 数据项名称
            ,crcycd -- 数据项币种
            ,upitem -- 上级数据项
            ,totltp -- 汇总类别
            ,totllv -- 汇总层次
            ,status -- 数据项状态
            ,plusfg -- 加减标志
            ,begndt -- 启用日期
            ,overdt -- 停用日期
            ,inptfg -- 0：指标公式1：excel公式2：静态值
            ,fomutp -- 取值方式
            ,foluma -- 取数公式
            ,datatp -- 值类型num:数字类型char:字符类型date:日期类型
            ,fomuds -- 取数公式说明
            ,remark -- 备注
            ,unitnm -- 数据单位
            ,verson -- 版本号
            ,coluna -- 数据项对应列名称
            ,rowsna -- 数据项对应行名称
            ,stacid -- 账套
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.subsys, o.subsys) as subsys -- 子系统编号
    ,nvl(n.shetcd, o.shetcd) as shetcd -- 报表编码
    ,nvl(n.itemcd, o.itemcd) as itemcd -- 数据项编码
    ,nvl(n.cellid, o.cellid) as cellid -- 数据项id
    ,nvl(n.itemna, o.itemna) as itemna -- 数据项名称
    ,nvl(n.crcycd, o.crcycd) as crcycd -- 数据项币种
    ,nvl(n.upitem, o.upitem) as upitem -- 上级数据项
    ,nvl(n.totltp, o.totltp) as totltp -- 汇总类别
    ,nvl(n.totllv, o.totllv) as totllv -- 汇总层次
    ,nvl(n.status, o.status) as status -- 数据项状态
    ,nvl(n.plusfg, o.plusfg) as plusfg -- 加减标志
    ,nvl(n.begndt, o.begndt) as begndt -- 启用日期
    ,nvl(n.overdt, o.overdt) as overdt -- 停用日期
    ,nvl(n.inptfg, o.inptfg) as inptfg -- 0：指标公式1：excel公式2：静态值
    ,nvl(n.fomutp, o.fomutp) as fomutp -- 取值方式
    ,nvl(n.foluma, o.foluma) as foluma -- 取数公式
    ,nvl(n.datatp, o.datatp) as datatp -- 值类型num:数字类型char:字符类型date:日期类型
    ,nvl(n.fomuds, o.fomuds) as fomuds -- 取数公式说明
    ,nvl(n.remark, o.remark) as remark -- 备注
    ,nvl(n.unitnm, o.unitnm) as unitnm -- 数据单位
    ,nvl(n.verson, o.verson) as verson -- 版本号
    ,nvl(n.coluna, o.coluna) as coluna -- 数据项对应列名称
    ,nvl(n.rowsna, o.rowsna) as rowsna -- 数据项对应行名称
    ,nvl(n.stacid, o.stacid) as stacid -- 账套
    ,case when
            n.subsys is null
            and n.shetcd is null
            and n.itemcd is null
            and n.cellid is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.subsys is null
            and n.shetcd is null
            and n.itemcd is null
            and n.cellid is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.subsys is null
            and n.shetcd is null
            and n.itemcd is null
            and n.cellid is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.tgls_cbrc_cell_info_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.tgls_cbrc_cell_info where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.subsys = n.subsys
            and o.shetcd = n.shetcd
            and o.itemcd = n.itemcd
            and o.cellid = n.cellid
where (
        o.subsys is null
        and o.shetcd is null
        and o.itemcd is null
        and o.cellid is null
    )
    or (
        n.subsys is null
        and n.shetcd is null
        and n.itemcd is null
        and n.cellid is null
    )
    or (
        o.itemna <> n.itemna
        or o.crcycd <> n.crcycd
        or o.upitem <> n.upitem
        or o.totltp <> n.totltp
        or o.totllv <> n.totllv
        or o.status <> n.status
        or o.plusfg <> n.plusfg
        or o.begndt <> n.begndt
        or o.overdt <> n.overdt
        or o.inptfg <> n.inptfg
        or o.fomutp <> n.fomutp
        or o.foluma <> n.foluma
        or o.datatp <> n.datatp
        or o.fomuds <> n.fomuds
        or o.remark <> n.remark
        or o.unitnm <> n.unitnm
        or o.verson <> n.verson
        or o.coluna <> n.coluna
        or o.rowsna <> n.rowsna
        or o.stacid <> n.stacid
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.tgls_cbrc_cell_info_cl(
            subsys -- 子系统编号
            ,shetcd -- 报表编码
            ,itemcd -- 数据项编码
            ,cellid -- 数据项id
            ,itemna -- 数据项名称
            ,crcycd -- 数据项币种
            ,upitem -- 上级数据项
            ,totltp -- 汇总类别
            ,totllv -- 汇总层次
            ,status -- 数据项状态
            ,plusfg -- 加减标志
            ,begndt -- 启用日期
            ,overdt -- 停用日期
            ,inptfg -- 0：指标公式1：excel公式2：静态值
            ,fomutp -- 取值方式
            ,foluma -- 取数公式
            ,datatp -- 值类型num:数字类型char:字符类型date:日期类型
            ,fomuds -- 取数公式说明
            ,remark -- 备注
            ,unitnm -- 数据单位
            ,verson -- 版本号
            ,coluna -- 数据项对应列名称
            ,rowsna -- 数据项对应行名称
            ,stacid -- 账套
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.tgls_cbrc_cell_info_op(
            subsys -- 子系统编号
            ,shetcd -- 报表编码
            ,itemcd -- 数据项编码
            ,cellid -- 数据项id
            ,itemna -- 数据项名称
            ,crcycd -- 数据项币种
            ,upitem -- 上级数据项
            ,totltp -- 汇总类别
            ,totllv -- 汇总层次
            ,status -- 数据项状态
            ,plusfg -- 加减标志
            ,begndt -- 启用日期
            ,overdt -- 停用日期
            ,inptfg -- 0：指标公式1：excel公式2：静态值
            ,fomutp -- 取值方式
            ,foluma -- 取数公式
            ,datatp -- 值类型num:数字类型char:字符类型date:日期类型
            ,fomuds -- 取数公式说明
            ,remark -- 备注
            ,unitnm -- 数据单位
            ,verson -- 版本号
            ,coluna -- 数据项对应列名称
            ,rowsna -- 数据项对应行名称
            ,stacid -- 账套
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.subsys -- 子系统编号
    ,o.shetcd -- 报表编码
    ,o.itemcd -- 数据项编码
    ,o.cellid -- 数据项id
    ,o.itemna -- 数据项名称
    ,o.crcycd -- 数据项币种
    ,o.upitem -- 上级数据项
    ,o.totltp -- 汇总类别
    ,o.totllv -- 汇总层次
    ,o.status -- 数据项状态
    ,o.plusfg -- 加减标志
    ,o.begndt -- 启用日期
    ,o.overdt -- 停用日期
    ,o.inptfg -- 0：指标公式1：excel公式2：静态值
    ,o.fomutp -- 取值方式
    ,o.foluma -- 取数公式
    ,o.datatp -- 值类型num:数字类型char:字符类型date:日期类型
    ,o.fomuds -- 取数公式说明
    ,o.remark -- 备注
    ,o.unitnm -- 数据单位
    ,o.verson -- 版本号
    ,o.coluna -- 数据项对应列名称
    ,o.rowsna -- 数据项对应行名称
    ,o.stacid -- 账套
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
from ${iol_schema}.tgls_cbrc_cell_info_bk o
    left join ${iol_schema}.tgls_cbrc_cell_info_op n
        on
            o.subsys = n.subsys
            and o.shetcd = n.shetcd
            and o.itemcd = n.itemcd
            and o.cellid = n.cellid
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.tgls_cbrc_cell_info_cl d
        on
            o.subsys = d.subsys
            and o.shetcd = d.shetcd
            and o.itemcd = d.itemcd
            and o.cellid = d.cellid
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
--truncate table ${iol_schema}.tgls_cbrc_cell_info;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('tgls_cbrc_cell_info') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.tgls_cbrc_cell_info drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.tgls_cbrc_cell_info add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.tgls_cbrc_cell_info exchange partition p_${batch_date} with table ${iol_schema}.tgls_cbrc_cell_info_cl;
alter table ${iol_schema}.tgls_cbrc_cell_info exchange partition p_20991231 with table ${iol_schema}.tgls_cbrc_cell_info_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.tgls_cbrc_cell_info to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.tgls_cbrc_cell_info_op purge;
drop table ${iol_schema}.tgls_cbrc_cell_info_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.tgls_cbrc_cell_info_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'tgls_cbrc_cell_info',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
