/*
Purpose:    整合模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iml prd_inpwn_vch_pledge_type_repo
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iml_schema}.prd_inpwn_vch_pledge_type_repo
whenever sqlerror continue none;
drop table ${iml_schema}.prd_inpwn_vch_pledge_type_repo purge;

whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.prd_inpwn_vch_pledge_type_repo(
    lp_id varchar2(60) -- 法人编号
    ,fin_instm_id varchar2(60) -- 金融工具编号
    ,asset_type_id varchar2(60) -- 资产类型编号
    ,market_type_id varchar2(60) -- 市场类型编号
    ,inpwn_vch_fin_instm_id varchar2(60) -- 质押券金融工具编号
    ,inpwn_vch_asset_type_id varchar2(60) -- 质押券资产类型编号
    ,inpwn_vch_market_type_id varchar2(60) -- 质押券市场类型编号
    ,inpwn_cert_face_lmt number(30,8) -- 质押券面额
    ,discnt_rat number(30,8) -- 折价率
    ,discnt_amt number(30,8) -- 折价金额
    ,int_ext_tran_flg varchar2(30) -- 内外部交易标志
    ,inpwn_vch_guar_type_cd varchar2(30) -- 质押券担保类型代码
    ,cbond_evltion number(30,8) -- 中债估值
    ,bal_qtty_chg number(38,8) -- 余额数量变动
    ,intnal_secu_acct_id varchar2(60) -- 内部证券账户编号
    ,ext_secu_acct_id varchar2(60) -- 外部证券账户编号
    ,tran_seq_num varchar2(60) -- 交易单序号
    ,etl_dt date -- ETL处理日期
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
grant select on ${iml_schema}.prd_inpwn_vch_pledge_type_repo to ${icl_schema};
grant select on ${iml_schema}.prd_inpwn_vch_pledge_type_repo to ${idl_schema};
grant select on ${iml_schema}.prd_inpwn_vch_pledge_type_repo to ${iel_schema};

-- comment
comment on table ${iml_schema}.prd_inpwn_vch_pledge_type_repo is '质押券质押式回购';
comment on column ${iml_schema}.prd_inpwn_vch_pledge_type_repo.lp_id is '法人编号';
comment on column ${iml_schema}.prd_inpwn_vch_pledge_type_repo.fin_instm_id is '金融工具编号';
comment on column ${iml_schema}.prd_inpwn_vch_pledge_type_repo.asset_type_id is '资产类型编号';
comment on column ${iml_schema}.prd_inpwn_vch_pledge_type_repo.market_type_id is '市场类型编号';
comment on column ${iml_schema}.prd_inpwn_vch_pledge_type_repo.inpwn_vch_fin_instm_id is '质押券金融工具编号';
comment on column ${iml_schema}.prd_inpwn_vch_pledge_type_repo.inpwn_vch_asset_type_id is '质押券资产类型编号';
comment on column ${iml_schema}.prd_inpwn_vch_pledge_type_repo.inpwn_vch_market_type_id is '质押券市场类型编号';
comment on column ${iml_schema}.prd_inpwn_vch_pledge_type_repo.inpwn_cert_face_lmt is '质押券面额';
comment on column ${iml_schema}.prd_inpwn_vch_pledge_type_repo.discnt_rat is '折价率';
comment on column ${iml_schema}.prd_inpwn_vch_pledge_type_repo.discnt_amt is '折价金额';
comment on column ${iml_schema}.prd_inpwn_vch_pledge_type_repo.int_ext_tran_flg is '内外部交易标志';
comment on column ${iml_schema}.prd_inpwn_vch_pledge_type_repo.inpwn_vch_guar_type_cd is '质押券担保类型代码';
comment on column ${iml_schema}.prd_inpwn_vch_pledge_type_repo.cbond_evltion is '中债估值';
comment on column ${iml_schema}.prd_inpwn_vch_pledge_type_repo.bal_qtty_chg is '余额数量变动';
comment on column ${iml_schema}.prd_inpwn_vch_pledge_type_repo.intnal_secu_acct_id is '内部证券账户编号';
comment on column ${iml_schema}.prd_inpwn_vch_pledge_type_repo.ext_secu_acct_id is '外部证券账户编号';
comment on column ${iml_schema}.prd_inpwn_vch_pledge_type_repo.tran_seq_num is '交易单序号';
comment on column ${iml_schema}.prd_inpwn_vch_pledge_type_repo.etl_dt is 'ETL处理日期';
comment on column ${iml_schema}.prd_inpwn_vch_pledge_type_repo.src_table_name is '源表名称';
comment on column ${iml_schema}.prd_inpwn_vch_pledge_type_repo.job_cd is '任务编码';
comment on column ${iml_schema}.prd_inpwn_vch_pledge_type_repo.etl_timestamp is 'ETL处理时间戳';
