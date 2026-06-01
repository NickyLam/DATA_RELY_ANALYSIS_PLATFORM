/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_amls_t00_organ
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
create table ${iol_schema}.amls_t00_organ_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.amls_t00_organ
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.amls_t00_organ_op purge;
drop table ${iol_schema}.amls_t00_organ_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.amls_t00_organ_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.amls_t00_organ where 0=1;

create table ${iol_schema}.amls_t00_organ_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.amls_t00_organ where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.amls_t00_organ_cl(
            organkey -- 机构代码内部使用
            ,organno -- 机构号
            ,organname -- 机构名称
            ,organsf -- 机构简称
            ,organlevel -- 机构级别 0通用级，1总行级，2分行级，3支行级
            ,uporgankey -- 上级机构为：1＝总行
            ,organaddress -- 详细地址
            ,postalcode -- 邮政编码
            ,telephone -- 电话号码
            ,organmanager -- 机构负责人
            ,organpamount -- 机构人数
            ,linkman -- 联系人姓名
            ,builddate -- 成立时间
            ,organdes -- 提示标志 0正常，1新增标识，2未填写行政区划代码标识
            ,validatedate -- 生效时间
            ,invalidatedate -- 失效时间
            ,createdate -- 创建时间
            ,creator -- 创建人
            ,modifydate -- 修改时间
            ,modifier -- 修改人员
            ,flag -- 标志位
            ,unionorgkey -- 现代支付系统行号
            ,org_area -- 行政区划代码
            ,settleorgkey -- 人民币结算账户管理系统行号
            ,uporgankey_sor -- 
            ,organcode -- 机构编码
            ,is_cross -- 跨境标识（境内10;境外11）
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.amls_t00_organ_op(
            organkey -- 机构代码内部使用
            ,organno -- 机构号
            ,organname -- 机构名称
            ,organsf -- 机构简称
            ,organlevel -- 机构级别 0通用级，1总行级，2分行级，3支行级
            ,uporgankey -- 上级机构为：1＝总行
            ,organaddress -- 详细地址
            ,postalcode -- 邮政编码
            ,telephone -- 电话号码
            ,organmanager -- 机构负责人
            ,organpamount -- 机构人数
            ,linkman -- 联系人姓名
            ,builddate -- 成立时间
            ,organdes -- 提示标志 0正常，1新增标识，2未填写行政区划代码标识
            ,validatedate -- 生效时间
            ,invalidatedate -- 失效时间
            ,createdate -- 创建时间
            ,creator -- 创建人
            ,modifydate -- 修改时间
            ,modifier -- 修改人员
            ,flag -- 标志位
            ,unionorgkey -- 现代支付系统行号
            ,org_area -- 行政区划代码
            ,settleorgkey -- 人民币结算账户管理系统行号
            ,uporgankey_sor -- 
            ,organcode -- 机构编码
            ,is_cross -- 跨境标识（境内10;境外11）
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.organkey, o.organkey) as organkey -- 机构代码内部使用
    ,nvl(n.organno, o.organno) as organno -- 机构号
    ,nvl(n.organname, o.organname) as organname -- 机构名称
    ,nvl(n.organsf, o.organsf) as organsf -- 机构简称
    ,nvl(n.organlevel, o.organlevel) as organlevel -- 机构级别 0通用级，1总行级，2分行级，3支行级
    ,nvl(n.uporgankey, o.uporgankey) as uporgankey -- 上级机构为：1＝总行
    ,nvl(n.organaddress, o.organaddress) as organaddress -- 详细地址
    ,nvl(n.postalcode, o.postalcode) as postalcode -- 邮政编码
    ,nvl(n.telephone, o.telephone) as telephone -- 电话号码
    ,nvl(n.organmanager, o.organmanager) as organmanager -- 机构负责人
    ,nvl(n.organpamount, o.organpamount) as organpamount -- 机构人数
    ,nvl(n.linkman, o.linkman) as linkman -- 联系人姓名
    ,nvl(n.builddate, o.builddate) as builddate -- 成立时间
    ,nvl(n.organdes, o.organdes) as organdes -- 提示标志 0正常，1新增标识，2未填写行政区划代码标识
    ,nvl(n.validatedate, o.validatedate) as validatedate -- 生效时间
    ,nvl(n.invalidatedate, o.invalidatedate) as invalidatedate -- 失效时间
    ,nvl(n.createdate, o.createdate) as createdate -- 创建时间
    ,nvl(n.creator, o.creator) as creator -- 创建人
    ,nvl(n.modifydate, o.modifydate) as modifydate -- 修改时间
    ,nvl(n.modifier, o.modifier) as modifier -- 修改人员
    ,nvl(n.flag, o.flag) as flag -- 标志位
    ,nvl(n.unionorgkey, o.unionorgkey) as unionorgkey -- 现代支付系统行号
    ,nvl(n.org_area, o.org_area) as org_area -- 行政区划代码
    ,nvl(n.settleorgkey, o.settleorgkey) as settleorgkey -- 人民币结算账户管理系统行号
    ,nvl(n.uporgankey_sor, o.uporgankey_sor) as uporgankey_sor -- 
    ,nvl(n.organcode, o.organcode) as organcode -- 机构编码
    ,nvl(n.is_cross, o.is_cross) as is_cross -- 跨境标识（境内10;境外11）
    ,case when
            n.organkey is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.organkey is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.organkey is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.amls_t00_organ_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.amls_t00_organ where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.organkey = n.organkey
where (
        o.organkey is null
    )
    or (
        n.organkey is null
    )
    or (
        o.organno <> n.organno
        or o.organname <> n.organname
        or o.organsf <> n.organsf
        or o.organlevel <> n.organlevel
        or o.uporgankey <> n.uporgankey
        or o.organaddress <> n.organaddress
        or o.postalcode <> n.postalcode
        or o.telephone <> n.telephone
        or o.organmanager <> n.organmanager
        or o.organpamount <> n.organpamount
        or o.linkman <> n.linkman
        or o.builddate <> n.builddate
        or o.organdes <> n.organdes
        or o.validatedate <> n.validatedate
        or o.invalidatedate <> n.invalidatedate
        or o.createdate <> n.createdate
        or o.creator <> n.creator
        or o.modifydate <> n.modifydate
        or o.modifier <> n.modifier
        or o.flag <> n.flag
        or o.unionorgkey <> n.unionorgkey
        or o.org_area <> n.org_area
        or o.settleorgkey <> n.settleorgkey
        or o.uporgankey_sor <> n.uporgankey_sor
        or o.organcode <> n.organcode
        or o.is_cross <> n.is_cross
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.amls_t00_organ_cl(
            organkey -- 机构代码内部使用
            ,organno -- 机构号
            ,organname -- 机构名称
            ,organsf -- 机构简称
            ,organlevel -- 机构级别 0通用级，1总行级，2分行级，3支行级
            ,uporgankey -- 上级机构为：1＝总行
            ,organaddress -- 详细地址
            ,postalcode -- 邮政编码
            ,telephone -- 电话号码
            ,organmanager -- 机构负责人
            ,organpamount -- 机构人数
            ,linkman -- 联系人姓名
            ,builddate -- 成立时间
            ,organdes -- 提示标志 0正常，1新增标识，2未填写行政区划代码标识
            ,validatedate -- 生效时间
            ,invalidatedate -- 失效时间
            ,createdate -- 创建时间
            ,creator -- 创建人
            ,modifydate -- 修改时间
            ,modifier -- 修改人员
            ,flag -- 标志位
            ,unionorgkey -- 现代支付系统行号
            ,org_area -- 行政区划代码
            ,settleorgkey -- 人民币结算账户管理系统行号
            ,uporgankey_sor -- 
            ,organcode -- 机构编码
            ,is_cross -- 跨境标识（境内10;境外11）
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.amls_t00_organ_op(
            organkey -- 机构代码内部使用
            ,organno -- 机构号
            ,organname -- 机构名称
            ,organsf -- 机构简称
            ,organlevel -- 机构级别 0通用级，1总行级，2分行级，3支行级
            ,uporgankey -- 上级机构为：1＝总行
            ,organaddress -- 详细地址
            ,postalcode -- 邮政编码
            ,telephone -- 电话号码
            ,organmanager -- 机构负责人
            ,organpamount -- 机构人数
            ,linkman -- 联系人姓名
            ,builddate -- 成立时间
            ,organdes -- 提示标志 0正常，1新增标识，2未填写行政区划代码标识
            ,validatedate -- 生效时间
            ,invalidatedate -- 失效时间
            ,createdate -- 创建时间
            ,creator -- 创建人
            ,modifydate -- 修改时间
            ,modifier -- 修改人员
            ,flag -- 标志位
            ,unionorgkey -- 现代支付系统行号
            ,org_area -- 行政区划代码
            ,settleorgkey -- 人民币结算账户管理系统行号
            ,uporgankey_sor -- 
            ,organcode -- 机构编码
            ,is_cross -- 跨境标识（境内10;境外11）
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.organkey -- 机构代码内部使用
    ,o.organno -- 机构号
    ,o.organname -- 机构名称
    ,o.organsf -- 机构简称
    ,o.organlevel -- 机构级别 0通用级，1总行级，2分行级，3支行级
    ,o.uporgankey -- 上级机构为：1＝总行
    ,o.organaddress -- 详细地址
    ,o.postalcode -- 邮政编码
    ,o.telephone -- 电话号码
    ,o.organmanager -- 机构负责人
    ,o.organpamount -- 机构人数
    ,o.linkman -- 联系人姓名
    ,o.builddate -- 成立时间
    ,o.organdes -- 提示标志 0正常，1新增标识，2未填写行政区划代码标识
    ,o.validatedate -- 生效时间
    ,o.invalidatedate -- 失效时间
    ,o.createdate -- 创建时间
    ,o.creator -- 创建人
    ,o.modifydate -- 修改时间
    ,o.modifier -- 修改人员
    ,o.flag -- 标志位
    ,o.unionorgkey -- 现代支付系统行号
    ,o.org_area -- 行政区划代码
    ,o.settleorgkey -- 人民币结算账户管理系统行号
    ,o.uporgankey_sor -- 
    ,o.organcode -- 机构编码
    ,o.is_cross -- 跨境标识（境内10;境外11）
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
from ${iol_schema}.amls_t00_organ_bk o
    left join ${iol_schema}.amls_t00_organ_op n
        on
            o.organkey = n.organkey
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.amls_t00_organ_cl d
        on
            o.organkey = d.organkey
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
--truncate table ${iol_schema}.amls_t00_organ;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('amls_t00_organ') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.amls_t00_organ drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.amls_t00_organ add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.amls_t00_organ exchange partition p_${batch_date} with table ${iol_schema}.amls_t00_organ_cl;
alter table ${iol_schema}.amls_t00_organ exchange partition p_20991231 with table ${iol_schema}.amls_t00_organ_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.amls_t00_organ to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.amls_t00_organ_op purge;
drop table ${iol_schema}.amls_t00_organ_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.amls_t00_organ_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'amls_t00_organ',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
