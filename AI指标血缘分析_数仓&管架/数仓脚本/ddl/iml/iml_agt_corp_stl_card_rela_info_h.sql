/*
Purpose:    整合模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iml agt_corp_stl_card_rela_info_h
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iml_schema}.agt_corp_stl_card_rela_info_h
whenever sqlerror continue none;
drop table ${iml_schema}.agt_corp_stl_card_rela_info_h purge;

whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.agt_corp_stl_card_rela_info_h(
    vouch_id varchar2(250) -- 凭证编号
    ,card_no varchar2(60) -- 卡号
    ,acct_num_sub_acct_num varchar2(60) -- 账号子账号
    ,cust_acct_num varchar2(60) -- 客户账号
    ,acct_prod_id varchar2(100) -- 账户产品编号
    ,lp_id varchar2(100) -- 法人编号
    ,card_prod_id varchar2(100) -- 卡产品编号
    ,acct_curr_cd varchar2(30) -- 账户币种代码
    ,cust_id varchar2(100) -- 客户编号
    ,deflt_acct_num_flg varchar2(10) -- 默认账号标志
    ,main_card_flg varchar2(10) -- 主卡标志
    ,main_card_card_no varchar2(60) -- 主卡卡号
    ,general_exch_flg varchar2(10) -- 通兑标志
    ,auto_coll_seq_type_cd varchar2(30) -- 自动归集顺序类型代码
    ,coll_seq_num varchar2(60) -- 归集顺序号
    ,linkg_deduct_flg varchar2(10) -- 联动扣款标志
    ,card_stop_use_flg varchar2(10) -- 卡停用标志
    ,in_card_interturn_flg varchar2(10) -- 卡内互转标志
    ,dep_flg varchar2(10) -- 可存款标志
    ,tranbl_flg varchar2(10) -- 可转出标志
    ,cash_flg varchar2(10) -- 可取现标志
    ,inco_decide_expns_flg varchar2(10) -- 以收定支标志
    ,tran_dt date -- 交易日期
    ,tran_timestamp date -- 交易时间
    ,tran_org_id varchar2(100) -- 交易机构编号
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
grant select on ${iml_schema}.agt_corp_stl_card_rela_info_h to ${icl_schema};
grant select on ${iml_schema}.agt_corp_stl_card_rela_info_h to ${idl_schema};
grant select on ${iml_schema}.agt_corp_stl_card_rela_info_h to ${iel_schema};

-- comment
comment on table ${iml_schema}.agt_corp_stl_card_rela_info_h is '单位结算卡关联信息历史';
comment on column ${iml_schema}.agt_corp_stl_card_rela_info_h.vouch_id is '凭证编号';
comment on column ${iml_schema}.agt_corp_stl_card_rela_info_h.card_no is '卡号';
comment on column ${iml_schema}.agt_corp_stl_card_rela_info_h.acct_num_sub_acct_num is '账号子账号';
comment on column ${iml_schema}.agt_corp_stl_card_rela_info_h.cust_acct_num is '客户账号';
comment on column ${iml_schema}.agt_corp_stl_card_rela_info_h.acct_prod_id is '账户产品编号';
comment on column ${iml_schema}.agt_corp_stl_card_rela_info_h.lp_id is '法人编号';
comment on column ${iml_schema}.agt_corp_stl_card_rela_info_h.card_prod_id is '卡产品编号';
comment on column ${iml_schema}.agt_corp_stl_card_rela_info_h.acct_curr_cd is '账户币种代码';
comment on column ${iml_schema}.agt_corp_stl_card_rela_info_h.cust_id is '客户编号';
comment on column ${iml_schema}.agt_corp_stl_card_rela_info_h.deflt_acct_num_flg is '默认账号标志';
comment on column ${iml_schema}.agt_corp_stl_card_rela_info_h.main_card_flg is '主卡标志';
comment on column ${iml_schema}.agt_corp_stl_card_rela_info_h.main_card_card_no is '主卡卡号';
comment on column ${iml_schema}.agt_corp_stl_card_rela_info_h.general_exch_flg is '通兑标志';
comment on column ${iml_schema}.agt_corp_stl_card_rela_info_h.auto_coll_seq_type_cd is '自动归集顺序类型代码';
comment on column ${iml_schema}.agt_corp_stl_card_rela_info_h.coll_seq_num is '归集顺序号';
comment on column ${iml_schema}.agt_corp_stl_card_rela_info_h.linkg_deduct_flg is '联动扣款标志';
comment on column ${iml_schema}.agt_corp_stl_card_rela_info_h.card_stop_use_flg is '卡停用标志';
comment on column ${iml_schema}.agt_corp_stl_card_rela_info_h.in_card_interturn_flg is '卡内互转标志';
comment on column ${iml_schema}.agt_corp_stl_card_rela_info_h.dep_flg is '可存款标志';
comment on column ${iml_schema}.agt_corp_stl_card_rela_info_h.tranbl_flg is '可转出标志';
comment on column ${iml_schema}.agt_corp_stl_card_rela_info_h.cash_flg is '可取现标志';
comment on column ${iml_schema}.agt_corp_stl_card_rela_info_h.inco_decide_expns_flg is '以收定支标志';
comment on column ${iml_schema}.agt_corp_stl_card_rela_info_h.tran_dt is '交易日期';
comment on column ${iml_schema}.agt_corp_stl_card_rela_info_h.tran_timestamp is '交易时间';
comment on column ${iml_schema}.agt_corp_stl_card_rela_info_h.tran_org_id is '交易机构编号';
comment on column ${iml_schema}.agt_corp_stl_card_rela_info_h.start_dt is '开始时间';
comment on column ${iml_schema}.agt_corp_stl_card_rela_info_h.end_dt is '结束时间';
comment on column ${iml_schema}.agt_corp_stl_card_rela_info_h.id_mark is '增删标志';
comment on column ${iml_schema}.agt_corp_stl_card_rela_info_h.src_table_name is '源表名称';
comment on column ${iml_schema}.agt_corp_stl_card_rela_info_h.job_cd is '任务编码';
comment on column ${iml_schema}.agt_corp_stl_card_rela_info_h.etl_timestamp is 'ETL处理时间戳';
