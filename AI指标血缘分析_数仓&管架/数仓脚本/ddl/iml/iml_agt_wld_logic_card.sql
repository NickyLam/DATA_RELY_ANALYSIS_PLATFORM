/*
Purpose:    整合模型层-快照表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iml agt_wld_logic_card
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iml_schema}.agt_wld_logic_card
whenever sqlerror continue none;
drop table ${iml_schema}.agt_wld_logic_card purge;

whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.agt_wld_logic_card(
    vouch_id varchar2(60) -- 凭证编号
    ,lp_id varchar2(60) -- 法人编号
    ,card_no varchar2(60) -- 卡号
    ,acct_id varchar2(60) -- 账户编号
    ,cust_id varchar2(60) -- 客户编号
    ,loan_prod_id varchar2(60) -- 贷款产品编号
    ,appl_id varchar2(60) -- 申请编号
    ,logic_card_main_card_card_id varchar2(60) -- 逻辑卡主卡卡编号
    ,latest_med_card_id varchar2(60) -- 最新介质卡编号
    ,actvd_flg varchar2(10) -- 已激活标志
    ,pin_card_clos_acct_dt date -- 销卡销户日期
    ,card_valid_dt date -- 卡片有效日期
    ,fir_ucd_dt date -- 首次用卡日期
    ,optimit_lock_edit_num varchar2(60) -- 乐观锁版本号
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
grant select on ${iml_schema}.agt_wld_logic_card to ${icl_schema};
grant select on ${iml_schema}.agt_wld_logic_card to ${idl_schema};
grant select on ${iml_schema}.agt_wld_logic_card to ${iel_schema};

-- comment
comment on table ${iml_schema}.agt_wld_logic_card is '微粒贷逻辑卡';
comment on column ${iml_schema}.agt_wld_logic_card.vouch_id is '凭证编号';
comment on column ${iml_schema}.agt_wld_logic_card.lp_id is '法人编号';
comment on column ${iml_schema}.agt_wld_logic_card.card_no is '卡号';
comment on column ${iml_schema}.agt_wld_logic_card.acct_id is '账户编号';
comment on column ${iml_schema}.agt_wld_logic_card.cust_id is '客户编号';
comment on column ${iml_schema}.agt_wld_logic_card.loan_prod_id is '贷款产品编号';
comment on column ${iml_schema}.agt_wld_logic_card.appl_id is '申请编号';
comment on column ${iml_schema}.agt_wld_logic_card.logic_card_main_card_card_id is '逻辑卡主卡卡编号';
comment on column ${iml_schema}.agt_wld_logic_card.latest_med_card_id is '最新介质卡编号';
comment on column ${iml_schema}.agt_wld_logic_card.actvd_flg is '已激活标志';
comment on column ${iml_schema}.agt_wld_logic_card.pin_card_clos_acct_dt is '销卡销户日期';
comment on column ${iml_schema}.agt_wld_logic_card.card_valid_dt is '卡片有效日期';
comment on column ${iml_schema}.agt_wld_logic_card.fir_ucd_dt is '首次用卡日期';
comment on column ${iml_schema}.agt_wld_logic_card.optimit_lock_edit_num is '乐观锁版本号';
comment on column ${iml_schema}.agt_wld_logic_card.create_dt is '创建日期';
comment on column ${iml_schema}.agt_wld_logic_card.update_dt is '更新日期';
comment on column ${iml_schema}.agt_wld_logic_card.etl_dt is 'ETL处理日期';
comment on column ${iml_schema}.agt_wld_logic_card.id_mark is '增删标志';
comment on column ${iml_schema}.agt_wld_logic_card.src_table_name is '源表名称';
comment on column ${iml_schema}.agt_wld_logic_card.job_cd is '任务编码';
comment on column ${iml_schema}.agt_wld_logic_card.etl_timestamp is 'ETL处理时间戳';
