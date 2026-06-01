/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_icms_wph_business_apply
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
create table ${iol_schema}.icms_wph_business_apply_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.icms_wph_business_apply
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.icms_wph_business_apply_op purge;
drop table ${iol_schema}.icms_wph_business_apply_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.icms_wph_business_apply_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.icms_wph_business_apply where 0=1;

create table ${iol_schema}.icms_wph_business_apply_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.icms_wph_business_apply where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.icms_wph_business_apply_cl(
            tenantid -- 租户ID
            ,userid -- 用户编号
            ,creditappno -- 申请编号
            ,partnercode -- 合作行代码
            ,productcode -- 产品编号
            ,applyid -- 第三方申请编号
            ,loantype -- 信贷类型
            ,amounttype -- 额度类型
            ,creditlimit -- 申请总额度
            ,creditlimitcrop -- 合作方承贷金额
            ,startdate -- 额度起始日
            ,enddate -- 额度到期日
            ,advicerate -- 年化利率
            ,chinesename -- 客户姓名
            ,mobile -- 客户手机号
            ,idtype -- 证件类型
            ,idnumber -- 证件号
            ,idaddress -- 身份证户籍地址
            ,idissueagent -- 身份证签发机构
            ,ideffectivedate -- 身份证有效期起
            ,idexpiredate -- 身份证有效期止
            ,birthdate -- 生日
            ,nationality -- 国籍
            ,race -- 民族
            ,sex -- 性别
            ,education -- 学历
            ,maritalstatus -- 婚姻状态
            ,degree -- 学位
            ,income -- 收入
            ,occupationtype -- 就业状况
            ,occupation -- 职业
            ,post -- 职务
            ,title -- 职称
            ,companyname -- 工作单位名称
            ,companyattribute -- 工作单位性质
            ,companyindustry -- 工作单位所属行业
            ,companyphone -- 单位电话
            ,homephone -- 家庭电话
            ,businesstype -- 业务类型
            ,customergroup -- 客群
            ,loanuse -- 贷款用途
            ,tenor -- 贷款期数
            ,pdcustdata -- 风控扩展字段
            ,productid -- 信贷产品编号
            ,customerid -- 客户编号
            ,approvestatus -- 申请状态
            ,riskstatus -- 风控结果
            ,failreason -- 风控拒绝原因
            ,riskcreditamount -- 风控授信额度
            ,riskintrate -- 风控利息年利率
            ,riskreqtime -- 风控回调时间
            ,inputuserid -- 登记人
            ,inputorgid -- 登记机构
            ,inputdate -- 登记时间
            ,updateuserid -- 更新人
            ,updateorgid -- 更新机构
            ,updatedate -- 更新日期
            ,downloadfileflag -- 影像下载成功标记
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.icms_wph_business_apply_op(
            tenantid -- 租户ID
            ,userid -- 用户编号
            ,creditappno -- 申请编号
            ,partnercode -- 合作行代码
            ,productcode -- 产品编号
            ,applyid -- 第三方申请编号
            ,loantype -- 信贷类型
            ,amounttype -- 额度类型
            ,creditlimit -- 申请总额度
            ,creditlimitcrop -- 合作方承贷金额
            ,startdate -- 额度起始日
            ,enddate -- 额度到期日
            ,advicerate -- 年化利率
            ,chinesename -- 客户姓名
            ,mobile -- 客户手机号
            ,idtype -- 证件类型
            ,idnumber -- 证件号
            ,idaddress -- 身份证户籍地址
            ,idissueagent -- 身份证签发机构
            ,ideffectivedate -- 身份证有效期起
            ,idexpiredate -- 身份证有效期止
            ,birthdate -- 生日
            ,nationality -- 国籍
            ,race -- 民族
            ,sex -- 性别
            ,education -- 学历
            ,maritalstatus -- 婚姻状态
            ,degree -- 学位
            ,income -- 收入
            ,occupationtype -- 就业状况
            ,occupation -- 职业
            ,post -- 职务
            ,title -- 职称
            ,companyname -- 工作单位名称
            ,companyattribute -- 工作单位性质
            ,companyindustry -- 工作单位所属行业
            ,companyphone -- 单位电话
            ,homephone -- 家庭电话
            ,businesstype -- 业务类型
            ,customergroup -- 客群
            ,loanuse -- 贷款用途
            ,tenor -- 贷款期数
            ,pdcustdata -- 风控扩展字段
            ,productid -- 信贷产品编号
            ,customerid -- 客户编号
            ,approvestatus -- 申请状态
            ,riskstatus -- 风控结果
            ,failreason -- 风控拒绝原因
            ,riskcreditamount -- 风控授信额度
            ,riskintrate -- 风控利息年利率
            ,riskreqtime -- 风控回调时间
            ,inputuserid -- 登记人
            ,inputorgid -- 登记机构
            ,inputdate -- 登记时间
            ,updateuserid -- 更新人
            ,updateorgid -- 更新机构
            ,updatedate -- 更新日期
            ,downloadfileflag -- 影像下载成功标记
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.tenantid, o.tenantid) as tenantid -- 租户ID
    ,nvl(n.userid, o.userid) as userid -- 用户编号
    ,nvl(n.creditappno, o.creditappno) as creditappno -- 申请编号
    ,nvl(n.partnercode, o.partnercode) as partnercode -- 合作行代码
    ,nvl(n.productcode, o.productcode) as productcode -- 产品编号
    ,nvl(n.applyid, o.applyid) as applyid -- 第三方申请编号
    ,nvl(n.loantype, o.loantype) as loantype -- 信贷类型
    ,nvl(n.amounttype, o.amounttype) as amounttype -- 额度类型
    ,nvl(n.creditlimit, o.creditlimit) as creditlimit -- 申请总额度
    ,nvl(n.creditlimitcrop, o.creditlimitcrop) as creditlimitcrop -- 合作方承贷金额
    ,nvl(n.startdate, o.startdate) as startdate -- 额度起始日
    ,nvl(n.enddate, o.enddate) as enddate -- 额度到期日
    ,nvl(n.advicerate, o.advicerate) as advicerate -- 年化利率
    ,nvl(n.chinesename, o.chinesename) as chinesename -- 客户姓名
    ,nvl(n.mobile, o.mobile) as mobile -- 客户手机号
    ,nvl(n.idtype, o.idtype) as idtype -- 证件类型
    ,nvl(n.idnumber, o.idnumber) as idnumber -- 证件号
    ,nvl(n.idaddress, o.idaddress) as idaddress -- 身份证户籍地址
    ,nvl(n.idissueagent, o.idissueagent) as idissueagent -- 身份证签发机构
    ,nvl(n.ideffectivedate, o.ideffectivedate) as ideffectivedate -- 身份证有效期起
    ,nvl(n.idexpiredate, o.idexpiredate) as idexpiredate -- 身份证有效期止
    ,nvl(n.birthdate, o.birthdate) as birthdate -- 生日
    ,nvl(n.nationality, o.nationality) as nationality -- 国籍
    ,nvl(n.race, o.race) as race -- 民族
    ,nvl(n.sex, o.sex) as sex -- 性别
    ,nvl(n.education, o.education) as education -- 学历
    ,nvl(n.maritalstatus, o.maritalstatus) as maritalstatus -- 婚姻状态
    ,nvl(n.degree, o.degree) as degree -- 学位
    ,nvl(n.income, o.income) as income -- 收入
    ,nvl(n.occupationtype, o.occupationtype) as occupationtype -- 就业状况
    ,nvl(n.occupation, o.occupation) as occupation -- 职业
    ,nvl(n.post, o.post) as post -- 职务
    ,nvl(n.title, o.title) as title -- 职称
    ,nvl(n.companyname, o.companyname) as companyname -- 工作单位名称
    ,nvl(n.companyattribute, o.companyattribute) as companyattribute -- 工作单位性质
    ,nvl(n.companyindustry, o.companyindustry) as companyindustry -- 工作单位所属行业
    ,nvl(n.companyphone, o.companyphone) as companyphone -- 单位电话
    ,nvl(n.homephone, o.homephone) as homephone -- 家庭电话
    ,nvl(n.businesstype, o.businesstype) as businesstype -- 业务类型
    ,nvl(n.customergroup, o.customergroup) as customergroup -- 客群
    ,nvl(n.loanuse, o.loanuse) as loanuse -- 贷款用途
    ,nvl(n.tenor, o.tenor) as tenor -- 贷款期数
    ,nvl(n.pdcustdata, o.pdcustdata) as pdcustdata -- 风控扩展字段
    ,nvl(n.productid, o.productid) as productid -- 信贷产品编号
    ,nvl(n.customerid, o.customerid) as customerid -- 客户编号
    ,nvl(n.approvestatus, o.approvestatus) as approvestatus -- 申请状态
    ,nvl(n.riskstatus, o.riskstatus) as riskstatus -- 风控结果
    ,nvl(n.failreason, o.failreason) as failreason -- 风控拒绝原因
    ,nvl(n.riskcreditamount, o.riskcreditamount) as riskcreditamount -- 风控授信额度
    ,nvl(n.riskintrate, o.riskintrate) as riskintrate -- 风控利息年利率
    ,nvl(n.riskreqtime, o.riskreqtime) as riskreqtime -- 风控回调时间
    ,nvl(n.inputuserid, o.inputuserid) as inputuserid -- 登记人
    ,nvl(n.inputorgid, o.inputorgid) as inputorgid -- 登记机构
    ,nvl(n.inputdate, o.inputdate) as inputdate -- 登记时间
    ,nvl(n.updateuserid, o.updateuserid) as updateuserid -- 更新人
    ,nvl(n.updateorgid, o.updateorgid) as updateorgid -- 更新机构
    ,nvl(n.updatedate, o.updatedate) as updatedate -- 更新日期
    ,nvl(n.downloadfileflag, o.downloadfileflag) as downloadfileflag -- 影像下载成功标记
    ,case when
            n.creditappno is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.creditappno is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.creditappno is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.icms_wph_business_apply_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.icms_wph_business_apply where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.creditappno = n.creditappno
where (
        o.creditappno is null
    )
    or (
        n.creditappno is null
    )
    or (
        o.tenantid <> n.tenantid
        or o.userid <> n.userid
        or o.partnercode <> n.partnercode
        or o.productcode <> n.productcode
        or o.applyid <> n.applyid
        or o.loantype <> n.loantype
        or o.amounttype <> n.amounttype
        or o.creditlimit <> n.creditlimit
        or o.creditlimitcrop <> n.creditlimitcrop
        or o.startdate <> n.startdate
        or o.enddate <> n.enddate
        or o.advicerate <> n.advicerate
        or o.chinesename <> n.chinesename
        or o.mobile <> n.mobile
        or o.idtype <> n.idtype
        or o.idnumber <> n.idnumber
        or o.idaddress <> n.idaddress
        or o.idissueagent <> n.idissueagent
        or o.ideffectivedate <> n.ideffectivedate
        or o.idexpiredate <> n.idexpiredate
        or o.birthdate <> n.birthdate
        or o.nationality <> n.nationality
        or o.race <> n.race
        or o.sex <> n.sex
        or o.education <> n.education
        or o.maritalstatus <> n.maritalstatus
        or o.degree <> n.degree
        or o.income <> n.income
        or o.occupationtype <> n.occupationtype
        or o.occupation <> n.occupation
        or o.post <> n.post
        or o.title <> n.title
        or o.companyname <> n.companyname
        or o.companyattribute <> n.companyattribute
        or o.companyindustry <> n.companyindustry
        or o.companyphone <> n.companyphone
        or o.homephone <> n.homephone
        or o.businesstype <> n.businesstype
        or o.customergroup <> n.customergroup
        or o.loanuse <> n.loanuse
        or o.tenor <> n.tenor
        or o.pdcustdata <> n.pdcustdata
        or o.productid <> n.productid
        or o.customerid <> n.customerid
        or o.approvestatus <> n.approvestatus
        or o.riskstatus <> n.riskstatus
        or o.failreason <> n.failreason
        or o.riskcreditamount <> n.riskcreditamount
        or o.riskintrate <> n.riskintrate
        or o.riskreqtime <> n.riskreqtime
        or o.inputuserid <> n.inputuserid
        or o.inputorgid <> n.inputorgid
        or o.inputdate <> n.inputdate
        or o.updateuserid <> n.updateuserid
        or o.updateorgid <> n.updateorgid
        or o.updatedate <> n.updatedate
        or o.downloadfileflag <> n.downloadfileflag
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.icms_wph_business_apply_cl(
            tenantid -- 租户ID
            ,userid -- 用户编号
            ,creditappno -- 申请编号
            ,partnercode -- 合作行代码
            ,productcode -- 产品编号
            ,applyid -- 第三方申请编号
            ,loantype -- 信贷类型
            ,amounttype -- 额度类型
            ,creditlimit -- 申请总额度
            ,creditlimitcrop -- 合作方承贷金额
            ,startdate -- 额度起始日
            ,enddate -- 额度到期日
            ,advicerate -- 年化利率
            ,chinesename -- 客户姓名
            ,mobile -- 客户手机号
            ,idtype -- 证件类型
            ,idnumber -- 证件号
            ,idaddress -- 身份证户籍地址
            ,idissueagent -- 身份证签发机构
            ,ideffectivedate -- 身份证有效期起
            ,idexpiredate -- 身份证有效期止
            ,birthdate -- 生日
            ,nationality -- 国籍
            ,race -- 民族
            ,sex -- 性别
            ,education -- 学历
            ,maritalstatus -- 婚姻状态
            ,degree -- 学位
            ,income -- 收入
            ,occupationtype -- 就业状况
            ,occupation -- 职业
            ,post -- 职务
            ,title -- 职称
            ,companyname -- 工作单位名称
            ,companyattribute -- 工作单位性质
            ,companyindustry -- 工作单位所属行业
            ,companyphone -- 单位电话
            ,homephone -- 家庭电话
            ,businesstype -- 业务类型
            ,customergroup -- 客群
            ,loanuse -- 贷款用途
            ,tenor -- 贷款期数
            ,pdcustdata -- 风控扩展字段
            ,productid -- 信贷产品编号
            ,customerid -- 客户编号
            ,approvestatus -- 申请状态
            ,riskstatus -- 风控结果
            ,failreason -- 风控拒绝原因
            ,riskcreditamount -- 风控授信额度
            ,riskintrate -- 风控利息年利率
            ,riskreqtime -- 风控回调时间
            ,inputuserid -- 登记人
            ,inputorgid -- 登记机构
            ,inputdate -- 登记时间
            ,updateuserid -- 更新人
            ,updateorgid -- 更新机构
            ,updatedate -- 更新日期
            ,downloadfileflag -- 影像下载成功标记
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.icms_wph_business_apply_op(
            tenantid -- 租户ID
            ,userid -- 用户编号
            ,creditappno -- 申请编号
            ,partnercode -- 合作行代码
            ,productcode -- 产品编号
            ,applyid -- 第三方申请编号
            ,loantype -- 信贷类型
            ,amounttype -- 额度类型
            ,creditlimit -- 申请总额度
            ,creditlimitcrop -- 合作方承贷金额
            ,startdate -- 额度起始日
            ,enddate -- 额度到期日
            ,advicerate -- 年化利率
            ,chinesename -- 客户姓名
            ,mobile -- 客户手机号
            ,idtype -- 证件类型
            ,idnumber -- 证件号
            ,idaddress -- 身份证户籍地址
            ,idissueagent -- 身份证签发机构
            ,ideffectivedate -- 身份证有效期起
            ,idexpiredate -- 身份证有效期止
            ,birthdate -- 生日
            ,nationality -- 国籍
            ,race -- 民族
            ,sex -- 性别
            ,education -- 学历
            ,maritalstatus -- 婚姻状态
            ,degree -- 学位
            ,income -- 收入
            ,occupationtype -- 就业状况
            ,occupation -- 职业
            ,post -- 职务
            ,title -- 职称
            ,companyname -- 工作单位名称
            ,companyattribute -- 工作单位性质
            ,companyindustry -- 工作单位所属行业
            ,companyphone -- 单位电话
            ,homephone -- 家庭电话
            ,businesstype -- 业务类型
            ,customergroup -- 客群
            ,loanuse -- 贷款用途
            ,tenor -- 贷款期数
            ,pdcustdata -- 风控扩展字段
            ,productid -- 信贷产品编号
            ,customerid -- 客户编号
            ,approvestatus -- 申请状态
            ,riskstatus -- 风控结果
            ,failreason -- 风控拒绝原因
            ,riskcreditamount -- 风控授信额度
            ,riskintrate -- 风控利息年利率
            ,riskreqtime -- 风控回调时间
            ,inputuserid -- 登记人
            ,inputorgid -- 登记机构
            ,inputdate -- 登记时间
            ,updateuserid -- 更新人
            ,updateorgid -- 更新机构
            ,updatedate -- 更新日期
            ,downloadfileflag -- 影像下载成功标记
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.tenantid -- 租户ID
    ,o.userid -- 用户编号
    ,o.creditappno -- 申请编号
    ,o.partnercode -- 合作行代码
    ,o.productcode -- 产品编号
    ,o.applyid -- 第三方申请编号
    ,o.loantype -- 信贷类型
    ,o.amounttype -- 额度类型
    ,o.creditlimit -- 申请总额度
    ,o.creditlimitcrop -- 合作方承贷金额
    ,o.startdate -- 额度起始日
    ,o.enddate -- 额度到期日
    ,o.advicerate -- 年化利率
    ,o.chinesename -- 客户姓名
    ,o.mobile -- 客户手机号
    ,o.idtype -- 证件类型
    ,o.idnumber -- 证件号
    ,o.idaddress -- 身份证户籍地址
    ,o.idissueagent -- 身份证签发机构
    ,o.ideffectivedate -- 身份证有效期起
    ,o.idexpiredate -- 身份证有效期止
    ,o.birthdate -- 生日
    ,o.nationality -- 国籍
    ,o.race -- 民族
    ,o.sex -- 性别
    ,o.education -- 学历
    ,o.maritalstatus -- 婚姻状态
    ,o.degree -- 学位
    ,o.income -- 收入
    ,o.occupationtype -- 就业状况
    ,o.occupation -- 职业
    ,o.post -- 职务
    ,o.title -- 职称
    ,o.companyname -- 工作单位名称
    ,o.companyattribute -- 工作单位性质
    ,o.companyindustry -- 工作单位所属行业
    ,o.companyphone -- 单位电话
    ,o.homephone -- 家庭电话
    ,o.businesstype -- 业务类型
    ,o.customergroup -- 客群
    ,o.loanuse -- 贷款用途
    ,o.tenor -- 贷款期数
    ,o.pdcustdata -- 风控扩展字段
    ,o.productid -- 信贷产品编号
    ,o.customerid -- 客户编号
    ,o.approvestatus -- 申请状态
    ,o.riskstatus -- 风控结果
    ,o.failreason -- 风控拒绝原因
    ,o.riskcreditamount -- 风控授信额度
    ,o.riskintrate -- 风控利息年利率
    ,o.riskreqtime -- 风控回调时间
    ,o.inputuserid -- 登记人
    ,o.inputorgid -- 登记机构
    ,o.inputdate -- 登记时间
    ,o.updateuserid -- 更新人
    ,o.updateorgid -- 更新机构
    ,o.updatedate -- 更新日期
    ,o.downloadfileflag -- 影像下载成功标记
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
from ${iol_schema}.icms_wph_business_apply_bk o
    left join ${iol_schema}.icms_wph_business_apply_op n
        on
            o.creditappno = n.creditappno
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.icms_wph_business_apply_cl d
        on
            o.creditappno = d.creditappno
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
--truncate table ${iol_schema}.icms_wph_business_apply;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('icms_wph_business_apply') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.icms_wph_business_apply drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.icms_wph_business_apply add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.icms_wph_business_apply exchange partition p_${batch_date} with table ${iol_schema}.icms_wph_business_apply_cl;
alter table ${iol_schema}.icms_wph_business_apply exchange partition p_20991231 with table ${iol_schema}.icms_wph_business_apply_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.icms_wph_business_apply to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.icms_wph_business_apply_op purge;
drop table ${iol_schema}.icms_wph_business_apply_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.icms_wph_business_apply_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'icms_wph_business_apply',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
