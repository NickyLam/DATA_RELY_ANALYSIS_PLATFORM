/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_mims_si_buildinginfo
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
create table ${iol_schema}.mims_si_buildinginfo_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.mims_si_buildinginfo;

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.mims_si_buildinginfo_op purge;
drop table ${iol_schema}.mims_si_buildinginfo_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.mims_si_buildinginfo_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.mims_si_buildinginfo where 0=1;

create table ${iol_schema}.mims_si_buildinginfo_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.mims_si_buildinginfo where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.mims_si_buildinginfo_cl(
            buildingno -- 楼盘编号
            ,buildingname -- 楼盘名称
            ,buildingalias -- 楼盘别名
            ,genus -- 行政区域
            ,area -- 片区
            ,neighbouraddress -- 小区地址
            ,longitude -- 经度
            ,latitude -- 维度
            ,cooperatename -- 开发商
            ,completdate -- 竣工时间
            ,sertypename -- 物业类别
            ,area1 -- 所属区域
            ,traffic -- 交通便捷度
            ,nature -- 自然环境
            ,naturedes -- 人文环境
            ,living -- 公共配套设施
            ,buildingnomaturity -- 居住社区成熟度
            ,jzwgggzx -- 建筑外观与公共装修
            ,sssb -- 设施设备
            ,wyglzzdj -- 物业管理资质等级
            ,bctj -- 泊车条件
            ,sfxqf -- 是否学区房
            ,rjl -- 容积率
            ,sfdcq -- 是否待拆迁
            ,remark -- 备注
            ,pmbzyld -- 平面布置优劣度
            ,jg -- 景观
            ,jzjg -- 建筑结构
            ,account -- 用户
            ,createrdept -- 
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.mims_si_buildinginfo_op(
            buildingno -- 楼盘编号
            ,buildingname -- 楼盘名称
            ,buildingalias -- 楼盘别名
            ,genus -- 行政区域
            ,area -- 片区
            ,neighbouraddress -- 小区地址
            ,longitude -- 经度
            ,latitude -- 维度
            ,cooperatename -- 开发商
            ,completdate -- 竣工时间
            ,sertypename -- 物业类别
            ,area1 -- 所属区域
            ,traffic -- 交通便捷度
            ,nature -- 自然环境
            ,naturedes -- 人文环境
            ,living -- 公共配套设施
            ,buildingnomaturity -- 居住社区成熟度
            ,jzwgggzx -- 建筑外观与公共装修
            ,sssb -- 设施设备
            ,wyglzzdj -- 物业管理资质等级
            ,bctj -- 泊车条件
            ,sfxqf -- 是否学区房
            ,rjl -- 容积率
            ,sfdcq -- 是否待拆迁
            ,remark -- 备注
            ,pmbzyld -- 平面布置优劣度
            ,jg -- 景观
            ,jzjg -- 建筑结构
            ,account -- 用户
            ,createrdept -- 
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.buildingno, o.buildingno) as buildingno -- 楼盘编号
    ,nvl(n.buildingname, o.buildingname) as buildingname -- 楼盘名称
    ,nvl(n.buildingalias, o.buildingalias) as buildingalias -- 楼盘别名
    ,nvl(n.genus, o.genus) as genus -- 行政区域
    ,nvl(n.area, o.area) as area -- 片区
    ,nvl(n.neighbouraddress, o.neighbouraddress) as neighbouraddress -- 小区地址
    ,nvl(n.longitude, o.longitude) as longitude -- 经度
    ,nvl(n.latitude, o.latitude) as latitude -- 维度
    ,nvl(n.cooperatename, o.cooperatename) as cooperatename -- 开发商
    ,nvl(n.completdate, o.completdate) as completdate -- 竣工时间
    ,nvl(n.sertypename, o.sertypename) as sertypename -- 物业类别
    ,nvl(n.area1, o.area1) as area1 -- 所属区域
    ,nvl(n.traffic, o.traffic) as traffic -- 交通便捷度
    ,nvl(n.nature, o.nature) as nature -- 自然环境
    ,nvl(n.naturedes, o.naturedes) as naturedes -- 人文环境
    ,nvl(n.living, o.living) as living -- 公共配套设施
    ,nvl(n.buildingnomaturity, o.buildingnomaturity) as buildingnomaturity -- 居住社区成熟度
    ,nvl(n.jzwgggzx, o.jzwgggzx) as jzwgggzx -- 建筑外观与公共装修
    ,nvl(n.sssb, o.sssb) as sssb -- 设施设备
    ,nvl(n.wyglzzdj, o.wyglzzdj) as wyglzzdj -- 物业管理资质等级
    ,nvl(n.bctj, o.bctj) as bctj -- 泊车条件
    ,nvl(n.sfxqf, o.sfxqf) as sfxqf -- 是否学区房
    ,nvl(n.rjl, o.rjl) as rjl -- 容积率
    ,nvl(n.sfdcq, o.sfdcq) as sfdcq -- 是否待拆迁
    ,nvl(n.remark, o.remark) as remark -- 备注
    ,nvl(n.pmbzyld, o.pmbzyld) as pmbzyld -- 平面布置优劣度
    ,nvl(n.jg, o.jg) as jg -- 景观
    ,nvl(n.jzjg, o.jzjg) as jzjg -- 建筑结构
    ,nvl(n.account, o.account) as account -- 用户
    ,nvl(n.createrdept, o.createrdept) as createrdept -- 
    ,case when
            n.buildingno is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.buildingno is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.buildingno is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.mims_si_buildinginfo_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.mims_si_buildinginfo where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.buildingno = n.buildingno
where (
        o.buildingno is null
    )
    or (
        n.buildingno is null
    )
    or (
        o.buildingname <> n.buildingname
        or o.buildingalias <> n.buildingalias
        or o.genus <> n.genus
        or o.area <> n.area
        or o.neighbouraddress <> n.neighbouraddress
        or o.longitude <> n.longitude
        or o.latitude <> n.latitude
        or o.cooperatename <> n.cooperatename
        or o.completdate <> n.completdate
        or o.sertypename <> n.sertypename
        or o.area1 <> n.area1
        or o.traffic <> n.traffic
        or o.nature <> n.nature
        or o.naturedes <> n.naturedes
        or o.living <> n.living
        or o.buildingnomaturity <> n.buildingnomaturity
        or o.jzwgggzx <> n.jzwgggzx
        or o.sssb <> n.sssb
        or o.wyglzzdj <> n.wyglzzdj
        or o.bctj <> n.bctj
        or o.sfxqf <> n.sfxqf
        or o.rjl <> n.rjl
        or o.sfdcq <> n.sfdcq
        or o.remark <> n.remark
        or o.pmbzyld <> n.pmbzyld
        or o.jg <> n.jg
        or o.jzjg <> n.jzjg
        or o.account <> n.account
        or o.createrdept <> n.createrdept
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.mims_si_buildinginfo_cl(
            buildingno -- 楼盘编号
            ,buildingname -- 楼盘名称
            ,buildingalias -- 楼盘别名
            ,genus -- 行政区域
            ,area -- 片区
            ,neighbouraddress -- 小区地址
            ,longitude -- 经度
            ,latitude -- 维度
            ,cooperatename -- 开发商
            ,completdate -- 竣工时间
            ,sertypename -- 物业类别
            ,area1 -- 所属区域
            ,traffic -- 交通便捷度
            ,nature -- 自然环境
            ,naturedes -- 人文环境
            ,living -- 公共配套设施
            ,buildingnomaturity -- 居住社区成熟度
            ,jzwgggzx -- 建筑外观与公共装修
            ,sssb -- 设施设备
            ,wyglzzdj -- 物业管理资质等级
            ,bctj -- 泊车条件
            ,sfxqf -- 是否学区房
            ,rjl -- 容积率
            ,sfdcq -- 是否待拆迁
            ,remark -- 备注
            ,pmbzyld -- 平面布置优劣度
            ,jg -- 景观
            ,jzjg -- 建筑结构
            ,account -- 用户
            ,createrdept -- 
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.mims_si_buildinginfo_op(
            buildingno -- 楼盘编号
            ,buildingname -- 楼盘名称
            ,buildingalias -- 楼盘别名
            ,genus -- 行政区域
            ,area -- 片区
            ,neighbouraddress -- 小区地址
            ,longitude -- 经度
            ,latitude -- 维度
            ,cooperatename -- 开发商
            ,completdate -- 竣工时间
            ,sertypename -- 物业类别
            ,area1 -- 所属区域
            ,traffic -- 交通便捷度
            ,nature -- 自然环境
            ,naturedes -- 人文环境
            ,living -- 公共配套设施
            ,buildingnomaturity -- 居住社区成熟度
            ,jzwgggzx -- 建筑外观与公共装修
            ,sssb -- 设施设备
            ,wyglzzdj -- 物业管理资质等级
            ,bctj -- 泊车条件
            ,sfxqf -- 是否学区房
            ,rjl -- 容积率
            ,sfdcq -- 是否待拆迁
            ,remark -- 备注
            ,pmbzyld -- 平面布置优劣度
            ,jg -- 景观
            ,jzjg -- 建筑结构
            ,account -- 用户
            ,createrdept -- 
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.buildingno -- 楼盘编号
    ,o.buildingname -- 楼盘名称
    ,o.buildingalias -- 楼盘别名
    ,o.genus -- 行政区域
    ,o.area -- 片区
    ,o.neighbouraddress -- 小区地址
    ,o.longitude -- 经度
    ,o.latitude -- 维度
    ,o.cooperatename -- 开发商
    ,o.completdate -- 竣工时间
    ,o.sertypename -- 物业类别
    ,o.area1 -- 所属区域
    ,o.traffic -- 交通便捷度
    ,o.nature -- 自然环境
    ,o.naturedes -- 人文环境
    ,o.living -- 公共配套设施
    ,o.buildingnomaturity -- 居住社区成熟度
    ,o.jzwgggzx -- 建筑外观与公共装修
    ,o.sssb -- 设施设备
    ,o.wyglzzdj -- 物业管理资质等级
    ,o.bctj -- 泊车条件
    ,o.sfxqf -- 是否学区房
    ,o.rjl -- 容积率
    ,o.sfdcq -- 是否待拆迁
    ,o.remark -- 备注
    ,o.pmbzyld -- 平面布置优劣度
    ,o.jg -- 景观
    ,o.jzjg -- 建筑结构
    ,o.account -- 用户
    ,o.createrdept -- 
    ,o.start_dt -- 开始时间
    ,case when n.start_dt is not null then to_date('${batch_date}', 'yyyymmdd')
          when o.end_dt >= to_date('${batch_date}','yyyymmdd') then to_date('20991231','yyyymmdd')
          else o.end_dt
     end as end_dt -- 结束时间
    ,o.id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from ${iol_schema}.mims_si_buildinginfo_bk o
    left join ${iol_schema}.mims_si_buildinginfo_op n
        on
            o.buildingno = n.buildingno
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.mims_si_buildinginfo_cl d
        on
            o.buildingno = d.buildingno
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
-- truncate table ${iol_schema}.mims_si_buildinginfo;

-- 4.2 exchange partition
alter table ${iol_schema}.mims_si_buildinginfo exchange partition p_19000101 with table ${iol_schema}.mims_si_buildinginfo_cl;
alter table ${iol_schema}.mims_si_buildinginfo exchange partition p_20991231 with table ${iol_schema}.mims_si_buildinginfo_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.mims_si_buildinginfo to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.mims_si_buildinginfo_op purge;
drop table ${iol_schema}.mims_si_buildinginfo_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.mims_si_buildinginfo_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'mims_si_buildinginfo',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
