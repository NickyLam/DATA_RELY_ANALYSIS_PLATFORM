/*
Purpose:    整合模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iml_prd_finc_prod_lmt_ctrl_h_ifmsf1
CreateDate: 20180515
Logs:
    zjj 2018-05-15 新建表本
*/

set timing on

-- 1 alter parallel
alter session force parallel query parallel 4;
alter session force parallel dml parallel 4;
-- alter session force parallel ddl parallel 1;

-- 2.1 create backup table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
alter table ${iml_schema}.prd_finc_prod_lmt_ctrl_h add partition p_ifmsf1 values ('ifmsf1')(
        subpartition p_ifmsf1_19000101 values less than (to_date('20991231','yyyymmdd'))
        ,subpartition p_ifmsf1_20991231 values less than (maxvalue)
    )
;

-- if backup table is exists, mean script if failed on last time
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
create table ${iml_schema}.prd_finc_prod_lmt_ctrl_h_ifmsf1_bk nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.prd_finc_prod_lmt_ctrl_h partition for ('ifmsf1')
;

-- 2.2 drop temp table
whenever sqlerror continue none ;
-- it is no need to check when this segment SQL was return faied
drop table ${iml_schema}.prd_finc_prod_lmt_ctrl_h_ifmsf1_tm purge;
drop table ${iml_schema}.prd_finc_prod_lmt_ctrl_h_ifmsf1_op purge;
drop table ${iml_schema}.prd_finc_prod_lmt_ctrl_h_ifmsf1_cl purge;

-- 2.3 create temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.prd_finc_prod_lmt_ctrl_h_ifmsf1_tm nologging
compress ${option_switch} for query high
as select
    prod_id -- 产品编号
    ,lp_id -- 法人编号
    ,org_id -- 机构编号
    ,finc_prod_id -- 理财产品编号
    ,finc_intnal_org_id -- 理财内部机构编号
    ,tot_sell_lmt -- 总销售额度
    ,indv_cust_lmt -- 个人客户额度
    ,selled_indv_lmt -- 已销售个人额度
    ,asigned_indv_lmt -- 已分配个人额度
    ,org_cust_lmt -- 机构客户额度
    ,selled_org_lmt -- 已销售机构额度
    ,asigned_org_lmt -- 已分配机构额度
    ,flexb_lmt -- 机动额度
    ,selled_indv_flexb_lmt -- 已销售个人机动额度
    ,selled_org_flexb_lmt -- 已销售机构机动额度
    ,asigned_flexb_lmt -- 已分配机动额度
    ,precon_lmt_uplmi -- 预约额度上限
    ,accu_precon_lmt -- 累积预约额度
    ,precon_buyed_lmt -- 预约已购买额度
    ,resv_lmt -- 保留额度
    ,asigned_resv_lmt -- 已分配保留额度
    ,to_date('${batch_date}', 'yyyymmdd') as etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
from ${iml_schema}.prd_finc_prod_lmt_ctrl_h partition for ('ifmsf1')
where 0=1
;

create table ${iml_schema}.prd_finc_prod_lmt_ctrl_h_ifmsf1_op nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.prd_finc_prod_lmt_ctrl_h partition for ('ifmsf1') where 0=1;

create table ${iml_schema}.prd_finc_prod_lmt_ctrl_h_ifmsf1_cl nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.prd_finc_prod_lmt_ctrl_h partition for ('ifmsf1') where 0=1;

-- 3.1 get new data into table
-- ifms_tbissamt-
insert into ${iml_schema}.prd_finc_prod_lmt_ctrl_h_ifmsf1_tm(
    prod_id -- 产品编号
    ,lp_id -- 法人编号
    ,org_id -- 机构编号
    ,finc_prod_id -- 理财产品编号
    ,finc_intnal_org_id -- 理财内部机构编号
    ,tot_sell_lmt -- 总销售额度
    ,indv_cust_lmt -- 个人客户额度
    ,selled_indv_lmt -- 已销售个人额度
    ,asigned_indv_lmt -- 已分配个人额度
    ,org_cust_lmt -- 机构客户额度
    ,selled_org_lmt -- 已销售机构额度
    ,asigned_org_lmt -- 已分配机构额度
    ,flexb_lmt -- 机动额度
    ,selled_indv_flexb_lmt -- 已销售个人机动额度
    ,selled_org_flexb_lmt -- 已销售机构机动额度
    ,asigned_flexb_lmt -- 已分配机动额度
    ,precon_lmt_uplmi -- 预约额度上限
    ,accu_precon_lmt -- 累积预约额度
    ,precon_buyed_lmt -- 预约已购买额度
    ,resv_lmt -- 保留额度
    ,asigned_resv_lmt -- 已分配保留额度
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
)
select
    '223001'||P1.PRD_CODE -- 产品编号
    ,'9999' -- 法人编号
    ,P1.BRANCH_NO -- 机构编号
    ,P1.PRD_CODE -- 理财产品编号
    ,P1.INTERNAL_BRANCH -- 理财内部机构编号
    ,P1.TOTSALE_AMT -- 总销售额度
    ,P1.PERSON_AMT -- 个人客户额度
    ,P1.SALE_PAMT -- 已销售个人额度
    ,P1.ALLOT_PAMT -- 已分配个人额度
    ,P1.ORG_AMT -- 机构客户额度
    ,P1.SALE_OAMT -- 已销售机构额度
    ,P1.ALLOT_OAMT -- 已分配机构额度
    ,P1.ADJUST_AMT -- 机动额度
    ,P1.SADJUST_PAMT -- 已销售个人机动额度
    ,P1.SADJUST_OAMT -- 已销售机构机动额度
    ,P1.AADJUST_AMT -- 已分配机动额度
    ,P1.LIMITBOOK_AMT -- 预约额度上限
    ,P1.TOTBOOK_AMT -- 累积预约额度
    ,P1.SALE_BAMT -- 预约已购买额度
    ,P1.HOLD_AMT -- 保留额度
    ,P1.ALLOT_HAMT -- 已分配保留额度
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,'ifms_tbissamt' -- 源表名称
    ,'ifmsf1' -- 任务编码
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间戳
from ${iol_schema}.ifms_tbissamt p1
where p1.start_dt <= to_date('${batch_date}','yyyymmdd') and p1.end_dt > to_date('${batch_date}','yyyymmdd')
;
commit;


commit;

-- 3.2 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iml_schema}.prd_finc_prod_lmt_ctrl_h_ifmsf1_cl(
            prod_id -- 产品编号
    ,lp_id -- 法人编号
    ,org_id -- 机构编号
    ,finc_prod_id -- 理财产品编号
    ,finc_intnal_org_id -- 理财内部机构编号
    ,tot_sell_lmt -- 总销售额度
    ,indv_cust_lmt -- 个人客户额度
    ,selled_indv_lmt -- 已销售个人额度
    ,asigned_indv_lmt -- 已分配个人额度
    ,org_cust_lmt -- 机构客户额度
    ,selled_org_lmt -- 已销售机构额度
    ,asigned_org_lmt -- 已分配机构额度
    ,flexb_lmt -- 机动额度
    ,selled_indv_flexb_lmt -- 已销售个人机动额度
    ,selled_org_flexb_lmt -- 已销售机构机动额度
    ,asigned_flexb_lmt -- 已分配机动额度
    ,precon_lmt_uplmi -- 预约额度上限
    ,accu_precon_lmt -- 累积预约额度
    ,precon_buyed_lmt -- 预约已购买额度
    ,resv_lmt -- 保留额度
    ,asigned_resv_lmt -- 已分配保留额度
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iml_schema}.prd_finc_prod_lmt_ctrl_h_ifmsf1_op(
            prod_id -- 产品编号
    ,lp_id -- 法人编号
    ,org_id -- 机构编号
    ,finc_prod_id -- 理财产品编号
    ,finc_intnal_org_id -- 理财内部机构编号
    ,tot_sell_lmt -- 总销售额度
    ,indv_cust_lmt -- 个人客户额度
    ,selled_indv_lmt -- 已销售个人额度
    ,asigned_indv_lmt -- 已分配个人额度
    ,org_cust_lmt -- 机构客户额度
    ,selled_org_lmt -- 已销售机构额度
    ,asigned_org_lmt -- 已分配机构额度
    ,flexb_lmt -- 机动额度
    ,selled_indv_flexb_lmt -- 已销售个人机动额度
    ,selled_org_flexb_lmt -- 已销售机构机动额度
    ,asigned_flexb_lmt -- 已分配机动额度
    ,precon_lmt_uplmi -- 预约额度上限
    ,accu_precon_lmt -- 累积预约额度
    ,precon_buyed_lmt -- 预约已购买额度
    ,resv_lmt -- 保留额度
    ,asigned_resv_lmt -- 已分配保留额度
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.prod_id, o.prod_id) as prod_id -- 产品编号
    ,nvl(n.lp_id, o.lp_id) as lp_id -- 法人编号
    ,nvl(n.org_id, o.org_id) as org_id -- 机构编号
    ,nvl(n.finc_prod_id, o.finc_prod_id) as finc_prod_id -- 理财产品编号
    ,nvl(n.finc_intnal_org_id, o.finc_intnal_org_id) as finc_intnal_org_id -- 理财内部机构编号
    ,nvl(n.tot_sell_lmt, o.tot_sell_lmt) as tot_sell_lmt -- 总销售额度
    ,nvl(n.indv_cust_lmt, o.indv_cust_lmt) as indv_cust_lmt -- 个人客户额度
    ,nvl(n.selled_indv_lmt, o.selled_indv_lmt) as selled_indv_lmt -- 已销售个人额度
    ,nvl(n.asigned_indv_lmt, o.asigned_indv_lmt) as asigned_indv_lmt -- 已分配个人额度
    ,nvl(n.org_cust_lmt, o.org_cust_lmt) as org_cust_lmt -- 机构客户额度
    ,nvl(n.selled_org_lmt, o.selled_org_lmt) as selled_org_lmt -- 已销售机构额度
    ,nvl(n.asigned_org_lmt, o.asigned_org_lmt) as asigned_org_lmt -- 已分配机构额度
    ,nvl(n.flexb_lmt, o.flexb_lmt) as flexb_lmt -- 机动额度
    ,nvl(n.selled_indv_flexb_lmt, o.selled_indv_flexb_lmt) as selled_indv_flexb_lmt -- 已销售个人机动额度
    ,nvl(n.selled_org_flexb_lmt, o.selled_org_flexb_lmt) as selled_org_flexb_lmt -- 已销售机构机动额度
    ,nvl(n.asigned_flexb_lmt, o.asigned_flexb_lmt) as asigned_flexb_lmt -- 已分配机动额度
    ,nvl(n.precon_lmt_uplmi, o.precon_lmt_uplmi) as precon_lmt_uplmi -- 预约额度上限
    ,nvl(n.accu_precon_lmt, o.accu_precon_lmt) as accu_precon_lmt -- 累积预约额度
    ,nvl(n.precon_buyed_lmt, o.precon_buyed_lmt) as precon_buyed_lmt -- 预约已购买额度
    ,nvl(n.resv_lmt, o.resv_lmt) as resv_lmt -- 保留额度
    ,nvl(n.asigned_resv_lmt, o.asigned_resv_lmt) as asigned_resv_lmt -- 已分配保留额度
    ,case when
            n.prod_id is null
            and n.lp_id is null
            and n.org_id is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.prod_id is null
            and n.lp_id is null
            and n.org_id is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.prod_id is null
            and n.lp_id is null
            and n.org_id is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,nvl(n.src_table_name, o.src_table_name) as src_table_name -- 源表名称
    ,nvl(n.job_cd, o.job_cd) as job_cd -- 任务编码
    ,nvl(n.etl_timestamp, o.etl_timestamp) as etl_timestamp -- ETL处理时间戳
from ${iml_schema}.prd_finc_prod_lmt_ctrl_h_ifmsf1_tm n
    full join (select * from ${iml_schema}.prd_finc_prod_lmt_ctrl_h_ifmsf1_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
        on
            o.prod_id = n.prod_id
            and o.lp_id = n.lp_id
            and o.org_id = n.org_id
where (
        o.prod_id is null
        and o.lp_id is null
        and o.org_id is null
    )
    or (
        n.prod_id is null
        and n.lp_id is null
        and n.org_id is null
    )
    or (
        o.finc_prod_id <> n.finc_prod_id
        or o.finc_intnal_org_id <> n.finc_intnal_org_id
        or o.tot_sell_lmt <> n.tot_sell_lmt
        or o.indv_cust_lmt <> n.indv_cust_lmt
        or o.selled_indv_lmt <> n.selled_indv_lmt
        or o.asigned_indv_lmt <> n.asigned_indv_lmt
        or o.org_cust_lmt <> n.org_cust_lmt
        or o.selled_org_lmt <> n.selled_org_lmt
        or o.asigned_org_lmt <> n.asigned_org_lmt
        or o.flexb_lmt <> n.flexb_lmt
        or o.selled_indv_flexb_lmt <> n.selled_indv_flexb_lmt
        or o.selled_org_flexb_lmt <> n.selled_org_flexb_lmt
        or o.asigned_flexb_lmt <> n.asigned_flexb_lmt
        or o.precon_lmt_uplmi <> n.precon_lmt_uplmi
        or o.accu_precon_lmt <> n.accu_precon_lmt
        or o.precon_buyed_lmt <> n.precon_buyed_lmt
        or o.resv_lmt <> n.resv_lmt
        or o.asigned_resv_lmt <> n.asigned_resv_lmt
    )
;
commit;

-- 3.3 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iml_schema}.prd_finc_prod_lmt_ctrl_h_ifmsf1_cl(
            prod_id -- 产品编号
    ,lp_id -- 法人编号
    ,org_id -- 机构编号
    ,finc_prod_id -- 理财产品编号
    ,finc_intnal_org_id -- 理财内部机构编号
    ,tot_sell_lmt -- 总销售额度
    ,indv_cust_lmt -- 个人客户额度
    ,selled_indv_lmt -- 已销售个人额度
    ,asigned_indv_lmt -- 已分配个人额度
    ,org_cust_lmt -- 机构客户额度
    ,selled_org_lmt -- 已销售机构额度
    ,asigned_org_lmt -- 已分配机构额度
    ,flexb_lmt -- 机动额度
    ,selled_indv_flexb_lmt -- 已销售个人机动额度
    ,selled_org_flexb_lmt -- 已销售机构机动额度
    ,asigned_flexb_lmt -- 已分配机动额度
    ,precon_lmt_uplmi -- 预约额度上限
    ,accu_precon_lmt -- 累积预约额度
    ,precon_buyed_lmt -- 预约已购买额度
    ,resv_lmt -- 保留额度
    ,asigned_resv_lmt -- 已分配保留额度
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iml_schema}.prd_finc_prod_lmt_ctrl_h_ifmsf1_op(
            prod_id -- 产品编号
    ,lp_id -- 法人编号
    ,org_id -- 机构编号
    ,finc_prod_id -- 理财产品编号
    ,finc_intnal_org_id -- 理财内部机构编号
    ,tot_sell_lmt -- 总销售额度
    ,indv_cust_lmt -- 个人客户额度
    ,selled_indv_lmt -- 已销售个人额度
    ,asigned_indv_lmt -- 已分配个人额度
    ,org_cust_lmt -- 机构客户额度
    ,selled_org_lmt -- 已销售机构额度
    ,asigned_org_lmt -- 已分配机构额度
    ,flexb_lmt -- 机动额度
    ,selled_indv_flexb_lmt -- 已销售个人机动额度
    ,selled_org_flexb_lmt -- 已销售机构机动额度
    ,asigned_flexb_lmt -- 已分配机动额度
    ,precon_lmt_uplmi -- 预约额度上限
    ,accu_precon_lmt -- 累积预约额度
    ,precon_buyed_lmt -- 预约已购买额度
    ,resv_lmt -- 保留额度
    ,asigned_resv_lmt -- 已分配保留额度
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.prod_id -- 产品编号
    ,o.lp_id -- 法人编号
    ,o.org_id -- 机构编号
    ,o.finc_prod_id -- 理财产品编号
    ,o.finc_intnal_org_id -- 理财内部机构编号
    ,o.tot_sell_lmt -- 总销售额度
    ,o.indv_cust_lmt -- 个人客户额度
    ,o.selled_indv_lmt -- 已销售个人额度
    ,o.asigned_indv_lmt -- 已分配个人额度
    ,o.org_cust_lmt -- 机构客户额度
    ,o.selled_org_lmt -- 已销售机构额度
    ,o.asigned_org_lmt -- 已分配机构额度
    ,o.flexb_lmt -- 机动额度
    ,o.selled_indv_flexb_lmt -- 已销售个人机动额度
    ,o.selled_org_flexb_lmt -- 已销售机构机动额度
    ,o.asigned_flexb_lmt -- 已分配机动额度
    ,o.precon_lmt_uplmi -- 预约额度上限
    ,o.accu_precon_lmt -- 累积预约额度
    ,o.precon_buyed_lmt -- 预约已购买额度
    ,o.resv_lmt -- 保留额度
    ,o.asigned_resv_lmt -- 已分配保留额度
    ,o.start_dt -- 开始时间
    ,case when n.start_dt is not null then to_date('${batch_date}', 'yyyymmdd')
          when o.end_dt >= to_date('${batch_date}','yyyymmdd') then to_date('20991231','yyyymmdd')
          else o.end_dt
     end as end_dt -- 结束时间
    ,o.id_mark -- 增删标志
    ,o.src_table_name -- 源表名称
    ,o.job_cd -- 任务编码
    ,o.etl_timestamp -- ETL处理时间戳
from ${iml_schema}.prd_finc_prod_lmt_ctrl_h_ifmsf1_bk o
    left join ${iml_schema}.prd_finc_prod_lmt_ctrl_h_ifmsf1_op n
        on
            o.prod_id = n.prod_id
            and o.lp_id = n.lp_id
            and o.org_id = n.org_id
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iml_schema}.prd_finc_prod_lmt_ctrl_h_ifmsf1_cl d
        on
            o.prod_id = d.prod_id
            and o.lp_id = d.lp_id
            and o.org_id = d.org_id
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
--truncate table ${iml_schema}.prd_finc_prod_lmt_ctrl_h;
alter table ${iml_schema}.prd_finc_prod_lmt_ctrl_h truncate partition for ('ifmsf1') reuse storage;

-- 4.2 exchange partition
alter table ${iml_schema}.prd_finc_prod_lmt_ctrl_h exchange subpartition p_ifmsf1_19000101 with table ${iml_schema}.prd_finc_prod_lmt_ctrl_h_ifmsf1_cl;
alter table ${iml_schema}.prd_finc_prod_lmt_ctrl_h exchange subpartition p_ifmsf1_20991231 with table ${iml_schema}.prd_finc_prod_lmt_ctrl_h_ifmsf1_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iml_schema}.prd_finc_prod_lmt_ctrl_h to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iml_schema}.prd_finc_prod_lmt_ctrl_h_ifmsf1_tm purge;
drop table ${iml_schema}.prd_finc_prod_lmt_ctrl_h_ifmsf1_op purge;
drop table ${iml_schema}.prd_finc_prod_lmt_ctrl_h_ifmsf1_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iml_schema}.prd_finc_prod_lmt_ctrl_h_ifmsf1_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iml_schema}',tabname => 'prd_finc_prod_lmt_ctrl_h', partname => 'p_ifmsf1_20991231', granularity => 'SUBPARTITION', degree => 8, cascade => true);
