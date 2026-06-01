/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_icms_white_info_edit
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
create table ${iol_schema}.icms_white_info_edit_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.icms_white_info_edit
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.icms_white_info_edit_op purge;
drop table ${iol_schema}.icms_white_info_edit_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.icms_white_info_edit_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.icms_white_info_edit where 0=1;

create table ${iol_schema}.icms_white_info_edit_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.icms_white_info_edit where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.icms_white_info_edit_cl(
            serialno -- 白名单修改编号
            ,issinosureaccount -- 是否信保客户
            ,singleputsum -- 单笔自动化出账金额上限
            ,teamputsum -- 团队长审批金额上限
            ,firstpayratio -- 首付款比例%
            ,serialnowf -- 白名单编号
            ,orgshort -- 机构中文简称
            ,isfirstpay -- 是否首付款1是2否
            ,inputuserid -- 登记员工编号
            ,editstatus -- 修改状态
            ,totolsum -- 额度上限
            ,attribute2 -- 保证金账户名称
            ,attribute4 -- 
            ,isbelongterm -- 是否靠档计息
            ,customername -- 客户名称
            ,sinosureaccount -- 受托支付账户账户
            ,maturity -- 有效到期日
            ,migtflag -- 迁移标志：crsrcrilcupl
            ,customerid -- 客户号
            ,bypassaccount -- 保证金子户
            ,adristtype -- 结息方式
            ,iscitecon -- 流贷合同
            ,repaytype -- 还款方式
            ,attribute1 -- 渠道
            ,riskcapitalassesstype -- 风险资本考核方式,码值:RiskCapitalAssessType,M:按月,S:按季
            ,attribute3 -- 
            ,inputdate -- 登记时间
            ,fixedrate -- 固定利率
            ,inputorgid -- 登记机构编号
            ,sinosurebillaccount -- 信保保证金账户
            ,sinosurename -- 受托支付账户名称
            ,maxloanterm -- 单笔最长贷款期限
            ,status -- 状态
            ,interestrepaycycle -- 结息频率-ICCycN
            ,relativeno -- 关联名单流水号
            ,tasktype -- 任务类型
            ,updatedate -- 更新时间
            ,updateorgid -- 更新机构编号
            ,updateuserid -- 更新用户编号
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.icms_white_info_edit_op(
            serialno -- 白名单修改编号
            ,issinosureaccount -- 是否信保客户
            ,singleputsum -- 单笔自动化出账金额上限
            ,teamputsum -- 团队长审批金额上限
            ,firstpayratio -- 首付款比例%
            ,serialnowf -- 白名单编号
            ,orgshort -- 机构中文简称
            ,isfirstpay -- 是否首付款1是2否
            ,inputuserid -- 登记员工编号
            ,editstatus -- 修改状态
            ,totolsum -- 额度上限
            ,attribute2 -- 保证金账户名称
            ,attribute4 -- 
            ,isbelongterm -- 是否靠档计息
            ,customername -- 客户名称
            ,sinosureaccount -- 受托支付账户账户
            ,maturity -- 有效到期日
            ,migtflag -- 迁移标志：crsrcrilcupl
            ,customerid -- 客户号
            ,bypassaccount -- 保证金子户
            ,adristtype -- 结息方式
            ,iscitecon -- 流贷合同
            ,repaytype -- 还款方式
            ,attribute1 -- 渠道
            ,riskcapitalassesstype -- 风险资本考核方式,码值:RiskCapitalAssessType,M:按月,S:按季
            ,attribute3 -- 
            ,inputdate -- 登记时间
            ,fixedrate -- 固定利率
            ,inputorgid -- 登记机构编号
            ,sinosurebillaccount -- 信保保证金账户
            ,sinosurename -- 受托支付账户名称
            ,maxloanterm -- 单笔最长贷款期限
            ,status -- 状态
            ,interestrepaycycle -- 结息频率-ICCycN
            ,relativeno -- 关联名单流水号
            ,tasktype -- 任务类型
            ,updatedate -- 更新时间
            ,updateorgid -- 更新机构编号
            ,updateuserid -- 更新用户编号
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.serialno, o.serialno) as serialno -- 白名单修改编号
    ,nvl(n.issinosureaccount, o.issinosureaccount) as issinosureaccount -- 是否信保客户
    ,nvl(n.singleputsum, o.singleputsum) as singleputsum -- 单笔自动化出账金额上限
    ,nvl(n.teamputsum, o.teamputsum) as teamputsum -- 团队长审批金额上限
    ,nvl(n.firstpayratio, o.firstpayratio) as firstpayratio -- 首付款比例%
    ,nvl(n.serialnowf, o.serialnowf) as serialnowf -- 白名单编号
    ,nvl(n.orgshort, o.orgshort) as orgshort -- 机构中文简称
    ,nvl(n.isfirstpay, o.isfirstpay) as isfirstpay -- 是否首付款1是2否
    ,nvl(n.inputuserid, o.inputuserid) as inputuserid -- 登记员工编号
    ,nvl(n.editstatus, o.editstatus) as editstatus -- 修改状态
    ,nvl(n.totolsum, o.totolsum) as totolsum -- 额度上限
    ,nvl(n.attribute2, o.attribute2) as attribute2 -- 保证金账户名称
    ,nvl(n.attribute4, o.attribute4) as attribute4 -- 
    ,nvl(n.isbelongterm, o.isbelongterm) as isbelongterm -- 是否靠档计息
    ,nvl(n.customername, o.customername) as customername -- 客户名称
    ,nvl(n.sinosureaccount, o.sinosureaccount) as sinosureaccount -- 受托支付账户账户
    ,nvl(n.maturity, o.maturity) as maturity -- 有效到期日
    ,nvl(n.migtflag, o.migtflag) as migtflag -- 迁移标志：crsrcrilcupl
    ,nvl(n.customerid, o.customerid) as customerid -- 客户号
    ,nvl(n.bypassaccount, o.bypassaccount) as bypassaccount -- 保证金子户
    ,nvl(n.adristtype, o.adristtype) as adristtype -- 结息方式
    ,nvl(n.iscitecon, o.iscitecon) as iscitecon -- 流贷合同
    ,nvl(n.repaytype, o.repaytype) as repaytype -- 还款方式
    ,nvl(n.attribute1, o.attribute1) as attribute1 -- 渠道
    ,nvl(n.riskcapitalassesstype, o.riskcapitalassesstype) as riskcapitalassesstype -- 风险资本考核方式,码值:RiskCapitalAssessType,M:按月,S:按季
    ,nvl(n.attribute3, o.attribute3) as attribute3 -- 
    ,nvl(n.inputdate, o.inputdate) as inputdate -- 登记时间
    ,nvl(n.fixedrate, o.fixedrate) as fixedrate -- 固定利率
    ,nvl(n.inputorgid, o.inputorgid) as inputorgid -- 登记机构编号
    ,nvl(n.sinosurebillaccount, o.sinosurebillaccount) as sinosurebillaccount -- 信保保证金账户
    ,nvl(n.sinosurename, o.sinosurename) as sinosurename -- 受托支付账户名称
    ,nvl(n.maxloanterm, o.maxloanterm) as maxloanterm -- 单笔最长贷款期限
    ,nvl(n.status, o.status) as status -- 状态
    ,nvl(n.interestrepaycycle, o.interestrepaycycle) as interestrepaycycle -- 结息频率-ICCycN
    ,nvl(n.relativeno, o.relativeno) as relativeno -- 关联名单流水号
    ,nvl(n.tasktype, o.tasktype) as tasktype -- 任务类型
    ,nvl(n.updatedate, o.updatedate) as updatedate -- 更新时间
    ,nvl(n.updateorgid, o.updateorgid) as updateorgid -- 更新机构编号
    ,nvl(n.updateuserid, o.updateuserid) as updateuserid -- 更新用户编号
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
from (select * from ${iol_schema}.icms_white_info_edit_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.icms_white_info_edit where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.serialno = n.serialno
where (
        o.serialno is null
    )
    or (
        n.serialno is null
    )
    or (
        o.issinosureaccount <> n.issinosureaccount
        or o.singleputsum <> n.singleputsum
        or o.teamputsum <> n.teamputsum
        or o.firstpayratio <> n.firstpayratio
        or o.serialnowf <> n.serialnowf
        or o.orgshort <> n.orgshort
        or o.isfirstpay <> n.isfirstpay
        or o.inputuserid <> n.inputuserid
        or o.editstatus <> n.editstatus
        or o.totolsum <> n.totolsum
        or o.attribute2 <> n.attribute2
        or o.attribute4 <> n.attribute4
        or o.isbelongterm <> n.isbelongterm
        or o.customername <> n.customername
        or o.sinosureaccount <> n.sinosureaccount
        or o.maturity <> n.maturity
        or o.migtflag <> n.migtflag
        or o.customerid <> n.customerid
        or o.bypassaccount <> n.bypassaccount
        or o.adristtype <> n.adristtype
        or o.iscitecon <> n.iscitecon
        or o.repaytype <> n.repaytype
        or o.attribute1 <> n.attribute1
        or o.riskcapitalassesstype <> n.riskcapitalassesstype
        or o.attribute3 <> n.attribute3
        or o.inputdate <> n.inputdate
        or o.fixedrate <> n.fixedrate
        or o.inputorgid <> n.inputorgid
        or o.sinosurebillaccount <> n.sinosurebillaccount
        or o.sinosurename <> n.sinosurename
        or o.maxloanterm <> n.maxloanterm
        or o.status <> n.status
        or o.interestrepaycycle <> n.interestrepaycycle
        or o.relativeno <> n.relativeno
        or o.tasktype <> n.tasktype
        or o.updatedate <> n.updatedate
        or o.updateorgid <> n.updateorgid
        or o.updateuserid <> n.updateuserid
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.icms_white_info_edit_cl(
            serialno -- 白名单修改编号
            ,issinosureaccount -- 是否信保客户
            ,singleputsum -- 单笔自动化出账金额上限
            ,teamputsum -- 团队长审批金额上限
            ,firstpayratio -- 首付款比例%
            ,serialnowf -- 白名单编号
            ,orgshort -- 机构中文简称
            ,isfirstpay -- 是否首付款1是2否
            ,inputuserid -- 登记员工编号
            ,editstatus -- 修改状态
            ,totolsum -- 额度上限
            ,attribute2 -- 保证金账户名称
            ,attribute4 -- 
            ,isbelongterm -- 是否靠档计息
            ,customername -- 客户名称
            ,sinosureaccount -- 受托支付账户账户
            ,maturity -- 有效到期日
            ,migtflag -- 迁移标志：crsrcrilcupl
            ,customerid -- 客户号
            ,bypassaccount -- 保证金子户
            ,adristtype -- 结息方式
            ,iscitecon -- 流贷合同
            ,repaytype -- 还款方式
            ,attribute1 -- 渠道
            ,riskcapitalassesstype -- 风险资本考核方式,码值:RiskCapitalAssessType,M:按月,S:按季
            ,attribute3 -- 
            ,inputdate -- 登记时间
            ,fixedrate -- 固定利率
            ,inputorgid -- 登记机构编号
            ,sinosurebillaccount -- 信保保证金账户
            ,sinosurename -- 受托支付账户名称
            ,maxloanterm -- 单笔最长贷款期限
            ,status -- 状态
            ,interestrepaycycle -- 结息频率-ICCycN
            ,relativeno -- 关联名单流水号
            ,tasktype -- 任务类型
            ,updatedate -- 更新时间
            ,updateorgid -- 更新机构编号
            ,updateuserid -- 更新用户编号
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.icms_white_info_edit_op(
            serialno -- 白名单修改编号
            ,issinosureaccount -- 是否信保客户
            ,singleputsum -- 单笔自动化出账金额上限
            ,teamputsum -- 团队长审批金额上限
            ,firstpayratio -- 首付款比例%
            ,serialnowf -- 白名单编号
            ,orgshort -- 机构中文简称
            ,isfirstpay -- 是否首付款1是2否
            ,inputuserid -- 登记员工编号
            ,editstatus -- 修改状态
            ,totolsum -- 额度上限
            ,attribute2 -- 保证金账户名称
            ,attribute4 -- 
            ,isbelongterm -- 是否靠档计息
            ,customername -- 客户名称
            ,sinosureaccount -- 受托支付账户账户
            ,maturity -- 有效到期日
            ,migtflag -- 迁移标志：crsrcrilcupl
            ,customerid -- 客户号
            ,bypassaccount -- 保证金子户
            ,adristtype -- 结息方式
            ,iscitecon -- 流贷合同
            ,repaytype -- 还款方式
            ,attribute1 -- 渠道
            ,riskcapitalassesstype -- 风险资本考核方式,码值:RiskCapitalAssessType,M:按月,S:按季
            ,attribute3 -- 
            ,inputdate -- 登记时间
            ,fixedrate -- 固定利率
            ,inputorgid -- 登记机构编号
            ,sinosurebillaccount -- 信保保证金账户
            ,sinosurename -- 受托支付账户名称
            ,maxloanterm -- 单笔最长贷款期限
            ,status -- 状态
            ,interestrepaycycle -- 结息频率-ICCycN
            ,relativeno -- 关联名单流水号
            ,tasktype -- 任务类型
            ,updatedate -- 更新时间
            ,updateorgid -- 更新机构编号
            ,updateuserid -- 更新用户编号
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.serialno -- 白名单修改编号
    ,o.issinosureaccount -- 是否信保客户
    ,o.singleputsum -- 单笔自动化出账金额上限
    ,o.teamputsum -- 团队长审批金额上限
    ,o.firstpayratio -- 首付款比例%
    ,o.serialnowf -- 白名单编号
    ,o.orgshort -- 机构中文简称
    ,o.isfirstpay -- 是否首付款1是2否
    ,o.inputuserid -- 登记员工编号
    ,o.editstatus -- 修改状态
    ,o.totolsum -- 额度上限
    ,o.attribute2 -- 保证金账户名称
    ,o.attribute4 -- 
    ,o.isbelongterm -- 是否靠档计息
    ,o.customername -- 客户名称
    ,o.sinosureaccount -- 受托支付账户账户
    ,o.maturity -- 有效到期日
    ,o.migtflag -- 迁移标志：crsrcrilcupl
    ,o.customerid -- 客户号
    ,o.bypassaccount -- 保证金子户
    ,o.adristtype -- 结息方式
    ,o.iscitecon -- 流贷合同
    ,o.repaytype -- 还款方式
    ,o.attribute1 -- 渠道
    ,o.riskcapitalassesstype -- 风险资本考核方式,码值:RiskCapitalAssessType,M:按月,S:按季
    ,o.attribute3 -- 
    ,o.inputdate -- 登记时间
    ,o.fixedrate -- 固定利率
    ,o.inputorgid -- 登记机构编号
    ,o.sinosurebillaccount -- 信保保证金账户
    ,o.sinosurename -- 受托支付账户名称
    ,o.maxloanterm -- 单笔最长贷款期限
    ,o.status -- 状态
    ,o.interestrepaycycle -- 结息频率-ICCycN
    ,o.relativeno -- 关联名单流水号
    ,o.tasktype -- 任务类型
    ,o.updatedate -- 更新时间
    ,o.updateorgid -- 更新机构编号
    ,o.updateuserid -- 更新用户编号
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
from ${iol_schema}.icms_white_info_edit_bk o
    left join ${iol_schema}.icms_white_info_edit_op n
        on
            o.serialno = n.serialno
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.icms_white_info_edit_cl d
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
--truncate table ${iol_schema}.icms_white_info_edit;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('icms_white_info_edit') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.icms_white_info_edit drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.icms_white_info_edit add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.icms_white_info_edit exchange partition p_${batch_date} with table ${iol_schema}.icms_white_info_edit_cl;
alter table ${iol_schema}.icms_white_info_edit exchange partition p_20991231 with table ${iol_schema}.icms_white_info_edit_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.icms_white_info_edit to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.icms_white_info_edit_op purge;
drop table ${iol_schema}.icms_white_info_edit_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.icms_white_info_edit_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'icms_white_info_edit',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
