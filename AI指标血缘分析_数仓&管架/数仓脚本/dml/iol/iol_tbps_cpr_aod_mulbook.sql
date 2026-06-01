/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_tbps_cpr_aod_mulbook
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
create table ${iol_schema}.tbps_cpr_aod_mulbook_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.tbps_cpr_aod_mulbook;

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.tbps_cpr_aod_mulbook_op purge;
drop table ${iol_schema}.tbps_cpr_aod_mulbook_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.tbps_cpr_aod_mulbook_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.tbps_cpr_aod_mulbook where 0=1;

create table ${iol_schema}.tbps_cpr_aod_mulbook_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.tbps_cpr_aod_mulbook where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.tbps_cpr_aod_mulbook_cl(
            cam_cstno -- 客户号
            ,cam_firstbookno -- 一级账簿编号
            ,cam_secondbookno -- 二级账簿编号
            ,cam_thirdbookno -- 三级账簿编号
            ,cam_bookno -- 账簿编号
            ,cam_bookname -- 账簿名称
            ,cam_bookgrade -- 账簿级别
            ,cam_ifbandacc -- 是否绑定单位结算账户：1绑定，2不绑定
            ,cam_accno -- 单位结算账号
            ,cam_motherbookno -- 上级账簿编号
            ,cam_createbooktime -- 创建账簿时间
            ,cam_bookstate -- 账簿状态：1正常，2作废
            ,cam_amount -- 账簿余额
            ,cam_motheracc -- 签约母账户
            ,cam_accnostatu -- 结算卡状态:0正常；1关闭；2未加挂卡
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.tbps_cpr_aod_mulbook_op(
            cam_cstno -- 客户号
            ,cam_firstbookno -- 一级账簿编号
            ,cam_secondbookno -- 二级账簿编号
            ,cam_thirdbookno -- 三级账簿编号
            ,cam_bookno -- 账簿编号
            ,cam_bookname -- 账簿名称
            ,cam_bookgrade -- 账簿级别
            ,cam_ifbandacc -- 是否绑定单位结算账户：1绑定，2不绑定
            ,cam_accno -- 单位结算账号
            ,cam_motherbookno -- 上级账簿编号
            ,cam_createbooktime -- 创建账簿时间
            ,cam_bookstate -- 账簿状态：1正常，2作废
            ,cam_amount -- 账簿余额
            ,cam_motheracc -- 签约母账户
            ,cam_accnostatu -- 结算卡状态:0正常；1关闭；2未加挂卡
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.cam_cstno, o.cam_cstno) as cam_cstno -- 客户号
    ,nvl(n.cam_firstbookno, o.cam_firstbookno) as cam_firstbookno -- 一级账簿编号
    ,nvl(n.cam_secondbookno, o.cam_secondbookno) as cam_secondbookno -- 二级账簿编号
    ,nvl(n.cam_thirdbookno, o.cam_thirdbookno) as cam_thirdbookno -- 三级账簿编号
    ,nvl(n.cam_bookno, o.cam_bookno) as cam_bookno -- 账簿编号
    ,nvl(n.cam_bookname, o.cam_bookname) as cam_bookname -- 账簿名称
    ,nvl(n.cam_bookgrade, o.cam_bookgrade) as cam_bookgrade -- 账簿级别
    ,nvl(n.cam_ifbandacc, o.cam_ifbandacc) as cam_ifbandacc -- 是否绑定单位结算账户：1绑定，2不绑定
    ,nvl(n.cam_accno, o.cam_accno) as cam_accno -- 单位结算账号
    ,nvl(n.cam_motherbookno, o.cam_motherbookno) as cam_motherbookno -- 上级账簿编号
    ,nvl(n.cam_createbooktime, o.cam_createbooktime) as cam_createbooktime -- 创建账簿时间
    ,nvl(n.cam_bookstate, o.cam_bookstate) as cam_bookstate -- 账簿状态：1正常，2作废
    ,nvl(n.cam_amount, o.cam_amount) as cam_amount -- 账簿余额
    ,nvl(n.cam_motheracc, o.cam_motheracc) as cam_motheracc -- 签约母账户
    ,nvl(n.cam_accnostatu, o.cam_accnostatu) as cam_accnostatu -- 结算卡状态:0正常；1关闭；2未加挂卡
    ,case when
            n.cam_cstno is null
            and n.cam_bookno is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.cam_cstno is null
            and n.cam_bookno is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.cam_cstno is null
            and n.cam_bookno is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.tbps_cpr_aod_mulbook_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.tbps_cpr_aod_mulbook where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.cam_cstno = n.cam_cstno
            and o.cam_bookno = n.cam_bookno
where (
        o.cam_cstno is null
        and o.cam_bookno is null
    )
    or (
        n.cam_cstno is null
        and n.cam_bookno is null
    )
    or (
        o.cam_firstbookno <> n.cam_firstbookno
        or o.cam_secondbookno <> n.cam_secondbookno
        or o.cam_thirdbookno <> n.cam_thirdbookno
        or o.cam_bookname <> n.cam_bookname
        or o.cam_bookgrade <> n.cam_bookgrade
        or o.cam_ifbandacc <> n.cam_ifbandacc
        or o.cam_accno <> n.cam_accno
        or o.cam_motherbookno <> n.cam_motherbookno
        or o.cam_createbooktime <> n.cam_createbooktime
        or o.cam_bookstate <> n.cam_bookstate
        or o.cam_amount <> n.cam_amount
        or o.cam_motheracc <> n.cam_motheracc
        or o.cam_accnostatu <> n.cam_accnostatu
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.tbps_cpr_aod_mulbook_cl(
            cam_cstno -- 客户号
            ,cam_firstbookno -- 一级账簿编号
            ,cam_secondbookno -- 二级账簿编号
            ,cam_thirdbookno -- 三级账簿编号
            ,cam_bookno -- 账簿编号
            ,cam_bookname -- 账簿名称
            ,cam_bookgrade -- 账簿级别
            ,cam_ifbandacc -- 是否绑定单位结算账户：1绑定，2不绑定
            ,cam_accno -- 单位结算账号
            ,cam_motherbookno -- 上级账簿编号
            ,cam_createbooktime -- 创建账簿时间
            ,cam_bookstate -- 账簿状态：1正常，2作废
            ,cam_amount -- 账簿余额
            ,cam_motheracc -- 签约母账户
            ,cam_accnostatu -- 结算卡状态:0正常；1关闭；2未加挂卡
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.tbps_cpr_aod_mulbook_op(
            cam_cstno -- 客户号
            ,cam_firstbookno -- 一级账簿编号
            ,cam_secondbookno -- 二级账簿编号
            ,cam_thirdbookno -- 三级账簿编号
            ,cam_bookno -- 账簿编号
            ,cam_bookname -- 账簿名称
            ,cam_bookgrade -- 账簿级别
            ,cam_ifbandacc -- 是否绑定单位结算账户：1绑定，2不绑定
            ,cam_accno -- 单位结算账号
            ,cam_motherbookno -- 上级账簿编号
            ,cam_createbooktime -- 创建账簿时间
            ,cam_bookstate -- 账簿状态：1正常，2作废
            ,cam_amount -- 账簿余额
            ,cam_motheracc -- 签约母账户
            ,cam_accnostatu -- 结算卡状态:0正常；1关闭；2未加挂卡
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.cam_cstno -- 客户号
    ,o.cam_firstbookno -- 一级账簿编号
    ,o.cam_secondbookno -- 二级账簿编号
    ,o.cam_thirdbookno -- 三级账簿编号
    ,o.cam_bookno -- 账簿编号
    ,o.cam_bookname -- 账簿名称
    ,o.cam_bookgrade -- 账簿级别
    ,o.cam_ifbandacc -- 是否绑定单位结算账户：1绑定，2不绑定
    ,o.cam_accno -- 单位结算账号
    ,o.cam_motherbookno -- 上级账簿编号
    ,o.cam_createbooktime -- 创建账簿时间
    ,o.cam_bookstate -- 账簿状态：1正常，2作废
    ,o.cam_amount -- 账簿余额
    ,o.cam_motheracc -- 签约母账户
    ,o.cam_accnostatu -- 结算卡状态:0正常；1关闭；2未加挂卡
    ,o.start_dt -- 开始时间
    ,case when n.start_dt is not null then to_date('${batch_date}', 'yyyymmdd')
          when o.end_dt >= to_date('${batch_date}','yyyymmdd') then to_date('20991231','yyyymmdd')
          else o.end_dt
     end as end_dt -- 结束时间
    ,o.id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from ${iol_schema}.tbps_cpr_aod_mulbook_bk o
    left join ${iol_schema}.tbps_cpr_aod_mulbook_op n
        on
            o.cam_cstno = n.cam_cstno
            and o.cam_bookno = n.cam_bookno
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.tbps_cpr_aod_mulbook_cl d
        on
            o.cam_cstno = d.cam_cstno
            and o.cam_bookno = d.cam_bookno
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
-- truncate table ${iol_schema}.tbps_cpr_aod_mulbook;

-- 4.2 exchange partition
alter table ${iol_schema}.tbps_cpr_aod_mulbook exchange partition p_19000101 with table ${iol_schema}.tbps_cpr_aod_mulbook_cl;
alter table ${iol_schema}.tbps_cpr_aod_mulbook exchange partition p_20991231 with table ${iol_schema}.tbps_cpr_aod_mulbook_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.tbps_cpr_aod_mulbook to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.tbps_cpr_aod_mulbook_op purge;
drop table ${iol_schema}.tbps_cpr_aod_mulbook_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.tbps_cpr_aod_mulbook_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'tbps_cpr_aod_mulbook',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
