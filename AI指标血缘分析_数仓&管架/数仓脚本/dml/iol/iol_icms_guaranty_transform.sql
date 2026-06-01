/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_icms_guaranty_transform
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
create table ${iol_schema}.icms_guaranty_transform_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.icms_guaranty_transform
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.icms_guaranty_transform_op purge;
drop table ${iol_schema}.icms_guaranty_transform_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.icms_guaranty_transform_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.icms_guaranty_transform where 0=1;

create table ${iol_schema}.icms_guaranty_transform_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.icms_guaranty_transform where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.icms_guaranty_transform_cl(
            serialno -- 申请流水号
            ,guarantybailsubaccount -- 押品保证金子账号
            ,transformreason -- 变更原因
            ,manageorgid -- 管户机构ID
            ,relativeserialno -- 合同流水号字段
            ,customerid -- 客户编号
            ,objecttype -- 对象类型
            ,inputuserid -- 登记人
            ,migtflag -- 迁移标志：crsrcrilcupl
            ,inputorgid -- 登记机构
            ,inputdate -- 登记日期
            ,guarantybailaccount -- 押品保证金账号
            ,artificialno -- 文本合同号
            ,businesscurrency -- 币种
            ,updateuserid -- 更新人
            ,balance -- 当前余额
            ,occurtype -- 发生类型
            ,updatedate -- 更新日期
            ,customername -- 客户名称
            ,chgtype -- 担保变更类型
            ,istfb -- 是否提放保
            ,businesssum -- 金额
            ,pigeonholedate -- 归档日期
            ,manageuserid -- 管户人ID
            ,businesstype -- 业务品种
            ,approvestatus -- 审批状态
            ,changenums -- 变更次数
            ,corporgid -- 法人机构编号
            ,updateorgid -- 更新机构
            ,ischangeapprove -- 是否需要授信批复变更
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.icms_guaranty_transform_op(
            serialno -- 申请流水号
            ,guarantybailsubaccount -- 押品保证金子账号
            ,transformreason -- 变更原因
            ,manageorgid -- 管户机构ID
            ,relativeserialno -- 合同流水号字段
            ,customerid -- 客户编号
            ,objecttype -- 对象类型
            ,inputuserid -- 登记人
            ,migtflag -- 迁移标志：crsrcrilcupl
            ,inputorgid -- 登记机构
            ,inputdate -- 登记日期
            ,guarantybailaccount -- 押品保证金账号
            ,artificialno -- 文本合同号
            ,businesscurrency -- 币种
            ,updateuserid -- 更新人
            ,balance -- 当前余额
            ,occurtype -- 发生类型
            ,updatedate -- 更新日期
            ,customername -- 客户名称
            ,chgtype -- 担保变更类型
            ,istfb -- 是否提放保
            ,businesssum -- 金额
            ,pigeonholedate -- 归档日期
            ,manageuserid -- 管户人ID
            ,businesstype -- 业务品种
            ,approvestatus -- 审批状态
            ,changenums -- 变更次数
            ,corporgid -- 法人机构编号
            ,updateorgid -- 更新机构
            ,ischangeapprove -- 是否需要授信批复变更
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.serialno, o.serialno) as serialno -- 申请流水号
    ,nvl(n.guarantybailsubaccount, o.guarantybailsubaccount) as guarantybailsubaccount -- 押品保证金子账号
    ,nvl(n.transformreason, o.transformreason) as transformreason -- 变更原因
    ,nvl(n.manageorgid, o.manageorgid) as manageorgid -- 管户机构ID
    ,nvl(n.relativeserialno, o.relativeserialno) as relativeserialno -- 合同流水号字段
    ,nvl(n.customerid, o.customerid) as customerid -- 客户编号
    ,nvl(n.objecttype, o.objecttype) as objecttype -- 对象类型
    ,nvl(n.inputuserid, o.inputuserid) as inputuserid -- 登记人
    ,nvl(n.migtflag, o.migtflag) as migtflag -- 迁移标志：crsrcrilcupl
    ,nvl(n.inputorgid, o.inputorgid) as inputorgid -- 登记机构
    ,nvl(n.inputdate, o.inputdate) as inputdate -- 登记日期
    ,nvl(n.guarantybailaccount, o.guarantybailaccount) as guarantybailaccount -- 押品保证金账号
    ,nvl(n.artificialno, o.artificialno) as artificialno -- 文本合同号
    ,nvl(n.businesscurrency, o.businesscurrency) as businesscurrency -- 币种
    ,nvl(n.updateuserid, o.updateuserid) as updateuserid -- 更新人
    ,nvl(n.balance, o.balance) as balance -- 当前余额
    ,nvl(n.occurtype, o.occurtype) as occurtype -- 发生类型
    ,nvl(n.updatedate, o.updatedate) as updatedate -- 更新日期
    ,nvl(n.customername, o.customername) as customername -- 客户名称
    ,nvl(n.chgtype, o.chgtype) as chgtype -- 担保变更类型
    ,nvl(n.istfb, o.istfb) as istfb -- 是否提放保
    ,nvl(n.businesssum, o.businesssum) as businesssum -- 金额
    ,nvl(n.pigeonholedate, o.pigeonholedate) as pigeonholedate -- 归档日期
    ,nvl(n.manageuserid, o.manageuserid) as manageuserid -- 管户人ID
    ,nvl(n.businesstype, o.businesstype) as businesstype -- 业务品种
    ,nvl(n.approvestatus, o.approvestatus) as approvestatus -- 审批状态
    ,nvl(n.changenums, o.changenums) as changenums -- 变更次数
    ,nvl(n.corporgid, o.corporgid) as corporgid -- 法人机构编号
    ,nvl(n.updateorgid, o.updateorgid) as updateorgid -- 更新机构
    ,nvl(n.ischangeapprove, o.ischangeapprove) as ischangeapprove -- 是否需要授信批复变更
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
from (select * from ${iol_schema}.icms_guaranty_transform_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.icms_guaranty_transform where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.serialno = n.serialno
where (
        o.serialno is null
    )
    or (
        n.serialno is null
    )
    or (
        o.guarantybailsubaccount <> n.guarantybailsubaccount
        or o.transformreason <> n.transformreason
        or o.manageorgid <> n.manageorgid
        or o.relativeserialno <> n.relativeserialno
        or o.customerid <> n.customerid
        or o.objecttype <> n.objecttype
        or o.inputuserid <> n.inputuserid
        or o.migtflag <> n.migtflag
        or o.inputorgid <> n.inputorgid
        or o.inputdate <> n.inputdate
        or o.guarantybailaccount <> n.guarantybailaccount
        or o.artificialno <> n.artificialno
        or o.businesscurrency <> n.businesscurrency
        or o.updateuserid <> n.updateuserid
        or o.balance <> n.balance
        or o.occurtype <> n.occurtype
        or o.updatedate <> n.updatedate
        or o.customername <> n.customername
        or o.chgtype <> n.chgtype
        or o.istfb <> n.istfb
        or o.businesssum <> n.businesssum
        or o.pigeonholedate <> n.pigeonholedate
        or o.manageuserid <> n.manageuserid
        or o.businesstype <> n.businesstype
        or o.approvestatus <> n.approvestatus
        or o.changenums <> n.changenums
        or o.corporgid <> n.corporgid
        or o.updateorgid <> n.updateorgid
        or o.ischangeapprove <> n.ischangeapprove
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.icms_guaranty_transform_cl(
            serialno -- 申请流水号
            ,guarantybailsubaccount -- 押品保证金子账号
            ,transformreason -- 变更原因
            ,manageorgid -- 管户机构ID
            ,relativeserialno -- 合同流水号字段
            ,customerid -- 客户编号
            ,objecttype -- 对象类型
            ,inputuserid -- 登记人
            ,migtflag -- 迁移标志：crsrcrilcupl
            ,inputorgid -- 登记机构
            ,inputdate -- 登记日期
            ,guarantybailaccount -- 押品保证金账号
            ,artificialno -- 文本合同号
            ,businesscurrency -- 币种
            ,updateuserid -- 更新人
            ,balance -- 当前余额
            ,occurtype -- 发生类型
            ,updatedate -- 更新日期
            ,customername -- 客户名称
            ,chgtype -- 担保变更类型
            ,istfb -- 是否提放保
            ,businesssum -- 金额
            ,pigeonholedate -- 归档日期
            ,manageuserid -- 管户人ID
            ,businesstype -- 业务品种
            ,approvestatus -- 审批状态
            ,changenums -- 变更次数
            ,corporgid -- 法人机构编号
            ,updateorgid -- 更新机构
            ,ischangeapprove -- 是否需要授信批复变更
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.icms_guaranty_transform_op(
            serialno -- 申请流水号
            ,guarantybailsubaccount -- 押品保证金子账号
            ,transformreason -- 变更原因
            ,manageorgid -- 管户机构ID
            ,relativeserialno -- 合同流水号字段
            ,customerid -- 客户编号
            ,objecttype -- 对象类型
            ,inputuserid -- 登记人
            ,migtflag -- 迁移标志：crsrcrilcupl
            ,inputorgid -- 登记机构
            ,inputdate -- 登记日期
            ,guarantybailaccount -- 押品保证金账号
            ,artificialno -- 文本合同号
            ,businesscurrency -- 币种
            ,updateuserid -- 更新人
            ,balance -- 当前余额
            ,occurtype -- 发生类型
            ,updatedate -- 更新日期
            ,customername -- 客户名称
            ,chgtype -- 担保变更类型
            ,istfb -- 是否提放保
            ,businesssum -- 金额
            ,pigeonholedate -- 归档日期
            ,manageuserid -- 管户人ID
            ,businesstype -- 业务品种
            ,approvestatus -- 审批状态
            ,changenums -- 变更次数
            ,corporgid -- 法人机构编号
            ,updateorgid -- 更新机构
            ,ischangeapprove -- 是否需要授信批复变更
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.serialno -- 申请流水号
    ,o.guarantybailsubaccount -- 押品保证金子账号
    ,o.transformreason -- 变更原因
    ,o.manageorgid -- 管户机构ID
    ,o.relativeserialno -- 合同流水号字段
    ,o.customerid -- 客户编号
    ,o.objecttype -- 对象类型
    ,o.inputuserid -- 登记人
    ,o.migtflag -- 迁移标志：crsrcrilcupl
    ,o.inputorgid -- 登记机构
    ,o.inputdate -- 登记日期
    ,o.guarantybailaccount -- 押品保证金账号
    ,o.artificialno -- 文本合同号
    ,o.businesscurrency -- 币种
    ,o.updateuserid -- 更新人
    ,o.balance -- 当前余额
    ,o.occurtype -- 发生类型
    ,o.updatedate -- 更新日期
    ,o.customername -- 客户名称
    ,o.chgtype -- 担保变更类型
    ,o.istfb -- 是否提放保
    ,o.businesssum -- 金额
    ,o.pigeonholedate -- 归档日期
    ,o.manageuserid -- 管户人ID
    ,o.businesstype -- 业务品种
    ,o.approvestatus -- 审批状态
    ,o.changenums -- 变更次数
    ,o.corporgid -- 法人机构编号
    ,o.updateorgid -- 更新机构
    ,o.ischangeapprove -- 是否需要授信批复变更
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
from ${iol_schema}.icms_guaranty_transform_bk o
    left join ${iol_schema}.icms_guaranty_transform_op n
        on
            o.serialno = n.serialno
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.icms_guaranty_transform_cl d
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
--truncate table ${iol_schema}.icms_guaranty_transform;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('icms_guaranty_transform') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.icms_guaranty_transform drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.icms_guaranty_transform add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.icms_guaranty_transform exchange partition p_${batch_date} with table ${iol_schema}.icms_guaranty_transform_cl;
alter table ${iol_schema}.icms_guaranty_transform exchange partition p_20991231 with table ${iol_schema}.icms_guaranty_transform_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.icms_guaranty_transform to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.icms_guaranty_transform_op purge;
drop table ${iol_schema}.icms_guaranty_transform_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.icms_guaranty_transform_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'icms_guaranty_transform',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
