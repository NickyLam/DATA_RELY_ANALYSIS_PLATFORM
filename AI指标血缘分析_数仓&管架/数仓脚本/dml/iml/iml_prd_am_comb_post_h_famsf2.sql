/*
Purpose:    整合模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iml_prd_am_comb_post_h_famsf2
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
alter table ${iml_schema}.prd_am_comb_post_h add partition p_famsf2 values ('famsf2')(
        subpartition p_famsf2_19000101 values less than (to_date('20991231','yyyymmdd'))
        ,subpartition p_famsf2_20991231 values less than (maxvalue)
    )
;

-- if backup table is exists, mean script if failed on last time
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
create table ${iml_schema}.prd_am_comb_post_h_famsf2_bk nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.prd_am_comb_post_h partition for ('famsf2')
;

-- 2.2 drop temp table
whenever sqlerror continue none ;
-- it is no need to check when this segment SQL was return faied
drop table ${iml_schema}.prd_am_comb_post_h_famsf2_tm purge;
drop table ${iml_schema}.prd_am_comb_post_h_famsf2_op purge;
drop table ${iml_schema}.prd_am_comb_post_h_famsf2_cl purge;

-- 2.3 create temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.prd_am_comb_post_h_famsf2_tm nologging
compress ${option_switch} for query high
as select
    inv_port_id -- 投资组合编号
    ,lp_id -- 法人编号
    ,secu_acct_id -- 证券账户编号
    ,fin_prod_id -- 金融产品编号
    ,brch_seq_num -- 分支序号
    ,invest_aim_cd -- 投资目的代码
    ,post_type_cd -- 持仓类型代码
    ,post_lot -- 持仓份额
    ,curr_cd -- 币种代码
    ,super_prod_id -- 上级产品编号
    ,bond_fac_val -- 债券面值
    ,to_date('${batch_date}', 'yyyymmdd') as etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
from ${iml_schema}.prd_am_comb_post_h partition for ('famsf2')
where 0=1
;

create table ${iml_schema}.prd_am_comb_post_h_famsf2_op nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.prd_am_comb_post_h partition for ('famsf2') where 0=1;

create table ${iml_schema}.prd_am_comb_post_h_famsf2_cl nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.prd_am_comb_post_h partition for ('famsf2') where 0=1;

-- 3.1 get new data into table
-- fams_ptl_sec_position-1
insert into ${iml_schema}.prd_am_comb_post_h_famsf2_tm(
    inv_port_id -- 投资组合编号
    ,lp_id -- 法人编号
    ,secu_acct_id -- 证券账户编号
    ,fin_prod_id -- 金融产品编号
    ,brch_seq_num -- 分支序号
    ,invest_aim_cd -- 投资目的代码
    ,post_type_cd -- 持仓类型代码
    ,post_lot -- 持仓份额
    ,curr_cd -- 币种代码
    ,super_prod_id -- 上级产品编号
    ,bond_fac_val -- 债券面值
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
)
select
    P1.PORTFOLIO_ID -- 投资组合编号
    ,'9999' -- 法人编号
    ,P1.SEC_ACCT_ID -- 证券账户编号
    ,P1.FINPROD_ID -- 金融产品编号
    ,P1.BRANCH -- 分支序号
    ,CASE WHEN R1.TARGET_CD_VAL IS NOT NULL THEN R1.TARGET_CD_VAL ELSE '@'||P1.INV_AIM END -- 投资目的代码
    ,NVL(TRIM(P1.HODING_TYPE),'-') -- 持仓类型代码
    ,P1.AMOUNT -- 持仓份额
    ,NVL(TRIM(P1.CCY),'-') -- 币种代码
    ,P1.P_FINPROD_ID -- 上级产品编号
    ,P1.FACE_VALUE -- 债券面值
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,'fams_ptl_sec_position' -- 源表名称
    ,'famsf2' -- 任务编码
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间戳
from ${iol_schema}.fams_ptl_sec_position p1
    left join ${iml_schema}.ref_pub_cd_map r1 on P1.INV_AIM = R1.SRC_CODE_VAL
        AND R1.SORC_SYS_CD= 'FAMS'
        AND R1.SRC_TAB_EN_NAME= 'FAMS_PTL_SEC_POSITION'
        AND R1.SRC_FIELD_EN_NAME= 'INV_AIM'
        AND R1.TARGET_TAB_EN_NAME= 'PRD_AM_COMB_POST_H'
        AND R1.TARGET_TAB_FIELD_EN_NAME= 'INVEST_AIM_CD'
where p1.start_dt <= to_date('${batch_date}','yyyymmdd') and p1.end_dt > to_date('${batch_date}','yyyymmdd')
     and p1.CDATE=to_date('${batch_date}','yyyymmdd') 
;
commit;


commit;

-- 3.2 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iml_schema}.prd_am_comb_post_h_famsf2_cl(
            inv_port_id -- 投资组合编号
    ,lp_id -- 法人编号
    ,secu_acct_id -- 证券账户编号
    ,fin_prod_id -- 金融产品编号
    ,brch_seq_num -- 分支序号
    ,invest_aim_cd -- 投资目的代码
    ,post_type_cd -- 持仓类型代码
    ,post_lot -- 持仓份额
    ,curr_cd -- 币种代码
    ,super_prod_id -- 上级产品编号
    ,bond_fac_val -- 债券面值
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iml_schema}.prd_am_comb_post_h_famsf2_op(
            inv_port_id -- 投资组合编号
    ,lp_id -- 法人编号
    ,secu_acct_id -- 证券账户编号
    ,fin_prod_id -- 金融产品编号
    ,brch_seq_num -- 分支序号
    ,invest_aim_cd -- 投资目的代码
    ,post_type_cd -- 持仓类型代码
    ,post_lot -- 持仓份额
    ,curr_cd -- 币种代码
    ,super_prod_id -- 上级产品编号
    ,bond_fac_val -- 债券面值
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.inv_port_id, o.inv_port_id) as inv_port_id -- 投资组合编号
    ,nvl(n.lp_id, o.lp_id) as lp_id -- 法人编号
    ,nvl(n.secu_acct_id, o.secu_acct_id) as secu_acct_id -- 证券账户编号
    ,nvl(n.fin_prod_id, o.fin_prod_id) as fin_prod_id -- 金融产品编号
    ,nvl(n.brch_seq_num, o.brch_seq_num) as brch_seq_num -- 分支序号
    ,nvl(n.invest_aim_cd, o.invest_aim_cd) as invest_aim_cd -- 投资目的代码
    ,nvl(n.post_type_cd, o.post_type_cd) as post_type_cd -- 持仓类型代码
    ,nvl(n.post_lot, o.post_lot) as post_lot -- 持仓份额
    ,nvl(n.curr_cd, o.curr_cd) as curr_cd -- 币种代码
    ,nvl(n.super_prod_id, o.super_prod_id) as super_prod_id -- 上级产品编号
    ,nvl(n.bond_fac_val, o.bond_fac_val) as bond_fac_val -- 债券面值
    ,case when
            n.inv_port_id is null
            and n.lp_id is null
            and n.secu_acct_id is null
            and n.fin_prod_id is null
            and n.brch_seq_num is null
            and n.invest_aim_cd is null
            and n.post_type_cd is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.inv_port_id is null
            and n.lp_id is null
            and n.secu_acct_id is null
            and n.fin_prod_id is null
            and n.brch_seq_num is null
            and n.invest_aim_cd is null
            and n.post_type_cd is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.inv_port_id is null
            and n.lp_id is null
            and n.secu_acct_id is null
            and n.fin_prod_id is null
            and n.brch_seq_num is null
            and n.invest_aim_cd is null
            and n.post_type_cd is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,nvl(n.src_table_name, o.src_table_name) as src_table_name -- 源表名称
    ,nvl(n.job_cd, o.job_cd) as job_cd -- 任务编码
    ,nvl(n.etl_timestamp, o.etl_timestamp) as etl_timestamp -- ETL处理时间戳
from ${iml_schema}.prd_am_comb_post_h_famsf2_tm n
    full join (select * from ${iml_schema}.prd_am_comb_post_h_famsf2_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
        on
            o.inv_port_id = n.inv_port_id
            and o.lp_id = n.lp_id
            and o.secu_acct_id = n.secu_acct_id
            and o.fin_prod_id = n.fin_prod_id
            and o.brch_seq_num = n.brch_seq_num
            and o.invest_aim_cd = n.invest_aim_cd
            and o.post_type_cd = n.post_type_cd
where (
        o.inv_port_id is null
        and o.lp_id is null
        and o.secu_acct_id is null
        and o.fin_prod_id is null
        and o.brch_seq_num is null
        and o.invest_aim_cd is null
        and o.post_type_cd is null
    )
    or (
        n.inv_port_id is null
        and n.lp_id is null
        and n.secu_acct_id is null
        and n.fin_prod_id is null
        and n.brch_seq_num is null
        and n.invest_aim_cd is null
        and n.post_type_cd is null
    )
    or (
        o.post_lot <> n.post_lot
        or o.curr_cd <> n.curr_cd
        or o.super_prod_id <> n.super_prod_id
        or o.bond_fac_val <> n.bond_fac_val
    )
;
commit;

-- 3.3 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iml_schema}.prd_am_comb_post_h_famsf2_cl(
            inv_port_id -- 投资组合编号
    ,lp_id -- 法人编号
    ,secu_acct_id -- 证券账户编号
    ,fin_prod_id -- 金融产品编号
    ,brch_seq_num -- 分支序号
    ,invest_aim_cd -- 投资目的代码
    ,post_type_cd -- 持仓类型代码
    ,post_lot -- 持仓份额
    ,curr_cd -- 币种代码
    ,super_prod_id -- 上级产品编号
    ,bond_fac_val -- 债券面值
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iml_schema}.prd_am_comb_post_h_famsf2_op(
            inv_port_id -- 投资组合编号
    ,lp_id -- 法人编号
    ,secu_acct_id -- 证券账户编号
    ,fin_prod_id -- 金融产品编号
    ,brch_seq_num -- 分支序号
    ,invest_aim_cd -- 投资目的代码
    ,post_type_cd -- 持仓类型代码
    ,post_lot -- 持仓份额
    ,curr_cd -- 币种代码
    ,super_prod_id -- 上级产品编号
    ,bond_fac_val -- 债券面值
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.inv_port_id -- 投资组合编号
    ,o.lp_id -- 法人编号
    ,o.secu_acct_id -- 证券账户编号
    ,o.fin_prod_id -- 金融产品编号
    ,o.brch_seq_num -- 分支序号
    ,o.invest_aim_cd -- 投资目的代码
    ,o.post_type_cd -- 持仓类型代码
    ,o.post_lot -- 持仓份额
    ,o.curr_cd -- 币种代码
    ,o.super_prod_id -- 上级产品编号
    ,o.bond_fac_val -- 债券面值
    ,o.start_dt -- 开始时间
    ,case when n.start_dt is not null then to_date('${batch_date}', 'yyyymmdd')
          when o.end_dt >= to_date('${batch_date}','yyyymmdd') then to_date('20991231','yyyymmdd')
          else o.end_dt
     end as end_dt -- 结束时间
    ,o.id_mark -- 增删标志
    ,o.src_table_name -- 源表名称
    ,o.job_cd -- 任务编码
    ,o.etl_timestamp -- ETL处理时间戳
from ${iml_schema}.prd_am_comb_post_h_famsf2_bk o
    left join ${iml_schema}.prd_am_comb_post_h_famsf2_op n
        on
            o.inv_port_id = n.inv_port_id
            and o.lp_id = n.lp_id
            and o.secu_acct_id = n.secu_acct_id
            and o.fin_prod_id = n.fin_prod_id
            and o.brch_seq_num = n.brch_seq_num
            and o.invest_aim_cd = n.invest_aim_cd
            and o.post_type_cd = n.post_type_cd
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iml_schema}.prd_am_comb_post_h_famsf2_cl d
        on
            o.inv_port_id = d.inv_port_id
            and o.lp_id = d.lp_id
            and o.secu_acct_id = d.secu_acct_id
            and o.fin_prod_id = d.fin_prod_id
            and o.brch_seq_num = d.brch_seq_num
            and o.invest_aim_cd = d.invest_aim_cd
            and o.post_type_cd = d.post_type_cd
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
--truncate table ${iml_schema}.prd_am_comb_post_h;
alter table ${iml_schema}.prd_am_comb_post_h truncate partition for ('famsf2') reuse storage;

-- 4.2 exchange partition
alter table ${iml_schema}.prd_am_comb_post_h exchange subpartition p_famsf2_19000101 with table ${iml_schema}.prd_am_comb_post_h_famsf2_cl;
alter table ${iml_schema}.prd_am_comb_post_h exchange subpartition p_famsf2_20991231 with table ${iml_schema}.prd_am_comb_post_h_famsf2_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iml_schema}.prd_am_comb_post_h to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iml_schema}.prd_am_comb_post_h_famsf2_tm purge;
drop table ${iml_schema}.prd_am_comb_post_h_famsf2_op purge;
drop table ${iml_schema}.prd_am_comb_post_h_famsf2_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iml_schema}.prd_am_comb_post_h_famsf2_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iml_schema}',tabname => 'prd_am_comb_post_h', partname => 'p_famsf2_20991231', granularity => 'SUBPARTITION', degree => 8, cascade => true);
