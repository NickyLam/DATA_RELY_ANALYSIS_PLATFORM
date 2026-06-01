/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_icms_ind_work_resume
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
create table ${iol_schema}.icms_ind_work_resume_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.icms_ind_work_resume
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.icms_ind_work_resume_op purge;
drop table ${iol_schema}.icms_ind_work_resume_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.icms_ind_work_resume_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.icms_ind_work_resume where 0=1;

create table ${iol_schema}.icms_ind_work_resume_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.icms_ind_work_resume where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.icms_ind_work_resume_cl(
            serialno -- 流水号
            ,acctopenorg -- 工资账号开户银行
            ,companyadd -- 单位地址
            ,begindate -- 开始日期开始日
            ,companyzip -- 单位地址邮编
            ,customername -- 所在单位
            ,remark -- 备注
            ,certid -- 单位证件号
            ,industrytype -- 所属行业类型
            ,migtflag -- 迁移标志：crsrcrilcupl
            ,officetel -- 办公电话
            ,relationship -- 担任职务担任职务（代码：1-高级领导(行政级别局级及局级以上领导或大公司高级管理人员)2-中级领导(行政级别局级以下领导或大公司中级管理人员)3-一般员工4-其他5-未知）
            ,unitcountryname -- 单位所在地名称
            ,techpost -- 职称
            ,industryname -- 所属行业名称
            ,updatedate -- 更新日期
            ,enddate -- 结束日期结束日
            ,updateuserid -- 更新人
            ,otherposition -- 其他职务
            ,inputuserid -- 登记人
            ,corporgid -- 法人机构编号
            ,account -- 工资账号
            ,inputorgid -- 登记机构
            ,updateorgid -- 更新机构
            ,certtype -- 单位证件类型
            ,unitcountry -- 单位所在地
            ,monthincome -- 月收入
            ,customerid -- 客户编号个人客户编号
            ,companynature -- 单位性质单位性质（代码：1-事业2-军队3-国有企业4-集团企业5-三资企业6-个人独资企业7-个体8-其他）
            ,companytel -- 单位电话
            ,inputdate -- 登记时间
            ,department -- 所在部门
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.icms_ind_work_resume_op(
            serialno -- 流水号
            ,acctopenorg -- 工资账号开户银行
            ,companyadd -- 单位地址
            ,begindate -- 开始日期开始日
            ,companyzip -- 单位地址邮编
            ,customername -- 所在单位
            ,remark -- 备注
            ,certid -- 单位证件号
            ,industrytype -- 所属行业类型
            ,migtflag -- 迁移标志：crsrcrilcupl
            ,officetel -- 办公电话
            ,relationship -- 担任职务担任职务（代码：1-高级领导(行政级别局级及局级以上领导或大公司高级管理人员)2-中级领导(行政级别局级以下领导或大公司中级管理人员)3-一般员工4-其他5-未知）
            ,unitcountryname -- 单位所在地名称
            ,techpost -- 职称
            ,industryname -- 所属行业名称
            ,updatedate -- 更新日期
            ,enddate -- 结束日期结束日
            ,updateuserid -- 更新人
            ,otherposition -- 其他职务
            ,inputuserid -- 登记人
            ,corporgid -- 法人机构编号
            ,account -- 工资账号
            ,inputorgid -- 登记机构
            ,updateorgid -- 更新机构
            ,certtype -- 单位证件类型
            ,unitcountry -- 单位所在地
            ,monthincome -- 月收入
            ,customerid -- 客户编号个人客户编号
            ,companynature -- 单位性质单位性质（代码：1-事业2-军队3-国有企业4-集团企业5-三资企业6-个人独资企业7-个体8-其他）
            ,companytel -- 单位电话
            ,inputdate -- 登记时间
            ,department -- 所在部门
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.serialno, o.serialno) as serialno -- 流水号
    ,nvl(n.acctopenorg, o.acctopenorg) as acctopenorg -- 工资账号开户银行
    ,nvl(n.companyadd, o.companyadd) as companyadd -- 单位地址
    ,nvl(n.begindate, o.begindate) as begindate -- 开始日期开始日
    ,nvl(n.companyzip, o.companyzip) as companyzip -- 单位地址邮编
    ,nvl(n.customername, o.customername) as customername -- 所在单位
    ,nvl(n.remark, o.remark) as remark -- 备注
    ,nvl(n.certid, o.certid) as certid -- 单位证件号
    ,nvl(n.industrytype, o.industrytype) as industrytype -- 所属行业类型
    ,nvl(n.migtflag, o.migtflag) as migtflag -- 迁移标志：crsrcrilcupl
    ,nvl(n.officetel, o.officetel) as officetel -- 办公电话
    ,nvl(n.relationship, o.relationship) as relationship -- 担任职务担任职务（代码：1-高级领导(行政级别局级及局级以上领导或大公司高级管理人员)2-中级领导(行政级别局级以下领导或大公司中级管理人员)3-一般员工4-其他5-未知）
    ,nvl(n.unitcountryname, o.unitcountryname) as unitcountryname -- 单位所在地名称
    ,nvl(n.techpost, o.techpost) as techpost -- 职称
    ,nvl(n.industryname, o.industryname) as industryname -- 所属行业名称
    ,nvl(n.updatedate, o.updatedate) as updatedate -- 更新日期
    ,nvl(n.enddate, o.enddate) as enddate -- 结束日期结束日
    ,nvl(n.updateuserid, o.updateuserid) as updateuserid -- 更新人
    ,nvl(n.otherposition, o.otherposition) as otherposition -- 其他职务
    ,nvl(n.inputuserid, o.inputuserid) as inputuserid -- 登记人
    ,nvl(n.corporgid, o.corporgid) as corporgid -- 法人机构编号
    ,nvl(n.account, o.account) as account -- 工资账号
    ,nvl(n.inputorgid, o.inputorgid) as inputorgid -- 登记机构
    ,nvl(n.updateorgid, o.updateorgid) as updateorgid -- 更新机构
    ,nvl(n.certtype, o.certtype) as certtype -- 单位证件类型
    ,nvl(n.unitcountry, o.unitcountry) as unitcountry -- 单位所在地
    ,nvl(n.monthincome, o.monthincome) as monthincome -- 月收入
    ,nvl(n.customerid, o.customerid) as customerid -- 客户编号个人客户编号
    ,nvl(n.companynature, o.companynature) as companynature -- 单位性质单位性质（代码：1-事业2-军队3-国有企业4-集团企业5-三资企业6-个人独资企业7-个体8-其他）
    ,nvl(n.companytel, o.companytel) as companytel -- 单位电话
    ,nvl(n.inputdate, o.inputdate) as inputdate -- 登记时间
    ,nvl(n.department, o.department) as department -- 所在部门
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
from (select * from ${iol_schema}.icms_ind_work_resume_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.icms_ind_work_resume where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.serialno = n.serialno
where (
        o.serialno is null
    )
    or (
        n.serialno is null
    )
    or (
        o.acctopenorg <> n.acctopenorg
        or o.companyadd <> n.companyadd
        or o.begindate <> n.begindate
        or o.companyzip <> n.companyzip
        or o.customername <> n.customername
        or o.remark <> n.remark
        or o.certid <> n.certid
        or o.industrytype <> n.industrytype
        or o.migtflag <> n.migtflag
        or o.officetel <> n.officetel
        or o.relationship <> n.relationship
        or o.unitcountryname <> n.unitcountryname
        or o.techpost <> n.techpost
        or o.industryname <> n.industryname
        or o.updatedate <> n.updatedate
        or o.enddate <> n.enddate
        or o.updateuserid <> n.updateuserid
        or o.otherposition <> n.otherposition
        or o.inputuserid <> n.inputuserid
        or o.corporgid <> n.corporgid
        or o.account <> n.account
        or o.inputorgid <> n.inputorgid
        or o.updateorgid <> n.updateorgid
        or o.certtype <> n.certtype
        or o.unitcountry <> n.unitcountry
        or o.monthincome <> n.monthincome
        or o.customerid <> n.customerid
        or o.companynature <> n.companynature
        or o.companytel <> n.companytel
        or o.inputdate <> n.inputdate
        or o.department <> n.department
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.icms_ind_work_resume_cl(
            serialno -- 流水号
            ,acctopenorg -- 工资账号开户银行
            ,companyadd -- 单位地址
            ,begindate -- 开始日期开始日
            ,companyzip -- 单位地址邮编
            ,customername -- 所在单位
            ,remark -- 备注
            ,certid -- 单位证件号
            ,industrytype -- 所属行业类型
            ,migtflag -- 迁移标志：crsrcrilcupl
            ,officetel -- 办公电话
            ,relationship -- 担任职务担任职务（代码：1-高级领导(行政级别局级及局级以上领导或大公司高级管理人员)2-中级领导(行政级别局级以下领导或大公司中级管理人员)3-一般员工4-其他5-未知）
            ,unitcountryname -- 单位所在地名称
            ,techpost -- 职称
            ,industryname -- 所属行业名称
            ,updatedate -- 更新日期
            ,enddate -- 结束日期结束日
            ,updateuserid -- 更新人
            ,otherposition -- 其他职务
            ,inputuserid -- 登记人
            ,corporgid -- 法人机构编号
            ,account -- 工资账号
            ,inputorgid -- 登记机构
            ,updateorgid -- 更新机构
            ,certtype -- 单位证件类型
            ,unitcountry -- 单位所在地
            ,monthincome -- 月收入
            ,customerid -- 客户编号个人客户编号
            ,companynature -- 单位性质单位性质（代码：1-事业2-军队3-国有企业4-集团企业5-三资企业6-个人独资企业7-个体8-其他）
            ,companytel -- 单位电话
            ,inputdate -- 登记时间
            ,department -- 所在部门
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.icms_ind_work_resume_op(
            serialno -- 流水号
            ,acctopenorg -- 工资账号开户银行
            ,companyadd -- 单位地址
            ,begindate -- 开始日期开始日
            ,companyzip -- 单位地址邮编
            ,customername -- 所在单位
            ,remark -- 备注
            ,certid -- 单位证件号
            ,industrytype -- 所属行业类型
            ,migtflag -- 迁移标志：crsrcrilcupl
            ,officetel -- 办公电话
            ,relationship -- 担任职务担任职务（代码：1-高级领导(行政级别局级及局级以上领导或大公司高级管理人员)2-中级领导(行政级别局级以下领导或大公司中级管理人员)3-一般员工4-其他5-未知）
            ,unitcountryname -- 单位所在地名称
            ,techpost -- 职称
            ,industryname -- 所属行业名称
            ,updatedate -- 更新日期
            ,enddate -- 结束日期结束日
            ,updateuserid -- 更新人
            ,otherposition -- 其他职务
            ,inputuserid -- 登记人
            ,corporgid -- 法人机构编号
            ,account -- 工资账号
            ,inputorgid -- 登记机构
            ,updateorgid -- 更新机构
            ,certtype -- 单位证件类型
            ,unitcountry -- 单位所在地
            ,monthincome -- 月收入
            ,customerid -- 客户编号个人客户编号
            ,companynature -- 单位性质单位性质（代码：1-事业2-军队3-国有企业4-集团企业5-三资企业6-个人独资企业7-个体8-其他）
            ,companytel -- 单位电话
            ,inputdate -- 登记时间
            ,department -- 所在部门
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.serialno -- 流水号
    ,o.acctopenorg -- 工资账号开户银行
    ,o.companyadd -- 单位地址
    ,o.begindate -- 开始日期开始日
    ,o.companyzip -- 单位地址邮编
    ,o.customername -- 所在单位
    ,o.remark -- 备注
    ,o.certid -- 单位证件号
    ,o.industrytype -- 所属行业类型
    ,o.migtflag -- 迁移标志：crsrcrilcupl
    ,o.officetel -- 办公电话
    ,o.relationship -- 担任职务担任职务（代码：1-高级领导(行政级别局级及局级以上领导或大公司高级管理人员)2-中级领导(行政级别局级以下领导或大公司中级管理人员)3-一般员工4-其他5-未知）
    ,o.unitcountryname -- 单位所在地名称
    ,o.techpost -- 职称
    ,o.industryname -- 所属行业名称
    ,o.updatedate -- 更新日期
    ,o.enddate -- 结束日期结束日
    ,o.updateuserid -- 更新人
    ,o.otherposition -- 其他职务
    ,o.inputuserid -- 登记人
    ,o.corporgid -- 法人机构编号
    ,o.account -- 工资账号
    ,o.inputorgid -- 登记机构
    ,o.updateorgid -- 更新机构
    ,o.certtype -- 单位证件类型
    ,o.unitcountry -- 单位所在地
    ,o.monthincome -- 月收入
    ,o.customerid -- 客户编号个人客户编号
    ,o.companynature -- 单位性质单位性质（代码：1-事业2-军队3-国有企业4-集团企业5-三资企业6-个人独资企业7-个体8-其他）
    ,o.companytel -- 单位电话
    ,o.inputdate -- 登记时间
    ,o.department -- 所在部门
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
from ${iol_schema}.icms_ind_work_resume_bk o
    left join ${iol_schema}.icms_ind_work_resume_op n
        on
            o.serialno = n.serialno
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.icms_ind_work_resume_cl d
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
--truncate table ${iol_schema}.icms_ind_work_resume;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('icms_ind_work_resume') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.icms_ind_work_resume drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.icms_ind_work_resume add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.icms_ind_work_resume exchange partition p_${batch_date} with table ${iol_schema}.icms_ind_work_resume_cl;
alter table ${iol_schema}.icms_ind_work_resume exchange partition p_20991231 with table ${iol_schema}.icms_ind_work_resume_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.icms_ind_work_resume to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.icms_ind_work_resume_op purge;
drop table ${iol_schema}.icms_ind_work_resume_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.icms_ind_work_resume_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'icms_ind_work_resume',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
