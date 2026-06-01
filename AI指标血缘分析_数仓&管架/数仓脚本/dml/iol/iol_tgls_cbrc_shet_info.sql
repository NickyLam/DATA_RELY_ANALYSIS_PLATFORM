/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_tgls_cbrc_shet_info
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
create table ${iol_schema}.tgls_cbrc_shet_info_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.tgls_cbrc_shet_info
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.tgls_cbrc_shet_info_op purge;
drop table ${iol_schema}.tgls_cbrc_shet_info_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.tgls_cbrc_shet_info_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.tgls_cbrc_shet_info where 0=1;

create table ${iol_schema}.tgls_cbrc_shet_info_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.tgls_cbrc_shet_info where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.tgls_cbrc_shet_info_cl(
            subsys -- 子系统编号
            ,shetcd -- 报表编码
            ,shetna -- 报表名称
            ,reptfq -- 报表统计频度
            ,reptut -- 报表单位
            ,reptfg -- 上报标志
            ,begndt -- 启用日期
            ,overdt -- 停用日期
            ,shetmp -- 报表大类
            ,shetsp -- 报表子类
            ,procna -- 报表数据集(冗余字段，统一设置参数，已迁移到cbrc_shet_brch表)
            ,inptfg -- 报表生成方式
            ,tabtor -- 报表创建人
            ,revwer -- 报表评审人
            ,resper -- 报表负责人
            ,remark -- 备注
            ,rpftch -- 报送口径(冗余字段，统一设置参数，已迁移到cbrc_shet_brch表)
            ,scheid -- 编排顺序号
            ,ftitle -- 报文标题
            ,stitle -- 报文子标题_x0013_
            ,crcycd -- 币种(冗余字段，无意义)
            ,shetsn -- 报文英文名称
            ,curent -- 是否实时报表
            ,stacid -- 帐套id
            ,isbala -- 是否涉及手工调账（1是2否）
            ,isused -- 启用（1是2否）
            ,shettp -- 报表类型（1固定报表2动态报表）
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.tgls_cbrc_shet_info_op(
            subsys -- 子系统编号
            ,shetcd -- 报表编码
            ,shetna -- 报表名称
            ,reptfq -- 报表统计频度
            ,reptut -- 报表单位
            ,reptfg -- 上报标志
            ,begndt -- 启用日期
            ,overdt -- 停用日期
            ,shetmp -- 报表大类
            ,shetsp -- 报表子类
            ,procna -- 报表数据集(冗余字段，统一设置参数，已迁移到cbrc_shet_brch表)
            ,inptfg -- 报表生成方式
            ,tabtor -- 报表创建人
            ,revwer -- 报表评审人
            ,resper -- 报表负责人
            ,remark -- 备注
            ,rpftch -- 报送口径(冗余字段，统一设置参数，已迁移到cbrc_shet_brch表)
            ,scheid -- 编排顺序号
            ,ftitle -- 报文标题
            ,stitle -- 报文子标题_x0013_
            ,crcycd -- 币种(冗余字段，无意义)
            ,shetsn -- 报文英文名称
            ,curent -- 是否实时报表
            ,stacid -- 帐套id
            ,isbala -- 是否涉及手工调账（1是2否）
            ,isused -- 启用（1是2否）
            ,shettp -- 报表类型（1固定报表2动态报表）
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.subsys, o.subsys) as subsys -- 子系统编号
    ,nvl(n.shetcd, o.shetcd) as shetcd -- 报表编码
    ,nvl(n.shetna, o.shetna) as shetna -- 报表名称
    ,nvl(n.reptfq, o.reptfq) as reptfq -- 报表统计频度
    ,nvl(n.reptut, o.reptut) as reptut -- 报表单位
    ,nvl(n.reptfg, o.reptfg) as reptfg -- 上报标志
    ,nvl(n.begndt, o.begndt) as begndt -- 启用日期
    ,nvl(n.overdt, o.overdt) as overdt -- 停用日期
    ,nvl(n.shetmp, o.shetmp) as shetmp -- 报表大类
    ,nvl(n.shetsp, o.shetsp) as shetsp -- 报表子类
    ,nvl(n.procna, o.procna) as procna -- 报表数据集(冗余字段，统一设置参数，已迁移到cbrc_shet_brch表)
    ,nvl(n.inptfg, o.inptfg) as inptfg -- 报表生成方式
    ,nvl(n.tabtor, o.tabtor) as tabtor -- 报表创建人
    ,nvl(n.revwer, o.revwer) as revwer -- 报表评审人
    ,nvl(n.resper, o.resper) as resper -- 报表负责人
    ,nvl(n.remark, o.remark) as remark -- 备注
    ,nvl(n.rpftch, o.rpftch) as rpftch -- 报送口径(冗余字段，统一设置参数，已迁移到cbrc_shet_brch表)
    ,nvl(n.scheid, o.scheid) as scheid -- 编排顺序号
    ,nvl(n.ftitle, o.ftitle) as ftitle -- 报文标题
    ,nvl(n.stitle, o.stitle) as stitle -- 报文子标题_x0013_
    ,nvl(n.crcycd, o.crcycd) as crcycd -- 币种(冗余字段，无意义)
    ,nvl(n.shetsn, o.shetsn) as shetsn -- 报文英文名称
    ,nvl(n.curent, o.curent) as curent -- 是否实时报表
    ,nvl(n.stacid, o.stacid) as stacid -- 帐套id
    ,nvl(n.isbala, o.isbala) as isbala -- 是否涉及手工调账（1是2否）
    ,nvl(n.isused, o.isused) as isused -- 启用（1是2否）
    ,nvl(n.shettp, o.shettp) as shettp -- 报表类型（1固定报表2动态报表）
    ,case when
            n.shetcd is null
            and n.stacid is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.shetcd is null
            and n.stacid is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.shetcd is null
            and n.stacid is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.tgls_cbrc_shet_info_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.tgls_cbrc_shet_info where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.shetcd = n.shetcd
            and o.stacid = n.stacid
where (
        o.shetcd is null
        and o.stacid is null
    )
    or (
        n.shetcd is null
        and n.stacid is null
    )
    or (
        o.subsys <> n.subsys
        or o.shetna <> n.shetna
        or o.reptfq <> n.reptfq
        or o.reptut <> n.reptut
        or o.reptfg <> n.reptfg
        or o.begndt <> n.begndt
        or o.overdt <> n.overdt
        or o.shetmp <> n.shetmp
        or o.shetsp <> n.shetsp
        or o.procna <> n.procna
        or o.inptfg <> n.inptfg
        or o.tabtor <> n.tabtor
        or o.revwer <> n.revwer
        or o.resper <> n.resper
        or o.remark <> n.remark
        or o.rpftch <> n.rpftch
        or o.scheid <> n.scheid
        or o.ftitle <> n.ftitle
        or o.stitle <> n.stitle
        or o.crcycd <> n.crcycd
        or o.shetsn <> n.shetsn
        or o.curent <> n.curent
        or o.isbala <> n.isbala
        or o.isused <> n.isused
        or o.shettp <> n.shettp
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.tgls_cbrc_shet_info_cl(
            subsys -- 子系统编号
            ,shetcd -- 报表编码
            ,shetna -- 报表名称
            ,reptfq -- 报表统计频度
            ,reptut -- 报表单位
            ,reptfg -- 上报标志
            ,begndt -- 启用日期
            ,overdt -- 停用日期
            ,shetmp -- 报表大类
            ,shetsp -- 报表子类
            ,procna -- 报表数据集(冗余字段，统一设置参数，已迁移到cbrc_shet_brch表)
            ,inptfg -- 报表生成方式
            ,tabtor -- 报表创建人
            ,revwer -- 报表评审人
            ,resper -- 报表负责人
            ,remark -- 备注
            ,rpftch -- 报送口径(冗余字段，统一设置参数，已迁移到cbrc_shet_brch表)
            ,scheid -- 编排顺序号
            ,ftitle -- 报文标题
            ,stitle -- 报文子标题_x0013_
            ,crcycd -- 币种(冗余字段，无意义)
            ,shetsn -- 报文英文名称
            ,curent -- 是否实时报表
            ,stacid -- 帐套id
            ,isbala -- 是否涉及手工调账（1是2否）
            ,isused -- 启用（1是2否）
            ,shettp -- 报表类型（1固定报表2动态报表）
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.tgls_cbrc_shet_info_op(
            subsys -- 子系统编号
            ,shetcd -- 报表编码
            ,shetna -- 报表名称
            ,reptfq -- 报表统计频度
            ,reptut -- 报表单位
            ,reptfg -- 上报标志
            ,begndt -- 启用日期
            ,overdt -- 停用日期
            ,shetmp -- 报表大类
            ,shetsp -- 报表子类
            ,procna -- 报表数据集(冗余字段，统一设置参数，已迁移到cbrc_shet_brch表)
            ,inptfg -- 报表生成方式
            ,tabtor -- 报表创建人
            ,revwer -- 报表评审人
            ,resper -- 报表负责人
            ,remark -- 备注
            ,rpftch -- 报送口径(冗余字段，统一设置参数，已迁移到cbrc_shet_brch表)
            ,scheid -- 编排顺序号
            ,ftitle -- 报文标题
            ,stitle -- 报文子标题_x0013_
            ,crcycd -- 币种(冗余字段，无意义)
            ,shetsn -- 报文英文名称
            ,curent -- 是否实时报表
            ,stacid -- 帐套id
            ,isbala -- 是否涉及手工调账（1是2否）
            ,isused -- 启用（1是2否）
            ,shettp -- 报表类型（1固定报表2动态报表）
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.subsys -- 子系统编号
    ,o.shetcd -- 报表编码
    ,o.shetna -- 报表名称
    ,o.reptfq -- 报表统计频度
    ,o.reptut -- 报表单位
    ,o.reptfg -- 上报标志
    ,o.begndt -- 启用日期
    ,o.overdt -- 停用日期
    ,o.shetmp -- 报表大类
    ,o.shetsp -- 报表子类
    ,o.procna -- 报表数据集(冗余字段，统一设置参数，已迁移到cbrc_shet_brch表)
    ,o.inptfg -- 报表生成方式
    ,o.tabtor -- 报表创建人
    ,o.revwer -- 报表评审人
    ,o.resper -- 报表负责人
    ,o.remark -- 备注
    ,o.rpftch -- 报送口径(冗余字段，统一设置参数，已迁移到cbrc_shet_brch表)
    ,o.scheid -- 编排顺序号
    ,o.ftitle -- 报文标题
    ,o.stitle -- 报文子标题_x0013_
    ,o.crcycd -- 币种(冗余字段，无意义)
    ,o.shetsn -- 报文英文名称
    ,o.curent -- 是否实时报表
    ,o.stacid -- 帐套id
    ,o.isbala -- 是否涉及手工调账（1是2否）
    ,o.isused -- 启用（1是2否）
    ,o.shettp -- 报表类型（1固定报表2动态报表）
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
from ${iol_schema}.tgls_cbrc_shet_info_bk o
    left join ${iol_schema}.tgls_cbrc_shet_info_op n
        on
            o.shetcd = n.shetcd
            and o.stacid = n.stacid
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.tgls_cbrc_shet_info_cl d
        on
            o.shetcd = d.shetcd
            and o.stacid = d.stacid
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
--truncate table ${iol_schema}.tgls_cbrc_shet_info;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('tgls_cbrc_shet_info') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.tgls_cbrc_shet_info drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.tgls_cbrc_shet_info add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.tgls_cbrc_shet_info exchange partition p_${batch_date} with table ${iol_schema}.tgls_cbrc_shet_info_cl;
alter table ${iol_schema}.tgls_cbrc_shet_info exchange partition p_20991231 with table ${iol_schema}.tgls_cbrc_shet_info_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.tgls_cbrc_shet_info to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.tgls_cbrc_shet_info_op purge;
drop table ${iol_schema}.tgls_cbrc_shet_info_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.tgls_cbrc_shet_info_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'tgls_cbrc_shet_info',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
