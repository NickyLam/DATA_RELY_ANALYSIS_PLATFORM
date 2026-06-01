/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_icms_classify_adjust
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
create table ${iol_schema}.icms_classify_adjust_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.icms_classify_adjust
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.icms_classify_adjust_op purge;
drop table ${iol_schema}.icms_classify_adjust_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.icms_classify_adjust_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.icms_classify_adjust where 0=1;

create table ${iol_schema}.icms_classify_adjust_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.icms_classify_adjust where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.icms_classify_adjust_cl(
            serialno -- 流水号
            ,objecttype -- 对象类型对象类型(合同/借据)
            ,productid -- 业务品种
            ,adjustdate -- 调整申请日期
            ,adjustapplyer -- 调整申请人
            ,customername -- 客户名称
            ,adjustorgid -- 调整申请机构
            ,approvestatus -- 审批状态
            ,operatedate -- 经办日期
            ,inputdate -- 登记日期
            ,adjusttype -- 调整类型调整类型(分类结果调整/分类方式调整)
            ,belongdept -- 所属条线
            ,inputuserid -- 登记人
            ,updatedate -- 更新日期
            ,corporgid -- 法人机构编号
            ,objectno -- 对象编号借据编号（借据编号/合同编号）
            ,operateorgid -- 经办机构
            ,customerid -- 客户编号
            ,adjustreason -- 分类调整原因
            ,updateorgid -- 更新机构
            ,migtflag -- 迁移标志：crsrcrilcupl
            ,adjustclassifyresult -- 调整分类结果
            ,currclassifytype -- 当前分类方式
            ,updateuserid -- 更新人
            ,adjustfinishdate -- 认定完成时间
            ,accountmonth -- 期次
            ,inputorgid -- 登记机构
            ,relativeserialno -- 原分类编号
            ,operateuserid -- 经办人
            ,currclassifyresult -- 当前分类结果
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.icms_classify_adjust_op(
            serialno -- 流水号
            ,objecttype -- 对象类型对象类型(合同/借据)
            ,productid -- 业务品种
            ,adjustdate -- 调整申请日期
            ,adjustapplyer -- 调整申请人
            ,customername -- 客户名称
            ,adjustorgid -- 调整申请机构
            ,approvestatus -- 审批状态
            ,operatedate -- 经办日期
            ,inputdate -- 登记日期
            ,adjusttype -- 调整类型调整类型(分类结果调整/分类方式调整)
            ,belongdept -- 所属条线
            ,inputuserid -- 登记人
            ,updatedate -- 更新日期
            ,corporgid -- 法人机构编号
            ,objectno -- 对象编号借据编号（借据编号/合同编号）
            ,operateorgid -- 经办机构
            ,customerid -- 客户编号
            ,adjustreason -- 分类调整原因
            ,updateorgid -- 更新机构
            ,migtflag -- 迁移标志：crsrcrilcupl
            ,adjustclassifyresult -- 调整分类结果
            ,currclassifytype -- 当前分类方式
            ,updateuserid -- 更新人
            ,adjustfinishdate -- 认定完成时间
            ,accountmonth -- 期次
            ,inputorgid -- 登记机构
            ,relativeserialno -- 原分类编号
            ,operateuserid -- 经办人
            ,currclassifyresult -- 当前分类结果
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.serialno, o.serialno) as serialno -- 流水号
    ,nvl(n.objecttype, o.objecttype) as objecttype -- 对象类型对象类型(合同/借据)
    ,nvl(n.productid, o.productid) as productid -- 业务品种
    ,nvl(n.adjustdate, o.adjustdate) as adjustdate -- 调整申请日期
    ,nvl(n.adjustapplyer, o.adjustapplyer) as adjustapplyer -- 调整申请人
    ,nvl(n.customername, o.customername) as customername -- 客户名称
    ,nvl(n.adjustorgid, o.adjustorgid) as adjustorgid -- 调整申请机构
    ,nvl(n.approvestatus, o.approvestatus) as approvestatus -- 审批状态
    ,nvl(n.operatedate, o.operatedate) as operatedate -- 经办日期
    ,nvl(n.inputdate, o.inputdate) as inputdate -- 登记日期
    ,nvl(n.adjusttype, o.adjusttype) as adjusttype -- 调整类型调整类型(分类结果调整/分类方式调整)
    ,nvl(n.belongdept, o.belongdept) as belongdept -- 所属条线
    ,nvl(n.inputuserid, o.inputuserid) as inputuserid -- 登记人
    ,nvl(n.updatedate, o.updatedate) as updatedate -- 更新日期
    ,nvl(n.corporgid, o.corporgid) as corporgid -- 法人机构编号
    ,nvl(n.objectno, o.objectno) as objectno -- 对象编号借据编号（借据编号/合同编号）
    ,nvl(n.operateorgid, o.operateorgid) as operateorgid -- 经办机构
    ,nvl(n.customerid, o.customerid) as customerid -- 客户编号
    ,nvl(n.adjustreason, o.adjustreason) as adjustreason -- 分类调整原因
    ,nvl(n.updateorgid, o.updateorgid) as updateorgid -- 更新机构
    ,nvl(n.migtflag, o.migtflag) as migtflag -- 迁移标志：crsrcrilcupl
    ,nvl(n.adjustclassifyresult, o.adjustclassifyresult) as adjustclassifyresult -- 调整分类结果
    ,nvl(n.currclassifytype, o.currclassifytype) as currclassifytype -- 当前分类方式
    ,nvl(n.updateuserid, o.updateuserid) as updateuserid -- 更新人
    ,nvl(n.adjustfinishdate, o.adjustfinishdate) as adjustfinishdate -- 认定完成时间
    ,nvl(n.accountmonth, o.accountmonth) as accountmonth -- 期次
    ,nvl(n.inputorgid, o.inputorgid) as inputorgid -- 登记机构
    ,nvl(n.relativeserialno, o.relativeserialno) as relativeserialno -- 原分类编号
    ,nvl(n.operateuserid, o.operateuserid) as operateuserid -- 经办人
    ,nvl(n.currclassifyresult, o.currclassifyresult) as currclassifyresult -- 当前分类结果
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
from (select * from ${iol_schema}.icms_classify_adjust_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.icms_classify_adjust where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.serialno = n.serialno
where (
        o.serialno is null
    )
    or (
        n.serialno is null
    )
    or (
        o.objecttype <> n.objecttype
        or o.productid <> n.productid
        or o.adjustdate <> n.adjustdate
        or o.adjustapplyer <> n.adjustapplyer
        or o.customername <> n.customername
        or o.adjustorgid <> n.adjustorgid
        or o.approvestatus <> n.approvestatus
        or o.operatedate <> n.operatedate
        or o.inputdate <> n.inputdate
        or o.adjusttype <> n.adjusttype
        or o.belongdept <> n.belongdept
        or o.inputuserid <> n.inputuserid
        or o.updatedate <> n.updatedate
        or o.corporgid <> n.corporgid
        or o.objectno <> n.objectno
        or o.operateorgid <> n.operateorgid
        or o.customerid <> n.customerid
        or o.adjustreason <> n.adjustreason
        or o.updateorgid <> n.updateorgid
        or o.migtflag <> n.migtflag
        or o.adjustclassifyresult <> n.adjustclassifyresult
        or o.currclassifytype <> n.currclassifytype
        or o.updateuserid <> n.updateuserid
        or o.adjustfinishdate <> n.adjustfinishdate
        or o.accountmonth <> n.accountmonth
        or o.inputorgid <> n.inputorgid
        or o.relativeserialno <> n.relativeserialno
        or o.operateuserid <> n.operateuserid
        or o.currclassifyresult <> n.currclassifyresult
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.icms_classify_adjust_cl(
            serialno -- 流水号
            ,objecttype -- 对象类型对象类型(合同/借据)
            ,productid -- 业务品种
            ,adjustdate -- 调整申请日期
            ,adjustapplyer -- 调整申请人
            ,customername -- 客户名称
            ,adjustorgid -- 调整申请机构
            ,approvestatus -- 审批状态
            ,operatedate -- 经办日期
            ,inputdate -- 登记日期
            ,adjusttype -- 调整类型调整类型(分类结果调整/分类方式调整)
            ,belongdept -- 所属条线
            ,inputuserid -- 登记人
            ,updatedate -- 更新日期
            ,corporgid -- 法人机构编号
            ,objectno -- 对象编号借据编号（借据编号/合同编号）
            ,operateorgid -- 经办机构
            ,customerid -- 客户编号
            ,adjustreason -- 分类调整原因
            ,updateorgid -- 更新机构
            ,migtflag -- 迁移标志：crsrcrilcupl
            ,adjustclassifyresult -- 调整分类结果
            ,currclassifytype -- 当前分类方式
            ,updateuserid -- 更新人
            ,adjustfinishdate -- 认定完成时间
            ,accountmonth -- 期次
            ,inputorgid -- 登记机构
            ,relativeserialno -- 原分类编号
            ,operateuserid -- 经办人
            ,currclassifyresult -- 当前分类结果
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.icms_classify_adjust_op(
            serialno -- 流水号
            ,objecttype -- 对象类型对象类型(合同/借据)
            ,productid -- 业务品种
            ,adjustdate -- 调整申请日期
            ,adjustapplyer -- 调整申请人
            ,customername -- 客户名称
            ,adjustorgid -- 调整申请机构
            ,approvestatus -- 审批状态
            ,operatedate -- 经办日期
            ,inputdate -- 登记日期
            ,adjusttype -- 调整类型调整类型(分类结果调整/分类方式调整)
            ,belongdept -- 所属条线
            ,inputuserid -- 登记人
            ,updatedate -- 更新日期
            ,corporgid -- 法人机构编号
            ,objectno -- 对象编号借据编号（借据编号/合同编号）
            ,operateorgid -- 经办机构
            ,customerid -- 客户编号
            ,adjustreason -- 分类调整原因
            ,updateorgid -- 更新机构
            ,migtflag -- 迁移标志：crsrcrilcupl
            ,adjustclassifyresult -- 调整分类结果
            ,currclassifytype -- 当前分类方式
            ,updateuserid -- 更新人
            ,adjustfinishdate -- 认定完成时间
            ,accountmonth -- 期次
            ,inputorgid -- 登记机构
            ,relativeserialno -- 原分类编号
            ,operateuserid -- 经办人
            ,currclassifyresult -- 当前分类结果
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.serialno -- 流水号
    ,o.objecttype -- 对象类型对象类型(合同/借据)
    ,o.productid -- 业务品种
    ,o.adjustdate -- 调整申请日期
    ,o.adjustapplyer -- 调整申请人
    ,o.customername -- 客户名称
    ,o.adjustorgid -- 调整申请机构
    ,o.approvestatus -- 审批状态
    ,o.operatedate -- 经办日期
    ,o.inputdate -- 登记日期
    ,o.adjusttype -- 调整类型调整类型(分类结果调整/分类方式调整)
    ,o.belongdept -- 所属条线
    ,o.inputuserid -- 登记人
    ,o.updatedate -- 更新日期
    ,o.corporgid -- 法人机构编号
    ,o.objectno -- 对象编号借据编号（借据编号/合同编号）
    ,o.operateorgid -- 经办机构
    ,o.customerid -- 客户编号
    ,o.adjustreason -- 分类调整原因
    ,o.updateorgid -- 更新机构
    ,o.migtflag -- 迁移标志：crsrcrilcupl
    ,o.adjustclassifyresult -- 调整分类结果
    ,o.currclassifytype -- 当前分类方式
    ,o.updateuserid -- 更新人
    ,o.adjustfinishdate -- 认定完成时间
    ,o.accountmonth -- 期次
    ,o.inputorgid -- 登记机构
    ,o.relativeserialno -- 原分类编号
    ,o.operateuserid -- 经办人
    ,o.currclassifyresult -- 当前分类结果
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
from ${iol_schema}.icms_classify_adjust_bk o
    left join ${iol_schema}.icms_classify_adjust_op n
        on
            o.serialno = n.serialno
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.icms_classify_adjust_cl d
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
--truncate table ${iol_schema}.icms_classify_adjust;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('icms_classify_adjust') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.icms_classify_adjust drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.icms_classify_adjust add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.icms_classify_adjust exchange partition p_${batch_date} with table ${iol_schema}.icms_classify_adjust_cl;
alter table ${iol_schema}.icms_classify_adjust exchange partition p_20991231 with table ${iol_schema}.icms_classify_adjust_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.icms_classify_adjust to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.icms_classify_adjust_op purge;
drop table ${iol_schema}.icms_classify_adjust_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.icms_classify_adjust_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'icms_classify_adjust',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
