/*
Purpose:    整合模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iml agt_dep_acct_cotas_info_h
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iml_schema}.agt_dep_acct_cotas_info_h
whenever sqlerror continue none;
drop table ${iml_schema}.agt_dep_acct_cotas_info_h purge;

whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.agt_dep_acct_cotas_info_h(
    agt_id varchar2(250) -- 协议编号
    ,lp_id varchar2(100) -- 法人编号
    ,acct_id varchar2(100) -- 账户编号
    ,cotas_tel_num_one varchar2(60) -- 联系人电话号码一
    ,cotas_type_id varchar2(100) -- 联系人类型编号
    ,cotas_type_descb varchar2(500) -- 联系人类型描述
    ,cust_id varchar2(100) -- 客户编号
    ,cotas_cls_cd varchar2(30) -- 联系人分类代码
    ,cotas_cert_no varchar2(60) -- 联系人证件号码
    ,cotas_cert_type_cd varchar2(30) -- 联系人证件类型代码
    ,cotas_name varchar2(500) -- 联系人名称
    ,cotas_tel_num_two varchar2(60) -- 联系人电话号码二
    ,data_valid_flg varchar2(10) -- 数据有效标志
    ,checker_seq_num varchar2(60) -- 查证人序号
    ,spec_cap_checker_flg varchar2(10) -- 指定资金查证人标志
    ,final_modif_dt date -- 最后修改日期
    ,final_modif_teller_id varchar2(100) -- 最后修改柜员编号
    ,tran_tm timestamp -- 交易时间
    ,cotas_type_cd varchar2(30) -- 联系人类型代码
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
grant select on ${iml_schema}.agt_dep_acct_cotas_info_h to ${icl_schema};
grant select on ${iml_schema}.agt_dep_acct_cotas_info_h to ${idl_schema};
grant select on ${iml_schema}.agt_dep_acct_cotas_info_h to ${iel_schema};

-- comment
comment on table ${iml_schema}.agt_dep_acct_cotas_info_h is '存款账户联系人信息历史';
comment on column ${iml_schema}.agt_dep_acct_cotas_info_h.agt_id is '协议编号';
comment on column ${iml_schema}.agt_dep_acct_cotas_info_h.lp_id is '法人编号';
comment on column ${iml_schema}.agt_dep_acct_cotas_info_h.acct_id is '账户编号';
comment on column ${iml_schema}.agt_dep_acct_cotas_info_h.cotas_tel_num_one is '联系人电话号码一';
comment on column ${iml_schema}.agt_dep_acct_cotas_info_h.cotas_type_id is '联系人类型编号';
comment on column ${iml_schema}.agt_dep_acct_cotas_info_h.cotas_type_descb is '联系人类型描述';
comment on column ${iml_schema}.agt_dep_acct_cotas_info_h.cust_id is '客户编号';
comment on column ${iml_schema}.agt_dep_acct_cotas_info_h.cotas_cls_cd is '联系人分类代码';
comment on column ${iml_schema}.agt_dep_acct_cotas_info_h.cotas_cert_no is '联系人证件号码';
comment on column ${iml_schema}.agt_dep_acct_cotas_info_h.cotas_cert_type_cd is '联系人证件类型代码';
comment on column ${iml_schema}.agt_dep_acct_cotas_info_h.cotas_name is '联系人名称';
comment on column ${iml_schema}.agt_dep_acct_cotas_info_h.cotas_tel_num_two is '联系人电话号码二';
comment on column ${iml_schema}.agt_dep_acct_cotas_info_h.data_valid_flg is '数据有效标志';
comment on column ${iml_schema}.agt_dep_acct_cotas_info_h.checker_seq_num is '查证人序号';
comment on column ${iml_schema}.agt_dep_acct_cotas_info_h.spec_cap_checker_flg is '指定资金查证人标志';
comment on column ${iml_schema}.agt_dep_acct_cotas_info_h.final_modif_dt is '最后修改日期';
comment on column ${iml_schema}.agt_dep_acct_cotas_info_h.final_modif_teller_id is '最后修改柜员编号';
comment on column ${iml_schema}.agt_dep_acct_cotas_info_h.tran_tm is '交易时间';
comment on column ${iml_schema}.agt_dep_acct_cotas_info_h.cotas_type_cd is '联系人类型代码';
comment on column ${iml_schema}.agt_dep_acct_cotas_info_h.start_dt is '开始时间';
comment on column ${iml_schema}.agt_dep_acct_cotas_info_h.end_dt is '结束时间';
comment on column ${iml_schema}.agt_dep_acct_cotas_info_h.id_mark is '增删标志';
comment on column ${iml_schema}.agt_dep_acct_cotas_info_h.src_table_name is '源表名称';
comment on column ${iml_schema}.agt_dep_acct_cotas_info_h.job_cd is '任务编码';
comment on column ${iml_schema}.agt_dep_acct_cotas_info_h.etl_timestamp is 'ETL处理时间戳';
