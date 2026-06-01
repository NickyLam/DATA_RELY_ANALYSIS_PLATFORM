/*
Purpose:    整合模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iml agt_seal_card_info_h
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iml_schema}.agt_seal_card_info_h
whenever sqlerror continue none;
drop table ${iml_schema}.agt_seal_card_info_h purge;

whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.agt_seal_card_info_h(
    vouch_id varchar2(100) -- 凭证编号
    ,lp_id varchar2(60) -- 法人编号
    ,sign_flow_num varchar2(100) -- 签约流水号
    ,seal_acct_sign_flow_num varchar2(100) -- 验印账户签约流水号
    ,seal_cnt number(30) -- 印鉴枚数
    ,start_use_dt date -- 启用日期
    ,wrtoff_dt date -- 注销日期
    ,seal_card_no varchar2(60) -- 印鉴卡号
    ,acct_id varchar2(100) -- 账户编号
    ,seal_card_status_cd varchar2(30) -- 印鉴卡状态代码
    ,start_dt date -- 开始时间
    ,end_dt date -- 结束时间
    ,id_mark varchar2(10) -- 增删标志
    ,src_table_name varchar2(100) -- 源表名称
    ,job_cd varchar2(10) -- 任务编码
    ,etl_timestamp timestamp -- ETL处理时间戳
)
partition by list (job_cd)
subpartition by range (end_dt)
(
   partition p_default values ('default')
   (
        subpartition p_default_19000101 values less than (to_date('20991231','yyyymmdd'))
        ,subpartition p_default_20991231 values less than (maxvalue)
   )
)
storage (initial 1024k next 1024k)
compress ${option_switch} for query high
nologging
;

-- grant
grant select on ${iml_schema}.agt_seal_card_info_h to ${icl_schema};
grant select on ${iml_schema}.agt_seal_card_info_h to ${idl_schema};
grant select on ${iml_schema}.agt_seal_card_info_h to ${iel_schema};

-- comment
comment on table ${iml_schema}.agt_seal_card_info_h is '印鉴卡信息历史';
comment on column ${iml_schema}.agt_seal_card_info_h.vouch_id is '凭证编号';
comment on column ${iml_schema}.agt_seal_card_info_h.lp_id is '法人编号';
comment on column ${iml_schema}.agt_seal_card_info_h.sign_flow_num is '签约流水号';
comment on column ${iml_schema}.agt_seal_card_info_h.seal_acct_sign_flow_num is '验印账户签约流水号';
comment on column ${iml_schema}.agt_seal_card_info_h.seal_cnt is '印鉴枚数';
comment on column ${iml_schema}.agt_seal_card_info_h.start_use_dt is '启用日期';
comment on column ${iml_schema}.agt_seal_card_info_h.wrtoff_dt is '注销日期';
comment on column ${iml_schema}.agt_seal_card_info_h.seal_card_no is '印鉴卡号';
comment on column ${iml_schema}.agt_seal_card_info_h.acct_id is '账户编号';
comment on column ${iml_schema}.agt_seal_card_info_h.seal_card_status_cd is '印鉴卡状态代码';
comment on column ${iml_schema}.agt_seal_card_info_h.start_dt is '开始时间';
comment on column ${iml_schema}.agt_seal_card_info_h.end_dt is '结束时间';
comment on column ${iml_schema}.agt_seal_card_info_h.id_mark is '增删标志';
comment on column ${iml_schema}.agt_seal_card_info_h.src_table_name is '源表名称';
comment on column ${iml_schema}.agt_seal_card_info_h.job_cd is '任务编码';
comment on column ${iml_schema}.agt_seal_card_info_h.etl_timestamp is 'ETL处理时间戳';
