/*
Purpose:    整合模型层-快照表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iml ast_col_fund_info
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iml_schema}.ast_col_fund_info
whenever sqlerror continue none;
drop table ${iml_schema}.ast_col_fund_info purge;

whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.ast_col_fund_info(
    asset_id varchar2(100) -- 资产编号
    ,lp_id varchar2(60) -- 法人编号
    ,fund_cd varchar2(100) -- 基金代码
    ,acct_id varchar2(100) -- 账户编号
    ,issuer_name varchar2(375) -- 发行人名称
    ,begin_dt date -- 起始日期
    ,closing_dt date -- 截止日期
    ,fund_name varchar2(375) -- 基金名称
    ,fund_type_cd varchar2(30) -- 基金类型代码
    ,brkevn_flg varchar2(10) -- 保本标志
    ,tranbl_flg varchar2(10) -- 可转让标志
    ,invest_underly_cd varchar2(100) -- 投资标的代码
    ,public_quot_flg varchar2(10) -- 公开报价标志
    ,inpwn_lot number(38) -- 质押份额
    ,corp_nv number(30,8) -- 单位净值
    ,inpwn_tot_val number(30,8) -- 质押总价值
    ,issuer_brwer_flg varchar2(10) -- 发行人为借款人标志
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
grant select on ${iml_schema}.ast_col_fund_info to ${icl_schema};
grant select on ${iml_schema}.ast_col_fund_info to ${idl_schema};
grant select on ${iml_schema}.ast_col_fund_info to ${iel_schema};

-- comment
comment on table ${iml_schema}.ast_col_fund_info is '押品基金信息';
comment on column ${iml_schema}.ast_col_fund_info.asset_id is '资产编号';
comment on column ${iml_schema}.ast_col_fund_info.lp_id is '法人编号';
comment on column ${iml_schema}.ast_col_fund_info.fund_cd is '基金代码';
comment on column ${iml_schema}.ast_col_fund_info.acct_id is '账户编号';
comment on column ${iml_schema}.ast_col_fund_info.issuer_name is '发行人名称';
comment on column ${iml_schema}.ast_col_fund_info.begin_dt is '起始日期';
comment on column ${iml_schema}.ast_col_fund_info.closing_dt is '截止日期';
comment on column ${iml_schema}.ast_col_fund_info.fund_name is '基金名称';
comment on column ${iml_schema}.ast_col_fund_info.fund_type_cd is '基金类型代码';
comment on column ${iml_schema}.ast_col_fund_info.brkevn_flg is '保本标志';
comment on column ${iml_schema}.ast_col_fund_info.tranbl_flg is '可转让标志';
comment on column ${iml_schema}.ast_col_fund_info.invest_underly_cd is '投资标的代码';
comment on column ${iml_schema}.ast_col_fund_info.public_quot_flg is '公开报价标志';
comment on column ${iml_schema}.ast_col_fund_info.inpwn_lot is '质押份额';
comment on column ${iml_schema}.ast_col_fund_info.corp_nv is '单位净值';
comment on column ${iml_schema}.ast_col_fund_info.inpwn_tot_val is '质押总价值';
comment on column ${iml_schema}.ast_col_fund_info.issuer_brwer_flg is '发行人为借款人标志';
comment on column ${iml_schema}.ast_col_fund_info.descb is '描述';
comment on column ${iml_schema}.ast_col_fund_info.curr_cd is '币种代码';
comment on column ${iml_schema}.ast_col_fund_info.create_dt is '创建日期';
comment on column ${iml_schema}.ast_col_fund_info.update_dt is '更新日期';
comment on column ${iml_schema}.ast_col_fund_info.etl_dt is 'ETL处理日期';
comment on column ${iml_schema}.ast_col_fund_info.id_mark is '增删标志';
comment on column ${iml_schema}.ast_col_fund_info.src_table_name is '源表名称';
comment on column ${iml_schema}.ast_col_fund_info.job_cd is '任务编码';
comment on column ${iml_schema}.ast_col_fund_info.etl_timestamp is 'ETL处理时间戳';
