/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_mpcs_a49tefbrnnbr
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
create table ${iol_schema}.mpcs_a49tefbrnnbr_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.mpcs_a49tefbrnnbr;

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.mpcs_a49tefbrnnbr_op purge;
drop table ${iol_schema}.mpcs_a49tefbrnnbr_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.mpcs_a49tefbrnnbr_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.mpcs_a49tefbrnnbr where 0=1;

create table ${iol_schema}.mpcs_a49tefbrnnbr_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.mpcs_a49tefbrnnbr where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.mpcs_a49tefbrnnbr_cl(
            brnnbr -- 行号
            ,swiftnbr -- swift行号
            ,sysid -- 系统号
            ,zoneid -- 地区代码
            ,area -- 所在区域
            ,acpbrn -- 集中受理行行号
            ,upbrn -- 直接清算行行号
            ,clscode -- 行别代码
            ,bankname -- 银行名称
            ,shortname -- 银行简称
            ,chkbrnnbr -- 二级核算行行号
            ,bankaddr -- 银行地址
            ,postcode -- 邮编
            ,phone -- 联系电话
            ,fax -- 传真
            ,emailaddr -- email地址
            ,linkman -- 联系人
            ,directflag -- 直接清算行标志
            ,conceflag -- 集中处理行标志
            ,paybnkflg -- 支付行号/非支付行号标志
            ,effdate -- 生效日期
            ,invdate -- 停用日期
            ,note -- 备注
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.mpcs_a49tefbrnnbr_op(
            brnnbr -- 行号
            ,swiftnbr -- swift行号
            ,sysid -- 系统号
            ,zoneid -- 地区代码
            ,area -- 所在区域
            ,acpbrn -- 集中受理行行号
            ,upbrn -- 直接清算行行号
            ,clscode -- 行别代码
            ,bankname -- 银行名称
            ,shortname -- 银行简称
            ,chkbrnnbr -- 二级核算行行号
            ,bankaddr -- 银行地址
            ,postcode -- 邮编
            ,phone -- 联系电话
            ,fax -- 传真
            ,emailaddr -- email地址
            ,linkman -- 联系人
            ,directflag -- 直接清算行标志
            ,conceflag -- 集中处理行标志
            ,paybnkflg -- 支付行号/非支付行号标志
            ,effdate -- 生效日期
            ,invdate -- 停用日期
            ,note -- 备注
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.brnnbr, o.brnnbr) as brnnbr -- 行号
    ,nvl(n.swiftnbr, o.swiftnbr) as swiftnbr -- swift行号
    ,nvl(n.sysid, o.sysid) as sysid -- 系统号
    ,nvl(n.zoneid, o.zoneid) as zoneid -- 地区代码
    ,nvl(n.area, o.area) as area -- 所在区域
    ,nvl(n.acpbrn, o.acpbrn) as acpbrn -- 集中受理行行号
    ,nvl(n.upbrn, o.upbrn) as upbrn -- 直接清算行行号
    ,nvl(n.clscode, o.clscode) as clscode -- 行别代码
    ,nvl(n.bankname, o.bankname) as bankname -- 银行名称
    ,nvl(n.shortname, o.shortname) as shortname -- 银行简称
    ,nvl(n.chkbrnnbr, o.chkbrnnbr) as chkbrnnbr -- 二级核算行行号
    ,nvl(n.bankaddr, o.bankaddr) as bankaddr -- 银行地址
    ,nvl(n.postcode, o.postcode) as postcode -- 邮编
    ,nvl(n.phone, o.phone) as phone -- 联系电话
    ,nvl(n.fax, o.fax) as fax -- 传真
    ,nvl(n.emailaddr, o.emailaddr) as emailaddr -- email地址
    ,nvl(n.linkman, o.linkman) as linkman -- 联系人
    ,nvl(n.directflag, o.directflag) as directflag -- 直接清算行标志
    ,nvl(n.conceflag, o.conceflag) as conceflag -- 集中处理行标志
    ,nvl(n.paybnkflg, o.paybnkflg) as paybnkflg -- 支付行号/非支付行号标志
    ,nvl(n.effdate, o.effdate) as effdate -- 生效日期
    ,nvl(n.invdate, o.invdate) as invdate -- 停用日期
    ,nvl(n.note, o.note) as note -- 备注
    ,case when
            n.brnnbr is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.brnnbr is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.brnnbr is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.mpcs_a49tefbrnnbr_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.mpcs_a49tefbrnnbr where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.brnnbr = n.brnnbr
where (
        o.brnnbr is null
    )
    or (
        n.brnnbr is null
    )
    or (
        o.swiftnbr <> n.swiftnbr
        or o.sysid <> n.sysid
        or o.zoneid <> n.zoneid
        or o.area <> n.area
        or o.acpbrn <> n.acpbrn
        or o.upbrn <> n.upbrn
        or o.clscode <> n.clscode
        or o.bankname <> n.bankname
        or o.shortname <> n.shortname
        or o.chkbrnnbr <> n.chkbrnnbr
        or o.bankaddr <> n.bankaddr
        or o.postcode <> n.postcode
        or o.phone <> n.phone
        or o.fax <> n.fax
        or o.emailaddr <> n.emailaddr
        or o.linkman <> n.linkman
        or o.directflag <> n.directflag
        or o.conceflag <> n.conceflag
        or o.paybnkflg <> n.paybnkflg
        or o.effdate <> n.effdate
        or o.invdate <> n.invdate
        or o.note <> n.note
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.mpcs_a49tefbrnnbr_cl(
            brnnbr -- 行号
            ,swiftnbr -- swift行号
            ,sysid -- 系统号
            ,zoneid -- 地区代码
            ,area -- 所在区域
            ,acpbrn -- 集中受理行行号
            ,upbrn -- 直接清算行行号
            ,clscode -- 行别代码
            ,bankname -- 银行名称
            ,shortname -- 银行简称
            ,chkbrnnbr -- 二级核算行行号
            ,bankaddr -- 银行地址
            ,postcode -- 邮编
            ,phone -- 联系电话
            ,fax -- 传真
            ,emailaddr -- email地址
            ,linkman -- 联系人
            ,directflag -- 直接清算行标志
            ,conceflag -- 集中处理行标志
            ,paybnkflg -- 支付行号/非支付行号标志
            ,effdate -- 生效日期
            ,invdate -- 停用日期
            ,note -- 备注
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.mpcs_a49tefbrnnbr_op(
            brnnbr -- 行号
            ,swiftnbr -- swift行号
            ,sysid -- 系统号
            ,zoneid -- 地区代码
            ,area -- 所在区域
            ,acpbrn -- 集中受理行行号
            ,upbrn -- 直接清算行行号
            ,clscode -- 行别代码
            ,bankname -- 银行名称
            ,shortname -- 银行简称
            ,chkbrnnbr -- 二级核算行行号
            ,bankaddr -- 银行地址
            ,postcode -- 邮编
            ,phone -- 联系电话
            ,fax -- 传真
            ,emailaddr -- email地址
            ,linkman -- 联系人
            ,directflag -- 直接清算行标志
            ,conceflag -- 集中处理行标志
            ,paybnkflg -- 支付行号/非支付行号标志
            ,effdate -- 生效日期
            ,invdate -- 停用日期
            ,note -- 备注
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.brnnbr -- 行号
    ,o.swiftnbr -- swift行号
    ,o.sysid -- 系统号
    ,o.zoneid -- 地区代码
    ,o.area -- 所在区域
    ,o.acpbrn -- 集中受理行行号
    ,o.upbrn -- 直接清算行行号
    ,o.clscode -- 行别代码
    ,o.bankname -- 银行名称
    ,o.shortname -- 银行简称
    ,o.chkbrnnbr -- 二级核算行行号
    ,o.bankaddr -- 银行地址
    ,o.postcode -- 邮编
    ,o.phone -- 联系电话
    ,o.fax -- 传真
    ,o.emailaddr -- email地址
    ,o.linkman -- 联系人
    ,o.directflag -- 直接清算行标志
    ,o.conceflag -- 集中处理行标志
    ,o.paybnkflg -- 支付行号/非支付行号标志
    ,o.effdate -- 生效日期
    ,o.invdate -- 停用日期
    ,o.note -- 备注
    ,o.start_dt -- 开始时间
    ,case when n.start_dt is not null then to_date('${batch_date}', 'yyyymmdd')
          when o.end_dt >= to_date('${batch_date}','yyyymmdd') then to_date('20991231','yyyymmdd')
          else o.end_dt
     end as end_dt -- 结束时间
    ,o.id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from ${iol_schema}.mpcs_a49tefbrnnbr_bk o
    left join ${iol_schema}.mpcs_a49tefbrnnbr_op n
        on
            o.brnnbr = n.brnnbr
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.mpcs_a49tefbrnnbr_cl d
        on
            o.brnnbr = d.brnnbr
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
-- truncate table ${iol_schema}.mpcs_a49tefbrnnbr;

-- 4.2 exchange partition
alter table ${iol_schema}.mpcs_a49tefbrnnbr exchange partition p_19000101 with table ${iol_schema}.mpcs_a49tefbrnnbr_cl;
alter table ${iol_schema}.mpcs_a49tefbrnnbr exchange partition p_20991231 with table ${iol_schema}.mpcs_a49tefbrnnbr_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.mpcs_a49tefbrnnbr to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.mpcs_a49tefbrnnbr_op purge;
drop table ${iol_schema}.mpcs_a49tefbrnnbr_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.mpcs_a49tefbrnnbr_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'mpcs_a49tefbrnnbr',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
