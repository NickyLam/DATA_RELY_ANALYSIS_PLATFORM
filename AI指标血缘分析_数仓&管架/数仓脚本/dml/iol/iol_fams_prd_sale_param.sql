/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_fams_prd_sale_param
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
create table ${iol_schema}.fams_prd_sale_param_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.fams_prd_sale_param
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.fams_prd_sale_param_op purge;
drop table ${iol_schema}.fams_prd_sale_param_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.fams_prd_sale_param_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.fams_prd_sale_param where 0=1;

create table ${iol_schema}.fams_prd_sale_param_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.fams_prd_sale_param where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.fams_prd_sale_param_cl(
            finprod_id -- 金融产品代码
            ,prd_band -- 产品品牌
            ,cyy_type -- 币种汇钞标志
            ,sale_channel -- 销售渠道，多选逗号分隔，柜面、网银、直销银行、手机银行、其他电子渠道，可多选
            ,sale_area -- 销售地区，多选逗号分隔
            ,sale_max -- 募集上限
            ,sale_min -- 募集下限
            ,toff_start -- 认购起点
            ,lowest_amt -- 最少追加金额
            ,huge_red_ratio -- 巨额赎回比例
            ,min_paper_qty -- 最低账面份额
            ,min_redm_qty -- 最低赎回份额
            ,can_plge -- 是否可质押
            ,max_plge_rate -- 质押率上限
            ,first_sale_vdate -- 首次募集开始日
            ,first_sale_mdate -- 首次募集结束日
            ,create_user -- 创建人
            ,create_dept -- 创建部门
            ,create_time -- 创建时间
            ,update_user -- 更新人
            ,update_time -- 更新时间
            ,consignment_flag -- 是否支持代销
            ,beforeend_flag -- 是否允许提前终止
            ,red_flag -- 是否允许客户赎回
            ,defaultred_flag -- 是否可违约赎回
            ,beforeestablish_flag -- 是否可提前成立
            ,continue_flag -- 是否续投
            ,raise_amt_plan -- 计划募集金额
            ,investor_type -- 目标客户类型
            ,same_org -- 同业机构
            ,buy_place -- 产品销售区域
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.fams_prd_sale_param_op(
            finprod_id -- 金融产品代码
            ,prd_band -- 产品品牌
            ,cyy_type -- 币种汇钞标志
            ,sale_channel -- 销售渠道，多选逗号分隔，柜面、网银、直销银行、手机银行、其他电子渠道，可多选
            ,sale_area -- 销售地区，多选逗号分隔
            ,sale_max -- 募集上限
            ,sale_min -- 募集下限
            ,toff_start -- 认购起点
            ,lowest_amt -- 最少追加金额
            ,huge_red_ratio -- 巨额赎回比例
            ,min_paper_qty -- 最低账面份额
            ,min_redm_qty -- 最低赎回份额
            ,can_plge -- 是否可质押
            ,max_plge_rate -- 质押率上限
            ,first_sale_vdate -- 首次募集开始日
            ,first_sale_mdate -- 首次募集结束日
            ,create_user -- 创建人
            ,create_dept -- 创建部门
            ,create_time -- 创建时间
            ,update_user -- 更新人
            ,update_time -- 更新时间
            ,consignment_flag -- 是否支持代销
            ,beforeend_flag -- 是否允许提前终止
            ,red_flag -- 是否允许客户赎回
            ,defaultred_flag -- 是否可违约赎回
            ,beforeestablish_flag -- 是否可提前成立
            ,continue_flag -- 是否续投
            ,raise_amt_plan -- 计划募集金额
            ,investor_type -- 目标客户类型
            ,same_org -- 同业机构
            ,buy_place -- 产品销售区域
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.finprod_id, o.finprod_id) as finprod_id -- 金融产品代码
    ,nvl(n.prd_band, o.prd_band) as prd_band -- 产品品牌
    ,nvl(n.cyy_type, o.cyy_type) as cyy_type -- 币种汇钞标志
    ,nvl(n.sale_channel, o.sale_channel) as sale_channel -- 销售渠道，多选逗号分隔，柜面、网银、直销银行、手机银行、其他电子渠道，可多选
    ,nvl(n.sale_area, o.sale_area) as sale_area -- 销售地区，多选逗号分隔
    ,nvl(n.sale_max, o.sale_max) as sale_max -- 募集上限
    ,nvl(n.sale_min, o.sale_min) as sale_min -- 募集下限
    ,nvl(n.toff_start, o.toff_start) as toff_start -- 认购起点
    ,nvl(n.lowest_amt, o.lowest_amt) as lowest_amt -- 最少追加金额
    ,nvl(n.huge_red_ratio, o.huge_red_ratio) as huge_red_ratio -- 巨额赎回比例
    ,nvl(n.min_paper_qty, o.min_paper_qty) as min_paper_qty -- 最低账面份额
    ,nvl(n.min_redm_qty, o.min_redm_qty) as min_redm_qty -- 最低赎回份额
    ,nvl(n.can_plge, o.can_plge) as can_plge -- 是否可质押
    ,nvl(n.max_plge_rate, o.max_plge_rate) as max_plge_rate -- 质押率上限
    ,nvl(n.first_sale_vdate, o.first_sale_vdate) as first_sale_vdate -- 首次募集开始日
    ,nvl(n.first_sale_mdate, o.first_sale_mdate) as first_sale_mdate -- 首次募集结束日
    ,nvl(n.create_user, o.create_user) as create_user -- 创建人
    ,nvl(n.create_dept, o.create_dept) as create_dept -- 创建部门
    ,nvl(n.create_time, o.create_time) as create_time -- 创建时间
    ,nvl(n.update_user, o.update_user) as update_user -- 更新人
    ,nvl(n.update_time, o.update_time) as update_time -- 更新时间
    ,nvl(n.consignment_flag, o.consignment_flag) as consignment_flag -- 是否支持代销
    ,nvl(n.beforeend_flag, o.beforeend_flag) as beforeend_flag -- 是否允许提前终止
    ,nvl(n.red_flag, o.red_flag) as red_flag -- 是否允许客户赎回
    ,nvl(n.defaultred_flag, o.defaultred_flag) as defaultred_flag -- 是否可违约赎回
    ,nvl(n.beforeestablish_flag, o.beforeestablish_flag) as beforeestablish_flag -- 是否可提前成立
    ,nvl(n.continue_flag, o.continue_flag) as continue_flag -- 是否续投
    ,nvl(n.raise_amt_plan, o.raise_amt_plan) as raise_amt_plan -- 计划募集金额
    ,nvl(n.investor_type, o.investor_type) as investor_type -- 目标客户类型
    ,nvl(n.same_org, o.same_org) as same_org -- 同业机构
    ,nvl(n.buy_place, o.buy_place) as buy_place -- 产品销售区域
    ,case when
            n.finprod_id is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.finprod_id is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.finprod_id is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.fams_prd_sale_param_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.fams_prd_sale_param where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.finprod_id = n.finprod_id
where (
        o.finprod_id is null
    )
    or (
        n.finprod_id is null
    )
    or (
        o.prd_band <> n.prd_band
        or o.cyy_type <> n.cyy_type
        or o.sale_channel <> n.sale_channel
        or o.sale_area <> n.sale_area
        or o.sale_max <> n.sale_max
        or o.sale_min <> n.sale_min
        or o.toff_start <> n.toff_start
        or o.lowest_amt <> n.lowest_amt
        or o.huge_red_ratio <> n.huge_red_ratio
        or o.min_paper_qty <> n.min_paper_qty
        or o.min_redm_qty <> n.min_redm_qty
        or o.can_plge <> n.can_plge
        or o.max_plge_rate <> n.max_plge_rate
        or o.first_sale_vdate <> n.first_sale_vdate
        or o.first_sale_mdate <> n.first_sale_mdate
        or o.create_user <> n.create_user
        or o.create_dept <> n.create_dept
        or o.create_time <> n.create_time
        or o.update_user <> n.update_user
        or o.update_time <> n.update_time
        or o.consignment_flag <> n.consignment_flag
        or o.beforeend_flag <> n.beforeend_flag
        or o.red_flag <> n.red_flag
        or o.defaultred_flag <> n.defaultred_flag
        or o.beforeestablish_flag <> n.beforeestablish_flag
        or o.continue_flag <> n.continue_flag
        or o.raise_amt_plan <> n.raise_amt_plan
        or o.investor_type <> n.investor_type
        or o.same_org <> n.same_org
        or o.buy_place <> n.buy_place
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.fams_prd_sale_param_cl(
            finprod_id -- 金融产品代码
            ,prd_band -- 产品品牌
            ,cyy_type -- 币种汇钞标志
            ,sale_channel -- 销售渠道，多选逗号分隔，柜面、网银、直销银行、手机银行、其他电子渠道，可多选
            ,sale_area -- 销售地区，多选逗号分隔
            ,sale_max -- 募集上限
            ,sale_min -- 募集下限
            ,toff_start -- 认购起点
            ,lowest_amt -- 最少追加金额
            ,huge_red_ratio -- 巨额赎回比例
            ,min_paper_qty -- 最低账面份额
            ,min_redm_qty -- 最低赎回份额
            ,can_plge -- 是否可质押
            ,max_plge_rate -- 质押率上限
            ,first_sale_vdate -- 首次募集开始日
            ,first_sale_mdate -- 首次募集结束日
            ,create_user -- 创建人
            ,create_dept -- 创建部门
            ,create_time -- 创建时间
            ,update_user -- 更新人
            ,update_time -- 更新时间
            ,consignment_flag -- 是否支持代销
            ,beforeend_flag -- 是否允许提前终止
            ,red_flag -- 是否允许客户赎回
            ,defaultred_flag -- 是否可违约赎回
            ,beforeestablish_flag -- 是否可提前成立
            ,continue_flag -- 是否续投
            ,raise_amt_plan -- 计划募集金额
            ,investor_type -- 目标客户类型
            ,same_org -- 同业机构
            ,buy_place -- 产品销售区域
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.fams_prd_sale_param_op(
            finprod_id -- 金融产品代码
            ,prd_band -- 产品品牌
            ,cyy_type -- 币种汇钞标志
            ,sale_channel -- 销售渠道，多选逗号分隔，柜面、网银、直销银行、手机银行、其他电子渠道，可多选
            ,sale_area -- 销售地区，多选逗号分隔
            ,sale_max -- 募集上限
            ,sale_min -- 募集下限
            ,toff_start -- 认购起点
            ,lowest_amt -- 最少追加金额
            ,huge_red_ratio -- 巨额赎回比例
            ,min_paper_qty -- 最低账面份额
            ,min_redm_qty -- 最低赎回份额
            ,can_plge -- 是否可质押
            ,max_plge_rate -- 质押率上限
            ,first_sale_vdate -- 首次募集开始日
            ,first_sale_mdate -- 首次募集结束日
            ,create_user -- 创建人
            ,create_dept -- 创建部门
            ,create_time -- 创建时间
            ,update_user -- 更新人
            ,update_time -- 更新时间
            ,consignment_flag -- 是否支持代销
            ,beforeend_flag -- 是否允许提前终止
            ,red_flag -- 是否允许客户赎回
            ,defaultred_flag -- 是否可违约赎回
            ,beforeestablish_flag -- 是否可提前成立
            ,continue_flag -- 是否续投
            ,raise_amt_plan -- 计划募集金额
            ,investor_type -- 目标客户类型
            ,same_org -- 同业机构
            ,buy_place -- 产品销售区域
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.finprod_id -- 金融产品代码
    ,o.prd_band -- 产品品牌
    ,o.cyy_type -- 币种汇钞标志
    ,o.sale_channel -- 销售渠道，多选逗号分隔，柜面、网银、直销银行、手机银行、其他电子渠道，可多选
    ,o.sale_area -- 销售地区，多选逗号分隔
    ,o.sale_max -- 募集上限
    ,o.sale_min -- 募集下限
    ,o.toff_start -- 认购起点
    ,o.lowest_amt -- 最少追加金额
    ,o.huge_red_ratio -- 巨额赎回比例
    ,o.min_paper_qty -- 最低账面份额
    ,o.min_redm_qty -- 最低赎回份额
    ,o.can_plge -- 是否可质押
    ,o.max_plge_rate -- 质押率上限
    ,o.first_sale_vdate -- 首次募集开始日
    ,o.first_sale_mdate -- 首次募集结束日
    ,o.create_user -- 创建人
    ,o.create_dept -- 创建部门
    ,o.create_time -- 创建时间
    ,o.update_user -- 更新人
    ,o.update_time -- 更新时间
    ,o.consignment_flag -- 是否支持代销
    ,o.beforeend_flag -- 是否允许提前终止
    ,o.red_flag -- 是否允许客户赎回
    ,o.defaultred_flag -- 是否可违约赎回
    ,o.beforeestablish_flag -- 是否可提前成立
    ,o.continue_flag -- 是否续投
    ,o.raise_amt_plan -- 计划募集金额
    ,o.investor_type -- 目标客户类型
    ,o.same_org -- 同业机构
    ,o.buy_place -- 产品销售区域
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
from ${iol_schema}.fams_prd_sale_param_bk o
    left join ${iol_schema}.fams_prd_sale_param_op n
        on
            o.finprod_id = n.finprod_id
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.fams_prd_sale_param_cl d
        on
            o.finprod_id = d.finprod_id
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
--truncate table ${iol_schema}.fams_prd_sale_param;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('fams_prd_sale_param') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.fams_prd_sale_param drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.fams_prd_sale_param add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.fams_prd_sale_param exchange partition p_${batch_date} with table ${iol_schema}.fams_prd_sale_param_cl;
alter table ${iol_schema}.fams_prd_sale_param exchange partition p_20991231 with table ${iol_schema}.fams_prd_sale_param_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.fams_prd_sale_param to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.fams_prd_sale_param_op purge;
drop table ${iol_schema}.fams_prd_sale_param_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.fams_prd_sale_param_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'fams_prd_sale_param',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
