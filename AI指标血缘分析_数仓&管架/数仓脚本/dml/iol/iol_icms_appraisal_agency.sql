/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_icms_appraisal_agency
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
create table ${iol_schema}.icms_appraisal_agency_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.icms_appraisal_agency
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.icms_appraisal_agency_op purge;
drop table ${iol_schema}.icms_appraisal_agency_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.icms_appraisal_agency_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.icms_appraisal_agency where 0=1;

create table ${iol_schema}.icms_appraisal_agency_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.icms_appraisal_agency where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.icms_appraisal_agency_cl(
            appraisalorgid -- 评估机构编号
            ,appraisalorgname -- 评估机构名称
            ,appraisalorgtype -- 评估公司类型 02  特殊资产准入 03  特别准入,一次性)
            ,appraisalorgaddress -- 机构地址
            ,appraisalorgstatus -- 评估机构管理状态
            ,registerdate -- 机构成立日期
            ,assetstype -- 可评估资产类型
            ,qualifylevel -- 执业资质等级
            ,assessarea -- 可估价地域范围
            ,certname -- 资质证书名称
            ,certid -- 资质证书标号
            ,approvedate -- 资质核准日期
            ,approveenddate -- 资质到期日期
            ,departmentcare -- 行业主管部门是否年审
            ,inputuser -- 基本信息录入岗
            ,continuetime -- 连续执业时间
            ,businessscope -- 经营范围
            ,registercapital -- 注册资本（万元）
            ,legalrep -- 法人代表
            ,orgtelephone -- 评估机构电话
            ,orgfax -- 评估机构传真电话
            ,orgemail -- 评估机构电子邮箱
            ,appraisernum -- 评估师数量
            ,parentorgid -- 所属分行
            ,appraisalcertid -- 评估机构证件号码
            ,appraisalcerttype -- 评估机构证件类型
            ,relacertid -- 关联机构
            ,tempsaveflag -- 暂存标志
            ,isinalertlist -- 警示标识
            ,inputuserid -- 登记人
            ,inputorgid -- 登记机构
            ,inputdate -- 登记日期
            ,updateuserid -- 更新人
            ,updateorgid -- 更新机构
            ,updatedate -- 更新日期
            ,remark -- 备注
            ,corporgid -- 法人机构编号
            ,appraisallisttype -- 评估机构名单标识
            ,coopstartdate -- 合作起始日期
            ,coopenddate -- 合作到期日
            ,belongdept -- 所属条线
            ,appraisalorgstatustime -- 操作评估机构管理状态执行时间
            ,migtflag -- 迁移标识：rs rcr ilc upl mim
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.icms_appraisal_agency_op(
            appraisalorgid -- 评估机构编号
            ,appraisalorgname -- 评估机构名称
            ,appraisalorgtype -- 评估公司类型 02  特殊资产准入 03  特别准入,一次性)
            ,appraisalorgaddress -- 机构地址
            ,appraisalorgstatus -- 评估机构管理状态
            ,registerdate -- 机构成立日期
            ,assetstype -- 可评估资产类型
            ,qualifylevel -- 执业资质等级
            ,assessarea -- 可估价地域范围
            ,certname -- 资质证书名称
            ,certid -- 资质证书标号
            ,approvedate -- 资质核准日期
            ,approveenddate -- 资质到期日期
            ,departmentcare -- 行业主管部门是否年审
            ,inputuser -- 基本信息录入岗
            ,continuetime -- 连续执业时间
            ,businessscope -- 经营范围
            ,registercapital -- 注册资本（万元）
            ,legalrep -- 法人代表
            ,orgtelephone -- 评估机构电话
            ,orgfax -- 评估机构传真电话
            ,orgemail -- 评估机构电子邮箱
            ,appraisernum -- 评估师数量
            ,parentorgid -- 所属分行
            ,appraisalcertid -- 评估机构证件号码
            ,appraisalcerttype -- 评估机构证件类型
            ,relacertid -- 关联机构
            ,tempsaveflag -- 暂存标志
            ,isinalertlist -- 警示标识
            ,inputuserid -- 登记人
            ,inputorgid -- 登记机构
            ,inputdate -- 登记日期
            ,updateuserid -- 更新人
            ,updateorgid -- 更新机构
            ,updatedate -- 更新日期
            ,remark -- 备注
            ,corporgid -- 法人机构编号
            ,appraisallisttype -- 评估机构名单标识
            ,coopstartdate -- 合作起始日期
            ,coopenddate -- 合作到期日
            ,belongdept -- 所属条线
            ,appraisalorgstatustime -- 操作评估机构管理状态执行时间
            ,migtflag -- 迁移标识：rs rcr ilc upl mim
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.appraisalorgid, o.appraisalorgid) as appraisalorgid -- 评估机构编号
    ,nvl(n.appraisalorgname, o.appraisalorgname) as appraisalorgname -- 评估机构名称
    ,nvl(n.appraisalorgtype, o.appraisalorgtype) as appraisalorgtype -- 评估公司类型 02  特殊资产准入 03  特别准入,一次性)
    ,nvl(n.appraisalorgaddress, o.appraisalorgaddress) as appraisalorgaddress -- 机构地址
    ,nvl(n.appraisalorgstatus, o.appraisalorgstatus) as appraisalorgstatus -- 评估机构管理状态
    ,nvl(n.registerdate, o.registerdate) as registerdate -- 机构成立日期
    ,nvl(n.assetstype, o.assetstype) as assetstype -- 可评估资产类型
    ,nvl(n.qualifylevel, o.qualifylevel) as qualifylevel -- 执业资质等级
    ,nvl(n.assessarea, o.assessarea) as assessarea -- 可估价地域范围
    ,nvl(n.certname, o.certname) as certname -- 资质证书名称
    ,nvl(n.certid, o.certid) as certid -- 资质证书标号
    ,nvl(n.approvedate, o.approvedate) as approvedate -- 资质核准日期
    ,nvl(n.approveenddate, o.approveenddate) as approveenddate -- 资质到期日期
    ,nvl(n.departmentcare, o.departmentcare) as departmentcare -- 行业主管部门是否年审
    ,nvl(n.inputuser, o.inputuser) as inputuser -- 基本信息录入岗
    ,nvl(n.continuetime, o.continuetime) as continuetime -- 连续执业时间
    ,nvl(n.businessscope, o.businessscope) as businessscope -- 经营范围
    ,nvl(n.registercapital, o.registercapital) as registercapital -- 注册资本（万元）
    ,nvl(n.legalrep, o.legalrep) as legalrep -- 法人代表
    ,nvl(n.orgtelephone, o.orgtelephone) as orgtelephone -- 评估机构电话
    ,nvl(n.orgfax, o.orgfax) as orgfax -- 评估机构传真电话
    ,nvl(n.orgemail, o.orgemail) as orgemail -- 评估机构电子邮箱
    ,nvl(n.appraisernum, o.appraisernum) as appraisernum -- 评估师数量
    ,nvl(n.parentorgid, o.parentorgid) as parentorgid -- 所属分行
    ,nvl(n.appraisalcertid, o.appraisalcertid) as appraisalcertid -- 评估机构证件号码
    ,nvl(n.appraisalcerttype, o.appraisalcerttype) as appraisalcerttype -- 评估机构证件类型
    ,nvl(n.relacertid, o.relacertid) as relacertid -- 关联机构
    ,nvl(n.tempsaveflag, o.tempsaveflag) as tempsaveflag -- 暂存标志
    ,nvl(n.isinalertlist, o.isinalertlist) as isinalertlist -- 警示标识
    ,nvl(n.inputuserid, o.inputuserid) as inputuserid -- 登记人
    ,nvl(n.inputorgid, o.inputorgid) as inputorgid -- 登记机构
    ,nvl(n.inputdate, o.inputdate) as inputdate -- 登记日期
    ,nvl(n.updateuserid, o.updateuserid) as updateuserid -- 更新人
    ,nvl(n.updateorgid, o.updateorgid) as updateorgid -- 更新机构
    ,nvl(n.updatedate, o.updatedate) as updatedate -- 更新日期
    ,nvl(n.remark, o.remark) as remark -- 备注
    ,nvl(n.corporgid, o.corporgid) as corporgid -- 法人机构编号
    ,nvl(n.appraisallisttype, o.appraisallisttype) as appraisallisttype -- 评估机构名单标识
    ,nvl(n.coopstartdate, o.coopstartdate) as coopstartdate -- 合作起始日期
    ,nvl(n.coopenddate, o.coopenddate) as coopenddate -- 合作到期日
    ,nvl(n.belongdept, o.belongdept) as belongdept -- 所属条线
    ,nvl(n.appraisalorgstatustime, o.appraisalorgstatustime) as appraisalorgstatustime -- 操作评估机构管理状态执行时间
    ,nvl(n.migtflag, o.migtflag) as migtflag -- 迁移标识：rs rcr ilc upl mim
    ,case when
            n.appraisalorgid is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.appraisalorgid is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.appraisalorgid is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.icms_appraisal_agency_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.icms_appraisal_agency where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.appraisalorgid = n.appraisalorgid
where (
        o.appraisalorgid is null
    )
    or (
        n.appraisalorgid is null
    )
    or (
        o.appraisalorgname <> n.appraisalorgname
        or o.appraisalorgtype <> n.appraisalorgtype
        or o.appraisalorgaddress <> n.appraisalorgaddress
        or o.appraisalorgstatus <> n.appraisalorgstatus
        or o.registerdate <> n.registerdate
        or o.assetstype <> n.assetstype
        or o.qualifylevel <> n.qualifylevel
        or o.assessarea <> n.assessarea
        or o.certname <> n.certname
        or o.certid <> n.certid
        or o.approvedate <> n.approvedate
        or o.approveenddate <> n.approveenddate
        or o.departmentcare <> n.departmentcare
        or o.inputuser <> n.inputuser
        or o.continuetime <> n.continuetime
        or o.businessscope <> n.businessscope
        or o.registercapital <> n.registercapital
        or o.legalrep <> n.legalrep
        or o.orgtelephone <> n.orgtelephone
        or o.orgfax <> n.orgfax
        or o.orgemail <> n.orgemail
        or o.appraisernum <> n.appraisernum
        or o.parentorgid <> n.parentorgid
        or o.appraisalcertid <> n.appraisalcertid
        or o.appraisalcerttype <> n.appraisalcerttype
        or o.relacertid <> n.relacertid
        or o.tempsaveflag <> n.tempsaveflag
        or o.isinalertlist <> n.isinalertlist
        or o.inputuserid <> n.inputuserid
        or o.inputorgid <> n.inputorgid
        or o.inputdate <> n.inputdate
        or o.updateuserid <> n.updateuserid
        or o.updateorgid <> n.updateorgid
        or o.updatedate <> n.updatedate
        or o.remark <> n.remark
        or o.corporgid <> n.corporgid
        or o.appraisallisttype <> n.appraisallisttype
        or o.coopstartdate <> n.coopstartdate
        or o.coopenddate <> n.coopenddate
        or o.belongdept <> n.belongdept
        or o.appraisalorgstatustime <> n.appraisalorgstatustime
        or o.migtflag <> n.migtflag
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.icms_appraisal_agency_cl(
            appraisalorgid -- 评估机构编号
            ,appraisalorgname -- 评估机构名称
            ,appraisalorgtype -- 评估公司类型 02  特殊资产准入 03  特别准入,一次性)
            ,appraisalorgaddress -- 机构地址
            ,appraisalorgstatus -- 评估机构管理状态
            ,registerdate -- 机构成立日期
            ,assetstype -- 可评估资产类型
            ,qualifylevel -- 执业资质等级
            ,assessarea -- 可估价地域范围
            ,certname -- 资质证书名称
            ,certid -- 资质证书标号
            ,approvedate -- 资质核准日期
            ,approveenddate -- 资质到期日期
            ,departmentcare -- 行业主管部门是否年审
            ,inputuser -- 基本信息录入岗
            ,continuetime -- 连续执业时间
            ,businessscope -- 经营范围
            ,registercapital -- 注册资本（万元）
            ,legalrep -- 法人代表
            ,orgtelephone -- 评估机构电话
            ,orgfax -- 评估机构传真电话
            ,orgemail -- 评估机构电子邮箱
            ,appraisernum -- 评估师数量
            ,parentorgid -- 所属分行
            ,appraisalcertid -- 评估机构证件号码
            ,appraisalcerttype -- 评估机构证件类型
            ,relacertid -- 关联机构
            ,tempsaveflag -- 暂存标志
            ,isinalertlist -- 警示标识
            ,inputuserid -- 登记人
            ,inputorgid -- 登记机构
            ,inputdate -- 登记日期
            ,updateuserid -- 更新人
            ,updateorgid -- 更新机构
            ,updatedate -- 更新日期
            ,remark -- 备注
            ,corporgid -- 法人机构编号
            ,appraisallisttype -- 评估机构名单标识
            ,coopstartdate -- 合作起始日期
            ,coopenddate -- 合作到期日
            ,belongdept -- 所属条线
            ,appraisalorgstatustime -- 操作评估机构管理状态执行时间
            ,migtflag -- 迁移标识：rs rcr ilc upl mim
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.icms_appraisal_agency_op(
            appraisalorgid -- 评估机构编号
            ,appraisalorgname -- 评估机构名称
            ,appraisalorgtype -- 评估公司类型 02  特殊资产准入 03  特别准入,一次性)
            ,appraisalorgaddress -- 机构地址
            ,appraisalorgstatus -- 评估机构管理状态
            ,registerdate -- 机构成立日期
            ,assetstype -- 可评估资产类型
            ,qualifylevel -- 执业资质等级
            ,assessarea -- 可估价地域范围
            ,certname -- 资质证书名称
            ,certid -- 资质证书标号
            ,approvedate -- 资质核准日期
            ,approveenddate -- 资质到期日期
            ,departmentcare -- 行业主管部门是否年审
            ,inputuser -- 基本信息录入岗
            ,continuetime -- 连续执业时间
            ,businessscope -- 经营范围
            ,registercapital -- 注册资本（万元）
            ,legalrep -- 法人代表
            ,orgtelephone -- 评估机构电话
            ,orgfax -- 评估机构传真电话
            ,orgemail -- 评估机构电子邮箱
            ,appraisernum -- 评估师数量
            ,parentorgid -- 所属分行
            ,appraisalcertid -- 评估机构证件号码
            ,appraisalcerttype -- 评估机构证件类型
            ,relacertid -- 关联机构
            ,tempsaveflag -- 暂存标志
            ,isinalertlist -- 警示标识
            ,inputuserid -- 登记人
            ,inputorgid -- 登记机构
            ,inputdate -- 登记日期
            ,updateuserid -- 更新人
            ,updateorgid -- 更新机构
            ,updatedate -- 更新日期
            ,remark -- 备注
            ,corporgid -- 法人机构编号
            ,appraisallisttype -- 评估机构名单标识
            ,coopstartdate -- 合作起始日期
            ,coopenddate -- 合作到期日
            ,belongdept -- 所属条线
            ,appraisalorgstatustime -- 操作评估机构管理状态执行时间
            ,migtflag -- 迁移标识：rs rcr ilc upl mim
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.appraisalorgid -- 评估机构编号
    ,o.appraisalorgname -- 评估机构名称
    ,o.appraisalorgtype -- 评估公司类型 02  特殊资产准入 03  特别准入,一次性)
    ,o.appraisalorgaddress -- 机构地址
    ,o.appraisalorgstatus -- 评估机构管理状态
    ,o.registerdate -- 机构成立日期
    ,o.assetstype -- 可评估资产类型
    ,o.qualifylevel -- 执业资质等级
    ,o.assessarea -- 可估价地域范围
    ,o.certname -- 资质证书名称
    ,o.certid -- 资质证书标号
    ,o.approvedate -- 资质核准日期
    ,o.approveenddate -- 资质到期日期
    ,o.departmentcare -- 行业主管部门是否年审
    ,o.inputuser -- 基本信息录入岗
    ,o.continuetime -- 连续执业时间
    ,o.businessscope -- 经营范围
    ,o.registercapital -- 注册资本（万元）
    ,o.legalrep -- 法人代表
    ,o.orgtelephone -- 评估机构电话
    ,o.orgfax -- 评估机构传真电话
    ,o.orgemail -- 评估机构电子邮箱
    ,o.appraisernum -- 评估师数量
    ,o.parentorgid -- 所属分行
    ,o.appraisalcertid -- 评估机构证件号码
    ,o.appraisalcerttype -- 评估机构证件类型
    ,o.relacertid -- 关联机构
    ,o.tempsaveflag -- 暂存标志
    ,o.isinalertlist -- 警示标识
    ,o.inputuserid -- 登记人
    ,o.inputorgid -- 登记机构
    ,o.inputdate -- 登记日期
    ,o.updateuserid -- 更新人
    ,o.updateorgid -- 更新机构
    ,o.updatedate -- 更新日期
    ,o.remark -- 备注
    ,o.corporgid -- 法人机构编号
    ,o.appraisallisttype -- 评估机构名单标识
    ,o.coopstartdate -- 合作起始日期
    ,o.coopenddate -- 合作到期日
    ,o.belongdept -- 所属条线
    ,o.appraisalorgstatustime -- 操作评估机构管理状态执行时间
    ,o.migtflag -- 迁移标识：rs rcr ilc upl mim
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
from ${iol_schema}.icms_appraisal_agency_bk o
    left join ${iol_schema}.icms_appraisal_agency_op n
        on
            o.appraisalorgid = n.appraisalorgid
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.icms_appraisal_agency_cl d
        on
            o.appraisalorgid = d.appraisalorgid
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
--truncate table ${iol_schema}.icms_appraisal_agency;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('icms_appraisal_agency') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.icms_appraisal_agency drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.icms_appraisal_agency add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.icms_appraisal_agency exchange partition p_${batch_date} with table ${iol_schema}.icms_appraisal_agency_cl;
alter table ${iol_schema}.icms_appraisal_agency exchange partition p_20991231 with table ${iol_schema}.icms_appraisal_agency_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.icms_appraisal_agency to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.icms_appraisal_agency_op purge;
drop table ${iol_schema}.icms_appraisal_agency_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.icms_appraisal_agency_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'icms_appraisal_agency',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
