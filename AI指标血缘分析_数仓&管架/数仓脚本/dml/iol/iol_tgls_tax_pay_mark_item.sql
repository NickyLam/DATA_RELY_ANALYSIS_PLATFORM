/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_tgls_tax_pay_mark_item
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
create table ${iol_schema}.tgls_tax_pay_mark_item_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.tgls_tax_pay_mark_item
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.tgls_tax_pay_mark_item_op purge;
drop table ${iol_schema}.tgls_tax_pay_mark_item_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.tgls_tax_pay_mark_item_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.tgls_tax_pay_mark_item where 0=1;

create table ${iol_schema}.tgls_tax_pay_mark_item_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.tgls_tax_pay_mark_item where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.tgls_tax_pay_mark_item_cl(
            stacid -- 账套
            ,taxcode -- 税种代码（01-增值税，02-城建税，03-教育附加税，04-地方教育附加税，05-印花税，06-房产税，07-土地使用税，08-企业所得税，09-递延所得税，10-车船税）
            ,acctmd -- 记账方式(r-红字，b-蓝字)
            ,datefq -- 上划频率（1-日，2-月，3-季，4-年，5-自定义，6-半年）
            ,timefq -- 上划时点（1-期末,2-下期期初）
            ,itemcd -- 科目编号
            ,itemna -- 科目名称
            ,valutp -- 取值类型(发生额:am,期初余额:bb,期末余额:eb)
            ,smrytx -- 备注
            ,amntdn -- 取值金额方向
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.tgls_tax_pay_mark_item_op(
            stacid -- 账套
            ,taxcode -- 税种代码（01-增值税，02-城建税，03-教育附加税，04-地方教育附加税，05-印花税，06-房产税，07-土地使用税，08-企业所得税，09-递延所得税，10-车船税）
            ,acctmd -- 记账方式(r-红字，b-蓝字)
            ,datefq -- 上划频率（1-日，2-月，3-季，4-年，5-自定义，6-半年）
            ,timefq -- 上划时点（1-期末,2-下期期初）
            ,itemcd -- 科目编号
            ,itemna -- 科目名称
            ,valutp -- 取值类型(发生额:am,期初余额:bb,期末余额:eb)
            ,smrytx -- 备注
            ,amntdn -- 取值金额方向
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.stacid, o.stacid) as stacid -- 账套
    ,nvl(n.taxcode, o.taxcode) as taxcode -- 税种代码（01-增值税，02-城建税，03-教育附加税，04-地方教育附加税，05-印花税，06-房产税，07-土地使用税，08-企业所得税，09-递延所得税，10-车船税）
    ,nvl(n.acctmd, o.acctmd) as acctmd -- 记账方式(r-红字，b-蓝字)
    ,nvl(n.datefq, o.datefq) as datefq -- 上划频率（1-日，2-月，3-季，4-年，5-自定义，6-半年）
    ,nvl(n.timefq, o.timefq) as timefq -- 上划时点（1-期末,2-下期期初）
    ,nvl(n.itemcd, o.itemcd) as itemcd -- 科目编号
    ,nvl(n.itemna, o.itemna) as itemna -- 科目名称
    ,nvl(n.valutp, o.valutp) as valutp -- 取值类型(发生额:am,期初余额:bb,期末余额:eb)
    ,nvl(n.smrytx, o.smrytx) as smrytx -- 备注
    ,nvl(n.amntdn, o.amntdn) as amntdn -- 取值金额方向
    ,case when
            n.stacid is null
            and n.taxcode is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.stacid is null
            and n.taxcode is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.stacid is null
            and n.taxcode is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.tgls_tax_pay_mark_item_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.tgls_tax_pay_mark_item where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.stacid = n.stacid
            and o.taxcode = n.taxcode
where (
        o.stacid is null
        and o.taxcode is null
    )
    or (
        n.stacid is null
        and n.taxcode is null
    )
    or (
        o.acctmd <> n.acctmd
        or o.datefq <> n.datefq
        or o.timefq <> n.timefq
        or o.itemcd <> n.itemcd
        or o.itemna <> n.itemna
        or o.valutp <> n.valutp
        or o.smrytx <> n.smrytx
        or o.amntdn <> n.amntdn
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.tgls_tax_pay_mark_item_cl(
            stacid -- 账套
            ,taxcode -- 税种代码（01-增值税，02-城建税，03-教育附加税，04-地方教育附加税，05-印花税，06-房产税，07-土地使用税，08-企业所得税，09-递延所得税，10-车船税）
            ,acctmd -- 记账方式(r-红字，b-蓝字)
            ,datefq -- 上划频率（1-日，2-月，3-季，4-年，5-自定义，6-半年）
            ,timefq -- 上划时点（1-期末,2-下期期初）
            ,itemcd -- 科目编号
            ,itemna -- 科目名称
            ,valutp -- 取值类型(发生额:am,期初余额:bb,期末余额:eb)
            ,smrytx -- 备注
            ,amntdn -- 取值金额方向
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.tgls_tax_pay_mark_item_op(
            stacid -- 账套
            ,taxcode -- 税种代码（01-增值税，02-城建税，03-教育附加税，04-地方教育附加税，05-印花税，06-房产税，07-土地使用税，08-企业所得税，09-递延所得税，10-车船税）
            ,acctmd -- 记账方式(r-红字，b-蓝字)
            ,datefq -- 上划频率（1-日，2-月，3-季，4-年，5-自定义，6-半年）
            ,timefq -- 上划时点（1-期末,2-下期期初）
            ,itemcd -- 科目编号
            ,itemna -- 科目名称
            ,valutp -- 取值类型(发生额:am,期初余额:bb,期末余额:eb)
            ,smrytx -- 备注
            ,amntdn -- 取值金额方向
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.stacid -- 账套
    ,o.taxcode -- 税种代码（01-增值税，02-城建税，03-教育附加税，04-地方教育附加税，05-印花税，06-房产税，07-土地使用税，08-企业所得税，09-递延所得税，10-车船税）
    ,o.acctmd -- 记账方式(r-红字，b-蓝字)
    ,o.datefq -- 上划频率（1-日，2-月，3-季，4-年，5-自定义，6-半年）
    ,o.timefq -- 上划时点（1-期末,2-下期期初）
    ,o.itemcd -- 科目编号
    ,o.itemna -- 科目名称
    ,o.valutp -- 取值类型(发生额:am,期初余额:bb,期末余额:eb)
    ,o.smrytx -- 备注
    ,o.amntdn -- 取值金额方向
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
from ${iol_schema}.tgls_tax_pay_mark_item_bk o
    left join ${iol_schema}.tgls_tax_pay_mark_item_op n
        on
            o.stacid = n.stacid
            and o.taxcode = n.taxcode
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.tgls_tax_pay_mark_item_cl d
        on
            o.stacid = d.stacid
            and o.taxcode = d.taxcode
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
--truncate table ${iol_schema}.tgls_tax_pay_mark_item;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('tgls_tax_pay_mark_item') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.tgls_tax_pay_mark_item drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.tgls_tax_pay_mark_item add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.tgls_tax_pay_mark_item exchange partition p_${batch_date} with table ${iol_schema}.tgls_tax_pay_mark_item_cl;
alter table ${iol_schema}.tgls_tax_pay_mark_item exchange partition p_20991231 with table ${iol_schema}.tgls_tax_pay_mark_item_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.tgls_tax_pay_mark_item to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.tgls_tax_pay_mark_item_op purge;
drop table ${iol_schema}.tgls_tax_pay_mark_item_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.tgls_tax_pay_mark_item_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'tgls_tax_pay_mark_item',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
