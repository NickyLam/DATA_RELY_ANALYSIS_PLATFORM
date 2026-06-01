/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_hgls_product_info
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
create table ${iol_schema}.hgls_product_info_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.hgls_product_info
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.hgls_product_info_op purge;
drop table ${iol_schema}.hgls_product_info_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.hgls_product_info_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.hgls_product_info where 0=1;

create table ${iol_schema}.hgls_product_info_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.hgls_product_info where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.hgls_product_info_cl(
            prd_id -- 产品ID:主键
            ,code -- 产品编码
            ,prd_name -- 产品名
            ,prd_type -- 产品类型:1.网贷,2.经营贷
            ,loan_apply_type -- 贷款类型
            ,prd_status -- 发布状态:1.未发布,2.已发布
            ,tpl_code -- 模板CODE
            ,loan_limit -- 贷款额度(单位:万元):0.000-9999.999
            ,loan_rate -- 贷款日利率(单位:‱):0.9999~0.0001，无锡改版，允许为空
            ,loan_months -- 最长用信周期
            ,loan_auth_days -- 最长授信周期
            ,repayment_kind -- 还款方式:1.本金自定,2.等额本金,3.等额本息,4.定期还款,5.分期还款,6.一次性还款 以,分隔每个值
            ,interest_type -- 计息方式:1.按月,2.按天
            ,auth_type -- 授信方式 以,分隔每个值
            ,cities_id -- 发放城市列表,以,分隔每个城市的值
            ,loan_type -- 放款方式,长度256
            ,req_condition -- 申请资格,长度256
            ,audience -- 适用人群,长度256
            ,approve_num -- 审批人数
            ,examine_num -- 审查人数
            ,customer_industry -- 受众行业 以,分隔每个值
            ,prd_ad -- 广告语,长度50
            ,prd_describe -- 产品描述，长度500
            ,age_limit -- 最小年龄(单位:岁):0~200
            ,age_max -- 最大年龄(单位:岁):0~200
            ,enterprise_code -- 企业编码
            ,edited_index -- 步骤
            ,create_user -- 创建人ID
            ,credit_on -- 预授信模式:0.关闭,１.开启
            ,tpl_default -- 启用默认模板:0.否,１.是
            ,isfixed_rate -- 是否固定利率，0否1是
            ,create_date -- 申请日期
            ,update_date -- 更新时间
            ,isdel -- 删除标识:0.未删除,1.已删除
            ,year_rate -- 贷款年利率(单位:%)
            ,order_index -- 产品列表排序字段，默认0
            ,year_rate_max -- 最高年利率(单位:%)
            ,org_num -- 机构编码 以,分割每个值
            ,prd_num -- 产品编号
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.hgls_product_info_op(
            prd_id -- 产品ID:主键
            ,code -- 产品编码
            ,prd_name -- 产品名
            ,prd_type -- 产品类型:1.网贷,2.经营贷
            ,loan_apply_type -- 贷款类型
            ,prd_status -- 发布状态:1.未发布,2.已发布
            ,tpl_code -- 模板CODE
            ,loan_limit -- 贷款额度(单位:万元):0.000-9999.999
            ,loan_rate -- 贷款日利率(单位:‱):0.9999~0.0001，无锡改版，允许为空
            ,loan_months -- 最长用信周期
            ,loan_auth_days -- 最长授信周期
            ,repayment_kind -- 还款方式:1.本金自定,2.等额本金,3.等额本息,4.定期还款,5.分期还款,6.一次性还款 以,分隔每个值
            ,interest_type -- 计息方式:1.按月,2.按天
            ,auth_type -- 授信方式 以,分隔每个值
            ,cities_id -- 发放城市列表,以,分隔每个城市的值
            ,loan_type -- 放款方式,长度256
            ,req_condition -- 申请资格,长度256
            ,audience -- 适用人群,长度256
            ,approve_num -- 审批人数
            ,examine_num -- 审查人数
            ,customer_industry -- 受众行业 以,分隔每个值
            ,prd_ad -- 广告语,长度50
            ,prd_describe -- 产品描述，长度500
            ,age_limit -- 最小年龄(单位:岁):0~200
            ,age_max -- 最大年龄(单位:岁):0~200
            ,enterprise_code -- 企业编码
            ,edited_index -- 步骤
            ,create_user -- 创建人ID
            ,credit_on -- 预授信模式:0.关闭,１.开启
            ,tpl_default -- 启用默认模板:0.否,１.是
            ,isfixed_rate -- 是否固定利率，0否1是
            ,create_date -- 申请日期
            ,update_date -- 更新时间
            ,isdel -- 删除标识:0.未删除,1.已删除
            ,year_rate -- 贷款年利率(单位:%)
            ,order_index -- 产品列表排序字段，默认0
            ,year_rate_max -- 最高年利率(单位:%)
            ,org_num -- 机构编码 以,分割每个值
            ,prd_num -- 产品编号
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.prd_id, o.prd_id) as prd_id -- 产品ID:主键
    ,nvl(n.code, o.code) as code -- 产品编码
    ,nvl(n.prd_name, o.prd_name) as prd_name -- 产品名
    ,nvl(n.prd_type, o.prd_type) as prd_type -- 产品类型:1.网贷,2.经营贷
    ,nvl(n.loan_apply_type, o.loan_apply_type) as loan_apply_type -- 贷款类型
    ,nvl(n.prd_status, o.prd_status) as prd_status -- 发布状态:1.未发布,2.已发布
    ,nvl(n.tpl_code, o.tpl_code) as tpl_code -- 模板CODE
    ,nvl(n.loan_limit, o.loan_limit) as loan_limit -- 贷款额度(单位:万元):0.000-9999.999
    ,nvl(n.loan_rate, o.loan_rate) as loan_rate -- 贷款日利率(单位:‱):0.9999~0.0001，无锡改版，允许为空
    ,nvl(n.loan_months, o.loan_months) as loan_months -- 最长用信周期
    ,nvl(n.loan_auth_days, o.loan_auth_days) as loan_auth_days -- 最长授信周期
    ,nvl(n.repayment_kind, o.repayment_kind) as repayment_kind -- 还款方式:1.本金自定,2.等额本金,3.等额本息,4.定期还款,5.分期还款,6.一次性还款 以,分隔每个值
    ,nvl(n.interest_type, o.interest_type) as interest_type -- 计息方式:1.按月,2.按天
    ,nvl(n.auth_type, o.auth_type) as auth_type -- 授信方式 以,分隔每个值
    ,nvl(n.cities_id, o.cities_id) as cities_id -- 发放城市列表,以,分隔每个城市的值
    ,nvl(n.loan_type, o.loan_type) as loan_type -- 放款方式,长度256
    ,nvl(n.req_condition, o.req_condition) as req_condition -- 申请资格,长度256
    ,nvl(n.audience, o.audience) as audience -- 适用人群,长度256
    ,nvl(n.approve_num, o.approve_num) as approve_num -- 审批人数
    ,nvl(n.examine_num, o.examine_num) as examine_num -- 审查人数
    ,nvl(n.customer_industry, o.customer_industry) as customer_industry -- 受众行业 以,分隔每个值
    ,nvl(n.prd_ad, o.prd_ad) as prd_ad -- 广告语,长度50
    ,nvl(n.prd_describe, o.prd_describe) as prd_describe -- 产品描述，长度500
    ,nvl(n.age_limit, o.age_limit) as age_limit -- 最小年龄(单位:岁):0~200
    ,nvl(n.age_max, o.age_max) as age_max -- 最大年龄(单位:岁):0~200
    ,nvl(n.enterprise_code, o.enterprise_code) as enterprise_code -- 企业编码
    ,nvl(n.edited_index, o.edited_index) as edited_index -- 步骤
    ,nvl(n.create_user, o.create_user) as create_user -- 创建人ID
    ,nvl(n.credit_on, o.credit_on) as credit_on -- 预授信模式:0.关闭,１.开启
    ,nvl(n.tpl_default, o.tpl_default) as tpl_default -- 启用默认模板:0.否,１.是
    ,nvl(n.isfixed_rate, o.isfixed_rate) as isfixed_rate -- 是否固定利率，0否1是
    ,nvl(n.create_date, o.create_date) as create_date -- 申请日期
    ,nvl(n.update_date, o.update_date) as update_date -- 更新时间
    ,nvl(n.isdel, o.isdel) as isdel -- 删除标识:0.未删除,1.已删除
    ,nvl(n.year_rate, o.year_rate) as year_rate -- 贷款年利率(单位:%)
    ,nvl(n.order_index, o.order_index) as order_index -- 产品列表排序字段，默认0
    ,nvl(n.year_rate_max, o.year_rate_max) as year_rate_max -- 最高年利率(单位:%)
    ,nvl(n.org_num, o.org_num) as org_num -- 机构编码 以,分割每个值
    ,nvl(n.prd_num, o.prd_num) as prd_num -- 产品编号
    ,case when
            n.prd_id is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.prd_id is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.prd_id is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.hgls_product_info_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.hgls_product_info where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.prd_id = n.prd_id
where (
        o.prd_id is null
    )
    or (
        n.prd_id is null
    )
    or (
        o.code <> n.code
        or o.prd_name <> n.prd_name
        or o.prd_type <> n.prd_type
        or o.loan_apply_type <> n.loan_apply_type
        or o.prd_status <> n.prd_status
        or o.tpl_code <> n.tpl_code
        or o.loan_limit <> n.loan_limit
        or o.loan_rate <> n.loan_rate
        or o.loan_months <> n.loan_months
        or o.loan_auth_days <> n.loan_auth_days
        or o.repayment_kind <> n.repayment_kind
        or o.interest_type <> n.interest_type
        or o.auth_type <> n.auth_type
        or o.cities_id <> n.cities_id
        or o.loan_type <> n.loan_type
        or o.req_condition <> n.req_condition
        or o.audience <> n.audience
        or o.approve_num <> n.approve_num
        or o.examine_num <> n.examine_num
        or o.customer_industry <> n.customer_industry
        or o.prd_ad <> n.prd_ad
        or o.prd_describe <> n.prd_describe
        or o.age_limit <> n.age_limit
        or o.age_max <> n.age_max
        or o.enterprise_code <> n.enterprise_code
        or o.edited_index <> n.edited_index
        or o.create_user <> n.create_user
        or o.credit_on <> n.credit_on
        or o.tpl_default <> n.tpl_default
        or o.isfixed_rate <> n.isfixed_rate
        or o.create_date <> n.create_date
        or o.update_date <> n.update_date
        or o.isdel <> n.isdel
        or o.year_rate <> n.year_rate
        or o.order_index <> n.order_index
        or o.year_rate_max <> n.year_rate_max
        or o.org_num <> n.org_num
        or o.prd_num <> n.prd_num
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.hgls_product_info_cl(
            prd_id -- 产品ID:主键
            ,code -- 产品编码
            ,prd_name -- 产品名
            ,prd_type -- 产品类型:1.网贷,2.经营贷
            ,loan_apply_type -- 贷款类型
            ,prd_status -- 发布状态:1.未发布,2.已发布
            ,tpl_code -- 模板CODE
            ,loan_limit -- 贷款额度(单位:万元):0.000-9999.999
            ,loan_rate -- 贷款日利率(单位:‱):0.9999~0.0001，无锡改版，允许为空
            ,loan_months -- 最长用信周期
            ,loan_auth_days -- 最长授信周期
            ,repayment_kind -- 还款方式:1.本金自定,2.等额本金,3.等额本息,4.定期还款,5.分期还款,6.一次性还款 以,分隔每个值
            ,interest_type -- 计息方式:1.按月,2.按天
            ,auth_type -- 授信方式 以,分隔每个值
            ,cities_id -- 发放城市列表,以,分隔每个城市的值
            ,loan_type -- 放款方式,长度256
            ,req_condition -- 申请资格,长度256
            ,audience -- 适用人群,长度256
            ,approve_num -- 审批人数
            ,examine_num -- 审查人数
            ,customer_industry -- 受众行业 以,分隔每个值
            ,prd_ad -- 广告语,长度50
            ,prd_describe -- 产品描述，长度500
            ,age_limit -- 最小年龄(单位:岁):0~200
            ,age_max -- 最大年龄(单位:岁):0~200
            ,enterprise_code -- 企业编码
            ,edited_index -- 步骤
            ,create_user -- 创建人ID
            ,credit_on -- 预授信模式:0.关闭,１.开启
            ,tpl_default -- 启用默认模板:0.否,１.是
            ,isfixed_rate -- 是否固定利率，0否1是
            ,create_date -- 申请日期
            ,update_date -- 更新时间
            ,isdel -- 删除标识:0.未删除,1.已删除
            ,year_rate -- 贷款年利率(单位:%)
            ,order_index -- 产品列表排序字段，默认0
            ,year_rate_max -- 最高年利率(单位:%)
            ,org_num -- 机构编码 以,分割每个值
            ,prd_num -- 产品编号
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.hgls_product_info_op(
            prd_id -- 产品ID:主键
            ,code -- 产品编码
            ,prd_name -- 产品名
            ,prd_type -- 产品类型:1.网贷,2.经营贷
            ,loan_apply_type -- 贷款类型
            ,prd_status -- 发布状态:1.未发布,2.已发布
            ,tpl_code -- 模板CODE
            ,loan_limit -- 贷款额度(单位:万元):0.000-9999.999
            ,loan_rate -- 贷款日利率(单位:‱):0.9999~0.0001，无锡改版，允许为空
            ,loan_months -- 最长用信周期
            ,loan_auth_days -- 最长授信周期
            ,repayment_kind -- 还款方式:1.本金自定,2.等额本金,3.等额本息,4.定期还款,5.分期还款,6.一次性还款 以,分隔每个值
            ,interest_type -- 计息方式:1.按月,2.按天
            ,auth_type -- 授信方式 以,分隔每个值
            ,cities_id -- 发放城市列表,以,分隔每个城市的值
            ,loan_type -- 放款方式,长度256
            ,req_condition -- 申请资格,长度256
            ,audience -- 适用人群,长度256
            ,approve_num -- 审批人数
            ,examine_num -- 审查人数
            ,customer_industry -- 受众行业 以,分隔每个值
            ,prd_ad -- 广告语,长度50
            ,prd_describe -- 产品描述，长度500
            ,age_limit -- 最小年龄(单位:岁):0~200
            ,age_max -- 最大年龄(单位:岁):0~200
            ,enterprise_code -- 企业编码
            ,edited_index -- 步骤
            ,create_user -- 创建人ID
            ,credit_on -- 预授信模式:0.关闭,１.开启
            ,tpl_default -- 启用默认模板:0.否,１.是
            ,isfixed_rate -- 是否固定利率，0否1是
            ,create_date -- 申请日期
            ,update_date -- 更新时间
            ,isdel -- 删除标识:0.未删除,1.已删除
            ,year_rate -- 贷款年利率(单位:%)
            ,order_index -- 产品列表排序字段，默认0
            ,year_rate_max -- 最高年利率(单位:%)
            ,org_num -- 机构编码 以,分割每个值
            ,prd_num -- 产品编号
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.prd_id -- 产品ID:主键
    ,o.code -- 产品编码
    ,o.prd_name -- 产品名
    ,o.prd_type -- 产品类型:1.网贷,2.经营贷
    ,o.loan_apply_type -- 贷款类型
    ,o.prd_status -- 发布状态:1.未发布,2.已发布
    ,o.tpl_code -- 模板CODE
    ,o.loan_limit -- 贷款额度(单位:万元):0.000-9999.999
    ,o.loan_rate -- 贷款日利率(单位:‱):0.9999~0.0001，无锡改版，允许为空
    ,o.loan_months -- 最长用信周期
    ,o.loan_auth_days -- 最长授信周期
    ,o.repayment_kind -- 还款方式:1.本金自定,2.等额本金,3.等额本息,4.定期还款,5.分期还款,6.一次性还款 以,分隔每个值
    ,o.interest_type -- 计息方式:1.按月,2.按天
    ,o.auth_type -- 授信方式 以,分隔每个值
    ,o.cities_id -- 发放城市列表,以,分隔每个城市的值
    ,o.loan_type -- 放款方式,长度256
    ,o.req_condition -- 申请资格,长度256
    ,o.audience -- 适用人群,长度256
    ,o.approve_num -- 审批人数
    ,o.examine_num -- 审查人数
    ,o.customer_industry -- 受众行业 以,分隔每个值
    ,o.prd_ad -- 广告语,长度50
    ,o.prd_describe -- 产品描述，长度500
    ,o.age_limit -- 最小年龄(单位:岁):0~200
    ,o.age_max -- 最大年龄(单位:岁):0~200
    ,o.enterprise_code -- 企业编码
    ,o.edited_index -- 步骤
    ,o.create_user -- 创建人ID
    ,o.credit_on -- 预授信模式:0.关闭,１.开启
    ,o.tpl_default -- 启用默认模板:0.否,１.是
    ,o.isfixed_rate -- 是否固定利率，0否1是
    ,o.create_date -- 申请日期
    ,o.update_date -- 更新时间
    ,o.isdel -- 删除标识:0.未删除,1.已删除
    ,o.year_rate -- 贷款年利率(单位:%)
    ,o.order_index -- 产品列表排序字段，默认0
    ,o.year_rate_max -- 最高年利率(单位:%)
    ,o.org_num -- 机构编码 以,分割每个值
    ,o.prd_num -- 产品编号
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
from ${iol_schema}.hgls_product_info_bk o
    left join ${iol_schema}.hgls_product_info_op n
        on
            o.prd_id = n.prd_id
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.hgls_product_info_cl d
        on
            o.prd_id = d.prd_id
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
--truncate table ${iol_schema}.hgls_product_info;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('hgls_product_info') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.hgls_product_info drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.hgls_product_info add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.hgls_product_info exchange partition p_${batch_date} with table ${iol_schema}.hgls_product_info_cl;
alter table ${iol_schema}.hgls_product_info exchange partition p_20991231 with table ${iol_schema}.hgls_product_info_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.hgls_product_info to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.hgls_product_info_op purge;
drop table ${iol_schema}.hgls_product_info_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.hgls_product_info_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'hgls_product_info',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
