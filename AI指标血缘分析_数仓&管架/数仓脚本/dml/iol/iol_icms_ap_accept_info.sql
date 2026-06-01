/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_icms_ap_accept_info
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
create table ${iol_schema}.icms_ap_accept_info_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.icms_ap_accept_info
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.icms_ap_accept_info_op purge;
drop table ${iol_schema}.icms_ap_accept_info_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.icms_ap_accept_info_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.icms_ap_accept_info where 0=1;

create table ${iol_schema}.icms_ap_accept_info_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.icms_ap_accept_info where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.icms_ap_accept_info_cl(
            acceptno -- 受理编号
            ,clearingdate -- 清算组成立日期
            ,bankruptdefendantid -- 破产被申请人编号
            ,thirdparty -- 第三人
            ,overseeresult -- 立案审查结果
            ,acceptorg -- 受理仲裁机构
            ,remark -- 备注
            ,accuserids -- 原告编号
            ,defendant -- 被告
            ,refuseacceptdate -- 不予受理日期
            ,clearingmember -- 清算组成员
            ,acceptcourt -- 受理法院
            ,bankruptcyflag -- 是否破产
            ,defendantids -- 被告人编号
            ,thirdpartyids -- 第三人编号
            ,legaliinstruments -- 起诉状
            ,updateorgid -- 更新机构编号
            ,acceptflag -- 是否受理
            ,caseprogramstage -- 程序阶段
            ,inadmissibleruling -- 不予受理裁定
            ,tmsp -- 时间戳
            ,accuser -- 原告
            ,inputorgid -- 登记机构编号
            ,acceptdate -- 受理日期
            ,bankruptdefendant -- 破产被申请人
            ,inputuserid -- 登记人编号
            ,updatedate -- 更新日期
            ,inputdate -- 登记日期
            ,retrialdecision -- 再审裁定书
            ,bankruptcyapplicant -- 破产申请人
            ,caseid -- 案号
            ,applydate -- 申请日期
            ,arbaccinstrumen -- 仲裁受理文书
            ,caseno -- 关联案件项目编号
            ,saveflag -- 受理信息表保存状态
            ,fileno -- 影像平台编号
            ,acceptnotice -- 受理通知书
            ,retrialtype -- 再审类型
            ,dishonestyflag -- 是否“失信被执行人名单”
            ,highcostflag -- 是否“限制高消费名单”
            ,updateuserid -- 更新人编号
            ,operateusername -- 指定破产管理人名称
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.icms_ap_accept_info_op(
            acceptno -- 受理编号
            ,clearingdate -- 清算组成立日期
            ,bankruptdefendantid -- 破产被申请人编号
            ,thirdparty -- 第三人
            ,overseeresult -- 立案审查结果
            ,acceptorg -- 受理仲裁机构
            ,remark -- 备注
            ,accuserids -- 原告编号
            ,defendant -- 被告
            ,refuseacceptdate -- 不予受理日期
            ,clearingmember -- 清算组成员
            ,acceptcourt -- 受理法院
            ,bankruptcyflag -- 是否破产
            ,defendantids -- 被告人编号
            ,thirdpartyids -- 第三人编号
            ,legaliinstruments -- 起诉状
            ,updateorgid -- 更新机构编号
            ,acceptflag -- 是否受理
            ,caseprogramstage -- 程序阶段
            ,inadmissibleruling -- 不予受理裁定
            ,tmsp -- 时间戳
            ,accuser -- 原告
            ,inputorgid -- 登记机构编号
            ,acceptdate -- 受理日期
            ,bankruptdefendant -- 破产被申请人
            ,inputuserid -- 登记人编号
            ,updatedate -- 更新日期
            ,inputdate -- 登记日期
            ,retrialdecision -- 再审裁定书
            ,bankruptcyapplicant -- 破产申请人
            ,caseid -- 案号
            ,applydate -- 申请日期
            ,arbaccinstrumen -- 仲裁受理文书
            ,caseno -- 关联案件项目编号
            ,saveflag -- 受理信息表保存状态
            ,fileno -- 影像平台编号
            ,acceptnotice -- 受理通知书
            ,retrialtype -- 再审类型
            ,dishonestyflag -- 是否“失信被执行人名单”
            ,highcostflag -- 是否“限制高消费名单”
            ,updateuserid -- 更新人编号
            ,operateusername -- 指定破产管理人名称
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.acceptno, o.acceptno) as acceptno -- 受理编号
    ,nvl(n.clearingdate, o.clearingdate) as clearingdate -- 清算组成立日期
    ,nvl(n.bankruptdefendantid, o.bankruptdefendantid) as bankruptdefendantid -- 破产被申请人编号
    ,nvl(n.thirdparty, o.thirdparty) as thirdparty -- 第三人
    ,nvl(n.overseeresult, o.overseeresult) as overseeresult -- 立案审查结果
    ,nvl(n.acceptorg, o.acceptorg) as acceptorg -- 受理仲裁机构
    ,nvl(n.remark, o.remark) as remark -- 备注
    ,nvl(n.accuserids, o.accuserids) as accuserids -- 原告编号
    ,nvl(n.defendant, o.defendant) as defendant -- 被告
    ,nvl(n.refuseacceptdate, o.refuseacceptdate) as refuseacceptdate -- 不予受理日期
    ,nvl(n.clearingmember, o.clearingmember) as clearingmember -- 清算组成员
    ,nvl(n.acceptcourt, o.acceptcourt) as acceptcourt -- 受理法院
    ,nvl(n.bankruptcyflag, o.bankruptcyflag) as bankruptcyflag -- 是否破产
    ,nvl(n.defendantids, o.defendantids) as defendantids -- 被告人编号
    ,nvl(n.thirdpartyids, o.thirdpartyids) as thirdpartyids -- 第三人编号
    ,nvl(n.legaliinstruments, o.legaliinstruments) as legaliinstruments -- 起诉状
    ,nvl(n.updateorgid, o.updateorgid) as updateorgid -- 更新机构编号
    ,nvl(n.acceptflag, o.acceptflag) as acceptflag -- 是否受理
    ,nvl(n.caseprogramstage, o.caseprogramstage) as caseprogramstage -- 程序阶段
    ,nvl(n.inadmissibleruling, o.inadmissibleruling) as inadmissibleruling -- 不予受理裁定
    ,nvl(n.tmsp, o.tmsp) as tmsp -- 时间戳
    ,nvl(n.accuser, o.accuser) as accuser -- 原告
    ,nvl(n.inputorgid, o.inputorgid) as inputorgid -- 登记机构编号
    ,nvl(n.acceptdate, o.acceptdate) as acceptdate -- 受理日期
    ,nvl(n.bankruptdefendant, o.bankruptdefendant) as bankruptdefendant -- 破产被申请人
    ,nvl(n.inputuserid, o.inputuserid) as inputuserid -- 登记人编号
    ,nvl(n.updatedate, o.updatedate) as updatedate -- 更新日期
    ,nvl(n.inputdate, o.inputdate) as inputdate -- 登记日期
    ,nvl(n.retrialdecision, o.retrialdecision) as retrialdecision -- 再审裁定书
    ,nvl(n.bankruptcyapplicant, o.bankruptcyapplicant) as bankruptcyapplicant -- 破产申请人
    ,nvl(n.caseid, o.caseid) as caseid -- 案号
    ,nvl(n.applydate, o.applydate) as applydate -- 申请日期
    ,nvl(n.arbaccinstrumen, o.arbaccinstrumen) as arbaccinstrumen -- 仲裁受理文书
    ,nvl(n.caseno, o.caseno) as caseno -- 关联案件项目编号
    ,nvl(n.saveflag, o.saveflag) as saveflag -- 受理信息表保存状态
    ,nvl(n.fileno, o.fileno) as fileno -- 影像平台编号
    ,nvl(n.acceptnotice, o.acceptnotice) as acceptnotice -- 受理通知书
    ,nvl(n.retrialtype, o.retrialtype) as retrialtype -- 再审类型
    ,nvl(n.dishonestyflag, o.dishonestyflag) as dishonestyflag -- 是否“失信被执行人名单”
    ,nvl(n.highcostflag, o.highcostflag) as highcostflag -- 是否“限制高消费名单”
    ,nvl(n.updateuserid, o.updateuserid) as updateuserid -- 更新人编号
    ,nvl(n.operateusername, o.operateusername) as operateusername -- 指定破产管理人名称
    ,case when
            n.acceptno is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.acceptno is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.acceptno is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.icms_ap_accept_info_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.icms_ap_accept_info where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.acceptno = n.acceptno
where (
        o.acceptno is null
    )
    or (
        n.acceptno is null
    )
    or (
        o.clearingdate <> n.clearingdate
        or o.bankruptdefendantid <> n.bankruptdefendantid
        or o.thirdparty <> n.thirdparty
        or o.overseeresult <> n.overseeresult
        or o.acceptorg <> n.acceptorg
        or o.remark <> n.remark
        or o.accuserids <> n.accuserids
        or o.defendant <> n.defendant
        or o.refuseacceptdate <> n.refuseacceptdate
        or o.clearingmember <> n.clearingmember
        or o.acceptcourt <> n.acceptcourt
        or o.bankruptcyflag <> n.bankruptcyflag
        or o.defendantids <> n.defendantids
        or o.thirdpartyids <> n.thirdpartyids
        or o.legaliinstruments <> n.legaliinstruments
        or o.updateorgid <> n.updateorgid
        or o.acceptflag <> n.acceptflag
        or o.caseprogramstage <> n.caseprogramstage
        or o.inadmissibleruling <> n.inadmissibleruling
        or o.tmsp <> n.tmsp
        or o.accuser <> n.accuser
        or o.inputorgid <> n.inputorgid
        or o.acceptdate <> n.acceptdate
        or o.bankruptdefendant <> n.bankruptdefendant
        or o.inputuserid <> n.inputuserid
        or o.updatedate <> n.updatedate
        or o.inputdate <> n.inputdate
        or o.retrialdecision <> n.retrialdecision
        or o.bankruptcyapplicant <> n.bankruptcyapplicant
        or o.caseid <> n.caseid
        or o.applydate <> n.applydate
        or o.arbaccinstrumen <> n.arbaccinstrumen
        or o.caseno <> n.caseno
        or o.saveflag <> n.saveflag
        or o.fileno <> n.fileno
        or o.acceptnotice <> n.acceptnotice
        or o.retrialtype <> n.retrialtype
        or o.dishonestyflag <> n.dishonestyflag
        or o.highcostflag <> n.highcostflag
        or o.updateuserid <> n.updateuserid
        or o.operateusername <> n.operateusername
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.icms_ap_accept_info_cl(
            acceptno -- 受理编号
            ,clearingdate -- 清算组成立日期
            ,bankruptdefendantid -- 破产被申请人编号
            ,thirdparty -- 第三人
            ,overseeresult -- 立案审查结果
            ,acceptorg -- 受理仲裁机构
            ,remark -- 备注
            ,accuserids -- 原告编号
            ,defendant -- 被告
            ,refuseacceptdate -- 不予受理日期
            ,clearingmember -- 清算组成员
            ,acceptcourt -- 受理法院
            ,bankruptcyflag -- 是否破产
            ,defendantids -- 被告人编号
            ,thirdpartyids -- 第三人编号
            ,legaliinstruments -- 起诉状
            ,updateorgid -- 更新机构编号
            ,acceptflag -- 是否受理
            ,caseprogramstage -- 程序阶段
            ,inadmissibleruling -- 不予受理裁定
            ,tmsp -- 时间戳
            ,accuser -- 原告
            ,inputorgid -- 登记机构编号
            ,acceptdate -- 受理日期
            ,bankruptdefendant -- 破产被申请人
            ,inputuserid -- 登记人编号
            ,updatedate -- 更新日期
            ,inputdate -- 登记日期
            ,retrialdecision -- 再审裁定书
            ,bankruptcyapplicant -- 破产申请人
            ,caseid -- 案号
            ,applydate -- 申请日期
            ,arbaccinstrumen -- 仲裁受理文书
            ,caseno -- 关联案件项目编号
            ,saveflag -- 受理信息表保存状态
            ,fileno -- 影像平台编号
            ,acceptnotice -- 受理通知书
            ,retrialtype -- 再审类型
            ,dishonestyflag -- 是否“失信被执行人名单”
            ,highcostflag -- 是否“限制高消费名单”
            ,updateuserid -- 更新人编号
            ,operateusername -- 指定破产管理人名称
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.icms_ap_accept_info_op(
            acceptno -- 受理编号
            ,clearingdate -- 清算组成立日期
            ,bankruptdefendantid -- 破产被申请人编号
            ,thirdparty -- 第三人
            ,overseeresult -- 立案审查结果
            ,acceptorg -- 受理仲裁机构
            ,remark -- 备注
            ,accuserids -- 原告编号
            ,defendant -- 被告
            ,refuseacceptdate -- 不予受理日期
            ,clearingmember -- 清算组成员
            ,acceptcourt -- 受理法院
            ,bankruptcyflag -- 是否破产
            ,defendantids -- 被告人编号
            ,thirdpartyids -- 第三人编号
            ,legaliinstruments -- 起诉状
            ,updateorgid -- 更新机构编号
            ,acceptflag -- 是否受理
            ,caseprogramstage -- 程序阶段
            ,inadmissibleruling -- 不予受理裁定
            ,tmsp -- 时间戳
            ,accuser -- 原告
            ,inputorgid -- 登记机构编号
            ,acceptdate -- 受理日期
            ,bankruptdefendant -- 破产被申请人
            ,inputuserid -- 登记人编号
            ,updatedate -- 更新日期
            ,inputdate -- 登记日期
            ,retrialdecision -- 再审裁定书
            ,bankruptcyapplicant -- 破产申请人
            ,caseid -- 案号
            ,applydate -- 申请日期
            ,arbaccinstrumen -- 仲裁受理文书
            ,caseno -- 关联案件项目编号
            ,saveflag -- 受理信息表保存状态
            ,fileno -- 影像平台编号
            ,acceptnotice -- 受理通知书
            ,retrialtype -- 再审类型
            ,dishonestyflag -- 是否“失信被执行人名单”
            ,highcostflag -- 是否“限制高消费名单”
            ,updateuserid -- 更新人编号
            ,operateusername -- 指定破产管理人名称
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.acceptno -- 受理编号
    ,o.clearingdate -- 清算组成立日期
    ,o.bankruptdefendantid -- 破产被申请人编号
    ,o.thirdparty -- 第三人
    ,o.overseeresult -- 立案审查结果
    ,o.acceptorg -- 受理仲裁机构
    ,o.remark -- 备注
    ,o.accuserids -- 原告编号
    ,o.defendant -- 被告
    ,o.refuseacceptdate -- 不予受理日期
    ,o.clearingmember -- 清算组成员
    ,o.acceptcourt -- 受理法院
    ,o.bankruptcyflag -- 是否破产
    ,o.defendantids -- 被告人编号
    ,o.thirdpartyids -- 第三人编号
    ,o.legaliinstruments -- 起诉状
    ,o.updateorgid -- 更新机构编号
    ,o.acceptflag -- 是否受理
    ,o.caseprogramstage -- 程序阶段
    ,o.inadmissibleruling -- 不予受理裁定
    ,o.tmsp -- 时间戳
    ,o.accuser -- 原告
    ,o.inputorgid -- 登记机构编号
    ,o.acceptdate -- 受理日期
    ,o.bankruptdefendant -- 破产被申请人
    ,o.inputuserid -- 登记人编号
    ,o.updatedate -- 更新日期
    ,o.inputdate -- 登记日期
    ,o.retrialdecision -- 再审裁定书
    ,o.bankruptcyapplicant -- 破产申请人
    ,o.caseid -- 案号
    ,o.applydate -- 申请日期
    ,o.arbaccinstrumen -- 仲裁受理文书
    ,o.caseno -- 关联案件项目编号
    ,o.saveflag -- 受理信息表保存状态
    ,o.fileno -- 影像平台编号
    ,o.acceptnotice -- 受理通知书
    ,o.retrialtype -- 再审类型
    ,o.dishonestyflag -- 是否“失信被执行人名单”
    ,o.highcostflag -- 是否“限制高消费名单”
    ,o.updateuserid -- 更新人编号
    ,o.operateusername -- 指定破产管理人名称
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
from ${iol_schema}.icms_ap_accept_info_bk o
    left join ${iol_schema}.icms_ap_accept_info_op n
        on
            o.acceptno = n.acceptno
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.icms_ap_accept_info_cl d
        on
            o.acceptno = d.acceptno
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
--truncate table ${iol_schema}.icms_ap_accept_info;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('icms_ap_accept_info') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.icms_ap_accept_info drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.icms_ap_accept_info add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.icms_ap_accept_info exchange partition p_${batch_date} with table ${iol_schema}.icms_ap_accept_info_cl;
alter table ${iol_schema}.icms_ap_accept_info exchange partition p_20991231 with table ${iol_schema}.icms_ap_accept_info_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.icms_ap_accept_info to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.icms_ap_accept_info_op purge;
drop table ${iol_schema}.icms_ap_accept_info_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.icms_ap_accept_info_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'icms_ap_accept_info',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
