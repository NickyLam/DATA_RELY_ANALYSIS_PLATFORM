/*
Purpose:    整合模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iml_ast_col_list_stock_inpwn_info_mimsf1
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
alter table ${iml_schema}.ast_col_list_stock_inpwn_info add partition p_mimsf1 values ('mimsf1')(
        subpartition p_mimsf1_19000101 values less than (to_date('20991231','yyyymmdd'))
        ,subpartition p_mimsf1_20991231 values less than (maxvalue)
    )
;

-- if backup table is exists, mean script if failed on last time
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
create table ${iml_schema}.ast_col_list_stock_inpwn_info_mimsf1_bk nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.ast_col_list_stock_inpwn_info partition for ('mimsf1')
;

-- 2.2 drop temp table
whenever sqlerror continue none ;
-- it is no need to check when this segment SQL was return faied
drop table ${iml_schema}.ast_col_list_stock_inpwn_info_mimsf1_tm purge;
drop table ${iml_schema}.ast_col_list_stock_inpwn_info_mimsf1_op purge;
drop table ${iml_schema}.ast_col_list_stock_inpwn_info_mimsf1_cl purge;

-- 2.3 create temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.ast_col_list_stock_inpwn_info_mimsf1_tm nologging
compress ${option_switch} for query high
as select
    asset_id -- 资产编号
    ,lp_id -- 法人编号
    ,stock_cd -- 股票代码
    ,stock_name -- 股票名称
    ,corp_name -- 公司名称
    ,issuer_brwer_flg -- 发行人为借款人标志
    ,corp_prev_year_margin -- 公司上年度利润
    ,stock_nomal_flg -- 股票正常标志
    ,stock_status_cd -- 股票状态代码
    ,tran_site_cd -- 交易场所代码
    ,public_tran_flg -- 公开交易标志
    ,hold_shares_qtty -- 持股数量
    ,inpwn_stock_qtty -- 质押股权数量
    ,mk_pri -- 市价
    ,last_year_share_divd_amt -- 上年每股分红金额
    ,warning_line -- 警戒线
    ,per_share_net_asset -- 每股净资产
    ,close_pos_line -- 平仓线
    ,inpwn_tot_val -- 质押总价值
    ,restr_exp_dt -- 限售到期日期
    ,other_comnt -- 其他说明
    ,curr_cd -- 币种代码
    ,trust_broker_name -- 托管券商名称
    ,to_date('${batch_date}', 'yyyymmdd') as etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
from ${iml_schema}.ast_col_list_stock_inpwn_info partition for ('mimsf1')
where 0=1
;

create table ${iml_schema}.ast_col_list_stock_inpwn_info_mimsf1_op nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.ast_col_list_stock_inpwn_info partition for ('mimsf1') where 0=1;

create table ${iml_schema}.ast_col_list_stock_inpwn_info_mimsf1_cl nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.ast_col_list_stock_inpwn_info partition for ('mimsf1') where 0=1;

-- 3.1 get new data into table
-- mims_si_listedstock-
insert into ${iml_schema}.ast_col_list_stock_inpwn_info_mimsf1_tm(
    asset_id -- 资产编号
    ,lp_id -- 法人编号
    ,stock_cd -- 股票代码
    ,stock_name -- 股票名称
    ,corp_name -- 公司名称
    ,issuer_brwer_flg -- 发行人为借款人标志
    ,corp_prev_year_margin -- 公司上年度利润
    ,stock_nomal_flg -- 股票正常标志
    ,stock_status_cd -- 股票状态代码
    ,tran_site_cd -- 交易场所代码
    ,public_tran_flg -- 公开交易标志
    ,hold_shares_qtty -- 持股数量
    ,inpwn_stock_qtty -- 质押股权数量
    ,mk_pri -- 市价
    ,last_year_share_divd_amt -- 上年每股分红金额
    ,warning_line -- 警戒线
    ,per_share_net_asset -- 每股净资产
    ,close_pos_line -- 平仓线
    ,inpwn_tot_val -- 质押总价值
    ,restr_exp_dt -- 限售到期日期
    ,other_comnt -- 其他说明
    ,curr_cd -- 币种代码
    ,trust_broker_name -- 托管券商名称
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
)
select
    p1.SCCODE -- 资产编号
    ,'9999' -- 法人编号
    ,p1.STOCKCODE -- 股票代码
    ,p1.STOCKNAME -- 股票名称
    ,p1.COMPANYNAME -- 公司名称
    ,nvl(trim(p1.ISBORROWER),'-') -- 发行人为借款人标志
    ,p1.PROFITS -- 公司上年度利润
    ,CASE WHEN ISNROMAL='01' THEN '1' WHEN TRIM(ISNROMAL) IS NULL THEN '-' ELSE '0' END -- 股票正常标志
    ,nvl(trim(p1.ISNROMAL),'00') -- 股票状态代码
    ,CASE WHEN R1.TARGET_CD_VAL IS NOT NULL THEN R1.TARGET_CD_VAL ELSE '@'||P1.BOURSE END -- 交易场所代码
    ,nvl(trim(p1.ISPUBLIC),'-') -- 公开交易标志
    ,p1.SHAREAMOUNT -- 持股数量
    ,p1.STOCKAMOUNT -- 质押股权数量
    ,p1.PERSHAREMARKETPRICE -- 市价
    ,p1.PROFITMONEY -- 上年每股分红金额
    ,p1.WARNINGLINE -- 警戒线
    ,p1.PERSHAREVALUE -- 每股净资产
    ,p1.LIQUIDATELINE -- 平仓线
    ,p1.TOTALVALUE -- 质押总价值
    ,${iml_schema}.DATEFORMAT_MIN(P1.DUEDATE) -- 限售到期日期
    ,p1.REMARK -- 其他说明
    ,nvl(trim(p1.TDCURRENCY),'CNY') -- 币种代码
    ,p1.STOCKIDC -- 托管券商名称
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,'mims_si_listedstock' -- 源表名称
    ,'mimsf1' -- 任务编码
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间戳
from ${iol_schema}.mims_si_listedstock p1
    left join ${iml_schema}.ref_pub_cd_map r1 on P1.BOURSE = R1.SRC_CODE_VAL
        AND R1.SORC_SYS_CD= 'MIMS'
        AND R1.SRC_TAB_EN_NAME= 'MIMS_SI_LISTEDSTOCK'
        AND R1.SRC_FIELD_EN_NAME= 'BOURSE'
        AND R1.TARGET_TAB_EN_NAME= 'AST_COL_LIST_STOCK_INPWN_INFO'
        AND R1.TARGET_TAB_FIELD_EN_NAME= 'TRAN_SITE_CD'
where p1.start_dt <= to_date('${batch_date}','yyyymmdd') and p1.end_dt > to_date('${batch_date}','yyyymmdd')
;
commit;


commit;

-- 3.2 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iml_schema}.ast_col_list_stock_inpwn_info_mimsf1_cl(
            asset_id -- 资产编号
    ,lp_id -- 法人编号
    ,stock_cd -- 股票代码
    ,stock_name -- 股票名称
    ,corp_name -- 公司名称
    ,issuer_brwer_flg -- 发行人为借款人标志
    ,corp_prev_year_margin -- 公司上年度利润
    ,stock_nomal_flg -- 股票正常标志
    ,stock_status_cd -- 股票状态代码
    ,tran_site_cd -- 交易场所代码
    ,public_tran_flg -- 公开交易标志
    ,hold_shares_qtty -- 持股数量
    ,inpwn_stock_qtty -- 质押股权数量
    ,mk_pri -- 市价
    ,last_year_share_divd_amt -- 上年每股分红金额
    ,warning_line -- 警戒线
    ,per_share_net_asset -- 每股净资产
    ,close_pos_line -- 平仓线
    ,inpwn_tot_val -- 质押总价值
    ,restr_exp_dt -- 限售到期日期
    ,other_comnt -- 其他说明
    ,curr_cd -- 币种代码
    ,trust_broker_name -- 托管券商名称
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iml_schema}.ast_col_list_stock_inpwn_info_mimsf1_op(
            asset_id -- 资产编号
    ,lp_id -- 法人编号
    ,stock_cd -- 股票代码
    ,stock_name -- 股票名称
    ,corp_name -- 公司名称
    ,issuer_brwer_flg -- 发行人为借款人标志
    ,corp_prev_year_margin -- 公司上年度利润
    ,stock_nomal_flg -- 股票正常标志
    ,stock_status_cd -- 股票状态代码
    ,tran_site_cd -- 交易场所代码
    ,public_tran_flg -- 公开交易标志
    ,hold_shares_qtty -- 持股数量
    ,inpwn_stock_qtty -- 质押股权数量
    ,mk_pri -- 市价
    ,last_year_share_divd_amt -- 上年每股分红金额
    ,warning_line -- 警戒线
    ,per_share_net_asset -- 每股净资产
    ,close_pos_line -- 平仓线
    ,inpwn_tot_val -- 质押总价值
    ,restr_exp_dt -- 限售到期日期
    ,other_comnt -- 其他说明
    ,curr_cd -- 币种代码
    ,trust_broker_name -- 托管券商名称
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.asset_id, o.asset_id) as asset_id -- 资产编号
    ,nvl(n.lp_id, o.lp_id) as lp_id -- 法人编号
    ,nvl(n.stock_cd, o.stock_cd) as stock_cd -- 股票代码
    ,nvl(n.stock_name, o.stock_name) as stock_name -- 股票名称
    ,nvl(n.corp_name, o.corp_name) as corp_name -- 公司名称
    ,nvl(n.issuer_brwer_flg, o.issuer_brwer_flg) as issuer_brwer_flg -- 发行人为借款人标志
    ,nvl(n.corp_prev_year_margin, o.corp_prev_year_margin) as corp_prev_year_margin -- 公司上年度利润
    ,nvl(n.stock_nomal_flg, o.stock_nomal_flg) as stock_nomal_flg -- 股票正常标志
    ,nvl(n.stock_status_cd, o.stock_status_cd) as stock_status_cd -- 股票状态代码
    ,nvl(n.tran_site_cd, o.tran_site_cd) as tran_site_cd -- 交易场所代码
    ,nvl(n.public_tran_flg, o.public_tran_flg) as public_tran_flg -- 公开交易标志
    ,nvl(n.hold_shares_qtty, o.hold_shares_qtty) as hold_shares_qtty -- 持股数量
    ,nvl(n.inpwn_stock_qtty, o.inpwn_stock_qtty) as inpwn_stock_qtty -- 质押股权数量
    ,nvl(n.mk_pri, o.mk_pri) as mk_pri -- 市价
    ,nvl(n.last_year_share_divd_amt, o.last_year_share_divd_amt) as last_year_share_divd_amt -- 上年每股分红金额
    ,nvl(n.warning_line, o.warning_line) as warning_line -- 警戒线
    ,nvl(n.per_share_net_asset, o.per_share_net_asset) as per_share_net_asset -- 每股净资产
    ,nvl(n.close_pos_line, o.close_pos_line) as close_pos_line -- 平仓线
    ,nvl(n.inpwn_tot_val, o.inpwn_tot_val) as inpwn_tot_val -- 质押总价值
    ,nvl(n.restr_exp_dt, o.restr_exp_dt) as restr_exp_dt -- 限售到期日期
    ,nvl(n.other_comnt, o.other_comnt) as other_comnt -- 其他说明
    ,nvl(n.curr_cd, o.curr_cd) as curr_cd -- 币种代码
    ,nvl(n.trust_broker_name, o.trust_broker_name) as trust_broker_name -- 托管券商名称
    ,case when
            n.asset_id is null
            and n.lp_id is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.asset_id is null
            and n.lp_id is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.asset_id is null
            and n.lp_id is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,nvl(n.src_table_name, o.src_table_name) as src_table_name -- 源表名称
    ,nvl(n.job_cd, o.job_cd) as job_cd -- 任务编码
    ,nvl(n.etl_timestamp, o.etl_timestamp) as etl_timestamp -- ETL处理时间戳
from ${iml_schema}.ast_col_list_stock_inpwn_info_mimsf1_tm n
    full join (select * from ${iml_schema}.ast_col_list_stock_inpwn_info_mimsf1_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
        on
            o.asset_id = n.asset_id
            and o.lp_id = n.lp_id
where (
        o.asset_id is null
        and o.lp_id is null
    )
    or (
        n.asset_id is null
        and n.lp_id is null
    )
    or (
        o.stock_cd <> n.stock_cd
        or o.stock_name <> n.stock_name
        or o.corp_name <> n.corp_name
        or o.issuer_brwer_flg <> n.issuer_brwer_flg
        or o.corp_prev_year_margin <> n.corp_prev_year_margin
        or o.stock_nomal_flg <> n.stock_nomal_flg
        or o.stock_status_cd <> n.stock_status_cd
        or o.tran_site_cd <> n.tran_site_cd
        or o.public_tran_flg <> n.public_tran_flg
        or o.hold_shares_qtty <> n.hold_shares_qtty
        or o.inpwn_stock_qtty <> n.inpwn_stock_qtty
        or o.mk_pri <> n.mk_pri
        or o.last_year_share_divd_amt <> n.last_year_share_divd_amt
        or o.warning_line <> n.warning_line
        or o.per_share_net_asset <> n.per_share_net_asset
        or o.close_pos_line <> n.close_pos_line
        or o.inpwn_tot_val <> n.inpwn_tot_val
        or o.restr_exp_dt <> n.restr_exp_dt
        or o.other_comnt <> n.other_comnt
        or o.curr_cd <> n.curr_cd
        or o.trust_broker_name <> n.trust_broker_name
    )
;
commit;

-- 3.3 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iml_schema}.ast_col_list_stock_inpwn_info_mimsf1_cl(
            asset_id -- 资产编号
    ,lp_id -- 法人编号
    ,stock_cd -- 股票代码
    ,stock_name -- 股票名称
    ,corp_name -- 公司名称
    ,issuer_brwer_flg -- 发行人为借款人标志
    ,corp_prev_year_margin -- 公司上年度利润
    ,stock_nomal_flg -- 股票正常标志
    ,stock_status_cd -- 股票状态代码
    ,tran_site_cd -- 交易场所代码
    ,public_tran_flg -- 公开交易标志
    ,hold_shares_qtty -- 持股数量
    ,inpwn_stock_qtty -- 质押股权数量
    ,mk_pri -- 市价
    ,last_year_share_divd_amt -- 上年每股分红金额
    ,warning_line -- 警戒线
    ,per_share_net_asset -- 每股净资产
    ,close_pos_line -- 平仓线
    ,inpwn_tot_val -- 质押总价值
    ,restr_exp_dt -- 限售到期日期
    ,other_comnt -- 其他说明
    ,curr_cd -- 币种代码
    ,trust_broker_name -- 托管券商名称
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iml_schema}.ast_col_list_stock_inpwn_info_mimsf1_op(
            asset_id -- 资产编号
    ,lp_id -- 法人编号
    ,stock_cd -- 股票代码
    ,stock_name -- 股票名称
    ,corp_name -- 公司名称
    ,issuer_brwer_flg -- 发行人为借款人标志
    ,corp_prev_year_margin -- 公司上年度利润
    ,stock_nomal_flg -- 股票正常标志
    ,stock_status_cd -- 股票状态代码
    ,tran_site_cd -- 交易场所代码
    ,public_tran_flg -- 公开交易标志
    ,hold_shares_qtty -- 持股数量
    ,inpwn_stock_qtty -- 质押股权数量
    ,mk_pri -- 市价
    ,last_year_share_divd_amt -- 上年每股分红金额
    ,warning_line -- 警戒线
    ,per_share_net_asset -- 每股净资产
    ,close_pos_line -- 平仓线
    ,inpwn_tot_val -- 质押总价值
    ,restr_exp_dt -- 限售到期日期
    ,other_comnt -- 其他说明
    ,curr_cd -- 币种代码
    ,trust_broker_name -- 托管券商名称
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.asset_id -- 资产编号
    ,o.lp_id -- 法人编号
    ,o.stock_cd -- 股票代码
    ,o.stock_name -- 股票名称
    ,o.corp_name -- 公司名称
    ,o.issuer_brwer_flg -- 发行人为借款人标志
    ,o.corp_prev_year_margin -- 公司上年度利润
    ,o.stock_nomal_flg -- 股票正常标志
    ,o.stock_status_cd -- 股票状态代码
    ,o.tran_site_cd -- 交易场所代码
    ,o.public_tran_flg -- 公开交易标志
    ,o.hold_shares_qtty -- 持股数量
    ,o.inpwn_stock_qtty -- 质押股权数量
    ,o.mk_pri -- 市价
    ,o.last_year_share_divd_amt -- 上年每股分红金额
    ,o.warning_line -- 警戒线
    ,o.per_share_net_asset -- 每股净资产
    ,o.close_pos_line -- 平仓线
    ,o.inpwn_tot_val -- 质押总价值
    ,o.restr_exp_dt -- 限售到期日期
    ,o.other_comnt -- 其他说明
    ,o.curr_cd -- 币种代码
    ,o.trust_broker_name -- 托管券商名称
    ,o.start_dt -- 开始时间
    ,case when n.start_dt is not null then to_date('${batch_date}', 'yyyymmdd')
          when o.end_dt >= to_date('${batch_date}','yyyymmdd') then to_date('20991231','yyyymmdd')
          else o.end_dt
     end as end_dt -- 结束时间
    ,o.id_mark -- 增删标志
    ,o.src_table_name -- 源表名称
    ,o.job_cd -- 任务编码
    ,o.etl_timestamp -- ETL处理时间戳
from ${iml_schema}.ast_col_list_stock_inpwn_info_mimsf1_bk o
    left join ${iml_schema}.ast_col_list_stock_inpwn_info_mimsf1_op n
        on
            o.asset_id = n.asset_id
            and o.lp_id = n.lp_id
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iml_schema}.ast_col_list_stock_inpwn_info_mimsf1_cl d
        on
            o.asset_id = d.asset_id
            and o.lp_id = d.lp_id
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
--truncate table ${iml_schema}.ast_col_list_stock_inpwn_info;
alter table ${iml_schema}.ast_col_list_stock_inpwn_info truncate partition for ('mimsf1') reuse storage;

-- 4.2 exchange partition
alter table ${iml_schema}.ast_col_list_stock_inpwn_info exchange subpartition p_mimsf1_19000101 with table ${iml_schema}.ast_col_list_stock_inpwn_info_mimsf1_cl;
alter table ${iml_schema}.ast_col_list_stock_inpwn_info exchange subpartition p_mimsf1_20991231 with table ${iml_schema}.ast_col_list_stock_inpwn_info_mimsf1_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iml_schema}.ast_col_list_stock_inpwn_info to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iml_schema}.ast_col_list_stock_inpwn_info_mimsf1_tm purge;
drop table ${iml_schema}.ast_col_list_stock_inpwn_info_mimsf1_op purge;
drop table ${iml_schema}.ast_col_list_stock_inpwn_info_mimsf1_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iml_schema}.ast_col_list_stock_inpwn_info_mimsf1_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iml_schema}',tabname => 'ast_col_list_stock_inpwn_info', partname => 'p_mimsf1_20991231', granularity => 'SUBPARTITION', degree => 8, cascade => true);
