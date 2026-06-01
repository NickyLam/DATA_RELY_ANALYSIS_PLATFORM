/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_icms_group_limit_occupy
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
create table ${iol_schema}.icms_group_limit_occupy_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.icms_group_limit_occupy
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.icms_group_limit_occupy_op purge;
drop table ${iol_schema}.icms_group_limit_occupy_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.icms_group_limit_occupy_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.icms_group_limit_occupy where 0=1;

create table ${iol_schema}.icms_group_limit_occupy_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.icms_group_limit_occupy where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.icms_group_limit_occupy_cl(
            fromsystem -- 来源系统
            ,objectno -- 业务流水号
            ,balance -- 余额
            ,inputtime -- 登记时间(格式：YYYY/MM/DDhh:mm:ss)
            ,businesscurrency -- 币种
            ,groupcustomerid -- 关联信贷集团客户号
            ,mfcustomerid -- 申请人核心客户号
            ,relacustomerid -- 关联公司客户号(注：个人客户关联的公司客户)
            ,updatetime -- 更新时间(格式：YYYY/MM/DDhh:mm:ss)
            ,balancechangetime -- 余额变化时间(格式：YYYY/MM/DDhh:mm:ss)
            ,bailsum -- 保证金(折人民币元)
            ,putoutdate -- 起始日期(格式：YYYY/MM/DD)
            ,relacustomername -- 关联公司客户号名称(注：个人客户作为法代、实控人、股东关联的公司客户)
            ,businesssum -- 申请金额
            ,contractno -- 贷款合同号
            ,customerid -- 申请人信贷客户号
            ,effectflag -- 生效状态
            ,customername -- 申请人信贷客户名称
            ,certid -- 申请人证件号码
            ,totalputoutsum -- 累计发放金额
            ,totalsum -- 敞口金额(折人民币元)
            ,lowriskassuresum -- 低风险担保金额(折人民币元)
            ,groupcustomername -- 关联信贷集团客户名称
            ,grouplimitid -- 关联集团限额流水
            ,cycleflag -- 是否循环
            ,maturity -- 到期日期(格式：YYYY/MM/DD)
            ,certtype -- 申请人证件类型
            ,statuschangetime -- 状态变化时间(格式：YYYY/MM/DDhh:mm:ss)
            ,businesstype -- 业务品种代码
            ,businesstypename -- 业务品种名称
            ,relacustomertype -- 关联公司客户类型(注：个人客户作为法代、实控人、股东关联的公司客户)
            ,relatype -- 关联类型(参考：集团成员、法人代表、实控人、股东)
            ,migtflag -- 迁移标志：crsrcrilcupl
            ,applycustomername -- 客户名称(零售推送)
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.icms_group_limit_occupy_op(
            fromsystem -- 来源系统
            ,objectno -- 业务流水号
            ,balance -- 余额
            ,inputtime -- 登记时间(格式：YYYY/MM/DDhh:mm:ss)
            ,businesscurrency -- 币种
            ,groupcustomerid -- 关联信贷集团客户号
            ,mfcustomerid -- 申请人核心客户号
            ,relacustomerid -- 关联公司客户号(注：个人客户关联的公司客户)
            ,updatetime -- 更新时间(格式：YYYY/MM/DDhh:mm:ss)
            ,balancechangetime -- 余额变化时间(格式：YYYY/MM/DDhh:mm:ss)
            ,bailsum -- 保证金(折人民币元)
            ,putoutdate -- 起始日期(格式：YYYY/MM/DD)
            ,relacustomername -- 关联公司客户号名称(注：个人客户作为法代、实控人、股东关联的公司客户)
            ,businesssum -- 申请金额
            ,contractno -- 贷款合同号
            ,customerid -- 申请人信贷客户号
            ,effectflag -- 生效状态
            ,customername -- 申请人信贷客户名称
            ,certid -- 申请人证件号码
            ,totalputoutsum -- 累计发放金额
            ,totalsum -- 敞口金额(折人民币元)
            ,lowriskassuresum -- 低风险担保金额(折人民币元)
            ,groupcustomername -- 关联信贷集团客户名称
            ,grouplimitid -- 关联集团限额流水
            ,cycleflag -- 是否循环
            ,maturity -- 到期日期(格式：YYYY/MM/DD)
            ,certtype -- 申请人证件类型
            ,statuschangetime -- 状态变化时间(格式：YYYY/MM/DDhh:mm:ss)
            ,businesstype -- 业务品种代码
            ,businesstypename -- 业务品种名称
            ,relacustomertype -- 关联公司客户类型(注：个人客户作为法代、实控人、股东关联的公司客户)
            ,relatype -- 关联类型(参考：集团成员、法人代表、实控人、股东)
            ,migtflag -- 迁移标志：crsrcrilcupl
            ,applycustomername -- 客户名称(零售推送)
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.fromsystem, o.fromsystem) as fromsystem -- 来源系统
    ,nvl(n.objectno, o.objectno) as objectno -- 业务流水号
    ,nvl(n.balance, o.balance) as balance -- 余额
    ,nvl(n.inputtime, o.inputtime) as inputtime -- 登记时间(格式：YYYY/MM/DDhh:mm:ss)
    ,nvl(n.businesscurrency, o.businesscurrency) as businesscurrency -- 币种
    ,nvl(n.groupcustomerid, o.groupcustomerid) as groupcustomerid -- 关联信贷集团客户号
    ,nvl(n.mfcustomerid, o.mfcustomerid) as mfcustomerid -- 申请人核心客户号
    ,nvl(n.relacustomerid, o.relacustomerid) as relacustomerid -- 关联公司客户号(注：个人客户关联的公司客户)
    ,nvl(n.updatetime, o.updatetime) as updatetime -- 更新时间(格式：YYYY/MM/DDhh:mm:ss)
    ,nvl(n.balancechangetime, o.balancechangetime) as balancechangetime -- 余额变化时间(格式：YYYY/MM/DDhh:mm:ss)
    ,nvl(n.bailsum, o.bailsum) as bailsum -- 保证金(折人民币元)
    ,nvl(n.putoutdate, o.putoutdate) as putoutdate -- 起始日期(格式：YYYY/MM/DD)
    ,nvl(n.relacustomername, o.relacustomername) as relacustomername -- 关联公司客户号名称(注：个人客户作为法代、实控人、股东关联的公司客户)
    ,nvl(n.businesssum, o.businesssum) as businesssum -- 申请金额
    ,nvl(n.contractno, o.contractno) as contractno -- 贷款合同号
    ,nvl(n.customerid, o.customerid) as customerid -- 申请人信贷客户号
    ,nvl(n.effectflag, o.effectflag) as effectflag -- 生效状态
    ,nvl(n.customername, o.customername) as customername -- 申请人信贷客户名称
    ,nvl(n.certid, o.certid) as certid -- 申请人证件号码
    ,nvl(n.totalputoutsum, o.totalputoutsum) as totalputoutsum -- 累计发放金额
    ,nvl(n.totalsum, o.totalsum) as totalsum -- 敞口金额(折人民币元)
    ,nvl(n.lowriskassuresum, o.lowriskassuresum) as lowriskassuresum -- 低风险担保金额(折人民币元)
    ,nvl(n.groupcustomername, o.groupcustomername) as groupcustomername -- 关联信贷集团客户名称
    ,nvl(n.grouplimitid, o.grouplimitid) as grouplimitid -- 关联集团限额流水
    ,nvl(n.cycleflag, o.cycleflag) as cycleflag -- 是否循环
    ,nvl(n.maturity, o.maturity) as maturity -- 到期日期(格式：YYYY/MM/DD)
    ,nvl(n.certtype, o.certtype) as certtype -- 申请人证件类型
    ,nvl(n.statuschangetime, o.statuschangetime) as statuschangetime -- 状态变化时间(格式：YYYY/MM/DDhh:mm:ss)
    ,nvl(n.businesstype, o.businesstype) as businesstype -- 业务品种代码
    ,nvl(n.businesstypename, o.businesstypename) as businesstypename -- 业务品种名称
    ,nvl(n.relacustomertype, o.relacustomertype) as relacustomertype -- 关联公司客户类型(注：个人客户作为法代、实控人、股东关联的公司客户)
    ,nvl(n.relatype, o.relatype) as relatype -- 关联类型(参考：集团成员、法人代表、实控人、股东)
    ,nvl(n.migtflag, o.migtflag) as migtflag -- 迁移标志：crsrcrilcupl
    ,nvl(n.applycustomername, o.applycustomername) as applycustomername -- 客户名称(零售推送)
    ,case when
            n.fromsystem is null
            and n.objectno is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.fromsystem is null
            and n.objectno is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.fromsystem is null
            and n.objectno is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.icms_group_limit_occupy_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.icms_group_limit_occupy where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.fromsystem = n.fromsystem
            and o.objectno = n.objectno
where (
        o.fromsystem is null
        and o.objectno is null
    )
    or (
        n.fromsystem is null
        and n.objectno is null
    )
    or (
        o.balance <> n.balance
        or o.inputtime <> n.inputtime
        or o.businesscurrency <> n.businesscurrency
        or o.groupcustomerid <> n.groupcustomerid
        or o.mfcustomerid <> n.mfcustomerid
        or o.relacustomerid <> n.relacustomerid
        or o.updatetime <> n.updatetime
        or o.balancechangetime <> n.balancechangetime
        or o.bailsum <> n.bailsum
        or o.putoutdate <> n.putoutdate
        or o.relacustomername <> n.relacustomername
        or o.businesssum <> n.businesssum
        or o.contractno <> n.contractno
        or o.customerid <> n.customerid
        or o.effectflag <> n.effectflag
        or o.customername <> n.customername
        or o.certid <> n.certid
        or o.totalputoutsum <> n.totalputoutsum
        or o.totalsum <> n.totalsum
        or o.lowriskassuresum <> n.lowriskassuresum
        or o.groupcustomername <> n.groupcustomername
        or o.grouplimitid <> n.grouplimitid
        or o.cycleflag <> n.cycleflag
        or o.maturity <> n.maturity
        or o.certtype <> n.certtype
        or o.statuschangetime <> n.statuschangetime
        or o.businesstype <> n.businesstype
        or o.businesstypename <> n.businesstypename
        or o.relacustomertype <> n.relacustomertype
        or o.relatype <> n.relatype
        or o.migtflag <> n.migtflag
        or o.applycustomername <> n.applycustomername
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.icms_group_limit_occupy_cl(
            fromsystem -- 来源系统
            ,objectno -- 业务流水号
            ,balance -- 余额
            ,inputtime -- 登记时间(格式：YYYY/MM/DDhh:mm:ss)
            ,businesscurrency -- 币种
            ,groupcustomerid -- 关联信贷集团客户号
            ,mfcustomerid -- 申请人核心客户号
            ,relacustomerid -- 关联公司客户号(注：个人客户关联的公司客户)
            ,updatetime -- 更新时间(格式：YYYY/MM/DDhh:mm:ss)
            ,balancechangetime -- 余额变化时间(格式：YYYY/MM/DDhh:mm:ss)
            ,bailsum -- 保证金(折人民币元)
            ,putoutdate -- 起始日期(格式：YYYY/MM/DD)
            ,relacustomername -- 关联公司客户号名称(注：个人客户作为法代、实控人、股东关联的公司客户)
            ,businesssum -- 申请金额
            ,contractno -- 贷款合同号
            ,customerid -- 申请人信贷客户号
            ,effectflag -- 生效状态
            ,customername -- 申请人信贷客户名称
            ,certid -- 申请人证件号码
            ,totalputoutsum -- 累计发放金额
            ,totalsum -- 敞口金额(折人民币元)
            ,lowriskassuresum -- 低风险担保金额(折人民币元)
            ,groupcustomername -- 关联信贷集团客户名称
            ,grouplimitid -- 关联集团限额流水
            ,cycleflag -- 是否循环
            ,maturity -- 到期日期(格式：YYYY/MM/DD)
            ,certtype -- 申请人证件类型
            ,statuschangetime -- 状态变化时间(格式：YYYY/MM/DDhh:mm:ss)
            ,businesstype -- 业务品种代码
            ,businesstypename -- 业务品种名称
            ,relacustomertype -- 关联公司客户类型(注：个人客户作为法代、实控人、股东关联的公司客户)
            ,relatype -- 关联类型(参考：集团成员、法人代表、实控人、股东)
            ,migtflag -- 迁移标志：crsrcrilcupl
            ,applycustomername -- 客户名称(零售推送)
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.icms_group_limit_occupy_op(
            fromsystem -- 来源系统
            ,objectno -- 业务流水号
            ,balance -- 余额
            ,inputtime -- 登记时间(格式：YYYY/MM/DDhh:mm:ss)
            ,businesscurrency -- 币种
            ,groupcustomerid -- 关联信贷集团客户号
            ,mfcustomerid -- 申请人核心客户号
            ,relacustomerid -- 关联公司客户号(注：个人客户关联的公司客户)
            ,updatetime -- 更新时间(格式：YYYY/MM/DDhh:mm:ss)
            ,balancechangetime -- 余额变化时间(格式：YYYY/MM/DDhh:mm:ss)
            ,bailsum -- 保证金(折人民币元)
            ,putoutdate -- 起始日期(格式：YYYY/MM/DD)
            ,relacustomername -- 关联公司客户号名称(注：个人客户作为法代、实控人、股东关联的公司客户)
            ,businesssum -- 申请金额
            ,contractno -- 贷款合同号
            ,customerid -- 申请人信贷客户号
            ,effectflag -- 生效状态
            ,customername -- 申请人信贷客户名称
            ,certid -- 申请人证件号码
            ,totalputoutsum -- 累计发放金额
            ,totalsum -- 敞口金额(折人民币元)
            ,lowriskassuresum -- 低风险担保金额(折人民币元)
            ,groupcustomername -- 关联信贷集团客户名称
            ,grouplimitid -- 关联集团限额流水
            ,cycleflag -- 是否循环
            ,maturity -- 到期日期(格式：YYYY/MM/DD)
            ,certtype -- 申请人证件类型
            ,statuschangetime -- 状态变化时间(格式：YYYY/MM/DDhh:mm:ss)
            ,businesstype -- 业务品种代码
            ,businesstypename -- 业务品种名称
            ,relacustomertype -- 关联公司客户类型(注：个人客户作为法代、实控人、股东关联的公司客户)
            ,relatype -- 关联类型(参考：集团成员、法人代表、实控人、股东)
            ,migtflag -- 迁移标志：crsrcrilcupl
            ,applycustomername -- 客户名称(零售推送)
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.fromsystem -- 来源系统
    ,o.objectno -- 业务流水号
    ,o.balance -- 余额
    ,o.inputtime -- 登记时间(格式：YYYY/MM/DDhh:mm:ss)
    ,o.businesscurrency -- 币种
    ,o.groupcustomerid -- 关联信贷集团客户号
    ,o.mfcustomerid -- 申请人核心客户号
    ,o.relacustomerid -- 关联公司客户号(注：个人客户关联的公司客户)
    ,o.updatetime -- 更新时间(格式：YYYY/MM/DDhh:mm:ss)
    ,o.balancechangetime -- 余额变化时间(格式：YYYY/MM/DDhh:mm:ss)
    ,o.bailsum -- 保证金(折人民币元)
    ,o.putoutdate -- 起始日期(格式：YYYY/MM/DD)
    ,o.relacustomername -- 关联公司客户号名称(注：个人客户作为法代、实控人、股东关联的公司客户)
    ,o.businesssum -- 申请金额
    ,o.contractno -- 贷款合同号
    ,o.customerid -- 申请人信贷客户号
    ,o.effectflag -- 生效状态
    ,o.customername -- 申请人信贷客户名称
    ,o.certid -- 申请人证件号码
    ,o.totalputoutsum -- 累计发放金额
    ,o.totalsum -- 敞口金额(折人民币元)
    ,o.lowriskassuresum -- 低风险担保金额(折人民币元)
    ,o.groupcustomername -- 关联信贷集团客户名称
    ,o.grouplimitid -- 关联集团限额流水
    ,o.cycleflag -- 是否循环
    ,o.maturity -- 到期日期(格式：YYYY/MM/DD)
    ,o.certtype -- 申请人证件类型
    ,o.statuschangetime -- 状态变化时间(格式：YYYY/MM/DDhh:mm:ss)
    ,o.businesstype -- 业务品种代码
    ,o.businesstypename -- 业务品种名称
    ,o.relacustomertype -- 关联公司客户类型(注：个人客户作为法代、实控人、股东关联的公司客户)
    ,o.relatype -- 关联类型(参考：集团成员、法人代表、实控人、股东)
    ,o.migtflag -- 迁移标志：crsrcrilcupl
    ,o.applycustomername -- 客户名称(零售推送)
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
from ${iol_schema}.icms_group_limit_occupy_bk o
    left join ${iol_schema}.icms_group_limit_occupy_op n
        on
            o.fromsystem = n.fromsystem
            and o.objectno = n.objectno
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.icms_group_limit_occupy_cl d
        on
            o.fromsystem = d.fromsystem
            and o.objectno = d.objectno
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
--truncate table ${iol_schema}.icms_group_limit_occupy;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('icms_group_limit_occupy') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.icms_group_limit_occupy drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.icms_group_limit_occupy add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.icms_group_limit_occupy exchange partition p_${batch_date} with table ${iol_schema}.icms_group_limit_occupy_cl;
alter table ${iol_schema}.icms_group_limit_occupy exchange partition p_20991231 with table ${iol_schema}.icms_group_limit_occupy_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.icms_group_limit_occupy to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.icms_group_limit_occupy_op purge;
drop table ${iol_schema}.icms_group_limit_occupy_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.icms_group_limit_occupy_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'icms_group_limit_occupy',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
