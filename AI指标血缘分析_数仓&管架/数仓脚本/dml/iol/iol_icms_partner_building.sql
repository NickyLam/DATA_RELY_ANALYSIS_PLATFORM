/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_icms_partner_building
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
create table ${iol_schema}.icms_partner_building_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.icms_partner_building
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.icms_partner_building_op purge;
drop table ${iol_schema}.icms_partner_building_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.icms_partner_building_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.icms_partner_building where 0=1;

create table ${iol_schema}.icms_partner_building_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.icms_partner_building where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.icms_partner_building_cl(
            buildingno -- 楼盘编号
            ,buildingdevelopers -- 楼盘开发商
            ,constructarea -- 总建筑面积
            ,updatedate -- 更新日期
            ,buildingperiod -- 楼盘期数
            ,updataflag -- 批量更新标识
            ,repo -- 回购回购(是/否)
            ,projectprograminglicense -- 建设工程规划许可证编号
            ,inputuserid -- 登记人
            ,inuptorgid -- 登记机构
            ,updateorgid -- 更新机构
            ,prjtotalincom -- 项目总销售收入
            ,city -- 区域城市
            ,landprograminglicense -- 建筑用地规划许可证编号
            ,maincertificatedate -- 大产证办理日期
            ,inputdate -- 登记日期
            ,housetype -- 房产类型
            ,landcertlicense -- 土地使用证编号
            ,updateuserid -- 更新人
            ,startpermitlicense -- 开工许可证编号
            ,migtflag -- 迁移标志：crsrcrilcupl
            ,buildingname -- 楼盘名称
            ,devotesum -- 总投资金额
            ,floorarea -- 总占地面积
            ,predictfinishdate -- 预计竣工日期
            ,practicalfinishdate -- 实际竣工日期
            ,deliverydate -- 交房日期
            ,remark -- 备注
            ,corporgid -- 法人机构编号
            ,salelicense -- 销售许可证
            ,houseflag -- 房屋状况房屋状况(代码：1-期房2-现房3-其他)
            ,saledhousenum -- 已销售房套数
            ,seatingposition -- 坐落位置
            ,landusedeadline -- 土地使用截止年限
            ,prjotherpric -- 其他部分销售总价
            ,housestatus -- 楼盘状态
            ,prjrightname -- 项目权利人名称
            ,landcharacter -- 土地性质
            ,prjbegday -- 项目开工时间
            ,prjreadyinv -- 已投资金额
            ,appendant -- 附属物
            ,sidecertificatedate -- 小产证办理日期
            ,updateflag -- 批量更新标识
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.icms_partner_building_op(
            buildingno -- 楼盘编号
            ,buildingdevelopers -- 楼盘开发商
            ,constructarea -- 总建筑面积
            ,updatedate -- 更新日期
            ,buildingperiod -- 楼盘期数
            ,updataflag -- 批量更新标识
            ,repo -- 回购回购(是/否)
            ,projectprograminglicense -- 建设工程规划许可证编号
            ,inputuserid -- 登记人
            ,inuptorgid -- 登记机构
            ,updateorgid -- 更新机构
            ,prjtotalincom -- 项目总销售收入
            ,city -- 区域城市
            ,landprograminglicense -- 建筑用地规划许可证编号
            ,maincertificatedate -- 大产证办理日期
            ,inputdate -- 登记日期
            ,housetype -- 房产类型
            ,landcertlicense -- 土地使用证编号
            ,updateuserid -- 更新人
            ,startpermitlicense -- 开工许可证编号
            ,migtflag -- 迁移标志：crsrcrilcupl
            ,buildingname -- 楼盘名称
            ,devotesum -- 总投资金额
            ,floorarea -- 总占地面积
            ,predictfinishdate -- 预计竣工日期
            ,practicalfinishdate -- 实际竣工日期
            ,deliverydate -- 交房日期
            ,remark -- 备注
            ,corporgid -- 法人机构编号
            ,salelicense -- 销售许可证
            ,houseflag -- 房屋状况房屋状况(代码：1-期房2-现房3-其他)
            ,saledhousenum -- 已销售房套数
            ,seatingposition -- 坐落位置
            ,landusedeadline -- 土地使用截止年限
            ,prjotherpric -- 其他部分销售总价
            ,housestatus -- 楼盘状态
            ,prjrightname -- 项目权利人名称
            ,landcharacter -- 土地性质
            ,prjbegday -- 项目开工时间
            ,prjreadyinv -- 已投资金额
            ,appendant -- 附属物
            ,sidecertificatedate -- 小产证办理日期
            ,updateflag -- 批量更新标识
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.buildingno, o.buildingno) as buildingno -- 楼盘编号
    ,nvl(n.buildingdevelopers, o.buildingdevelopers) as buildingdevelopers -- 楼盘开发商
    ,nvl(n.constructarea, o.constructarea) as constructarea -- 总建筑面积
    ,nvl(n.updatedate, o.updatedate) as updatedate -- 更新日期
    ,nvl(n.buildingperiod, o.buildingperiod) as buildingperiod -- 楼盘期数
    ,nvl(n.updataflag, o.updataflag) as updataflag -- 批量更新标识
    ,nvl(n.repo, o.repo) as repo -- 回购回购(是/否)
    ,nvl(n.projectprograminglicense, o.projectprograminglicense) as projectprograminglicense -- 建设工程规划许可证编号
    ,nvl(n.inputuserid, o.inputuserid) as inputuserid -- 登记人
    ,nvl(n.inuptorgid, o.inuptorgid) as inuptorgid -- 登记机构
    ,nvl(n.updateorgid, o.updateorgid) as updateorgid -- 更新机构
    ,nvl(n.prjtotalincom, o.prjtotalincom) as prjtotalincom -- 项目总销售收入
    ,nvl(n.city, o.city) as city -- 区域城市
    ,nvl(n.landprograminglicense, o.landprograminglicense) as landprograminglicense -- 建筑用地规划许可证编号
    ,nvl(n.maincertificatedate, o.maincertificatedate) as maincertificatedate -- 大产证办理日期
    ,nvl(n.inputdate, o.inputdate) as inputdate -- 登记日期
    ,nvl(n.housetype, o.housetype) as housetype -- 房产类型
    ,nvl(n.landcertlicense, o.landcertlicense) as landcertlicense -- 土地使用证编号
    ,nvl(n.updateuserid, o.updateuserid) as updateuserid -- 更新人
    ,nvl(n.startpermitlicense, o.startpermitlicense) as startpermitlicense -- 开工许可证编号
    ,nvl(n.migtflag, o.migtflag) as migtflag -- 迁移标志：crsrcrilcupl
    ,nvl(n.buildingname, o.buildingname) as buildingname -- 楼盘名称
    ,nvl(n.devotesum, o.devotesum) as devotesum -- 总投资金额
    ,nvl(n.floorarea, o.floorarea) as floorarea -- 总占地面积
    ,nvl(n.predictfinishdate, o.predictfinishdate) as predictfinishdate -- 预计竣工日期
    ,nvl(n.practicalfinishdate, o.practicalfinishdate) as practicalfinishdate -- 实际竣工日期
    ,nvl(n.deliverydate, o.deliverydate) as deliverydate -- 交房日期
    ,nvl(n.remark, o.remark) as remark -- 备注
    ,nvl(n.corporgid, o.corporgid) as corporgid -- 法人机构编号
    ,nvl(n.salelicense, o.salelicense) as salelicense -- 销售许可证
    ,nvl(n.houseflag, o.houseflag) as houseflag -- 房屋状况房屋状况(代码：1-期房2-现房3-其他)
    ,nvl(n.saledhousenum, o.saledhousenum) as saledhousenum -- 已销售房套数
    ,nvl(n.seatingposition, o.seatingposition) as seatingposition -- 坐落位置
    ,nvl(n.landusedeadline, o.landusedeadline) as landusedeadline -- 土地使用截止年限
    ,nvl(n.prjotherpric, o.prjotherpric) as prjotherpric -- 其他部分销售总价
    ,nvl(n.housestatus, o.housestatus) as housestatus -- 楼盘状态
    ,nvl(n.prjrightname, o.prjrightname) as prjrightname -- 项目权利人名称
    ,nvl(n.landcharacter, o.landcharacter) as landcharacter -- 土地性质
    ,nvl(n.prjbegday, o.prjbegday) as prjbegday -- 项目开工时间
    ,nvl(n.prjreadyinv, o.prjreadyinv) as prjreadyinv -- 已投资金额
    ,nvl(n.appendant, o.appendant) as appendant -- 附属物
    ,nvl(n.sidecertificatedate, o.sidecertificatedate) as sidecertificatedate -- 小产证办理日期
    ,nvl(n.updateflag, o.updateflag) as updateflag -- 批量更新标识
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
from (select * from ${iol_schema}.icms_partner_building_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.icms_partner_building where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.buildingno = n.buildingno
where (
        o.buildingno is null
    )
    or (
        n.buildingno is null
    )
    or (
        o.buildingdevelopers <> n.buildingdevelopers
        or o.constructarea <> n.constructarea
        or o.updatedate <> n.updatedate
        or o.buildingperiod <> n.buildingperiod
        or o.updataflag <> n.updataflag
        or o.repo <> n.repo
        or o.projectprograminglicense <> n.projectprograminglicense
        or o.inputuserid <> n.inputuserid
        or o.inuptorgid <> n.inuptorgid
        or o.updateorgid <> n.updateorgid
        or o.prjtotalincom <> n.prjtotalincom
        or o.city <> n.city
        or o.landprograminglicense <> n.landprograminglicense
        or o.maincertificatedate <> n.maincertificatedate
        or o.inputdate <> n.inputdate
        or o.housetype <> n.housetype
        or o.landcertlicense <> n.landcertlicense
        or o.updateuserid <> n.updateuserid
        or o.startpermitlicense <> n.startpermitlicense
        or o.migtflag <> n.migtflag
        or o.buildingname <> n.buildingname
        or o.devotesum <> n.devotesum
        or o.floorarea <> n.floorarea
        or o.predictfinishdate <> n.predictfinishdate
        or o.practicalfinishdate <> n.practicalfinishdate
        or o.deliverydate <> n.deliverydate
        or o.remark <> n.remark
        or o.corporgid <> n.corporgid
        or o.salelicense <> n.salelicense
        or o.houseflag <> n.houseflag
        or o.saledhousenum <> n.saledhousenum
        or o.seatingposition <> n.seatingposition
        or o.landusedeadline <> n.landusedeadline
        or o.prjotherpric <> n.prjotherpric
        or o.housestatus <> n.housestatus
        or o.prjrightname <> n.prjrightname
        or o.landcharacter <> n.landcharacter
        or o.prjbegday <> n.prjbegday
        or o.prjreadyinv <> n.prjreadyinv
        or o.appendant <> n.appendant
        or o.sidecertificatedate <> n.sidecertificatedate
        or o.updateflag <> n.updateflag
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.icms_partner_building_cl(
            buildingno -- 楼盘编号
            ,buildingdevelopers -- 楼盘开发商
            ,constructarea -- 总建筑面积
            ,updatedate -- 更新日期
            ,buildingperiod -- 楼盘期数
            ,updataflag -- 批量更新标识
            ,repo -- 回购回购(是/否)
            ,projectprograminglicense -- 建设工程规划许可证编号
            ,inputuserid -- 登记人
            ,inuptorgid -- 登记机构
            ,updateorgid -- 更新机构
            ,prjtotalincom -- 项目总销售收入
            ,city -- 区域城市
            ,landprograminglicense -- 建筑用地规划许可证编号
            ,maincertificatedate -- 大产证办理日期
            ,inputdate -- 登记日期
            ,housetype -- 房产类型
            ,landcertlicense -- 土地使用证编号
            ,updateuserid -- 更新人
            ,startpermitlicense -- 开工许可证编号
            ,migtflag -- 迁移标志：crsrcrilcupl
            ,buildingname -- 楼盘名称
            ,devotesum -- 总投资金额
            ,floorarea -- 总占地面积
            ,predictfinishdate -- 预计竣工日期
            ,practicalfinishdate -- 实际竣工日期
            ,deliverydate -- 交房日期
            ,remark -- 备注
            ,corporgid -- 法人机构编号
            ,salelicense -- 销售许可证
            ,houseflag -- 房屋状况房屋状况(代码：1-期房2-现房3-其他)
            ,saledhousenum -- 已销售房套数
            ,seatingposition -- 坐落位置
            ,landusedeadline -- 土地使用截止年限
            ,prjotherpric -- 其他部分销售总价
            ,housestatus -- 楼盘状态
            ,prjrightname -- 项目权利人名称
            ,landcharacter -- 土地性质
            ,prjbegday -- 项目开工时间
            ,prjreadyinv -- 已投资金额
            ,appendant -- 附属物
            ,sidecertificatedate -- 小产证办理日期
            ,updateflag -- 批量更新标识
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.icms_partner_building_op(
            buildingno -- 楼盘编号
            ,buildingdevelopers -- 楼盘开发商
            ,constructarea -- 总建筑面积
            ,updatedate -- 更新日期
            ,buildingperiod -- 楼盘期数
            ,updataflag -- 批量更新标识
            ,repo -- 回购回购(是/否)
            ,projectprograminglicense -- 建设工程规划许可证编号
            ,inputuserid -- 登记人
            ,inuptorgid -- 登记机构
            ,updateorgid -- 更新机构
            ,prjtotalincom -- 项目总销售收入
            ,city -- 区域城市
            ,landprograminglicense -- 建筑用地规划许可证编号
            ,maincertificatedate -- 大产证办理日期
            ,inputdate -- 登记日期
            ,housetype -- 房产类型
            ,landcertlicense -- 土地使用证编号
            ,updateuserid -- 更新人
            ,startpermitlicense -- 开工许可证编号
            ,migtflag -- 迁移标志：crsrcrilcupl
            ,buildingname -- 楼盘名称
            ,devotesum -- 总投资金额
            ,floorarea -- 总占地面积
            ,predictfinishdate -- 预计竣工日期
            ,practicalfinishdate -- 实际竣工日期
            ,deliverydate -- 交房日期
            ,remark -- 备注
            ,corporgid -- 法人机构编号
            ,salelicense -- 销售许可证
            ,houseflag -- 房屋状况房屋状况(代码：1-期房2-现房3-其他)
            ,saledhousenum -- 已销售房套数
            ,seatingposition -- 坐落位置
            ,landusedeadline -- 土地使用截止年限
            ,prjotherpric -- 其他部分销售总价
            ,housestatus -- 楼盘状态
            ,prjrightname -- 项目权利人名称
            ,landcharacter -- 土地性质
            ,prjbegday -- 项目开工时间
            ,prjreadyinv -- 已投资金额
            ,appendant -- 附属物
            ,sidecertificatedate -- 小产证办理日期
            ,updateflag -- 批量更新标识
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.buildingno -- 楼盘编号
    ,o.buildingdevelopers -- 楼盘开发商
    ,o.constructarea -- 总建筑面积
    ,o.updatedate -- 更新日期
    ,o.buildingperiod -- 楼盘期数
    ,o.updataflag -- 批量更新标识
    ,o.repo -- 回购回购(是/否)
    ,o.projectprograminglicense -- 建设工程规划许可证编号
    ,o.inputuserid -- 登记人
    ,o.inuptorgid -- 登记机构
    ,o.updateorgid -- 更新机构
    ,o.prjtotalincom -- 项目总销售收入
    ,o.city -- 区域城市
    ,o.landprograminglicense -- 建筑用地规划许可证编号
    ,o.maincertificatedate -- 大产证办理日期
    ,o.inputdate -- 登记日期
    ,o.housetype -- 房产类型
    ,o.landcertlicense -- 土地使用证编号
    ,o.updateuserid -- 更新人
    ,o.startpermitlicense -- 开工许可证编号
    ,o.migtflag -- 迁移标志：crsrcrilcupl
    ,o.buildingname -- 楼盘名称
    ,o.devotesum -- 总投资金额
    ,o.floorarea -- 总占地面积
    ,o.predictfinishdate -- 预计竣工日期
    ,o.practicalfinishdate -- 实际竣工日期
    ,o.deliverydate -- 交房日期
    ,o.remark -- 备注
    ,o.corporgid -- 法人机构编号
    ,o.salelicense -- 销售许可证
    ,o.houseflag -- 房屋状况房屋状况(代码：1-期房2-现房3-其他)
    ,o.saledhousenum -- 已销售房套数
    ,o.seatingposition -- 坐落位置
    ,o.landusedeadline -- 土地使用截止年限
    ,o.prjotherpric -- 其他部分销售总价
    ,o.housestatus -- 楼盘状态
    ,o.prjrightname -- 项目权利人名称
    ,o.landcharacter -- 土地性质
    ,o.prjbegday -- 项目开工时间
    ,o.prjreadyinv -- 已投资金额
    ,o.appendant -- 附属物
    ,o.sidecertificatedate -- 小产证办理日期
    ,o.updateflag -- 批量更新标识
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
from ${iol_schema}.icms_partner_building_bk o
    left join ${iol_schema}.icms_partner_building_op n
        on
            o.buildingno = n.buildingno
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.icms_partner_building_cl d
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
--truncate table ${iol_schema}.icms_partner_building;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('icms_partner_building') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.icms_partner_building drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.icms_partner_building add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.icms_partner_building exchange partition p_${batch_date} with table ${iol_schema}.icms_partner_building_cl;
alter table ${iol_schema}.icms_partner_building exchange partition p_20991231 with table ${iol_schema}.icms_partner_building_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.icms_partner_building to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.icms_partner_building_op purge;
drop table ${iol_schema}.icms_partner_building_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.icms_partner_building_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'icms_partner_building',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
