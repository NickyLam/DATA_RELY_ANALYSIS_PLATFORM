/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_icms_customer_info_wld
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
create table ${iol_schema}.icms_customer_info_wld_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.icms_customer_info_wld
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.icms_customer_info_wld_op purge;
drop table ${iol_schema}.icms_customer_info_wld_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.icms_customer_info_wld_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.icms_customer_info_wld where 0=1;

create table ${iol_schema}.icms_customer_info_wld_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.icms_customer_info_wld where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.icms_customer_info_wld_cl(
            customerid -- 客户号
            ,customername -- 客户姓名
            ,certtype -- 证件类型
            ,certid -- 证件号码
            ,certstartdate -- 证件起始日
            ,certmaturity -- 证件到期日
            ,sex -- 性别
            ,occupation -- 职业
            ,nation -- 国籍
            ,address -- 地址
            ,telephone -- 联系电话
            ,isfarmer -- 农户标志
            ,isindividual -- 是否个体工商户
            ,isminbusiowner -- 是否小微企业主
            ,wldcustid -- 微粒贷客户号
            ,birthday -- 生日
            ,profcountry -- 是否永久居住
            ,residencycountrycd -- 永久居住地国家代码
            ,languageind -- 语言代码
            ,embname -- 拼音名
            ,surname -- 姓氏
            ,marrystate -- 婚姻状况
            ,homephone -- 家庭电话
            ,compphone -- 单位电话
            ,qualification -- 学历
            ,degree -- 学位
            ,resideaddr -- 户籍地址
            ,matecertp -- 配偶证件类型
            ,matecerno -- 配偶证件号码
            ,matename -- 配偶姓名
            ,matecorp -- 配偶工作单位
            ,matephone -- 配偶联系电话
            ,addr -- 居住地址
            ,residestate -- 居住状况
            ,compnm -- 工作单位
            ,compaddr -- 单位地址
            ,comptrade -- 行业
            ,business -- 职务
            ,teachpose -- 职称
            ,workdate -- 本单位工作起始年份
            ,expiredate -- 有效期
            ,entname -- 企业名称
            ,entcerttype -- 企业证件类型
            ,entcreditcode -- 统一社会信用代码
            ,inputdate -- 登记日期
            ,updatedate -- 更新日期
            ,entregno -- 企业注册号
            ,entbusinessstatus -- 企业经营状态
            ,industrycode -- 行业代码
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.icms_customer_info_wld_op(
            customerid -- 客户号
            ,customername -- 客户姓名
            ,certtype -- 证件类型
            ,certid -- 证件号码
            ,certstartdate -- 证件起始日
            ,certmaturity -- 证件到期日
            ,sex -- 性别
            ,occupation -- 职业
            ,nation -- 国籍
            ,address -- 地址
            ,telephone -- 联系电话
            ,isfarmer -- 农户标志
            ,isindividual -- 是否个体工商户
            ,isminbusiowner -- 是否小微企业主
            ,wldcustid -- 微粒贷客户号
            ,birthday -- 生日
            ,profcountry -- 是否永久居住
            ,residencycountrycd -- 永久居住地国家代码
            ,languageind -- 语言代码
            ,embname -- 拼音名
            ,surname -- 姓氏
            ,marrystate -- 婚姻状况
            ,homephone -- 家庭电话
            ,compphone -- 单位电话
            ,qualification -- 学历
            ,degree -- 学位
            ,resideaddr -- 户籍地址
            ,matecertp -- 配偶证件类型
            ,matecerno -- 配偶证件号码
            ,matename -- 配偶姓名
            ,matecorp -- 配偶工作单位
            ,matephone -- 配偶联系电话
            ,addr -- 居住地址
            ,residestate -- 居住状况
            ,compnm -- 工作单位
            ,compaddr -- 单位地址
            ,comptrade -- 行业
            ,business -- 职务
            ,teachpose -- 职称
            ,workdate -- 本单位工作起始年份
            ,expiredate -- 有效期
            ,entname -- 企业名称
            ,entcerttype -- 企业证件类型
            ,entcreditcode -- 统一社会信用代码
            ,inputdate -- 登记日期
            ,updatedate -- 更新日期
            ,entregno -- 企业注册号
            ,entbusinessstatus -- 企业经营状态
            ,industrycode -- 行业代码
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.customerid, o.customerid) as customerid -- 客户号
    ,nvl(n.customername, o.customername) as customername -- 客户姓名
    ,nvl(n.certtype, o.certtype) as certtype -- 证件类型
    ,nvl(n.certid, o.certid) as certid -- 证件号码
    ,nvl(n.certstartdate, o.certstartdate) as certstartdate -- 证件起始日
    ,nvl(n.certmaturity, o.certmaturity) as certmaturity -- 证件到期日
    ,nvl(n.sex, o.sex) as sex -- 性别
    ,nvl(n.occupation, o.occupation) as occupation -- 职业
    ,nvl(n.nation, o.nation) as nation -- 国籍
    ,nvl(n.address, o.address) as address -- 地址
    ,nvl(n.telephone, o.telephone) as telephone -- 联系电话
    ,nvl(n.isfarmer, o.isfarmer) as isfarmer -- 农户标志
    ,nvl(n.isindividual, o.isindividual) as isindividual -- 是否个体工商户
    ,nvl(n.isminbusiowner, o.isminbusiowner) as isminbusiowner -- 是否小微企业主
    ,nvl(n.wldcustid, o.wldcustid) as wldcustid -- 微粒贷客户号
    ,nvl(n.birthday, o.birthday) as birthday -- 生日
    ,nvl(n.profcountry, o.profcountry) as profcountry -- 是否永久居住
    ,nvl(n.residencycountrycd, o.residencycountrycd) as residencycountrycd -- 永久居住地国家代码
    ,nvl(n.languageind, o.languageind) as languageind -- 语言代码
    ,nvl(n.embname, o.embname) as embname -- 拼音名
    ,nvl(n.surname, o.surname) as surname -- 姓氏
    ,nvl(n.marrystate, o.marrystate) as marrystate -- 婚姻状况
    ,nvl(n.homephone, o.homephone) as homephone -- 家庭电话
    ,nvl(n.compphone, o.compphone) as compphone -- 单位电话
    ,nvl(n.qualification, o.qualification) as qualification -- 学历
    ,nvl(n.degree, o.degree) as degree -- 学位
    ,nvl(n.resideaddr, o.resideaddr) as resideaddr -- 户籍地址
    ,nvl(n.matecertp, o.matecertp) as matecertp -- 配偶证件类型
    ,nvl(n.matecerno, o.matecerno) as matecerno -- 配偶证件号码
    ,nvl(n.matename, o.matename) as matename -- 配偶姓名
    ,nvl(n.matecorp, o.matecorp) as matecorp -- 配偶工作单位
    ,nvl(n.matephone, o.matephone) as matephone -- 配偶联系电话
    ,nvl(n.addr, o.addr) as addr -- 居住地址
    ,nvl(n.residestate, o.residestate) as residestate -- 居住状况
    ,nvl(n.compnm, o.compnm) as compnm -- 工作单位
    ,nvl(n.compaddr, o.compaddr) as compaddr -- 单位地址
    ,nvl(n.comptrade, o.comptrade) as comptrade -- 行业
    ,nvl(n.business, o.business) as business -- 职务
    ,nvl(n.teachpose, o.teachpose) as teachpose -- 职称
    ,nvl(n.workdate, o.workdate) as workdate -- 本单位工作起始年份
    ,nvl(n.expiredate, o.expiredate) as expiredate -- 有效期
    ,nvl(n.entname, o.entname) as entname -- 企业名称
    ,nvl(n.entcerttype, o.entcerttype) as entcerttype -- 企业证件类型
    ,nvl(n.entcreditcode, o.entcreditcode) as entcreditcode -- 统一社会信用代码
    ,nvl(n.inputdate, o.inputdate) as inputdate -- 登记日期
    ,nvl(n.updatedate, o.updatedate) as updatedate -- 更新日期
    ,nvl(n.entregno, o.entregno) as entregno -- 企业注册号
    ,nvl(n.entbusinessstatus, o.entbusinessstatus) as entbusinessstatus -- 企业经营状态
    ,nvl(n.industrycode, o.industrycode) as industrycode -- 行业代码
    ,case when
            n.customerid is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.customerid is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.customerid is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.icms_customer_info_wld_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.icms_customer_info_wld where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.customerid = n.customerid
where (
        o.customerid is null
    )
    or (
        n.customerid is null
    )
    or (
        o.customername <> n.customername
        or o.certtype <> n.certtype
        or o.certid <> n.certid
        or o.certstartdate <> n.certstartdate
        or o.certmaturity <> n.certmaturity
        or o.sex <> n.sex
        or o.occupation <> n.occupation
        or o.nation <> n.nation
        or o.address <> n.address
        or o.telephone <> n.telephone
        or o.isfarmer <> n.isfarmer
        or o.isindividual <> n.isindividual
        or o.isminbusiowner <> n.isminbusiowner
        or o.wldcustid <> n.wldcustid
        or o.birthday <> n.birthday
        or o.profcountry <> n.profcountry
        or o.residencycountrycd <> n.residencycountrycd
        or o.languageind <> n.languageind
        or o.embname <> n.embname
        or o.surname <> n.surname
        or o.marrystate <> n.marrystate
        or o.homephone <> n.homephone
        or o.compphone <> n.compphone
        or o.qualification <> n.qualification
        or o.degree <> n.degree
        or o.resideaddr <> n.resideaddr
        or o.matecertp <> n.matecertp
        or o.matecerno <> n.matecerno
        or o.matename <> n.matename
        or o.matecorp <> n.matecorp
        or o.matephone <> n.matephone
        or o.addr <> n.addr
        or o.residestate <> n.residestate
        or o.compnm <> n.compnm
        or o.compaddr <> n.compaddr
        or o.comptrade <> n.comptrade
        or o.business <> n.business
        or o.teachpose <> n.teachpose
        or o.workdate <> n.workdate
        or o.expiredate <> n.expiredate
        or o.entname <> n.entname
        or o.entcerttype <> n.entcerttype
        or o.entcreditcode <> n.entcreditcode
        or o.inputdate <> n.inputdate
        or o.updatedate <> n.updatedate
        or o.entregno <> n.entregno
        or o.entbusinessstatus <> n.entbusinessstatus
        or o.industrycode <> n.industrycode
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.icms_customer_info_wld_cl(
            customerid -- 客户号
            ,customername -- 客户姓名
            ,certtype -- 证件类型
            ,certid -- 证件号码
            ,certstartdate -- 证件起始日
            ,certmaturity -- 证件到期日
            ,sex -- 性别
            ,occupation -- 职业
            ,nation -- 国籍
            ,address -- 地址
            ,telephone -- 联系电话
            ,isfarmer -- 农户标志
            ,isindividual -- 是否个体工商户
            ,isminbusiowner -- 是否小微企业主
            ,wldcustid -- 微粒贷客户号
            ,birthday -- 生日
            ,profcountry -- 是否永久居住
            ,residencycountrycd -- 永久居住地国家代码
            ,languageind -- 语言代码
            ,embname -- 拼音名
            ,surname -- 姓氏
            ,marrystate -- 婚姻状况
            ,homephone -- 家庭电话
            ,compphone -- 单位电话
            ,qualification -- 学历
            ,degree -- 学位
            ,resideaddr -- 户籍地址
            ,matecertp -- 配偶证件类型
            ,matecerno -- 配偶证件号码
            ,matename -- 配偶姓名
            ,matecorp -- 配偶工作单位
            ,matephone -- 配偶联系电话
            ,addr -- 居住地址
            ,residestate -- 居住状况
            ,compnm -- 工作单位
            ,compaddr -- 单位地址
            ,comptrade -- 行业
            ,business -- 职务
            ,teachpose -- 职称
            ,workdate -- 本单位工作起始年份
            ,expiredate -- 有效期
            ,entname -- 企业名称
            ,entcerttype -- 企业证件类型
            ,entcreditcode -- 统一社会信用代码
            ,inputdate -- 登记日期
            ,updatedate -- 更新日期
            ,entregno -- 企业注册号
            ,entbusinessstatus -- 企业经营状态
            ,industrycode -- 行业代码
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.icms_customer_info_wld_op(
            customerid -- 客户号
            ,customername -- 客户姓名
            ,certtype -- 证件类型
            ,certid -- 证件号码
            ,certstartdate -- 证件起始日
            ,certmaturity -- 证件到期日
            ,sex -- 性别
            ,occupation -- 职业
            ,nation -- 国籍
            ,address -- 地址
            ,telephone -- 联系电话
            ,isfarmer -- 农户标志
            ,isindividual -- 是否个体工商户
            ,isminbusiowner -- 是否小微企业主
            ,wldcustid -- 微粒贷客户号
            ,birthday -- 生日
            ,profcountry -- 是否永久居住
            ,residencycountrycd -- 永久居住地国家代码
            ,languageind -- 语言代码
            ,embname -- 拼音名
            ,surname -- 姓氏
            ,marrystate -- 婚姻状况
            ,homephone -- 家庭电话
            ,compphone -- 单位电话
            ,qualification -- 学历
            ,degree -- 学位
            ,resideaddr -- 户籍地址
            ,matecertp -- 配偶证件类型
            ,matecerno -- 配偶证件号码
            ,matename -- 配偶姓名
            ,matecorp -- 配偶工作单位
            ,matephone -- 配偶联系电话
            ,addr -- 居住地址
            ,residestate -- 居住状况
            ,compnm -- 工作单位
            ,compaddr -- 单位地址
            ,comptrade -- 行业
            ,business -- 职务
            ,teachpose -- 职称
            ,workdate -- 本单位工作起始年份
            ,expiredate -- 有效期
            ,entname -- 企业名称
            ,entcerttype -- 企业证件类型
            ,entcreditcode -- 统一社会信用代码
            ,inputdate -- 登记日期
            ,updatedate -- 更新日期
            ,entregno -- 企业注册号
            ,entbusinessstatus -- 企业经营状态
            ,industrycode -- 行业代码
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.customerid -- 客户号
    ,o.customername -- 客户姓名
    ,o.certtype -- 证件类型
    ,o.certid -- 证件号码
    ,o.certstartdate -- 证件起始日
    ,o.certmaturity -- 证件到期日
    ,o.sex -- 性别
    ,o.occupation -- 职业
    ,o.nation -- 国籍
    ,o.address -- 地址
    ,o.telephone -- 联系电话
    ,o.isfarmer -- 农户标志
    ,o.isindividual -- 是否个体工商户
    ,o.isminbusiowner -- 是否小微企业主
    ,o.wldcustid -- 微粒贷客户号
    ,o.birthday -- 生日
    ,o.profcountry -- 是否永久居住
    ,o.residencycountrycd -- 永久居住地国家代码
    ,o.languageind -- 语言代码
    ,o.embname -- 拼音名
    ,o.surname -- 姓氏
    ,o.marrystate -- 婚姻状况
    ,o.homephone -- 家庭电话
    ,o.compphone -- 单位电话
    ,o.qualification -- 学历
    ,o.degree -- 学位
    ,o.resideaddr -- 户籍地址
    ,o.matecertp -- 配偶证件类型
    ,o.matecerno -- 配偶证件号码
    ,o.matename -- 配偶姓名
    ,o.matecorp -- 配偶工作单位
    ,o.matephone -- 配偶联系电话
    ,o.addr -- 居住地址
    ,o.residestate -- 居住状况
    ,o.compnm -- 工作单位
    ,o.compaddr -- 单位地址
    ,o.comptrade -- 行业
    ,o.business -- 职务
    ,o.teachpose -- 职称
    ,o.workdate -- 本单位工作起始年份
    ,o.expiredate -- 有效期
    ,o.entname -- 企业名称
    ,o.entcerttype -- 企业证件类型
    ,o.entcreditcode -- 统一社会信用代码
    ,o.inputdate -- 登记日期
    ,o.updatedate -- 更新日期
    ,o.entregno -- 企业注册号
    ,o.entbusinessstatus -- 企业经营状态
    ,o.industrycode -- 行业代码
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
from ${iol_schema}.icms_customer_info_wld_bk o
    left join ${iol_schema}.icms_customer_info_wld_op n
        on
            o.customerid = n.customerid
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.icms_customer_info_wld_cl d
        on
            o.customerid = d.customerid
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
--truncate table ${iol_schema}.icms_customer_info_wld;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('icms_customer_info_wld') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.icms_customer_info_wld drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.icms_customer_info_wld add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.icms_customer_info_wld exchange partition p_${batch_date} with table ${iol_schema}.icms_customer_info_wld_cl;
alter table ${iol_schema}.icms_customer_info_wld exchange partition p_20991231 with table ${iol_schema}.icms_customer_info_wld_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.icms_customer_info_wld to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.icms_customer_info_wld_op purge;
drop table ${iol_schema}.icms_customer_info_wld_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.icms_customer_info_wld_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'icms_customer_info_wld',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
