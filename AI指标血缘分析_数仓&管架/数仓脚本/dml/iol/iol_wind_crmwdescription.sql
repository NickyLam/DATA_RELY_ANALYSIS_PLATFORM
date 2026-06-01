/*
Purpose:    偏源模型层-增量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_wind_crmwdescription
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
whenever sqlerror continue none ;
create table ${iol_schema}.wind_crmwdescription_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.wind_crmwdescription;

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.wind_crmwdescription_op purge;
drop table ${iol_schema}.wind_crmwdescription_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.wind_crmwdescription_op nologging
compress ${option_switch} for query high
as select * from ${iol_schema}.wind_crmwdescription where 0=1;

create table ${iol_schema}.wind_crmwdescription_cl nologging
compress ${option_switch} for query high
as select * from ${iol_schema}.wind_crmwdescription where 0=1;

-- 3.1 get new, alter data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ into ${iol_schema}.wind_crmwdescription_op(
        object_id -- 对象ID
        ,b_info_windcode -- Wind代码
        ,b_create_fullname -- 凭证全称
        ,b_create_name -- 创设机构名称
        ,b_create_nameid -- 创设机构ID
        ,filenum -- 创设批准文件编号
        ,b_create_ann_date -- 创设公告日
        ,b_create_object -- 发行对象代码
        ,b_create_price -- 凭证创设价格
        ,b_create_amountplan -- 计划创设总额
        ,b_create_amountact -- 实际创设总额
        ,b_create_firstissue -- 簿记建档日
        ,b_registration_date -- 凭证登记日
        ,b_create_start_day -- 凭证起始日
        ,b_create_end_day -- 凭证到期日
        ,b_create_term_day -- 凭证期限
        ,b_create_payment_code -- 付费方式代码
        ,b_cgross_principal_amount -- 名义本金总额
        ,is_guarantee -- 是否担保
        ,b_cgross_settlement_code -- 结算方式代码
        ,b_voucher_code -- 凭证类别代码
        ,b_security_code -- 履约保障机制代码
        ,b_unit_nominal_capital -- 单位名义本金
        ,b_create_cancellation_day -- 凭证注销日
        ,b_info_compcode -- 参考实体公司id
        ,b_create_debt_type -- 债务种类
        ,b_create_debt_features -- 债务特征
        ,b_info_code -- 可交付债务证券id
        ,start_dt -- 开始时间
        ,end_dt -- 结束时间
        ,id_mark -- 增删标志
        ,etl_timestamp -- ETL处理时间戳
    )
select
    n.object_id -- 对象ID
    ,n.b_info_windcode -- Wind代码
    ,n.b_create_fullname -- 凭证全称
    ,n.b_create_name -- 创设机构名称
    ,n.b_create_nameid -- 创设机构ID
    ,n.filenum -- 创设批准文件编号
    ,n.b_create_ann_date -- 创设公告日
    ,n.b_create_object -- 发行对象代码
    ,n.b_create_price -- 凭证创设价格
    ,n.b_create_amountplan -- 计划创设总额
    ,n.b_create_amountact -- 实际创设总额
    ,n.b_create_firstissue -- 簿记建档日
    ,n.b_registration_date -- 凭证登记日
    ,n.b_create_start_day -- 凭证起始日
    ,n.b_create_end_day -- 凭证到期日
    ,n.b_create_term_day -- 凭证期限
    ,n.b_create_payment_code -- 付费方式代码
    ,n.b_cgross_principal_amount -- 名义本金总额
    ,n.is_guarantee -- 是否担保
    ,n.b_cgross_settlement_code -- 结算方式代码
    ,n.b_voucher_code -- 凭证类别代码
    ,n.b_security_code -- 履约保障机制代码
    ,n.b_unit_nominal_capital -- 单位名义本金
    ,n.b_create_cancellation_day -- 凭证注销日
    ,n.b_info_compcode -- 参考实体公司id
    ,n.b_create_debt_type -- 债务种类
    ,n.b_create_debt_features -- 债务特征
    ,n.b_info_code -- 可交付债务证券id
    ,to_date('${batch_date}', 'yyyymmdd') as start_dt -- 开始时间
    ,to_date('20991231', 'yyyymmdd') as end_dt -- 结束时间
    ,'I' as id_mark  -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.wind_crmwdescription_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd')) o
    right join (select * from ${itl_schema}.wind_crmwdescription where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.b_info_windcode = n.b_info_windcode
where (
        o.b_info_windcode is null
    )
    or (
        o.object_id <> n.object_id
        or o.b_create_fullname <> n.b_create_fullname
        or o.b_create_name <> n.b_create_name
        or o.b_create_nameid <> n.b_create_nameid
        or o.filenum <> n.filenum
        or o.b_create_ann_date <> n.b_create_ann_date
        or o.b_create_object <> n.b_create_object
        or o.b_create_price <> n.b_create_price
        or o.b_create_amountplan <> n.b_create_amountplan
        or o.b_create_amountact <> n.b_create_amountact
        or o.b_create_firstissue <> n.b_create_firstissue
        or o.b_registration_date <> n.b_registration_date
        or o.b_create_start_day <> n.b_create_start_day
        or o.b_create_end_day <> n.b_create_end_day
        or o.b_create_term_day <> n.b_create_term_day
        or o.b_create_payment_code <> n.b_create_payment_code
        or o.b_cgross_principal_amount <> n.b_cgross_principal_amount
        or o.is_guarantee <> n.is_guarantee
        or o.b_cgross_settlement_code <> n.b_cgross_settlement_code
        or o.b_voucher_code <> n.b_voucher_code
        or o.b_security_code <> n.b_security_code
        or o.b_unit_nominal_capital <> n.b_unit_nominal_capital
        or o.b_create_cancellation_day <> n.b_create_cancellation_day
        or o.b_info_compcode <> n.b_info_compcode
        or o.b_create_debt_type <> n.b_create_debt_type
        or o.b_create_debt_features <> n.b_create_debt_features
        or o.b_info_code <> n.b_info_code
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.wind_crmwdescription_cl(
            object_id -- 对象ID
        ,b_info_windcode -- Wind代码
        ,b_create_fullname -- 凭证全称
        ,b_create_name -- 创设机构名称
        ,b_create_nameid -- 创设机构ID
        ,filenum -- 创设批准文件编号
        ,b_create_ann_date -- 创设公告日
        ,b_create_object -- 发行对象代码
        ,b_create_price -- 凭证创设价格
        ,b_create_amountplan -- 计划创设总额
        ,b_create_amountact -- 实际创设总额
        ,b_create_firstissue -- 簿记建档日
        ,b_registration_date -- 凭证登记日
        ,b_create_start_day -- 凭证起始日
        ,b_create_end_day -- 凭证到期日
        ,b_create_term_day -- 凭证期限
        ,b_create_payment_code -- 付费方式代码
        ,b_cgross_principal_amount -- 名义本金总额
        ,is_guarantee -- 是否担保
        ,b_cgross_settlement_code -- 结算方式代码
        ,b_voucher_code -- 凭证类别代码
        ,b_security_code -- 履约保障机制代码
        ,b_unit_nominal_capital -- 单位名义本金
        ,b_create_cancellation_day -- 凭证注销日
        ,b_info_compcode -- 参考实体公司id
        ,b_create_debt_type -- 债务种类
        ,b_create_debt_features -- 债务特征
        ,b_info_code -- 可交付债务证券id
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.wind_crmwdescription_op(
            object_id -- 对象ID
        ,b_info_windcode -- Wind代码
        ,b_create_fullname -- 凭证全称
        ,b_create_name -- 创设机构名称
        ,b_create_nameid -- 创设机构ID
        ,filenum -- 创设批准文件编号
        ,b_create_ann_date -- 创设公告日
        ,b_create_object -- 发行对象代码
        ,b_create_price -- 凭证创设价格
        ,b_create_amountplan -- 计划创设总额
        ,b_create_amountact -- 实际创设总额
        ,b_create_firstissue -- 簿记建档日
        ,b_registration_date -- 凭证登记日
        ,b_create_start_day -- 凭证起始日
        ,b_create_end_day -- 凭证到期日
        ,b_create_term_day -- 凭证期限
        ,b_create_payment_code -- 付费方式代码
        ,b_cgross_principal_amount -- 名义本金总额
        ,is_guarantee -- 是否担保
        ,b_cgross_settlement_code -- 结算方式代码
        ,b_voucher_code -- 凭证类别代码
        ,b_security_code -- 履约保障机制代码
        ,b_unit_nominal_capital -- 单位名义本金
        ,b_create_cancellation_day -- 凭证注销日
        ,b_info_compcode -- 参考实体公司id
        ,b_create_debt_type -- 债务种类
        ,b_create_debt_features -- 债务特征
        ,b_info_code -- 可交付债务证券id
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.object_id -- 对象ID
    ,o.b_info_windcode -- Wind代码
    ,o.b_create_fullname -- 凭证全称
    ,o.b_create_name -- 创设机构名称
    ,o.b_create_nameid -- 创设机构ID
    ,o.filenum -- 创设批准文件编号
    ,o.b_create_ann_date -- 创设公告日
    ,o.b_create_object -- 发行对象代码
    ,o.b_create_price -- 凭证创设价格
    ,o.b_create_amountplan -- 计划创设总额
    ,o.b_create_amountact -- 实际创设总额
    ,o.b_create_firstissue -- 簿记建档日
    ,o.b_registration_date -- 凭证登记日
    ,o.b_create_start_day -- 凭证起始日
    ,o.b_create_end_day -- 凭证到期日
    ,o.b_create_term_day -- 凭证期限
    ,o.b_create_payment_code -- 付费方式代码
    ,o.b_cgross_principal_amount -- 名义本金总额
    ,o.is_guarantee -- 是否担保
    ,o.b_cgross_settlement_code -- 结算方式代码
    ,o.b_voucher_code -- 凭证类别代码
    ,o.b_security_code -- 履约保障机制代码
    ,o.b_unit_nominal_capital -- 单位名义本金
    ,o.b_create_cancellation_day -- 凭证注销日
    ,o.b_info_compcode -- 参考实体公司id
    ,o.b_create_debt_type -- 债务种类
    ,o.b_create_debt_features -- 债务特征
    ,o.b_info_code -- 可交付债务证券id
    ,o.start_dt -- 开始时间
    ,case when n.start_dt is not null then to_date('${batch_date}', 'yyyymmdd')
          when o.end_dt >= to_date('${batch_date}','yyyymmdd') then to_date('20991231','yyyymmdd')
          else o.end_dt
     end as end_dt -- 结束时间
    ,case when n.start_dt is not null then 'I'
          when o.end_dt>=to_date('${batch_date}','yyyymmdd') then 'I'
          else o.id_mark
     end as id_mark  -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from ${iol_schema}.wind_crmwdescription_bk o
    left join ${iol_schema}.wind_crmwdescription_op n
        on
            o.b_info_windcode = n.b_info_windcode
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
where o.start_dt < to_date('${batch_date}','yyyymmdd')
;
commit;

-- 4.1 truncate target table
--truncate table ${iol_schema}.wind_crmwdescription;

-- 4.2 exchange partition
alter table ${iol_schema}.wind_crmwdescription exchange partition p_19000101 with table ${iol_schema}.wind_crmwdescription_cl;
alter table ${iol_schema}.wind_crmwdescription exchange partition p_20991231 with table ${iol_schema}.wind_crmwdescription_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.wind_crmwdescription to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.wind_crmwdescription_op purge;
drop table ${iol_schema}.wind_crmwdescription_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.wind_crmwdescription_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'wind_crmwdescription',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
