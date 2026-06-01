/*
Purpose:    整合模型层-增量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iml_prd_eqty_nv_info_h_ibmsi1
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
alter table ${iml_schema}.prd_eqty_nv_info_h add partition p_ibmsi1 values ('ibmsi1')(
        subpartition p_ibmsi1_19000101 values less than (to_date('20991231','yyyymmdd'))
        ,subpartition p_ibmsi1_20991231 values less than (maxvalue)
    )
;

-- if backup table is exists, mean script if failed on last time
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
create table ${iml_schema}.prd_eqty_nv_info_h_ibmsi1_bk nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.prd_eqty_nv_info_h partition for ('ibmsi1')
;

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iml_schema}.prd_eqty_nv_info_h_ibmsi1_tm purge;
drop table ${iml_schema}.prd_eqty_nv_info_h_ibmsi1_op purge;
drop table ${iml_schema}.prd_eqty_nv_info_h_ibmsi1_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.prd_eqty_nv_info_h_ibmsi1_tm nologging
compress ${option_switch} for query high
as select
    fin_instm_id -- 金融工具编号
    ,asset_type_id -- 资产类型编号
    ,market_type_id -- 市场类型编号
    ,lp_id -- 法人编号
    ,nv_id -- 净值编号
    ,tot_nv -- 总净值
    ,corp_nv -- 单位净值
    ,ten_thous_prft_lmt -- 万份收益额
    ,sevn_aual_yld -- 七日年化收益率
    ,imp_dt -- 导入日期
    ,imp_way_id -- 导入方式编号
    ,to_date('${batch_date}', 'yyyymmdd') as etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
from ${iml_schema}.prd_eqty_nv_info_h partition for ('ibmsi1')
where 0=1
;

create table ${iml_schema}.prd_eqty_nv_info_h_ibmsi1_op nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.prd_eqty_nv_info_h partition for ('ibmsi1') where 0=1;

create table ${iml_schema}.prd_eqty_nv_info_h_ibmsi1_cl nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.prd_eqty_nv_info_h partition for ('ibmsi1') where 0=1;

-- 3.1 get new data into table
-- ibms_ttrd_equity_nav-
insert into ${iml_schema}.prd_eqty_nv_info_h_ibmsi1_tm(
    fin_instm_id -- 金融工具编号
    ,asset_type_id -- 资产类型编号
    ,market_type_id -- 市场类型编号
    ,lp_id -- 法人编号
    ,nv_id -- 净值编号
    ,tot_nv -- 总净值
    ,corp_nv -- 单位净值
    ,ten_thous_prft_lmt -- 万份收益额
    ,sevn_aual_yld -- 七日年化收益率
    ,imp_dt -- 导入日期
    ,imp_way_id -- 导入方式编号
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
)
select
    P1.I_CODE -- 金融工具编号
    ,P1.A_TYPE -- 资产类型编号
    ,P1.M_TYPE -- 市场类型编号
    ,'9999' -- 法人编号
    ,TO_CHAR(P1.E_ID) -- 净值编号
    ,P1.TOTAL_NAV -- 总净值
    ,P1.UNIT_NAV -- 单位净值
    ,P1.PROFIT_1W -- 万份收益额
    ,P1.YIELD_7D -- 七日年化收益率
    ,${iml_schema}.DATEFORMAT_MIN(P1.IMP_DATE） -- 导入日期
    ,TO_CHAR(P1.PIPE_ID) -- 导入方式编号
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,'ibms_ttrd_equity_nav' -- 源表名称
    ,'ibmsi1' -- 任务编码
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间戳
from ${iol_schema}.ibms_ttrd_equity_nav p1
where p1.start_dt <= to_date('${batch_date}','yyyymmdd') and p1.end_dt > to_date('${batch_date}','yyyymmdd')
    AND TO_DATE(P1.IMP_DATE,'YYYY-MM-DD') = TO_DATE('${batch_date}','yyyy-mm-dd')
;
commit;


commit;

-- 3.2 get new, alter data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ into ${iml_schema}.prd_eqty_nv_info_h_ibmsi1_op(
        fin_instm_id -- 金融工具编号
    ,asset_type_id -- 资产类型编号
    ,market_type_id -- 市场类型编号
    ,lp_id -- 法人编号
    ,nv_id -- 净值编号
    ,tot_nv -- 总净值
    ,corp_nv -- 单位净值
    ,ten_thous_prft_lmt -- 万份收益额
    ,sevn_aual_yld -- 七日年化收益率
    ,imp_dt -- 导入日期
    ,imp_way_id -- 导入方式编号
        ,start_dt -- 开始时间
        ,end_dt -- 结束时间
        ,id_mark -- 增删标志
        ,src_table_name -- 源表名称
        ,job_cd -- 任务编码
        ,etl_timestamp -- ETL处理时间戳
    )
select
    n.fin_instm_id -- 金融工具编号
    ,n.asset_type_id -- 资产类型编号
    ,n.market_type_id -- 市场类型编号
    ,n.lp_id -- 法人编号
    ,n.nv_id -- 净值编号
    ,n.tot_nv -- 总净值
    ,n.corp_nv -- 单位净值
    ,n.ten_thous_prft_lmt -- 万份收益额
    ,n.sevn_aual_yld -- 七日年化收益率
    ,n.imp_dt -- 导入日期
    ,n.imp_way_id -- 导入方式编号
    ,to_date('${batch_date}', 'yyyymmdd') as start_dt -- 开始时间
    ,to_date('20991231', 'yyyymmdd') as end_dt -- 结束时间
    ,'I' as id_mark -- 增删标志
    ,n.src_table_name -- 源表名称
    ,'ibmsi1' as job_cd -- 任务编码
    ,n.etl_timestamp as etl_timestamp -- ETL处理时间戳
from ${iml_schema}.prd_eqty_nv_info_h_ibmsi1_tm n
    left join (select * from ${iml_schema}.prd_eqty_nv_info_h_ibmsi1_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd')) o
        on
            o.fin_instm_id = n.fin_instm_id
            and o.asset_type_id = n.asset_type_id
            and o.market_type_id = n.market_type_id
            and o.lp_id = n.lp_id
where (
        o.fin_instm_id is null
        and o.asset_type_id is null
        and o.market_type_id is null
        and o.lp_id is null
    )
    or (
        o.nv_id <> n.nv_id
        or o.tot_nv <> n.tot_nv
        or o.corp_nv <> n.corp_nv
        or o.ten_thous_prft_lmt <> n.ten_thous_prft_lmt
        or o.sevn_aual_yld <> n.sevn_aual_yld
        or o.imp_dt <> n.imp_dt
        or o.imp_way_id <> n.imp_way_id
    )
;
commit;

-- 3.3 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iml_schema}.prd_eqty_nv_info_h_ibmsi1_cl(
            fin_instm_id -- 金融工具编号
    ,asset_type_id -- 资产类型编号
    ,market_type_id -- 市场类型编号
    ,lp_id -- 法人编号
    ,nv_id -- 净值编号
    ,tot_nv -- 总净值
    ,corp_nv -- 单位净值
    ,ten_thous_prft_lmt -- 万份收益额
    ,sevn_aual_yld -- 七日年化收益率
    ,imp_dt -- 导入日期
    ,imp_way_id -- 导入方式编号
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iml_schema}.prd_eqty_nv_info_h_ibmsi1_op(
            fin_instm_id -- 金融工具编号
    ,asset_type_id -- 资产类型编号
    ,market_type_id -- 市场类型编号
    ,lp_id -- 法人编号
    ,nv_id -- 净值编号
    ,tot_nv -- 总净值
    ,corp_nv -- 单位净值
    ,ten_thous_prft_lmt -- 万份收益额
    ,sevn_aual_yld -- 七日年化收益率
    ,imp_dt -- 导入日期
    ,imp_way_id -- 导入方式编号
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.fin_instm_id -- 金融工具编号
    ,o.asset_type_id -- 资产类型编号
    ,o.market_type_id -- 市场类型编号
    ,o.lp_id -- 法人编号
    ,o.nv_id -- 净值编号
    ,o.tot_nv -- 总净值
    ,o.corp_nv -- 单位净值
    ,o.ten_thous_prft_lmt -- 万份收益额
    ,o.sevn_aual_yld -- 七日年化收益率
    ,o.imp_dt -- 导入日期
    ,o.imp_way_id -- 导入方式编号
    ,o.start_dt -- 开始时间
    ,case when n.start_dt is not null then to_date('${batch_date}', 'yyyymmdd')
          when o.end_dt >= to_date('${batch_date}','yyyymmdd') then to_date('20991231','yyyymmdd')
          else o.end_dt
     end as end_dt -- 结束时间
    ,o.id_mark -- 增删标志
    ,o.src_table_name -- 源表名称
    ,o.job_cd -- 任务编码
    ,o.etl_timestamp -- ETL处理时间戳
from ${iml_schema}.prd_eqty_nv_info_h_ibmsi1_bk o
    left join ${iml_schema}.prd_eqty_nv_info_h_ibmsi1_op n
        on
            o.fin_instm_id = n.fin_instm_id
            and o.asset_type_id = n.asset_type_id
            and o.market_type_id = n.market_type_id
            and o.lp_id = n.lp_id
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
where o.start_dt < to_date('${batch_date}','yyyymmdd')
;
commit;

-- 4.1 truncate target table
--truncate table ${iml_schema}.prd_eqty_nv_info_h;
alter table ${iml_schema}.prd_eqty_nv_info_h truncate partition for ('ibmsi1') reuse storage;

-- 4.2 exchange partition
alter table ${iml_schema}.prd_eqty_nv_info_h exchange subpartition p_ibmsi1_19000101 with table ${iml_schema}.prd_eqty_nv_info_h_ibmsi1_cl;
alter table ${iml_schema}.prd_eqty_nv_info_h exchange subpartition p_ibmsi1_20991231 with table ${iml_schema}.prd_eqty_nv_info_h_ibmsi1_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iml_schema}.prd_eqty_nv_info_h to ${iml_schema};

-- 5.2 drop temp table
whenever sqlerror continue none ;
-- it is no need to check when this segment SQL was return faied
drop table ${iml_schema}.prd_eqty_nv_info_h_ibmsi1_tm purge;
drop table ${iml_schema}.prd_eqty_nv_info_h_ibmsi1_op purge;
drop table ${iml_schema}.prd_eqty_nv_info_h_ibmsi1_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iml_schema}.prd_eqty_nv_info_h_ibmsi1_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iml_schema}',tabname => 'prd_eqty_nv_info_h', partname => 'p_ibmsi1_20991231', granularity => 'SUBPARTITION', degree => 8, cascade => true);
