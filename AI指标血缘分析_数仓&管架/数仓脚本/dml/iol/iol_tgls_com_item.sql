/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_tgls_com_item
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
create table ${iol_schema}.tgls_com_item_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.tgls_com_item
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.tgls_com_item_op purge;
drop table ${iol_schema}.tgls_com_item_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.tgls_com_item_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.tgls_com_item where 0=1;

create table ${iol_schema}.tgls_com_item_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.tgls_com_item where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.tgls_com_item_cl(
            stacid -- 账套标记
            ,itemcd -- 科目编号
            ,sprrcd -- 上级科目编号
            ,itemna -- 科目名称
            ,itemlv -- 科目级别
            ,cutrna -- 备用名称
            ,itemtp -- 科目类型(1资产类2负债类3所有者权益类4系统往来类5损益类6表外,7备忘)
            ,itempr -- 科目属性0汇总科目2多账户科目3无分户科目
            ,detltg -- 是否末级(0非末级科目1末级科目)
            ,itemdn -- 科目余额方向(d,c,r.p.b)
            ,usedtp -- 是否已使用(1:已使用,0:未使用,9:停用)
            ,measut -- 计量单位
            ,confin -- 是否受限科目
            ,pomdtg -- 是否允许透支(1允许0不允许)
            ,mntytg -- 货币性项目标志(0货币性项目1一般非货币性项目2公允价值计量的非货币性项目)
            ,inactp -- 建账类型(1总部管理2分行（市县联社）管理5支行（分社）管理)
            ,brchtg -- 部门辅助设置
            ,prcdtg -- 产品辅助设置
            ,bulntg -- 业务条线辅助设置
            ,custtg -- 往来单位辅助设置
            ,emlytg -- 职员辅助设置
            ,accttg -- 账户辅助设置
            ,itemcl -- 科目归属（d：存款账l：贷款账i：内部账a：考核账）
            ,ioflag -- 表内外标志（i表内o表外）
            ,hdopmd -- 手工开户受理模式（0：不允许通用记账1：总行代开2：分行代开3：自行开立）
            ,begndt -- 科目生效日期
            ,overdt -- 科目失效日期
            ,usesys -- 科目使用系统
            ,happen -- 科目发生额方向
            ,sepatg -- 是否价税分离（0：不涉及，1：是，2：否）
            ,warning -- 是否科目余额浮动预警（0：否，1：是）
            ,counbe -- 柜面手工记账开始日期
            ,counov -- 柜面手工记账结束日期
            ,checkbe -- 核算中台手工记账开始日期
            ,checkov -- 核算中台手工记账结束日期
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.tgls_com_item_op(
            stacid -- 账套标记
            ,itemcd -- 科目编号
            ,sprrcd -- 上级科目编号
            ,itemna -- 科目名称
            ,itemlv -- 科目级别
            ,cutrna -- 备用名称
            ,itemtp -- 科目类型(1资产类2负债类3所有者权益类4系统往来类5损益类6表外,7备忘)
            ,itempr -- 科目属性0汇总科目2多账户科目3无分户科目
            ,detltg -- 是否末级(0非末级科目1末级科目)
            ,itemdn -- 科目余额方向(d,c,r.p.b)
            ,usedtp -- 是否已使用(1:已使用,0:未使用,9:停用)
            ,measut -- 计量单位
            ,confin -- 是否受限科目
            ,pomdtg -- 是否允许透支(1允许0不允许)
            ,mntytg -- 货币性项目标志(0货币性项目1一般非货币性项目2公允价值计量的非货币性项目)
            ,inactp -- 建账类型(1总部管理2分行（市县联社）管理5支行（分社）管理)
            ,brchtg -- 部门辅助设置
            ,prcdtg -- 产品辅助设置
            ,bulntg -- 业务条线辅助设置
            ,custtg -- 往来单位辅助设置
            ,emlytg -- 职员辅助设置
            ,accttg -- 账户辅助设置
            ,itemcl -- 科目归属（d：存款账l：贷款账i：内部账a：考核账）
            ,ioflag -- 表内外标志（i表内o表外）
            ,hdopmd -- 手工开户受理模式（0：不允许通用记账1：总行代开2：分行代开3：自行开立）
            ,begndt -- 科目生效日期
            ,overdt -- 科目失效日期
            ,usesys -- 科目使用系统
            ,happen -- 科目发生额方向
            ,sepatg -- 是否价税分离（0：不涉及，1：是，2：否）
            ,warning -- 是否科目余额浮动预警（0：否，1：是）
            ,counbe -- 柜面手工记账开始日期
            ,counov -- 柜面手工记账结束日期
            ,checkbe -- 核算中台手工记账开始日期
            ,checkov -- 核算中台手工记账结束日期
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.stacid, o.stacid) as stacid -- 账套标记
    ,nvl(n.itemcd, o.itemcd) as itemcd -- 科目编号
    ,nvl(n.sprrcd, o.sprrcd) as sprrcd -- 上级科目编号
    ,nvl(n.itemna, o.itemna) as itemna -- 科目名称
    ,nvl(n.itemlv, o.itemlv) as itemlv -- 科目级别
    ,nvl(n.cutrna, o.cutrna) as cutrna -- 备用名称
    ,nvl(n.itemtp, o.itemtp) as itemtp -- 科目类型(1资产类2负债类3所有者权益类4系统往来类5损益类6表外,7备忘)
    ,nvl(n.itempr, o.itempr) as itempr -- 科目属性0汇总科目2多账户科目3无分户科目
    ,nvl(n.detltg, o.detltg) as detltg -- 是否末级(0非末级科目1末级科目)
    ,nvl(n.itemdn, o.itemdn) as itemdn -- 科目余额方向(d,c,r.p.b)
    ,nvl(n.usedtp, o.usedtp) as usedtp -- 是否已使用(1:已使用,0:未使用,9:停用)
    ,nvl(n.measut, o.measut) as measut -- 计量单位
    ,nvl(n.confin, o.confin) as confin -- 是否受限科目
    ,nvl(n.pomdtg, o.pomdtg) as pomdtg -- 是否允许透支(1允许0不允许)
    ,nvl(n.mntytg, o.mntytg) as mntytg -- 货币性项目标志(0货币性项目1一般非货币性项目2公允价值计量的非货币性项目)
    ,nvl(n.inactp, o.inactp) as inactp -- 建账类型(1总部管理2分行（市县联社）管理5支行（分社）管理)
    ,nvl(n.brchtg, o.brchtg) as brchtg -- 部门辅助设置
    ,nvl(n.prcdtg, o.prcdtg) as prcdtg -- 产品辅助设置
    ,nvl(n.bulntg, o.bulntg) as bulntg -- 业务条线辅助设置
    ,nvl(n.custtg, o.custtg) as custtg -- 往来单位辅助设置
    ,nvl(n.emlytg, o.emlytg) as emlytg -- 职员辅助设置
    ,nvl(n.accttg, o.accttg) as accttg -- 账户辅助设置
    ,nvl(n.itemcl, o.itemcl) as itemcl -- 科目归属（d：存款账l：贷款账i：内部账a：考核账）
    ,nvl(n.ioflag, o.ioflag) as ioflag -- 表内外标志（i表内o表外）
    ,nvl(n.hdopmd, o.hdopmd) as hdopmd -- 手工开户受理模式（0：不允许通用记账1：总行代开2：分行代开3：自行开立）
    ,nvl(n.begndt, o.begndt) as begndt -- 科目生效日期
    ,nvl(n.overdt, o.overdt) as overdt -- 科目失效日期
    ,nvl(n.usesys, o.usesys) as usesys -- 科目使用系统
    ,nvl(n.happen, o.happen) as happen -- 科目发生额方向
    ,nvl(n.sepatg, o.sepatg) as sepatg -- 是否价税分离（0：不涉及，1：是，2：否）
    ,nvl(n.warning, o.warning) as warning -- 是否科目余额浮动预警（0：否，1：是）
    ,nvl(n.counbe, o.counbe) as counbe -- 柜面手工记账开始日期
    ,nvl(n.counov, o.counov) as counov -- 柜面手工记账结束日期
    ,nvl(n.checkbe, o.checkbe) as checkbe -- 核算中台手工记账开始日期
    ,nvl(n.checkov, o.checkov) as checkov -- 核算中台手工记账结束日期
    ,case when
            n.stacid is null
            and n.itemcd is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.stacid is null
            and n.itemcd is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.stacid is null
            and n.itemcd is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.tgls_com_item_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.tgls_com_item where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.stacid = n.stacid
            and o.itemcd = n.itemcd
where (
        o.stacid is null
        and o.itemcd is null
    )
    or (
        n.stacid is null
        and n.itemcd is null
    )
    or (
        o.sprrcd <> n.sprrcd
        or o.itemna <> n.itemna
        or o.itemlv <> n.itemlv
        or o.cutrna <> n.cutrna
        or o.itemtp <> n.itemtp
        or o.itempr <> n.itempr
        or o.detltg <> n.detltg
        or o.itemdn <> n.itemdn
        or o.usedtp <> n.usedtp
        or o.measut <> n.measut
        or o.confin <> n.confin
        or o.pomdtg <> n.pomdtg
        or o.mntytg <> n.mntytg
        or o.inactp <> n.inactp
        or o.brchtg <> n.brchtg
        or o.prcdtg <> n.prcdtg
        or o.bulntg <> n.bulntg
        or o.custtg <> n.custtg
        or o.emlytg <> n.emlytg
        or o.accttg <> n.accttg
        or o.itemcl <> n.itemcl
        or o.ioflag <> n.ioflag
        or o.hdopmd <> n.hdopmd
        or o.begndt <> n.begndt
        or o.overdt <> n.overdt
        or o.usesys <> n.usesys
        or o.happen <> n.happen
        or o.sepatg <> n.sepatg
        or o.warning <> n.warning
        or o.counbe <> n.counbe
        or o.counov <> n.counov
        or o.checkbe <> n.checkbe
        or o.checkov <> n.checkov
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.tgls_com_item_cl(
            stacid -- 账套标记
            ,itemcd -- 科目编号
            ,sprrcd -- 上级科目编号
            ,itemna -- 科目名称
            ,itemlv -- 科目级别
            ,cutrna -- 备用名称
            ,itemtp -- 科目类型(1资产类2负债类3所有者权益类4系统往来类5损益类6表外,7备忘)
            ,itempr -- 科目属性0汇总科目2多账户科目3无分户科目
            ,detltg -- 是否末级(0非末级科目1末级科目)
            ,itemdn -- 科目余额方向(d,c,r.p.b)
            ,usedtp -- 是否已使用(1:已使用,0:未使用,9:停用)
            ,measut -- 计量单位
            ,confin -- 是否受限科目
            ,pomdtg -- 是否允许透支(1允许0不允许)
            ,mntytg -- 货币性项目标志(0货币性项目1一般非货币性项目2公允价值计量的非货币性项目)
            ,inactp -- 建账类型(1总部管理2分行（市县联社）管理5支行（分社）管理)
            ,brchtg -- 部门辅助设置
            ,prcdtg -- 产品辅助设置
            ,bulntg -- 业务条线辅助设置
            ,custtg -- 往来单位辅助设置
            ,emlytg -- 职员辅助设置
            ,accttg -- 账户辅助设置
            ,itemcl -- 科目归属（d：存款账l：贷款账i：内部账a：考核账）
            ,ioflag -- 表内外标志（i表内o表外）
            ,hdopmd -- 手工开户受理模式（0：不允许通用记账1：总行代开2：分行代开3：自行开立）
            ,begndt -- 科目生效日期
            ,overdt -- 科目失效日期
            ,usesys -- 科目使用系统
            ,happen -- 科目发生额方向
            ,sepatg -- 是否价税分离（0：不涉及，1：是，2：否）
            ,warning -- 是否科目余额浮动预警（0：否，1：是）
            ,counbe -- 柜面手工记账开始日期
            ,counov -- 柜面手工记账结束日期
            ,checkbe -- 核算中台手工记账开始日期
            ,checkov -- 核算中台手工记账结束日期
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.tgls_com_item_op(
            stacid -- 账套标记
            ,itemcd -- 科目编号
            ,sprrcd -- 上级科目编号
            ,itemna -- 科目名称
            ,itemlv -- 科目级别
            ,cutrna -- 备用名称
            ,itemtp -- 科目类型(1资产类2负债类3所有者权益类4系统往来类5损益类6表外,7备忘)
            ,itempr -- 科目属性0汇总科目2多账户科目3无分户科目
            ,detltg -- 是否末级(0非末级科目1末级科目)
            ,itemdn -- 科目余额方向(d,c,r.p.b)
            ,usedtp -- 是否已使用(1:已使用,0:未使用,9:停用)
            ,measut -- 计量单位
            ,confin -- 是否受限科目
            ,pomdtg -- 是否允许透支(1允许0不允许)
            ,mntytg -- 货币性项目标志(0货币性项目1一般非货币性项目2公允价值计量的非货币性项目)
            ,inactp -- 建账类型(1总部管理2分行（市县联社）管理5支行（分社）管理)
            ,brchtg -- 部门辅助设置
            ,prcdtg -- 产品辅助设置
            ,bulntg -- 业务条线辅助设置
            ,custtg -- 往来单位辅助设置
            ,emlytg -- 职员辅助设置
            ,accttg -- 账户辅助设置
            ,itemcl -- 科目归属（d：存款账l：贷款账i：内部账a：考核账）
            ,ioflag -- 表内外标志（i表内o表外）
            ,hdopmd -- 手工开户受理模式（0：不允许通用记账1：总行代开2：分行代开3：自行开立）
            ,begndt -- 科目生效日期
            ,overdt -- 科目失效日期
            ,usesys -- 科目使用系统
            ,happen -- 科目发生额方向
            ,sepatg -- 是否价税分离（0：不涉及，1：是，2：否）
            ,warning -- 是否科目余额浮动预警（0：否，1：是）
            ,counbe -- 柜面手工记账开始日期
            ,counov -- 柜面手工记账结束日期
            ,checkbe -- 核算中台手工记账开始日期
            ,checkov -- 核算中台手工记账结束日期
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.stacid -- 账套标记
    ,o.itemcd -- 科目编号
    ,o.sprrcd -- 上级科目编号
    ,o.itemna -- 科目名称
    ,o.itemlv -- 科目级别
    ,o.cutrna -- 备用名称
    ,o.itemtp -- 科目类型(1资产类2负债类3所有者权益类4系统往来类5损益类6表外,7备忘)
    ,o.itempr -- 科目属性0汇总科目2多账户科目3无分户科目
    ,o.detltg -- 是否末级(0非末级科目1末级科目)
    ,o.itemdn -- 科目余额方向(d,c,r.p.b)
    ,o.usedtp -- 是否已使用(1:已使用,0:未使用,9:停用)
    ,o.measut -- 计量单位
    ,o.confin -- 是否受限科目
    ,o.pomdtg -- 是否允许透支(1允许0不允许)
    ,o.mntytg -- 货币性项目标志(0货币性项目1一般非货币性项目2公允价值计量的非货币性项目)
    ,o.inactp -- 建账类型(1总部管理2分行（市县联社）管理5支行（分社）管理)
    ,o.brchtg -- 部门辅助设置
    ,o.prcdtg -- 产品辅助设置
    ,o.bulntg -- 业务条线辅助设置
    ,o.custtg -- 往来单位辅助设置
    ,o.emlytg -- 职员辅助设置
    ,o.accttg -- 账户辅助设置
    ,o.itemcl -- 科目归属（d：存款账l：贷款账i：内部账a：考核账）
    ,o.ioflag -- 表内外标志（i表内o表外）
    ,o.hdopmd -- 手工开户受理模式（0：不允许通用记账1：总行代开2：分行代开3：自行开立）
    ,o.begndt -- 科目生效日期
    ,o.overdt -- 科目失效日期
    ,o.usesys -- 科目使用系统
    ,o.happen -- 科目发生额方向
    ,o.sepatg -- 是否价税分离（0：不涉及，1：是，2：否）
    ,o.warning -- 是否科目余额浮动预警（0：否，1：是）
    ,o.counbe -- 柜面手工记账开始日期
    ,o.counov -- 柜面手工记账结束日期
    ,o.checkbe -- 核算中台手工记账开始日期
    ,o.checkov -- 核算中台手工记账结束日期
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
from ${iol_schema}.tgls_com_item_bk o
    left join ${iol_schema}.tgls_com_item_op n
        on
            o.stacid = n.stacid
            and o.itemcd = n.itemcd
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.tgls_com_item_cl d
        on
            o.stacid = d.stacid
            and o.itemcd = d.itemcd
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
--truncate table ${iol_schema}.tgls_com_item;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('tgls_com_item') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.tgls_com_item drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.tgls_com_item add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.tgls_com_item exchange partition p_${batch_date} with table ${iol_schema}.tgls_com_item_cl;
alter table ${iol_schema}.tgls_com_item exchange partition p_20991231 with table ${iol_schema}.tgls_com_item_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.tgls_com_item to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.tgls_com_item_op purge;
drop table ${iol_schema}.tgls_com_item_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.tgls_com_item_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'tgls_com_item',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
