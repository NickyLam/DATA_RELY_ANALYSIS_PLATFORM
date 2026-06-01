/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_mims_si_businessroom
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
create table ${iol_schema}.mims_si_businessroom_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.mims_si_businessroom
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.mims_si_businessroom_op purge;
drop table ${iol_schema}.mims_si_businessroom_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.mims_si_businessroom_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.mims_si_businessroom where 0=1;

create table ${iol_schema}.mims_si_businessroom_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.mims_si_businessroom where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.mims_si_businessroom_cl(
            sccode -- 押品编号
            ,isnewhouse -- 一手/二手标识
            ,istwotogether -- 是否两证合一
            ,warrantsno -- 房产证/不动产证号
            ,istotal -- 该产证所属房产是否全部抵押
            ,otherremark -- 部分抵押房产的部位描述
            ,contno -- 房地产买卖合同编号
            ,tradedate -- 购房日期
            ,tradeprice -- 购房总价
            ,buildingarea -- 建筑面积
            ,usearea -- 实用面积
            ,createyear -- 建成年份
            ,buildage -- 楼龄(年)
            ,roomstructe -- 房屋结构类型
            ,province -- 所在/注册省份
            ,city -- 所在/注册市
            ,counties -- 所在县（区）
            ,street -- 街道/村镇/路名
            ,roomno -- 门牌号/弄号
            ,address -- 房产证或不动产证地址/期房预售合同地址
            ,storeyno -- 层次（标的所在楼层）
            ,totalstoreyno -- 层数（标的所在总楼层）
            ,presentstatus -- 目前状态
            ,buildrightinfo -- 房屋产权期限信息
            ,landno -- 土地证号
            ,landusenature -- 土地使用权性质
            ,landgainway -- 土地使用权取得方式
            ,landstartdate -- 土地使用权起始日期
            ,landenddate -- 土地使用权到期日期
            ,landuseryear -- 土地使用年限
            ,landusering -- 土地用途
            ,isotherright -- 是否有他项权证
            ,remark -- 其他说明
            ,isrents -- 是否租赁
            ,hpaddr -- 承租人
            ,hiresdate -- 租赁起始日
            ,hireedate -- 租赁到期日
            ,hireremark -- 租赁情况说明
            ,tdcurrency -- 币种
            ,remainuseyear -- 剩余使用年限
            ,monmanagementfee -- 
            ,yearlyrental -- 租赁年收入（元）
            ,iscompleted -- 房屋是否已竣工
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.mims_si_businessroom_op(
            sccode -- 押品编号
            ,isnewhouse -- 一手/二手标识
            ,istwotogether -- 是否两证合一
            ,warrantsno -- 房产证/不动产证号
            ,istotal -- 该产证所属房产是否全部抵押
            ,otherremark -- 部分抵押房产的部位描述
            ,contno -- 房地产买卖合同编号
            ,tradedate -- 购房日期
            ,tradeprice -- 购房总价
            ,buildingarea -- 建筑面积
            ,usearea -- 实用面积
            ,createyear -- 建成年份
            ,buildage -- 楼龄(年)
            ,roomstructe -- 房屋结构类型
            ,province -- 所在/注册省份
            ,city -- 所在/注册市
            ,counties -- 所在县（区）
            ,street -- 街道/村镇/路名
            ,roomno -- 门牌号/弄号
            ,address -- 房产证或不动产证地址/期房预售合同地址
            ,storeyno -- 层次（标的所在楼层）
            ,totalstoreyno -- 层数（标的所在总楼层）
            ,presentstatus -- 目前状态
            ,buildrightinfo -- 房屋产权期限信息
            ,landno -- 土地证号
            ,landusenature -- 土地使用权性质
            ,landgainway -- 土地使用权取得方式
            ,landstartdate -- 土地使用权起始日期
            ,landenddate -- 土地使用权到期日期
            ,landuseryear -- 土地使用年限
            ,landusering -- 土地用途
            ,isotherright -- 是否有他项权证
            ,remark -- 其他说明
            ,isrents -- 是否租赁
            ,hpaddr -- 承租人
            ,hiresdate -- 租赁起始日
            ,hireedate -- 租赁到期日
            ,hireremark -- 租赁情况说明
            ,tdcurrency -- 币种
            ,remainuseyear -- 剩余使用年限
            ,monmanagementfee -- 
            ,yearlyrental -- 租赁年收入（元）
            ,iscompleted -- 房屋是否已竣工
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.sccode, o.sccode) as sccode -- 押品编号
    ,nvl(n.isnewhouse, o.isnewhouse) as isnewhouse -- 一手/二手标识
    ,nvl(n.istwotogether, o.istwotogether) as istwotogether -- 是否两证合一
    ,nvl(n.warrantsno, o.warrantsno) as warrantsno -- 房产证/不动产证号
    ,nvl(n.istotal, o.istotal) as istotal -- 该产证所属房产是否全部抵押
    ,nvl(n.otherremark, o.otherremark) as otherremark -- 部分抵押房产的部位描述
    ,nvl(n.contno, o.contno) as contno -- 房地产买卖合同编号
    ,nvl(n.tradedate, o.tradedate) as tradedate -- 购房日期
    ,nvl(n.tradeprice, o.tradeprice) as tradeprice -- 购房总价
    ,nvl(n.buildingarea, o.buildingarea) as buildingarea -- 建筑面积
    ,nvl(n.usearea, o.usearea) as usearea -- 实用面积
    ,nvl(n.createyear, o.createyear) as createyear -- 建成年份
    ,nvl(n.buildage, o.buildage) as buildage -- 楼龄(年)
    ,nvl(n.roomstructe, o.roomstructe) as roomstructe -- 房屋结构类型
    ,nvl(n.province, o.province) as province -- 所在/注册省份
    ,nvl(n.city, o.city) as city -- 所在/注册市
    ,nvl(n.counties, o.counties) as counties -- 所在县（区）
    ,nvl(n.street, o.street) as street -- 街道/村镇/路名
    ,nvl(n.roomno, o.roomno) as roomno -- 门牌号/弄号
    ,nvl(n.address, o.address) as address -- 房产证或不动产证地址/期房预售合同地址
    ,nvl(n.storeyno, o.storeyno) as storeyno -- 层次（标的所在楼层）
    ,nvl(n.totalstoreyno, o.totalstoreyno) as totalstoreyno -- 层数（标的所在总楼层）
    ,nvl(n.presentstatus, o.presentstatus) as presentstatus -- 目前状态
    ,nvl(n.buildrightinfo, o.buildrightinfo) as buildrightinfo -- 房屋产权期限信息
    ,nvl(n.landno, o.landno) as landno -- 土地证号
    ,nvl(n.landusenature, o.landusenature) as landusenature -- 土地使用权性质
    ,nvl(n.landgainway, o.landgainway) as landgainway -- 土地使用权取得方式
    ,nvl(n.landstartdate, o.landstartdate) as landstartdate -- 土地使用权起始日期
    ,nvl(n.landenddate, o.landenddate) as landenddate -- 土地使用权到期日期
    ,nvl(n.landuseryear, o.landuseryear) as landuseryear -- 土地使用年限
    ,nvl(n.landusering, o.landusering) as landusering -- 土地用途
    ,nvl(n.isotherright, o.isotherright) as isotherright -- 是否有他项权证
    ,nvl(n.remark, o.remark) as remark -- 其他说明
    ,nvl(n.isrents, o.isrents) as isrents -- 是否租赁
    ,nvl(n.hpaddr, o.hpaddr) as hpaddr -- 承租人
    ,nvl(n.hiresdate, o.hiresdate) as hiresdate -- 租赁起始日
    ,nvl(n.hireedate, o.hireedate) as hireedate -- 租赁到期日
    ,nvl(n.hireremark, o.hireremark) as hireremark -- 租赁情况说明
    ,nvl(n.tdcurrency, o.tdcurrency) as tdcurrency -- 币种
    ,nvl(n.remainuseyear, o.remainuseyear) as remainuseyear -- 剩余使用年限
    ,nvl(n.monmanagementfee, o.monmanagementfee) as monmanagementfee -- 
    ,nvl(n.yearlyrental, o.yearlyrental) as yearlyrental -- 租赁年收入（元）
    ,nvl(n.iscompleted, o.iscompleted) as iscompleted -- 房屋是否已竣工
    ,case when
            n.sccode is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.sccode is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.sccode is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.mims_si_businessroom_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.mims_si_businessroom where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.sccode = n.sccode
where (
        o.sccode is null
    )
    or (
        n.sccode is null
    )
    or (
        o.isnewhouse <> n.isnewhouse
        or o.istwotogether <> n.istwotogether
        or o.warrantsno <> n.warrantsno
        or o.istotal <> n.istotal
        or o.otherremark <> n.otherremark
        or o.contno <> n.contno
        or o.tradedate <> n.tradedate
        or o.tradeprice <> n.tradeprice
        or o.buildingarea <> n.buildingarea
        or o.usearea <> n.usearea
        or o.createyear <> n.createyear
        or o.buildage <> n.buildage
        or o.roomstructe <> n.roomstructe
        or o.province <> n.province
        or o.city <> n.city
        or o.counties <> n.counties
        or o.street <> n.street
        or o.roomno <> n.roomno
        or o.address <> n.address
        or o.storeyno <> n.storeyno
        or o.totalstoreyno <> n.totalstoreyno
        or o.presentstatus <> n.presentstatus
        or o.buildrightinfo <> n.buildrightinfo
        or o.landno <> n.landno
        or o.landusenature <> n.landusenature
        or o.landgainway <> n.landgainway
        or o.landstartdate <> n.landstartdate
        or o.landenddate <> n.landenddate
        or o.landuseryear <> n.landuseryear
        or o.landusering <> n.landusering
        or o.isotherright <> n.isotherright
        or o.remark <> n.remark
        or o.isrents <> n.isrents
        or o.hpaddr <> n.hpaddr
        or o.hiresdate <> n.hiresdate
        or o.hireedate <> n.hireedate
        or o.hireremark <> n.hireremark
        or o.tdcurrency <> n.tdcurrency
        or o.remainuseyear <> n.remainuseyear
        or o.monmanagementfee <> n.monmanagementfee
        or o.yearlyrental <> n.yearlyrental
        or o.iscompleted <> n.iscompleted
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.mims_si_businessroom_cl(
            sccode -- 押品编号
            ,isnewhouse -- 一手/二手标识
            ,istwotogether -- 是否两证合一
            ,warrantsno -- 房产证/不动产证号
            ,istotal -- 该产证所属房产是否全部抵押
            ,otherremark -- 部分抵押房产的部位描述
            ,contno -- 房地产买卖合同编号
            ,tradedate -- 购房日期
            ,tradeprice -- 购房总价
            ,buildingarea -- 建筑面积
            ,usearea -- 实用面积
            ,createyear -- 建成年份
            ,buildage -- 楼龄(年)
            ,roomstructe -- 房屋结构类型
            ,province -- 所在/注册省份
            ,city -- 所在/注册市
            ,counties -- 所在县（区）
            ,street -- 街道/村镇/路名
            ,roomno -- 门牌号/弄号
            ,address -- 房产证或不动产证地址/期房预售合同地址
            ,storeyno -- 层次（标的所在楼层）
            ,totalstoreyno -- 层数（标的所在总楼层）
            ,presentstatus -- 目前状态
            ,buildrightinfo -- 房屋产权期限信息
            ,landno -- 土地证号
            ,landusenature -- 土地使用权性质
            ,landgainway -- 土地使用权取得方式
            ,landstartdate -- 土地使用权起始日期
            ,landenddate -- 土地使用权到期日期
            ,landuseryear -- 土地使用年限
            ,landusering -- 土地用途
            ,isotherright -- 是否有他项权证
            ,remark -- 其他说明
            ,isrents -- 是否租赁
            ,hpaddr -- 承租人
            ,hiresdate -- 租赁起始日
            ,hireedate -- 租赁到期日
            ,hireremark -- 租赁情况说明
            ,tdcurrency -- 币种
            ,remainuseyear -- 剩余使用年限
            ,monmanagementfee -- 
            ,yearlyrental -- 租赁年收入（元）
            ,iscompleted -- 房屋是否已竣工
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.mims_si_businessroom_op(
            sccode -- 押品编号
            ,isnewhouse -- 一手/二手标识
            ,istwotogether -- 是否两证合一
            ,warrantsno -- 房产证/不动产证号
            ,istotal -- 该产证所属房产是否全部抵押
            ,otherremark -- 部分抵押房产的部位描述
            ,contno -- 房地产买卖合同编号
            ,tradedate -- 购房日期
            ,tradeprice -- 购房总价
            ,buildingarea -- 建筑面积
            ,usearea -- 实用面积
            ,createyear -- 建成年份
            ,buildage -- 楼龄(年)
            ,roomstructe -- 房屋结构类型
            ,province -- 所在/注册省份
            ,city -- 所在/注册市
            ,counties -- 所在县（区）
            ,street -- 街道/村镇/路名
            ,roomno -- 门牌号/弄号
            ,address -- 房产证或不动产证地址/期房预售合同地址
            ,storeyno -- 层次（标的所在楼层）
            ,totalstoreyno -- 层数（标的所在总楼层）
            ,presentstatus -- 目前状态
            ,buildrightinfo -- 房屋产权期限信息
            ,landno -- 土地证号
            ,landusenature -- 土地使用权性质
            ,landgainway -- 土地使用权取得方式
            ,landstartdate -- 土地使用权起始日期
            ,landenddate -- 土地使用权到期日期
            ,landuseryear -- 土地使用年限
            ,landusering -- 土地用途
            ,isotherright -- 是否有他项权证
            ,remark -- 其他说明
            ,isrents -- 是否租赁
            ,hpaddr -- 承租人
            ,hiresdate -- 租赁起始日
            ,hireedate -- 租赁到期日
            ,hireremark -- 租赁情况说明
            ,tdcurrency -- 币种
            ,remainuseyear -- 剩余使用年限
            ,monmanagementfee -- 
            ,yearlyrental -- 租赁年收入（元）
            ,iscompleted -- 房屋是否已竣工
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.sccode -- 押品编号
    ,o.isnewhouse -- 一手/二手标识
    ,o.istwotogether -- 是否两证合一
    ,o.warrantsno -- 房产证/不动产证号
    ,o.istotal -- 该产证所属房产是否全部抵押
    ,o.otherremark -- 部分抵押房产的部位描述
    ,o.contno -- 房地产买卖合同编号
    ,o.tradedate -- 购房日期
    ,o.tradeprice -- 购房总价
    ,o.buildingarea -- 建筑面积
    ,o.usearea -- 实用面积
    ,o.createyear -- 建成年份
    ,o.buildage -- 楼龄(年)
    ,o.roomstructe -- 房屋结构类型
    ,o.province -- 所在/注册省份
    ,o.city -- 所在/注册市
    ,o.counties -- 所在县（区）
    ,o.street -- 街道/村镇/路名
    ,o.roomno -- 门牌号/弄号
    ,o.address -- 房产证或不动产证地址/期房预售合同地址
    ,o.storeyno -- 层次（标的所在楼层）
    ,o.totalstoreyno -- 层数（标的所在总楼层）
    ,o.presentstatus -- 目前状态
    ,o.buildrightinfo -- 房屋产权期限信息
    ,o.landno -- 土地证号
    ,o.landusenature -- 土地使用权性质
    ,o.landgainway -- 土地使用权取得方式
    ,o.landstartdate -- 土地使用权起始日期
    ,o.landenddate -- 土地使用权到期日期
    ,o.landuseryear -- 土地使用年限
    ,o.landusering -- 土地用途
    ,o.isotherright -- 是否有他项权证
    ,o.remark -- 其他说明
    ,o.isrents -- 是否租赁
    ,o.hpaddr -- 承租人
    ,o.hiresdate -- 租赁起始日
    ,o.hireedate -- 租赁到期日
    ,o.hireremark -- 租赁情况说明
    ,o.tdcurrency -- 币种
    ,o.remainuseyear -- 剩余使用年限
    ,o.monmanagementfee -- 
    ,o.yearlyrental -- 租赁年收入（元）
    ,o.iscompleted -- 房屋是否已竣工
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
from ${iol_schema}.mims_si_businessroom_bk o
    left join ${iol_schema}.mims_si_businessroom_op n
        on
            o.sccode = n.sccode
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.mims_si_businessroom_cl d
        on
            o.sccode = d.sccode
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
--truncate table ${iol_schema}.mims_si_businessroom;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('mims_si_businessroom') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.mims_si_businessroom drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.mims_si_businessroom add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.mims_si_businessroom exchange partition p_${batch_date} with table ${iol_schema}.mims_si_businessroom_cl;
alter table ${iol_schema}.mims_si_businessroom exchange partition p_20991231 with table ${iol_schema}.mims_si_businessroom_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.mims_si_businessroom to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.mims_si_businessroom_op purge;
drop table ${iol_schema}.mims_si_businessroom_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.mims_si_businessroom_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'mims_si_businessroom',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
