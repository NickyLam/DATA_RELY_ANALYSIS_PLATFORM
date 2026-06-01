/*
Purpose:    整合模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iml_prd_finc_prod_imp_info_h_ifmsf1
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
alter table ${iml_schema}.prd_finc_prod_imp_info_h add partition p_ifmsf1 values ('ifmsf1')(
        subpartition p_ifmsf1_19000101 values less than (to_date('20991231','yyyymmdd'))
        ,subpartition p_ifmsf1_20991231 values less than (maxvalue)
    )
;

-- if backup table is exists, mean script if failed on last time
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
create table ${iml_schema}.prd_finc_prod_imp_info_h_ifmsf1_bk nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.prd_finc_prod_imp_info_h partition for ('ifmsf1')
;

-- 2.2 drop temp table
whenever sqlerror continue none ;
-- it is no need to check when this segment SQL was return faied
drop table ${iml_schema}.prd_finc_prod_imp_info_h_ifmsf1_tm purge;
drop table ${iml_schema}.prd_finc_prod_imp_info_h_ifmsf1_op purge;
drop table ${iml_schema}.prd_finc_prod_imp_info_h_ifmsf1_cl purge;

-- 2.3 create temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.prd_finc_prod_imp_info_h_ifmsf1_tm nologging
compress ${option_switch} for query high
as select
    issue_dt -- 发布日期
    ,lp_id -- 法人编号
    ,cfm_dt -- 确认日期
    ,prod_id -- 产品编号
    ,ta_cd -- TA代码
    ,prod_tot_size -- 产品总规模
    ,lot_tot -- 份额总数
    ,td_add_shares -- 当日增加份数
    ,td_decrs_shares -- 当日减少份数
    ,prod_nv -- 产品净值
    ,prod_fac_val -- 产品面值
    ,prft_cust_ratio -- 收益客户比例
    ,prft_assign_flg -- 收益分配标志
    ,tran_flg -- 转换标志
    ,status_cd -- 状态代码
    ,ld_status_cd -- 上日状态代码
    ,prod_acm_nv -- 产品累计净值
    ,to_date('${batch_date}', 'yyyymmdd') as etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
from ${iml_schema}.prd_finc_prod_imp_info_h partition for ('ifmsf1')
where 0=1
;

create table ${iml_schema}.prd_finc_prod_imp_info_h_ifmsf1_op nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.prd_finc_prod_imp_info_h partition for ('ifmsf1') where 0=1;

create table ${iml_schema}.prd_finc_prod_imp_info_h_ifmsf1_cl nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.prd_finc_prod_imp_info_h partition for ('ifmsf1') where 0=1;

-- 3.1 get new data into table
-- ifms_tbprddaily-
insert into ${iml_schema}.prd_finc_prod_imp_info_h_ifmsf1_tm(
    issue_dt -- 发布日期
    ,lp_id -- 法人编号
    ,cfm_dt -- 确认日期
    ,prod_id -- 产品编号
    ,ta_cd -- TA代码
    ,prod_tot_size -- 产品总规模
    ,lot_tot -- 份额总数
    ,td_add_shares -- 当日增加份数
    ,td_decrs_shares -- 当日减少份数
    ,prod_nv -- 产品净值
    ,prod_fac_val -- 产品面值
    ,prft_cust_ratio -- 收益客户比例
    ,prft_assign_flg -- 收益分配标志
    ,tran_flg -- 转换标志
    ,status_cd -- 状态代码
    ,ld_status_cd -- 上日状态代码
    ,prod_acm_nv -- 产品累计净值
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
)
select
    ${iml_schema}.DATEFORMAT_MIN(TO_CHAR(P1.ISS_DATE)) -- 发布日期
    ,'9999' -- 法人编号
    ,${iml_schema}.DATEFORMAT_MAX(TO_CHAR(P1.CFM_DATE)) -- 确认日期
    ,P1.PRD_CODE -- 产品编号
    ,NVL(TRIM(P1.TA_CODE),'-') -- TA代码
    ,P1.PRD_SCALE -- 产品总规模
    ,P1.TOT_VOL -- 份额总数
    ,P1.INCREASE_VOL -- 当日增加份数
    ,P1.REDUCE_VOL -- 当日减少份数
    ,P1.NAV -- 产品净值
    ,P1.FACE_VALUE -- 产品面值
    ,P1.INCOME_RATE -- 收益客户比例
    ,P1.ASSIGN_FLAG -- 收益分配标志
    ,P1.CONV_FLAG -- 转换标志
    ,CASE WHEN R1.TARGET_CD_VAL IS NOT NULL THEN R1.TARGET_CD_VAL ELSE '@'||P1.STATUS END -- 状态代码
    ,CASE WHEN R2.TARGET_CD_VAL IS NOT NULL THEN R2.TARGET_CD_VAL ELSE '@'||P1.LAST_STATUS END -- 上日状态代码
    ,P1.TOT_NAV -- 产品累计净值
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,'ifms_tbprddaily' -- 源表名称
    ,'ifmsf1' -- 任务编码
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间戳
from ${iol_schema}.ifms_tbprddaily p1
    left join ${iml_schema}.ref_pub_cd_map r1 on P1.STATUS = R1.SRC_CODE_VAL
        AND R1.SORC_SYS_CD= 'IFMS'
        AND R1.SRC_TAB_EN_NAME= 'IFMS_TBPRDDAILY'
        AND R1.SRC_FIELD_EN_NAME= 'STATUS'
        AND R1.TARGET_TAB_EN_NAME= 'PRD_FINC_PROD_IMP_INFO_H'
        AND R1.TARGET_TAB_FIELD_EN_NAME= 'STATUS_CD'
    left join ${iml_schema}.ref_pub_cd_map r2 on P1.LAST_STATUS = R2.SRC_CODE_VAL
        AND R2.SORC_SYS_CD= 'IFMS'
        AND R2.SRC_TAB_EN_NAME= 'IFMS_TBPRDDAILY'
        AND R2.SRC_FIELD_EN_NAME= 'LAST_STATUS'
        AND R2.TARGET_TAB_EN_NAME= 'PRD_FINC_PROD_IMP_INFO_H'
        AND R2.TARGET_TAB_FIELD_EN_NAME= 'LD_STATUS_CD'
where  1 = 1 
    AND P1.ETL_DT=TO_DATE('${batch_date}','YYYYMMDD')
;
commit;


commit;

-- 3.2 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iml_schema}.prd_finc_prod_imp_info_h_ifmsf1_cl(
            issue_dt -- 发布日期
    ,lp_id -- 法人编号
    ,cfm_dt -- 确认日期
    ,prod_id -- 产品编号
    ,ta_cd -- TA代码
    ,prod_tot_size -- 产品总规模
    ,lot_tot -- 份额总数
    ,td_add_shares -- 当日增加份数
    ,td_decrs_shares -- 当日减少份数
    ,prod_nv -- 产品净值
    ,prod_fac_val -- 产品面值
    ,prft_cust_ratio -- 收益客户比例
    ,prft_assign_flg -- 收益分配标志
    ,tran_flg -- 转换标志
    ,status_cd -- 状态代码
    ,ld_status_cd -- 上日状态代码
    ,prod_acm_nv -- 产品累计净值
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iml_schema}.prd_finc_prod_imp_info_h_ifmsf1_op(
            issue_dt -- 发布日期
    ,lp_id -- 法人编号
    ,cfm_dt -- 确认日期
    ,prod_id -- 产品编号
    ,ta_cd -- TA代码
    ,prod_tot_size -- 产品总规模
    ,lot_tot -- 份额总数
    ,td_add_shares -- 当日增加份数
    ,td_decrs_shares -- 当日减少份数
    ,prod_nv -- 产品净值
    ,prod_fac_val -- 产品面值
    ,prft_cust_ratio -- 收益客户比例
    ,prft_assign_flg -- 收益分配标志
    ,tran_flg -- 转换标志
    ,status_cd -- 状态代码
    ,ld_status_cd -- 上日状态代码
    ,prod_acm_nv -- 产品累计净值
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.issue_dt, o.issue_dt) as issue_dt -- 发布日期
    ,nvl(n.lp_id, o.lp_id) as lp_id -- 法人编号
    ,nvl(n.cfm_dt, o.cfm_dt) as cfm_dt -- 确认日期
    ,nvl(n.prod_id, o.prod_id) as prod_id -- 产品编号
    ,nvl(n.ta_cd, o.ta_cd) as ta_cd -- TA代码
    ,nvl(n.prod_tot_size, o.prod_tot_size) as prod_tot_size -- 产品总规模
    ,nvl(n.lot_tot, o.lot_tot) as lot_tot -- 份额总数
    ,nvl(n.td_add_shares, o.td_add_shares) as td_add_shares -- 当日增加份数
    ,nvl(n.td_decrs_shares, o.td_decrs_shares) as td_decrs_shares -- 当日减少份数
    ,nvl(n.prod_nv, o.prod_nv) as prod_nv -- 产品净值
    ,nvl(n.prod_fac_val, o.prod_fac_val) as prod_fac_val -- 产品面值
    ,nvl(n.prft_cust_ratio, o.prft_cust_ratio) as prft_cust_ratio -- 收益客户比例
    ,nvl(n.prft_assign_flg, o.prft_assign_flg) as prft_assign_flg -- 收益分配标志
    ,nvl(n.tran_flg, o.tran_flg) as tran_flg -- 转换标志
    ,nvl(n.status_cd, o.status_cd) as status_cd -- 状态代码
    ,nvl(n.ld_status_cd, o.ld_status_cd) as ld_status_cd -- 上日状态代码
    ,nvl(n.prod_acm_nv, o.prod_acm_nv) as prod_acm_nv -- 产品累计净值
    ,case when
            n.issue_dt is null
            and n.lp_id is null
            and n.cfm_dt is null
            and n.prod_id is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.issue_dt is null
            and n.lp_id is null
            and n.cfm_dt is null
            and n.prod_id is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.issue_dt is null
            and n.lp_id is null
            and n.cfm_dt is null
            and n.prod_id is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,nvl(n.src_table_name, o.src_table_name) as src_table_name -- 源表名称
    ,nvl(n.job_cd, o.job_cd) as job_cd -- 任务编码
    ,nvl(n.etl_timestamp, o.etl_timestamp) as etl_timestamp -- ETL处理时间戳
from ${iml_schema}.prd_finc_prod_imp_info_h_ifmsf1_tm n
    full join (select * from ${iml_schema}.prd_finc_prod_imp_info_h_ifmsf1_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
        on
            o.issue_dt = n.issue_dt
            and o.lp_id = n.lp_id
            and o.cfm_dt = n.cfm_dt
            and o.prod_id = n.prod_id
where (
        o.issue_dt is null
        and o.lp_id is null
        and o.cfm_dt is null
        and o.prod_id is null
    )
    or (
        n.issue_dt is null
        and n.lp_id is null
        and n.cfm_dt is null
        and n.prod_id is null
    )
    or (
        o.ta_cd <> n.ta_cd
        or o.prod_tot_size <> n.prod_tot_size
        or o.lot_tot <> n.lot_tot
        or o.td_add_shares <> n.td_add_shares
        or o.td_decrs_shares <> n.td_decrs_shares
        or o.prod_nv <> n.prod_nv
        or o.prod_fac_val <> n.prod_fac_val
        or o.prft_cust_ratio <> n.prft_cust_ratio
        or o.prft_assign_flg <> n.prft_assign_flg
        or o.tran_flg <> n.tran_flg
        or o.status_cd <> n.status_cd
        or o.ld_status_cd <> n.ld_status_cd
        or o.prod_acm_nv <> n.prod_acm_nv
    )
;
commit;

-- 3.3 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iml_schema}.prd_finc_prod_imp_info_h_ifmsf1_cl(
            issue_dt -- 发布日期
    ,lp_id -- 法人编号
    ,cfm_dt -- 确认日期
    ,prod_id -- 产品编号
    ,ta_cd -- TA代码
    ,prod_tot_size -- 产品总规模
    ,lot_tot -- 份额总数
    ,td_add_shares -- 当日增加份数
    ,td_decrs_shares -- 当日减少份数
    ,prod_nv -- 产品净值
    ,prod_fac_val -- 产品面值
    ,prft_cust_ratio -- 收益客户比例
    ,prft_assign_flg -- 收益分配标志
    ,tran_flg -- 转换标志
    ,status_cd -- 状态代码
    ,ld_status_cd -- 上日状态代码
    ,prod_acm_nv -- 产品累计净值
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iml_schema}.prd_finc_prod_imp_info_h_ifmsf1_op(
            issue_dt -- 发布日期
    ,lp_id -- 法人编号
    ,cfm_dt -- 确认日期
    ,prod_id -- 产品编号
    ,ta_cd -- TA代码
    ,prod_tot_size -- 产品总规模
    ,lot_tot -- 份额总数
    ,td_add_shares -- 当日增加份数
    ,td_decrs_shares -- 当日减少份数
    ,prod_nv -- 产品净值
    ,prod_fac_val -- 产品面值
    ,prft_cust_ratio -- 收益客户比例
    ,prft_assign_flg -- 收益分配标志
    ,tran_flg -- 转换标志
    ,status_cd -- 状态代码
    ,ld_status_cd -- 上日状态代码
    ,prod_acm_nv -- 产品累计净值
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.issue_dt -- 发布日期
    ,o.lp_id -- 法人编号
    ,o.cfm_dt -- 确认日期
    ,o.prod_id -- 产品编号
    ,o.ta_cd -- TA代码
    ,o.prod_tot_size -- 产品总规模
    ,o.lot_tot -- 份额总数
    ,o.td_add_shares -- 当日增加份数
    ,o.td_decrs_shares -- 当日减少份数
    ,o.prod_nv -- 产品净值
    ,o.prod_fac_val -- 产品面值
    ,o.prft_cust_ratio -- 收益客户比例
    ,o.prft_assign_flg -- 收益分配标志
    ,o.tran_flg -- 转换标志
    ,o.status_cd -- 状态代码
    ,o.ld_status_cd -- 上日状态代码
    ,o.prod_acm_nv -- 产品累计净值
    ,o.start_dt -- 开始时间
    ,case when n.start_dt is not null then to_date('${batch_date}', 'yyyymmdd')
          when o.end_dt >= to_date('${batch_date}','yyyymmdd') then to_date('20991231','yyyymmdd')
          else o.end_dt
     end as end_dt -- 结束时间
    ,o.id_mark -- 增删标志
    ,o.src_table_name -- 源表名称
    ,o.job_cd -- 任务编码
    ,o.etl_timestamp -- ETL处理时间戳
from ${iml_schema}.prd_finc_prod_imp_info_h_ifmsf1_bk o
    left join ${iml_schema}.prd_finc_prod_imp_info_h_ifmsf1_op n
        on
            o.issue_dt = n.issue_dt
            and o.lp_id = n.lp_id
            and o.cfm_dt = n.cfm_dt
            and o.prod_id = n.prod_id
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iml_schema}.prd_finc_prod_imp_info_h_ifmsf1_cl d
        on
            o.issue_dt = d.issue_dt
            and o.lp_id = d.lp_id
            and o.cfm_dt = d.cfm_dt
            and o.prod_id = d.prod_id
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
--truncate table ${iml_schema}.prd_finc_prod_imp_info_h;
alter table ${iml_schema}.prd_finc_prod_imp_info_h truncate partition for ('ifmsf1') reuse storage;

-- 4.2 exchange partition
alter table ${iml_schema}.prd_finc_prod_imp_info_h exchange subpartition p_ifmsf1_19000101 with table ${iml_schema}.prd_finc_prod_imp_info_h_ifmsf1_cl;
alter table ${iml_schema}.prd_finc_prod_imp_info_h exchange subpartition p_ifmsf1_20991231 with table ${iml_schema}.prd_finc_prod_imp_info_h_ifmsf1_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iml_schema}.prd_finc_prod_imp_info_h to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iml_schema}.prd_finc_prod_imp_info_h_ifmsf1_tm purge;
drop table ${iml_schema}.prd_finc_prod_imp_info_h_ifmsf1_op purge;
drop table ${iml_schema}.prd_finc_prod_imp_info_h_ifmsf1_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iml_schema}.prd_finc_prod_imp_info_h_ifmsf1_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iml_schema}',tabname => 'prd_finc_prod_imp_info_h', partname => 'p_ifmsf1_20991231', granularity => 'SUBPARTITION', degree => 8, cascade => true);
