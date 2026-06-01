/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_amss_cms_industry
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
create table ${iol_schema}.amss_cms_industry_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.amss_cms_industry
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.amss_cms_industry_op purge;
drop table ${iol_schema}.amss_cms_industry_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.amss_cms_industry_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.amss_cms_industry where 0=1;

create table ${iol_schema}.amss_cms_industry_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.amss_cms_industry where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.amss_cms_industry_cl(
            industry_id -- 行业ID.
            ,industry_name -- 行业名称.
            ,parent_industry -- 所属行业.
            ,thi_industry -- 第三方行业类别.商户信息报备时使用
            ,deal_type -- 经营类型.1:实体;2:虚拟
            ,remark -- 备注.
            ,create_user -- 创建用户.
            ,create_emp -- 创建人.
            ,create_time -- 创建时间.
            ,update_time -- 更新时间.
            ,ali_industry -- 阿里第三方行业类别
            ,qq_industry -- qq行业类别
            ,alipay_authorization_desc -- 描述需要哪些执照和许可证，创建支付宝门店的时候需要用到
            ,ali_v2_industry -- 支付宝V2报备行业类别
            ,best_pay_industry -- 翼支付行业类别
            ,hebao_industry -- 和包行业类别
            ,yifubao_industry -- 易付宝行业类别
            ,union_pay_industry -- 银联二维码行业类别
            ,shengfutong_industry -- 盛付通行业类别
            ,jd_industry -- 京东行业类别
            ,union_qq_industry -- 银联QQ钱包行业类别
            ,mcc -- MCC码
            ,fld_s1 -- 字符备用1
            ,fld_s2 -- 字符备用2
            ,fld_s3 -- 字符备用3
            ,fld_s4 -- 字符备用4
            ,fld_s5 -- 字符备用5
            ,yz_industry -- 银总行业类别
            ,wx_settlement_id_normal -- 微信结算id(普通)
            ,wx_settlement_id_newsmall -- 微信结算id(小微)
            ,wx_settlement_id_normal2 -- 
            ,wx_settlement_id_newsmall2 -- 
            ,bank_industry -- 银行的行业Id
            ,union_unstandard_flag -- 银联非标费率标识，0-标准费率;1-可非标费率
            ,root_industry -- ROOT行业类别
            ,industry_level -- 行业分级
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.amss_cms_industry_op(
            industry_id -- 行业ID.
            ,industry_name -- 行业名称.
            ,parent_industry -- 所属行业.
            ,thi_industry -- 第三方行业类别.商户信息报备时使用
            ,deal_type -- 经营类型.1:实体;2:虚拟
            ,remark -- 备注.
            ,create_user -- 创建用户.
            ,create_emp -- 创建人.
            ,create_time -- 创建时间.
            ,update_time -- 更新时间.
            ,ali_industry -- 阿里第三方行业类别
            ,qq_industry -- qq行业类别
            ,alipay_authorization_desc -- 描述需要哪些执照和许可证，创建支付宝门店的时候需要用到
            ,ali_v2_industry -- 支付宝V2报备行业类别
            ,best_pay_industry -- 翼支付行业类别
            ,hebao_industry -- 和包行业类别
            ,yifubao_industry -- 易付宝行业类别
            ,union_pay_industry -- 银联二维码行业类别
            ,shengfutong_industry -- 盛付通行业类别
            ,jd_industry -- 京东行业类别
            ,union_qq_industry -- 银联QQ钱包行业类别
            ,mcc -- MCC码
            ,fld_s1 -- 字符备用1
            ,fld_s2 -- 字符备用2
            ,fld_s3 -- 字符备用3
            ,fld_s4 -- 字符备用4
            ,fld_s5 -- 字符备用5
            ,yz_industry -- 银总行业类别
            ,wx_settlement_id_normal -- 微信结算id(普通)
            ,wx_settlement_id_newsmall -- 微信结算id(小微)
            ,wx_settlement_id_normal2 -- 
            ,wx_settlement_id_newsmall2 -- 
            ,bank_industry -- 银行的行业Id
            ,union_unstandard_flag -- 银联非标费率标识，0-标准费率;1-可非标费率
            ,root_industry -- ROOT行业类别
            ,industry_level -- 行业分级
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.industry_id, o.industry_id) as industry_id -- 行业ID.
    ,nvl(n.industry_name, o.industry_name) as industry_name -- 行业名称.
    ,nvl(n.parent_industry, o.parent_industry) as parent_industry -- 所属行业.
    ,nvl(n.thi_industry, o.thi_industry) as thi_industry -- 第三方行业类别.商户信息报备时使用
    ,nvl(n.deal_type, o.deal_type) as deal_type -- 经营类型.1:实体;2:虚拟
    ,nvl(n.remark, o.remark) as remark -- 备注.
    ,nvl(n.create_user, o.create_user) as create_user -- 创建用户.
    ,nvl(n.create_emp, o.create_emp) as create_emp -- 创建人.
    ,nvl(n.create_time, o.create_time) as create_time -- 创建时间.
    ,nvl(n.update_time, o.update_time) as update_time -- 更新时间.
    ,nvl(n.ali_industry, o.ali_industry) as ali_industry -- 阿里第三方行业类别
    ,nvl(n.qq_industry, o.qq_industry) as qq_industry -- qq行业类别
    ,nvl(n.alipay_authorization_desc, o.alipay_authorization_desc) as alipay_authorization_desc -- 描述需要哪些执照和许可证，创建支付宝门店的时候需要用到
    ,nvl(n.ali_v2_industry, o.ali_v2_industry) as ali_v2_industry -- 支付宝V2报备行业类别
    ,nvl(n.best_pay_industry, o.best_pay_industry) as best_pay_industry -- 翼支付行业类别
    ,nvl(n.hebao_industry, o.hebao_industry) as hebao_industry -- 和包行业类别
    ,nvl(n.yifubao_industry, o.yifubao_industry) as yifubao_industry -- 易付宝行业类别
    ,nvl(n.union_pay_industry, o.union_pay_industry) as union_pay_industry -- 银联二维码行业类别
    ,nvl(n.shengfutong_industry, o.shengfutong_industry) as shengfutong_industry -- 盛付通行业类别
    ,nvl(n.jd_industry, o.jd_industry) as jd_industry -- 京东行业类别
    ,nvl(n.union_qq_industry, o.union_qq_industry) as union_qq_industry -- 银联QQ钱包行业类别
    ,nvl(n.mcc, o.mcc) as mcc -- MCC码
    ,nvl(n.fld_s1, o.fld_s1) as fld_s1 -- 字符备用1
    ,nvl(n.fld_s2, o.fld_s2) as fld_s2 -- 字符备用2
    ,nvl(n.fld_s3, o.fld_s3) as fld_s3 -- 字符备用3
    ,nvl(n.fld_s4, o.fld_s4) as fld_s4 -- 字符备用4
    ,nvl(n.fld_s5, o.fld_s5) as fld_s5 -- 字符备用5
    ,nvl(n.yz_industry, o.yz_industry) as yz_industry -- 银总行业类别
    ,nvl(n.wx_settlement_id_normal, o.wx_settlement_id_normal) as wx_settlement_id_normal -- 微信结算id(普通)
    ,nvl(n.wx_settlement_id_newsmall, o.wx_settlement_id_newsmall) as wx_settlement_id_newsmall -- 微信结算id(小微)
    ,nvl(n.wx_settlement_id_normal2, o.wx_settlement_id_normal2) as wx_settlement_id_normal2 -- 
    ,nvl(n.wx_settlement_id_newsmall2, o.wx_settlement_id_newsmall2) as wx_settlement_id_newsmall2 -- 
    ,nvl(n.bank_industry, o.bank_industry) as bank_industry -- 银行的行业Id
    ,nvl(n.union_unstandard_flag, o.union_unstandard_flag) as union_unstandard_flag -- 银联非标费率标识，0-标准费率;1-可非标费率
    ,nvl(n.root_industry, o.root_industry) as root_industry -- ROOT行业类别
    ,nvl(n.industry_level, o.industry_level) as industry_level -- 行业分级
    ,case when
            n.industry_id is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.industry_id is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.industry_id is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.amss_cms_industry_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.amss_cms_industry where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.industry_id = n.industry_id
where (
        o.industry_id is null
    )
    or (
        n.industry_id is null
    )
    or (
        o.industry_name <> n.industry_name
        or o.parent_industry <> n.parent_industry
        or o.thi_industry <> n.thi_industry
        or o.deal_type <> n.deal_type
        or o.remark <> n.remark
        or o.create_user <> n.create_user
        or o.create_emp <> n.create_emp
        or o.create_time <> n.create_time
        or o.update_time <> n.update_time
        or o.ali_industry <> n.ali_industry
        or o.qq_industry <> n.qq_industry
        or o.alipay_authorization_desc <> n.alipay_authorization_desc
        or o.ali_v2_industry <> n.ali_v2_industry
        or o.best_pay_industry <> n.best_pay_industry
        or o.hebao_industry <> n.hebao_industry
        or o.yifubao_industry <> n.yifubao_industry
        or o.union_pay_industry <> n.union_pay_industry
        or o.shengfutong_industry <> n.shengfutong_industry
        or o.jd_industry <> n.jd_industry
        or o.union_qq_industry <> n.union_qq_industry
        or o.mcc <> n.mcc
        or o.fld_s1 <> n.fld_s1
        or o.fld_s2 <> n.fld_s2
        or o.fld_s3 <> n.fld_s3
        or o.fld_s4 <> n.fld_s4
        or o.fld_s5 <> n.fld_s5
        or o.yz_industry <> n.yz_industry
        or o.wx_settlement_id_normal <> n.wx_settlement_id_normal
        or o.wx_settlement_id_newsmall <> n.wx_settlement_id_newsmall
        or o.wx_settlement_id_normal2 <> n.wx_settlement_id_normal2
        or o.wx_settlement_id_newsmall2 <> n.wx_settlement_id_newsmall2
        or o.bank_industry <> n.bank_industry
        or o.union_unstandard_flag <> n.union_unstandard_flag
        or o.root_industry <> n.root_industry
        or o.industry_level <> n.industry_level
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.amss_cms_industry_cl(
            industry_id -- 行业ID.
            ,industry_name -- 行业名称.
            ,parent_industry -- 所属行业.
            ,thi_industry -- 第三方行业类别.商户信息报备时使用
            ,deal_type -- 经营类型.1:实体;2:虚拟
            ,remark -- 备注.
            ,create_user -- 创建用户.
            ,create_emp -- 创建人.
            ,create_time -- 创建时间.
            ,update_time -- 更新时间.
            ,ali_industry -- 阿里第三方行业类别
            ,qq_industry -- qq行业类别
            ,alipay_authorization_desc -- 描述需要哪些执照和许可证，创建支付宝门店的时候需要用到
            ,ali_v2_industry -- 支付宝V2报备行业类别
            ,best_pay_industry -- 翼支付行业类别
            ,hebao_industry -- 和包行业类别
            ,yifubao_industry -- 易付宝行业类别
            ,union_pay_industry -- 银联二维码行业类别
            ,shengfutong_industry -- 盛付通行业类别
            ,jd_industry -- 京东行业类别
            ,union_qq_industry -- 银联QQ钱包行业类别
            ,mcc -- MCC码
            ,fld_s1 -- 字符备用1
            ,fld_s2 -- 字符备用2
            ,fld_s3 -- 字符备用3
            ,fld_s4 -- 字符备用4
            ,fld_s5 -- 字符备用5
            ,yz_industry -- 银总行业类别
            ,wx_settlement_id_normal -- 微信结算id(普通)
            ,wx_settlement_id_newsmall -- 微信结算id(小微)
            ,wx_settlement_id_normal2 -- 
            ,wx_settlement_id_newsmall2 -- 
            ,bank_industry -- 银行的行业Id
            ,union_unstandard_flag -- 银联非标费率标识，0-标准费率;1-可非标费率
            ,root_industry -- ROOT行业类别
            ,industry_level -- 行业分级
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.amss_cms_industry_op(
            industry_id -- 行业ID.
            ,industry_name -- 行业名称.
            ,parent_industry -- 所属行业.
            ,thi_industry -- 第三方行业类别.商户信息报备时使用
            ,deal_type -- 经营类型.1:实体;2:虚拟
            ,remark -- 备注.
            ,create_user -- 创建用户.
            ,create_emp -- 创建人.
            ,create_time -- 创建时间.
            ,update_time -- 更新时间.
            ,ali_industry -- 阿里第三方行业类别
            ,qq_industry -- qq行业类别
            ,alipay_authorization_desc -- 描述需要哪些执照和许可证，创建支付宝门店的时候需要用到
            ,ali_v2_industry -- 支付宝V2报备行业类别
            ,best_pay_industry -- 翼支付行业类别
            ,hebao_industry -- 和包行业类别
            ,yifubao_industry -- 易付宝行业类别
            ,union_pay_industry -- 银联二维码行业类别
            ,shengfutong_industry -- 盛付通行业类别
            ,jd_industry -- 京东行业类别
            ,union_qq_industry -- 银联QQ钱包行业类别
            ,mcc -- MCC码
            ,fld_s1 -- 字符备用1
            ,fld_s2 -- 字符备用2
            ,fld_s3 -- 字符备用3
            ,fld_s4 -- 字符备用4
            ,fld_s5 -- 字符备用5
            ,yz_industry -- 银总行业类别
            ,wx_settlement_id_normal -- 微信结算id(普通)
            ,wx_settlement_id_newsmall -- 微信结算id(小微)
            ,wx_settlement_id_normal2 -- 
            ,wx_settlement_id_newsmall2 -- 
            ,bank_industry -- 银行的行业Id
            ,union_unstandard_flag -- 银联非标费率标识，0-标准费率;1-可非标费率
            ,root_industry -- ROOT行业类别
            ,industry_level -- 行业分级
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.industry_id -- 行业ID.
    ,o.industry_name -- 行业名称.
    ,o.parent_industry -- 所属行业.
    ,o.thi_industry -- 第三方行业类别.商户信息报备时使用
    ,o.deal_type -- 经营类型.1:实体;2:虚拟
    ,o.remark -- 备注.
    ,o.create_user -- 创建用户.
    ,o.create_emp -- 创建人.
    ,o.create_time -- 创建时间.
    ,o.update_time -- 更新时间.
    ,o.ali_industry -- 阿里第三方行业类别
    ,o.qq_industry -- qq行业类别
    ,o.alipay_authorization_desc -- 描述需要哪些执照和许可证，创建支付宝门店的时候需要用到
    ,o.ali_v2_industry -- 支付宝V2报备行业类别
    ,o.best_pay_industry -- 翼支付行业类别
    ,o.hebao_industry -- 和包行业类别
    ,o.yifubao_industry -- 易付宝行业类别
    ,o.union_pay_industry -- 银联二维码行业类别
    ,o.shengfutong_industry -- 盛付通行业类别
    ,o.jd_industry -- 京东行业类别
    ,o.union_qq_industry -- 银联QQ钱包行业类别
    ,o.mcc -- MCC码
    ,o.fld_s1 -- 字符备用1
    ,o.fld_s2 -- 字符备用2
    ,o.fld_s3 -- 字符备用3
    ,o.fld_s4 -- 字符备用4
    ,o.fld_s5 -- 字符备用5
    ,o.yz_industry -- 银总行业类别
    ,o.wx_settlement_id_normal -- 微信结算id(普通)
    ,o.wx_settlement_id_newsmall -- 微信结算id(小微)
    ,o.wx_settlement_id_normal2 -- 
    ,o.wx_settlement_id_newsmall2 -- 
    ,o.bank_industry -- 银行的行业Id
    ,o.union_unstandard_flag -- 银联非标费率标识，0-标准费率;1-可非标费率
    ,o.root_industry -- ROOT行业类别
    ,o.industry_level -- 行业分级
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
from ${iol_schema}.amss_cms_industry_bk o
    left join ${iol_schema}.amss_cms_industry_op n
        on
            o.industry_id = n.industry_id
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.amss_cms_industry_cl d
        on
            o.industry_id = d.industry_id
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
--truncate table ${iol_schema}.amss_cms_industry;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('amss_cms_industry') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.amss_cms_industry drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.amss_cms_industry add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.amss_cms_industry exchange partition p_${batch_date} with table ${iol_schema}.amss_cms_industry_cl;
alter table ${iol_schema}.amss_cms_industry exchange partition p_20991231 with table ${iol_schema}.amss_cms_industry_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.amss_cms_industry to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.amss_cms_industry_op purge;
drop table ${iol_schema}.amss_cms_industry_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.amss_cms_industry_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'amss_cms_industry',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
