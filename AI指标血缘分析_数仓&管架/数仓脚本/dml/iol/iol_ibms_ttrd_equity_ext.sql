/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_ibms_ttrd_equity_ext
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
create table ${iol_schema}.ibms_ttrd_equity_ext_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.ibms_ttrd_equity_ext;

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.ibms_ttrd_equity_ext_op purge;
drop table ${iol_schema}.ibms_ttrd_equity_ext_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ibms_ttrd_equity_ext_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.ibms_ttrd_equity_ext where 0=1;

create table ${iol_schema}.ibms_ttrd_equity_ext_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.ibms_ttrd_equity_ext where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.ibms_ttrd_equity_ext_cl(
            i_code -- 主键
            ,h_datefield -- 日期类型
            ,h_textfield -- 文本类型
            ,h_numberfield -- 数值类型
            ,h_combobox -- 下拉框类型
            ,h_textarea -- 文本域类型
            ,h_issuer -- 发行人
            ,h_honour_date -- 兑付日
            ,h_grade_org -- 评级机构
            ,h_risk_classify -- 风险分类
            ,h_guarantor_type -- 担保方类型
            ,h_product_grade -- 产品评级
            ,asset_product_statistics_code -- 资管产品统计编码
            ,special_purpose_vehicle_type -- 特定目的载体类型
            ,issuer_region_code -- 发行人地区代码
            ,excute_mode -- 运行方式
            ,special_purpose_vehicle_code -- 特定目的载体代码
            ,issuer_code -- 发行人代码
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.ibms_ttrd_equity_ext_op(
            i_code -- 主键
            ,h_datefield -- 日期类型
            ,h_textfield -- 文本类型
            ,h_numberfield -- 数值类型
            ,h_combobox -- 下拉框类型
            ,h_textarea -- 文本域类型
            ,h_issuer -- 发行人
            ,h_honour_date -- 兑付日
            ,h_grade_org -- 评级机构
            ,h_risk_classify -- 风险分类
            ,h_guarantor_type -- 担保方类型
            ,h_product_grade -- 产品评级
            ,asset_product_statistics_code -- 资管产品统计编码
            ,special_purpose_vehicle_type -- 特定目的载体类型
            ,issuer_region_code -- 发行人地区代码
            ,excute_mode -- 运行方式
            ,special_purpose_vehicle_code -- 特定目的载体代码
            ,issuer_code -- 发行人代码
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.i_code, o.i_code) as i_code -- 主键
    ,nvl(n.h_datefield, o.h_datefield) as h_datefield -- 日期类型
    ,nvl(n.h_textfield, o.h_textfield) as h_textfield -- 文本类型
    ,nvl(n.h_numberfield, o.h_numberfield) as h_numberfield -- 数值类型
    ,nvl(n.h_combobox, o.h_combobox) as h_combobox -- 下拉框类型
    ,nvl(n.h_textarea, o.h_textarea) as h_textarea -- 文本域类型
    ,nvl(n.h_issuer, o.h_issuer) as h_issuer -- 发行人
    ,nvl(n.h_honour_date, o.h_honour_date) as h_honour_date -- 兑付日
    ,nvl(n.h_grade_org, o.h_grade_org) as h_grade_org -- 评级机构
    ,nvl(n.h_risk_classify, o.h_risk_classify) as h_risk_classify -- 风险分类
    ,nvl(n.h_guarantor_type, o.h_guarantor_type) as h_guarantor_type -- 担保方类型
    ,nvl(n.h_product_grade, o.h_product_grade) as h_product_grade -- 产品评级
    ,nvl(n.asset_product_statistics_code, o.asset_product_statistics_code) as asset_product_statistics_code -- 资管产品统计编码
    ,nvl(n.special_purpose_vehicle_type, o.special_purpose_vehicle_type) as special_purpose_vehicle_type -- 特定目的载体类型
    ,nvl(n.issuer_region_code, o.issuer_region_code) as issuer_region_code -- 发行人地区代码
    ,nvl(n.excute_mode, o.excute_mode) as excute_mode -- 运行方式
    ,nvl(n.special_purpose_vehicle_code, o.special_purpose_vehicle_code) as special_purpose_vehicle_code -- 特定目的载体代码
    ,nvl(n.issuer_code, o.issuer_code) as issuer_code -- 发行人代码
    ,case when
            n.i_code is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.i_code is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.i_code is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.ibms_ttrd_equity_ext_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.ibms_ttrd_equity_ext where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.i_code = n.i_code
where (
        o.i_code is null
    )
    or (
        n.i_code is null
    )
    or (
        o.h_datefield <> n.h_datefield
        or o.h_textfield <> n.h_textfield
        or o.h_numberfield <> n.h_numberfield
        or o.h_combobox <> n.h_combobox
        or o.h_textarea <> n.h_textarea
        or o.h_issuer <> n.h_issuer
        or o.h_honour_date <> n.h_honour_date
        or o.h_grade_org <> n.h_grade_org
        or o.h_risk_classify <> n.h_risk_classify
        or o.h_guarantor_type <> n.h_guarantor_type
        or o.h_product_grade <> n.h_product_grade
        or o.asset_product_statistics_code <> n.asset_product_statistics_code
        or o.special_purpose_vehicle_type <> n.special_purpose_vehicle_type
        or o.issuer_region_code <> n.issuer_region_code
        or o.excute_mode <> n.excute_mode
        or o.special_purpose_vehicle_code <> n.special_purpose_vehicle_code
        or o.issuer_code <> n.issuer_code
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.ibms_ttrd_equity_ext_cl(
            i_code -- 主键
            ,h_datefield -- 日期类型
            ,h_textfield -- 文本类型
            ,h_numberfield -- 数值类型
            ,h_combobox -- 下拉框类型
            ,h_textarea -- 文本域类型
            ,h_issuer -- 发行人
            ,h_honour_date -- 兑付日
            ,h_grade_org -- 评级机构
            ,h_risk_classify -- 风险分类
            ,h_guarantor_type -- 担保方类型
            ,h_product_grade -- 产品评级
            ,asset_product_statistics_code -- 资管产品统计编码
            ,special_purpose_vehicle_type -- 特定目的载体类型
            ,issuer_region_code -- 发行人地区代码
            ,excute_mode -- 运行方式
            ,special_purpose_vehicle_code -- 特定目的载体代码
            ,issuer_code -- 发行人代码
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.ibms_ttrd_equity_ext_op(
            i_code -- 主键
            ,h_datefield -- 日期类型
            ,h_textfield -- 文本类型
            ,h_numberfield -- 数值类型
            ,h_combobox -- 下拉框类型
            ,h_textarea -- 文本域类型
            ,h_issuer -- 发行人
            ,h_honour_date -- 兑付日
            ,h_grade_org -- 评级机构
            ,h_risk_classify -- 风险分类
            ,h_guarantor_type -- 担保方类型
            ,h_product_grade -- 产品评级
            ,asset_product_statistics_code -- 资管产品统计编码
            ,special_purpose_vehicle_type -- 特定目的载体类型
            ,issuer_region_code -- 发行人地区代码
            ,excute_mode -- 运行方式
            ,special_purpose_vehicle_code -- 特定目的载体代码
            ,issuer_code -- 发行人代码
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.i_code -- 主键
    ,o.h_datefield -- 日期类型
    ,o.h_textfield -- 文本类型
    ,o.h_numberfield -- 数值类型
    ,o.h_combobox -- 下拉框类型
    ,o.h_textarea -- 文本域类型
    ,o.h_issuer -- 发行人
    ,o.h_honour_date -- 兑付日
    ,o.h_grade_org -- 评级机构
    ,o.h_risk_classify -- 风险分类
    ,o.h_guarantor_type -- 担保方类型
    ,o.h_product_grade -- 产品评级
    ,o.asset_product_statistics_code -- 资管产品统计编码
    ,o.special_purpose_vehicle_type -- 特定目的载体类型
    ,o.issuer_region_code -- 发行人地区代码
    ,o.excute_mode -- 运行方式
    ,o.special_purpose_vehicle_code -- 特定目的载体代码
    ,o.issuer_code -- 发行人代码
    ,o.start_dt -- 开始时间
    ,case when n.start_dt is not null then to_date('${batch_date}', 'yyyymmdd')
          when o.end_dt >= to_date('${batch_date}','yyyymmdd') then to_date('20991231','yyyymmdd')
          else o.end_dt
     end as end_dt -- 结束时间
    ,o.id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from ${iol_schema}.ibms_ttrd_equity_ext_bk o
    left join ${iol_schema}.ibms_ttrd_equity_ext_op n
        on
            o.i_code = n.i_code
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.ibms_ttrd_equity_ext_cl d
        on
            o.i_code = d.i_code
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
-- truncate table ${iol_schema}.ibms_ttrd_equity_ext;

-- 4.2 exchange partition
alter table ${iol_schema}.ibms_ttrd_equity_ext exchange partition p_19000101 with table ${iol_schema}.ibms_ttrd_equity_ext_cl;
alter table ${iol_schema}.ibms_ttrd_equity_ext exchange partition p_20991231 with table ${iol_schema}.ibms_ttrd_equity_ext_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.ibms_ttrd_equity_ext to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.ibms_ttrd_equity_ext_op purge;
drop table ${iol_schema}.ibms_ttrd_equity_ext_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.ibms_ttrd_equity_ext_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'ibms_ttrd_equity_ext',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
