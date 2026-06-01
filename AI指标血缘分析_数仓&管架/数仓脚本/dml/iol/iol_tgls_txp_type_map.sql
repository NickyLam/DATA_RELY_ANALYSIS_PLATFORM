/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_tgls_txp_type_map
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
create table ${iol_schema}.tgls_txp_type_map_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.tgls_txp_type_map
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.tgls_txp_type_map_op purge;
drop table ${iol_schema}.tgls_txp_type_map_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.tgls_txp_type_map_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.tgls_txp_type_map where 0=1;

create table ${iol_schema}.tgls_txp_type_map_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.tgls_txp_type_map where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.tgls_txp_type_map_cl(
            stacid -- 账套
            ,prodcd -- 类别（产品）
            ,prodp1 -- 属性1值
            ,prodp2 -- 属性2
            ,prodp3 -- 属性3
            ,prodp4 -- 属性4
            ,prodp5 -- 属性5
            ,prodp6 -- 属性6
            ,prodp7 -- 属性7
            ,prodp8 -- 属性8
            ,prodp9 -- 属性9
            ,prodpa -- 属性10
            ,typecd -- 税目
            ,taxvtg -- 进项销项标识：进项(in)、销项(ou)
            ,opracd -- 分离动作：销项可取值为涉票（tis）、涉税（tax）、摊销或计提调整（tad）进项可取值为涉票（tis）、摊销或计提调整（tad）
            ,toamnt -- b-蓝字r-红字
            ,toitem -- 对方科目
            ,adjutg -- 账务调整标识（0：不调整核算1：调整核算）调整核算时采用红字冲字
            ,itemaj -- 调整科目（为空则为原科目）
            ,sepatg -- 分离标识
            ,usedtg -- 使用标识（0：未使用1：已使用2：停用）
            ,reason -- 修改原因
            ,modidt -- 创建时间（格式yyyy-mm-ddhh24:mm:ss）
            ,spuuid -- 分离规则唯一标识
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.tgls_txp_type_map_op(
            stacid -- 账套
            ,prodcd -- 类别（产品）
            ,prodp1 -- 属性1值
            ,prodp2 -- 属性2
            ,prodp3 -- 属性3
            ,prodp4 -- 属性4
            ,prodp5 -- 属性5
            ,prodp6 -- 属性6
            ,prodp7 -- 属性7
            ,prodp8 -- 属性8
            ,prodp9 -- 属性9
            ,prodpa -- 属性10
            ,typecd -- 税目
            ,taxvtg -- 进项销项标识：进项(in)、销项(ou)
            ,opracd -- 分离动作：销项可取值为涉票（tis）、涉税（tax）、摊销或计提调整（tad）进项可取值为涉票（tis）、摊销或计提调整（tad）
            ,toamnt -- b-蓝字r-红字
            ,toitem -- 对方科目
            ,adjutg -- 账务调整标识（0：不调整核算1：调整核算）调整核算时采用红字冲字
            ,itemaj -- 调整科目（为空则为原科目）
            ,sepatg -- 分离标识
            ,usedtg -- 使用标识（0：未使用1：已使用2：停用）
            ,reason -- 修改原因
            ,modidt -- 创建时间（格式yyyy-mm-ddhh24:mm:ss）
            ,spuuid -- 分离规则唯一标识
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.stacid, o.stacid) as stacid -- 账套
    ,nvl(n.prodcd, o.prodcd) as prodcd -- 类别（产品）
    ,nvl(n.prodp1, o.prodp1) as prodp1 -- 属性1值
    ,nvl(n.prodp2, o.prodp2) as prodp2 -- 属性2
    ,nvl(n.prodp3, o.prodp3) as prodp3 -- 属性3
    ,nvl(n.prodp4, o.prodp4) as prodp4 -- 属性4
    ,nvl(n.prodp5, o.prodp5) as prodp5 -- 属性5
    ,nvl(n.prodp6, o.prodp6) as prodp6 -- 属性6
    ,nvl(n.prodp7, o.prodp7) as prodp7 -- 属性7
    ,nvl(n.prodp8, o.prodp8) as prodp8 -- 属性8
    ,nvl(n.prodp9, o.prodp9) as prodp9 -- 属性9
    ,nvl(n.prodpa, o.prodpa) as prodpa -- 属性10
    ,nvl(n.typecd, o.typecd) as typecd -- 税目
    ,nvl(n.taxvtg, o.taxvtg) as taxvtg -- 进项销项标识：进项(in)、销项(ou)
    ,nvl(n.opracd, o.opracd) as opracd -- 分离动作：销项可取值为涉票（tis）、涉税（tax）、摊销或计提调整（tad）进项可取值为涉票（tis）、摊销或计提调整（tad）
    ,nvl(n.toamnt, o.toamnt) as toamnt -- b-蓝字r-红字
    ,nvl(n.toitem, o.toitem) as toitem -- 对方科目
    ,nvl(n.adjutg, o.adjutg) as adjutg -- 账务调整标识（0：不调整核算1：调整核算）调整核算时采用红字冲字
    ,nvl(n.itemaj, o.itemaj) as itemaj -- 调整科目（为空则为原科目）
    ,nvl(n.sepatg, o.sepatg) as sepatg -- 分离标识
    ,nvl(n.usedtg, o.usedtg) as usedtg -- 使用标识（0：未使用1：已使用2：停用）
    ,nvl(n.reason, o.reason) as reason -- 修改原因
    ,nvl(n.modidt, o.modidt) as modidt -- 创建时间（格式yyyy-mm-ddhh24:mm:ss）
    ,nvl(n.spuuid, o.spuuid) as spuuid -- 分离规则唯一标识
    ,case when
            n.stacid is null
            and n.prodcd is null
            and n.prodp1 is null
            and n.prodp2 is null
            and n.prodp3 is null
            and n.prodp4 is null
            and n.prodp5 is null
            and n.prodp6 is null
            and n.prodp7 is null
            and n.prodp8 is null
            and n.prodp9 is null
            and n.prodpa is null
            and n.typecd is null
            and n.modidt is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.stacid is null
            and n.prodcd is null
            and n.prodp1 is null
            and n.prodp2 is null
            and n.prodp3 is null
            and n.prodp4 is null
            and n.prodp5 is null
            and n.prodp6 is null
            and n.prodp7 is null
            and n.prodp8 is null
            and n.prodp9 is null
            and n.prodpa is null
            and n.typecd is null
            and n.modidt is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.stacid is null
            and n.prodcd is null
            and n.prodp1 is null
            and n.prodp2 is null
            and n.prodp3 is null
            and n.prodp4 is null
            and n.prodp5 is null
            and n.prodp6 is null
            and n.prodp7 is null
            and n.prodp8 is null
            and n.prodp9 is null
            and n.prodpa is null
            and n.typecd is null
            and n.modidt is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.tgls_txp_type_map_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.tgls_txp_type_map where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.stacid = n.stacid
            and o.prodcd = n.prodcd
            and o.prodp1 = n.prodp1
            and o.prodp2 = n.prodp2
            and o.prodp3 = n.prodp3
            and o.prodp4 = n.prodp4
            and o.prodp5 = n.prodp5
            and o.prodp6 = n.prodp6
            and o.prodp7 = n.prodp7
            and o.prodp8 = n.prodp8
            and o.prodp9 = n.prodp9
            and o.prodpa = n.prodpa
            and o.typecd = n.typecd
            and o.modidt = n.modidt
where (
        o.stacid is null
        and o.prodcd is null
        and o.prodp1 is null
        and o.prodp2 is null
        and o.prodp3 is null
        and o.prodp4 is null
        and o.prodp5 is null
        and o.prodp6 is null
        and o.prodp7 is null
        and o.prodp8 is null
        and o.prodp9 is null
        and o.prodpa is null
        and o.typecd is null
        and o.modidt is null
    )
    or (
        n.stacid is null
        and n.prodcd is null
        and n.prodp1 is null
        and n.prodp2 is null
        and n.prodp3 is null
        and n.prodp4 is null
        and n.prodp5 is null
        and n.prodp6 is null
        and n.prodp7 is null
        and n.prodp8 is null
        and n.prodp9 is null
        and n.prodpa is null
        and n.typecd is null
        and n.modidt is null
    )
    or (
        o.taxvtg <> n.taxvtg
        or o.opracd <> n.opracd
        or o.toamnt <> n.toamnt
        or o.toitem <> n.toitem
        or o.adjutg <> n.adjutg
        or o.itemaj <> n.itemaj
        or o.sepatg <> n.sepatg
        or o.usedtg <> n.usedtg
        or o.reason <> n.reason
        or o.spuuid <> n.spuuid
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.tgls_txp_type_map_cl(
            stacid -- 账套
            ,prodcd -- 类别（产品）
            ,prodp1 -- 属性1值
            ,prodp2 -- 属性2
            ,prodp3 -- 属性3
            ,prodp4 -- 属性4
            ,prodp5 -- 属性5
            ,prodp6 -- 属性6
            ,prodp7 -- 属性7
            ,prodp8 -- 属性8
            ,prodp9 -- 属性9
            ,prodpa -- 属性10
            ,typecd -- 税目
            ,taxvtg -- 进项销项标识：进项(in)、销项(ou)
            ,opracd -- 分离动作：销项可取值为涉票（tis）、涉税（tax）、摊销或计提调整（tad）进项可取值为涉票（tis）、摊销或计提调整（tad）
            ,toamnt -- b-蓝字r-红字
            ,toitem -- 对方科目
            ,adjutg -- 账务调整标识（0：不调整核算1：调整核算）调整核算时采用红字冲字
            ,itemaj -- 调整科目（为空则为原科目）
            ,sepatg -- 分离标识
            ,usedtg -- 使用标识（0：未使用1：已使用2：停用）
            ,reason -- 修改原因
            ,modidt -- 创建时间（格式yyyy-mm-ddhh24:mm:ss）
            ,spuuid -- 分离规则唯一标识
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.tgls_txp_type_map_op(
            stacid -- 账套
            ,prodcd -- 类别（产品）
            ,prodp1 -- 属性1值
            ,prodp2 -- 属性2
            ,prodp3 -- 属性3
            ,prodp4 -- 属性4
            ,prodp5 -- 属性5
            ,prodp6 -- 属性6
            ,prodp7 -- 属性7
            ,prodp8 -- 属性8
            ,prodp9 -- 属性9
            ,prodpa -- 属性10
            ,typecd -- 税目
            ,taxvtg -- 进项销项标识：进项(in)、销项(ou)
            ,opracd -- 分离动作：销项可取值为涉票（tis）、涉税（tax）、摊销或计提调整（tad）进项可取值为涉票（tis）、摊销或计提调整（tad）
            ,toamnt -- b-蓝字r-红字
            ,toitem -- 对方科目
            ,adjutg -- 账务调整标识（0：不调整核算1：调整核算）调整核算时采用红字冲字
            ,itemaj -- 调整科目（为空则为原科目）
            ,sepatg -- 分离标识
            ,usedtg -- 使用标识（0：未使用1：已使用2：停用）
            ,reason -- 修改原因
            ,modidt -- 创建时间（格式yyyy-mm-ddhh24:mm:ss）
            ,spuuid -- 分离规则唯一标识
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.stacid -- 账套
    ,o.prodcd -- 类别（产品）
    ,o.prodp1 -- 属性1值
    ,o.prodp2 -- 属性2
    ,o.prodp3 -- 属性3
    ,o.prodp4 -- 属性4
    ,o.prodp5 -- 属性5
    ,o.prodp6 -- 属性6
    ,o.prodp7 -- 属性7
    ,o.prodp8 -- 属性8
    ,o.prodp9 -- 属性9
    ,o.prodpa -- 属性10
    ,o.typecd -- 税目
    ,o.taxvtg -- 进项销项标识：进项(in)、销项(ou)
    ,o.opracd -- 分离动作：销项可取值为涉票（tis）、涉税（tax）、摊销或计提调整（tad）进项可取值为涉票（tis）、摊销或计提调整（tad）
    ,o.toamnt -- b-蓝字r-红字
    ,o.toitem -- 对方科目
    ,o.adjutg -- 账务调整标识（0：不调整核算1：调整核算）调整核算时采用红字冲字
    ,o.itemaj -- 调整科目（为空则为原科目）
    ,o.sepatg -- 分离标识
    ,o.usedtg -- 使用标识（0：未使用1：已使用2：停用）
    ,o.reason -- 修改原因
    ,o.modidt -- 创建时间（格式yyyy-mm-ddhh24:mm:ss）
    ,o.spuuid -- 分离规则唯一标识
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
from ${iol_schema}.tgls_txp_type_map_bk o
    left join ${iol_schema}.tgls_txp_type_map_op n
        on
            o.stacid = n.stacid
            and o.prodcd = n.prodcd
            and o.prodp1 = n.prodp1
            and o.prodp2 = n.prodp2
            and o.prodp3 = n.prodp3
            and o.prodp4 = n.prodp4
            and o.prodp5 = n.prodp5
            and o.prodp6 = n.prodp6
            and o.prodp7 = n.prodp7
            and o.prodp8 = n.prodp8
            and o.prodp9 = n.prodp9
            and o.prodpa = n.prodpa
            and o.typecd = n.typecd
            and o.modidt = n.modidt
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.tgls_txp_type_map_cl d
        on
            o.stacid = d.stacid
            and o.prodcd = d.prodcd
            and o.prodp1 = d.prodp1
            and o.prodp2 = d.prodp2
            and o.prodp3 = d.prodp3
            and o.prodp4 = d.prodp4
            and o.prodp5 = d.prodp5
            and o.prodp6 = d.prodp6
            and o.prodp7 = d.prodp7
            and o.prodp8 = d.prodp8
            and o.prodp9 = d.prodp9
            and o.prodpa = d.prodpa
            and o.typecd = d.typecd
            and o.modidt = d.modidt
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
--truncate table ${iol_schema}.tgls_txp_type_map;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('tgls_txp_type_map') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.tgls_txp_type_map drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.tgls_txp_type_map add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.tgls_txp_type_map exchange partition p_${batch_date} with table ${iol_schema}.tgls_txp_type_map_cl;
alter table ${iol_schema}.tgls_txp_type_map exchange partition p_20991231 with table ${iol_schema}.tgls_txp_type_map_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.tgls_txp_type_map to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.tgls_txp_type_map_op purge;
drop table ${iol_schema}.tgls_txp_type_map_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.tgls_txp_type_map_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'tgls_txp_type_map',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
