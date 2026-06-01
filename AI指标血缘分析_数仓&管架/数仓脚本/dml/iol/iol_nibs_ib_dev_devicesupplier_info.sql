/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_nibs_ib_dev_devicesupplier_info
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
create table ${iol_schema}.nibs_ib_dev_devicesupplier_info_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.nibs_ib_dev_devicesupplier_info
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.nibs_ib_dev_devicesupplier_info_op purge;
drop table ${iol_schema}.nibs_ib_dev_devicesupplier_info_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.nibs_ib_dev_devicesupplier_info_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.nibs_ib_dev_devicesupplier_info where 0=1;

create table ${iol_schema}.nibs_ib_dev_devicesupplier_info_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.nibs_ib_dev_devicesupplier_info where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.nibs_ib_dev_devicesupplier_info_cl(
            serviceprovnum -- 服务商编号
            ,serviceprovname -- 服务商名称
            ,cont -- 联系人
            ,contactnum -- 联系电话
            ,cellnum -- 手机号
            ,contactaddr -- 联系地址
            ,creator -- 创建人
            ,creatorbrno -- 创建人所属机构
            ,startdate -- 创建日期
            ,starttime -- 创建时间
            ,modifyuser -- 最后修改人
            ,modifyuserbrno -- 最后修改人所属机构
            ,modifdate -- 最后修改日期
            ,modiftime -- 最后修改时间
            ,defectsliabilityperiod -- 保修期(月)
            ,web -- 公司主页
            ,mailbox -- 邮箱
            ,wechat -- 微信
            ,note1 -- 备注1
            ,note2 -- 备注2
            ,note3 -- 备注3
            ,note4 -- 备注4
            ,note5 -- 备注5
            ,simpvendorname -- 厂商名称简称
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.nibs_ib_dev_devicesupplier_info_op(
            serviceprovnum -- 服务商编号
            ,serviceprovname -- 服务商名称
            ,cont -- 联系人
            ,contactnum -- 联系电话
            ,cellnum -- 手机号
            ,contactaddr -- 联系地址
            ,creator -- 创建人
            ,creatorbrno -- 创建人所属机构
            ,startdate -- 创建日期
            ,starttime -- 创建时间
            ,modifyuser -- 最后修改人
            ,modifyuserbrno -- 最后修改人所属机构
            ,modifdate -- 最后修改日期
            ,modiftime -- 最后修改时间
            ,defectsliabilityperiod -- 保修期(月)
            ,web -- 公司主页
            ,mailbox -- 邮箱
            ,wechat -- 微信
            ,note1 -- 备注1
            ,note2 -- 备注2
            ,note3 -- 备注3
            ,note4 -- 备注4
            ,note5 -- 备注5
            ,simpvendorname -- 厂商名称简称
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.serviceprovnum, o.serviceprovnum) as serviceprovnum -- 服务商编号
    ,nvl(n.serviceprovname, o.serviceprovname) as serviceprovname -- 服务商名称
    ,nvl(n.cont, o.cont) as cont -- 联系人
    ,nvl(n.contactnum, o.contactnum) as contactnum -- 联系电话
    ,nvl(n.cellnum, o.cellnum) as cellnum -- 手机号
    ,nvl(n.contactaddr, o.contactaddr) as contactaddr -- 联系地址
    ,nvl(n.creator, o.creator) as creator -- 创建人
    ,nvl(n.creatorbrno, o.creatorbrno) as creatorbrno -- 创建人所属机构
    ,nvl(n.startdate, o.startdate) as startdate -- 创建日期
    ,nvl(n.starttime, o.starttime) as starttime -- 创建时间
    ,nvl(n.modifyuser, o.modifyuser) as modifyuser -- 最后修改人
    ,nvl(n.modifyuserbrno, o.modifyuserbrno) as modifyuserbrno -- 最后修改人所属机构
    ,nvl(n.modifdate, o.modifdate) as modifdate -- 最后修改日期
    ,nvl(n.modiftime, o.modiftime) as modiftime -- 最后修改时间
    ,nvl(n.defectsliabilityperiod, o.defectsliabilityperiod) as defectsliabilityperiod -- 保修期(月)
    ,nvl(n.web, o.web) as web -- 公司主页
    ,nvl(n.mailbox, o.mailbox) as mailbox -- 邮箱
    ,nvl(n.wechat, o.wechat) as wechat -- 微信
    ,nvl(n.note1, o.note1) as note1 -- 备注1
    ,nvl(n.note2, o.note2) as note2 -- 备注2
    ,nvl(n.note3, o.note3) as note3 -- 备注3
    ,nvl(n.note4, o.note4) as note4 -- 备注4
    ,nvl(n.note5, o.note5) as note5 -- 备注5
    ,nvl(n.simpvendorname, o.simpvendorname) as simpvendorname -- 厂商名称简称
    ,case when
            n.serviceprovnum is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.serviceprovnum is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.serviceprovnum is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.nibs_ib_dev_devicesupplier_info_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.nibs_ib_dev_devicesupplier_info where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.serviceprovnum = n.serviceprovnum
where (
        o.serviceprovnum is null
    )
    or (
        n.serviceprovnum is null
    )
    or (
        o.serviceprovname <> n.serviceprovname
        or o.cont <> n.cont
        or o.contactnum <> n.contactnum
        or o.cellnum <> n.cellnum
        or o.contactaddr <> n.contactaddr
        or o.creator <> n.creator
        or o.creatorbrno <> n.creatorbrno
        or o.startdate <> n.startdate
        or o.starttime <> n.starttime
        or o.modifyuser <> n.modifyuser
        or o.modifyuserbrno <> n.modifyuserbrno
        or o.modifdate <> n.modifdate
        or o.modiftime <> n.modiftime
        or o.defectsliabilityperiod <> n.defectsliabilityperiod
        or o.web <> n.web
        or o.mailbox <> n.mailbox
        or o.wechat <> n.wechat
        or o.note1 <> n.note1
        or o.note2 <> n.note2
        or o.note3 <> n.note3
        or o.note4 <> n.note4
        or o.note5 <> n.note5
        or o.simpvendorname <> n.simpvendorname
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.nibs_ib_dev_devicesupplier_info_cl(
            serviceprovnum -- 服务商编号
            ,serviceprovname -- 服务商名称
            ,cont -- 联系人
            ,contactnum -- 联系电话
            ,cellnum -- 手机号
            ,contactaddr -- 联系地址
            ,creator -- 创建人
            ,creatorbrno -- 创建人所属机构
            ,startdate -- 创建日期
            ,starttime -- 创建时间
            ,modifyuser -- 最后修改人
            ,modifyuserbrno -- 最后修改人所属机构
            ,modifdate -- 最后修改日期
            ,modiftime -- 最后修改时间
            ,defectsliabilityperiod -- 保修期(月)
            ,web -- 公司主页
            ,mailbox -- 邮箱
            ,wechat -- 微信
            ,note1 -- 备注1
            ,note2 -- 备注2
            ,note3 -- 备注3
            ,note4 -- 备注4
            ,note5 -- 备注5
            ,simpvendorname -- 厂商名称简称
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.nibs_ib_dev_devicesupplier_info_op(
            serviceprovnum -- 服务商编号
            ,serviceprovname -- 服务商名称
            ,cont -- 联系人
            ,contactnum -- 联系电话
            ,cellnum -- 手机号
            ,contactaddr -- 联系地址
            ,creator -- 创建人
            ,creatorbrno -- 创建人所属机构
            ,startdate -- 创建日期
            ,starttime -- 创建时间
            ,modifyuser -- 最后修改人
            ,modifyuserbrno -- 最后修改人所属机构
            ,modifdate -- 最后修改日期
            ,modiftime -- 最后修改时间
            ,defectsliabilityperiod -- 保修期(月)
            ,web -- 公司主页
            ,mailbox -- 邮箱
            ,wechat -- 微信
            ,note1 -- 备注1
            ,note2 -- 备注2
            ,note3 -- 备注3
            ,note4 -- 备注4
            ,note5 -- 备注5
            ,simpvendorname -- 厂商名称简称
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.serviceprovnum -- 服务商编号
    ,o.serviceprovname -- 服务商名称
    ,o.cont -- 联系人
    ,o.contactnum -- 联系电话
    ,o.cellnum -- 手机号
    ,o.contactaddr -- 联系地址
    ,o.creator -- 创建人
    ,o.creatorbrno -- 创建人所属机构
    ,o.startdate -- 创建日期
    ,o.starttime -- 创建时间
    ,o.modifyuser -- 最后修改人
    ,o.modifyuserbrno -- 最后修改人所属机构
    ,o.modifdate -- 最后修改日期
    ,o.modiftime -- 最后修改时间
    ,o.defectsliabilityperiod -- 保修期(月)
    ,o.web -- 公司主页
    ,o.mailbox -- 邮箱
    ,o.wechat -- 微信
    ,o.note1 -- 备注1
    ,o.note2 -- 备注2
    ,o.note3 -- 备注3
    ,o.note4 -- 备注4
    ,o.note5 -- 备注5
    ,o.simpvendorname -- 厂商名称简称
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
from ${iol_schema}.nibs_ib_dev_devicesupplier_info_bk o
    left join ${iol_schema}.nibs_ib_dev_devicesupplier_info_op n
        on
            o.serviceprovnum = n.serviceprovnum
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.nibs_ib_dev_devicesupplier_info_cl d
        on
            o.serviceprovnum = d.serviceprovnum
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
--truncate table ${iol_schema}.nibs_ib_dev_devicesupplier_info;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('nibs_ib_dev_devicesupplier_info') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.nibs_ib_dev_devicesupplier_info drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.nibs_ib_dev_devicesupplier_info add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.nibs_ib_dev_devicesupplier_info exchange partition p_${batch_date} with table ${iol_schema}.nibs_ib_dev_devicesupplier_info_cl;
alter table ${iol_schema}.nibs_ib_dev_devicesupplier_info exchange partition p_20991231 with table ${iol_schema}.nibs_ib_dev_devicesupplier_info_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.nibs_ib_dev_devicesupplier_info to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.nibs_ib_dev_devicesupplier_info_op purge;
drop table ${iol_schema}.nibs_ib_dev_devicesupplier_info_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.nibs_ib_dev_devicesupplier_info_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'nibs_ib_dev_devicesupplier_info',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
