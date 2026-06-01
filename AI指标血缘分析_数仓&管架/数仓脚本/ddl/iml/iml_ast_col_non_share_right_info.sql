/*
Purpose:    整合模型层-快照表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iml ast_col_non_share_right_info
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iml_schema}.ast_col_non_share_right_info
whenever sqlerror continue none;
drop table ${iml_schema}.ast_col_non_share_right_info purge;

whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.ast_col_non_share_right_info(
    asset_id varchar2(100) -- 资产编号
    ,lp_id varchar2(60) -- 法人编号
    ,pledge_share_corp_name varchar2(375) -- 出质股权公司名称
    ,pledge_share_local_corp_cd varchar2(100) -- 出质股权所在公司代码
    ,issuer_brwer_flg varchar2(10) -- 发行人为借款人标志
    ,hold_shares_qtty number(38) -- 持股数量
    ,pledge_right_tot_right_ratio number(30,8) -- 出质股权所占总股权比例
    ,pledge_right_cnt number(30,8) -- 出质股权数
    ,per_share_mk_pri number(30,8) -- 每股市价
    ,prev_share_divd_amt number(30,8) -- 上年度每股分红金额
    ,per_share_idtfy_val number(30,8) -- 每股认定价值
    ,inpwn_tot_val number(38,8) -- 质押总价值
    ,per_share_net_asset number(30,8) -- 每股净资产
    ,warning_line number(30,8) -- 警戒线
    ,close_pos_line number(30,8) -- 平仓线
    ,net_asset_tot number(30,8) -- 净资产总额
    ,descb varchar2(4000) -- 描述
    ,curr_cd varchar2(30) -- 币种代码
    ,create_dt date -- 创建日期
    ,update_dt date -- 更新日期
    ,etl_dt date -- ETL处理日期
    ,id_mark varchar2(10) -- 增删标志
    ,src_table_name varchar2(100) -- 源表名称
    ,job_cd varchar2(10) -- 任务编码
    ,etl_timestamp timestamp -- ETL处理时间戳
)
partition by list (job_cd)
subpartition by list (etl_dt)
(
   partition p_default values ('default')
   (
        subpartition p_default_19000101 values (to_date('19000101','yyyymmdd'))
   )
)
storage (initial 1024k next 1024k)
compress ${option_switch} for query high
nologging
;

-- grant
grant select on ${iml_schema}.ast_col_non_share_right_info to ${icl_schema};
grant select on ${iml_schema}.ast_col_non_share_right_info to ${idl_schema};
grant select on ${iml_schema}.ast_col_non_share_right_info to ${iel_schema};

-- comment
comment on table ${iml_schema}.ast_col_non_share_right_info is '押品非上市股权信息';
comment on column ${iml_schema}.ast_col_non_share_right_info.asset_id is '资产编号';
comment on column ${iml_schema}.ast_col_non_share_right_info.lp_id is '法人编号';
comment on column ${iml_schema}.ast_col_non_share_right_info.pledge_share_corp_name is '出质股权公司名称';
comment on column ${iml_schema}.ast_col_non_share_right_info.pledge_share_local_corp_cd is '出质股权所在公司代码';
comment on column ${iml_schema}.ast_col_non_share_right_info.issuer_brwer_flg is '发行人为借款人标志';
comment on column ${iml_schema}.ast_col_non_share_right_info.hold_shares_qtty is '持股数量';
comment on column ${iml_schema}.ast_col_non_share_right_info.pledge_right_tot_right_ratio is '出质股权所占总股权比例';
comment on column ${iml_schema}.ast_col_non_share_right_info.pledge_right_cnt is '出质股权数';
comment on column ${iml_schema}.ast_col_non_share_right_info.per_share_mk_pri is '每股市价';
comment on column ${iml_schema}.ast_col_non_share_right_info.prev_share_divd_amt is '上年度每股分红金额';
comment on column ${iml_schema}.ast_col_non_share_right_info.per_share_idtfy_val is '每股认定价值';
comment on column ${iml_schema}.ast_col_non_share_right_info.inpwn_tot_val is '质押总价值';
comment on column ${iml_schema}.ast_col_non_share_right_info.per_share_net_asset is '每股净资产';
comment on column ${iml_schema}.ast_col_non_share_right_info.warning_line is '警戒线';
comment on column ${iml_schema}.ast_col_non_share_right_info.close_pos_line is '平仓线';
comment on column ${iml_schema}.ast_col_non_share_right_info.net_asset_tot is '净资产总额';
comment on column ${iml_schema}.ast_col_non_share_right_info.descb is '描述';
comment on column ${iml_schema}.ast_col_non_share_right_info.curr_cd is '币种代码';
comment on column ${iml_schema}.ast_col_non_share_right_info.create_dt is '创建日期';
comment on column ${iml_schema}.ast_col_non_share_right_info.update_dt is '更新日期';
comment on column ${iml_schema}.ast_col_non_share_right_info.etl_dt is 'ETL处理日期';
comment on column ${iml_schema}.ast_col_non_share_right_info.id_mark is '增删标志';
comment on column ${iml_schema}.ast_col_non_share_right_info.src_table_name is '源表名称';
comment on column ${iml_schema}.ast_col_non_share_right_info.job_cd is '任务编码';
comment on column ${iml_schema}.ast_col_non_share_right_info.etl_timestamp is 'ETL处理时间戳';
