/*
Purpose:    整合模型层-增量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iml_prd_distr_finc_day_sell_info_h_ifdsi1
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
alter table ${iml_schema}.prd_distr_finc_day_sell_info_h add partition p_ifdsi1 values ('ifdsi1')(
        subpartition p_ifdsi1_19000101 values less than (to_date('20991231','yyyymmdd'))
        ,subpartition p_ifdsi1_20991231 values less than (maxvalue)
    )
;

-- if backup table is exists, mean script if failed on last time
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
create table ${iml_schema}.prd_distr_finc_day_sell_info_h_ifdsi1_bk nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.prd_distr_finc_day_sell_info_h partition for ('ifdsi1')
;

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iml_schema}.prd_distr_finc_day_sell_info_h_ifdsi1_tm purge;
drop table ${iml_schema}.prd_distr_finc_day_sell_info_h_ifdsi1_op purge;
drop table ${iml_schema}.prd_distr_finc_day_sell_info_h_ifdsi1_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.prd_distr_finc_day_sell_info_h_ifdsi1_tm nologging
compress ${option_switch} for query high
as select
    prod_id -- 产品编号
    ,lp_id -- 法人编号
    ,issue_dt -- 发布日期
    ,bank_id -- 银行编号
    ,src_prod_id -- 源产品编号
    ,finc_prod_id -- 理财产品编号
    ,ta_cd -- TA代码
    ,prod_size -- 产品规模
    ,lot -- 份额
    ,td_add_shares -- 当日增加份数
    ,td_decrs_shares -- 当日减少份数
    ,prod_nv -- 产品净值
    ,prod_fac_val -- 产品面值
    ,aual_yld -- 年化收益率
    ,prod_year_prft -- 产品年收益
    ,ten_thous_corp_prft -- 万份单位收益
    ,unditrib_prft -- 未分配收益
    ,td_assign_prft -- 当天分配收益
    ,prft_assign_flg -- 收益分配标志
    ,tran_flg -- 转换标志
    ,status_cd -- 状态代码
    ,ld_prod_status_cd -- 上日产品状态代码
    ,prod_acm_nv -- 产品累计净值
    ,to_date('${batch_date}', 'yyyymmdd') as etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
from ${iml_schema}.prd_distr_finc_day_sell_info_h partition for ('ifdsi1')
where 0=1
;

create table ${iml_schema}.prd_distr_finc_day_sell_info_h_ifdsi1_op nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.prd_distr_finc_day_sell_info_h partition for ('ifdsi1') where 0=1;

create table ${iml_schema}.prd_distr_finc_day_sell_info_h_ifdsi1_cl nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.prd_distr_finc_day_sell_info_h partition for ('ifdsi1') where 0=1;

-- 3.1 get new data into table
-- ifms_fds_tbprddaily-
insert into ${iml_schema}.prd_distr_finc_day_sell_info_h_ifdsi1_tm(
    prod_id -- 产品编号
    ,lp_id -- 法人编号
    ,issue_dt -- 发布日期
    ,bank_id -- 银行编号
    ,src_prod_id -- 源产品编号
    ,finc_prod_id -- 理财产品编号
    ,ta_cd -- TA代码
    ,prod_size -- 产品规模
    ,lot -- 份额
    ,td_add_shares -- 当日增加份数
    ,td_decrs_shares -- 当日减少份数
    ,prod_nv -- 产品净值
    ,prod_fac_val -- 产品面值
    ,aual_yld -- 年化收益率
    ,prod_year_prft -- 产品年收益
    ,ten_thous_corp_prft -- 万份单位收益
    ,unditrib_prft -- 未分配收益
    ,td_assign_prft -- 当天分配收益
    ,prft_assign_flg -- 收益分配标志
    ,tran_flg -- 转换标志
    ,status_cd -- 状态代码
    ,ld_prod_status_cd -- 上日产品状态代码
    ,prod_acm_nv -- 产品累计净值
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
)
select
    '223004'||P1.PRD_CODE -- 产品编号
    ,'9999' -- 法人编号
    ,${iml_schema}.DATEFORMAT_min(TO_CHAR(P1.ISS_DATE)) -- 发布日期
    ,P1.BANK_NO -- 银行编号
    ,P1.PRD_CODE -- 源产品编号
    ,P1.REAL_PRD_CODE -- 理财产品编号
    ,P1.TA_CODE -- TA代码
    ,P1.PRD_SCALE -- 产品规模
    ,P1.TOT_VOL -- 份额
    ,P1.INCREASE_VOL -- 当日增加份数
    ,P1.REDUCE_VOL -- 当日减少份数
    ,P1.NAV -- 产品净值
    ,P1.FACE_VALUE -- 产品面值
    ,P1.INCOME_RATE -- 年化收益率
    ,P1.INCOME -- 产品年收益
    ,P1.INCOME_UNIT -- 万份单位收益
    ,P1.UNASSIGN_INCOME -- 未分配收益
    ,P1.ASSIGN_INCOME -- 当天分配收益
    ,P1.ASSIGN_FLAG -- 收益分配标志
    ,P1.CONV_FLAG -- 转换标志
    ,P1.STATUS -- 状态代码
    ,P1.LAST_STATUS -- 上日产品状态代码
    ,P1.TOT_NAV -- 产品累计净值
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,'ifms_fds_tbprddaily' -- 源表名称
    ,'ifdsi1' -- 任务编码
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间戳
from ${iol_schema}.ifms_fds_tbprddaily p1
where  1 = 1 
    and to_char(to_date(p1.cfm_date,'yyyymmdd'),'yyyymmdd') = '${batch_date}'
;
commit;


commit;

-- 3.2 get new, alter data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ into ${iml_schema}.prd_distr_finc_day_sell_info_h_ifdsi1_op(
        prod_id -- 产品编号
    ,lp_id -- 法人编号
    ,issue_dt -- 发布日期
    ,bank_id -- 银行编号
    ,src_prod_id -- 源产品编号
    ,finc_prod_id -- 理财产品编号
    ,ta_cd -- TA代码
    ,prod_size -- 产品规模
    ,lot -- 份额
    ,td_add_shares -- 当日增加份数
    ,td_decrs_shares -- 当日减少份数
    ,prod_nv -- 产品净值
    ,prod_fac_val -- 产品面值
    ,aual_yld -- 年化收益率
    ,prod_year_prft -- 产品年收益
    ,ten_thous_corp_prft -- 万份单位收益
    ,unditrib_prft -- 未分配收益
    ,td_assign_prft -- 当天分配收益
    ,prft_assign_flg -- 收益分配标志
    ,tran_flg -- 转换标志
    ,status_cd -- 状态代码
    ,ld_prod_status_cd -- 上日产品状态代码
    ,prod_acm_nv -- 产品累计净值
        ,start_dt -- 开始时间
        ,end_dt -- 结束时间
        ,id_mark -- 增删标志
        ,src_table_name -- 源表名称
        ,job_cd -- 任务编码
        ,etl_timestamp -- ETL处理时间戳
    )
select
    n.prod_id -- 产品编号
    ,n.lp_id -- 法人编号
    ,n.issue_dt -- 发布日期
    ,n.bank_id -- 银行编号
    ,n.src_prod_id -- 源产品编号
    ,n.finc_prod_id -- 理财产品编号
    ,n.ta_cd -- TA代码
    ,n.prod_size -- 产品规模
    ,n.lot -- 份额
    ,n.td_add_shares -- 当日增加份数
    ,n.td_decrs_shares -- 当日减少份数
    ,n.prod_nv -- 产品净值
    ,n.prod_fac_val -- 产品面值
    ,n.aual_yld -- 年化收益率
    ,n.prod_year_prft -- 产品年收益
    ,n.ten_thous_corp_prft -- 万份单位收益
    ,n.unditrib_prft -- 未分配收益
    ,n.td_assign_prft -- 当天分配收益
    ,n.prft_assign_flg -- 收益分配标志
    ,n.tran_flg -- 转换标志
    ,n.status_cd -- 状态代码
    ,n.ld_prod_status_cd -- 上日产品状态代码
    ,n.prod_acm_nv -- 产品累计净值
    ,to_date('${batch_date}', 'yyyymmdd') as start_dt -- 开始时间
    ,to_date('20991231', 'yyyymmdd') as end_dt -- 结束时间
    ,'I' as id_mark -- 增删标志
    ,n.src_table_name -- 源表名称
    ,'ifdsi1' as job_cd -- 任务编码
    ,n.etl_timestamp as etl_timestamp -- ETL处理时间戳
from ${iml_schema}.prd_distr_finc_day_sell_info_h_ifdsi1_tm n
    left join (select * from ${iml_schema}.prd_distr_finc_day_sell_info_h_ifdsi1_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd')) o
        on
            o.prod_id = n.prod_id
            and o.lp_id = n.lp_id
where (
        o.prod_id is null
        and o.lp_id is null
    )
    or (
        o.issue_dt <> n.issue_dt
        or o.bank_id <> n.bank_id
        or o.src_prod_id <> n.src_prod_id
        or o.finc_prod_id <> n.finc_prod_id
        or o.ta_cd <> n.ta_cd
        or o.prod_size <> n.prod_size
        or o.lot <> n.lot
        or o.td_add_shares <> n.td_add_shares
        or o.td_decrs_shares <> n.td_decrs_shares
        or o.prod_nv <> n.prod_nv
        or o.prod_fac_val <> n.prod_fac_val
        or o.aual_yld <> n.aual_yld
        or o.prod_year_prft <> n.prod_year_prft
        or o.ten_thous_corp_prft <> n.ten_thous_corp_prft
        or o.unditrib_prft <> n.unditrib_prft
        or o.td_assign_prft <> n.td_assign_prft
        or o.prft_assign_flg <> n.prft_assign_flg
        or o.tran_flg <> n.tran_flg
        or o.status_cd <> n.status_cd
        or o.ld_prod_status_cd <> n.ld_prod_status_cd
        or o.prod_acm_nv <> n.prod_acm_nv
    )
;
commit;

-- 3.3 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iml_schema}.prd_distr_finc_day_sell_info_h_ifdsi1_cl(
            prod_id -- 产品编号
    ,lp_id -- 法人编号
    ,issue_dt -- 发布日期
    ,bank_id -- 银行编号
    ,src_prod_id -- 源产品编号
    ,finc_prod_id -- 理财产品编号
    ,ta_cd -- TA代码
    ,prod_size -- 产品规模
    ,lot -- 份额
    ,td_add_shares -- 当日增加份数
    ,td_decrs_shares -- 当日减少份数
    ,prod_nv -- 产品净值
    ,prod_fac_val -- 产品面值
    ,aual_yld -- 年化收益率
    ,prod_year_prft -- 产品年收益
    ,ten_thous_corp_prft -- 万份单位收益
    ,unditrib_prft -- 未分配收益
    ,td_assign_prft -- 当天分配收益
    ,prft_assign_flg -- 收益分配标志
    ,tran_flg -- 转换标志
    ,status_cd -- 状态代码
    ,ld_prod_status_cd -- 上日产品状态代码
    ,prod_acm_nv -- 产品累计净值
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iml_schema}.prd_distr_finc_day_sell_info_h_ifdsi1_op(
            prod_id -- 产品编号
    ,lp_id -- 法人编号
    ,issue_dt -- 发布日期
    ,bank_id -- 银行编号
    ,src_prod_id -- 源产品编号
    ,finc_prod_id -- 理财产品编号
    ,ta_cd -- TA代码
    ,prod_size -- 产品规模
    ,lot -- 份额
    ,td_add_shares -- 当日增加份数
    ,td_decrs_shares -- 当日减少份数
    ,prod_nv -- 产品净值
    ,prod_fac_val -- 产品面值
    ,aual_yld -- 年化收益率
    ,prod_year_prft -- 产品年收益
    ,ten_thous_corp_prft -- 万份单位收益
    ,unditrib_prft -- 未分配收益
    ,td_assign_prft -- 当天分配收益
    ,prft_assign_flg -- 收益分配标志
    ,tran_flg -- 转换标志
    ,status_cd -- 状态代码
    ,ld_prod_status_cd -- 上日产品状态代码
    ,prod_acm_nv -- 产品累计净值
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
    ,o.issue_dt -- 发布日期
    ,o.bank_id -- 银行编号
    ,o.src_prod_id -- 源产品编号
    ,o.finc_prod_id -- 理财产品编号
    ,o.ta_cd -- TA代码
    ,o.prod_size -- 产品规模
    ,o.lot -- 份额
    ,o.td_add_shares -- 当日增加份数
    ,o.td_decrs_shares -- 当日减少份数
    ,o.prod_nv -- 产品净值
    ,o.prod_fac_val -- 产品面值
    ,o.aual_yld -- 年化收益率
    ,o.prod_year_prft -- 产品年收益
    ,o.ten_thous_corp_prft -- 万份单位收益
    ,o.unditrib_prft -- 未分配收益
    ,o.td_assign_prft -- 当天分配收益
    ,o.prft_assign_flg -- 收益分配标志
    ,o.tran_flg -- 转换标志
    ,o.status_cd -- 状态代码
    ,o.ld_prod_status_cd -- 上日产品状态代码
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
from ${iml_schema}.prd_distr_finc_day_sell_info_h_ifdsi1_bk o
    left join ${iml_schema}.prd_distr_finc_day_sell_info_h_ifdsi1_op n
        on
            o.prod_id = n.prod_id
            and o.lp_id = n.lp_id
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
where o.start_dt < to_date('${batch_date}','yyyymmdd')
;
commit;

-- 4.1 truncate target table
--truncate table ${iml_schema}.prd_distr_finc_day_sell_info_h;
alter table ${iml_schema}.prd_distr_finc_day_sell_info_h truncate partition for ('ifdsi1') reuse storage;

-- 4.2 exchange partition
alter table ${iml_schema}.prd_distr_finc_day_sell_info_h exchange subpartition p_ifdsi1_19000101 with table ${iml_schema}.prd_distr_finc_day_sell_info_h_ifdsi1_cl;
alter table ${iml_schema}.prd_distr_finc_day_sell_info_h exchange subpartition p_ifdsi1_20991231 with table ${iml_schema}.prd_distr_finc_day_sell_info_h_ifdsi1_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iml_schema}.prd_distr_finc_day_sell_info_h to ${iml_schema};

-- 5.2 drop temp table
whenever sqlerror continue none ;
-- it is no need to check when this segment SQL was return faied
drop table ${iml_schema}.prd_distr_finc_day_sell_info_h_ifdsi1_tm purge;
drop table ${iml_schema}.prd_distr_finc_day_sell_info_h_ifdsi1_op purge;
drop table ${iml_schema}.prd_distr_finc_day_sell_info_h_ifdsi1_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iml_schema}.prd_distr_finc_day_sell_info_h_ifdsi1_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iml_schema}',tabname => 'prd_distr_finc_day_sell_info_h', partname => 'p_ifdsi1_20991231', granularity => 'SUBPARTITION', degree => 8, cascade => true);
