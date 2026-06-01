/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_icms_meeting_inventory
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
create table ${iol_schema}.icms_meeting_inventory_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.icms_meeting_inventory
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.icms_meeting_inventory_op purge;
drop table ${iol_schema}.icms_meeting_inventory_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.icms_meeting_inventory_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.icms_meeting_inventory where 0=1;

create table ${iol_schema}.icms_meeting_inventory_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.icms_meeting_inventory where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.icms_meeting_inventory_cl(
            serialno -- 会议上会清单流水号
            ,meetingserialno -- 关联会议流水号
            ,businessapplyserialno -- 关联授信流水号
            ,declarationorg -- 申报机构
            ,customerid -- 客户编号
            ,customername -- 客户名称
            ,ownershiptype -- 所有制形式
            ,occurtype -- 授信性质
            ,productid -- 额度类型
            ,vouchtype -- 担保方式
            ,businesssum -- 提交上会额度金额
            ,totalsum -- 提交上会敞口金额
            ,termmonth -- 期限
            ,meetingtype -- 会议类型  1-大会 2-小会
            ,firstappruser -- 初审员
            ,reviewuser -- 复审员
            ,attachmentnum -- 附件数量
            ,isonlinevoting -- 是否在线表决
            ,issubmit -- 提交上会
            ,votingstatus -- 表决状态 码表：VotingStatus
            ,submitstatus -- 上会状态 1-待上会 2-已上会
            ,apprconclusion -- 审议结论
            ,remark -- 文字备注
            ,issurestatus -- 确认状态
            ,opinion1 -- 报告汇总意见
            ,opinion2 -- 报告审议意见
            ,meetbelongdept -- 上会业务条线 码值：MeetBelongDept
            ,inputuserid -- 登记人
            ,inputorgid -- 登记机构
            ,inputdate -- 登记时间
            ,updateuserid -- 更新人
            ,updateorgid -- 更新机构
            ,updatedate -- 更新时间
            ,meetingpoolserialno -- 关联任务池流水号
            ,isonlinemeeting -- 是否现场会议（1-是，0-否）
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.icms_meeting_inventory_op(
            serialno -- 会议上会清单流水号
            ,meetingserialno -- 关联会议流水号
            ,businessapplyserialno -- 关联授信流水号
            ,declarationorg -- 申报机构
            ,customerid -- 客户编号
            ,customername -- 客户名称
            ,ownershiptype -- 所有制形式
            ,occurtype -- 授信性质
            ,productid -- 额度类型
            ,vouchtype -- 担保方式
            ,businesssum -- 提交上会额度金额
            ,totalsum -- 提交上会敞口金额
            ,termmonth -- 期限
            ,meetingtype -- 会议类型  1-大会 2-小会
            ,firstappruser -- 初审员
            ,reviewuser -- 复审员
            ,attachmentnum -- 附件数量
            ,isonlinevoting -- 是否在线表决
            ,issubmit -- 提交上会
            ,votingstatus -- 表决状态 码表：VotingStatus
            ,submitstatus -- 上会状态 1-待上会 2-已上会
            ,apprconclusion -- 审议结论
            ,remark -- 文字备注
            ,issurestatus -- 确认状态
            ,opinion1 -- 报告汇总意见
            ,opinion2 -- 报告审议意见
            ,meetbelongdept -- 上会业务条线 码值：MeetBelongDept
            ,inputuserid -- 登记人
            ,inputorgid -- 登记机构
            ,inputdate -- 登记时间
            ,updateuserid -- 更新人
            ,updateorgid -- 更新机构
            ,updatedate -- 更新时间
            ,meetingpoolserialno -- 关联任务池流水号
            ,isonlinemeeting -- 是否现场会议（1-是，0-否）
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.serialno, o.serialno) as serialno -- 会议上会清单流水号
    ,nvl(n.meetingserialno, o.meetingserialno) as meetingserialno -- 关联会议流水号
    ,nvl(n.businessapplyserialno, o.businessapplyserialno) as businessapplyserialno -- 关联授信流水号
    ,nvl(n.declarationorg, o.declarationorg) as declarationorg -- 申报机构
    ,nvl(n.customerid, o.customerid) as customerid -- 客户编号
    ,nvl(n.customername, o.customername) as customername -- 客户名称
    ,nvl(n.ownershiptype, o.ownershiptype) as ownershiptype -- 所有制形式
    ,nvl(n.occurtype, o.occurtype) as occurtype -- 授信性质
    ,nvl(n.productid, o.productid) as productid -- 额度类型
    ,nvl(n.vouchtype, o.vouchtype) as vouchtype -- 担保方式
    ,nvl(n.businesssum, o.businesssum) as businesssum -- 提交上会额度金额
    ,nvl(n.totalsum, o.totalsum) as totalsum -- 提交上会敞口金额
    ,nvl(n.termmonth, o.termmonth) as termmonth -- 期限
    ,nvl(n.meetingtype, o.meetingtype) as meetingtype -- 会议类型  1-大会 2-小会
    ,nvl(n.firstappruser, o.firstappruser) as firstappruser -- 初审员
    ,nvl(n.reviewuser, o.reviewuser) as reviewuser -- 复审员
    ,nvl(n.attachmentnum, o.attachmentnum) as attachmentnum -- 附件数量
    ,nvl(n.isonlinevoting, o.isonlinevoting) as isonlinevoting -- 是否在线表决
    ,nvl(n.issubmit, o.issubmit) as issubmit -- 提交上会
    ,nvl(n.votingstatus, o.votingstatus) as votingstatus -- 表决状态 码表：VotingStatus
    ,nvl(n.submitstatus, o.submitstatus) as submitstatus -- 上会状态 1-待上会 2-已上会
    ,nvl(n.apprconclusion, o.apprconclusion) as apprconclusion -- 审议结论
    ,nvl(n.remark, o.remark) as remark -- 文字备注
    ,nvl(n.issurestatus, o.issurestatus) as issurestatus -- 确认状态
    ,nvl(n.opinion1, o.opinion1) as opinion1 -- 报告汇总意见
    ,nvl(n.opinion2, o.opinion2) as opinion2 -- 报告审议意见
    ,nvl(n.meetbelongdept, o.meetbelongdept) as meetbelongdept -- 上会业务条线 码值：MeetBelongDept
    ,nvl(n.inputuserid, o.inputuserid) as inputuserid -- 登记人
    ,nvl(n.inputorgid, o.inputorgid) as inputorgid -- 登记机构
    ,nvl(n.inputdate, o.inputdate) as inputdate -- 登记时间
    ,nvl(n.updateuserid, o.updateuserid) as updateuserid -- 更新人
    ,nvl(n.updateorgid, o.updateorgid) as updateorgid -- 更新机构
    ,nvl(n.updatedate, o.updatedate) as updatedate -- 更新时间
    ,nvl(n.meetingpoolserialno, o.meetingpoolserialno) as meetingpoolserialno -- 关联任务池流水号
    ,nvl(n.isonlinemeeting, o.isonlinemeeting) as isonlinemeeting -- 是否现场会议（1-是，0-否）
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
from (select * from ${iol_schema}.icms_meeting_inventory_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.icms_meeting_inventory where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.serialno = n.serialno
where (
        o.serialno is null
    )
    or (
        n.serialno is null
    )
    or (
        o.meetingserialno <> n.meetingserialno
        or o.businessapplyserialno <> n.businessapplyserialno
        or o.declarationorg <> n.declarationorg
        or o.customerid <> n.customerid
        or o.customername <> n.customername
        or o.ownershiptype <> n.ownershiptype
        or o.occurtype <> n.occurtype
        or o.productid <> n.productid
        or o.vouchtype <> n.vouchtype
        or o.businesssum <> n.businesssum
        or o.totalsum <> n.totalsum
        or o.termmonth <> n.termmonth
        or o.meetingtype <> n.meetingtype
        or o.firstappruser <> n.firstappruser
        or o.reviewuser <> n.reviewuser
        or o.attachmentnum <> n.attachmentnum
        or o.isonlinevoting <> n.isonlinevoting
        or o.issubmit <> n.issubmit
        or o.votingstatus <> n.votingstatus
        or o.submitstatus <> n.submitstatus
        or o.apprconclusion <> n.apprconclusion
        or o.remark <> n.remark
        or o.issurestatus <> n.issurestatus
        or o.opinion1 <> n.opinion1
        or o.opinion2 <> n.opinion2
        or o.meetbelongdept <> n.meetbelongdept
        or o.inputuserid <> n.inputuserid
        or o.inputorgid <> n.inputorgid
        or o.inputdate <> n.inputdate
        or o.updateuserid <> n.updateuserid
        or o.updateorgid <> n.updateorgid
        or o.updatedate <> n.updatedate
        or o.meetingpoolserialno <> n.meetingpoolserialno
        or o.isonlinemeeting <> n.isonlinemeeting
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.icms_meeting_inventory_cl(
            serialno -- 会议上会清单流水号
            ,meetingserialno -- 关联会议流水号
            ,businessapplyserialno -- 关联授信流水号
            ,declarationorg -- 申报机构
            ,customerid -- 客户编号
            ,customername -- 客户名称
            ,ownershiptype -- 所有制形式
            ,occurtype -- 授信性质
            ,productid -- 额度类型
            ,vouchtype -- 担保方式
            ,businesssum -- 提交上会额度金额
            ,totalsum -- 提交上会敞口金额
            ,termmonth -- 期限
            ,meetingtype -- 会议类型  1-大会 2-小会
            ,firstappruser -- 初审员
            ,reviewuser -- 复审员
            ,attachmentnum -- 附件数量
            ,isonlinevoting -- 是否在线表决
            ,issubmit -- 提交上会
            ,votingstatus -- 表决状态 码表：VotingStatus
            ,submitstatus -- 上会状态 1-待上会 2-已上会
            ,apprconclusion -- 审议结论
            ,remark -- 文字备注
            ,issurestatus -- 确认状态
            ,opinion1 -- 报告汇总意见
            ,opinion2 -- 报告审议意见
            ,meetbelongdept -- 上会业务条线 码值：MeetBelongDept
            ,inputuserid -- 登记人
            ,inputorgid -- 登记机构
            ,inputdate -- 登记时间
            ,updateuserid -- 更新人
            ,updateorgid -- 更新机构
            ,updatedate -- 更新时间
            ,meetingpoolserialno -- 关联任务池流水号
            ,isonlinemeeting -- 是否现场会议（1-是，0-否）
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.icms_meeting_inventory_op(
            serialno -- 会议上会清单流水号
            ,meetingserialno -- 关联会议流水号
            ,businessapplyserialno -- 关联授信流水号
            ,declarationorg -- 申报机构
            ,customerid -- 客户编号
            ,customername -- 客户名称
            ,ownershiptype -- 所有制形式
            ,occurtype -- 授信性质
            ,productid -- 额度类型
            ,vouchtype -- 担保方式
            ,businesssum -- 提交上会额度金额
            ,totalsum -- 提交上会敞口金额
            ,termmonth -- 期限
            ,meetingtype -- 会议类型  1-大会 2-小会
            ,firstappruser -- 初审员
            ,reviewuser -- 复审员
            ,attachmentnum -- 附件数量
            ,isonlinevoting -- 是否在线表决
            ,issubmit -- 提交上会
            ,votingstatus -- 表决状态 码表：VotingStatus
            ,submitstatus -- 上会状态 1-待上会 2-已上会
            ,apprconclusion -- 审议结论
            ,remark -- 文字备注
            ,issurestatus -- 确认状态
            ,opinion1 -- 报告汇总意见
            ,opinion2 -- 报告审议意见
            ,meetbelongdept -- 上会业务条线 码值：MeetBelongDept
            ,inputuserid -- 登记人
            ,inputorgid -- 登记机构
            ,inputdate -- 登记时间
            ,updateuserid -- 更新人
            ,updateorgid -- 更新机构
            ,updatedate -- 更新时间
            ,meetingpoolserialno -- 关联任务池流水号
            ,isonlinemeeting -- 是否现场会议（1-是，0-否）
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.serialno -- 会议上会清单流水号
    ,o.meetingserialno -- 关联会议流水号
    ,o.businessapplyserialno -- 关联授信流水号
    ,o.declarationorg -- 申报机构
    ,o.customerid -- 客户编号
    ,o.customername -- 客户名称
    ,o.ownershiptype -- 所有制形式
    ,o.occurtype -- 授信性质
    ,o.productid -- 额度类型
    ,o.vouchtype -- 担保方式
    ,o.businesssum -- 提交上会额度金额
    ,o.totalsum -- 提交上会敞口金额
    ,o.termmonth -- 期限
    ,o.meetingtype -- 会议类型  1-大会 2-小会
    ,o.firstappruser -- 初审员
    ,o.reviewuser -- 复审员
    ,o.attachmentnum -- 附件数量
    ,o.isonlinevoting -- 是否在线表决
    ,o.issubmit -- 提交上会
    ,o.votingstatus -- 表决状态 码表：VotingStatus
    ,o.submitstatus -- 上会状态 1-待上会 2-已上会
    ,o.apprconclusion -- 审议结论
    ,o.remark -- 文字备注
    ,o.issurestatus -- 确认状态
    ,o.opinion1 -- 报告汇总意见
    ,o.opinion2 -- 报告审议意见
    ,o.meetbelongdept -- 上会业务条线 码值：MeetBelongDept
    ,o.inputuserid -- 登记人
    ,o.inputorgid -- 登记机构
    ,o.inputdate -- 登记时间
    ,o.updateuserid -- 更新人
    ,o.updateorgid -- 更新机构
    ,o.updatedate -- 更新时间
    ,o.meetingpoolserialno -- 关联任务池流水号
    ,o.isonlinemeeting -- 是否现场会议（1-是，0-否）
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
from ${iol_schema}.icms_meeting_inventory_bk o
    left join ${iol_schema}.icms_meeting_inventory_op n
        on
            o.serialno = n.serialno
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.icms_meeting_inventory_cl d
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
--truncate table ${iol_schema}.icms_meeting_inventory;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('icms_meeting_inventory') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.icms_meeting_inventory drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.icms_meeting_inventory add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.icms_meeting_inventory exchange partition p_${batch_date} with table ${iol_schema}.icms_meeting_inventory_cl;
alter table ${iol_schema}.icms_meeting_inventory exchange partition p_20991231 with table ${iol_schema}.icms_meeting_inventory_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.icms_meeting_inventory to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.icms_meeting_inventory_op purge;
drop table ${iol_schema}.icms_meeting_inventory_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.icms_meeting_inventory_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'icms_meeting_inventory',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
