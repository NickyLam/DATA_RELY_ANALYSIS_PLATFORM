/*
Purpose:    整合模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iml agt_wl_acct
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iml_schema}.agt_wl_acct
whenever sqlerror continue none;
drop table ${iml_schema}.agt_wl_acct purge;

whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.agt_wl_acct(
    acct_id varchar2(60) -- 账户编号
    ,lp_id varchar2(60) -- 法人编号
    ,acct_name varchar2(250) -- 账户名称
    ,acct_type_cd varchar2(30) -- 账户类型代码
    ,cap_acct_id varchar2(60) -- 资金账户编号
    ,open_bank_name varchar2(500) -- 开户行名称
    ,open_bank_num varchar2(60) -- 开户行号
    ,open_acct_name varchar2(250) -- 开户名称
    ,acct_status_cd varchar2(30) -- 账户状态代码
    ,teller_id varchar2(60) -- 柜员编号
    ,asset_acct_type_cd varchar2(30) -- 资产账户类型代码
    ,bd_card_no varchar2(60) -- 绑定卡卡号
    ,bind_mobile_no varchar2(60) -- 绑定手机号码
    ,pbc_fin_inst_code varchar2(60) -- 人行金融机构编码
    ,obank_card_flg varchar2(30) -- 他行卡标志
    ,cust_id varchar2(60) -- 客户编号
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
grant select on ${iml_schema}.agt_wl_acct to ${icl_schema};
grant select on ${iml_schema}.agt_wl_acct to ${idl_schema};
grant select on ${iml_schema}.agt_wl_acct to ${iel_schema};

-- comment
comment on table ${iml_schema}.agt_wl_acct is '网贷账户';
comment on column ${iml_schema}.agt_wl_acct.acct_id is '账户编号';
comment on column ${iml_schema}.agt_wl_acct.lp_id is '法人编号';
comment on column ${iml_schema}.agt_wl_acct.acct_name is '账户名称';
comment on column ${iml_schema}.agt_wl_acct.acct_type_cd is '账户类型代码';
comment on column ${iml_schema}.agt_wl_acct.cap_acct_id is '资金账户编号';
comment on column ${iml_schema}.agt_wl_acct.open_bank_name is '开户行名称';
comment on column ${iml_schema}.agt_wl_acct.open_bank_num is '开户行号';
comment on column ${iml_schema}.agt_wl_acct.open_acct_name is '开户名称';
comment on column ${iml_schema}.agt_wl_acct.acct_status_cd is '账户状态代码';
comment on column ${iml_schema}.agt_wl_acct.teller_id is '柜员编号';
comment on column ${iml_schema}.agt_wl_acct.asset_acct_type_cd is '资产账户类型代码';
comment on column ${iml_schema}.agt_wl_acct.bd_card_no is '绑定卡卡号';
comment on column ${iml_schema}.agt_wl_acct.bind_mobile_no is '绑定手机号码';
comment on column ${iml_schema}.agt_wl_acct.pbc_fin_inst_code is '人行金融机构编码';
comment on column ${iml_schema}.agt_wl_acct.obank_card_flg is '他行卡标志';
comment on column ${iml_schema}.agt_wl_acct.cust_id is '客户编号';
comment on column ${iml_schema}.agt_wl_acct.start_dt is '开始时间';
comment on column ${iml_schema}.agt_wl_acct.end_dt is '结束时间';
comment on column ${iml_schema}.agt_wl_acct.id_mark is '增删标志';
comment on column ${iml_schema}.agt_wl_acct.src_table_name is '源表名称';
comment on column ${iml_schema}.agt_wl_acct.job_cd is '任务编码';
comment on column ${iml_schema}.agt_wl_acct.etl_timestamp is 'ETL处理时间戳';
