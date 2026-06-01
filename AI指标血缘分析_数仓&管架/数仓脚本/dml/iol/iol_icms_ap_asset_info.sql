/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_icms_ap_asset_info
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
create table ${iol_schema}.icms_ap_asset_info_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.icms_ap_asset_info
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.icms_ap_asset_info_op purge;
drop table ${iol_schema}.icms_ap_asset_info_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.icms_ap_asset_info_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.icms_ap_asset_info where 0=1;

create table ${iol_schema}.icms_ap_asset_info_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.icms_ap_asset_info where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.icms_ap_asset_info_cl(
            assetno -- 风险资产编号
            ,submitstatus -- 提交状态
            ,groupid -- 集团编号
            ,contractno -- 合同编号
            ,updatedate -- 更新日期
            ,fmuserid -- 当前保全经理编号
            ,approvestatus -- 审批状态
            ,reorggroupid -- 重组集团编号
            ,handinreason -- 移交原因
            ,resourcesystem -- 来源系统
            ,inputorgid -- 登记机构
            ,businesssum -- 合同金额
            ,groupname -- 集团名称
            ,recoverno -- 恢复流水号
            ,handinorg -- 移交机构
            ,currency -- 币种
            ,borrowerno -- 借款人编号
            ,customertype -- 客户类型
            ,deleteflag -- 删除标识
            ,inputuserid -- 登记人
            ,classifyresult -- 当前五级分类结果
            ,holdisflag -- 是否认定问题客户
            ,balance -- 合同余额
            ,begindate -- 合同生效日期
            ,issendpayment -- 是否已发送支付令
            ,smuserid -- 协办项目经理编号
            ,holdno -- 认定流水号
            ,handoutreason -- 逆移交原因
            ,customerid -- 客户编号
            ,businesstype -- 业务品种
            ,assetinreason -- 认定原因
            ,transfertype -- 移交类型
            ,happendate -- 业务发生日期
            ,borrowername -- 借款人名称
            ,customername -- 客户名称
            ,updateuserid -- 更新人
            ,customerlevel -- 客户评级
            ,handinno -- 移交流水号
            ,isdisflag -- 是否移交特资部
            ,assetname -- 资产名称
            ,certid -- 证件号码
            ,inputdate -- 登记日期
            ,isoutflag -- 是否逆移交
            ,fmusername -- 当前保全经理名称
            ,smusername -- 协办项目经理名称
            ,reorggroupname -- 重组集团名称R
            ,disflag -- 是否分发
            ,allbalance -- 总借据余额
            ,writeoffflag -- 核销标识
            ,handoutno -- 逆移交流水号
            ,updateorgid -- 更新机构
            ,allbusinesssum -- 总授信金额
            ,allbdbusinesssum -- 总借据金额
            ,certtype -- 证件类型
            ,assetoutreason -- 恢复原因
            ,outdate -- 移出时间
            ,holdoutisflag -- 是否恢复正常客户
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.icms_ap_asset_info_op(
            assetno -- 风险资产编号
            ,submitstatus -- 提交状态
            ,groupid -- 集团编号
            ,contractno -- 合同编号
            ,updatedate -- 更新日期
            ,fmuserid -- 当前保全经理编号
            ,approvestatus -- 审批状态
            ,reorggroupid -- 重组集团编号
            ,handinreason -- 移交原因
            ,resourcesystem -- 来源系统
            ,inputorgid -- 登记机构
            ,businesssum -- 合同金额
            ,groupname -- 集团名称
            ,recoverno -- 恢复流水号
            ,handinorg -- 移交机构
            ,currency -- 币种
            ,borrowerno -- 借款人编号
            ,customertype -- 客户类型
            ,deleteflag -- 删除标识
            ,inputuserid -- 登记人
            ,classifyresult -- 当前五级分类结果
            ,holdisflag -- 是否认定问题客户
            ,balance -- 合同余额
            ,begindate -- 合同生效日期
            ,issendpayment -- 是否已发送支付令
            ,smuserid -- 协办项目经理编号
            ,holdno -- 认定流水号
            ,handoutreason -- 逆移交原因
            ,customerid -- 客户编号
            ,businesstype -- 业务品种
            ,assetinreason -- 认定原因
            ,transfertype -- 移交类型
            ,happendate -- 业务发生日期
            ,borrowername -- 借款人名称
            ,customername -- 客户名称
            ,updateuserid -- 更新人
            ,customerlevel -- 客户评级
            ,handinno -- 移交流水号
            ,isdisflag -- 是否移交特资部
            ,assetname -- 资产名称
            ,certid -- 证件号码
            ,inputdate -- 登记日期
            ,isoutflag -- 是否逆移交
            ,fmusername -- 当前保全经理名称
            ,smusername -- 协办项目经理名称
            ,reorggroupname -- 重组集团名称R
            ,disflag -- 是否分发
            ,allbalance -- 总借据余额
            ,writeoffflag -- 核销标识
            ,handoutno -- 逆移交流水号
            ,updateorgid -- 更新机构
            ,allbusinesssum -- 总授信金额
            ,allbdbusinesssum -- 总借据金额
            ,certtype -- 证件类型
            ,assetoutreason -- 恢复原因
            ,outdate -- 移出时间
            ,holdoutisflag -- 是否恢复正常客户
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.assetno, o.assetno) as assetno -- 风险资产编号
    ,nvl(n.submitstatus, o.submitstatus) as submitstatus -- 提交状态
    ,nvl(n.groupid, o.groupid) as groupid -- 集团编号
    ,nvl(n.contractno, o.contractno) as contractno -- 合同编号
    ,nvl(n.updatedate, o.updatedate) as updatedate -- 更新日期
    ,nvl(n.fmuserid, o.fmuserid) as fmuserid -- 当前保全经理编号
    ,nvl(n.approvestatus, o.approvestatus) as approvestatus -- 审批状态
    ,nvl(n.reorggroupid, o.reorggroupid) as reorggroupid -- 重组集团编号
    ,nvl(n.handinreason, o.handinreason) as handinreason -- 移交原因
    ,nvl(n.resourcesystem, o.resourcesystem) as resourcesystem -- 来源系统
    ,nvl(n.inputorgid, o.inputorgid) as inputorgid -- 登记机构
    ,nvl(n.businesssum, o.businesssum) as businesssum -- 合同金额
    ,nvl(n.groupname, o.groupname) as groupname -- 集团名称
    ,nvl(n.recoverno, o.recoverno) as recoverno -- 恢复流水号
    ,nvl(n.handinorg, o.handinorg) as handinorg -- 移交机构
    ,nvl(n.currency, o.currency) as currency -- 币种
    ,nvl(n.borrowerno, o.borrowerno) as borrowerno -- 借款人编号
    ,nvl(n.customertype, o.customertype) as customertype -- 客户类型
    ,nvl(n.deleteflag, o.deleteflag) as deleteflag -- 删除标识
    ,nvl(n.inputuserid, o.inputuserid) as inputuserid -- 登记人
    ,nvl(n.classifyresult, o.classifyresult) as classifyresult -- 当前五级分类结果
    ,nvl(n.holdisflag, o.holdisflag) as holdisflag -- 是否认定问题客户
    ,nvl(n.balance, o.balance) as balance -- 合同余额
    ,nvl(n.begindate, o.begindate) as begindate -- 合同生效日期
    ,nvl(n.issendpayment, o.issendpayment) as issendpayment -- 是否已发送支付令
    ,nvl(n.smuserid, o.smuserid) as smuserid -- 协办项目经理编号
    ,nvl(n.holdno, o.holdno) as holdno -- 认定流水号
    ,nvl(n.handoutreason, o.handoutreason) as handoutreason -- 逆移交原因
    ,nvl(n.customerid, o.customerid) as customerid -- 客户编号
    ,nvl(n.businesstype, o.businesstype) as businesstype -- 业务品种
    ,nvl(n.assetinreason, o.assetinreason) as assetinreason -- 认定原因
    ,nvl(n.transfertype, o.transfertype) as transfertype -- 移交类型
    ,nvl(n.happendate, o.happendate) as happendate -- 业务发生日期
    ,nvl(n.borrowername, o.borrowername) as borrowername -- 借款人名称
    ,nvl(n.customername, o.customername) as customername -- 客户名称
    ,nvl(n.updateuserid, o.updateuserid) as updateuserid -- 更新人
    ,nvl(n.customerlevel, o.customerlevel) as customerlevel -- 客户评级
    ,nvl(n.handinno, o.handinno) as handinno -- 移交流水号
    ,nvl(n.isdisflag, o.isdisflag) as isdisflag -- 是否移交特资部
    ,nvl(n.assetname, o.assetname) as assetname -- 资产名称
    ,nvl(n.certid, o.certid) as certid -- 证件号码
    ,nvl(n.inputdate, o.inputdate) as inputdate -- 登记日期
    ,nvl(n.isoutflag, o.isoutflag) as isoutflag -- 是否逆移交
    ,nvl(n.fmusername, o.fmusername) as fmusername -- 当前保全经理名称
    ,nvl(n.smusername, o.smusername) as smusername -- 协办项目经理名称
    ,nvl(n.reorggroupname, o.reorggroupname) as reorggroupname -- 重组集团名称R
    ,nvl(n.disflag, o.disflag) as disflag -- 是否分发
    ,nvl(n.allbalance, o.allbalance) as allbalance -- 总借据余额
    ,nvl(n.writeoffflag, o.writeoffflag) as writeoffflag -- 核销标识
    ,nvl(n.handoutno, o.handoutno) as handoutno -- 逆移交流水号
    ,nvl(n.updateorgid, o.updateorgid) as updateorgid -- 更新机构
    ,nvl(n.allbusinesssum, o.allbusinesssum) as allbusinesssum -- 总授信金额
    ,nvl(n.allbdbusinesssum, o.allbdbusinesssum) as allbdbusinesssum -- 总借据金额
    ,nvl(n.certtype, o.certtype) as certtype -- 证件类型
    ,nvl(n.assetoutreason, o.assetoutreason) as assetoutreason -- 恢复原因
    ,nvl(n.outdate, o.outdate) as outdate -- 移出时间
    ,nvl(n.holdoutisflag, o.holdoutisflag) as holdoutisflag -- 是否恢复正常客户
    ,case when
            n.assetno is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.assetno is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.assetno is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.icms_ap_asset_info_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.icms_ap_asset_info where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.assetno = n.assetno
where (
        o.assetno is null
    )
    or (
        n.assetno is null
    )
    or (
        o.submitstatus <> n.submitstatus
        or o.groupid <> n.groupid
        or o.contractno <> n.contractno
        or o.updatedate <> n.updatedate
        or o.fmuserid <> n.fmuserid
        or o.approvestatus <> n.approvestatus
        or o.reorggroupid <> n.reorggroupid
        or o.handinreason <> n.handinreason
        or o.resourcesystem <> n.resourcesystem
        or o.inputorgid <> n.inputorgid
        or o.businesssum <> n.businesssum
        or o.groupname <> n.groupname
        or o.recoverno <> n.recoverno
        or o.handinorg <> n.handinorg
        or o.currency <> n.currency
        or o.borrowerno <> n.borrowerno
        or o.customertype <> n.customertype
        or o.deleteflag <> n.deleteflag
        or o.inputuserid <> n.inputuserid
        or o.classifyresult <> n.classifyresult
        or o.holdisflag <> n.holdisflag
        or o.balance <> n.balance
        or o.begindate <> n.begindate
        or o.issendpayment <> n.issendpayment
        or o.smuserid <> n.smuserid
        or o.holdno <> n.holdno
        or o.handoutreason <> n.handoutreason
        or o.customerid <> n.customerid
        or o.businesstype <> n.businesstype
        or o.assetinreason <> n.assetinreason
        or o.transfertype <> n.transfertype
        or o.happendate <> n.happendate
        or o.borrowername <> n.borrowername
        or o.customername <> n.customername
        or o.updateuserid <> n.updateuserid
        or o.customerlevel <> n.customerlevel
        or o.handinno <> n.handinno
        or o.isdisflag <> n.isdisflag
        or o.assetname <> n.assetname
        or o.certid <> n.certid
        or o.inputdate <> n.inputdate
        or o.isoutflag <> n.isoutflag
        or o.fmusername <> n.fmusername
        or o.smusername <> n.smusername
        or o.reorggroupname <> n.reorggroupname
        or o.disflag <> n.disflag
        or o.allbalance <> n.allbalance
        or o.writeoffflag <> n.writeoffflag
        or o.handoutno <> n.handoutno
        or o.updateorgid <> n.updateorgid
        or o.allbusinesssum <> n.allbusinesssum
        or o.allbdbusinesssum <> n.allbdbusinesssum
        or o.certtype <> n.certtype
        or o.assetoutreason <> n.assetoutreason
        or o.outdate <> n.outdate
        or o.holdoutisflag <> n.holdoutisflag
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.icms_ap_asset_info_cl(
            assetno -- 风险资产编号
            ,submitstatus -- 提交状态
            ,groupid -- 集团编号
            ,contractno -- 合同编号
            ,updatedate -- 更新日期
            ,fmuserid -- 当前保全经理编号
            ,approvestatus -- 审批状态
            ,reorggroupid -- 重组集团编号
            ,handinreason -- 移交原因
            ,resourcesystem -- 来源系统
            ,inputorgid -- 登记机构
            ,businesssum -- 合同金额
            ,groupname -- 集团名称
            ,recoverno -- 恢复流水号
            ,handinorg -- 移交机构
            ,currency -- 币种
            ,borrowerno -- 借款人编号
            ,customertype -- 客户类型
            ,deleteflag -- 删除标识
            ,inputuserid -- 登记人
            ,classifyresult -- 当前五级分类结果
            ,holdisflag -- 是否认定问题客户
            ,balance -- 合同余额
            ,begindate -- 合同生效日期
            ,issendpayment -- 是否已发送支付令
            ,smuserid -- 协办项目经理编号
            ,holdno -- 认定流水号
            ,handoutreason -- 逆移交原因
            ,customerid -- 客户编号
            ,businesstype -- 业务品种
            ,assetinreason -- 认定原因
            ,transfertype -- 移交类型
            ,happendate -- 业务发生日期
            ,borrowername -- 借款人名称
            ,customername -- 客户名称
            ,updateuserid -- 更新人
            ,customerlevel -- 客户评级
            ,handinno -- 移交流水号
            ,isdisflag -- 是否移交特资部
            ,assetname -- 资产名称
            ,certid -- 证件号码
            ,inputdate -- 登记日期
            ,isoutflag -- 是否逆移交
            ,fmusername -- 当前保全经理名称
            ,smusername -- 协办项目经理名称
            ,reorggroupname -- 重组集团名称R
            ,disflag -- 是否分发
            ,allbalance -- 总借据余额
            ,writeoffflag -- 核销标识
            ,handoutno -- 逆移交流水号
            ,updateorgid -- 更新机构
            ,allbusinesssum -- 总授信金额
            ,allbdbusinesssum -- 总借据金额
            ,certtype -- 证件类型
            ,assetoutreason -- 恢复原因
            ,outdate -- 移出时间
            ,holdoutisflag -- 是否恢复正常客户
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.icms_ap_asset_info_op(
            assetno -- 风险资产编号
            ,submitstatus -- 提交状态
            ,groupid -- 集团编号
            ,contractno -- 合同编号
            ,updatedate -- 更新日期
            ,fmuserid -- 当前保全经理编号
            ,approvestatus -- 审批状态
            ,reorggroupid -- 重组集团编号
            ,handinreason -- 移交原因
            ,resourcesystem -- 来源系统
            ,inputorgid -- 登记机构
            ,businesssum -- 合同金额
            ,groupname -- 集团名称
            ,recoverno -- 恢复流水号
            ,handinorg -- 移交机构
            ,currency -- 币种
            ,borrowerno -- 借款人编号
            ,customertype -- 客户类型
            ,deleteflag -- 删除标识
            ,inputuserid -- 登记人
            ,classifyresult -- 当前五级分类结果
            ,holdisflag -- 是否认定问题客户
            ,balance -- 合同余额
            ,begindate -- 合同生效日期
            ,issendpayment -- 是否已发送支付令
            ,smuserid -- 协办项目经理编号
            ,holdno -- 认定流水号
            ,handoutreason -- 逆移交原因
            ,customerid -- 客户编号
            ,businesstype -- 业务品种
            ,assetinreason -- 认定原因
            ,transfertype -- 移交类型
            ,happendate -- 业务发生日期
            ,borrowername -- 借款人名称
            ,customername -- 客户名称
            ,updateuserid -- 更新人
            ,customerlevel -- 客户评级
            ,handinno -- 移交流水号
            ,isdisflag -- 是否移交特资部
            ,assetname -- 资产名称
            ,certid -- 证件号码
            ,inputdate -- 登记日期
            ,isoutflag -- 是否逆移交
            ,fmusername -- 当前保全经理名称
            ,smusername -- 协办项目经理名称
            ,reorggroupname -- 重组集团名称R
            ,disflag -- 是否分发
            ,allbalance -- 总借据余额
            ,writeoffflag -- 核销标识
            ,handoutno -- 逆移交流水号
            ,updateorgid -- 更新机构
            ,allbusinesssum -- 总授信金额
            ,allbdbusinesssum -- 总借据金额
            ,certtype -- 证件类型
            ,assetoutreason -- 恢复原因
            ,outdate -- 移出时间
            ,holdoutisflag -- 是否恢复正常客户
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.assetno -- 风险资产编号
    ,o.submitstatus -- 提交状态
    ,o.groupid -- 集团编号
    ,o.contractno -- 合同编号
    ,o.updatedate -- 更新日期
    ,o.fmuserid -- 当前保全经理编号
    ,o.approvestatus -- 审批状态
    ,o.reorggroupid -- 重组集团编号
    ,o.handinreason -- 移交原因
    ,o.resourcesystem -- 来源系统
    ,o.inputorgid -- 登记机构
    ,o.businesssum -- 合同金额
    ,o.groupname -- 集团名称
    ,o.recoverno -- 恢复流水号
    ,o.handinorg -- 移交机构
    ,o.currency -- 币种
    ,o.borrowerno -- 借款人编号
    ,o.customertype -- 客户类型
    ,o.deleteflag -- 删除标识
    ,o.inputuserid -- 登记人
    ,o.classifyresult -- 当前五级分类结果
    ,o.holdisflag -- 是否认定问题客户
    ,o.balance -- 合同余额
    ,o.begindate -- 合同生效日期
    ,o.issendpayment -- 是否已发送支付令
    ,o.smuserid -- 协办项目经理编号
    ,o.holdno -- 认定流水号
    ,o.handoutreason -- 逆移交原因
    ,o.customerid -- 客户编号
    ,o.businesstype -- 业务品种
    ,o.assetinreason -- 认定原因
    ,o.transfertype -- 移交类型
    ,o.happendate -- 业务发生日期
    ,o.borrowername -- 借款人名称
    ,o.customername -- 客户名称
    ,o.updateuserid -- 更新人
    ,o.customerlevel -- 客户评级
    ,o.handinno -- 移交流水号
    ,o.isdisflag -- 是否移交特资部
    ,o.assetname -- 资产名称
    ,o.certid -- 证件号码
    ,o.inputdate -- 登记日期
    ,o.isoutflag -- 是否逆移交
    ,o.fmusername -- 当前保全经理名称
    ,o.smusername -- 协办项目经理名称
    ,o.reorggroupname -- 重组集团名称R
    ,o.disflag -- 是否分发
    ,o.allbalance -- 总借据余额
    ,o.writeoffflag -- 核销标识
    ,o.handoutno -- 逆移交流水号
    ,o.updateorgid -- 更新机构
    ,o.allbusinesssum -- 总授信金额
    ,o.allbdbusinesssum -- 总借据金额
    ,o.certtype -- 证件类型
    ,o.assetoutreason -- 恢复原因
    ,o.outdate -- 移出时间
    ,o.holdoutisflag -- 是否恢复正常客户
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
from ${iol_schema}.icms_ap_asset_info_bk o
    left join ${iol_schema}.icms_ap_asset_info_op n
        on
            o.assetno = n.assetno
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.icms_ap_asset_info_cl d
        on
            o.assetno = d.assetno
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
--truncate table ${iol_schema}.icms_ap_asset_info;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('icms_ap_asset_info') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.icms_ap_asset_info drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.icms_ap_asset_info add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.icms_ap_asset_info exchange partition p_${batch_date} with table ${iol_schema}.icms_ap_asset_info_cl;
alter table ${iol_schema}.icms_ap_asset_info exchange partition p_20991231 with table ${iol_schema}.icms_ap_asset_info_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.icms_ap_asset_info to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.icms_ap_asset_info_op purge;
drop table ${iol_schema}.icms_ap_asset_info_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.icms_ap_asset_info_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'icms_ap_asset_info',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
