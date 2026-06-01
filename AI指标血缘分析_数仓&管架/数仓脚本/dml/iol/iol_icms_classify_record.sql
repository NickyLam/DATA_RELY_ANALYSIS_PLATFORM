/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_icms_classify_record
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
create table ${iol_schema}.icms_classify_record_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.icms_classify_record
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.icms_classify_record_op purge;
drop table ${iol_schema}.icms_classify_record_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.icms_classify_record_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.icms_classify_record where 0=1;

create table ${iol_schema}.icms_classify_record_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.icms_classify_record where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.icms_classify_record_cl(
            serialno -- 流水号
            ,remark -- 备注
            ,relativeserialno -- 关联结果编号关联分类结果编号
            ,objectno -- 对象编号借据编号（借据编号/合同编号）
            ,accountmonth -- 期次
            ,islowrisk -- 是否低风险
            ,inputorgid -- 登记机构
            ,corporgid -- 法人机构编号
            ,oldserialno -- 旧信贷流水号
            ,manuclassifyresult -- 人工分类结果
            ,finalresult -- 最终结果
            ,customerid -- 客户编号
            ,balance -- 贷款余额
            ,classifystatus -- 分类状态
            ,operatedate -- 经办日期
            ,inputuserid -- 登记人
            ,firstresult -- 第一次分类结果
            ,objecttype -- 对象类型对象类型(合同/借据)
            ,updatedate -- 更新日期
            ,secondresult -- 第二次分类结果
            ,classifytype -- 分类方式分类方式(系统分类/人工分类)
            ,updateuserid -- 更新人
            ,finishdate2 -- FINISHDATE2
            ,contractserialno -- 合同号
            ,customername -- 客户名称
            ,currency -- 币种
            ,operateorgid -- 经办机构
            ,sysclassifyresult -- 系统分类结果
            ,manuclassifyreason -- 人工分类理由
            ,belongdept -- 所属条线
            ,reportperiod -- 财报周期
            ,isthismonthoccur -- 是否当月发生
            ,finishdate -- 分类完成日期
            ,termmonth -- 贷款期限
            ,finishdate5 -- FINISHDATE5
            ,migtflag -- 迁移标志：crsrcrilcupl
            ,productid -- 业务品种
            ,classifylevel -- 认定级别
            ,reportaccountmonth -- 财报会计月财报会计月
            ,inputdate -- 登记日期
            ,lastresult -- 上次分类结果
            ,businesssum -- 贷款金额
            ,operateuserid -- 经办人
            ,updateorgid -- 更新机构
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.icms_classify_record_op(
            serialno -- 流水号
            ,remark -- 备注
            ,relativeserialno -- 关联结果编号关联分类结果编号
            ,objectno -- 对象编号借据编号（借据编号/合同编号）
            ,accountmonth -- 期次
            ,islowrisk -- 是否低风险
            ,inputorgid -- 登记机构
            ,corporgid -- 法人机构编号
            ,oldserialno -- 旧信贷流水号
            ,manuclassifyresult -- 人工分类结果
            ,finalresult -- 最终结果
            ,customerid -- 客户编号
            ,balance -- 贷款余额
            ,classifystatus -- 分类状态
            ,operatedate -- 经办日期
            ,inputuserid -- 登记人
            ,firstresult -- 第一次分类结果
            ,objecttype -- 对象类型对象类型(合同/借据)
            ,updatedate -- 更新日期
            ,secondresult -- 第二次分类结果
            ,classifytype -- 分类方式分类方式(系统分类/人工分类)
            ,updateuserid -- 更新人
            ,finishdate2 -- FINISHDATE2
            ,contractserialno -- 合同号
            ,customername -- 客户名称
            ,currency -- 币种
            ,operateorgid -- 经办机构
            ,sysclassifyresult -- 系统分类结果
            ,manuclassifyreason -- 人工分类理由
            ,belongdept -- 所属条线
            ,reportperiod -- 财报周期
            ,isthismonthoccur -- 是否当月发生
            ,finishdate -- 分类完成日期
            ,termmonth -- 贷款期限
            ,finishdate5 -- FINISHDATE5
            ,migtflag -- 迁移标志：crsrcrilcupl
            ,productid -- 业务品种
            ,classifylevel -- 认定级别
            ,reportaccountmonth -- 财报会计月财报会计月
            ,inputdate -- 登记日期
            ,lastresult -- 上次分类结果
            ,businesssum -- 贷款金额
            ,operateuserid -- 经办人
            ,updateorgid -- 更新机构
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.serialno, o.serialno) as serialno -- 流水号
    ,nvl(n.remark, o.remark) as remark -- 备注
    ,nvl(n.relativeserialno, o.relativeserialno) as relativeserialno -- 关联结果编号关联分类结果编号
    ,nvl(n.objectno, o.objectno) as objectno -- 对象编号借据编号（借据编号/合同编号）
    ,nvl(n.accountmonth, o.accountmonth) as accountmonth -- 期次
    ,nvl(n.islowrisk, o.islowrisk) as islowrisk -- 是否低风险
    ,nvl(n.inputorgid, o.inputorgid) as inputorgid -- 登记机构
    ,nvl(n.corporgid, o.corporgid) as corporgid -- 法人机构编号
    ,nvl(n.oldserialno, o.oldserialno) as oldserialno -- 旧信贷流水号
    ,nvl(n.manuclassifyresult, o.manuclassifyresult) as manuclassifyresult -- 人工分类结果
    ,nvl(n.finalresult, o.finalresult) as finalresult -- 最终结果
    ,nvl(n.customerid, o.customerid) as customerid -- 客户编号
    ,nvl(n.balance, o.balance) as balance -- 贷款余额
    ,nvl(n.classifystatus, o.classifystatus) as classifystatus -- 分类状态
    ,nvl(n.operatedate, o.operatedate) as operatedate -- 经办日期
    ,nvl(n.inputuserid, o.inputuserid) as inputuserid -- 登记人
    ,nvl(n.firstresult, o.firstresult) as firstresult -- 第一次分类结果
    ,nvl(n.objecttype, o.objecttype) as objecttype -- 对象类型对象类型(合同/借据)
    ,nvl(n.updatedate, o.updatedate) as updatedate -- 更新日期
    ,nvl(n.secondresult, o.secondresult) as secondresult -- 第二次分类结果
    ,nvl(n.classifytype, o.classifytype) as classifytype -- 分类方式分类方式(系统分类/人工分类)
    ,nvl(n.updateuserid, o.updateuserid) as updateuserid -- 更新人
    ,nvl(n.finishdate2, o.finishdate2) as finishdate2 -- FINISHDATE2
    ,nvl(n.contractserialno, o.contractserialno) as contractserialno -- 合同号
    ,nvl(n.customername, o.customername) as customername -- 客户名称
    ,nvl(n.currency, o.currency) as currency -- 币种
    ,nvl(n.operateorgid, o.operateorgid) as operateorgid -- 经办机构
    ,nvl(n.sysclassifyresult, o.sysclassifyresult) as sysclassifyresult -- 系统分类结果
    ,nvl(n.manuclassifyreason, o.manuclassifyreason) as manuclassifyreason -- 人工分类理由
    ,nvl(n.belongdept, o.belongdept) as belongdept -- 所属条线
    ,nvl(n.reportperiod, o.reportperiod) as reportperiod -- 财报周期
    ,nvl(n.isthismonthoccur, o.isthismonthoccur) as isthismonthoccur -- 是否当月发生
    ,nvl(n.finishdate, o.finishdate) as finishdate -- 分类完成日期
    ,nvl(n.termmonth, o.termmonth) as termmonth -- 贷款期限
    ,nvl(n.finishdate5, o.finishdate5) as finishdate5 -- FINISHDATE5
    ,nvl(n.migtflag, o.migtflag) as migtflag -- 迁移标志：crsrcrilcupl
    ,nvl(n.productid, o.productid) as productid -- 业务品种
    ,nvl(n.classifylevel, o.classifylevel) as classifylevel -- 认定级别
    ,nvl(n.reportaccountmonth, o.reportaccountmonth) as reportaccountmonth -- 财报会计月财报会计月
    ,nvl(n.inputdate, o.inputdate) as inputdate -- 登记日期
    ,nvl(n.lastresult, o.lastresult) as lastresult -- 上次分类结果
    ,nvl(n.businesssum, o.businesssum) as businesssum -- 贷款金额
    ,nvl(n.operateuserid, o.operateuserid) as operateuserid -- 经办人
    ,nvl(n.updateorgid, o.updateorgid) as updateorgid -- 更新机构
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
from (select * from ${iol_schema}.icms_classify_record_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.icms_classify_record where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.serialno = n.serialno
where (
        o.serialno is null
    )
    or (
        n.serialno is null
    )
    or (
        o.remark <> n.remark
        or o.relativeserialno <> n.relativeserialno
        or o.objectno <> n.objectno
        or o.accountmonth <> n.accountmonth
        or o.islowrisk <> n.islowrisk
        or o.inputorgid <> n.inputorgid
        or o.corporgid <> n.corporgid
        or o.oldserialno <> n.oldserialno
        or o.manuclassifyresult <> n.manuclassifyresult
        or o.finalresult <> n.finalresult
        or o.customerid <> n.customerid
        or o.balance <> n.balance
        or o.classifystatus <> n.classifystatus
        or o.operatedate <> n.operatedate
        or o.inputuserid <> n.inputuserid
        or o.firstresult <> n.firstresult
        or o.objecttype <> n.objecttype
        or o.updatedate <> n.updatedate
        or o.secondresult <> n.secondresult
        or o.classifytype <> n.classifytype
        or o.updateuserid <> n.updateuserid
        or o.finishdate2 <> n.finishdate2
        or o.contractserialno <> n.contractserialno
        or o.customername <> n.customername
        or o.currency <> n.currency
        or o.operateorgid <> n.operateorgid
        or o.sysclassifyresult <> n.sysclassifyresult
        or o.manuclassifyreason <> n.manuclassifyreason
        or o.belongdept <> n.belongdept
        or o.reportperiod <> n.reportperiod
        or o.isthismonthoccur <> n.isthismonthoccur
        or o.finishdate <> n.finishdate
        or o.termmonth <> n.termmonth
        or o.finishdate5 <> n.finishdate5
        or o.migtflag <> n.migtflag
        or o.productid <> n.productid
        or o.classifylevel <> n.classifylevel
        or o.reportaccountmonth <> n.reportaccountmonth
        or o.inputdate <> n.inputdate
        or o.lastresult <> n.lastresult
        or o.businesssum <> n.businesssum
        or o.operateuserid <> n.operateuserid
        or o.updateorgid <> n.updateorgid
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.icms_classify_record_cl(
            serialno -- 流水号
            ,remark -- 备注
            ,relativeserialno -- 关联结果编号关联分类结果编号
            ,objectno -- 对象编号借据编号（借据编号/合同编号）
            ,accountmonth -- 期次
            ,islowrisk -- 是否低风险
            ,inputorgid -- 登记机构
            ,corporgid -- 法人机构编号
            ,oldserialno -- 旧信贷流水号
            ,manuclassifyresult -- 人工分类结果
            ,finalresult -- 最终结果
            ,customerid -- 客户编号
            ,balance -- 贷款余额
            ,classifystatus -- 分类状态
            ,operatedate -- 经办日期
            ,inputuserid -- 登记人
            ,firstresult -- 第一次分类结果
            ,objecttype -- 对象类型对象类型(合同/借据)
            ,updatedate -- 更新日期
            ,secondresult -- 第二次分类结果
            ,classifytype -- 分类方式分类方式(系统分类/人工分类)
            ,updateuserid -- 更新人
            ,finishdate2 -- FINISHDATE2
            ,contractserialno -- 合同号
            ,customername -- 客户名称
            ,currency -- 币种
            ,operateorgid -- 经办机构
            ,sysclassifyresult -- 系统分类结果
            ,manuclassifyreason -- 人工分类理由
            ,belongdept -- 所属条线
            ,reportperiod -- 财报周期
            ,isthismonthoccur -- 是否当月发生
            ,finishdate -- 分类完成日期
            ,termmonth -- 贷款期限
            ,finishdate5 -- FINISHDATE5
            ,migtflag -- 迁移标志：crsrcrilcupl
            ,productid -- 业务品种
            ,classifylevel -- 认定级别
            ,reportaccountmonth -- 财报会计月财报会计月
            ,inputdate -- 登记日期
            ,lastresult -- 上次分类结果
            ,businesssum -- 贷款金额
            ,operateuserid -- 经办人
            ,updateorgid -- 更新机构
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.icms_classify_record_op(
            serialno -- 流水号
            ,remark -- 备注
            ,relativeserialno -- 关联结果编号关联分类结果编号
            ,objectno -- 对象编号借据编号（借据编号/合同编号）
            ,accountmonth -- 期次
            ,islowrisk -- 是否低风险
            ,inputorgid -- 登记机构
            ,corporgid -- 法人机构编号
            ,oldserialno -- 旧信贷流水号
            ,manuclassifyresult -- 人工分类结果
            ,finalresult -- 最终结果
            ,customerid -- 客户编号
            ,balance -- 贷款余额
            ,classifystatus -- 分类状态
            ,operatedate -- 经办日期
            ,inputuserid -- 登记人
            ,firstresult -- 第一次分类结果
            ,objecttype -- 对象类型对象类型(合同/借据)
            ,updatedate -- 更新日期
            ,secondresult -- 第二次分类结果
            ,classifytype -- 分类方式分类方式(系统分类/人工分类)
            ,updateuserid -- 更新人
            ,finishdate2 -- FINISHDATE2
            ,contractserialno -- 合同号
            ,customername -- 客户名称
            ,currency -- 币种
            ,operateorgid -- 经办机构
            ,sysclassifyresult -- 系统分类结果
            ,manuclassifyreason -- 人工分类理由
            ,belongdept -- 所属条线
            ,reportperiod -- 财报周期
            ,isthismonthoccur -- 是否当月发生
            ,finishdate -- 分类完成日期
            ,termmonth -- 贷款期限
            ,finishdate5 -- FINISHDATE5
            ,migtflag -- 迁移标志：crsrcrilcupl
            ,productid -- 业务品种
            ,classifylevel -- 认定级别
            ,reportaccountmonth -- 财报会计月财报会计月
            ,inputdate -- 登记日期
            ,lastresult -- 上次分类结果
            ,businesssum -- 贷款金额
            ,operateuserid -- 经办人
            ,updateorgid -- 更新机构
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.serialno -- 流水号
    ,o.remark -- 备注
    ,o.relativeserialno -- 关联结果编号关联分类结果编号
    ,o.objectno -- 对象编号借据编号（借据编号/合同编号）
    ,o.accountmonth -- 期次
    ,o.islowrisk -- 是否低风险
    ,o.inputorgid -- 登记机构
    ,o.corporgid -- 法人机构编号
    ,o.oldserialno -- 旧信贷流水号
    ,o.manuclassifyresult -- 人工分类结果
    ,o.finalresult -- 最终结果
    ,o.customerid -- 客户编号
    ,o.balance -- 贷款余额
    ,o.classifystatus -- 分类状态
    ,o.operatedate -- 经办日期
    ,o.inputuserid -- 登记人
    ,o.firstresult -- 第一次分类结果
    ,o.objecttype -- 对象类型对象类型(合同/借据)
    ,o.updatedate -- 更新日期
    ,o.secondresult -- 第二次分类结果
    ,o.classifytype -- 分类方式分类方式(系统分类/人工分类)
    ,o.updateuserid -- 更新人
    ,o.finishdate2 -- FINISHDATE2
    ,o.contractserialno -- 合同号
    ,o.customername -- 客户名称
    ,o.currency -- 币种
    ,o.operateorgid -- 经办机构
    ,o.sysclassifyresult -- 系统分类结果
    ,o.manuclassifyreason -- 人工分类理由
    ,o.belongdept -- 所属条线
    ,o.reportperiod -- 财报周期
    ,o.isthismonthoccur -- 是否当月发生
    ,o.finishdate -- 分类完成日期
    ,o.termmonth -- 贷款期限
    ,o.finishdate5 -- FINISHDATE5
    ,o.migtflag -- 迁移标志：crsrcrilcupl
    ,o.productid -- 业务品种
    ,o.classifylevel -- 认定级别
    ,o.reportaccountmonth -- 财报会计月财报会计月
    ,o.inputdate -- 登记日期
    ,o.lastresult -- 上次分类结果
    ,o.businesssum -- 贷款金额
    ,o.operateuserid -- 经办人
    ,o.updateorgid -- 更新机构
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
from ${iol_schema}.icms_classify_record_bk o
    left join ${iol_schema}.icms_classify_record_op n
        on
            o.serialno = n.serialno
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.icms_classify_record_cl d
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
--truncate table ${iol_schema}.icms_classify_record;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('icms_classify_record') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.icms_classify_record drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.icms_classify_record add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.icms_classify_record exchange partition p_${batch_date} with table ${iol_schema}.icms_classify_record_cl;
alter table ${iol_schema}.icms_classify_record exchange partition p_20991231 with table ${iol_schema}.icms_classify_record_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.icms_classify_record to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.icms_classify_record_op purge;
drop table ${iol_schema}.icms_classify_record_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.icms_classify_record_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'icms_classify_record',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
