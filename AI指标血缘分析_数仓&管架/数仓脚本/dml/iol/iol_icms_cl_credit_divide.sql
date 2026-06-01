/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_icms_cl_credit_divide
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
create table ${iol_schema}.icms_cl_credit_divide_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.icms_cl_credit_divide
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.icms_cl_credit_divide_op purge;
drop table ${iol_schema}.icms_cl_credit_divide_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.icms_cl_credit_divide_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.icms_cl_credit_divide where 0=1;

create table ${iol_schema}.icms_cl_credit_divide_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.icms_cl_credit_divide where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.icms_cl_credit_divide_cl(
            inputuserid -- 登记人
            ,ifexclusivecredit -- 是否专属
            ,dividetype -- 切分类型:机构/产品/客户
            ,nominalamount -- 切分名义金额
            ,occupynominalamount -- 占用名义金额
            ,availableriskexposuresum -- 一般风险可用敞口金额
            ,updateorgid -- 更新机构
            ,objectname -- 切分对象的名称
            ,updatedate -- 更新日期
            ,availablenominalsum -- 可用名义金额
            ,recyclable -- 可循环标志
            ,occupyexposureamount -- 占用敞口金额
            ,lowriskexposuresum -- 类低风险敞口金额
            ,parentdivideno -- 上层控制编号
            ,inputorgid -- 登记机构
            ,divideno -- 控制编号
            ,creditno -- 额度系统业务编号
            ,updateuserid -- 更新人
            ,availableexposuresum -- 可用敞口金额
            ,objectno -- 切分对象的编号
            ,riskexposuresum -- 一般敞口金额
            ,availablelowriskexposuresum -- 类低风险可用敞口金额
            ,dividecurrency -- 切分币种
            ,exposureamount -- 切分敞口金额
            ,inputdate -- 登记日期
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.icms_cl_credit_divide_op(
            inputuserid -- 登记人
            ,ifexclusivecredit -- 是否专属
            ,dividetype -- 切分类型:机构/产品/客户
            ,nominalamount -- 切分名义金额
            ,occupynominalamount -- 占用名义金额
            ,availableriskexposuresum -- 一般风险可用敞口金额
            ,updateorgid -- 更新机构
            ,objectname -- 切分对象的名称
            ,updatedate -- 更新日期
            ,availablenominalsum -- 可用名义金额
            ,recyclable -- 可循环标志
            ,occupyexposureamount -- 占用敞口金额
            ,lowriskexposuresum -- 类低风险敞口金额
            ,parentdivideno -- 上层控制编号
            ,inputorgid -- 登记机构
            ,divideno -- 控制编号
            ,creditno -- 额度系统业务编号
            ,updateuserid -- 更新人
            ,availableexposuresum -- 可用敞口金额
            ,objectno -- 切分对象的编号
            ,riskexposuresum -- 一般敞口金额
            ,availablelowriskexposuresum -- 类低风险可用敞口金额
            ,dividecurrency -- 切分币种
            ,exposureamount -- 切分敞口金额
            ,inputdate -- 登记日期
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.inputuserid, o.inputuserid) as inputuserid -- 登记人
    ,nvl(n.ifexclusivecredit, o.ifexclusivecredit) as ifexclusivecredit -- 是否专属
    ,nvl(n.dividetype, o.dividetype) as dividetype -- 切分类型:机构/产品/客户
    ,nvl(n.nominalamount, o.nominalamount) as nominalamount -- 切分名义金额
    ,nvl(n.occupynominalamount, o.occupynominalamount) as occupynominalamount -- 占用名义金额
    ,nvl(n.availableriskexposuresum, o.availableriskexposuresum) as availableriskexposuresum -- 一般风险可用敞口金额
    ,nvl(n.updateorgid, o.updateorgid) as updateorgid -- 更新机构
    ,nvl(n.objectname, o.objectname) as objectname -- 切分对象的名称
    ,nvl(n.updatedate, o.updatedate) as updatedate -- 更新日期
    ,nvl(n.availablenominalsum, o.availablenominalsum) as availablenominalsum -- 可用名义金额
    ,nvl(n.recyclable, o.recyclable) as recyclable -- 可循环标志
    ,nvl(n.occupyexposureamount, o.occupyexposureamount) as occupyexposureamount -- 占用敞口金额
    ,nvl(n.lowriskexposuresum, o.lowriskexposuresum) as lowriskexposuresum -- 类低风险敞口金额
    ,nvl(n.parentdivideno, o.parentdivideno) as parentdivideno -- 上层控制编号
    ,nvl(n.inputorgid, o.inputorgid) as inputorgid -- 登记机构
    ,nvl(n.divideno, o.divideno) as divideno -- 控制编号
    ,nvl(n.creditno, o.creditno) as creditno -- 额度系统业务编号
    ,nvl(n.updateuserid, o.updateuserid) as updateuserid -- 更新人
    ,nvl(n.availableexposuresum, o.availableexposuresum) as availableexposuresum -- 可用敞口金额
    ,nvl(n.objectno, o.objectno) as objectno -- 切分对象的编号
    ,nvl(n.riskexposuresum, o.riskexposuresum) as riskexposuresum -- 一般敞口金额
    ,nvl(n.availablelowriskexposuresum, o.availablelowriskexposuresum) as availablelowriskexposuresum -- 类低风险可用敞口金额
    ,nvl(n.dividecurrency, o.dividecurrency) as dividecurrency -- 切分币种
    ,nvl(n.exposureamount, o.exposureamount) as exposureamount -- 切分敞口金额
    ,nvl(n.inputdate, o.inputdate) as inputdate -- 登记日期
    ,case when
            n.divideno is null
            and n.creditno is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.divideno is null
            and n.creditno is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.divideno is null
            and n.creditno is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.icms_cl_credit_divide_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.icms_cl_credit_divide where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.divideno = n.divideno
            and o.creditno = n.creditno
where (
        o.divideno is null
        and o.creditno is null
    )
    or (
        n.divideno is null
        and n.creditno is null
    )
    or (
        o.inputuserid <> n.inputuserid
        or o.ifexclusivecredit <> n.ifexclusivecredit
        or o.dividetype <> n.dividetype
        or o.nominalamount <> n.nominalamount
        or o.occupynominalamount <> n.occupynominalamount
        or o.availableriskexposuresum <> n.availableriskexposuresum
        or o.updateorgid <> n.updateorgid
        or o.objectname <> n.objectname
        or o.updatedate <> n.updatedate
        or o.availablenominalsum <> n.availablenominalsum
        or o.recyclable <> n.recyclable
        or o.occupyexposureamount <> n.occupyexposureamount
        or o.lowriskexposuresum <> n.lowriskexposuresum
        or o.parentdivideno <> n.parentdivideno
        or o.inputorgid <> n.inputorgid
        or o.updateuserid <> n.updateuserid
        or o.availableexposuresum <> n.availableexposuresum
        or o.objectno <> n.objectno
        or o.riskexposuresum <> n.riskexposuresum
        or o.availablelowriskexposuresum <> n.availablelowriskexposuresum
        or o.dividecurrency <> n.dividecurrency
        or o.exposureamount <> n.exposureamount
        or o.inputdate <> n.inputdate
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.icms_cl_credit_divide_cl(
            inputuserid -- 登记人
            ,ifexclusivecredit -- 是否专属
            ,dividetype -- 切分类型:机构/产品/客户
            ,nominalamount -- 切分名义金额
            ,occupynominalamount -- 占用名义金额
            ,availableriskexposuresum -- 一般风险可用敞口金额
            ,updateorgid -- 更新机构
            ,objectname -- 切分对象的名称
            ,updatedate -- 更新日期
            ,availablenominalsum -- 可用名义金额
            ,recyclable -- 可循环标志
            ,occupyexposureamount -- 占用敞口金额
            ,lowriskexposuresum -- 类低风险敞口金额
            ,parentdivideno -- 上层控制编号
            ,inputorgid -- 登记机构
            ,divideno -- 控制编号
            ,creditno -- 额度系统业务编号
            ,updateuserid -- 更新人
            ,availableexposuresum -- 可用敞口金额
            ,objectno -- 切分对象的编号
            ,riskexposuresum -- 一般敞口金额
            ,availablelowriskexposuresum -- 类低风险可用敞口金额
            ,dividecurrency -- 切分币种
            ,exposureamount -- 切分敞口金额
            ,inputdate -- 登记日期
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.icms_cl_credit_divide_op(
            inputuserid -- 登记人
            ,ifexclusivecredit -- 是否专属
            ,dividetype -- 切分类型:机构/产品/客户
            ,nominalamount -- 切分名义金额
            ,occupynominalamount -- 占用名义金额
            ,availableriskexposuresum -- 一般风险可用敞口金额
            ,updateorgid -- 更新机构
            ,objectname -- 切分对象的名称
            ,updatedate -- 更新日期
            ,availablenominalsum -- 可用名义金额
            ,recyclable -- 可循环标志
            ,occupyexposureamount -- 占用敞口金额
            ,lowriskexposuresum -- 类低风险敞口金额
            ,parentdivideno -- 上层控制编号
            ,inputorgid -- 登记机构
            ,divideno -- 控制编号
            ,creditno -- 额度系统业务编号
            ,updateuserid -- 更新人
            ,availableexposuresum -- 可用敞口金额
            ,objectno -- 切分对象的编号
            ,riskexposuresum -- 一般敞口金额
            ,availablelowriskexposuresum -- 类低风险可用敞口金额
            ,dividecurrency -- 切分币种
            ,exposureamount -- 切分敞口金额
            ,inputdate -- 登记日期
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.inputuserid -- 登记人
    ,o.ifexclusivecredit -- 是否专属
    ,o.dividetype -- 切分类型:机构/产品/客户
    ,o.nominalamount -- 切分名义金额
    ,o.occupynominalamount -- 占用名义金额
    ,o.availableriskexposuresum -- 一般风险可用敞口金额
    ,o.updateorgid -- 更新机构
    ,o.objectname -- 切分对象的名称
    ,o.updatedate -- 更新日期
    ,o.availablenominalsum -- 可用名义金额
    ,o.recyclable -- 可循环标志
    ,o.occupyexposureamount -- 占用敞口金额
    ,o.lowriskexposuresum -- 类低风险敞口金额
    ,o.parentdivideno -- 上层控制编号
    ,o.inputorgid -- 登记机构
    ,o.divideno -- 控制编号
    ,o.creditno -- 额度系统业务编号
    ,o.updateuserid -- 更新人
    ,o.availableexposuresum -- 可用敞口金额
    ,o.objectno -- 切分对象的编号
    ,o.riskexposuresum -- 一般敞口金额
    ,o.availablelowriskexposuresum -- 类低风险可用敞口金额
    ,o.dividecurrency -- 切分币种
    ,o.exposureamount -- 切分敞口金额
    ,o.inputdate -- 登记日期
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
from ${iol_schema}.icms_cl_credit_divide_bk o
    left join ${iol_schema}.icms_cl_credit_divide_op n
        on
            o.divideno = n.divideno
            and o.creditno = n.creditno
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.icms_cl_credit_divide_cl d
        on
            o.divideno = d.divideno
            and o.creditno = d.creditno
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
--truncate table ${iol_schema}.icms_cl_credit_divide;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('icms_cl_credit_divide') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.icms_cl_credit_divide drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.icms_cl_credit_divide add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.icms_cl_credit_divide exchange partition p_${batch_date} with table ${iol_schema}.icms_cl_credit_divide_cl;
alter table ${iol_schema}.icms_cl_credit_divide exchange partition p_20991231 with table ${iol_schema}.icms_cl_credit_divide_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.icms_cl_credit_divide to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.icms_cl_credit_divide_op purge;
drop table ${iol_schema}.icms_cl_credit_divide_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.icms_cl_credit_divide_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'icms_cl_credit_divide',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
