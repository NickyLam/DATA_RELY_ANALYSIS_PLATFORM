/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_icms_impoversee_info
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
create table ${iol_schema}.icms_impoversee_info_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.icms_impoversee_info
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.icms_impoversee_info_op purge;
drop table ${iol_schema}.icms_impoversee_info_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.icms_impoversee_info_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.icms_impoversee_info where 0=1;

create table ${iol_schema}.icms_impoversee_info_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.icms_impoversee_info where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.icms_impoversee_info_cl(
            serialno -- 流水号
            ,customerid -- 客户编号
            ,validstatus -- 状态010有效020失效
            ,updatedate -- 更新日期
            ,delflag -- 删除标志(1-已删除)
            ,inputdate -- 申请日期
            ,customername -- 客户名称
            ,logofftype -- 退出方式
            ,validdate -- 生效日期
            ,otherinreason -- 其他进入原因
            ,delorgid -- 删除机构
            ,migtflag -- 
            ,passlevel -- 批准机构级别010总行批准020分行批准
            ,capacitytype -- 认定方式010直接认定020流程认定
            ,currentprocessstatus -- 当前流程状态：ToFinished-待完成ToConfirm-待确认HasConfirm-已确认
            ,approvebusinesssum -- 申请时批复授信金额
            ,approvestatus -- 审批状态
            ,isimpcustomerflag -- 是否为重点监测客户
            ,inputuserid -- 登记人
            ,inputorgid -- 登记机构编号
            ,addflag -- 新增标志010人工新增020批量新增
            ,inreason -- 进入原因
            ,passorgid -- 批准机构
            ,risklevel -- 风险级别
            ,updateuserid -- 更新人编号
            ,inapplybusinessbalance -- 进入时授信余额
            ,quitereason -- 退出原因
            ,deluserid -- 删除用户
            ,currentapplytype -- 当前申请类型：ApplyIn-申请进入ApplyOut-申请退出
            ,updateorgid -- 更新机构编号
            ,inapproveexposuresum -- 进入时批复敞口金额
            ,levelmanage -- 层级管理010总行020分行030支行/团队
            ,relativeserailno -- 关联的申请流水
            ,inapplyexposurebalance -- 进入时敞口余额
            ,logoffdescript -- 退出措施
            ,manageuserid -- 管户人
            ,passuserid -- 批准人
            ,quitedate -- 退出日期
            ,inapprovebusinesssum -- 进入时批复授信金额
            ,manageorgid -- 管户机构
            ,deldate -- 删除日期
            ,approveexposuresum -- 申请时批复敞口金额
            ,customertype -- 客户类型01公司客户02集团客户03个人客户0310个人客户0320个体经营户
            ,applybusinessbalance -- 申请时授信余额
            ,applyexposurebalance -- 申请时敞口余额
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.icms_impoversee_info_op(
            serialno -- 流水号
            ,customerid -- 客户编号
            ,validstatus -- 状态010有效020失效
            ,updatedate -- 更新日期
            ,delflag -- 删除标志(1-已删除)
            ,inputdate -- 申请日期
            ,customername -- 客户名称
            ,logofftype -- 退出方式
            ,validdate -- 生效日期
            ,otherinreason -- 其他进入原因
            ,delorgid -- 删除机构
            ,migtflag -- 
            ,passlevel -- 批准机构级别010总行批准020分行批准
            ,capacitytype -- 认定方式010直接认定020流程认定
            ,currentprocessstatus -- 当前流程状态：ToFinished-待完成ToConfirm-待确认HasConfirm-已确认
            ,approvebusinesssum -- 申请时批复授信金额
            ,approvestatus -- 审批状态
            ,isimpcustomerflag -- 是否为重点监测客户
            ,inputuserid -- 登记人
            ,inputorgid -- 登记机构编号
            ,addflag -- 新增标志010人工新增020批量新增
            ,inreason -- 进入原因
            ,passorgid -- 批准机构
            ,risklevel -- 风险级别
            ,updateuserid -- 更新人编号
            ,inapplybusinessbalance -- 进入时授信余额
            ,quitereason -- 退出原因
            ,deluserid -- 删除用户
            ,currentapplytype -- 当前申请类型：ApplyIn-申请进入ApplyOut-申请退出
            ,updateorgid -- 更新机构编号
            ,inapproveexposuresum -- 进入时批复敞口金额
            ,levelmanage -- 层级管理010总行020分行030支行/团队
            ,relativeserailno -- 关联的申请流水
            ,inapplyexposurebalance -- 进入时敞口余额
            ,logoffdescript -- 退出措施
            ,manageuserid -- 管户人
            ,passuserid -- 批准人
            ,quitedate -- 退出日期
            ,inapprovebusinesssum -- 进入时批复授信金额
            ,manageorgid -- 管户机构
            ,deldate -- 删除日期
            ,approveexposuresum -- 申请时批复敞口金额
            ,customertype -- 客户类型01公司客户02集团客户03个人客户0310个人客户0320个体经营户
            ,applybusinessbalance -- 申请时授信余额
            ,applyexposurebalance -- 申请时敞口余额
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.serialno, o.serialno) as serialno -- 流水号
    ,nvl(n.customerid, o.customerid) as customerid -- 客户编号
    ,nvl(n.validstatus, o.validstatus) as validstatus -- 状态010有效020失效
    ,nvl(n.updatedate, o.updatedate) as updatedate -- 更新日期
    ,nvl(n.delflag, o.delflag) as delflag -- 删除标志(1-已删除)
    ,nvl(n.inputdate, o.inputdate) as inputdate -- 申请日期
    ,nvl(n.customername, o.customername) as customername -- 客户名称
    ,nvl(n.logofftype, o.logofftype) as logofftype -- 退出方式
    ,nvl(n.validdate, o.validdate) as validdate -- 生效日期
    ,nvl(n.otherinreason, o.otherinreason) as otherinreason -- 其他进入原因
    ,nvl(n.delorgid, o.delorgid) as delorgid -- 删除机构
    ,nvl(n.migtflag, o.migtflag) as migtflag -- 
    ,nvl(n.passlevel, o.passlevel) as passlevel -- 批准机构级别010总行批准020分行批准
    ,nvl(n.capacitytype, o.capacitytype) as capacitytype -- 认定方式010直接认定020流程认定
    ,nvl(n.currentprocessstatus, o.currentprocessstatus) as currentprocessstatus -- 当前流程状态：ToFinished-待完成ToConfirm-待确认HasConfirm-已确认
    ,nvl(n.approvebusinesssum, o.approvebusinesssum) as approvebusinesssum -- 申请时批复授信金额
    ,nvl(n.approvestatus, o.approvestatus) as approvestatus -- 审批状态
    ,nvl(n.isimpcustomerflag, o.isimpcustomerflag) as isimpcustomerflag -- 是否为重点监测客户
    ,nvl(n.inputuserid, o.inputuserid) as inputuserid -- 登记人
    ,nvl(n.inputorgid, o.inputorgid) as inputorgid -- 登记机构编号
    ,nvl(n.addflag, o.addflag) as addflag -- 新增标志010人工新增020批量新增
    ,nvl(n.inreason, o.inreason) as inreason -- 进入原因
    ,nvl(n.passorgid, o.passorgid) as passorgid -- 批准机构
    ,nvl(n.risklevel, o.risklevel) as risklevel -- 风险级别
    ,nvl(n.updateuserid, o.updateuserid) as updateuserid -- 更新人编号
    ,nvl(n.inapplybusinessbalance, o.inapplybusinessbalance) as inapplybusinessbalance -- 进入时授信余额
    ,nvl(n.quitereason, o.quitereason) as quitereason -- 退出原因
    ,nvl(n.deluserid, o.deluserid) as deluserid -- 删除用户
    ,nvl(n.currentapplytype, o.currentapplytype) as currentapplytype -- 当前申请类型：ApplyIn-申请进入ApplyOut-申请退出
    ,nvl(n.updateorgid, o.updateorgid) as updateorgid -- 更新机构编号
    ,nvl(n.inapproveexposuresum, o.inapproveexposuresum) as inapproveexposuresum -- 进入时批复敞口金额
    ,nvl(n.levelmanage, o.levelmanage) as levelmanage -- 层级管理010总行020分行030支行/团队
    ,nvl(n.relativeserailno, o.relativeserailno) as relativeserailno -- 关联的申请流水
    ,nvl(n.inapplyexposurebalance, o.inapplyexposurebalance) as inapplyexposurebalance -- 进入时敞口余额
    ,nvl(n.logoffdescript, o.logoffdescript) as logoffdescript -- 退出措施
    ,nvl(n.manageuserid, o.manageuserid) as manageuserid -- 管户人
    ,nvl(n.passuserid, o.passuserid) as passuserid -- 批准人
    ,nvl(n.quitedate, o.quitedate) as quitedate -- 退出日期
    ,nvl(n.inapprovebusinesssum, o.inapprovebusinesssum) as inapprovebusinesssum -- 进入时批复授信金额
    ,nvl(n.manageorgid, o.manageorgid) as manageorgid -- 管户机构
    ,nvl(n.deldate, o.deldate) as deldate -- 删除日期
    ,nvl(n.approveexposuresum, o.approveexposuresum) as approveexposuresum -- 申请时批复敞口金额
    ,nvl(n.customertype, o.customertype) as customertype -- 客户类型01公司客户02集团客户03个人客户0310个人客户0320个体经营户
    ,nvl(n.applybusinessbalance, o.applybusinessbalance) as applybusinessbalance -- 申请时授信余额
    ,nvl(n.applyexposurebalance, o.applyexposurebalance) as applyexposurebalance -- 申请时敞口余额
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
from (select * from ${iol_schema}.icms_impoversee_info_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.icms_impoversee_info where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.serialno = n.serialno
where (
        o.serialno is null
    )
    or (
        n.serialno is null
    )
    or (
        o.customerid <> n.customerid
        or o.validstatus <> n.validstatus
        or o.updatedate <> n.updatedate
        or o.delflag <> n.delflag
        or o.inputdate <> n.inputdate
        or o.customername <> n.customername
        or o.logofftype <> n.logofftype
        or o.validdate <> n.validdate
        or o.otherinreason <> n.otherinreason
        or o.delorgid <> n.delorgid
        or o.migtflag <> n.migtflag
        or o.passlevel <> n.passlevel
        or o.capacitytype <> n.capacitytype
        or o.currentprocessstatus <> n.currentprocessstatus
        or o.approvebusinesssum <> n.approvebusinesssum
        or o.approvestatus <> n.approvestatus
        or o.isimpcustomerflag <> n.isimpcustomerflag
        or o.inputuserid <> n.inputuserid
        or o.inputorgid <> n.inputorgid
        or o.addflag <> n.addflag
        or o.inreason <> n.inreason
        or o.passorgid <> n.passorgid
        or o.risklevel <> n.risklevel
        or o.updateuserid <> n.updateuserid
        or o.inapplybusinessbalance <> n.inapplybusinessbalance
        or o.quitereason <> n.quitereason
        or o.deluserid <> n.deluserid
        or o.currentapplytype <> n.currentapplytype
        or o.updateorgid <> n.updateorgid
        or o.inapproveexposuresum <> n.inapproveexposuresum
        or o.levelmanage <> n.levelmanage
        or o.relativeserailno <> n.relativeserailno
        or o.inapplyexposurebalance <> n.inapplyexposurebalance
        or o.logoffdescript <> n.logoffdescript
        or o.manageuserid <> n.manageuserid
        or o.passuserid <> n.passuserid
        or o.quitedate <> n.quitedate
        or o.inapprovebusinesssum <> n.inapprovebusinesssum
        or o.manageorgid <> n.manageorgid
        or o.deldate <> n.deldate
        or o.approveexposuresum <> n.approveexposuresum
        or o.customertype <> n.customertype
        or o.applybusinessbalance <> n.applybusinessbalance
        or o.applyexposurebalance <> n.applyexposurebalance
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.icms_impoversee_info_cl(
            serialno -- 流水号
            ,customerid -- 客户编号
            ,validstatus -- 状态010有效020失效
            ,updatedate -- 更新日期
            ,delflag -- 删除标志(1-已删除)
            ,inputdate -- 申请日期
            ,customername -- 客户名称
            ,logofftype -- 退出方式
            ,validdate -- 生效日期
            ,otherinreason -- 其他进入原因
            ,delorgid -- 删除机构
            ,migtflag -- 
            ,passlevel -- 批准机构级别010总行批准020分行批准
            ,capacitytype -- 认定方式010直接认定020流程认定
            ,currentprocessstatus -- 当前流程状态：ToFinished-待完成ToConfirm-待确认HasConfirm-已确认
            ,approvebusinesssum -- 申请时批复授信金额
            ,approvestatus -- 审批状态
            ,isimpcustomerflag -- 是否为重点监测客户
            ,inputuserid -- 登记人
            ,inputorgid -- 登记机构编号
            ,addflag -- 新增标志010人工新增020批量新增
            ,inreason -- 进入原因
            ,passorgid -- 批准机构
            ,risklevel -- 风险级别
            ,updateuserid -- 更新人编号
            ,inapplybusinessbalance -- 进入时授信余额
            ,quitereason -- 退出原因
            ,deluserid -- 删除用户
            ,currentapplytype -- 当前申请类型：ApplyIn-申请进入ApplyOut-申请退出
            ,updateorgid -- 更新机构编号
            ,inapproveexposuresum -- 进入时批复敞口金额
            ,levelmanage -- 层级管理010总行020分行030支行/团队
            ,relativeserailno -- 关联的申请流水
            ,inapplyexposurebalance -- 进入时敞口余额
            ,logoffdescript -- 退出措施
            ,manageuserid -- 管户人
            ,passuserid -- 批准人
            ,quitedate -- 退出日期
            ,inapprovebusinesssum -- 进入时批复授信金额
            ,manageorgid -- 管户机构
            ,deldate -- 删除日期
            ,approveexposuresum -- 申请时批复敞口金额
            ,customertype -- 客户类型01公司客户02集团客户03个人客户0310个人客户0320个体经营户
            ,applybusinessbalance -- 申请时授信余额
            ,applyexposurebalance -- 申请时敞口余额
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.icms_impoversee_info_op(
            serialno -- 流水号
            ,customerid -- 客户编号
            ,validstatus -- 状态010有效020失效
            ,updatedate -- 更新日期
            ,delflag -- 删除标志(1-已删除)
            ,inputdate -- 申请日期
            ,customername -- 客户名称
            ,logofftype -- 退出方式
            ,validdate -- 生效日期
            ,otherinreason -- 其他进入原因
            ,delorgid -- 删除机构
            ,migtflag -- 
            ,passlevel -- 批准机构级别010总行批准020分行批准
            ,capacitytype -- 认定方式010直接认定020流程认定
            ,currentprocessstatus -- 当前流程状态：ToFinished-待完成ToConfirm-待确认HasConfirm-已确认
            ,approvebusinesssum -- 申请时批复授信金额
            ,approvestatus -- 审批状态
            ,isimpcustomerflag -- 是否为重点监测客户
            ,inputuserid -- 登记人
            ,inputorgid -- 登记机构编号
            ,addflag -- 新增标志010人工新增020批量新增
            ,inreason -- 进入原因
            ,passorgid -- 批准机构
            ,risklevel -- 风险级别
            ,updateuserid -- 更新人编号
            ,inapplybusinessbalance -- 进入时授信余额
            ,quitereason -- 退出原因
            ,deluserid -- 删除用户
            ,currentapplytype -- 当前申请类型：ApplyIn-申请进入ApplyOut-申请退出
            ,updateorgid -- 更新机构编号
            ,inapproveexposuresum -- 进入时批复敞口金额
            ,levelmanage -- 层级管理010总行020分行030支行/团队
            ,relativeserailno -- 关联的申请流水
            ,inapplyexposurebalance -- 进入时敞口余额
            ,logoffdescript -- 退出措施
            ,manageuserid -- 管户人
            ,passuserid -- 批准人
            ,quitedate -- 退出日期
            ,inapprovebusinesssum -- 进入时批复授信金额
            ,manageorgid -- 管户机构
            ,deldate -- 删除日期
            ,approveexposuresum -- 申请时批复敞口金额
            ,customertype -- 客户类型01公司客户02集团客户03个人客户0310个人客户0320个体经营户
            ,applybusinessbalance -- 申请时授信余额
            ,applyexposurebalance -- 申请时敞口余额
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.serialno -- 流水号
    ,o.customerid -- 客户编号
    ,o.validstatus -- 状态010有效020失效
    ,o.updatedate -- 更新日期
    ,o.delflag -- 删除标志(1-已删除)
    ,o.inputdate -- 申请日期
    ,o.customername -- 客户名称
    ,o.logofftype -- 退出方式
    ,o.validdate -- 生效日期
    ,o.otherinreason -- 其他进入原因
    ,o.delorgid -- 删除机构
    ,o.migtflag -- 
    ,o.passlevel -- 批准机构级别010总行批准020分行批准
    ,o.capacitytype -- 认定方式010直接认定020流程认定
    ,o.currentprocessstatus -- 当前流程状态：ToFinished-待完成ToConfirm-待确认HasConfirm-已确认
    ,o.approvebusinesssum -- 申请时批复授信金额
    ,o.approvestatus -- 审批状态
    ,o.isimpcustomerflag -- 是否为重点监测客户
    ,o.inputuserid -- 登记人
    ,o.inputorgid -- 登记机构编号
    ,o.addflag -- 新增标志010人工新增020批量新增
    ,o.inreason -- 进入原因
    ,o.passorgid -- 批准机构
    ,o.risklevel -- 风险级别
    ,o.updateuserid -- 更新人编号
    ,o.inapplybusinessbalance -- 进入时授信余额
    ,o.quitereason -- 退出原因
    ,o.deluserid -- 删除用户
    ,o.currentapplytype -- 当前申请类型：ApplyIn-申请进入ApplyOut-申请退出
    ,o.updateorgid -- 更新机构编号
    ,o.inapproveexposuresum -- 进入时批复敞口金额
    ,o.levelmanage -- 层级管理010总行020分行030支行/团队
    ,o.relativeserailno -- 关联的申请流水
    ,o.inapplyexposurebalance -- 进入时敞口余额
    ,o.logoffdescript -- 退出措施
    ,o.manageuserid -- 管户人
    ,o.passuserid -- 批准人
    ,o.quitedate -- 退出日期
    ,o.inapprovebusinesssum -- 进入时批复授信金额
    ,o.manageorgid -- 管户机构
    ,o.deldate -- 删除日期
    ,o.approveexposuresum -- 申请时批复敞口金额
    ,o.customertype -- 客户类型01公司客户02集团客户03个人客户0310个人客户0320个体经营户
    ,o.applybusinessbalance -- 申请时授信余额
    ,o.applyexposurebalance -- 申请时敞口余额
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
from ${iol_schema}.icms_impoversee_info_bk o
    left join ${iol_schema}.icms_impoversee_info_op n
        on
            o.serialno = n.serialno
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.icms_impoversee_info_cl d
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
--truncate table ${iol_schema}.icms_impoversee_info;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('icms_impoversee_info') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.icms_impoversee_info drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.icms_impoversee_info add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.icms_impoversee_info exchange partition p_${batch_date} with table ${iol_schema}.icms_impoversee_info_cl;
alter table ${iol_schema}.icms_impoversee_info exchange partition p_20991231 with table ${iol_schema}.icms_impoversee_info_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.icms_impoversee_info to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.icms_impoversee_info_op purge;
drop table ${iol_schema}.icms_impoversee_info_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.icms_impoversee_info_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'icms_impoversee_info',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
