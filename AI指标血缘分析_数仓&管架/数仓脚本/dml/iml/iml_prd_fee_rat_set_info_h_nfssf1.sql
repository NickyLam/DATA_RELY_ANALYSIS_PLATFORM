/*
Purpose:    整合模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iml_prd_fee_rat_set_info_h_nfssf1
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
alter table ${iml_schema}.prd_fee_rat_set_info_h add partition p_nfssf1 values ('nfssf1')(
        subpartition p_nfssf1_19000101 values less than (to_date('20991231','yyyymmdd'))
        ,subpartition p_nfssf1_20991231 values less than (maxvalue)
    )
;

-- if backup table is exists, mean script if failed on last time
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
create table ${iml_schema}.prd_fee_rat_set_info_h_nfssf1_bk nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.prd_fee_rat_set_info_h partition for ('nfssf1')
;

-- 2.2 drop temp table
whenever sqlerror continue none ;
-- it is no need to check when this segment SQL was return faied
drop table ${iml_schema}.prd_fee_rat_set_info_h_nfssf1_tm purge;
drop table ${iml_schema}.prd_fee_rat_set_info_h_nfssf1_op purge;
drop table ${iml_schema}.prd_fee_rat_set_info_h_nfssf1_cl purge;

-- 2.3 create temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.prd_fee_rat_set_info_h_nfssf1_tm nologging
compress ${option_switch} for query high
as select
    prod_id -- 产品编号
    ,lp_id -- 法人编号
    ,finc_prod_id -- 理财产品编号
    ,bus_type_cd -- 业务类型代码
    ,fee_type_cd -- 费用类型代码
    ,cust_type_cd -- 客户类型代码
    ,sell_type_cd -- 销售类型代码
    ,charge_way_cd -- 收费方式代码
    ,lowt_buy_amt -- 最低购买金额
    ,higt_buy_amt -- 最高购买金额
    ,min_precon_days -- 最小预约天数
    ,max_precon_days -- 最大预约天数
    ,min_surviv_days -- 最小存续天数
    ,max_surviv_days -- 最大存续天数
    ,fee_ratio -- 费用比例
    ,lowt_fee_amt -- 最低费用金额
    ,higt_fee_amt -- 最高费用金额
    ,cntpty_prod_id -- 对方产品编号
    ,fee_corp_cd -- 费用单位代码
    ,fee_corp_name -- 费用单位名称
    ,return_comm_fee_flg -- 固定费用模式返回手续费标志
    ,fee_mode_cd -- 费用模式代码
    ,to_date('${batch_date}', 'yyyymmdd') as etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
from ${iml_schema}.prd_fee_rat_set_info_h partition for ('nfssf1')
where 0=1
;

create table ${iml_schema}.prd_fee_rat_set_info_h_nfssf1_op nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.prd_fee_rat_set_info_h partition for ('nfssf1') where 0=1;

create table ${iml_schema}.prd_fee_rat_set_info_h_nfssf1_cl nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.prd_fee_rat_set_info_h partition for ('nfssf1') where 0=1;

-- 3.1 get new data into table
-- nfss_tbfeerate-
insert into ${iml_schema}.prd_fee_rat_set_info_h_nfssf1_tm(
    prod_id -- 产品编号
    ,lp_id -- 法人编号
    ,finc_prod_id -- 理财产品编号
    ,bus_type_cd -- 业务类型代码
    ,fee_type_cd -- 费用类型代码
    ,cust_type_cd -- 客户类型代码
    ,sell_type_cd -- 销售类型代码
    ,charge_way_cd -- 收费方式代码
    ,lowt_buy_amt -- 最低购买金额
    ,higt_buy_amt -- 最高购买金额
    ,min_precon_days -- 最小预约天数
    ,max_precon_days -- 最大预约天数
    ,min_surviv_days -- 最小存续天数
    ,max_surviv_days -- 最大存续天数
    ,fee_ratio -- 费用比例
    ,lowt_fee_amt -- 最低费用金额
    ,higt_fee_amt -- 最高费用金额
    ,cntpty_prod_id -- 对方产品编号
    ,fee_corp_cd -- 费用单位代码
    ,fee_corp_name -- 费用单位名称
    ,return_comm_fee_flg -- 固定费用模式返回手续费标志
    ,fee_mode_cd -- 费用模式代码
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
)
select
    '223008'||P1.PRD_CODE -- 产品编号
    ,'9999' -- 法人编号
    ,P1.PRD_CODE -- 理财产品编号
    ,CASE WHEN R1.TARGET_CD_VAL IS NOT NULL THEN R1.TARGET_CD_VAL ELSE '@'||P1.BUSIN_CODE end -- 业务类型代码
    ,CASE WHEN R2.TARGET_CD_VAL IS NOT NULL THEN R2.TARGET_CD_VAL ELSE '@'||P1.FEE_TYPE end -- 费用类型代码
    ,CASE WHEN R3.TARGET_CD_VAL IS NOT NULL THEN R3.TARGET_CD_VAL ELSE '@'||P1.CLIENT_TYPE end -- 客户类型代码
    ,NVL(trim(P1.SELLER_TYPE),'-') -- 销售类型代码
    ,CASE WHEN R4.TARGET_CD_VAL IS NOT NULL THEN R4.TARGET_CD_VAL ELSE '@'||P1.SUB_MODE end -- 收费方式代码
    ,P1.MIN_AMT -- 最低购买金额
    ,P1.MAX_AMT -- 最高购买金额
    ,P1.MIN_PREDAYS -- 最小预约天数
    ,P1.MAX_PREDAYS -- 最大预约天数
    ,P1.MIN_HOLDDAYS -- 最小存续天数
    ,P1.MAX_HOLDDAYS -- 最大存续天数
    ,P1.FEE_RATE -- 费用比例
    ,P1.MIN_FEE -- 最低费用金额
    ,P1.MAX_FEE -- 最高费用金额
    ,P1.OTHER_PRD_CODE -- 对方产品编号
    ,CASE WHEN R5.TARGET_CD_VAL IS NOT NULL THEN R5.TARGET_CD_VAL ELSE '@'||P1.UNIT end -- 费用单位代码
    ,P1.UNIT_NAME -- 费用单位名称
    ,nvl(trim(P1.BACK_FLAG),'-') -- 固定费用模式返回手续费标志
    ,CASE WHEN R6.TARGET_CD_VAL IS NOT NULL THEN R6.TARGET_CD_VAL ELSE '@'||P1.FEE_MODE end -- 费用模式代码
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,'nfss_tbfeerate' -- 源表名称
    ,'nfssf1' -- 任务编码
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间戳
from ${iol_schema}.nfss_tbfeerate p1
    left join ${iml_schema}.ref_pub_cd_map r1 on P1.BUSIN_CODE= R1.SRC_CODE_VAL
        AND R1.SORC_SYS_CD= 'NFSS'
        AND R1.SRC_TAB_EN_NAME= 'NFSS_TBFEERATE'
        AND R1.SRC_FIELD_EN_NAME= 'BUSIN_CODE'
        AND R1.TARGET_TAB_EN_NAME= 'PRD_FEE_RAT_SET_INFO_H'
        AND R1.TARGET_TAB_FIELD_EN_NAME= 'BUS_TYPE_CD'
    left join ${iml_schema}.ref_pub_cd_map r2 on P1.FEE_TYPE= R2.SRC_CODE_VAL
        AND R2.SORC_SYS_CD= 'NFSS'
        AND R2.SRC_TAB_EN_NAME= 'NFSS_TBFEERATE'
        AND R2.SRC_FIELD_EN_NAME= 'FEE_TYPE'
        AND R2.TARGET_TAB_EN_NAME= 'PRD_FEE_RAT_SET_INFO_H'
        AND R2.TARGET_TAB_FIELD_EN_NAME= 'FEE_TYPE_CD'
    left join ${iml_schema}.ref_pub_cd_map r3 on P1.CLIENT_TYPE= R3.SRC_CODE_VAL
        AND R3.SORC_SYS_CD= 'NFSS'
        AND R3.SRC_TAB_EN_NAME= 'NFSS_TBFEERATE'
        AND R3.SRC_FIELD_EN_NAME= 'CLIENT_TYPE'
        AND R3.TARGET_TAB_EN_NAME= 'PRD_FEE_RAT_SET_INFO_H'
        AND R3.TARGET_TAB_FIELD_EN_NAME= 'CUST_TYPE_CD'
    left join ${iml_schema}.ref_pub_cd_map r4 on P1.SUB_MODE= R4.SRC_CODE_VAL
        AND R4.SORC_SYS_CD= 'NFSS'
        AND R4.SRC_TAB_EN_NAME= 'NFSS_TBFEERATE'
        AND R4.SRC_FIELD_EN_NAME= 'SUB_MODE'
        AND R4.TARGET_TAB_EN_NAME= 'PRD_FEE_RAT_SET_INFO_H'
        AND R4.TARGET_TAB_FIELD_EN_NAME= 'CHARGE_WAY_CD'
    left join ${iml_schema}.ref_pub_cd_map r5 on P1.UNIT= R5.SRC_CODE_VAL
        AND R5.SORC_SYS_CD= 'NFSS'
        AND R5.SRC_TAB_EN_NAME= 'NFSS_TBFEERATE'
        AND R5.SRC_FIELD_EN_NAME= 'UNIT'
        AND R5.TARGET_TAB_EN_NAME= 'PRD_FEE_RAT_SET_INFO_H'
        AND R5.TARGET_TAB_FIELD_EN_NAME= 'FEE_CORP_CD'
    left join ${iml_schema}.ref_pub_cd_map r6 on P1.FEE_MODE= R6.SRC_CODE_VAL
        AND R6.SORC_SYS_CD= 'NFSS'
        AND R6.SRC_TAB_EN_NAME= 'NFSS_TBFEERATE'
        AND R6.SRC_FIELD_EN_NAME= 'FEE_MODE'
        AND R6.TARGET_TAB_EN_NAME= 'PRD_FEE_RAT_SET_INFO_H'
        AND R6.TARGET_TAB_FIELD_EN_NAME= 'FEE_MODE_CD'
where p1.start_dt <= to_date('${batch_date}','yyyymmdd') and p1.end_dt > to_date('${batch_date}','yyyymmdd')
;
commit;


commit;

-- 3.2 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iml_schema}.prd_fee_rat_set_info_h_nfssf1_cl(
            prod_id -- 产品编号
    ,lp_id -- 法人编号
    ,finc_prod_id -- 理财产品编号
    ,bus_type_cd -- 业务类型代码
    ,fee_type_cd -- 费用类型代码
    ,cust_type_cd -- 客户类型代码
    ,sell_type_cd -- 销售类型代码
    ,charge_way_cd -- 收费方式代码
    ,lowt_buy_amt -- 最低购买金额
    ,higt_buy_amt -- 最高购买金额
    ,min_precon_days -- 最小预约天数
    ,max_precon_days -- 最大预约天数
    ,min_surviv_days -- 最小存续天数
    ,max_surviv_days -- 最大存续天数
    ,fee_ratio -- 费用比例
    ,lowt_fee_amt -- 最低费用金额
    ,higt_fee_amt -- 最高费用金额
    ,cntpty_prod_id -- 对方产品编号
    ,fee_corp_cd -- 费用单位代码
    ,fee_corp_name -- 费用单位名称
    ,return_comm_fee_flg -- 固定费用模式返回手续费标志
    ,fee_mode_cd -- 费用模式代码
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iml_schema}.prd_fee_rat_set_info_h_nfssf1_op(
            prod_id -- 产品编号
    ,lp_id -- 法人编号
    ,finc_prod_id -- 理财产品编号
    ,bus_type_cd -- 业务类型代码
    ,fee_type_cd -- 费用类型代码
    ,cust_type_cd -- 客户类型代码
    ,sell_type_cd -- 销售类型代码
    ,charge_way_cd -- 收费方式代码
    ,lowt_buy_amt -- 最低购买金额
    ,higt_buy_amt -- 最高购买金额
    ,min_precon_days -- 最小预约天数
    ,max_precon_days -- 最大预约天数
    ,min_surviv_days -- 最小存续天数
    ,max_surviv_days -- 最大存续天数
    ,fee_ratio -- 费用比例
    ,lowt_fee_amt -- 最低费用金额
    ,higt_fee_amt -- 最高费用金额
    ,cntpty_prod_id -- 对方产品编号
    ,fee_corp_cd -- 费用单位代码
    ,fee_corp_name -- 费用单位名称
    ,return_comm_fee_flg -- 固定费用模式返回手续费标志
    ,fee_mode_cd -- 费用模式代码
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
    ,nvl(n.finc_prod_id, o.finc_prod_id) as finc_prod_id -- 理财产品编号
    ,nvl(n.bus_type_cd, o.bus_type_cd) as bus_type_cd -- 业务类型代码
    ,nvl(n.fee_type_cd, o.fee_type_cd) as fee_type_cd -- 费用类型代码
    ,nvl(n.cust_type_cd, o.cust_type_cd) as cust_type_cd -- 客户类型代码
    ,nvl(n.sell_type_cd, o.sell_type_cd) as sell_type_cd -- 销售类型代码
    ,nvl(n.charge_way_cd, o.charge_way_cd) as charge_way_cd -- 收费方式代码
    ,nvl(n.lowt_buy_amt, o.lowt_buy_amt) as lowt_buy_amt -- 最低购买金额
    ,nvl(n.higt_buy_amt, o.higt_buy_amt) as higt_buy_amt -- 最高购买金额
    ,nvl(n.min_precon_days, o.min_precon_days) as min_precon_days -- 最小预约天数
    ,nvl(n.max_precon_days, o.max_precon_days) as max_precon_days -- 最大预约天数
    ,nvl(n.min_surviv_days, o.min_surviv_days) as min_surviv_days -- 最小存续天数
    ,nvl(n.max_surviv_days, o.max_surviv_days) as max_surviv_days -- 最大存续天数
    ,nvl(n.fee_ratio, o.fee_ratio) as fee_ratio -- 费用比例
    ,nvl(n.lowt_fee_amt, o.lowt_fee_amt) as lowt_fee_amt -- 最低费用金额
    ,nvl(n.higt_fee_amt, o.higt_fee_amt) as higt_fee_amt -- 最高费用金额
    ,nvl(n.cntpty_prod_id, o.cntpty_prod_id) as cntpty_prod_id -- 对方产品编号
    ,nvl(n.fee_corp_cd, o.fee_corp_cd) as fee_corp_cd -- 费用单位代码
    ,nvl(n.fee_corp_name, o.fee_corp_name) as fee_corp_name -- 费用单位名称
    ,nvl(n.return_comm_fee_flg, o.return_comm_fee_flg) as return_comm_fee_flg -- 固定费用模式返回手续费标志
    ,nvl(n.fee_mode_cd, o.fee_mode_cd) as fee_mode_cd -- 费用模式代码
    ,case when
            n.prod_id is null
            and n.lp_id is null
            and n.finc_prod_id is null
            and n.bus_type_cd is null
            and n.fee_type_cd is null
            and n.cust_type_cd is null
            and n.sell_type_cd is null
            and n.charge_way_cd is null
            and n.lowt_buy_amt is null
            and n.min_precon_days is null
            and n.min_surviv_days is null
            and n.cntpty_prod_id is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.prod_id is null
            and n.lp_id is null
            and n.finc_prod_id is null
            and n.bus_type_cd is null
            and n.fee_type_cd is null
            and n.cust_type_cd is null
            and n.sell_type_cd is null
            and n.charge_way_cd is null
            and n.lowt_buy_amt is null
            and n.min_precon_days is null
            and n.min_surviv_days is null
            and n.cntpty_prod_id is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.prod_id is null
            and n.lp_id is null
            and n.finc_prod_id is null
            and n.bus_type_cd is null
            and n.fee_type_cd is null
            and n.cust_type_cd is null
            and n.sell_type_cd is null
            and n.charge_way_cd is null
            and n.lowt_buy_amt is null
            and n.min_precon_days is null
            and n.min_surviv_days is null
            and n.cntpty_prod_id is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,nvl(n.src_table_name, o.src_table_name) as src_table_name -- 源表名称
    ,nvl(n.job_cd, o.job_cd) as job_cd -- 任务编码
    ,nvl(n.etl_timestamp, o.etl_timestamp) as etl_timestamp -- ETL处理时间戳
from ${iml_schema}.prd_fee_rat_set_info_h_nfssf1_tm n
    full join (select * from ${iml_schema}.prd_fee_rat_set_info_h_nfssf1_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
        on
            o.prod_id = n.prod_id
            and o.lp_id = n.lp_id
            and o.finc_prod_id = n.finc_prod_id
            and o.bus_type_cd = n.bus_type_cd
            and o.fee_type_cd = n.fee_type_cd
            and o.cust_type_cd = n.cust_type_cd
            and o.sell_type_cd = n.sell_type_cd
            and o.charge_way_cd = n.charge_way_cd
            and o.lowt_buy_amt = n.lowt_buy_amt
            and o.min_precon_days = n.min_precon_days
            and o.min_surviv_days = n.min_surviv_days
            and o.cntpty_prod_id = n.cntpty_prod_id
where (
        o.prod_id is null
        and o.lp_id is null
        and o.finc_prod_id is null
        and o.bus_type_cd is null
        and o.fee_type_cd is null
        and o.cust_type_cd is null
        and o.sell_type_cd is null
        and o.charge_way_cd is null
        and o.lowt_buy_amt is null
        and o.min_precon_days is null
        and o.min_surviv_days is null
        and o.cntpty_prod_id is null
    )
    or (
        n.prod_id is null
        and n.lp_id is null
        and n.finc_prod_id is null
        and n.bus_type_cd is null
        and n.fee_type_cd is null
        and n.cust_type_cd is null
        and n.sell_type_cd is null
        and n.charge_way_cd is null
        and n.lowt_buy_amt is null
        and n.min_precon_days is null
        and n.min_surviv_days is null
        and n.cntpty_prod_id is null
    )
    or (
        o.higt_buy_amt <> n.higt_buy_amt
        or o.max_precon_days <> n.max_precon_days
        or o.max_surviv_days <> n.max_surviv_days
        or o.fee_ratio <> n.fee_ratio
        or o.lowt_fee_amt <> n.lowt_fee_amt
        or o.higt_fee_amt <> n.higt_fee_amt
        or o.fee_corp_cd <> n.fee_corp_cd
        or o.fee_corp_name <> n.fee_corp_name
        or o.return_comm_fee_flg <> n.return_comm_fee_flg
        or o.fee_mode_cd <> n.fee_mode_cd
    )
;
commit;

-- 3.3 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iml_schema}.prd_fee_rat_set_info_h_nfssf1_cl(
            prod_id -- 产品编号
    ,lp_id -- 法人编号
    ,finc_prod_id -- 理财产品编号
    ,bus_type_cd -- 业务类型代码
    ,fee_type_cd -- 费用类型代码
    ,cust_type_cd -- 客户类型代码
    ,sell_type_cd -- 销售类型代码
    ,charge_way_cd -- 收费方式代码
    ,lowt_buy_amt -- 最低购买金额
    ,higt_buy_amt -- 最高购买金额
    ,min_precon_days -- 最小预约天数
    ,max_precon_days -- 最大预约天数
    ,min_surviv_days -- 最小存续天数
    ,max_surviv_days -- 最大存续天数
    ,fee_ratio -- 费用比例
    ,lowt_fee_amt -- 最低费用金额
    ,higt_fee_amt -- 最高费用金额
    ,cntpty_prod_id -- 对方产品编号
    ,fee_corp_cd -- 费用单位代码
    ,fee_corp_name -- 费用单位名称
    ,return_comm_fee_flg -- 固定费用模式返回手续费标志
    ,fee_mode_cd -- 费用模式代码
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iml_schema}.prd_fee_rat_set_info_h_nfssf1_op(
            prod_id -- 产品编号
    ,lp_id -- 法人编号
    ,finc_prod_id -- 理财产品编号
    ,bus_type_cd -- 业务类型代码
    ,fee_type_cd -- 费用类型代码
    ,cust_type_cd -- 客户类型代码
    ,sell_type_cd -- 销售类型代码
    ,charge_way_cd -- 收费方式代码
    ,lowt_buy_amt -- 最低购买金额
    ,higt_buy_amt -- 最高购买金额
    ,min_precon_days -- 最小预约天数
    ,max_precon_days -- 最大预约天数
    ,min_surviv_days -- 最小存续天数
    ,max_surviv_days -- 最大存续天数
    ,fee_ratio -- 费用比例
    ,lowt_fee_amt -- 最低费用金额
    ,higt_fee_amt -- 最高费用金额
    ,cntpty_prod_id -- 对方产品编号
    ,fee_corp_cd -- 费用单位代码
    ,fee_corp_name -- 费用单位名称
    ,return_comm_fee_flg -- 固定费用模式返回手续费标志
    ,fee_mode_cd -- 费用模式代码
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
    ,o.finc_prod_id -- 理财产品编号
    ,o.bus_type_cd -- 业务类型代码
    ,o.fee_type_cd -- 费用类型代码
    ,o.cust_type_cd -- 客户类型代码
    ,o.sell_type_cd -- 销售类型代码
    ,o.charge_way_cd -- 收费方式代码
    ,o.lowt_buy_amt -- 最低购买金额
    ,o.higt_buy_amt -- 最高购买金额
    ,o.min_precon_days -- 最小预约天数
    ,o.max_precon_days -- 最大预约天数
    ,o.min_surviv_days -- 最小存续天数
    ,o.max_surviv_days -- 最大存续天数
    ,o.fee_ratio -- 费用比例
    ,o.lowt_fee_amt -- 最低费用金额
    ,o.higt_fee_amt -- 最高费用金额
    ,o.cntpty_prod_id -- 对方产品编号
    ,o.fee_corp_cd -- 费用单位代码
    ,o.fee_corp_name -- 费用单位名称
    ,o.return_comm_fee_flg -- 固定费用模式返回手续费标志
    ,o.fee_mode_cd -- 费用模式代码
    ,o.start_dt -- 开始时间
    ,case when n.start_dt is not null then to_date('${batch_date}', 'yyyymmdd')
          when o.end_dt >= to_date('${batch_date}','yyyymmdd') then to_date('20991231','yyyymmdd')
          else o.end_dt
     end as end_dt -- 结束时间
    ,o.id_mark -- 增删标志
    ,o.src_table_name -- 源表名称
    ,o.job_cd -- 任务编码
    ,o.etl_timestamp -- ETL处理时间戳
from ${iml_schema}.prd_fee_rat_set_info_h_nfssf1_bk o
    left join ${iml_schema}.prd_fee_rat_set_info_h_nfssf1_op n
        on
            o.prod_id = n.prod_id
            and o.lp_id = n.lp_id
            and o.finc_prod_id = n.finc_prod_id
            and o.bus_type_cd = n.bus_type_cd
            and o.fee_type_cd = n.fee_type_cd
            and o.cust_type_cd = n.cust_type_cd
            and o.sell_type_cd = n.sell_type_cd
            and o.charge_way_cd = n.charge_way_cd
            and o.lowt_buy_amt = n.lowt_buy_amt
            and o.min_precon_days = n.min_precon_days
            and o.min_surviv_days = n.min_surviv_days
            and o.cntpty_prod_id = n.cntpty_prod_id
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iml_schema}.prd_fee_rat_set_info_h_nfssf1_cl d
        on
            o.prod_id = d.prod_id
            and o.lp_id = d.lp_id
            and o.finc_prod_id = d.finc_prod_id
            and o.bus_type_cd = d.bus_type_cd
            and o.fee_type_cd = d.fee_type_cd
            and o.cust_type_cd = d.cust_type_cd
            and o.sell_type_cd = d.sell_type_cd
            and o.charge_way_cd = d.charge_way_cd
            and o.lowt_buy_amt = d.lowt_buy_amt
            and o.min_precon_days = d.min_precon_days
            and o.min_surviv_days = d.min_surviv_days
            and o.cntpty_prod_id = d.cntpty_prod_id
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
--truncate table ${iml_schema}.prd_fee_rat_set_info_h;
alter table ${iml_schema}.prd_fee_rat_set_info_h truncate partition for ('nfssf1') reuse storage;

-- 4.2 exchange partition
alter table ${iml_schema}.prd_fee_rat_set_info_h exchange subpartition p_nfssf1_19000101 with table ${iml_schema}.prd_fee_rat_set_info_h_nfssf1_cl;
alter table ${iml_schema}.prd_fee_rat_set_info_h exchange subpartition p_nfssf1_20991231 with table ${iml_schema}.prd_fee_rat_set_info_h_nfssf1_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iml_schema}.prd_fee_rat_set_info_h to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iml_schema}.prd_fee_rat_set_info_h_nfssf1_tm purge;
drop table ${iml_schema}.prd_fee_rat_set_info_h_nfssf1_op purge;
drop table ${iml_schema}.prd_fee_rat_set_info_h_nfssf1_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iml_schema}.prd_fee_rat_set_info_h_nfssf1_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iml_schema}',tabname => 'prd_fee_rat_set_info_h', partname => 'p_nfssf1_20991231', granularity => 'SUBPARTITION', degree => 8, cascade => true);
