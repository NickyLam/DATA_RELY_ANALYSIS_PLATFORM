/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_icms_loanafteroversee
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
create table ${iol_schema}.icms_loanafteroversee_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.icms_loanafteroversee
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.icms_loanafteroversee_op purge;
drop table ${iol_schema}.icms_loanafteroversee_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.icms_loanafteroversee_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.icms_loanafteroversee where 0=1;

create table ${iol_schema}.icms_loanafteroversee_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.icms_loanafteroversee where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.icms_loanafteroversee_cl(
            serialno -- 流水号
            ,inspectbasic -- 检查要素
            ,overseematurity -- 监测截止日
            ,manageuserid -- 主办客户经理
            ,inputdate -- 登记日期
            ,updatedate -- 更新日期
            ,putoutdate -- 出账日期
            ,inputuserid -- 登记人
            ,approvestatus -- 审批状态
            ,inputtype -- 录入类型1：对公贷后录入2：对私贷后录入
            ,updateuserid -- 更新人编号
            ,objecttype -- 对象类型，存储各监测类型
            ,isinuse -- 添加维护标志1正常2不维护
            ,updateorgid -- 更新机构编号
            ,exemptiontype -- 豁免申请类型
            ,manageorgid -- 主办机构
            ,putoutsum -- 出账金额
            ,isoverdue -- 是否过期
            ,submitriskmanager -- 提交风险经理用户编号
            ,customername -- 客户名称
            ,contractserialno -- 合同号
            ,customerid -- 客户编号
            ,overseemonth -- 监测月份(检查期次)
            ,flag -- 生成标志010：手工录入020：批量自动生成
            ,currency -- 币种
            ,certtype -- 证件类型
            ,migtflag -- 
            ,curclaifyresult -- 当前检查五级分类结果
            ,putoutserialno -- 出账号
            ,finishstatus -- 完成状态0：过期未完成1：未过期未完成2：已完成
            ,customertype -- 客户类型
            ,applytype -- 申请类型:010投贷后020实地030风险监测
            ,curopinion -- 当前检查业务经办意见
            ,objectno -- 对象号
            ,docid -- 填写调查报告的DOCID
            ,inputorgid -- 登记机构
            ,certid -- 证件号码
            ,finishdate -- 完成日期
            ,projectfinancingflag -- 预测现金流可覆盖借款余额标志
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.icms_loanafteroversee_op(
            serialno -- 流水号
            ,inspectbasic -- 检查要素
            ,overseematurity -- 监测截止日
            ,manageuserid -- 主办客户经理
            ,inputdate -- 登记日期
            ,updatedate -- 更新日期
            ,putoutdate -- 出账日期
            ,inputuserid -- 登记人
            ,approvestatus -- 审批状态
            ,inputtype -- 录入类型1：对公贷后录入2：对私贷后录入
            ,updateuserid -- 更新人编号
            ,objecttype -- 对象类型，存储各监测类型
            ,isinuse -- 添加维护标志1正常2不维护
            ,updateorgid -- 更新机构编号
            ,exemptiontype -- 豁免申请类型
            ,manageorgid -- 主办机构
            ,putoutsum -- 出账金额
            ,isoverdue -- 是否过期
            ,submitriskmanager -- 提交风险经理用户编号
            ,customername -- 客户名称
            ,contractserialno -- 合同号
            ,customerid -- 客户编号
            ,overseemonth -- 监测月份(检查期次)
            ,flag -- 生成标志010：手工录入020：批量自动生成
            ,currency -- 币种
            ,certtype -- 证件类型
            ,migtflag -- 
            ,curclaifyresult -- 当前检查五级分类结果
            ,putoutserialno -- 出账号
            ,finishstatus -- 完成状态0：过期未完成1：未过期未完成2：已完成
            ,customertype -- 客户类型
            ,applytype -- 申请类型:010投贷后020实地030风险监测
            ,curopinion -- 当前检查业务经办意见
            ,objectno -- 对象号
            ,docid -- 填写调查报告的DOCID
            ,inputorgid -- 登记机构
            ,certid -- 证件号码
            ,finishdate -- 完成日期
            ,projectfinancingflag -- 预测现金流可覆盖借款余额标志
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.serialno, o.serialno) as serialno -- 流水号
    ,nvl(n.inspectbasic, o.inspectbasic) as inspectbasic -- 检查要素
    ,nvl(n.overseematurity, o.overseematurity) as overseematurity -- 监测截止日
    ,nvl(n.manageuserid, o.manageuserid) as manageuserid -- 主办客户经理
    ,nvl(n.inputdate, o.inputdate) as inputdate -- 登记日期
    ,nvl(n.updatedate, o.updatedate) as updatedate -- 更新日期
    ,nvl(n.putoutdate, o.putoutdate) as putoutdate -- 出账日期
    ,nvl(n.inputuserid, o.inputuserid) as inputuserid -- 登记人
    ,nvl(n.approvestatus, o.approvestatus) as approvestatus -- 审批状态
    ,nvl(n.inputtype, o.inputtype) as inputtype -- 录入类型1：对公贷后录入2：对私贷后录入
    ,nvl(n.updateuserid, o.updateuserid) as updateuserid -- 更新人编号
    ,nvl(n.objecttype, o.objecttype) as objecttype -- 对象类型，存储各监测类型
    ,nvl(n.isinuse, o.isinuse) as isinuse -- 添加维护标志1正常2不维护
    ,nvl(n.updateorgid, o.updateorgid) as updateorgid -- 更新机构编号
    ,nvl(n.exemptiontype, o.exemptiontype) as exemptiontype -- 豁免申请类型
    ,nvl(n.manageorgid, o.manageorgid) as manageorgid -- 主办机构
    ,nvl(n.putoutsum, o.putoutsum) as putoutsum -- 出账金额
    ,nvl(n.isoverdue, o.isoverdue) as isoverdue -- 是否过期
    ,nvl(n.submitriskmanager, o.submitriskmanager) as submitriskmanager -- 提交风险经理用户编号
    ,nvl(n.customername, o.customername) as customername -- 客户名称
    ,nvl(n.contractserialno, o.contractserialno) as contractserialno -- 合同号
    ,nvl(n.customerid, o.customerid) as customerid -- 客户编号
    ,nvl(n.overseemonth, o.overseemonth) as overseemonth -- 监测月份(检查期次)
    ,nvl(n.flag, o.flag) as flag -- 生成标志010：手工录入020：批量自动生成
    ,nvl(n.currency, o.currency) as currency -- 币种
    ,nvl(n.certtype, o.certtype) as certtype -- 证件类型
    ,nvl(n.migtflag, o.migtflag) as migtflag -- 
    ,nvl(n.curclaifyresult, o.curclaifyresult) as curclaifyresult -- 当前检查五级分类结果
    ,nvl(n.putoutserialno, o.putoutserialno) as putoutserialno -- 出账号
    ,nvl(n.finishstatus, o.finishstatus) as finishstatus -- 完成状态0：过期未完成1：未过期未完成2：已完成
    ,nvl(n.customertype, o.customertype) as customertype -- 客户类型
    ,nvl(n.applytype, o.applytype) as applytype -- 申请类型:010投贷后020实地030风险监测
    ,nvl(n.curopinion, o.curopinion) as curopinion -- 当前检查业务经办意见
    ,nvl(n.objectno, o.objectno) as objectno -- 对象号
    ,nvl(n.docid, o.docid) as docid -- 填写调查报告的DOCID
    ,nvl(n.inputorgid, o.inputorgid) as inputorgid -- 登记机构
    ,nvl(n.certid, o.certid) as certid -- 证件号码
    ,nvl(n.finishdate, o.finishdate) as finishdate -- 完成日期
    ,nvl(n.projectfinancingflag, o.projectfinancingflag) as projectfinancingflag -- 预测现金流可覆盖借款余额标志
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
from (select * from ${iol_schema}.icms_loanafteroversee_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.icms_loanafteroversee where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.serialno = n.serialno
where (
        o.serialno is null
    )
    or (
        n.serialno is null
    )
    or (
        o.inspectbasic <> n.inspectbasic
        or o.overseematurity <> n.overseematurity
        or o.manageuserid <> n.manageuserid
        or o.inputdate <> n.inputdate
        or o.updatedate <> n.updatedate
        or o.putoutdate <> n.putoutdate
        or o.inputuserid <> n.inputuserid
        or o.approvestatus <> n.approvestatus
        or o.inputtype <> n.inputtype
        or o.updateuserid <> n.updateuserid
        or o.objecttype <> n.objecttype
        or o.isinuse <> n.isinuse
        or o.updateorgid <> n.updateorgid
        or o.exemptiontype <> n.exemptiontype
        or o.manageorgid <> n.manageorgid
        or o.putoutsum <> n.putoutsum
        or o.isoverdue <> n.isoverdue
        or o.submitriskmanager <> n.submitriskmanager
        or o.customername <> n.customername
        or o.contractserialno <> n.contractserialno
        or o.customerid <> n.customerid
        or o.overseemonth <> n.overseemonth
        or o.flag <> n.flag
        or o.currency <> n.currency
        or o.certtype <> n.certtype
        or o.migtflag <> n.migtflag
        or o.curclaifyresult <> n.curclaifyresult
        or o.putoutserialno <> n.putoutserialno
        or o.finishstatus <> n.finishstatus
        or o.customertype <> n.customertype
        or o.applytype <> n.applytype
        or o.curopinion <> n.curopinion
        or o.objectno <> n.objectno
        or o.docid <> n.docid
        or o.inputorgid <> n.inputorgid
        or o.certid <> n.certid
        or o.finishdate <> n.finishdate
        or o.projectfinancingflag <> n.projectfinancingflag
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.icms_loanafteroversee_cl(
            serialno -- 流水号
            ,inspectbasic -- 检查要素
            ,overseematurity -- 监测截止日
            ,manageuserid -- 主办客户经理
            ,inputdate -- 登记日期
            ,updatedate -- 更新日期
            ,putoutdate -- 出账日期
            ,inputuserid -- 登记人
            ,approvestatus -- 审批状态
            ,inputtype -- 录入类型1：对公贷后录入2：对私贷后录入
            ,updateuserid -- 更新人编号
            ,objecttype -- 对象类型，存储各监测类型
            ,isinuse -- 添加维护标志1正常2不维护
            ,updateorgid -- 更新机构编号
            ,exemptiontype -- 豁免申请类型
            ,manageorgid -- 主办机构
            ,putoutsum -- 出账金额
            ,isoverdue -- 是否过期
            ,submitriskmanager -- 提交风险经理用户编号
            ,customername -- 客户名称
            ,contractserialno -- 合同号
            ,customerid -- 客户编号
            ,overseemonth -- 监测月份(检查期次)
            ,flag -- 生成标志010：手工录入020：批量自动生成
            ,currency -- 币种
            ,certtype -- 证件类型
            ,migtflag -- 
            ,curclaifyresult -- 当前检查五级分类结果
            ,putoutserialno -- 出账号
            ,finishstatus -- 完成状态0：过期未完成1：未过期未完成2：已完成
            ,customertype -- 客户类型
            ,applytype -- 申请类型:010投贷后020实地030风险监测
            ,curopinion -- 当前检查业务经办意见
            ,objectno -- 对象号
            ,docid -- 填写调查报告的DOCID
            ,inputorgid -- 登记机构
            ,certid -- 证件号码
            ,finishdate -- 完成日期
            ,projectfinancingflag -- 预测现金流可覆盖借款余额标志
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.icms_loanafteroversee_op(
            serialno -- 流水号
            ,inspectbasic -- 检查要素
            ,overseematurity -- 监测截止日
            ,manageuserid -- 主办客户经理
            ,inputdate -- 登记日期
            ,updatedate -- 更新日期
            ,putoutdate -- 出账日期
            ,inputuserid -- 登记人
            ,approvestatus -- 审批状态
            ,inputtype -- 录入类型1：对公贷后录入2：对私贷后录入
            ,updateuserid -- 更新人编号
            ,objecttype -- 对象类型，存储各监测类型
            ,isinuse -- 添加维护标志1正常2不维护
            ,updateorgid -- 更新机构编号
            ,exemptiontype -- 豁免申请类型
            ,manageorgid -- 主办机构
            ,putoutsum -- 出账金额
            ,isoverdue -- 是否过期
            ,submitriskmanager -- 提交风险经理用户编号
            ,customername -- 客户名称
            ,contractserialno -- 合同号
            ,customerid -- 客户编号
            ,overseemonth -- 监测月份(检查期次)
            ,flag -- 生成标志010：手工录入020：批量自动生成
            ,currency -- 币种
            ,certtype -- 证件类型
            ,migtflag -- 
            ,curclaifyresult -- 当前检查五级分类结果
            ,putoutserialno -- 出账号
            ,finishstatus -- 完成状态0：过期未完成1：未过期未完成2：已完成
            ,customertype -- 客户类型
            ,applytype -- 申请类型:010投贷后020实地030风险监测
            ,curopinion -- 当前检查业务经办意见
            ,objectno -- 对象号
            ,docid -- 填写调查报告的DOCID
            ,inputorgid -- 登记机构
            ,certid -- 证件号码
            ,finishdate -- 完成日期
            ,projectfinancingflag -- 预测现金流可覆盖借款余额标志
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.serialno -- 流水号
    ,o.inspectbasic -- 检查要素
    ,o.overseematurity -- 监测截止日
    ,o.manageuserid -- 主办客户经理
    ,o.inputdate -- 登记日期
    ,o.updatedate -- 更新日期
    ,o.putoutdate -- 出账日期
    ,o.inputuserid -- 登记人
    ,o.approvestatus -- 审批状态
    ,o.inputtype -- 录入类型1：对公贷后录入2：对私贷后录入
    ,o.updateuserid -- 更新人编号
    ,o.objecttype -- 对象类型，存储各监测类型
    ,o.isinuse -- 添加维护标志1正常2不维护
    ,o.updateorgid -- 更新机构编号
    ,o.exemptiontype -- 豁免申请类型
    ,o.manageorgid -- 主办机构
    ,o.putoutsum -- 出账金额
    ,o.isoverdue -- 是否过期
    ,o.submitriskmanager -- 提交风险经理用户编号
    ,o.customername -- 客户名称
    ,o.contractserialno -- 合同号
    ,o.customerid -- 客户编号
    ,o.overseemonth -- 监测月份(检查期次)
    ,o.flag -- 生成标志010：手工录入020：批量自动生成
    ,o.currency -- 币种
    ,o.certtype -- 证件类型
    ,o.migtflag -- 
    ,o.curclaifyresult -- 当前检查五级分类结果
    ,o.putoutserialno -- 出账号
    ,o.finishstatus -- 完成状态0：过期未完成1：未过期未完成2：已完成
    ,o.customertype -- 客户类型
    ,o.applytype -- 申请类型:010投贷后020实地030风险监测
    ,o.curopinion -- 当前检查业务经办意见
    ,o.objectno -- 对象号
    ,o.docid -- 填写调查报告的DOCID
    ,o.inputorgid -- 登记机构
    ,o.certid -- 证件号码
    ,o.finishdate -- 完成日期
    ,o.projectfinancingflag -- 预测现金流可覆盖借款余额标志
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
from ${iol_schema}.icms_loanafteroversee_bk o
    left join ${iol_schema}.icms_loanafteroversee_op n
        on
            o.serialno = n.serialno
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.icms_loanafteroversee_cl d
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
--truncate table ${iol_schema}.icms_loanafteroversee;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('icms_loanafteroversee') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.icms_loanafteroversee drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.icms_loanafteroversee add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.icms_loanafteroversee exchange partition p_${batch_date} with table ${iol_schema}.icms_loanafteroversee_cl;
alter table ${iol_schema}.icms_loanafteroversee exchange partition p_20991231 with table ${iol_schema}.icms_loanafteroversee_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.icms_loanafteroversee to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.icms_loanafteroversee_op purge;
drop table ${iol_schema}.icms_loanafteroversee_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.icms_loanafteroversee_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'icms_loanafteroversee',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
