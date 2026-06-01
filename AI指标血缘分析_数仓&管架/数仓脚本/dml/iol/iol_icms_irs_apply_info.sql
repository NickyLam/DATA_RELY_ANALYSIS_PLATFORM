/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_icms_irs_apply_info
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
create table ${iol_schema}.icms_irs_apply_info_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.icms_irs_apply_info
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.icms_irs_apply_info_op purge;
drop table ${iol_schema}.icms_irs_apply_info_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.icms_irs_apply_info_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.icms_irs_apply_info where 0=1;

create table ${iol_schema}.icms_irs_apply_info_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.icms_irs_apply_info where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.icms_irs_apply_info_cl(
            adjustlasttime -- 最后特例调整时间
            ,adjustlevel -- 特例调整等级
            ,applyid -- 申请id
            ,applytype -- 流程申请类型
            ,approvestatus -- 审批状态
            ,auditflag -- 使用财报是否审计
            ,balance -- 业务余额
            ,creditapplyid -- 授信申请Id(授信途中发起评级才会有)
            ,creditsync -- 是否同步授信流程 1是0否 授信发起的评级流程如果需要同步则为1，如果评级流程单独触发过退回则不再同步
            ,customerid -- 客户编号
            ,customername -- 客户名称
            ,customertype -- 客户类型
            ,datasource -- 数据来源 1.申请2.跑批3.老评级
            ,entscale -- 企业规模
            ,enttype -- 企业类型 参考字典IrsEntType
            ,finallevel -- 确认等级
            ,hightech -- 是否高新技术企业
            ,industrytype -- 国标行业
            ,inputdate -- 创建时间
            ,inputorgid -- 创建人机构
            ,inputorgname -- 创建机构名称
            ,inputuserid -- 创建人id
            ,inputusername -- 创建人名称
            ,lastapplyid -- 上期申请Id
            ,lastreporttime -- 最新年报期次
            ,modelcode -- 模型编码
            ,modelname -- 模型名称
            ,needreport -- 是否需要财报
            ,occurtype -- 评级发生类型 1.评级认定2.评级更新
            ,originlevel -- 初始机评等级
            ,overthrowlevel -- 推翻等级
            ,overthrowreason -- 推翻原因
            ,phaseopinion -- 签署意见
            ,pusherrorinfo -- 同盾推动异常信息，如果推送成功则为空
            ,ratedelaydate -- 本次延期期限
            ,ratedelaymonth -- 申请延期时长（月）
            ,ratedelayreason -- 延期原因
            ,rateobjtype -- 评级对象类型
            ,realestate -- 是否房地产开发公司
            ,remark -- 备注
            ,reportno -- 使用财报编号
            ,reportscope -- 使用财报的口径
            ,reporttime -- 评级期次 使用财报则为财报期次，否则为T-1年度
            ,reporttypeno -- 财报类型
            ,savelimittimes -- 保存限制次数
            ,savetimes -- 已经保存次数 防止客户经理多次保存探索规则引擎计算规律
            ,setupdate -- 成立日期
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.icms_irs_apply_info_op(
            adjustlasttime -- 最后特例调整时间
            ,adjustlevel -- 特例调整等级
            ,applyid -- 申请id
            ,applytype -- 流程申请类型
            ,approvestatus -- 审批状态
            ,auditflag -- 使用财报是否审计
            ,balance -- 业务余额
            ,creditapplyid -- 授信申请Id(授信途中发起评级才会有)
            ,creditsync -- 是否同步授信流程 1是0否 授信发起的评级流程如果需要同步则为1，如果评级流程单独触发过退回则不再同步
            ,customerid -- 客户编号
            ,customername -- 客户名称
            ,customertype -- 客户类型
            ,datasource -- 数据来源 1.申请2.跑批3.老评级
            ,entscale -- 企业规模
            ,enttype -- 企业类型 参考字典IrsEntType
            ,finallevel -- 确认等级
            ,hightech -- 是否高新技术企业
            ,industrytype -- 国标行业
            ,inputdate -- 创建时间
            ,inputorgid -- 创建人机构
            ,inputorgname -- 创建机构名称
            ,inputuserid -- 创建人id
            ,inputusername -- 创建人名称
            ,lastapplyid -- 上期申请Id
            ,lastreporttime -- 最新年报期次
            ,modelcode -- 模型编码
            ,modelname -- 模型名称
            ,needreport -- 是否需要财报
            ,occurtype -- 评级发生类型 1.评级认定2.评级更新
            ,originlevel -- 初始机评等级
            ,overthrowlevel -- 推翻等级
            ,overthrowreason -- 推翻原因
            ,phaseopinion -- 签署意见
            ,pusherrorinfo -- 同盾推动异常信息，如果推送成功则为空
            ,ratedelaydate -- 本次延期期限
            ,ratedelaymonth -- 申请延期时长（月）
            ,ratedelayreason -- 延期原因
            ,rateobjtype -- 评级对象类型
            ,realestate -- 是否房地产开发公司
            ,remark -- 备注
            ,reportno -- 使用财报编号
            ,reportscope -- 使用财报的口径
            ,reporttime -- 评级期次 使用财报则为财报期次，否则为T-1年度
            ,reporttypeno -- 财报类型
            ,savelimittimes -- 保存限制次数
            ,savetimes -- 已经保存次数 防止客户经理多次保存探索规则引擎计算规律
            ,setupdate -- 成立日期
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.adjustlasttime, o.adjustlasttime) as adjustlasttime -- 最后特例调整时间
    ,nvl(n.adjustlevel, o.adjustlevel) as adjustlevel -- 特例调整等级
    ,nvl(n.applyid, o.applyid) as applyid -- 申请id
    ,nvl(n.applytype, o.applytype) as applytype -- 流程申请类型
    ,nvl(n.approvestatus, o.approvestatus) as approvestatus -- 审批状态
    ,nvl(n.auditflag, o.auditflag) as auditflag -- 使用财报是否审计
    ,nvl(n.balance, o.balance) as balance -- 业务余额
    ,nvl(n.creditapplyid, o.creditapplyid) as creditapplyid -- 授信申请Id(授信途中发起评级才会有)
    ,nvl(n.creditsync, o.creditsync) as creditsync -- 是否同步授信流程 1是0否 授信发起的评级流程如果需要同步则为1，如果评级流程单独触发过退回则不再同步
    ,nvl(n.customerid, o.customerid) as customerid -- 客户编号
    ,nvl(n.customername, o.customername) as customername -- 客户名称
    ,nvl(n.customertype, o.customertype) as customertype -- 客户类型
    ,nvl(n.datasource, o.datasource) as datasource -- 数据来源 1.申请2.跑批3.老评级
    ,nvl(n.entscale, o.entscale) as entscale -- 企业规模
    ,nvl(n.enttype, o.enttype) as enttype -- 企业类型 参考字典IrsEntType
    ,nvl(n.finallevel, o.finallevel) as finallevel -- 确认等级
    ,nvl(n.hightech, o.hightech) as hightech -- 是否高新技术企业
    ,nvl(n.industrytype, o.industrytype) as industrytype -- 国标行业
    ,nvl(n.inputdate, o.inputdate) as inputdate -- 创建时间
    ,nvl(n.inputorgid, o.inputorgid) as inputorgid -- 创建人机构
    ,nvl(n.inputorgname, o.inputorgname) as inputorgname -- 创建机构名称
    ,nvl(n.inputuserid, o.inputuserid) as inputuserid -- 创建人id
    ,nvl(n.inputusername, o.inputusername) as inputusername -- 创建人名称
    ,nvl(n.lastapplyid, o.lastapplyid) as lastapplyid -- 上期申请Id
    ,nvl(n.lastreporttime, o.lastreporttime) as lastreporttime -- 最新年报期次
    ,nvl(n.modelcode, o.modelcode) as modelcode -- 模型编码
    ,nvl(n.modelname, o.modelname) as modelname -- 模型名称
    ,nvl(n.needreport, o.needreport) as needreport -- 是否需要财报
    ,nvl(n.occurtype, o.occurtype) as occurtype -- 评级发生类型 1.评级认定2.评级更新
    ,nvl(n.originlevel, o.originlevel) as originlevel -- 初始机评等级
    ,nvl(n.overthrowlevel, o.overthrowlevel) as overthrowlevel -- 推翻等级
    ,nvl(n.overthrowreason, o.overthrowreason) as overthrowreason -- 推翻原因
    ,nvl(n.phaseopinion, o.phaseopinion) as phaseopinion -- 签署意见
    ,nvl(n.pusherrorinfo, o.pusherrorinfo) as pusherrorinfo -- 同盾推动异常信息，如果推送成功则为空
    ,nvl(n.ratedelaydate, o.ratedelaydate) as ratedelaydate -- 本次延期期限
    ,nvl(n.ratedelaymonth, o.ratedelaymonth) as ratedelaymonth -- 申请延期时长（月）
    ,nvl(n.ratedelayreason, o.ratedelayreason) as ratedelayreason -- 延期原因
    ,nvl(n.rateobjtype, o.rateobjtype) as rateobjtype -- 评级对象类型
    ,nvl(n.realestate, o.realestate) as realestate -- 是否房地产开发公司
    ,nvl(n.remark, o.remark) as remark -- 备注
    ,nvl(n.reportno, o.reportno) as reportno -- 使用财报编号
    ,nvl(n.reportscope, o.reportscope) as reportscope -- 使用财报的口径
    ,nvl(n.reporttime, o.reporttime) as reporttime -- 评级期次 使用财报则为财报期次，否则为T-1年度
    ,nvl(n.reporttypeno, o.reporttypeno) as reporttypeno -- 财报类型
    ,nvl(n.savelimittimes, o.savelimittimes) as savelimittimes -- 保存限制次数
    ,nvl(n.savetimes, o.savetimes) as savetimes -- 已经保存次数 防止客户经理多次保存探索规则引擎计算规律
    ,nvl(n.setupdate, o.setupdate) as setupdate -- 成立日期
    ,case when
            n.applyid is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.applyid is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.applyid is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.icms_irs_apply_info_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.icms_irs_apply_info where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.applyid = n.applyid
where (
        o.applyid is null
    )
    or (
        n.applyid is null
    )
    or (
        o.adjustlasttime <> n.adjustlasttime
        or o.adjustlevel <> n.adjustlevel
        or o.applytype <> n.applytype
        or o.approvestatus <> n.approvestatus
        or o.auditflag <> n.auditflag
        or o.balance <> n.balance
        or o.creditapplyid <> n.creditapplyid
        or o.creditsync <> n.creditsync
        or o.customerid <> n.customerid
        or o.customername <> n.customername
        or o.customertype <> n.customertype
        or o.datasource <> n.datasource
        or o.entscale <> n.entscale
        or o.enttype <> n.enttype
        or o.finallevel <> n.finallevel
        or o.hightech <> n.hightech
        or o.industrytype <> n.industrytype
        or o.inputdate <> n.inputdate
        or o.inputorgid <> n.inputorgid
        or o.inputorgname <> n.inputorgname
        or o.inputuserid <> n.inputuserid
        or o.inputusername <> n.inputusername
        or o.lastapplyid <> n.lastapplyid
        or o.lastreporttime <> n.lastreporttime
        or o.modelcode <> n.modelcode
        or o.modelname <> n.modelname
        or o.needreport <> n.needreport
        or o.occurtype <> n.occurtype
        or o.originlevel <> n.originlevel
        or o.overthrowlevel <> n.overthrowlevel
        or o.overthrowreason <> n.overthrowreason
        or o.phaseopinion <> n.phaseopinion
        or o.pusherrorinfo <> n.pusherrorinfo
        or o.ratedelaydate <> n.ratedelaydate
        or o.ratedelaymonth <> n.ratedelaymonth
        or o.ratedelayreason <> n.ratedelayreason
        or o.rateobjtype <> n.rateobjtype
        or o.realestate <> n.realestate
        or o.remark <> n.remark
        or o.reportno <> n.reportno
        or o.reportscope <> n.reportscope
        or o.reporttime <> n.reporttime
        or o.reporttypeno <> n.reporttypeno
        or o.savelimittimes <> n.savelimittimes
        or o.savetimes <> n.savetimes
        or o.setupdate <> n.setupdate
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.icms_irs_apply_info_cl(
            adjustlasttime -- 最后特例调整时间
            ,adjustlevel -- 特例调整等级
            ,applyid -- 申请id
            ,applytype -- 流程申请类型
            ,approvestatus -- 审批状态
            ,auditflag -- 使用财报是否审计
            ,balance -- 业务余额
            ,creditapplyid -- 授信申请Id(授信途中发起评级才会有)
            ,creditsync -- 是否同步授信流程 1是0否 授信发起的评级流程如果需要同步则为1，如果评级流程单独触发过退回则不再同步
            ,customerid -- 客户编号
            ,customername -- 客户名称
            ,customertype -- 客户类型
            ,datasource -- 数据来源 1.申请2.跑批3.老评级
            ,entscale -- 企业规模
            ,enttype -- 企业类型 参考字典IrsEntType
            ,finallevel -- 确认等级
            ,hightech -- 是否高新技术企业
            ,industrytype -- 国标行业
            ,inputdate -- 创建时间
            ,inputorgid -- 创建人机构
            ,inputorgname -- 创建机构名称
            ,inputuserid -- 创建人id
            ,inputusername -- 创建人名称
            ,lastapplyid -- 上期申请Id
            ,lastreporttime -- 最新年报期次
            ,modelcode -- 模型编码
            ,modelname -- 模型名称
            ,needreport -- 是否需要财报
            ,occurtype -- 评级发生类型 1.评级认定2.评级更新
            ,originlevel -- 初始机评等级
            ,overthrowlevel -- 推翻等级
            ,overthrowreason -- 推翻原因
            ,phaseopinion -- 签署意见
            ,pusherrorinfo -- 同盾推动异常信息，如果推送成功则为空
            ,ratedelaydate -- 本次延期期限
            ,ratedelaymonth -- 申请延期时长（月）
            ,ratedelayreason -- 延期原因
            ,rateobjtype -- 评级对象类型
            ,realestate -- 是否房地产开发公司
            ,remark -- 备注
            ,reportno -- 使用财报编号
            ,reportscope -- 使用财报的口径
            ,reporttime -- 评级期次 使用财报则为财报期次，否则为T-1年度
            ,reporttypeno -- 财报类型
            ,savelimittimes -- 保存限制次数
            ,savetimes -- 已经保存次数 防止客户经理多次保存探索规则引擎计算规律
            ,setupdate -- 成立日期
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.icms_irs_apply_info_op(
            adjustlasttime -- 最后特例调整时间
            ,adjustlevel -- 特例调整等级
            ,applyid -- 申请id
            ,applytype -- 流程申请类型
            ,approvestatus -- 审批状态
            ,auditflag -- 使用财报是否审计
            ,balance -- 业务余额
            ,creditapplyid -- 授信申请Id(授信途中发起评级才会有)
            ,creditsync -- 是否同步授信流程 1是0否 授信发起的评级流程如果需要同步则为1，如果评级流程单独触发过退回则不再同步
            ,customerid -- 客户编号
            ,customername -- 客户名称
            ,customertype -- 客户类型
            ,datasource -- 数据来源 1.申请2.跑批3.老评级
            ,entscale -- 企业规模
            ,enttype -- 企业类型 参考字典IrsEntType
            ,finallevel -- 确认等级
            ,hightech -- 是否高新技术企业
            ,industrytype -- 国标行业
            ,inputdate -- 创建时间
            ,inputorgid -- 创建人机构
            ,inputorgname -- 创建机构名称
            ,inputuserid -- 创建人id
            ,inputusername -- 创建人名称
            ,lastapplyid -- 上期申请Id
            ,lastreporttime -- 最新年报期次
            ,modelcode -- 模型编码
            ,modelname -- 模型名称
            ,needreport -- 是否需要财报
            ,occurtype -- 评级发生类型 1.评级认定2.评级更新
            ,originlevel -- 初始机评等级
            ,overthrowlevel -- 推翻等级
            ,overthrowreason -- 推翻原因
            ,phaseopinion -- 签署意见
            ,pusherrorinfo -- 同盾推动异常信息，如果推送成功则为空
            ,ratedelaydate -- 本次延期期限
            ,ratedelaymonth -- 申请延期时长（月）
            ,ratedelayreason -- 延期原因
            ,rateobjtype -- 评级对象类型
            ,realestate -- 是否房地产开发公司
            ,remark -- 备注
            ,reportno -- 使用财报编号
            ,reportscope -- 使用财报的口径
            ,reporttime -- 评级期次 使用财报则为财报期次，否则为T-1年度
            ,reporttypeno -- 财报类型
            ,savelimittimes -- 保存限制次数
            ,savetimes -- 已经保存次数 防止客户经理多次保存探索规则引擎计算规律
            ,setupdate -- 成立日期
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.adjustlasttime -- 最后特例调整时间
    ,o.adjustlevel -- 特例调整等级
    ,o.applyid -- 申请id
    ,o.applytype -- 流程申请类型
    ,o.approvestatus -- 审批状态
    ,o.auditflag -- 使用财报是否审计
    ,o.balance -- 业务余额
    ,o.creditapplyid -- 授信申请Id(授信途中发起评级才会有)
    ,o.creditsync -- 是否同步授信流程 1是0否 授信发起的评级流程如果需要同步则为1，如果评级流程单独触发过退回则不再同步
    ,o.customerid -- 客户编号
    ,o.customername -- 客户名称
    ,o.customertype -- 客户类型
    ,o.datasource -- 数据来源 1.申请2.跑批3.老评级
    ,o.entscale -- 企业规模
    ,o.enttype -- 企业类型 参考字典IrsEntType
    ,o.finallevel -- 确认等级
    ,o.hightech -- 是否高新技术企业
    ,o.industrytype -- 国标行业
    ,o.inputdate -- 创建时间
    ,o.inputorgid -- 创建人机构
    ,o.inputorgname -- 创建机构名称
    ,o.inputuserid -- 创建人id
    ,o.inputusername -- 创建人名称
    ,o.lastapplyid -- 上期申请Id
    ,o.lastreporttime -- 最新年报期次
    ,o.modelcode -- 模型编码
    ,o.modelname -- 模型名称
    ,o.needreport -- 是否需要财报
    ,o.occurtype -- 评级发生类型 1.评级认定2.评级更新
    ,o.originlevel -- 初始机评等级
    ,o.overthrowlevel -- 推翻等级
    ,o.overthrowreason -- 推翻原因
    ,o.phaseopinion -- 签署意见
    ,o.pusherrorinfo -- 同盾推动异常信息，如果推送成功则为空
    ,o.ratedelaydate -- 本次延期期限
    ,o.ratedelaymonth -- 申请延期时长（月）
    ,o.ratedelayreason -- 延期原因
    ,o.rateobjtype -- 评级对象类型
    ,o.realestate -- 是否房地产开发公司
    ,o.remark -- 备注
    ,o.reportno -- 使用财报编号
    ,o.reportscope -- 使用财报的口径
    ,o.reporttime -- 评级期次 使用财报则为财报期次，否则为T-1年度
    ,o.reporttypeno -- 财报类型
    ,o.savelimittimes -- 保存限制次数
    ,o.savetimes -- 已经保存次数 防止客户经理多次保存探索规则引擎计算规律
    ,o.setupdate -- 成立日期
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
from ${iol_schema}.icms_irs_apply_info_bk o
    left join ${iol_schema}.icms_irs_apply_info_op n
        on
            o.applyid = n.applyid
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.icms_irs_apply_info_cl d
        on
            o.applyid = d.applyid
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
--truncate table ${iol_schema}.icms_irs_apply_info;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('icms_irs_apply_info') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.icms_irs_apply_info drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.icms_irs_apply_info add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.icms_irs_apply_info exchange partition p_${batch_date} with table ${iol_schema}.icms_irs_apply_info_cl;
alter table ${iol_schema}.icms_irs_apply_info exchange partition p_20991231 with table ${iol_schema}.icms_irs_apply_info_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.icms_irs_apply_info to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.icms_irs_apply_info_op purge;
drop table ${iol_schema}.icms_irs_apply_info_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.icms_irs_apply_info_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'icms_irs_apply_info',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
