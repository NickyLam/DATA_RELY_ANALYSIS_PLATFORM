/*
Purpose:    整合模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iml agt_corp_stl_card_card_holder_h
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iml_schema}.agt_corp_stl_card_card_holder_h
whenever sqlerror continue none;
drop table ${iml_schema}.agt_corp_stl_card_card_holder_h purge;

whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.agt_corp_stl_card_card_holder_h(
    vouch_id varchar2(250) -- 凭证编号
    ,card_no varchar2(60) -- 卡号
    ,lp_id varchar2(100) -- 法人编号
    ,main_card_flg varchar2(10) -- 主卡标志
    ,main_card_card_no varchar2(60) -- 主卡卡号
    ,cust_id varchar2(100) -- 客户编号
    ,cert_no varchar2(60) -- 证件号码
    ,cert_type_cd varchar2(30) -- 证件类型代码
    ,cust_cn_name varchar2(500) -- 客户中文名称
    ,tel_num varchar2(60) -- 电话号码
    ,tran_dt date -- 交易日期
    ,core_tran_org_id varchar2(100) -- 核心交易机构编号
    ,tran_teller_id varchar2(60) -- 交易柜员编号
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
grant select on ${iml_schema}.agt_corp_stl_card_card_holder_h to ${icl_schema};
grant select on ${iml_schema}.agt_corp_stl_card_card_holder_h to ${idl_schema};
grant select on ${iml_schema}.agt_corp_stl_card_card_holder_h to ${iel_schema};

-- comment
comment on table ${iml_schema}.agt_corp_stl_card_card_holder_h is '单位结算卡持卡人历史';
comment on column ${iml_schema}.agt_corp_stl_card_card_holder_h.vouch_id is '凭证编号';
comment on column ${iml_schema}.agt_corp_stl_card_card_holder_h.card_no is '卡号';
comment on column ${iml_schema}.agt_corp_stl_card_card_holder_h.lp_id is '法人编号';
comment on column ${iml_schema}.agt_corp_stl_card_card_holder_h.main_card_flg is '主卡标志';
comment on column ${iml_schema}.agt_corp_stl_card_card_holder_h.main_card_card_no is '主卡卡号';
comment on column ${iml_schema}.agt_corp_stl_card_card_holder_h.cust_id is '客户编号';
comment on column ${iml_schema}.agt_corp_stl_card_card_holder_h.cert_no is '证件号码';
comment on column ${iml_schema}.agt_corp_stl_card_card_holder_h.cert_type_cd is '证件类型代码';
comment on column ${iml_schema}.agt_corp_stl_card_card_holder_h.cust_cn_name is '客户中文名称';
comment on column ${iml_schema}.agt_corp_stl_card_card_holder_h.tel_num is '电话号码';
comment on column ${iml_schema}.agt_corp_stl_card_card_holder_h.tran_dt is '交易日期';
comment on column ${iml_schema}.agt_corp_stl_card_card_holder_h.core_tran_org_id is '核心交易机构编号';
comment on column ${iml_schema}.agt_corp_stl_card_card_holder_h.tran_teller_id is '交易柜员编号';
comment on column ${iml_schema}.agt_corp_stl_card_card_holder_h.start_dt is '开始时间';
comment on column ${iml_schema}.agt_corp_stl_card_card_holder_h.end_dt is '结束时间';
comment on column ${iml_schema}.agt_corp_stl_card_card_holder_h.id_mark is '增删标志';
comment on column ${iml_schema}.agt_corp_stl_card_card_holder_h.src_table_name is '源表名称';
comment on column ${iml_schema}.agt_corp_stl_card_card_holder_h.job_cd is '任务编码';
comment on column ${iml_schema}.agt_corp_stl_card_card_holder_h.etl_timestamp is 'ETL处理时间戳';
