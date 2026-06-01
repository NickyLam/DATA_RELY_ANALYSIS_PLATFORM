/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_icms_partner_vehicle
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
create table ${iol_schema}.icms_partner_vehicle_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.icms_partner_vehicle
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.icms_partner_vehicle_op purge;
drop table ${iol_schema}.icms_partner_vehicle_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.icms_partner_vehicle_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.icms_partner_vehicle where 0=1;

create table ${iol_schema}.icms_partner_vehicle_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.icms_partner_vehicle where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.icms_partner_vehicle_cl(
            serialno -- 流水号
            ,spstoreadd1 -- 专卖店地址1
            ,corporgid -- 法人机构编号
            ,sellcomname -- 销售商名称
            ,managertelephone -- 电话
            ,vehicletype -- 车辆类型
            ,importflag -- 是否为进口车是否为进口车（代码：1-是2-否）
            ,loadweight -- 载重
            ,cooperatemode -- 合作模式合作模式(代码：1-经销商模式2-生产商模式3-经销商模式+生产商模式)
            ,updatedate -- 更新日期
            ,brand -- 车辆品牌
            ,cylindercapacity -- 气缸容量
            ,updateorgid -- 更新机构
            ,vehicleno -- 车辆编号
            ,color -- 颜色
            ,inputorgid -- 登记机构
            ,brandmodel -- 品牌型号
            ,supplier -- 供应商
            ,grossweight -- 毛重
            ,coopbrand -- 合作品牌
            ,fueltype -- 驱动燃料类型
            ,coopbrandname -- 合作品牌名称
            ,ratedload -- 额定载客人数
            ,inputuserid -- 登记人
            ,updateuserid -- 更新人
            ,sellbranchcount -- 销售网点数量
            ,inputdate -- 登记日期
            ,standno -- 站位数目
            ,totalweight -- 总重
            ,managername -- 负责人姓名
            ,managercerttype -- 负责人证件类型
            ,migtflag -- 迁移标志：crsrcrilcupl
            ,manudate -- 生产日期
            ,spstoreadd2 -- 专卖店地址2
            ,managercertid -- 负责人证件号码
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.icms_partner_vehicle_op(
            serialno -- 流水号
            ,spstoreadd1 -- 专卖店地址1
            ,corporgid -- 法人机构编号
            ,sellcomname -- 销售商名称
            ,managertelephone -- 电话
            ,vehicletype -- 车辆类型
            ,importflag -- 是否为进口车是否为进口车（代码：1-是2-否）
            ,loadweight -- 载重
            ,cooperatemode -- 合作模式合作模式(代码：1-经销商模式2-生产商模式3-经销商模式+生产商模式)
            ,updatedate -- 更新日期
            ,brand -- 车辆品牌
            ,cylindercapacity -- 气缸容量
            ,updateorgid -- 更新机构
            ,vehicleno -- 车辆编号
            ,color -- 颜色
            ,inputorgid -- 登记机构
            ,brandmodel -- 品牌型号
            ,supplier -- 供应商
            ,grossweight -- 毛重
            ,coopbrand -- 合作品牌
            ,fueltype -- 驱动燃料类型
            ,coopbrandname -- 合作品牌名称
            ,ratedload -- 额定载客人数
            ,inputuserid -- 登记人
            ,updateuserid -- 更新人
            ,sellbranchcount -- 销售网点数量
            ,inputdate -- 登记日期
            ,standno -- 站位数目
            ,totalweight -- 总重
            ,managername -- 负责人姓名
            ,managercerttype -- 负责人证件类型
            ,migtflag -- 迁移标志：crsrcrilcupl
            ,manudate -- 生产日期
            ,spstoreadd2 -- 专卖店地址2
            ,managercertid -- 负责人证件号码
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.serialno, o.serialno) as serialno -- 流水号
    ,nvl(n.spstoreadd1, o.spstoreadd1) as spstoreadd1 -- 专卖店地址1
    ,nvl(n.corporgid, o.corporgid) as corporgid -- 法人机构编号
    ,nvl(n.sellcomname, o.sellcomname) as sellcomname -- 销售商名称
    ,nvl(n.managertelephone, o.managertelephone) as managertelephone -- 电话
    ,nvl(n.vehicletype, o.vehicletype) as vehicletype -- 车辆类型
    ,nvl(n.importflag, o.importflag) as importflag -- 是否为进口车是否为进口车（代码：1-是2-否）
    ,nvl(n.loadweight, o.loadweight) as loadweight -- 载重
    ,nvl(n.cooperatemode, o.cooperatemode) as cooperatemode -- 合作模式合作模式(代码：1-经销商模式2-生产商模式3-经销商模式+生产商模式)
    ,nvl(n.updatedate, o.updatedate) as updatedate -- 更新日期
    ,nvl(n.brand, o.brand) as brand -- 车辆品牌
    ,nvl(n.cylindercapacity, o.cylindercapacity) as cylindercapacity -- 气缸容量
    ,nvl(n.updateorgid, o.updateorgid) as updateorgid -- 更新机构
    ,nvl(n.vehicleno, o.vehicleno) as vehicleno -- 车辆编号
    ,nvl(n.color, o.color) as color -- 颜色
    ,nvl(n.inputorgid, o.inputorgid) as inputorgid -- 登记机构
    ,nvl(n.brandmodel, o.brandmodel) as brandmodel -- 品牌型号
    ,nvl(n.supplier, o.supplier) as supplier -- 供应商
    ,nvl(n.grossweight, o.grossweight) as grossweight -- 毛重
    ,nvl(n.coopbrand, o.coopbrand) as coopbrand -- 合作品牌
    ,nvl(n.fueltype, o.fueltype) as fueltype -- 驱动燃料类型
    ,nvl(n.coopbrandname, o.coopbrandname) as coopbrandname -- 合作品牌名称
    ,nvl(n.ratedload, o.ratedload) as ratedload -- 额定载客人数
    ,nvl(n.inputuserid, o.inputuserid) as inputuserid -- 登记人
    ,nvl(n.updateuserid, o.updateuserid) as updateuserid -- 更新人
    ,nvl(n.sellbranchcount, o.sellbranchcount) as sellbranchcount -- 销售网点数量
    ,nvl(n.inputdate, o.inputdate) as inputdate -- 登记日期
    ,nvl(n.standno, o.standno) as standno -- 站位数目
    ,nvl(n.totalweight, o.totalweight) as totalweight -- 总重
    ,nvl(n.managername, o.managername) as managername -- 负责人姓名
    ,nvl(n.managercerttype, o.managercerttype) as managercerttype -- 负责人证件类型
    ,nvl(n.migtflag, o.migtflag) as migtflag -- 迁移标志：crsrcrilcupl
    ,nvl(n.manudate, o.manudate) as manudate -- 生产日期
    ,nvl(n.spstoreadd2, o.spstoreadd2) as spstoreadd2 -- 专卖店地址2
    ,nvl(n.managercertid, o.managercertid) as managercertid -- 负责人证件号码
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
from (select * from ${iol_schema}.icms_partner_vehicle_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.icms_partner_vehicle where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.serialno = n.serialno
where (
        o.serialno is null
    )
    or (
        n.serialno is null
    )
    or (
        o.spstoreadd1 <> n.spstoreadd1
        or o.corporgid <> n.corporgid
        or o.sellcomname <> n.sellcomname
        or o.managertelephone <> n.managertelephone
        or o.vehicletype <> n.vehicletype
        or o.importflag <> n.importflag
        or o.loadweight <> n.loadweight
        or o.cooperatemode <> n.cooperatemode
        or o.updatedate <> n.updatedate
        or o.brand <> n.brand
        or o.cylindercapacity <> n.cylindercapacity
        or o.updateorgid <> n.updateorgid
        or o.vehicleno <> n.vehicleno
        or o.color <> n.color
        or o.inputorgid <> n.inputorgid
        or o.brandmodel <> n.brandmodel
        or o.supplier <> n.supplier
        or o.grossweight <> n.grossweight
        or o.coopbrand <> n.coopbrand
        or o.fueltype <> n.fueltype
        or o.coopbrandname <> n.coopbrandname
        or o.ratedload <> n.ratedload
        or o.inputuserid <> n.inputuserid
        or o.updateuserid <> n.updateuserid
        or o.sellbranchcount <> n.sellbranchcount
        or o.inputdate <> n.inputdate
        or o.standno <> n.standno
        or o.totalweight <> n.totalweight
        or o.managername <> n.managername
        or o.managercerttype <> n.managercerttype
        or o.migtflag <> n.migtflag
        or o.manudate <> n.manudate
        or o.spstoreadd2 <> n.spstoreadd2
        or o.managercertid <> n.managercertid
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.icms_partner_vehicle_cl(
            serialno -- 流水号
            ,spstoreadd1 -- 专卖店地址1
            ,corporgid -- 法人机构编号
            ,sellcomname -- 销售商名称
            ,managertelephone -- 电话
            ,vehicletype -- 车辆类型
            ,importflag -- 是否为进口车是否为进口车（代码：1-是2-否）
            ,loadweight -- 载重
            ,cooperatemode -- 合作模式合作模式(代码：1-经销商模式2-生产商模式3-经销商模式+生产商模式)
            ,updatedate -- 更新日期
            ,brand -- 车辆品牌
            ,cylindercapacity -- 气缸容量
            ,updateorgid -- 更新机构
            ,vehicleno -- 车辆编号
            ,color -- 颜色
            ,inputorgid -- 登记机构
            ,brandmodel -- 品牌型号
            ,supplier -- 供应商
            ,grossweight -- 毛重
            ,coopbrand -- 合作品牌
            ,fueltype -- 驱动燃料类型
            ,coopbrandname -- 合作品牌名称
            ,ratedload -- 额定载客人数
            ,inputuserid -- 登记人
            ,updateuserid -- 更新人
            ,sellbranchcount -- 销售网点数量
            ,inputdate -- 登记日期
            ,standno -- 站位数目
            ,totalweight -- 总重
            ,managername -- 负责人姓名
            ,managercerttype -- 负责人证件类型
            ,migtflag -- 迁移标志：crsrcrilcupl
            ,manudate -- 生产日期
            ,spstoreadd2 -- 专卖店地址2
            ,managercertid -- 负责人证件号码
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.icms_partner_vehicle_op(
            serialno -- 流水号
            ,spstoreadd1 -- 专卖店地址1
            ,corporgid -- 法人机构编号
            ,sellcomname -- 销售商名称
            ,managertelephone -- 电话
            ,vehicletype -- 车辆类型
            ,importflag -- 是否为进口车是否为进口车（代码：1-是2-否）
            ,loadweight -- 载重
            ,cooperatemode -- 合作模式合作模式(代码：1-经销商模式2-生产商模式3-经销商模式+生产商模式)
            ,updatedate -- 更新日期
            ,brand -- 车辆品牌
            ,cylindercapacity -- 气缸容量
            ,updateorgid -- 更新机构
            ,vehicleno -- 车辆编号
            ,color -- 颜色
            ,inputorgid -- 登记机构
            ,brandmodel -- 品牌型号
            ,supplier -- 供应商
            ,grossweight -- 毛重
            ,coopbrand -- 合作品牌
            ,fueltype -- 驱动燃料类型
            ,coopbrandname -- 合作品牌名称
            ,ratedload -- 额定载客人数
            ,inputuserid -- 登记人
            ,updateuserid -- 更新人
            ,sellbranchcount -- 销售网点数量
            ,inputdate -- 登记日期
            ,standno -- 站位数目
            ,totalweight -- 总重
            ,managername -- 负责人姓名
            ,managercerttype -- 负责人证件类型
            ,migtflag -- 迁移标志：crsrcrilcupl
            ,manudate -- 生产日期
            ,spstoreadd2 -- 专卖店地址2
            ,managercertid -- 负责人证件号码
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.serialno -- 流水号
    ,o.spstoreadd1 -- 专卖店地址1
    ,o.corporgid -- 法人机构编号
    ,o.sellcomname -- 销售商名称
    ,o.managertelephone -- 电话
    ,o.vehicletype -- 车辆类型
    ,o.importflag -- 是否为进口车是否为进口车（代码：1-是2-否）
    ,o.loadweight -- 载重
    ,o.cooperatemode -- 合作模式合作模式(代码：1-经销商模式2-生产商模式3-经销商模式+生产商模式)
    ,o.updatedate -- 更新日期
    ,o.brand -- 车辆品牌
    ,o.cylindercapacity -- 气缸容量
    ,o.updateorgid -- 更新机构
    ,o.vehicleno -- 车辆编号
    ,o.color -- 颜色
    ,o.inputorgid -- 登记机构
    ,o.brandmodel -- 品牌型号
    ,o.supplier -- 供应商
    ,o.grossweight -- 毛重
    ,o.coopbrand -- 合作品牌
    ,o.fueltype -- 驱动燃料类型
    ,o.coopbrandname -- 合作品牌名称
    ,o.ratedload -- 额定载客人数
    ,o.inputuserid -- 登记人
    ,o.updateuserid -- 更新人
    ,o.sellbranchcount -- 销售网点数量
    ,o.inputdate -- 登记日期
    ,o.standno -- 站位数目
    ,o.totalweight -- 总重
    ,o.managername -- 负责人姓名
    ,o.managercerttype -- 负责人证件类型
    ,o.migtflag -- 迁移标志：crsrcrilcupl
    ,o.manudate -- 生产日期
    ,o.spstoreadd2 -- 专卖店地址2
    ,o.managercertid -- 负责人证件号码
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
from ${iol_schema}.icms_partner_vehicle_bk o
    left join ${iol_schema}.icms_partner_vehicle_op n
        on
            o.serialno = n.serialno
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.icms_partner_vehicle_cl d
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
--truncate table ${iol_schema}.icms_partner_vehicle;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('icms_partner_vehicle') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.icms_partner_vehicle drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.icms_partner_vehicle add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.icms_partner_vehicle exchange partition p_${batch_date} with table ${iol_schema}.icms_partner_vehicle_cl;
alter table ${iol_schema}.icms_partner_vehicle exchange partition p_20991231 with table ${iol_schema}.icms_partner_vehicle_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.icms_partner_vehicle to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.icms_partner_vehicle_op purge;
drop table ${iol_schema}.icms_partner_vehicle_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.icms_partner_vehicle_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'icms_partner_vehicle',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
