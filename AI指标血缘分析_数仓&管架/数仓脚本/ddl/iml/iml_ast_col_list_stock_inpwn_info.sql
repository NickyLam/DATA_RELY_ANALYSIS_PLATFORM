/*
Purpose:    整合模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iml ast_col_list_stock_inpwn_info
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iml_schema}.ast_col_list_stock_inpwn_info
whenever sqlerror continue none;
drop table ${iml_schema}.ast_col_list_stock_inpwn_info purge;

whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.ast_col_list_stock_inpwn_info(
    asset_id varchar2(100) -- 资产编号
    ,lp_id varchar2(60) -- 法人编号
    ,stock_cd varchar2(250) -- 股票代码
    ,stock_name varchar2(750) -- 股票名称
    ,corp_name varchar2(750) -- 公司名称
    ,issuer_brwer_flg varchar2(10) -- 发行人为借款人标志
    ,corp_prev_year_margin number(30,8) -- 公司上年度利润
    ,stock_nomal_flg varchar2(10) -- 股票正常标志
    ,stock_status_cd varchar2(30) -- 股票状态代码
    ,tran_site_cd varchar2(30) -- 交易场所代码
    ,public_tran_flg varchar2(10) -- 公开交易标志
    ,hold_shares_qtty number(38) -- 持股数量
    ,inpwn_stock_qtty number(30,8) -- 质押股权数量
    ,mk_pri number(30,8) -- 市价
    ,last_year_share_divd_amt number(30,8) -- 上年每股分红金额
    ,warning_line number(30,8) -- 警戒线
    ,per_share_net_asset number(30,8) -- 每股净资产
    ,close_pos_line number(30,8) -- 平仓线
    ,etd_inpwn_flg varchar2(10) -- 场内质押标志
    ,inpwn_rgst_id varchar2(250) -- 质押登记编号
    ,inpwn_tot_val number(30,8) -- 质押总价值
    ,restr_exp_dt date -- 限售到期日期
    ,other_comnt varchar2(4000) -- 其他说明
    ,curr_cd varchar2(30) -- 币种代码
    ,trust_broker_name varchar2(750) -- 托管券商名称
    ,start_dt date -- 开始时间
    ,end_dt date -- 结束时间
    ,id_mark varchar2(10) -- 增删标志
    ,src_table_name varchar2(100) -- 源表名称
    ,job_cd varchar2(10) -- 任务编码
    ,etl_timestamp timestamp -- ETL处理时间戳
)
partition by list (job_cd)
subpartition by list (end_dt)
(
   partition p_default values ('default')
   (
         subpartition p_default_19000101 values (to_date('19000101','yyyymmdd'))
         ,subpartition p_default_20991231 values (to_date('20991231','yyyymmdd'))
   )
)
storage (initial 1024k next 1024k)
compress ${option_switch} for query high
nologging
;

-- grant
grant select on ${iml_schema}.ast_col_list_stock_inpwn_info to ${icl_schema};
grant select on ${iml_schema}.ast_col_list_stock_inpwn_info to ${idl_schema};
grant select on ${iml_schema}.ast_col_list_stock_inpwn_info to ${iel_schema};

-- comment
comment on table ${iml_schema}.ast_col_list_stock_inpwn_info is '押品上市公司股权质押信息';
comment on column ${iml_schema}.ast_col_list_stock_inpwn_info.asset_id is '资产编号';
comment on column ${iml_schema}.ast_col_list_stock_inpwn_info.lp_id is '法人编号';
comment on column ${iml_schema}.ast_col_list_stock_inpwn_info.stock_cd is '股票代码';
comment on column ${iml_schema}.ast_col_list_stock_inpwn_info.stock_name is '股票名称';
comment on column ${iml_schema}.ast_col_list_stock_inpwn_info.corp_name is '公司名称';
comment on column ${iml_schema}.ast_col_list_stock_inpwn_info.issuer_brwer_flg is '发行人为借款人标志';
comment on column ${iml_schema}.ast_col_list_stock_inpwn_info.corp_prev_year_margin is '公司上年度利润';
comment on column ${iml_schema}.ast_col_list_stock_inpwn_info.stock_nomal_flg is '股票正常标志';
comment on column ${iml_schema}.ast_col_list_stock_inpwn_info.stock_status_cd is '股票状态代码';
comment on column ${iml_schema}.ast_col_list_stock_inpwn_info.tran_site_cd is '交易场所代码';
comment on column ${iml_schema}.ast_col_list_stock_inpwn_info.public_tran_flg is '公开交易标志';
comment on column ${iml_schema}.ast_col_list_stock_inpwn_info.hold_shares_qtty is '持股数量';
comment on column ${iml_schema}.ast_col_list_stock_inpwn_info.inpwn_stock_qtty is '质押股权数量';
comment on column ${iml_schema}.ast_col_list_stock_inpwn_info.mk_pri is '市价';
comment on column ${iml_schema}.ast_col_list_stock_inpwn_info.last_year_share_divd_amt is '上年每股分红金额';
comment on column ${iml_schema}.ast_col_list_stock_inpwn_info.warning_line is '警戒线';
comment on column ${iml_schema}.ast_col_list_stock_inpwn_info.per_share_net_asset is '每股净资产';
comment on column ${iml_schema}.ast_col_list_stock_inpwn_info.close_pos_line is '平仓线';
comment on column ${iml_schema}.ast_col_list_stock_inpwn_info.etd_inpwn_flg is '场内质押标志';
comment on column ${iml_schema}.ast_col_list_stock_inpwn_info.inpwn_rgst_id is '质押登记编号';
comment on column ${iml_schema}.ast_col_list_stock_inpwn_info.inpwn_tot_val is '质押总价值';
comment on column ${iml_schema}.ast_col_list_stock_inpwn_info.restr_exp_dt is '限售到期日期';
comment on column ${iml_schema}.ast_col_list_stock_inpwn_info.other_comnt is '其他说明';
comment on column ${iml_schema}.ast_col_list_stock_inpwn_info.curr_cd is '币种代码';
comment on column ${iml_schema}.ast_col_list_stock_inpwn_info.trust_broker_name is '托管券商名称';
comment on column ${iml_schema}.ast_col_list_stock_inpwn_info.start_dt is '开始时间';
comment on column ${iml_schema}.ast_col_list_stock_inpwn_info.end_dt is '结束时间';
comment on column ${iml_schema}.ast_col_list_stock_inpwn_info.id_mark is '增删标志';
comment on column ${iml_schema}.ast_col_list_stock_inpwn_info.src_table_name is '源表名称';
comment on column ${iml_schema}.ast_col_list_stock_inpwn_info.job_cd is '任务编码';
comment on column ${iml_schema}.ast_col_list_stock_inpwn_info.etl_timestamp is 'ETL处理时间戳';
