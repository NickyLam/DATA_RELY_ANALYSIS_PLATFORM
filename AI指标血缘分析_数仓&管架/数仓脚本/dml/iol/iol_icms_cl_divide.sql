/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_icms_cl_divide
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
create table ${iol_schema}.icms_cl_divide_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.icms_cl_divide
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.icms_cl_divide_op purge;
drop table ${iol_schema}.icms_cl_divide_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.icms_cl_divide_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.icms_cl_divide where 0=1;

create table ${iol_schema}.icms_cl_divide_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.icms_cl_divide where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.icms_cl_divide_cl(
            serialno -- 流水号
            ,migtflag -- 迁移标志：crsrcrilcupl
            ,parentserialno -- 上层切分编号上层分配编号
            ,channel -- 渠道
            ,objectno -- 对象编号
            ,ifexclusivecredit -- 是否专属额度
            ,updatedate -- 更新日期
            ,availableexposuresum -- 可用敞口金额
            ,ownercustid -- 额度所属客户(汇总层额度存上次额度客户)
            ,objecttype -- 对象类型
            ,minbusinessrate -- 最低利率
            ,lowriskexposuresum -- 类低风险敞口金额
            ,oldobjectno -- 关联迁出方对象编号
            ,riskexposuresum -- 其中，一般风险敞口限额
            ,nominalsum -- 名义金额
            ,othercommand -- 其他要求
            ,cycleflag -- 是否循环
            ,currency -- 币种币种(默认为顶层额度币种)
            ,availablenominalsum -- 可用名义金额
            ,status -- 状态
            ,inputdate -- 登记日期
            ,divideobjecttype -- 切分对象类型CLDIVIDEOBJECTTYPE（产品、客户、机构）
            ,divideobjectno -- 切分对象编号
            ,occupynominalsum -- 已用名义金额已用名义金额(自动计算)
            ,minbailrate -- 最低保证金比例
            ,guarantytype -- 担保类型
            ,exposuresum -- 敞口金额
            ,inputuserid -- 登记人
            ,inputorgid -- 登记机构
            ,termmonth -- 期限
            ,oldobjecttype -- 关联迁出方对象类型
            ,occupyexposuresum -- 已用敞口金额已用敞口金额(自动计算)
            ,maxbusinesssum -- 最高单笔金额
            ,migtoldvalue -- 迁移数据-参数转换前字段值
            ,originserialno -- 
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.icms_cl_divide_op(
            serialno -- 流水号
            ,migtflag -- 迁移标志：crsrcrilcupl
            ,parentserialno -- 上层切分编号上层分配编号
            ,channel -- 渠道
            ,objectno -- 对象编号
            ,ifexclusivecredit -- 是否专属额度
            ,updatedate -- 更新日期
            ,availableexposuresum -- 可用敞口金额
            ,ownercustid -- 额度所属客户(汇总层额度存上次额度客户)
            ,objecttype -- 对象类型
            ,minbusinessrate -- 最低利率
            ,lowriskexposuresum -- 类低风险敞口金额
            ,oldobjectno -- 关联迁出方对象编号
            ,riskexposuresum -- 其中，一般风险敞口限额
            ,nominalsum -- 名义金额
            ,othercommand -- 其他要求
            ,cycleflag -- 是否循环
            ,currency -- 币种币种(默认为顶层额度币种)
            ,availablenominalsum -- 可用名义金额
            ,status -- 状态
            ,inputdate -- 登记日期
            ,divideobjecttype -- 切分对象类型CLDIVIDEOBJECTTYPE（产品、客户、机构）
            ,divideobjectno -- 切分对象编号
            ,occupynominalsum -- 已用名义金额已用名义金额(自动计算)
            ,minbailrate -- 最低保证金比例
            ,guarantytype -- 担保类型
            ,exposuresum -- 敞口金额
            ,inputuserid -- 登记人
            ,inputorgid -- 登记机构
            ,termmonth -- 期限
            ,oldobjecttype -- 关联迁出方对象类型
            ,occupyexposuresum -- 已用敞口金额已用敞口金额(自动计算)
            ,maxbusinesssum -- 最高单笔金额
            ,migtoldvalue -- 迁移数据-参数转换前字段值
            ,originserialno -- 
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.serialno, o.serialno) as serialno -- 流水号
    ,nvl(n.migtflag, o.migtflag) as migtflag -- 迁移标志：crsrcrilcupl
    ,nvl(n.parentserialno, o.parentserialno) as parentserialno -- 上层切分编号上层分配编号
    ,nvl(n.channel, o.channel) as channel -- 渠道
    ,nvl(n.objectno, o.objectno) as objectno -- 对象编号
    ,nvl(n.ifexclusivecredit, o.ifexclusivecredit) as ifexclusivecredit -- 是否专属额度
    ,nvl(n.updatedate, o.updatedate) as updatedate -- 更新日期
    ,nvl(n.availableexposuresum, o.availableexposuresum) as availableexposuresum -- 可用敞口金额
    ,nvl(n.ownercustid, o.ownercustid) as ownercustid -- 额度所属客户(汇总层额度存上次额度客户)
    ,nvl(n.objecttype, o.objecttype) as objecttype -- 对象类型
    ,nvl(n.minbusinessrate, o.minbusinessrate) as minbusinessrate -- 最低利率
    ,nvl(n.lowriskexposuresum, o.lowriskexposuresum) as lowriskexposuresum -- 类低风险敞口金额
    ,nvl(n.oldobjectno, o.oldobjectno) as oldobjectno -- 关联迁出方对象编号
    ,nvl(n.riskexposuresum, o.riskexposuresum) as riskexposuresum -- 其中，一般风险敞口限额
    ,nvl(n.nominalsum, o.nominalsum) as nominalsum -- 名义金额
    ,nvl(n.othercommand, o.othercommand) as othercommand -- 其他要求
    ,nvl(n.cycleflag, o.cycleflag) as cycleflag -- 是否循环
    ,nvl(n.currency, o.currency) as currency -- 币种币种(默认为顶层额度币种)
    ,nvl(n.availablenominalsum, o.availablenominalsum) as availablenominalsum -- 可用名义金额
    ,nvl(n.status, o.status) as status -- 状态
    ,nvl(n.inputdate, o.inputdate) as inputdate -- 登记日期
    ,nvl(n.divideobjecttype, o.divideobjecttype) as divideobjecttype -- 切分对象类型CLDIVIDEOBJECTTYPE（产品、客户、机构）
    ,nvl(n.divideobjectno, o.divideobjectno) as divideobjectno -- 切分对象编号
    ,nvl(n.occupynominalsum, o.occupynominalsum) as occupynominalsum -- 已用名义金额已用名义金额(自动计算)
    ,nvl(n.minbailrate, o.minbailrate) as minbailrate -- 最低保证金比例
    ,nvl(n.guarantytype, o.guarantytype) as guarantytype -- 担保类型
    ,nvl(n.exposuresum, o.exposuresum) as exposuresum -- 敞口金额
    ,nvl(n.inputuserid, o.inputuserid) as inputuserid -- 登记人
    ,nvl(n.inputorgid, o.inputorgid) as inputorgid -- 登记机构
    ,nvl(n.termmonth, o.termmonth) as termmonth -- 期限
    ,nvl(n.oldobjecttype, o.oldobjecttype) as oldobjecttype -- 关联迁出方对象类型
    ,nvl(n.occupyexposuresum, o.occupyexposuresum) as occupyexposuresum -- 已用敞口金额已用敞口金额(自动计算)
    ,nvl(n.maxbusinesssum, o.maxbusinesssum) as maxbusinesssum -- 最高单笔金额
    ,nvl(n.migtoldvalue, o.migtoldvalue) as migtoldvalue -- 迁移数据-参数转换前字段值
    ,nvl(n.originserialno, o.originserialno) as originserialno -- 
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
from (select * from ${iol_schema}.icms_cl_divide_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.icms_cl_divide where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.serialno = n.serialno
where (
        o.serialno is null
    )
    or (
        n.serialno is null
    )
    or (
        o.migtflag <> n.migtflag
        or o.parentserialno <> n.parentserialno
        or o.channel <> n.channel
        or o.objectno <> n.objectno
        or o.ifexclusivecredit <> n.ifexclusivecredit
        or o.updatedate <> n.updatedate
        or o.availableexposuresum <> n.availableexposuresum
        or o.ownercustid <> n.ownercustid
        or o.objecttype <> n.objecttype
        or o.minbusinessrate <> n.minbusinessrate
        or o.lowriskexposuresum <> n.lowriskexposuresum
        or o.oldobjectno <> n.oldobjectno
        or o.riskexposuresum <> n.riskexposuresum
        or o.nominalsum <> n.nominalsum
        or o.othercommand <> n.othercommand
        or o.cycleflag <> n.cycleflag
        or o.currency <> n.currency
        or o.availablenominalsum <> n.availablenominalsum
        or o.status <> n.status
        or o.inputdate <> n.inputdate
        or o.divideobjecttype <> n.divideobjecttype
        or o.divideobjectno <> n.divideobjectno
        or o.occupynominalsum <> n.occupynominalsum
        or o.minbailrate <> n.minbailrate
        or o.guarantytype <> n.guarantytype
        or o.exposuresum <> n.exposuresum
        or o.inputuserid <> n.inputuserid
        or o.inputorgid <> n.inputorgid
        or o.termmonth <> n.termmonth
        or o.oldobjecttype <> n.oldobjecttype
        or o.occupyexposuresum <> n.occupyexposuresum
        or o.maxbusinesssum <> n.maxbusinesssum
        or o.migtoldvalue <> n.migtoldvalue
        or o.originserialno <> n.originserialno
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.icms_cl_divide_cl(
            serialno -- 流水号
            ,migtflag -- 迁移标志：crsrcrilcupl
            ,parentserialno -- 上层切分编号上层分配编号
            ,channel -- 渠道
            ,objectno -- 对象编号
            ,ifexclusivecredit -- 是否专属额度
            ,updatedate -- 更新日期
            ,availableexposuresum -- 可用敞口金额
            ,ownercustid -- 额度所属客户(汇总层额度存上次额度客户)
            ,objecttype -- 对象类型
            ,minbusinessrate -- 最低利率
            ,lowriskexposuresum -- 类低风险敞口金额
            ,oldobjectno -- 关联迁出方对象编号
            ,riskexposuresum -- 其中，一般风险敞口限额
            ,nominalsum -- 名义金额
            ,othercommand -- 其他要求
            ,cycleflag -- 是否循环
            ,currency -- 币种币种(默认为顶层额度币种)
            ,availablenominalsum -- 可用名义金额
            ,status -- 状态
            ,inputdate -- 登记日期
            ,divideobjecttype -- 切分对象类型CLDIVIDEOBJECTTYPE（产品、客户、机构）
            ,divideobjectno -- 切分对象编号
            ,occupynominalsum -- 已用名义金额已用名义金额(自动计算)
            ,minbailrate -- 最低保证金比例
            ,guarantytype -- 担保类型
            ,exposuresum -- 敞口金额
            ,inputuserid -- 登记人
            ,inputorgid -- 登记机构
            ,termmonth -- 期限
            ,oldobjecttype -- 关联迁出方对象类型
            ,occupyexposuresum -- 已用敞口金额已用敞口金额(自动计算)
            ,maxbusinesssum -- 最高单笔金额
            ,migtoldvalue -- 迁移数据-参数转换前字段值
            ,originserialno -- 
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.icms_cl_divide_op(
            serialno -- 流水号
            ,migtflag -- 迁移标志：crsrcrilcupl
            ,parentserialno -- 上层切分编号上层分配编号
            ,channel -- 渠道
            ,objectno -- 对象编号
            ,ifexclusivecredit -- 是否专属额度
            ,updatedate -- 更新日期
            ,availableexposuresum -- 可用敞口金额
            ,ownercustid -- 额度所属客户(汇总层额度存上次额度客户)
            ,objecttype -- 对象类型
            ,minbusinessrate -- 最低利率
            ,lowriskexposuresum -- 类低风险敞口金额
            ,oldobjectno -- 关联迁出方对象编号
            ,riskexposuresum -- 其中，一般风险敞口限额
            ,nominalsum -- 名义金额
            ,othercommand -- 其他要求
            ,cycleflag -- 是否循环
            ,currency -- 币种币种(默认为顶层额度币种)
            ,availablenominalsum -- 可用名义金额
            ,status -- 状态
            ,inputdate -- 登记日期
            ,divideobjecttype -- 切分对象类型CLDIVIDEOBJECTTYPE（产品、客户、机构）
            ,divideobjectno -- 切分对象编号
            ,occupynominalsum -- 已用名义金额已用名义金额(自动计算)
            ,minbailrate -- 最低保证金比例
            ,guarantytype -- 担保类型
            ,exposuresum -- 敞口金额
            ,inputuserid -- 登记人
            ,inputorgid -- 登记机构
            ,termmonth -- 期限
            ,oldobjecttype -- 关联迁出方对象类型
            ,occupyexposuresum -- 已用敞口金额已用敞口金额(自动计算)
            ,maxbusinesssum -- 最高单笔金额
            ,migtoldvalue -- 迁移数据-参数转换前字段值
            ,originserialno -- 
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.serialno -- 流水号
    ,o.migtflag -- 迁移标志：crsrcrilcupl
    ,o.parentserialno -- 上层切分编号上层分配编号
    ,o.channel -- 渠道
    ,o.objectno -- 对象编号
    ,o.ifexclusivecredit -- 是否专属额度
    ,o.updatedate -- 更新日期
    ,o.availableexposuresum -- 可用敞口金额
    ,o.ownercustid -- 额度所属客户(汇总层额度存上次额度客户)
    ,o.objecttype -- 对象类型
    ,o.minbusinessrate -- 最低利率
    ,o.lowriskexposuresum -- 类低风险敞口金额
    ,o.oldobjectno -- 关联迁出方对象编号
    ,o.riskexposuresum -- 其中，一般风险敞口限额
    ,o.nominalsum -- 名义金额
    ,o.othercommand -- 其他要求
    ,o.cycleflag -- 是否循环
    ,o.currency -- 币种币种(默认为顶层额度币种)
    ,o.availablenominalsum -- 可用名义金额
    ,o.status -- 状态
    ,o.inputdate -- 登记日期
    ,o.divideobjecttype -- 切分对象类型CLDIVIDEOBJECTTYPE（产品、客户、机构）
    ,o.divideobjectno -- 切分对象编号
    ,o.occupynominalsum -- 已用名义金额已用名义金额(自动计算)
    ,o.minbailrate -- 最低保证金比例
    ,o.guarantytype -- 担保类型
    ,o.exposuresum -- 敞口金额
    ,o.inputuserid -- 登记人
    ,o.inputorgid -- 登记机构
    ,o.termmonth -- 期限
    ,o.oldobjecttype -- 关联迁出方对象类型
    ,o.occupyexposuresum -- 已用敞口金额已用敞口金额(自动计算)
    ,o.maxbusinesssum -- 最高单笔金额
    ,o.migtoldvalue -- 迁移数据-参数转换前字段值
    ,o.originserialno -- 
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
from ${iol_schema}.icms_cl_divide_bk o
    left join ${iol_schema}.icms_cl_divide_op n
        on
            o.serialno = n.serialno
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.icms_cl_divide_cl d
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
--truncate table ${iol_schema}.icms_cl_divide;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('icms_cl_divide') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.icms_cl_divide drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.icms_cl_divide add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.icms_cl_divide exchange partition p_${batch_date} with table ${iol_schema}.icms_cl_divide_cl;
alter table ${iol_schema}.icms_cl_divide exchange partition p_20991231 with table ${iol_schema}.icms_cl_divide_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.icms_cl_divide to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.icms_cl_divide_op purge;
drop table ${iol_schema}.icms_cl_divide_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.icms_cl_divide_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'icms_cl_divide',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
