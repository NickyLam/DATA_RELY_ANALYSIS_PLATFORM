/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_osbs_fls_insurance_product_detail
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
create table ${iol_schema}.osbs_fls_insurance_product_detail_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.osbs_fls_insurance_product_detail;

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.osbs_fls_insurance_product_detail_op purge;
drop table ${iol_schema}.osbs_fls_insurance_product_detail_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.osbs_fls_insurance_product_detail_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.osbs_fls_insurance_product_detail where 0=1;

create table ${iol_schema}.osbs_fls_insurance_product_detail_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.osbs_fls_insurance_product_detail where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.osbs_fls_insurance_product_detail_cl(
            fip_prdct_code -- 产品编码
            ,fip_prdct_name -- 产品名称
            ,fip_prdct_pic1 -- 网银图片路径
            ,fip_prdct_pic2 -- 手机银行图片路径
            ,fip_prdct_brief -- 产品简介
            ,fip_prdct_age -- 投保年龄
            ,fip_risk_level -- 风险等级
            ,fip_prdct_feature -- 产品特色
            ,fip_prdct_illustration -- 产品协议，多个用逗号隔开《产品说明书》：A、《保险产品条款》:B、《投保提示书》:C、《投保声明协议》:D
            ,fip_special_notice -- 特别告知
            ,fip_exemp_clause -- 免责条款
            ,fip_customer_notify -- 客户告知
            ,fip_buy_tip -- 购买提示
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.osbs_fls_insurance_product_detail_op(
            fip_prdct_code -- 产品编码
            ,fip_prdct_name -- 产品名称
            ,fip_prdct_pic1 -- 网银图片路径
            ,fip_prdct_pic2 -- 手机银行图片路径
            ,fip_prdct_brief -- 产品简介
            ,fip_prdct_age -- 投保年龄
            ,fip_risk_level -- 风险等级
            ,fip_prdct_feature -- 产品特色
            ,fip_prdct_illustration -- 产品协议，多个用逗号隔开《产品说明书》：A、《保险产品条款》:B、《投保提示书》:C、《投保声明协议》:D
            ,fip_special_notice -- 特别告知
            ,fip_exemp_clause -- 免责条款
            ,fip_customer_notify -- 客户告知
            ,fip_buy_tip -- 购买提示
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.fip_prdct_code, o.fip_prdct_code) as fip_prdct_code -- 产品编码
    ,nvl(n.fip_prdct_name, o.fip_prdct_name) as fip_prdct_name -- 产品名称
    ,nvl(n.fip_prdct_pic1, o.fip_prdct_pic1) as fip_prdct_pic1 -- 网银图片路径
    ,nvl(n.fip_prdct_pic2, o.fip_prdct_pic2) as fip_prdct_pic2 -- 手机银行图片路径
    ,nvl(n.fip_prdct_brief, o.fip_prdct_brief) as fip_prdct_brief -- 产品简介
    ,nvl(n.fip_prdct_age, o.fip_prdct_age) as fip_prdct_age -- 投保年龄
    ,nvl(n.fip_risk_level, o.fip_risk_level) as fip_risk_level -- 风险等级
    ,nvl(n.fip_prdct_feature, o.fip_prdct_feature) as fip_prdct_feature -- 产品特色
    ,nvl(n.fip_prdct_illustration, o.fip_prdct_illustration) as fip_prdct_illustration -- 产品协议，多个用逗号隔开《产品说明书》：A、《保险产品条款》:B、《投保提示书》:C、《投保声明协议》:D
    ,nvl(n.fip_special_notice, o.fip_special_notice) as fip_special_notice -- 特别告知
    ,nvl(n.fip_exemp_clause, o.fip_exemp_clause) as fip_exemp_clause -- 免责条款
    ,nvl(n.fip_customer_notify, o.fip_customer_notify) as fip_customer_notify -- 客户告知
    ,nvl(n.fip_buy_tip, o.fip_buy_tip) as fip_buy_tip -- 购买提示
    ,case when
            n.fip_prdct_code is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.fip_prdct_code is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.fip_prdct_code is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.osbs_fls_insurance_product_detail_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.osbs_fls_insurance_product_detail where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.fip_prdct_code = n.fip_prdct_code
where (
        o.fip_prdct_code is null
    )
    or (
        n.fip_prdct_code is null
    )
    or (
        o.fip_prdct_name <> n.fip_prdct_name
        or o.fip_prdct_pic1 <> n.fip_prdct_pic1
        or o.fip_prdct_pic2 <> n.fip_prdct_pic2
        or o.fip_prdct_brief <> n.fip_prdct_brief
        or o.fip_prdct_age <> n.fip_prdct_age
        or o.fip_risk_level <> n.fip_risk_level
        or o.fip_prdct_feature <> n.fip_prdct_feature
        or o.fip_prdct_illustration <> n.fip_prdct_illustration
        or o.fip_special_notice <> n.fip_special_notice
        or o.fip_exemp_clause <> n.fip_exemp_clause
        or o.fip_customer_notify <> n.fip_customer_notify
        or o.fip_buy_tip <> n.fip_buy_tip
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.osbs_fls_insurance_product_detail_cl(
            fip_prdct_code -- 产品编码
            ,fip_prdct_name -- 产品名称
            ,fip_prdct_pic1 -- 网银图片路径
            ,fip_prdct_pic2 -- 手机银行图片路径
            ,fip_prdct_brief -- 产品简介
            ,fip_prdct_age -- 投保年龄
            ,fip_risk_level -- 风险等级
            ,fip_prdct_feature -- 产品特色
            ,fip_prdct_illustration -- 产品协议，多个用逗号隔开《产品说明书》：A、《保险产品条款》:B、《投保提示书》:C、《投保声明协议》:D
            ,fip_special_notice -- 特别告知
            ,fip_exemp_clause -- 免责条款
            ,fip_customer_notify -- 客户告知
            ,fip_buy_tip -- 购买提示
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.osbs_fls_insurance_product_detail_op(
            fip_prdct_code -- 产品编码
            ,fip_prdct_name -- 产品名称
            ,fip_prdct_pic1 -- 网银图片路径
            ,fip_prdct_pic2 -- 手机银行图片路径
            ,fip_prdct_brief -- 产品简介
            ,fip_prdct_age -- 投保年龄
            ,fip_risk_level -- 风险等级
            ,fip_prdct_feature -- 产品特色
            ,fip_prdct_illustration -- 产品协议，多个用逗号隔开《产品说明书》：A、《保险产品条款》:B、《投保提示书》:C、《投保声明协议》:D
            ,fip_special_notice -- 特别告知
            ,fip_exemp_clause -- 免责条款
            ,fip_customer_notify -- 客户告知
            ,fip_buy_tip -- 购买提示
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.fip_prdct_code -- 产品编码
    ,o.fip_prdct_name -- 产品名称
    ,o.fip_prdct_pic1 -- 网银图片路径
    ,o.fip_prdct_pic2 -- 手机银行图片路径
    ,o.fip_prdct_brief -- 产品简介
    ,o.fip_prdct_age -- 投保年龄
    ,o.fip_risk_level -- 风险等级
    ,o.fip_prdct_feature -- 产品特色
    ,o.fip_prdct_illustration -- 产品协议，多个用逗号隔开《产品说明书》：A、《保险产品条款》:B、《投保提示书》:C、《投保声明协议》:D
    ,o.fip_special_notice -- 特别告知
    ,o.fip_exemp_clause -- 免责条款
    ,o.fip_customer_notify -- 客户告知
    ,o.fip_buy_tip -- 购买提示
    ,o.start_dt -- 开始时间
    ,case when n.start_dt is not null then to_date('${batch_date}', 'yyyymmdd')
          when o.end_dt >= to_date('${batch_date}','yyyymmdd') then to_date('20991231','yyyymmdd')
          else o.end_dt
     end as end_dt -- 结束时间
    ,o.id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from ${iol_schema}.osbs_fls_insurance_product_detail_bk o
    left join ${iol_schema}.osbs_fls_insurance_product_detail_op n
        on
            o.fip_prdct_code = n.fip_prdct_code
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.osbs_fls_insurance_product_detail_cl d
        on
            o.fip_prdct_code = d.fip_prdct_code
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
-- truncate table ${iol_schema}.osbs_fls_insurance_product_detail;

-- 4.2 exchange partition
alter table ${iol_schema}.osbs_fls_insurance_product_detail exchange partition p_19000101 with table ${iol_schema}.osbs_fls_insurance_product_detail_cl;
alter table ${iol_schema}.osbs_fls_insurance_product_detail exchange partition p_20991231 with table ${iol_schema}.osbs_fls_insurance_product_detail_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.osbs_fls_insurance_product_detail to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.osbs_fls_insurance_product_detail_op purge;
drop table ${iol_schema}.osbs_fls_insurance_product_detail_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.osbs_fls_insurance_product_detail_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'osbs_fls_insurance_product_detail',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
