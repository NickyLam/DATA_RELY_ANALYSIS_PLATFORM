/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_icms_tm_business_enterprise_info
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
create table ${iol_schema}.icms_tm_business_enterprise_info_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.icms_tm_business_enterprise_info
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.icms_tm_business_enterprise_info_op purge;
drop table ${iol_schema}.icms_tm_business_enterprise_info_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.icms_tm_business_enterprise_info_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.icms_tm_business_enterprise_info where 0=1;

create table ${iol_schema}.icms_tm_business_enterprise_info_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.icms_tm_business_enterprise_info where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.icms_tm_business_enterprise_info_cl(
            custid -- 客户编号
            ,name -- 姓名
            ,idno -- 证件号码
            ,identifybizno -- 认定流水号
            ,identifytype -- 经营身份类型
            ,identifystatus -- 经营身份状态
            ,fundedratio -- 出资比例
            ,affirmtime -- 认定时间
            ,entcreditcode -- 统一社会信用代码
            ,entregno -- 企业注册号
            ,orgcode -- 组织机构代码
            ,entname -- 企业名称
            ,enttype -- 企业类型
            ,entbusinessstatus -- 企业经营状态
            ,esdate -- 企业成立日期
            ,industryname -- 行业名称
            ,industrycode -- 行业代码
            ,industrycategory -- 行业分类
            ,affirmorg -- 登记机构
            ,reserve1 -- 注册地址
            ,reserve2 -- 注册地址编码
            ,reserve3 -- 备份字段
            ,reserve4 -- 备份字段
            ,reserve5 -- 备份字段
            ,reserve6 -- 备份字段
            ,reserve7 -- 备份字段
            ,reserve8 -- 备份字段
            ,reserve9 -- 备份字段
            ,reserve10 -- 备份字段
            ,reserve11 -- 备份字段
            ,reserve12 -- 备份字段
            ,reserve13 -- 备份字段
            ,reserve14 -- 备份字段
            ,reserve15 -- 备份字段
            ,reserve16 -- 备份字段
            ,reserve17 -- 备份字段
            ,reserve18 -- 备份字段
            ,reserve19 -- 备份字段
            ,reserve20 -- 备份字段
            ,reserve21 -- 备份字段
            ,reserve22 -- 备份字段
            ,reserve23 -- 备份字段
            ,reserve24 -- 备份字段
            ,reserve25 -- 备份字段
            ,reserve26 -- 备份字段
            ,reserve27 -- 备份字段
            ,reserve28 -- 备份字段
            ,reserve29 -- 备份字段
            ,reserve30 -- 备份字段
            ,reserve31 -- 备份字段
            ,reserve32 -- 备份字段
            ,reserve33 -- 备份字段
            ,reserve34 -- 备份字段
            ,reserve35 -- 备份字段
            ,reserve36 -- 备份字段
            ,reserve37 -- 备份字段
            ,reserve38 -- 备份字段
            ,reserve39 -- 备份字段
            ,reserve40 -- 备份字段
            ,reserve41 -- 备份字段
            ,reserve42 -- 备份字段
            ,reserve43 -- 备份字段
            ,reserve44 -- 备份字段
            ,reserve45 -- 备份字段
            ,reserve46 -- 备份字段
            ,reserve47 -- 备份字段
            ,reserve48 -- 备份字段
            ,reserve49 -- 备份字段
            ,reserve50 -- 备份字段
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.icms_tm_business_enterprise_info_op(
            custid -- 客户编号
            ,name -- 姓名
            ,idno -- 证件号码
            ,identifybizno -- 认定流水号
            ,identifytype -- 经营身份类型
            ,identifystatus -- 经营身份状态
            ,fundedratio -- 出资比例
            ,affirmtime -- 认定时间
            ,entcreditcode -- 统一社会信用代码
            ,entregno -- 企业注册号
            ,orgcode -- 组织机构代码
            ,entname -- 企业名称
            ,enttype -- 企业类型
            ,entbusinessstatus -- 企业经营状态
            ,esdate -- 企业成立日期
            ,industryname -- 行业名称
            ,industrycode -- 行业代码
            ,industrycategory -- 行业分类
            ,affirmorg -- 登记机构
            ,reserve1 -- 注册地址
            ,reserve2 -- 注册地址编码
            ,reserve3 -- 备份字段
            ,reserve4 -- 备份字段
            ,reserve5 -- 备份字段
            ,reserve6 -- 备份字段
            ,reserve7 -- 备份字段
            ,reserve8 -- 备份字段
            ,reserve9 -- 备份字段
            ,reserve10 -- 备份字段
            ,reserve11 -- 备份字段
            ,reserve12 -- 备份字段
            ,reserve13 -- 备份字段
            ,reserve14 -- 备份字段
            ,reserve15 -- 备份字段
            ,reserve16 -- 备份字段
            ,reserve17 -- 备份字段
            ,reserve18 -- 备份字段
            ,reserve19 -- 备份字段
            ,reserve20 -- 备份字段
            ,reserve21 -- 备份字段
            ,reserve22 -- 备份字段
            ,reserve23 -- 备份字段
            ,reserve24 -- 备份字段
            ,reserve25 -- 备份字段
            ,reserve26 -- 备份字段
            ,reserve27 -- 备份字段
            ,reserve28 -- 备份字段
            ,reserve29 -- 备份字段
            ,reserve30 -- 备份字段
            ,reserve31 -- 备份字段
            ,reserve32 -- 备份字段
            ,reserve33 -- 备份字段
            ,reserve34 -- 备份字段
            ,reserve35 -- 备份字段
            ,reserve36 -- 备份字段
            ,reserve37 -- 备份字段
            ,reserve38 -- 备份字段
            ,reserve39 -- 备份字段
            ,reserve40 -- 备份字段
            ,reserve41 -- 备份字段
            ,reserve42 -- 备份字段
            ,reserve43 -- 备份字段
            ,reserve44 -- 备份字段
            ,reserve45 -- 备份字段
            ,reserve46 -- 备份字段
            ,reserve47 -- 备份字段
            ,reserve48 -- 备份字段
            ,reserve49 -- 备份字段
            ,reserve50 -- 备份字段
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.custid, o.custid) as custid -- 客户编号
    ,nvl(n.name, o.name) as name -- 姓名
    ,nvl(n.idno, o.idno) as idno -- 证件号码
    ,nvl(n.identifybizno, o.identifybizno) as identifybizno -- 认定流水号
    ,nvl(n.identifytype, o.identifytype) as identifytype -- 经营身份类型
    ,nvl(n.identifystatus, o.identifystatus) as identifystatus -- 经营身份状态
    ,nvl(n.fundedratio, o.fundedratio) as fundedratio -- 出资比例
    ,nvl(n.affirmtime, o.affirmtime) as affirmtime -- 认定时间
    ,nvl(n.entcreditcode, o.entcreditcode) as entcreditcode -- 统一社会信用代码
    ,nvl(n.entregno, o.entregno) as entregno -- 企业注册号
    ,nvl(n.orgcode, o.orgcode) as orgcode -- 组织机构代码
    ,nvl(n.entname, o.entname) as entname -- 企业名称
    ,nvl(n.enttype, o.enttype) as enttype -- 企业类型
    ,nvl(n.entbusinessstatus, o.entbusinessstatus) as entbusinessstatus -- 企业经营状态
    ,nvl(n.esdate, o.esdate) as esdate -- 企业成立日期
    ,nvl(n.industryname, o.industryname) as industryname -- 行业名称
    ,nvl(n.industrycode, o.industrycode) as industrycode -- 行业代码
    ,nvl(n.industrycategory, o.industrycategory) as industrycategory -- 行业分类
    ,nvl(n.affirmorg, o.affirmorg) as affirmorg -- 登记机构
    ,nvl(n.reserve1, o.reserve1) as reserve1 -- 注册地址
    ,nvl(n.reserve2, o.reserve2) as reserve2 -- 注册地址编码
    ,nvl(n.reserve3, o.reserve3) as reserve3 -- 备份字段
    ,nvl(n.reserve4, o.reserve4) as reserve4 -- 备份字段
    ,nvl(n.reserve5, o.reserve5) as reserve5 -- 备份字段
    ,nvl(n.reserve6, o.reserve6) as reserve6 -- 备份字段
    ,nvl(n.reserve7, o.reserve7) as reserve7 -- 备份字段
    ,nvl(n.reserve8, o.reserve8) as reserve8 -- 备份字段
    ,nvl(n.reserve9, o.reserve9) as reserve9 -- 备份字段
    ,nvl(n.reserve10, o.reserve10) as reserve10 -- 备份字段
    ,nvl(n.reserve11, o.reserve11) as reserve11 -- 备份字段
    ,nvl(n.reserve12, o.reserve12) as reserve12 -- 备份字段
    ,nvl(n.reserve13, o.reserve13) as reserve13 -- 备份字段
    ,nvl(n.reserve14, o.reserve14) as reserve14 -- 备份字段
    ,nvl(n.reserve15, o.reserve15) as reserve15 -- 备份字段
    ,nvl(n.reserve16, o.reserve16) as reserve16 -- 备份字段
    ,nvl(n.reserve17, o.reserve17) as reserve17 -- 备份字段
    ,nvl(n.reserve18, o.reserve18) as reserve18 -- 备份字段
    ,nvl(n.reserve19, o.reserve19) as reserve19 -- 备份字段
    ,nvl(n.reserve20, o.reserve20) as reserve20 -- 备份字段
    ,nvl(n.reserve21, o.reserve21) as reserve21 -- 备份字段
    ,nvl(n.reserve22, o.reserve22) as reserve22 -- 备份字段
    ,nvl(n.reserve23, o.reserve23) as reserve23 -- 备份字段
    ,nvl(n.reserve24, o.reserve24) as reserve24 -- 备份字段
    ,nvl(n.reserve25, o.reserve25) as reserve25 -- 备份字段
    ,nvl(n.reserve26, o.reserve26) as reserve26 -- 备份字段
    ,nvl(n.reserve27, o.reserve27) as reserve27 -- 备份字段
    ,nvl(n.reserve28, o.reserve28) as reserve28 -- 备份字段
    ,nvl(n.reserve29, o.reserve29) as reserve29 -- 备份字段
    ,nvl(n.reserve30, o.reserve30) as reserve30 -- 备份字段
    ,nvl(n.reserve31, o.reserve31) as reserve31 -- 备份字段
    ,nvl(n.reserve32, o.reserve32) as reserve32 -- 备份字段
    ,nvl(n.reserve33, o.reserve33) as reserve33 -- 备份字段
    ,nvl(n.reserve34, o.reserve34) as reserve34 -- 备份字段
    ,nvl(n.reserve35, o.reserve35) as reserve35 -- 备份字段
    ,nvl(n.reserve36, o.reserve36) as reserve36 -- 备份字段
    ,nvl(n.reserve37, o.reserve37) as reserve37 -- 备份字段
    ,nvl(n.reserve38, o.reserve38) as reserve38 -- 备份字段
    ,nvl(n.reserve39, o.reserve39) as reserve39 -- 备份字段
    ,nvl(n.reserve40, o.reserve40) as reserve40 -- 备份字段
    ,nvl(n.reserve41, o.reserve41) as reserve41 -- 备份字段
    ,nvl(n.reserve42, o.reserve42) as reserve42 -- 备份字段
    ,nvl(n.reserve43, o.reserve43) as reserve43 -- 备份字段
    ,nvl(n.reserve44, o.reserve44) as reserve44 -- 备份字段
    ,nvl(n.reserve45, o.reserve45) as reserve45 -- 备份字段
    ,nvl(n.reserve46, o.reserve46) as reserve46 -- 备份字段
    ,nvl(n.reserve47, o.reserve47) as reserve47 -- 备份字段
    ,nvl(n.reserve48, o.reserve48) as reserve48 -- 备份字段
    ,nvl(n.reserve49, o.reserve49) as reserve49 -- 备份字段
    ,nvl(n.reserve50, o.reserve50) as reserve50 -- 备份字段
    ,case when
            n.custid is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.custid is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.custid is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.icms_tm_business_enterprise_info_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.icms_tm_business_enterprise_info where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.custid = n.custid
where (
        o.custid is null
    )
    or (
        n.custid is null
    )
    or (
        o.name <> n.name
        or o.idno <> n.idno
        or o.identifybizno <> n.identifybizno
        or o.identifytype <> n.identifytype
        or o.identifystatus <> n.identifystatus
        or o.fundedratio <> n.fundedratio
        or o.affirmtime <> n.affirmtime
        or o.entcreditcode <> n.entcreditcode
        or o.entregno <> n.entregno
        or o.orgcode <> n.orgcode
        or o.entname <> n.entname
        or o.enttype <> n.enttype
        or o.entbusinessstatus <> n.entbusinessstatus
        or o.esdate <> n.esdate
        or o.industryname <> n.industryname
        or o.industrycode <> n.industrycode
        or o.industrycategory <> n.industrycategory
        or o.affirmorg <> n.affirmorg
        or o.reserve1 <> n.reserve1
        or o.reserve2 <> n.reserve2
        or o.reserve3 <> n.reserve3
        or o.reserve4 <> n.reserve4
        or o.reserve5 <> n.reserve5
        or o.reserve6 <> n.reserve6
        or o.reserve7 <> n.reserve7
        or o.reserve8 <> n.reserve8
        or o.reserve9 <> n.reserve9
        or o.reserve10 <> n.reserve10
        or o.reserve11 <> n.reserve11
        or o.reserve12 <> n.reserve12
        or o.reserve13 <> n.reserve13
        or o.reserve14 <> n.reserve14
        or o.reserve15 <> n.reserve15
        or o.reserve16 <> n.reserve16
        or o.reserve17 <> n.reserve17
        or o.reserve18 <> n.reserve18
        or o.reserve19 <> n.reserve19
        or o.reserve20 <> n.reserve20
        or o.reserve21 <> n.reserve21
        or o.reserve22 <> n.reserve22
        or o.reserve23 <> n.reserve23
        or o.reserve24 <> n.reserve24
        or o.reserve25 <> n.reserve25
        or o.reserve26 <> n.reserve26
        or o.reserve27 <> n.reserve27
        or o.reserve28 <> n.reserve28
        or o.reserve29 <> n.reserve29
        or o.reserve30 <> n.reserve30
        or o.reserve31 <> n.reserve31
        or o.reserve32 <> n.reserve32
        or o.reserve33 <> n.reserve33
        or o.reserve34 <> n.reserve34
        or o.reserve35 <> n.reserve35
        or o.reserve36 <> n.reserve36
        or o.reserve37 <> n.reserve37
        or o.reserve38 <> n.reserve38
        or o.reserve39 <> n.reserve39
        or o.reserve40 <> n.reserve40
        or o.reserve41 <> n.reserve41
        or o.reserve42 <> n.reserve42
        or o.reserve43 <> n.reserve43
        or o.reserve44 <> n.reserve44
        or o.reserve45 <> n.reserve45
        or o.reserve46 <> n.reserve46
        or o.reserve47 <> n.reserve47
        or o.reserve48 <> n.reserve48
        or o.reserve49 <> n.reserve49
        or o.reserve50 <> n.reserve50
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.icms_tm_business_enterprise_info_cl(
            custid -- 客户编号
            ,name -- 姓名
            ,idno -- 证件号码
            ,identifybizno -- 认定流水号
            ,identifytype -- 经营身份类型
            ,identifystatus -- 经营身份状态
            ,fundedratio -- 出资比例
            ,affirmtime -- 认定时间
            ,entcreditcode -- 统一社会信用代码
            ,entregno -- 企业注册号
            ,orgcode -- 组织机构代码
            ,entname -- 企业名称
            ,enttype -- 企业类型
            ,entbusinessstatus -- 企业经营状态
            ,esdate -- 企业成立日期
            ,industryname -- 行业名称
            ,industrycode -- 行业代码
            ,industrycategory -- 行业分类
            ,affirmorg -- 登记机构
            ,reserve1 -- 注册地址
            ,reserve2 -- 注册地址编码
            ,reserve3 -- 备份字段
            ,reserve4 -- 备份字段
            ,reserve5 -- 备份字段
            ,reserve6 -- 备份字段
            ,reserve7 -- 备份字段
            ,reserve8 -- 备份字段
            ,reserve9 -- 备份字段
            ,reserve10 -- 备份字段
            ,reserve11 -- 备份字段
            ,reserve12 -- 备份字段
            ,reserve13 -- 备份字段
            ,reserve14 -- 备份字段
            ,reserve15 -- 备份字段
            ,reserve16 -- 备份字段
            ,reserve17 -- 备份字段
            ,reserve18 -- 备份字段
            ,reserve19 -- 备份字段
            ,reserve20 -- 备份字段
            ,reserve21 -- 备份字段
            ,reserve22 -- 备份字段
            ,reserve23 -- 备份字段
            ,reserve24 -- 备份字段
            ,reserve25 -- 备份字段
            ,reserve26 -- 备份字段
            ,reserve27 -- 备份字段
            ,reserve28 -- 备份字段
            ,reserve29 -- 备份字段
            ,reserve30 -- 备份字段
            ,reserve31 -- 备份字段
            ,reserve32 -- 备份字段
            ,reserve33 -- 备份字段
            ,reserve34 -- 备份字段
            ,reserve35 -- 备份字段
            ,reserve36 -- 备份字段
            ,reserve37 -- 备份字段
            ,reserve38 -- 备份字段
            ,reserve39 -- 备份字段
            ,reserve40 -- 备份字段
            ,reserve41 -- 备份字段
            ,reserve42 -- 备份字段
            ,reserve43 -- 备份字段
            ,reserve44 -- 备份字段
            ,reserve45 -- 备份字段
            ,reserve46 -- 备份字段
            ,reserve47 -- 备份字段
            ,reserve48 -- 备份字段
            ,reserve49 -- 备份字段
            ,reserve50 -- 备份字段
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.icms_tm_business_enterprise_info_op(
            custid -- 客户编号
            ,name -- 姓名
            ,idno -- 证件号码
            ,identifybizno -- 认定流水号
            ,identifytype -- 经营身份类型
            ,identifystatus -- 经营身份状态
            ,fundedratio -- 出资比例
            ,affirmtime -- 认定时间
            ,entcreditcode -- 统一社会信用代码
            ,entregno -- 企业注册号
            ,orgcode -- 组织机构代码
            ,entname -- 企业名称
            ,enttype -- 企业类型
            ,entbusinessstatus -- 企业经营状态
            ,esdate -- 企业成立日期
            ,industryname -- 行业名称
            ,industrycode -- 行业代码
            ,industrycategory -- 行业分类
            ,affirmorg -- 登记机构
            ,reserve1 -- 注册地址
            ,reserve2 -- 注册地址编码
            ,reserve3 -- 备份字段
            ,reserve4 -- 备份字段
            ,reserve5 -- 备份字段
            ,reserve6 -- 备份字段
            ,reserve7 -- 备份字段
            ,reserve8 -- 备份字段
            ,reserve9 -- 备份字段
            ,reserve10 -- 备份字段
            ,reserve11 -- 备份字段
            ,reserve12 -- 备份字段
            ,reserve13 -- 备份字段
            ,reserve14 -- 备份字段
            ,reserve15 -- 备份字段
            ,reserve16 -- 备份字段
            ,reserve17 -- 备份字段
            ,reserve18 -- 备份字段
            ,reserve19 -- 备份字段
            ,reserve20 -- 备份字段
            ,reserve21 -- 备份字段
            ,reserve22 -- 备份字段
            ,reserve23 -- 备份字段
            ,reserve24 -- 备份字段
            ,reserve25 -- 备份字段
            ,reserve26 -- 备份字段
            ,reserve27 -- 备份字段
            ,reserve28 -- 备份字段
            ,reserve29 -- 备份字段
            ,reserve30 -- 备份字段
            ,reserve31 -- 备份字段
            ,reserve32 -- 备份字段
            ,reserve33 -- 备份字段
            ,reserve34 -- 备份字段
            ,reserve35 -- 备份字段
            ,reserve36 -- 备份字段
            ,reserve37 -- 备份字段
            ,reserve38 -- 备份字段
            ,reserve39 -- 备份字段
            ,reserve40 -- 备份字段
            ,reserve41 -- 备份字段
            ,reserve42 -- 备份字段
            ,reserve43 -- 备份字段
            ,reserve44 -- 备份字段
            ,reserve45 -- 备份字段
            ,reserve46 -- 备份字段
            ,reserve47 -- 备份字段
            ,reserve48 -- 备份字段
            ,reserve49 -- 备份字段
            ,reserve50 -- 备份字段
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.custid -- 客户编号
    ,o.name -- 姓名
    ,o.idno -- 证件号码
    ,o.identifybizno -- 认定流水号
    ,o.identifytype -- 经营身份类型
    ,o.identifystatus -- 经营身份状态
    ,o.fundedratio -- 出资比例
    ,o.affirmtime -- 认定时间
    ,o.entcreditcode -- 统一社会信用代码
    ,o.entregno -- 企业注册号
    ,o.orgcode -- 组织机构代码
    ,o.entname -- 企业名称
    ,o.enttype -- 企业类型
    ,o.entbusinessstatus -- 企业经营状态
    ,o.esdate -- 企业成立日期
    ,o.industryname -- 行业名称
    ,o.industrycode -- 行业代码
    ,o.industrycategory -- 行业分类
    ,o.affirmorg -- 登记机构
    ,o.reserve1 -- 注册地址
    ,o.reserve2 -- 注册地址编码
    ,o.reserve3 -- 备份字段
    ,o.reserve4 -- 备份字段
    ,o.reserve5 -- 备份字段
    ,o.reserve6 -- 备份字段
    ,o.reserve7 -- 备份字段
    ,o.reserve8 -- 备份字段
    ,o.reserve9 -- 备份字段
    ,o.reserve10 -- 备份字段
    ,o.reserve11 -- 备份字段
    ,o.reserve12 -- 备份字段
    ,o.reserve13 -- 备份字段
    ,o.reserve14 -- 备份字段
    ,o.reserve15 -- 备份字段
    ,o.reserve16 -- 备份字段
    ,o.reserve17 -- 备份字段
    ,o.reserve18 -- 备份字段
    ,o.reserve19 -- 备份字段
    ,o.reserve20 -- 备份字段
    ,o.reserve21 -- 备份字段
    ,o.reserve22 -- 备份字段
    ,o.reserve23 -- 备份字段
    ,o.reserve24 -- 备份字段
    ,o.reserve25 -- 备份字段
    ,o.reserve26 -- 备份字段
    ,o.reserve27 -- 备份字段
    ,o.reserve28 -- 备份字段
    ,o.reserve29 -- 备份字段
    ,o.reserve30 -- 备份字段
    ,o.reserve31 -- 备份字段
    ,o.reserve32 -- 备份字段
    ,o.reserve33 -- 备份字段
    ,o.reserve34 -- 备份字段
    ,o.reserve35 -- 备份字段
    ,o.reserve36 -- 备份字段
    ,o.reserve37 -- 备份字段
    ,o.reserve38 -- 备份字段
    ,o.reserve39 -- 备份字段
    ,o.reserve40 -- 备份字段
    ,o.reserve41 -- 备份字段
    ,o.reserve42 -- 备份字段
    ,o.reserve43 -- 备份字段
    ,o.reserve44 -- 备份字段
    ,o.reserve45 -- 备份字段
    ,o.reserve46 -- 备份字段
    ,o.reserve47 -- 备份字段
    ,o.reserve48 -- 备份字段
    ,o.reserve49 -- 备份字段
    ,o.reserve50 -- 备份字段
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
from ${iol_schema}.icms_tm_business_enterprise_info_bk o
    left join ${iol_schema}.icms_tm_business_enterprise_info_op n
        on
            o.custid = n.custid
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.icms_tm_business_enterprise_info_cl d
        on
            o.custid = d.custid
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
--truncate table ${iol_schema}.icms_tm_business_enterprise_info;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('icms_tm_business_enterprise_info') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.icms_tm_business_enterprise_info drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.icms_tm_business_enterprise_info add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.icms_tm_business_enterprise_info exchange partition p_${batch_date} with table ${iol_schema}.icms_tm_business_enterprise_info_cl;
alter table ${iol_schema}.icms_tm_business_enterprise_info exchange partition p_20991231 with table ${iol_schema}.icms_tm_business_enterprise_info_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.icms_tm_business_enterprise_info to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.icms_tm_business_enterprise_info_op purge;
drop table ${iol_schema}.icms_tm_business_enterprise_info_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.icms_tm_business_enterprise_info_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'icms_tm_business_enterprise_info',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
