/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_tgls_com_txtp
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
create table ${iol_schema}.tgls_com_txtp_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.tgls_com_txtp
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.tgls_com_txtp_op purge;
drop table ${iol_schema}.tgls_com_txtp_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.tgls_com_txtp_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.tgls_com_txtp where 0=1;

create table ${iol_schema}.tgls_com_txtp_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.tgls_com_txtp where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.tgls_com_txtp_cl(
            typecd -- 分类代码
            ,typena -- 名称
            ,vatxrt -- 税率
            ,fromdt -- 有效起始日
            ,endddt -- 有效结束日
            ,status -- 状态
            ,smrytx -- 备注
            ,dedutg -- 可抵扣标志（0：否1：是*：无效）——对进项适用
            ,exeptg -- 应税标识（0：零税率1：是n：免税*：无效）——对销项适用
            ,catxtp -- 计税方式（s：简易计税n：一般计税）
            ,maketp -- 开票类型(专票-sp、普票-cm、不能开票-no、无效-nv)
            ,vatxtp -- 进销项类型(销项-ou、进项-in)
            ,gdsvcd -- 税收分类编码
            ,dutycd -- 免税代码
            ,productsena -- 商品服务名称
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.tgls_com_txtp_op(
            typecd -- 分类代码
            ,typena -- 名称
            ,vatxrt -- 税率
            ,fromdt -- 有效起始日
            ,endddt -- 有效结束日
            ,status -- 状态
            ,smrytx -- 备注
            ,dedutg -- 可抵扣标志（0：否1：是*：无效）——对进项适用
            ,exeptg -- 应税标识（0：零税率1：是n：免税*：无效）——对销项适用
            ,catxtp -- 计税方式（s：简易计税n：一般计税）
            ,maketp -- 开票类型(专票-sp、普票-cm、不能开票-no、无效-nv)
            ,vatxtp -- 进销项类型(销项-ou、进项-in)
            ,gdsvcd -- 税收分类编码
            ,dutycd -- 免税代码
            ,productsena -- 商品服务名称
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.typecd, o.typecd) as typecd -- 分类代码
    ,nvl(n.typena, o.typena) as typena -- 名称
    ,nvl(n.vatxrt, o.vatxrt) as vatxrt -- 税率
    ,nvl(n.fromdt, o.fromdt) as fromdt -- 有效起始日
    ,nvl(n.endddt, o.endddt) as endddt -- 有效结束日
    ,nvl(n.status, o.status) as status -- 状态
    ,nvl(n.smrytx, o.smrytx) as smrytx -- 备注
    ,nvl(n.dedutg, o.dedutg) as dedutg -- 可抵扣标志（0：否1：是*：无效）——对进项适用
    ,nvl(n.exeptg, o.exeptg) as exeptg -- 应税标识（0：零税率1：是n：免税*：无效）——对销项适用
    ,nvl(n.catxtp, o.catxtp) as catxtp -- 计税方式（s：简易计税n：一般计税）
    ,nvl(n.maketp, o.maketp) as maketp -- 开票类型(专票-sp、普票-cm、不能开票-no、无效-nv)
    ,nvl(n.vatxtp, o.vatxtp) as vatxtp -- 进销项类型(销项-ou、进项-in)
    ,nvl(n.gdsvcd, o.gdsvcd) as gdsvcd -- 税收分类编码
    ,nvl(n.dutycd, o.dutycd) as dutycd -- 免税代码
    ,nvl(n.productsena, o.productsena) as productsena -- 商品服务名称
    ,case when
            n.typecd is null
            and n.fromdt is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.typecd is null
            and n.fromdt is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.typecd is null
            and n.fromdt is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.tgls_com_txtp_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.tgls_com_txtp where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.typecd = n.typecd
            and o.fromdt = n.fromdt
where (
        o.typecd is null
        and o.fromdt is null
    )
    or (
        n.typecd is null
        and n.fromdt is null
    )
    or (
        o.typena <> n.typena
        or o.vatxrt <> n.vatxrt
        or o.endddt <> n.endddt
        or o.status <> n.status
        or o.smrytx <> n.smrytx
        or o.dedutg <> n.dedutg
        or o.exeptg <> n.exeptg
        or o.catxtp <> n.catxtp
        or o.maketp <> n.maketp
        or o.vatxtp <> n.vatxtp
        or o.gdsvcd <> n.gdsvcd
        or o.dutycd <> n.dutycd
        or o.productsena <> n.productsena
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.tgls_com_txtp_cl(
            typecd -- 分类代码
            ,typena -- 名称
            ,vatxrt -- 税率
            ,fromdt -- 有效起始日
            ,endddt -- 有效结束日
            ,status -- 状态
            ,smrytx -- 备注
            ,dedutg -- 可抵扣标志（0：否1：是*：无效）——对进项适用
            ,exeptg -- 应税标识（0：零税率1：是n：免税*：无效）——对销项适用
            ,catxtp -- 计税方式（s：简易计税n：一般计税）
            ,maketp -- 开票类型(专票-sp、普票-cm、不能开票-no、无效-nv)
            ,vatxtp -- 进销项类型(销项-ou、进项-in)
            ,gdsvcd -- 税收分类编码
            ,dutycd -- 免税代码
            ,productsena -- 商品服务名称
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.tgls_com_txtp_op(
            typecd -- 分类代码
            ,typena -- 名称
            ,vatxrt -- 税率
            ,fromdt -- 有效起始日
            ,endddt -- 有效结束日
            ,status -- 状态
            ,smrytx -- 备注
            ,dedutg -- 可抵扣标志（0：否1：是*：无效）——对进项适用
            ,exeptg -- 应税标识（0：零税率1：是n：免税*：无效）——对销项适用
            ,catxtp -- 计税方式（s：简易计税n：一般计税）
            ,maketp -- 开票类型(专票-sp、普票-cm、不能开票-no、无效-nv)
            ,vatxtp -- 进销项类型(销项-ou、进项-in)
            ,gdsvcd -- 税收分类编码
            ,dutycd -- 免税代码
            ,productsena -- 商品服务名称
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.typecd -- 分类代码
    ,o.typena -- 名称
    ,o.vatxrt -- 税率
    ,o.fromdt -- 有效起始日
    ,o.endddt -- 有效结束日
    ,o.status -- 状态
    ,o.smrytx -- 备注
    ,o.dedutg -- 可抵扣标志（0：否1：是*：无效）——对进项适用
    ,o.exeptg -- 应税标识（0：零税率1：是n：免税*：无效）——对销项适用
    ,o.catxtp -- 计税方式（s：简易计税n：一般计税）
    ,o.maketp -- 开票类型(专票-sp、普票-cm、不能开票-no、无效-nv)
    ,o.vatxtp -- 进销项类型(销项-ou、进项-in)
    ,o.gdsvcd -- 税收分类编码
    ,o.dutycd -- 免税代码
    ,o.productsena -- 商品服务名称
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
from ${iol_schema}.tgls_com_txtp_bk o
    left join ${iol_schema}.tgls_com_txtp_op n
        on
            o.typecd = n.typecd
            and o.fromdt = n.fromdt
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.tgls_com_txtp_cl d
        on
            o.typecd = d.typecd
            and o.fromdt = d.fromdt
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
--truncate table ${iol_schema}.tgls_com_txtp;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('tgls_com_txtp') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.tgls_com_txtp drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.tgls_com_txtp add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.tgls_com_txtp exchange partition p_${batch_date} with table ${iol_schema}.tgls_com_txtp_cl;
alter table ${iol_schema}.tgls_com_txtp exchange partition p_20991231 with table ${iol_schema}.tgls_com_txtp_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.tgls_com_txtp to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.tgls_com_txtp_op purge;
drop table ${iol_schema}.tgls_com_txtp_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.tgls_com_txtp_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'tgls_com_txtp',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
