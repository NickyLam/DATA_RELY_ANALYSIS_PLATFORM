/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_icms_ap_contract_info
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
create table ${iol_schema}.icms_ap_contract_info_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.icms_ap_contract_info
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.icms_ap_contract_info_op purge;
drop table ${iol_schema}.icms_ap_contract_info_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.icms_ap_contract_info_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.icms_ap_contract_info where 0=1;

create table ${iol_schema}.icms_ap_contract_info_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.icms_ap_contract_info where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.icms_ap_contract_info_cl(
            contractno -- 合同流水号
            ,operateuserid -- 主办机构编号
            ,overdueratefloat -- 逾期利率浮动比例
            ,assetno -- 资产编号
            ,outbalance -- 表外利息余额
            ,classifyresult -- 风险分类
            ,operateorgid -- 主办客户经理编号
            ,begindate -- 合同起始日
            ,rateadjusttype -- 利率调整方式
            ,signdate -- 合同签订日
            ,approvedate -- 审批通过日
            ,inputuserid -- 登记人
            ,repaytype -- 还款方式
            ,interestoverdueday -- 欠息天数
            ,deleteflag -- 删除标志
            ,certtype -- 证件类型
            ,interestdate -- 结息扣款日
            ,resourcesystem -- 来源系统
            ,customername -- 客户名称
            ,currency -- 币种
            ,repayno -- 还款账号
            ,principaloverdueday -- 本金逾期天数
            ,updateorgid -- 更新机构
            ,interestcyc -- 结息周期
            ,ratefloattype -- 利率浮动类型
            ,ratefloat -- 利率浮动值
            ,cooperateuserid -- 协办客户经理编号
            ,writeoffflag -- 核销状态
            ,balance -- 合同余额
            ,cooperateorgid -- 协办机构编号
            ,mforgid -- 入账机构编号
            ,onbalance -- 表内利息余额
            ,newnpdate -- 最新进入不良日期
            ,expiredate -- 合同到期日
            ,wrightoffbalance -- 核销当日欠息
            ,tmsp -- 时间戳
            ,inputdate -- 登记日期
            ,certid -- 证件号码
            ,businesstype -- 业务品种编号
            ,cooperateusername -- 协办客户经理名称
            ,inputorgid -- 登记机构
            ,assetname -- 资产名称
            ,updateuserid -- 更新人
            ,updatedate -- 更新日期
            ,customerid -- 客户号
            ,businesssum -- 合同金额
            ,yearrate -- 执行年利率
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.icms_ap_contract_info_op(
            contractno -- 合同流水号
            ,operateuserid -- 主办机构编号
            ,overdueratefloat -- 逾期利率浮动比例
            ,assetno -- 资产编号
            ,outbalance -- 表外利息余额
            ,classifyresult -- 风险分类
            ,operateorgid -- 主办客户经理编号
            ,begindate -- 合同起始日
            ,rateadjusttype -- 利率调整方式
            ,signdate -- 合同签订日
            ,approvedate -- 审批通过日
            ,inputuserid -- 登记人
            ,repaytype -- 还款方式
            ,interestoverdueday -- 欠息天数
            ,deleteflag -- 删除标志
            ,certtype -- 证件类型
            ,interestdate -- 结息扣款日
            ,resourcesystem -- 来源系统
            ,customername -- 客户名称
            ,currency -- 币种
            ,repayno -- 还款账号
            ,principaloverdueday -- 本金逾期天数
            ,updateorgid -- 更新机构
            ,interestcyc -- 结息周期
            ,ratefloattype -- 利率浮动类型
            ,ratefloat -- 利率浮动值
            ,cooperateuserid -- 协办客户经理编号
            ,writeoffflag -- 核销状态
            ,balance -- 合同余额
            ,cooperateorgid -- 协办机构编号
            ,mforgid -- 入账机构编号
            ,onbalance -- 表内利息余额
            ,newnpdate -- 最新进入不良日期
            ,expiredate -- 合同到期日
            ,wrightoffbalance -- 核销当日欠息
            ,tmsp -- 时间戳
            ,inputdate -- 登记日期
            ,certid -- 证件号码
            ,businesstype -- 业务品种编号
            ,cooperateusername -- 协办客户经理名称
            ,inputorgid -- 登记机构
            ,assetname -- 资产名称
            ,updateuserid -- 更新人
            ,updatedate -- 更新日期
            ,customerid -- 客户号
            ,businesssum -- 合同金额
            ,yearrate -- 执行年利率
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.contractno, o.contractno) as contractno -- 合同流水号
    ,nvl(n.operateuserid, o.operateuserid) as operateuserid -- 主办机构编号
    ,nvl(n.overdueratefloat, o.overdueratefloat) as overdueratefloat -- 逾期利率浮动比例
    ,nvl(n.assetno, o.assetno) as assetno -- 资产编号
    ,nvl(n.outbalance, o.outbalance) as outbalance -- 表外利息余额
    ,nvl(n.classifyresult, o.classifyresult) as classifyresult -- 风险分类
    ,nvl(n.operateorgid, o.operateorgid) as operateorgid -- 主办客户经理编号
    ,nvl(n.begindate, o.begindate) as begindate -- 合同起始日
    ,nvl(n.rateadjusttype, o.rateadjusttype) as rateadjusttype -- 利率调整方式
    ,nvl(n.signdate, o.signdate) as signdate -- 合同签订日
    ,nvl(n.approvedate, o.approvedate) as approvedate -- 审批通过日
    ,nvl(n.inputuserid, o.inputuserid) as inputuserid -- 登记人
    ,nvl(n.repaytype, o.repaytype) as repaytype -- 还款方式
    ,nvl(n.interestoverdueday, o.interestoverdueday) as interestoverdueday -- 欠息天数
    ,nvl(n.deleteflag, o.deleteflag) as deleteflag -- 删除标志
    ,nvl(n.certtype, o.certtype) as certtype -- 证件类型
    ,nvl(n.interestdate, o.interestdate) as interestdate -- 结息扣款日
    ,nvl(n.resourcesystem, o.resourcesystem) as resourcesystem -- 来源系统
    ,nvl(n.customername, o.customername) as customername -- 客户名称
    ,nvl(n.currency, o.currency) as currency -- 币种
    ,nvl(n.repayno, o.repayno) as repayno -- 还款账号
    ,nvl(n.principaloverdueday, o.principaloverdueday) as principaloverdueday -- 本金逾期天数
    ,nvl(n.updateorgid, o.updateorgid) as updateorgid -- 更新机构
    ,nvl(n.interestcyc, o.interestcyc) as interestcyc -- 结息周期
    ,nvl(n.ratefloattype, o.ratefloattype) as ratefloattype -- 利率浮动类型
    ,nvl(n.ratefloat, o.ratefloat) as ratefloat -- 利率浮动值
    ,nvl(n.cooperateuserid, o.cooperateuserid) as cooperateuserid -- 协办客户经理编号
    ,nvl(n.writeoffflag, o.writeoffflag) as writeoffflag -- 核销状态
    ,nvl(n.balance, o.balance) as balance -- 合同余额
    ,nvl(n.cooperateorgid, o.cooperateorgid) as cooperateorgid -- 协办机构编号
    ,nvl(n.mforgid, o.mforgid) as mforgid -- 入账机构编号
    ,nvl(n.onbalance, o.onbalance) as onbalance -- 表内利息余额
    ,nvl(n.newnpdate, o.newnpdate) as newnpdate -- 最新进入不良日期
    ,nvl(n.expiredate, o.expiredate) as expiredate -- 合同到期日
    ,nvl(n.wrightoffbalance, o.wrightoffbalance) as wrightoffbalance -- 核销当日欠息
    ,nvl(n.tmsp, o.tmsp) as tmsp -- 时间戳
    ,nvl(n.inputdate, o.inputdate) as inputdate -- 登记日期
    ,nvl(n.certid, o.certid) as certid -- 证件号码
    ,nvl(n.businesstype, o.businesstype) as businesstype -- 业务品种编号
    ,nvl(n.cooperateusername, o.cooperateusername) as cooperateusername -- 协办客户经理名称
    ,nvl(n.inputorgid, o.inputorgid) as inputorgid -- 登记机构
    ,nvl(n.assetname, o.assetname) as assetname -- 资产名称
    ,nvl(n.updateuserid, o.updateuserid) as updateuserid -- 更新人
    ,nvl(n.updatedate, o.updatedate) as updatedate -- 更新日期
    ,nvl(n.customerid, o.customerid) as customerid -- 客户号
    ,nvl(n.businesssum, o.businesssum) as businesssum -- 合同金额
    ,nvl(n.yearrate, o.yearrate) as yearrate -- 执行年利率
    ,case when
            n.contractno is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.contractno is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.contractno is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.icms_ap_contract_info_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.icms_ap_contract_info where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.contractno = n.contractno
where (
        o.contractno is null
    )
    or (
        n.contractno is null
    )
    or (
        o.operateuserid <> n.operateuserid
        or o.overdueratefloat <> n.overdueratefloat
        or o.assetno <> n.assetno
        or o.outbalance <> n.outbalance
        or o.classifyresult <> n.classifyresult
        or o.operateorgid <> n.operateorgid
        or o.begindate <> n.begindate
        or o.rateadjusttype <> n.rateadjusttype
        or o.signdate <> n.signdate
        or o.approvedate <> n.approvedate
        or o.inputuserid <> n.inputuserid
        or o.repaytype <> n.repaytype
        or o.interestoverdueday <> n.interestoverdueday
        or o.deleteflag <> n.deleteflag
        or o.certtype <> n.certtype
        or o.interestdate <> n.interestdate
        or o.resourcesystem <> n.resourcesystem
        or o.customername <> n.customername
        or o.currency <> n.currency
        or o.repayno <> n.repayno
        or o.principaloverdueday <> n.principaloverdueday
        or o.updateorgid <> n.updateorgid
        or o.interestcyc <> n.interestcyc
        or o.ratefloattype <> n.ratefloattype
        or o.ratefloat <> n.ratefloat
        or o.cooperateuserid <> n.cooperateuserid
        or o.writeoffflag <> n.writeoffflag
        or o.balance <> n.balance
        or o.cooperateorgid <> n.cooperateorgid
        or o.mforgid <> n.mforgid
        or o.onbalance <> n.onbalance
        or o.newnpdate <> n.newnpdate
        or o.expiredate <> n.expiredate
        or o.wrightoffbalance <> n.wrightoffbalance
        or o.tmsp <> n.tmsp
        or o.inputdate <> n.inputdate
        or o.certid <> n.certid
        or o.businesstype <> n.businesstype
        or o.cooperateusername <> n.cooperateusername
        or o.inputorgid <> n.inputorgid
        or o.assetname <> n.assetname
        or o.updateuserid <> n.updateuserid
        or o.updatedate <> n.updatedate
        or o.customerid <> n.customerid
        or o.businesssum <> n.businesssum
        or o.yearrate <> n.yearrate
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.icms_ap_contract_info_cl(
            contractno -- 合同流水号
            ,operateuserid -- 主办机构编号
            ,overdueratefloat -- 逾期利率浮动比例
            ,assetno -- 资产编号
            ,outbalance -- 表外利息余额
            ,classifyresult -- 风险分类
            ,operateorgid -- 主办客户经理编号
            ,begindate -- 合同起始日
            ,rateadjusttype -- 利率调整方式
            ,signdate -- 合同签订日
            ,approvedate -- 审批通过日
            ,inputuserid -- 登记人
            ,repaytype -- 还款方式
            ,interestoverdueday -- 欠息天数
            ,deleteflag -- 删除标志
            ,certtype -- 证件类型
            ,interestdate -- 结息扣款日
            ,resourcesystem -- 来源系统
            ,customername -- 客户名称
            ,currency -- 币种
            ,repayno -- 还款账号
            ,principaloverdueday -- 本金逾期天数
            ,updateorgid -- 更新机构
            ,interestcyc -- 结息周期
            ,ratefloattype -- 利率浮动类型
            ,ratefloat -- 利率浮动值
            ,cooperateuserid -- 协办客户经理编号
            ,writeoffflag -- 核销状态
            ,balance -- 合同余额
            ,cooperateorgid -- 协办机构编号
            ,mforgid -- 入账机构编号
            ,onbalance -- 表内利息余额
            ,newnpdate -- 最新进入不良日期
            ,expiredate -- 合同到期日
            ,wrightoffbalance -- 核销当日欠息
            ,tmsp -- 时间戳
            ,inputdate -- 登记日期
            ,certid -- 证件号码
            ,businesstype -- 业务品种编号
            ,cooperateusername -- 协办客户经理名称
            ,inputorgid -- 登记机构
            ,assetname -- 资产名称
            ,updateuserid -- 更新人
            ,updatedate -- 更新日期
            ,customerid -- 客户号
            ,businesssum -- 合同金额
            ,yearrate -- 执行年利率
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.icms_ap_contract_info_op(
            contractno -- 合同流水号
            ,operateuserid -- 主办机构编号
            ,overdueratefloat -- 逾期利率浮动比例
            ,assetno -- 资产编号
            ,outbalance -- 表外利息余额
            ,classifyresult -- 风险分类
            ,operateorgid -- 主办客户经理编号
            ,begindate -- 合同起始日
            ,rateadjusttype -- 利率调整方式
            ,signdate -- 合同签订日
            ,approvedate -- 审批通过日
            ,inputuserid -- 登记人
            ,repaytype -- 还款方式
            ,interestoverdueday -- 欠息天数
            ,deleteflag -- 删除标志
            ,certtype -- 证件类型
            ,interestdate -- 结息扣款日
            ,resourcesystem -- 来源系统
            ,customername -- 客户名称
            ,currency -- 币种
            ,repayno -- 还款账号
            ,principaloverdueday -- 本金逾期天数
            ,updateorgid -- 更新机构
            ,interestcyc -- 结息周期
            ,ratefloattype -- 利率浮动类型
            ,ratefloat -- 利率浮动值
            ,cooperateuserid -- 协办客户经理编号
            ,writeoffflag -- 核销状态
            ,balance -- 合同余额
            ,cooperateorgid -- 协办机构编号
            ,mforgid -- 入账机构编号
            ,onbalance -- 表内利息余额
            ,newnpdate -- 最新进入不良日期
            ,expiredate -- 合同到期日
            ,wrightoffbalance -- 核销当日欠息
            ,tmsp -- 时间戳
            ,inputdate -- 登记日期
            ,certid -- 证件号码
            ,businesstype -- 业务品种编号
            ,cooperateusername -- 协办客户经理名称
            ,inputorgid -- 登记机构
            ,assetname -- 资产名称
            ,updateuserid -- 更新人
            ,updatedate -- 更新日期
            ,customerid -- 客户号
            ,businesssum -- 合同金额
            ,yearrate -- 执行年利率
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.contractno -- 合同流水号
    ,o.operateuserid -- 主办机构编号
    ,o.overdueratefloat -- 逾期利率浮动比例
    ,o.assetno -- 资产编号
    ,o.outbalance -- 表外利息余额
    ,o.classifyresult -- 风险分类
    ,o.operateorgid -- 主办客户经理编号
    ,o.begindate -- 合同起始日
    ,o.rateadjusttype -- 利率调整方式
    ,o.signdate -- 合同签订日
    ,o.approvedate -- 审批通过日
    ,o.inputuserid -- 登记人
    ,o.repaytype -- 还款方式
    ,o.interestoverdueday -- 欠息天数
    ,o.deleteflag -- 删除标志
    ,o.certtype -- 证件类型
    ,o.interestdate -- 结息扣款日
    ,o.resourcesystem -- 来源系统
    ,o.customername -- 客户名称
    ,o.currency -- 币种
    ,o.repayno -- 还款账号
    ,o.principaloverdueday -- 本金逾期天数
    ,o.updateorgid -- 更新机构
    ,o.interestcyc -- 结息周期
    ,o.ratefloattype -- 利率浮动类型
    ,o.ratefloat -- 利率浮动值
    ,o.cooperateuserid -- 协办客户经理编号
    ,o.writeoffflag -- 核销状态
    ,o.balance -- 合同余额
    ,o.cooperateorgid -- 协办机构编号
    ,o.mforgid -- 入账机构编号
    ,o.onbalance -- 表内利息余额
    ,o.newnpdate -- 最新进入不良日期
    ,o.expiredate -- 合同到期日
    ,o.wrightoffbalance -- 核销当日欠息
    ,o.tmsp -- 时间戳
    ,o.inputdate -- 登记日期
    ,o.certid -- 证件号码
    ,o.businesstype -- 业务品种编号
    ,o.cooperateusername -- 协办客户经理名称
    ,o.inputorgid -- 登记机构
    ,o.assetname -- 资产名称
    ,o.updateuserid -- 更新人
    ,o.updatedate -- 更新日期
    ,o.customerid -- 客户号
    ,o.businesssum -- 合同金额
    ,o.yearrate -- 执行年利率
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
from ${iol_schema}.icms_ap_contract_info_bk o
    left join ${iol_schema}.icms_ap_contract_info_op n
        on
            o.contractno = n.contractno
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.icms_ap_contract_info_cl d
        on
            o.contractno = d.contractno
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
--truncate table ${iol_schema}.icms_ap_contract_info;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('icms_ap_contract_info') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.icms_ap_contract_info drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.icms_ap_contract_info add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.icms_ap_contract_info exchange partition p_${batch_date} with table ${iol_schema}.icms_ap_contract_info_cl;
alter table ${iol_schema}.icms_ap_contract_info exchange partition p_20991231 with table ${iol_schema}.icms_ap_contract_info_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.icms_ap_contract_info to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.icms_ap_contract_info_op purge;
drop table ${iol_schema}.icms_ap_contract_info_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.icms_ap_contract_info_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'icms_ap_contract_info',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
