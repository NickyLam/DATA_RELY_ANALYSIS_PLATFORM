/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_icms_clr_asset_property_landright
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
create table ${iol_schema}.icms_clr_asset_property_landright_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.icms_clr_asset_property_landright
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.icms_clr_asset_property_landright_op purge;
drop table ${iol_schema}.icms_clr_asset_property_landright_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.icms_clr_asset_property_landright_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.icms_clr_asset_property_landright where 0=1;

create table ${iol_schema}.icms_clr_asset_property_landright_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.icms_clr_asset_property_landright where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.icms_clr_asset_property_landright_cl(
            clrid -- 押品编号
            ,landno -- 土地证号
            ,warrantsno -- 土地承包经营权权证号（该字段仅文化旅游用地使用权和其他土地使用权这两类使用）
            ,landusenature -- 土地使用权性质
            ,landgainway -- 土地使用权取得方式
            ,landstartdate -- 土地使用权起始日期-(除了文化旅游用地使用权和其他土地使用权这两类)/土地承包经营权取得日期-（文化旅游用地使用权和其他土地使用权）
            ,landenddate -- 土地使用权到期日期-(除了文化旅游用地使用权和其他土地使用权这两类)/土地承包经营权到期日期-（文化旅游用地使用权和其他土地使用权）
            ,landusering -- 土地用途
            ,landusearea -- 土地使用权面积-(除了文化旅游用地使用权和其他土地使用权这两类)/土地承包经营权面积(平方米)-（文化旅游用地使用权和其他土地使用权）
            ,landtype -- 闲置土地类型
            ,province -- 所在/注册省份
            ,city -- 所在/注册市
            ,counties -- 所在县（区）
            ,street -- 街道/村镇/路名
            ,address -- 土地详细地址-(除了文化旅游用地使用权和其他土地使用权这两类)/土地承包经营权地址-（文化旅游用地使用权和其他土地使用权）
            ,landdec -- 宗地号
            ,tradedate -- 购买时间
            ,tradeprice -- 购买价格
            ,isattachments -- 是否有地上附着物
            ,attachmenttype -- 附着物种类
            ,buildterm -- 地上建筑物项数
            ,attachmentowner -- 附着物所有权人名称
            ,attachmentregion -- 附着物所有权人范围
            ,overallfloorage -- 地上附着物总面积
            ,remark -- 其他说明
            ,tdcurrency -- 币种
            ,landsubtype -- 使用权细类
            ,migtflag -- 迁移标识：rs rcr ilc upl mim
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.icms_clr_asset_property_landright_op(
            clrid -- 押品编号
            ,landno -- 土地证号
            ,warrantsno -- 土地承包经营权权证号（该字段仅文化旅游用地使用权和其他土地使用权这两类使用）
            ,landusenature -- 土地使用权性质
            ,landgainway -- 土地使用权取得方式
            ,landstartdate -- 土地使用权起始日期-(除了文化旅游用地使用权和其他土地使用权这两类)/土地承包经营权取得日期-（文化旅游用地使用权和其他土地使用权）
            ,landenddate -- 土地使用权到期日期-(除了文化旅游用地使用权和其他土地使用权这两类)/土地承包经营权到期日期-（文化旅游用地使用权和其他土地使用权）
            ,landusering -- 土地用途
            ,landusearea -- 土地使用权面积-(除了文化旅游用地使用权和其他土地使用权这两类)/土地承包经营权面积(平方米)-（文化旅游用地使用权和其他土地使用权）
            ,landtype -- 闲置土地类型
            ,province -- 所在/注册省份
            ,city -- 所在/注册市
            ,counties -- 所在县（区）
            ,street -- 街道/村镇/路名
            ,address -- 土地详细地址-(除了文化旅游用地使用权和其他土地使用权这两类)/土地承包经营权地址-（文化旅游用地使用权和其他土地使用权）
            ,landdec -- 宗地号
            ,tradedate -- 购买时间
            ,tradeprice -- 购买价格
            ,isattachments -- 是否有地上附着物
            ,attachmenttype -- 附着物种类
            ,buildterm -- 地上建筑物项数
            ,attachmentowner -- 附着物所有权人名称
            ,attachmentregion -- 附着物所有权人范围
            ,overallfloorage -- 地上附着物总面积
            ,remark -- 其他说明
            ,tdcurrency -- 币种
            ,landsubtype -- 使用权细类
            ,migtflag -- 迁移标识：rs rcr ilc upl mim
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.clrid, o.clrid) as clrid -- 押品编号
    ,nvl(n.landno, o.landno) as landno -- 土地证号
    ,nvl(n.warrantsno, o.warrantsno) as warrantsno -- 土地承包经营权权证号（该字段仅文化旅游用地使用权和其他土地使用权这两类使用）
    ,nvl(n.landusenature, o.landusenature) as landusenature -- 土地使用权性质
    ,nvl(n.landgainway, o.landgainway) as landgainway -- 土地使用权取得方式
    ,nvl(n.landstartdate, o.landstartdate) as landstartdate -- 土地使用权起始日期-(除了文化旅游用地使用权和其他土地使用权这两类)/土地承包经营权取得日期-（文化旅游用地使用权和其他土地使用权）
    ,nvl(n.landenddate, o.landenddate) as landenddate -- 土地使用权到期日期-(除了文化旅游用地使用权和其他土地使用权这两类)/土地承包经营权到期日期-（文化旅游用地使用权和其他土地使用权）
    ,nvl(n.landusering, o.landusering) as landusering -- 土地用途
    ,nvl(n.landusearea, o.landusearea) as landusearea -- 土地使用权面积-(除了文化旅游用地使用权和其他土地使用权这两类)/土地承包经营权面积(平方米)-（文化旅游用地使用权和其他土地使用权）
    ,nvl(n.landtype, o.landtype) as landtype -- 闲置土地类型
    ,nvl(n.province, o.province) as province -- 所在/注册省份
    ,nvl(n.city, o.city) as city -- 所在/注册市
    ,nvl(n.counties, o.counties) as counties -- 所在县（区）
    ,nvl(n.street, o.street) as street -- 街道/村镇/路名
    ,nvl(n.address, o.address) as address -- 土地详细地址-(除了文化旅游用地使用权和其他土地使用权这两类)/土地承包经营权地址-（文化旅游用地使用权和其他土地使用权）
    ,nvl(n.landdec, o.landdec) as landdec -- 宗地号
    ,nvl(n.tradedate, o.tradedate) as tradedate -- 购买时间
    ,nvl(n.tradeprice, o.tradeprice) as tradeprice -- 购买价格
    ,nvl(n.isattachments, o.isattachments) as isattachments -- 是否有地上附着物
    ,nvl(n.attachmenttype, o.attachmenttype) as attachmenttype -- 附着物种类
    ,nvl(n.buildterm, o.buildterm) as buildterm -- 地上建筑物项数
    ,nvl(n.attachmentowner, o.attachmentowner) as attachmentowner -- 附着物所有权人名称
    ,nvl(n.attachmentregion, o.attachmentregion) as attachmentregion -- 附着物所有权人范围
    ,nvl(n.overallfloorage, o.overallfloorage) as overallfloorage -- 地上附着物总面积
    ,nvl(n.remark, o.remark) as remark -- 其他说明
    ,nvl(n.tdcurrency, o.tdcurrency) as tdcurrency -- 币种
    ,nvl(n.landsubtype, o.landsubtype) as landsubtype -- 使用权细类
    ,nvl(n.migtflag, o.migtflag) as migtflag -- 迁移标识：rs rcr ilc upl mim
    ,case when
            n.clrid is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.clrid is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.clrid is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.icms_clr_asset_property_landright_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.icms_clr_asset_property_landright where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.clrid = n.clrid
where (
        o.clrid is null
    )
    or (
        n.clrid is null
    )
    or (
        o.landno <> n.landno
        or o.warrantsno <> n.warrantsno
        or o.landusenature <> n.landusenature
        or o.landgainway <> n.landgainway
        or o.landstartdate <> n.landstartdate
        or o.landenddate <> n.landenddate
        or o.landusering <> n.landusering
        or o.landusearea <> n.landusearea
        or o.landtype <> n.landtype
        or o.province <> n.province
        or o.city <> n.city
        or o.counties <> n.counties
        or o.street <> n.street
        or o.address <> n.address
        or o.landdec <> n.landdec
        or o.tradedate <> n.tradedate
        or o.tradeprice <> n.tradeprice
        or o.isattachments <> n.isattachments
        or o.attachmenttype <> n.attachmenttype
        or o.buildterm <> n.buildterm
        or o.attachmentowner <> n.attachmentowner
        or o.attachmentregion <> n.attachmentregion
        or o.overallfloorage <> n.overallfloorage
        or o.remark <> n.remark
        or o.tdcurrency <> n.tdcurrency
        or o.landsubtype <> n.landsubtype
        or o.migtflag <> n.migtflag
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.icms_clr_asset_property_landright_cl(
            clrid -- 押品编号
            ,landno -- 土地证号
            ,warrantsno -- 土地承包经营权权证号（该字段仅文化旅游用地使用权和其他土地使用权这两类使用）
            ,landusenature -- 土地使用权性质
            ,landgainway -- 土地使用权取得方式
            ,landstartdate -- 土地使用权起始日期-(除了文化旅游用地使用权和其他土地使用权这两类)/土地承包经营权取得日期-（文化旅游用地使用权和其他土地使用权）
            ,landenddate -- 土地使用权到期日期-(除了文化旅游用地使用权和其他土地使用权这两类)/土地承包经营权到期日期-（文化旅游用地使用权和其他土地使用权）
            ,landusering -- 土地用途
            ,landusearea -- 土地使用权面积-(除了文化旅游用地使用权和其他土地使用权这两类)/土地承包经营权面积(平方米)-（文化旅游用地使用权和其他土地使用权）
            ,landtype -- 闲置土地类型
            ,province -- 所在/注册省份
            ,city -- 所在/注册市
            ,counties -- 所在县（区）
            ,street -- 街道/村镇/路名
            ,address -- 土地详细地址-(除了文化旅游用地使用权和其他土地使用权这两类)/土地承包经营权地址-（文化旅游用地使用权和其他土地使用权）
            ,landdec -- 宗地号
            ,tradedate -- 购买时间
            ,tradeprice -- 购买价格
            ,isattachments -- 是否有地上附着物
            ,attachmenttype -- 附着物种类
            ,buildterm -- 地上建筑物项数
            ,attachmentowner -- 附着物所有权人名称
            ,attachmentregion -- 附着物所有权人范围
            ,overallfloorage -- 地上附着物总面积
            ,remark -- 其他说明
            ,tdcurrency -- 币种
            ,landsubtype -- 使用权细类
            ,migtflag -- 迁移标识：rs rcr ilc upl mim
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.icms_clr_asset_property_landright_op(
            clrid -- 押品编号
            ,landno -- 土地证号
            ,warrantsno -- 土地承包经营权权证号（该字段仅文化旅游用地使用权和其他土地使用权这两类使用）
            ,landusenature -- 土地使用权性质
            ,landgainway -- 土地使用权取得方式
            ,landstartdate -- 土地使用权起始日期-(除了文化旅游用地使用权和其他土地使用权这两类)/土地承包经营权取得日期-（文化旅游用地使用权和其他土地使用权）
            ,landenddate -- 土地使用权到期日期-(除了文化旅游用地使用权和其他土地使用权这两类)/土地承包经营权到期日期-（文化旅游用地使用权和其他土地使用权）
            ,landusering -- 土地用途
            ,landusearea -- 土地使用权面积-(除了文化旅游用地使用权和其他土地使用权这两类)/土地承包经营权面积(平方米)-（文化旅游用地使用权和其他土地使用权）
            ,landtype -- 闲置土地类型
            ,province -- 所在/注册省份
            ,city -- 所在/注册市
            ,counties -- 所在县（区）
            ,street -- 街道/村镇/路名
            ,address -- 土地详细地址-(除了文化旅游用地使用权和其他土地使用权这两类)/土地承包经营权地址-（文化旅游用地使用权和其他土地使用权）
            ,landdec -- 宗地号
            ,tradedate -- 购买时间
            ,tradeprice -- 购买价格
            ,isattachments -- 是否有地上附着物
            ,attachmenttype -- 附着物种类
            ,buildterm -- 地上建筑物项数
            ,attachmentowner -- 附着物所有权人名称
            ,attachmentregion -- 附着物所有权人范围
            ,overallfloorage -- 地上附着物总面积
            ,remark -- 其他说明
            ,tdcurrency -- 币种
            ,landsubtype -- 使用权细类
            ,migtflag -- 迁移标识：rs rcr ilc upl mim
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.clrid -- 押品编号
    ,o.landno -- 土地证号
    ,o.warrantsno -- 土地承包经营权权证号（该字段仅文化旅游用地使用权和其他土地使用权这两类使用）
    ,o.landusenature -- 土地使用权性质
    ,o.landgainway -- 土地使用权取得方式
    ,o.landstartdate -- 土地使用权起始日期-(除了文化旅游用地使用权和其他土地使用权这两类)/土地承包经营权取得日期-（文化旅游用地使用权和其他土地使用权）
    ,o.landenddate -- 土地使用权到期日期-(除了文化旅游用地使用权和其他土地使用权这两类)/土地承包经营权到期日期-（文化旅游用地使用权和其他土地使用权）
    ,o.landusering -- 土地用途
    ,o.landusearea -- 土地使用权面积-(除了文化旅游用地使用权和其他土地使用权这两类)/土地承包经营权面积(平方米)-（文化旅游用地使用权和其他土地使用权）
    ,o.landtype -- 闲置土地类型
    ,o.province -- 所在/注册省份
    ,o.city -- 所在/注册市
    ,o.counties -- 所在县（区）
    ,o.street -- 街道/村镇/路名
    ,o.address -- 土地详细地址-(除了文化旅游用地使用权和其他土地使用权这两类)/土地承包经营权地址-（文化旅游用地使用权和其他土地使用权）
    ,o.landdec -- 宗地号
    ,o.tradedate -- 购买时间
    ,o.tradeprice -- 购买价格
    ,o.isattachments -- 是否有地上附着物
    ,o.attachmenttype -- 附着物种类
    ,o.buildterm -- 地上建筑物项数
    ,o.attachmentowner -- 附着物所有权人名称
    ,o.attachmentregion -- 附着物所有权人范围
    ,o.overallfloorage -- 地上附着物总面积
    ,o.remark -- 其他说明
    ,o.tdcurrency -- 币种
    ,o.landsubtype -- 使用权细类
    ,o.migtflag -- 迁移标识：rs rcr ilc upl mim
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
from ${iol_schema}.icms_clr_asset_property_landright_bk o
    left join ${iol_schema}.icms_clr_asset_property_landright_op n
        on
            o.clrid = n.clrid
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.icms_clr_asset_property_landright_cl d
        on
            o.clrid = d.clrid
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
--truncate table ${iol_schema}.icms_clr_asset_property_landright;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('icms_clr_asset_property_landright') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.icms_clr_asset_property_landright drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.icms_clr_asset_property_landright add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.icms_clr_asset_property_landright exchange partition p_${batch_date} with table ${iol_schema}.icms_clr_asset_property_landright_cl;
alter table ${iol_schema}.icms_clr_asset_property_landright exchange partition p_20991231 with table ${iol_schema}.icms_clr_asset_property_landright_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.icms_clr_asset_property_landright to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.icms_clr_asset_property_landright_op purge;
drop table ${iol_schema}.icms_clr_asset_property_landright_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.icms_clr_asset_property_landright_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'icms_clr_asset_property_landright',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
